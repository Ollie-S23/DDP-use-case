<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];
$input  = json_decode(file_get_contents('php://input'), true);

// ── SQLite file-based database (no server required) ───────────────────────────
$dbPath  = __DIR__ . '/src/database/ddp_v5.sqlite';
$sqlPath = __DIR__ . '/src/database/ddp_v5.sql';
$db = getDb($dbPath, $sqlPath);

// ── Named-query route (?query=<name>) ─────────────────────────────────────────
$queryName = isset($_GET['query']) ? preg_replace('/[^a-z0-9_]+/i', '', $_GET['query']) : null;

if ($queryName && $method === 'GET') {
    header('Content-Type: application/json');
    handleNamedQuery($db, $queryName);
    exit();
}

// ── Generic single-table CRUD route (?table=<name>) ──────────────────────────
$allowed_tables = [
    'round_def', 'archer_details', 'division', 'comp',
    'categories', 'age_class', 'staging_table', 'staging_end', 'staging_arrow',
    'equivalent_rounds', 'range_def'
];

$table = preg_replace('/[^a-z0-9_]+/i', '', isset($_GET['table']) ? $_GET['table'] : '');

if (!in_array($table, $allowed_tables)) {
    http_response_code(400);
    echo 'ERROR: Invalid or missing table';
    exit();
}

$fld = preg_replace('/[^a-z0-9_]+/i', '', isset($_GET['fld']) ? $_GET['fld'] : '');
$key = isset($_GET['key']) ? $_GET['key'] : null;

$columns = [];
$values  = [];
if (isset($input) && is_array($input)) {
    $columns = array_map(fn($col) => preg_replace('/[^a-z0-9_]+/i', '', $col), array_keys($input));
    $values  = array_values($input);
}

$where = ($fld && $key !== null)
    ? " WHERE `$fld`=" . $db->quote($key)
    : '';

switch ($method) {
    case 'GET':
        $sql = "SELECT * FROM `$table`$where";
        break;

    case 'DELETE':
        $sql = "DELETE FROM `$table`" . ($where ?: " WHERE 0=1");
        break;

    case 'PUT':
    case 'POST':
        if (empty($columns)) {
            http_response_code(400);
            echo 'ERROR: No data provided';
            exit();
        }
        $setParts = [];
        $colParts = [];
        $valParts = [];
        for ($i = 0; $i < count($columns); $i++) {
            $qval       = $values[$i] === null ? 'NULL' : $db->quote((string)$values[$i]);
            $setParts[] = '`' . $columns[$i] . '`=' . $qval;
            $colParts[] = '`' . $columns[$i] . '`';
            $valParts[] = $qval;
        }
        if ($method === 'PUT') {
            $sql = "UPDATE `$table` SET " . implode(',', $setParts) . ($where ?: " WHERE 0=1");
        } else {
            $sql = "INSERT INTO `$table` (" . implode(',', $colParts) . ") VALUES (" . implode(',', $valParts) . ")";
        }
        break;

    default:
        http_response_code(405);
        echo 'ERROR: Method not allowed';
        exit();
}

try {
    $stmt = $db->query($sql);
    if ($method === 'GET') {
        header('Content-Type: application/json');
        echo json_encode($stmt->fetchAll(PDO::FETCH_OBJ));
    } elseif ($method === 'POST') {
        echo $db->lastInsertId();
    } else {
        echo $stmt->rowCount();
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo 'ERROR: ' . $e->getMessage();
}

// ── Named query implementations ───────────────────────────────────────────────

function handleNamedQuery(PDO $db, string $name): void {
    switch ($name) {

        // Everything the setup screen needs — 6 tables, 1 HTTP request.
        case 'setup_data':
            echo json_encode([
                'rounds'            => queryRows($db, "
                    SELECT rd.round_def_id,
                           rd.round_name,
                           COALESCE(SUM(rng.num_ends) * 6, 0) AS arrow_count
                    FROM   round_def rd
                    LEFT JOIN range_def rng ON rng.round_def_id = rd.round_def_id
                    GROUP  BY rd.round_def_id, rd.round_name
                    ORDER  BY rd.round_name
                "),
                'archers'           => queryRows($db,
                    "SELECT * FROM archer_details ORDER BY name_surname, name_given"
                ),
                'divisions'         => queryRows($db,
                    "SELECT * FROM division ORDER BY division_name"
                ),
                'age_classes'       => queryRows($db,
                    "SELECT * FROM age_class ORDER BY gender, min_age"
                ),
                'categories'        => queryRows($db,
                    "SELECT * FROM categories"
                ),
                'equivalent_rounds' => queryRows($db,
                    "SELECT * FROM equivalent_rounds"
                ),
            ]);
            break;

        // Valid age classes for one archer on one round.
        // Params: round_id (int), gender (M/F), age (int)
        case 'valid_age_classes':
            $round_id = (int)($_GET['round_id'] ?? 0);
            $gender   = $_GET['gender'] ?? '';
            $age      = (int)($_GET['age'] ?? 0);

            if (!$round_id || !$gender || !$age) {
                http_response_code(400);
                echo json_encode(['error' => 'Missing round_id, gender, or age']);
                return;
            }

            $genderQ = $db->quote($gender);

            $caseA = (int)queryScalar($db,
                "SELECT COUNT(*) FROM equivalent_rounds WHERE equivalent_round_id = $round_id"
            ) > 0;

            if ($caseA) {
                $sql = "
                    SELECT DISTINCT ac.*
                    FROM   age_class ac
                    JOIN   categories c ON c.age_class_id = ac.age_class_id
                    WHERE  c.category_id IN (
                               SELECT category_id FROM equivalent_rounds
                               WHERE  equivalent_round_id = $round_id
                           )
                    AND    ac.gender = $genderQ
                    AND    (ac.min_age IS NULL OR ac.min_age <= $age)
                    AND    (ac.max_age IS NULL OR ac.max_age >= $age)
                ";
            } else {
                $caseB = (int)queryScalar($db,
                    "SELECT COUNT(*) FROM equivalent_rounds WHERE base_round_id = $round_id"
                ) > 0;

                if ($caseB) {
                    $sql = "
                        SELECT DISTINCT ac.*
                        FROM   age_class ac
                        JOIN   categories c ON c.age_class_id = ac.age_class_id
                        WHERE  c.category_id NOT IN (SELECT category_id FROM equivalent_rounds)
                        AND    ac.gender = $genderQ
                        AND    (ac.min_age IS NULL OR ac.min_age <= $age)
                        AND    (ac.max_age IS NULL OR ac.max_age >= $age)
                    ";
                } else {
                    $sql = "
                        SELECT * FROM age_class
                        WHERE  gender = $genderQ
                        AND    (min_age IS NULL OR min_age <= $age)
                        AND    (max_age IS NULL OR max_age >= $age)
                    ";
                }
            }
            echo json_encode(queryRows($db, $sql));
            break;

        // Valid divisions for one archer (by age class) on one round.
        // Params: round_id (int), age_class_id (int)
        case 'valid_divisions':
            $round_id     = (int)($_GET['round_id']     ?? 0);
            $age_class_id = (int)($_GET['age_class_id'] ?? 0);

            if (!$round_id || !$age_class_id) {
                echo json_encode(queryRows($db, "SELECT * FROM division ORDER BY division_name"));
                return;
            }

            $caseA = (int)queryScalar($db,
                "SELECT COUNT(*) FROM equivalent_rounds WHERE equivalent_round_id = $round_id"
            ) > 0;

            if ($caseA) {
                $sql = "
                    SELECT DISTINCT d.*
                    FROM   division d
                    JOIN   categories c ON c.division_id = d.division_id
                    WHERE  c.category_id IN (
                               SELECT category_id FROM equivalent_rounds
                               WHERE  equivalent_round_id = $round_id
                           )
                    AND    c.age_class_id = $age_class_id
                    ORDER  BY d.division_name
                ";
            } else {
                $caseB = (int)queryScalar($db,
                    "SELECT COUNT(*) FROM equivalent_rounds WHERE base_round_id = $round_id"
                ) > 0;

                if ($caseB) {
                    $sql = "
                        SELECT DISTINCT d.*
                        FROM   division d
                        JOIN   categories c ON c.division_id = d.division_id
                        WHERE  c.category_id NOT IN (SELECT category_id FROM equivalent_rounds)
                        AND    c.age_class_id = $age_class_id
                        ORDER  BY d.division_name
                    ";
                } else {
                    $sql = "SELECT * FROM division ORDER BY division_name";
                }
            }
            echo json_encode(queryRows($db, $sql));
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => "Unknown query: $name"]);
    }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function queryRows(PDO $db, string $sql): array {
    try {
        return $db->query($sql)->fetchAll(PDO::FETCH_OBJ);
    } catch (PDOException $e) {
        return [['__error' => $e->getMessage()]];
    }
}

function queryScalar(PDO $db, string $sql) {
    try {
        $row = $db->query($sql)->fetch(PDO::FETCH_NUM);
        return $row[0] ?? 0;
    } catch (PDOException $e) {
        return 0;
    }
}

// ── Database initialisation ───────────────────────────────────────────────────

function getDb(string $dbPath, string $sqlPath): PDO {
    $needInit = !file_exists($dbPath);
    $db = new PDO('sqlite:' . $dbPath);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    if ($needInit) {
        try {
            $mysqlSql  = file_get_contents($sqlPath);
            $sqliteSql = mysqlDumpToSqlite($mysqlSql);
            $db->exec($sqliteSql);
        } catch (Exception $e) {
            // Remove partially-initialised file so the next request retries cleanly
            if (file_exists($dbPath)) {
                unlink($dbPath);
            }
            http_response_code(500);
            echo 'ERROR: Could not initialise database — ' . $e->getMessage();
            exit();
        }
    }
    return $db;
}

/**
 * Converts a phpMyAdmin MySQL dump to SQLite-compatible SQL.
 *
 * Handles the specific patterns produced by phpMyAdmin:
 *  - Strips MySQL conditional comments, SET statements, and table options
 *  - Folds ALTER TABLE ADD PRIMARY KEY into each CREATE TABLE definition
 *  - Converts ALTER TABLE ADD KEY to CREATE INDEX statements
 *  - Converts MySQL \' string escaping to SQLite '' escaping
 *  - Skips AUTO_INCREMENT modifiers, COMMENT column attributes, and foreign-key constraints
 */
function mysqlDumpToSqlite(string $mysqlSql): string {
    // Normalise line endings (dump may be CRLF on Windows)
    $mysqlSql = str_replace(["\r\n", "\r"], "\n", $mysqlSql);

    // ── Pass 1: collect PRIMARY KEY and INDEX info from ALTER TABLE ───────────
    $pks     = [];   // table => pk_column_list  e.g. "`col1`,`col2`"
    $indexes = [];   // [{table, name, cols}, ...]

    // Each ALTER TABLE block ends with the first bare `;`
    preg_match_all(
        '/ALTER\s+TABLE\s+`(\w+)`\s+(.*?);/si',
        $mysqlSql, $altMatches, PREG_SET_ORDER
    );

    foreach ($altMatches as $m) {
        $table    = $m[1];
        $altBody  = $m[2];

        if (preg_match('/ADD\s+PRIMARY\s+KEY\s*\(([^)]+)\)/i', $altBody, $pk)) {
            $pks[$table] = $pk[1];
        }

        preg_match_all(
            '/ADD(?:\s+UNIQUE)?\s+KEY\s+`?(\w+)`?\s*\(([^)]+)\)/i',
            $altBody, $idxm, PREG_SET_ORDER
        );
        foreach ($idxm as $ix) {
            $indexes[] = ['table' => $table, 'name' => $ix[1], 'cols' => $ix[2]];
        }
    }

    // ── Pass 2: generate SQLite SQL ───────────────────────────────────────────
    $out = "BEGIN;\n\n";

    // CREATE TABLE — phpMyAdmin always puts ") ENGINE=..." flush against the left margin
    preg_match_all(
        '/CREATE\s+TABLE\s+`(\w+)`\s*\(\n(.*?)\n\)\s+ENGINE=[^\n]+;/si',
        $mysqlSql, $tables, PREG_SET_ORDER
    );

    foreach ($tables as $t) {
        $table    = $t[1];
        $body     = $t[2];

        // Strip COMMENT '...' - SQLite does not support inline column comments
        $body = preg_replace("/COMMENT\s+'[^']*'/i", '', $body);

        // Strip AUTO_INCREMENT keyword from column defs (INTEGER PRIMARY KEY auto-increments)
        $body = preg_replace('/\s*AUTO_INCREMENT\b/i', '', $body);

        // Replace enum(...) with TEXT - SQLite rejects string literals inside type parens
        $body = preg_replace('/\benum\s*\([^)]*\)/i', 'TEXT', $body);

        // Remove UNSIGNED - not a valid SQLite type qualifier
        $body = preg_replace('/\s+UNSIGNED\b/i', '', $body);

        // Convert MySQL integer types to INTEGER so SQLite single-column PKs
        // auto-increment correctly (SQLite requires the exact word INTEGER for this)
        $body = preg_replace('/\bbigint\s*\(\d+\)/i',   'INTEGER', $body);
        $body = preg_replace('/\bmediumint\s*\(\d+\)/i','INTEGER', $body);
        $body = preg_replace('/\bsmallint\s*\(\d+\)/i', 'INTEGER', $body);
        $body = preg_replace('/\btinyint\s*\(\d+\)/i',  'INTEGER', $body);
        $body = preg_replace('/\bint\s*\(\d+\)/i',      'INTEGER', $body);

        // Convert varchar/char to TEXT
        $body = preg_replace('/\b(?:var)?char\s*\(\d+\)/i', 'TEXT', $body);

        // Append PRIMARY KEY table constraint (must come after all column defs)
        if (isset($pks[$table])) {
            $body = rtrim($body, " \t\n,");
            $body .= ",\n  PRIMARY KEY (" . $pks[$table] . ")";
        }

        $out .= "CREATE TABLE IF NOT EXISTS `$table` (\n$body\n);\n\n";
    }

    // INSERT statements — convert MySQL \'  escaping to SQLite '' escaping
    preg_match_all(
        '/INSERT INTO `\w+`\s+\([^)]+\)\s+VALUES\n[^;]+;/si',
        $mysqlSql, $inserts
    );
    foreach ($inserts[0] as $ins) {
        $ins  = str_replace("\\'", "''", $ins);
        $out .= $ins . "\n\n";
    }

    // CREATE INDEX statements (de-duplicated)
    $seen = [];
    foreach ($indexes as $ix) {
        $dedupeKey = $ix['table'] . '.' . $ix['name'];
        if (isset($seen[$dedupeKey])) {
            continue;
        }
        $seen[$dedupeKey] = true;
        $idxName = 'idx_' . $ix['table'] . '_' . $ix['name'];
        $out .= "CREATE INDEX IF NOT EXISTS `$idxName` ON `{$ix['table']}` ({$ix['cols']});\n";
    }

    $out .= "\nCOMMIT;\n";
    return $out;
}
?>
