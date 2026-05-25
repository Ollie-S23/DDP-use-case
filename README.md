# DDP-use-case

## USE CASE purpose
This use case is to explore the practical applications of databases for software and game development majors.
I am studying the Game Development major who is also minoring in Web Development so I am familiar with web applications' frontend and backend design. I used VueJS and Vite to create this project.
I had decided to take this loose task to expand on the foundations that they have given during the Week 10 and 11 work, by allowing not just round and archer choice, but also the class, division, and competitions. 
The purpose of this use case is meant to be an easy GUI web application for archers' to enter their own details in.
This task is exclusively for archers and do not include the recorders verifying archer details moving results from staging to permanent tables. The task is just to implement the basics of inserting data (CRUD) for the users and no other features such as querying the user's details such as scores, personal bests, equivalent rounds, etc. 
Additionally, this task does not have nay deployment to a sever and is all local (instructions below), and that some liberties were taken in for considering the design of this project while trying to keep the project brief in mind, no tables were changed from the latest design from Confluence. No security measure were added like a proper web application such as a login system. 
The purpose of this was to show how an archer could responsibly enter there details, so functionality should reflect that, however the design of this application was not considered. 

editors note: due to feedback and discussion taken place in the lecture and class on the 25th May 2026, the following was changed:
- changed the date fields to datetime where appropriate
- removed redundant is_approved in arrow_shot table
- changed is_chomp in chomp to is_champ
- made all data go to staging table instead of shots when casual and staging when competition
- sorted the ends arrow to be highest to lowest in crud statement rather than gui frontend or db functions.
It is to be noted that all functionality and reasonability checks are made in this program by CRUD statement rather than any in db; discussed in lecture. 

> **Disclaimer:** XAMPP must be installed and fully set up before following these steps. It is assumed that Apache is running on port **80** (the XAMPP default). If you have changed the port, update `vite.config.js` accordingly.

## How to import the SQL database into XAMPP

1. Open your browser and go to `http://localhost/phpmyadmin`
2. Click **New** in the left sidebar and create a database named `ddp_v5_appv`
3. Select the `ddp_v5_appv` database
4. Click the **Import** tab at the top
5. Click **Choose File** and select `use case web app/src/database/ddp_v5_appv.sql` from the project folder
6. Click **Go** at the bottom of the page

## How to add `apis.php` to XAMPP

Open PowerShell and run:

```powershell
Copy-Item "path\to\your\project\apis.php" "C:\xampp\htdocs\apis.php" -Force
```

Replace `path\to\your\project` with the full path to the project folder. For example:

```powershell
Copy-Item "c:\Users\ollie\Downloads\DDP-use-case\apis.php" "C:\xampp\htdocs\apis.php" -Force
```

## Indexes used in this project

Indexes are defined on all foreign key columns to speed up JOINs and lookups.

| Table | Indexed column(s) |
|---|---|
| `archer_details` | `division_id` |
| `arrow_shot` | `end_id` |
| `categories` | `age_class_id`, `division_id` |
| `end_shot` | `range_shot_id` |
| `equivalent_rounds` | `base_round_id`, `equivalent_round_id`, `category_id` |
| `range_shot` | `round_shots_id`, `range_def_round_id` + `range_def_distance` + `range_def_target_size` |
| `round_shot` | `round_def_id`, `archer_id`, `category_id`, `comp_id` |
| `staging_arrow` | `staging_end_id` |
| `staging_end` | `range_def_round_id` + `range_def_distance` + `range_def_target_size`, `staging_id` |
| `staging_table` | `archer_id`, `round_def_id`, `division_id`, `comp_id` |

## SQL statements used in this project

### Setup screen — load all reference data

```sql
SELECT rd.round_def_id, rd.round_name,
       COALESCE(SUM(rng.num_ends) * 6, 0) AS arrow_count
FROM   round_def rd
LEFT JOIN range_def rng ON rng.round_def_id = rd.round_def_id
GROUP  BY rd.round_def_id, rd.round_name
HAVING arrow_count > 0
ORDER  BY rd.round_name;

SELECT * FROM archer_details ORDER BY name_given, name_surname;
SELECT * FROM division ORDER BY division_name;
SELECT * FROM age_class ORDER BY gender, min_age;
SELECT * FROM categories;
SELECT * FROM equivalent_rounds;
SELECT comp_id, comp_name, comp_date FROM comp ORDER BY comp_date DESC;
```

### Valid age classes for a round (3 cases)

```sql
-- Case A: round is an equivalent round
SELECT DISTINCT ac.*
FROM   age_class ac
JOIN   categories c ON c.age_class_id = ac.age_class_id
WHERE  c.category_id IN (
           SELECT category_id FROM equivalent_rounds WHERE equivalent_round_id = :round_id
       )
AND    ac.gender = :gender
AND    (ac.min_age IS NULL OR ac.min_age <= :age)
AND    (ac.max_age IS NULL OR ac.max_age >= :age);

-- Case B: round is a base round
SELECT DISTINCT ac.*
FROM   age_class ac
JOIN   categories c ON c.age_class_id = ac.age_class_id
WHERE  c.category_id NOT IN (SELECT category_id FROM equivalent_rounds)
AND    ac.gender = :gender
AND    (ac.min_age IS NULL OR ac.min_age <= :age)
AND    (ac.max_age IS NULL OR ac.max_age >= :age);

-- Case C: round has no equivalent-round mapping
SELECT * FROM age_class
WHERE  gender = :gender
AND    (min_age IS NULL OR min_age <= :age)
AND    (max_age IS NULL OR max_age >= :age);
```

### Valid divisions for a round + age class (3 cases)

```sql
-- Case A
SELECT DISTINCT d.*
FROM   division d
JOIN   categories c ON c.division_id = d.division_id
WHERE  c.category_id IN (
           SELECT category_id FROM equivalent_rounds WHERE equivalent_round_id = :round_id
       )
AND    c.age_class_id = :age_class_id
ORDER  BY d.division_name;

-- Case B
SELECT DISTINCT d.*
FROM   division d
JOIN   categories c ON c.division_id = d.division_id
WHERE  c.category_id NOT IN (SELECT category_id FROM equivalent_rounds)
AND    c.age_class_id = :age_class_id
ORDER  BY d.division_name;

-- Case C
SELECT * FROM division ORDER BY division_name;
```

### Ranges for a round

```sql
SELECT * FROM range_def WHERE round_def_id = :round_id ORDER BY distance DESC;
```

### Submit session — all sessions go to staging (pending recorder approval. Regardless if comp or casual)

All submissions — both casual and competition — are inserted into the staging tables. `comp_id` is the competition ID if one was selected, or `NULL` for a casual session. `datetime` is captured at the moment of submission via `NOW()`.

```sql
INSERT INTO staging_table (archer_id, round_def_id, division_id, comp_id, datetime, status)
VALUES (:archer_id, :round_id, :division_id, :comp_id_or_null, NOW(), 'pending');

INSERT INTO staging_end (staging_id, range_def_round_id, range_def_distance, range_def_target_size, end_number)
VALUES (:staged_id, :round_id, :distance, :target_size, :end_number);

INSERT INTO staging_arrow (staging_end_id, score, is_x)
VALUES (:staging_end_id, :score, :is_x);
```

### edit statements for database from feedback

```sql
-- Rename is_comp to is_champ in comp table
ALTER TABLE `comp` CHANGE `is_comp` `is_champ` tinyint(1) NOT NULL DEFAULT 0;

-- Remove is_approved from arrow_shot
ALTER TABLE `arrow_shot` DROP COLUMN `is_approved`;

-- Add nullable comp_id FK to staging_table
ALTER TABLE `staging_table`
  ADD COLUMN `comp_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `staging_table_ibfk_4` FOREIGN KEY (`comp_id`) REFERENCES `comp` (`comp_id`);

-- Rename round_shots_date to round_shots_datetime and change type to DATETIME
ALTER TABLE `round_shot` CHANGE `round_shots_date` `round_shots_datetime` DATETIME NOT NULL;
```
