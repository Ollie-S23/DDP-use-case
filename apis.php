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

// ── MySQL via XAMPP ───────────────────────────────────────────────────────────
try {
    $db = new PDO('mysql:host=127.0.0.1;port=3306;dbname=ddp_v5_appv;charset=utf8mb4', 'root', '', [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'DB connection failed: ' . $e->getMessage()]);
    exit();
}

// ── Named-query route (?query=<name>) ─────────────────────────────────────────
$queryName = isset($_GET['query']) ? preg_replace('/[^a-z0-9_]+/i', '', $_GET['query']) : null;

if ($queryName && in_array($method, ['GET', 'POST'])) {
    header('Content-Type: application/json');
    handleNamedQuery($db, $queryName, $method, $input);
    exit();
}

// ── Generic single-table CRUD route (?table=<name>) ──────────────────────────
$allowed_tables = [
    'round_def', 'archer_details', 'division', 'comp',
    'categories', 'age_class', 'staging_table', 'staging_end', 'staging_arrow',
    'equivalent_rounds', 'range_def', 'round_shot', 'range_shot', 'end_shot', 'arrow_shot'
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

function handleNamedQuery(PDO $db, string $name, string $method, ?array $input = null): void {
    switch ($name) {

        // Note: this sql crud qeuery is used
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
                    HAVING arrow_count > 0
                    ORDER  BY rd.round_name
                "),
                'archers'           => queryRows($db,
                    "SELECT * FROM archer_details ORDER BY name_given, name_surname"
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
                'competitions'      => queryRows($db,
                    "SELECT comp_id, comp_name, comp_date FROM comp ORDER BY comp_date DESC"
                ),
            ]);
            break;

        // note: this crud qeuery was never used, and is controlled now by js
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

        // note: this crud qeuery was never used, and is controlled now by js
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

        // Note: this sql crud qeuery is used
        // Submit a completed scoring session.
        // Body (JSON): archer_id, round_def_id, division_id, age_class_id,
        //              comp_id (int|null — null means casual session),
        //              ranges: [{distance, target_size_cm, ends: [[scores]]}]
        case 'submit_session':
            if ($method !== 'POST') {
                http_response_code(405);
                echo json_encode(['error' => 'POST required']);
                return;
            }
            $d            = $input ?? [];
            $archer_id    = (int)($d['archer_id']    ?? 0);
            $round_id     = (int)($d['round_def_id'] ?? 0);
            $division_id  = (int)($d['division_id']  ?? 0);
            $age_class_id = (int)($d['age_class_id'] ?? 0);
            $comp_id      = !empty($d['comp_id']) ? (int)$d['comp_id'] : null;
            $ranges_data  = $d['ranges'] ?? [];

            if (!$archer_id || !$round_id || !$division_id || !$age_class_id || empty($ranges_data)) {
                http_response_code(400);
                echo json_encode(['error' => 'Missing required fields']);
                return;
            }

            $comp_val = $comp_id !== null ? $comp_id : 'NULL';

            $db->beginTransaction();
            try {
                $db->exec("INSERT INTO staging_table (archer_id, round_def_id, division_id, comp_id, datetime, status)
                           VALUES ($archer_id, $round_id, $division_id, $comp_val, NOW(), 'pending')");
                $staged_id = (int)$db->lastInsertId();

                foreach ($ranges_data as $rng) {
                    $dist   = (int)$rng['distance'];
                    $target = (int)$rng['target_size_cm'];
                    foreach ($rng['ends'] as $end_num => $arrows) {
                        $end_number = $end_num + 1;
                        $db->exec("INSERT INTO staging_end
                                     (staging_id, range_def_round_id, range_def_distance, range_def_target_size, end_number)
                                   VALUES ($staged_id, $round_id, $dist, $target, $end_number)");
                        $staging_end_id = (int)$db->lastInsertId();
                        foreach ($arrows as $arrow) {
                            $is_x  = $arrow === 'X' ? 1 : 0;
                            $score = $arrow === 'X' ? 10 : ($arrow === 'M' ? 0 : (int)$arrow);
                            $db->exec("INSERT INTO staging_arrow (staging_end_id, score, is_x)
                                       VALUES ($staging_end_id, $score, $is_x)");
                        }
                    }
                }
                $db->commit();
                echo json_encode(['ok' => true, 'staged_id' => $staged_id]);
            } catch (PDOException $e) {
                $db->rollBack();
                http_response_code(500);
                echo json_encode(['error' => $e->getMessage()]);
            }
            break;

        // Note: this sql crud qeuery is used
        // Ranges (with end count) for a given round.
        // Params: round_id (int)
        case 'ranges_for_round':
            $round_id = (int)($_GET['round_id'] ?? 0);
            if (!$round_id) {
                http_response_code(400);
                echo json_encode(['error' => 'Missing round_id']);
                return;
            }
            echo json_encode(queryRows($db, "
                SELECT *
                FROM   range_def
                WHERE  round_def_id = $round_id
                ORDER  BY distance DESC
            "));
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => "Unknown query: $name"]);
    }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function queryRows(PDO $db, string $sql): array {
    return $db->query($sql)->fetchAll(PDO::FETCH_OBJ);
}

function queryScalar(PDO $db, string $sql) {
    try {
        $row = $db->query($sql)->fetch(PDO::FETCH_NUM);
        return $row[0] ?? 0;
    } catch (PDOException $e) {
        return 0;
    }
}

?>
