-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 09, 2026 at 07:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ddp_v5_draft3`
--

-- --------------------------------------------------------

--
-- Table structure for table `age_class`
--

CREATE TABLE `age_class` (
  `age_class_id` int(11) NOT NULL,
  `class_name` varchar(30) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `min_age` tinyint(3) UNSIGNED DEFAULT NULL COMMENT 'NULL = no lower bound',
  `max_age` tinyint(3) UNSIGNED DEFAULT NULL COMMENT 'NULL = no upper bound (Open)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `age_class`
--

INSERT INTO `age_class` (`age_class_id`, `class_name`, `gender`, `min_age`, `max_age`) VALUES
(1, 'Female Open', 'F', NULL, NULL),
(2, 'Male Open', 'M', NULL, NULL),
(3, 'Female 50+', 'F', 50, NULL),
(4, 'Male 50+', 'M', 50, NULL),
(5, 'Female 60+', 'F', 60, NULL),
(6, 'Male 60+', 'M', 60, NULL),
(7, 'Female 70+', 'F', 70, NULL),
(8, 'Male 70+', 'M', 70, NULL),
(9, 'Under 21 Female', 'F', NULL, 21),
(10, 'Under 21 Male', 'M', NULL, 21),
(11, 'Under 18 Female', 'F', NULL, 18),
(12, 'Under 18 Male', 'M', NULL, 18),
(13, 'Under 16 Female', 'F', NULL, 16),
(14, 'Under 16 Male', 'M', NULL, 16),
(15, 'Under 14 Female', 'F', NULL, 14),
(16, 'Under 14 Male', 'M', NULL, 14);

-- --------------------------------------------------------

--
-- Table structure for table `archer_details`
--

CREATE TABLE `archer_details` (
  `archer_id` int(11) NOT NULL,
  `name_given` varchar(50) NOT NULL,
  `name_surname` varchar(50) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `birth_year` year(4) NOT NULL COMMENT 'Used with gender to derive AgeClass',
  `division_id` int(11) DEFAULT NULL COMMENT 'Default bow type for this archer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archer_details`
--

INSERT INTO `archer_details` (`archer_id`, `name_given`, `name_surname`, `gender`, `birth_year`, `division_id`) VALUES
(1, 'Mia', 'Miller', 'F', '2000', 1),
(2, 'Quinn', 'Friend', 'F', '2005', 3),
(3, 'Giuliano', 'Zuoccara', 'M', '2006', 5),
(4, 'Pratima', 'Sharma', 'F', '2004', 4),
(5, 'Oliver', 'Scott', 'M', '2006', 3),
(6, 'Kasey', 'Hoodlass', 'F', '2014', 5),
(7, 'Arri', 'Coolahan', 'M', '1993', 1),
(8, 'Coraline', 'Sickling', 'F', '2001', 3),
(9, 'Bordie', 'Weymouth', 'M', '1999', 5),
(10, 'Moises', 'Tilley', 'M', '1987', 2),
(11, 'Arturo', 'Coit', 'M', '1952', 1),
(12, 'Lilian', 'De Benedictis', 'F', '2007', 4),
(13, 'Margareta', 'Digance', 'F', '1972', 1),
(14, 'Ignacius', 'Noulton', 'M', '1993', 4),
(15, 'Sib', 'Trebble', 'F', '1969', 5),
(16, 'Bamby', 'Mearns', 'F', '1958', 4),
(17, 'Kym', 'Runcieman', 'F', '2009', 5),
(18, 'Steward', 'Belf', 'M', '1965', 2),
(19, 'Peg', 'Dellenty', 'F', '1971', 3),
(20, 'Judi', 'Cromblehome', 'F', '1992', 2),
(21, 'Zebedee', 'Romagosa', 'M', '1954', 2),
(22, 'Flynn', 'Durant', 'M', '1958', 3),
(23, 'Caryl', 'Luetchford', 'F', '1998', 4),
(24, 'Aksel', 'Hallut', 'M', '2004', 5),
(25, 'Eleanore', 'Goracci', 'F', '1971', 3),
(26, 'Keriann', 'Klimentov', 'F', '1985', 5),
(27, 'Angelica', 'Blockwell', 'F', '2007', 5),
(28, 'Claudie', 'Turmel', 'F', '1978', 3),
(29, 'Shanna', 'Hiskey', 'F', '2008', 1),
(30, 'Gareth', 'Harrismith', 'M', '1985', 2),
(31, 'Creighton', 'Cothey', 'M', '1979', 2),
(32, 'Andeee', 'Arenson', 'F', '1986', 3),
(33, 'Franny', 'Langelaan', 'M', '2001', 2),
(34, 'Mohandas', 'Fishleigh', 'M', '1986', 5),
(35, 'Brit', 'McAree', 'M', '1989', 1),
(36, 'Wynny', 'Pond-Jones', 'F', '1958', 2),
(37, 'Shell', 'Maeer', 'M', '2001', 2),
(38, 'Willdon', 'Stubs', 'M', '1999', 1),
(39, 'Anett', 'Christofe', 'F', '1953', 3),
(40, 'Tanner', 'Marrable', 'M', '2015', 5),
(41, 'Aland', 'Choupin', 'M', '1962', 1),
(42, 'Jeanie', 'Gimeno', 'F', '1995', 5),
(43, 'Augusto', 'Hiner', 'M', '1967', 2),
(44, 'Niki', 'Attwater', 'M', '2002', 3),
(45, 'Hasheem', 'Braithwaite', 'M', '1997', 4),
(46, 'Shelagh', 'Rosenbloom', 'F', '1967', 4),
(47, 'Gavra', 'Beet', 'F', '2003', 3),
(48, 'Kelley', 'Thorwarth', 'F', '1956', 3),
(49, 'Leta', 'Beaushaw', 'F', '1992', 3),
(50, 'Rose', 'Osant', 'F', '1982', 1),
(51, 'Giselbert', 'Rasper', 'M', '1985', 3),
(52, 'Nomi', 'Brede', 'F', '1955', 2),
(53, 'Giavani', 'Jakubowski', 'M', '2001', 3),
(54, 'Ulick', 'Norsister', 'M', '1958', 2),
(55, 'Nichol', 'Lambswood', 'F', '2010', 2),
(56, 'Whittaker', 'McQuaid', 'M', '1952', 4),
(57, 'Peadar', 'Rodenhurst', 'M', '1999', 4),
(58, 'Dorelle', 'Pablo', 'F', '1961', 4),
(59, 'Leonhard', 'Wigmore', 'M', '1996', 5),
(60, 'Babara', 'Hanaford', 'F', '2015', 5),
(61, 'Ashleigh', 'Briskey', 'F', '2012', 2),
(62, 'Lorette', 'Rodenborch', 'F', '1950', 3),
(63, 'Davita', 'Cayle', 'F', '1967', 3),
(64, 'Amalea', 'Reisenberg', 'F', '1993', 1),
(65, 'Siobhan', 'Meuse', 'F', '1977', 4),
(66, 'Cirilo', 'Harrad', 'M', '1960', 1),
(67, 'Saunder', 'Maryin', 'M', '1992', 3),
(68, 'Josee', 'Capper', 'F', '1983', 2),
(69, 'Konstance', 'Scarlon', 'F', '1997', 3),
(70, 'Horatia', 'MacKegg', 'F', '1994', 2),
(71, 'Alexandre', 'Bouch', 'M', '1997', 4),
(72, 'Sophia', 'Spellward', 'F', '1980', 5),
(73, 'Ernestus', 'Di Bartolomeo', 'M', '1987', 2),
(74, 'Lorrie', 'Skeech', 'M', '1986', 2),
(75, 'Rodney', 'Dyott', 'M', '1996', 2),
(76, 'Edsel', 'Rubica', 'M', '1968', 5),
(77, 'Olivier', 'Shegog', 'M', '1994', 1),
(78, 'Carina', 'Rootham', 'F', '1951', 1),
(79, 'Quinn', 'Bartosek', 'F', '2000', 3),
(80, 'Jonis', 'Blakeley', 'F', '1951', 1),
(81, 'Sherie', 'Ram', 'F', '1987', 1),
(82, 'Gustie', 'Vigar', 'F', '1986', 5),
(83, 'Bobbee', 'Jenks', 'F', '2015', 3),
(84, 'Kellen', 'Groucutt', 'F', '1971', 3),
(85, 'Bale', 'Kiddell', 'M', '1971', 4),
(86, 'Llywellyn', 'McGrah', 'M', '1993', 5),
(87, 'Shepherd', 'Winfred', 'M', '2007', 4),
(88, 'Gabriell', 'Della Scala', 'F', '1960', 4),
(89, 'Leroi', 'Tapsfield', 'M', '1998', 2),
(90, 'Tris', 'Franken', 'M', '1988', 2),
(91, 'Hale', 'Elintune', 'M', '1995', 1),
(92, 'Georgeta', 'Shakespear', 'F', '1990', 4),
(93, 'Denis', 'Hawick', 'M', '1971', 1),
(94, 'Basilio', 'Peirce', 'M', '1974', 4),
(95, 'Goran', 'Munkton', 'M', '1972', 3),
(96, 'Sayre', 'Creeboe', 'M', '2012', 5),
(97, 'Licha', 'Gravett', 'F', '1978', 4),
(98, 'Nathan', 'Wrightem', 'M', '1970', 3),
(99, 'Fitzgerald', 'Stobbie', 'M', '2002', 5),
(100, 'Land', 'Ouver', 'M', '1953', 5);

-- --------------------------------------------------------

--
-- Table structure for table `arrow_shot`
--

CREATE TABLE `arrow_shot` (
  `arrow_id` int(11) NOT NULL,
  `end_id` int(11) NOT NULL,
  `score` tinyint(3) UNSIGNED NOT NULL COMMENT 'Arrow score 0–10',
  `isX_score` tinyint(1) NOT NULL DEFAULT 0,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `arrow_shot`
--

INSERT INTO `arrow_shot` (`arrow_id`, `end_id`, `score`, `isX_score`, `is_approved`) VALUES
(1, 1, 10, 1, 0),
(2, 1, 10, 0, 0),
(3, 1, 9, 0, 0),
(4, 1, 8, 0, 0),
(5, 1, 7, 0, 0),
(6, 1, 3, 0, 0),
(7, 2, 10, 1, 0),
(8, 2, 10, 0, 0),
(9, 2, 9, 0, 0),
(10, 2, 7, 0, 0),
(11, 2, 6, 0, 0),
(12, 2, 5, 0, 0),
(13, 3, 10, 1, 0),
(14, 3, 9, 0, 0),
(15, 3, 8, 0, 0),
(16, 3, 7, 0, 0),
(17, 3, 5, 0, 0),
(18, 3, 4, 0, 0),
(19, 4, 10, 1, 0),
(20, 4, 10, 0, 0),
(21, 4, 9, 0, 0),
(22, 4, 8, 0, 0),
(23, 4, 6, 0, 0),
(24, 4, 3, 0, 0),
(25, 5, 10, 1, 0),
(26, 5, 10, 0, 0),
(27, 5, 9, 0, 0),
(28, 5, 8, 0, 0),
(29, 5, 7, 0, 0),
(30, 5, 4, 0, 0),
(31, 6, 10, 0, 0),
(32, 6, 8, 0, 0),
(33, 6, 7, 0, 0),
(34, 6, 6, 0, 0),
(35, 6, 5, 0, 0),
(36, 6, 3, 0, 0),
(37, 7, 10, 1, 0),
(38, 7, 10, 0, 0),
(39, 7, 9, 0, 0),
(40, 7, 8, 0, 0),
(41, 7, 7, 0, 0),
(42, 7, 4, 0, 0),
(43, 8, 10, 1, 0),
(44, 8, 10, 0, 0),
(45, 8, 9, 0, 0),
(46, 8, 7, 0, 0),
(47, 8, 5, 0, 0),
(48, 8, 3, 0, 0),
(49, 9, 10, 1, 0),
(50, 9, 10, 0, 0),
(51, 9, 9, 0, 0),
(52, 9, 8, 0, 0),
(53, 9, 7, 0, 0),
(54, 9, 6, 0, 0),
(55, 10, 10, 1, 0),
(56, 10, 9, 0, 0),
(57, 10, 8, 0, 0),
(58, 10, 7, 0, 0),
(59, 10, 5, 0, 0),
(60, 10, 4, 0, 0),
(61, 11, 10, 1, 0),
(62, 11, 10, 0, 0),
(63, 11, 9, 0, 0),
(64, 11, 8, 0, 0),
(65, 11, 6, 0, 0),
(66, 11, 3, 0, 0),
(67, 12, 10, 1, 0),
(68, 12, 10, 0, 0),
(69, 12, 8, 0, 0),
(70, 12, 7, 0, 0),
(71, 12, 5, 0, 0),
(72, 12, 4, 0, 0),
(73, 13, 10, 1, 0),
(74, 13, 10, 0, 0),
(75, 13, 9, 0, 0),
(76, 13, 8, 0, 0),
(77, 13, 7, 0, 0),
(78, 13, 3, 0, 0),
(79, 14, 10, 0, 0),
(80, 14, 9, 0, 0),
(81, 14, 8, 0, 0),
(82, 14, 7, 0, 0),
(83, 14, 6, 0, 0),
(84, 14, 4, 0, 0),
(85, 15, 10, 1, 0),
(86, 15, 10, 0, 0),
(87, 15, 9, 0, 0),
(88, 15, 7, 0, 0),
(89, 15, 5, 0, 0),
(90, 15, 3, 0, 0),
(91, 16, 10, 1, 0),
(92, 16, 10, 0, 0),
(93, 16, 9, 0, 0),
(94, 16, 8, 0, 0),
(95, 16, 7, 0, 0),
(96, 16, 6, 0, 0),
(97, 17, 10, 1, 0),
(98, 17, 9, 0, 0),
(99, 17, 8, 0, 0),
(100, 17, 7, 0, 0),
(101, 17, 5, 0, 0),
(102, 17, 4, 0, 0),
(103, 18, 10, 1, 0),
(104, 18, 10, 0, 0),
(105, 18, 9, 0, 0),
(106, 18, 8, 0, 0),
(107, 18, 6, 0, 0),
(108, 18, 3, 0, 0),
(109, 19, 10, 1, 0),
(110, 19, 10, 0, 0),
(111, 19, 8, 0, 0),
(112, 19, 7, 0, 0),
(113, 19, 5, 0, 0),
(114, 19, 4, 0, 0),
(115, 20, 10, 1, 0),
(116, 20, 10, 0, 0),
(117, 20, 9, 0, 0),
(118, 20, 8, 0, 0),
(119, 20, 7, 0, 0),
(120, 20, 3, 0, 0),
(121, 21, 10, 0, 0),
(122, 21, 9, 0, 0),
(123, 21, 8, 0, 0),
(124, 21, 7, 0, 0),
(125, 21, 6, 0, 0),
(126, 21, 4, 0, 0),
(127, 22, 10, 1, 0),
(128, 22, 10, 0, 0),
(129, 22, 9, 0, 0),
(130, 22, 7, 0, 0),
(131, 22, 5, 0, 0),
(132, 22, 3, 0, 0),
(133, 23, 10, 1, 0),
(134, 23, 10, 0, 0),
(135, 23, 9, 0, 0),
(136, 23, 8, 0, 0),
(137, 23, 7, 0, 0),
(138, 23, 6, 0, 0),
(139, 24, 10, 1, 0),
(140, 24, 9, 0, 0),
(141, 24, 8, 0, 0),
(142, 24, 5, 0, 0),
(143, 24, 4, 0, 0),
(144, 24, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `age_class_id` int(11) NOT NULL,
  `division_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `age_class_id`, `division_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 2, 1),
(7, 2, 2),
(8, 2, 3),
(9, 2, 4),
(10, 2, 5),
(11, 3, 1),
(12, 3, 2),
(13, 3, 3),
(14, 3, 4),
(15, 3, 5),
(16, 4, 1),
(17, 4, 2),
(18, 4, 3),
(19, 4, 4),
(20, 4, 5),
(21, 5, 1),
(22, 5, 2),
(23, 5, 3),
(24, 5, 4),
(25, 5, 5),
(26, 6, 1),
(27, 6, 2),
(28, 6, 3),
(29, 6, 4),
(30, 6, 5),
(31, 7, 1),
(32, 7, 2),
(33, 7, 3),
(34, 7, 4),
(35, 7, 5),
(36, 8, 1),
(37, 8, 2),
(38, 8, 3),
(39, 8, 4),
(40, 8, 5),
(41, 9, 1),
(42, 9, 2),
(43, 9, 3),
(44, 9, 4),
(45, 9, 5),
(46, 10, 1),
(47, 10, 2),
(48, 10, 3),
(49, 10, 4),
(50, 10, 5),
(51, 11, 1),
(52, 11, 2),
(53, 11, 3),
(54, 11, 4),
(55, 11, 5),
(56, 12, 1),
(57, 12, 2),
(58, 12, 3),
(59, 12, 4),
(60, 12, 5),
(61, 13, 1),
(62, 13, 2),
(63, 13, 3),
(64, 13, 4),
(65, 13, 5),
(66, 14, 1),
(67, 14, 2),
(68, 14, 3),
(69, 14, 4),
(70, 14, 5),
(71, 15, 1),
(72, 15, 2),
(73, 15, 3),
(74, 15, 4),
(75, 15, 5),
(76, 16, 1),
(77, 16, 2),
(78, 16, 3),
(79, 16, 4),
(80, 16, 5);

-- --------------------------------------------------------

--
-- Table structure for table `comp`
--

CREATE TABLE `comp` (
  `comp_id` int(11) NOT NULL,
  `comp_name` varchar(100) DEFAULT NULL,
  `comp_date` date DEFAULT NULL,
  `is_comp` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'True = official competition'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comp`
--

INSERT INTO `comp` (`comp_id`, `comp_name`, `comp_date`, `is_comp`) VALUES
(1, 'Michael Kors Holdings Limited', '2025-12-23', 0),
(2, 'China Mobile (Hong Kong) Ltd.', '2025-06-01', 1),
(3, 'Carlisle Companies Incorporated', '2025-06-24', 1),
(4, 'CPS Technologies Corp.', '2025-10-31', 0),
(5, 'Bank Of Montreal', '2026-04-27', 1),
(6, 'YuMe, Inc.', '2025-09-24', 1),
(7, 'Central Garden & Pet Company', '2025-09-21', 1),
(8, 'Smart', '2025-05-08', 0),
(9, 'Oasmia Pharmaceutical AB', '2025-10-26', 0),
(10, 'New York Times Company (The)', '2025-08-16', 1),
(11, 'AllianzGI NFJ Dividend, Interest & Premium Strategy Fund', '2025-01-19', 0),
(12, 'KB Home', '2025-10-15', 0),
(13, 'First Trust New Opportunities MLP & Energy Fund', '2025-06-10', 0),
(14, 'Fifth Street Senior Floating Rate Corp.', '2025-11-24', 1),
(15, 'Templeton Dragon Fund, Inc.', '2026-02-19', 1),
(16, 'Ingevity Corporation', '2026-03-20', 1),
(17, 'Apartment Investment and Management Company', '2025-02-28', 1),
(18, 'R.R. Donnelley & Sons Company', '2025-08-03', 0),
(19, 'Concho Resources Inc.', '2025-01-20', 0),
(20, 'Camden Property Trust', '2025-06-28', 1),
(21, 'SciClone Pharmaceuticals, Inc.', '2025-06-11', 1),
(22, 'Digital Realty Trust, Inc.', '2026-01-08', 0),
(23, 'Forum Merger Corporation', '2025-12-19', 1),
(24, 'Select Bancorp, Inc.', '2025-02-22', 0),
(25, 'EchoStar Corporation', '2025-03-19', 1),
(26, 'Blackrock MuniHoldings California Quality Fund,  Inc.', '2025-11-04', 1),
(27, 'Zion Oil & Gas Inc', '2025-05-07', 1),
(28, 'Allegion plc', '2025-02-10', 1),
(29, 'Micronet Enertec Technologies, Inc.', '2025-10-23', 1),
(30, 'Echelon Corporation', '2026-02-27', 0),
(31, 'Nuveen Intermediate Duration Municipal Term Fund', '2025-03-16', 0),
(32, 'Franco-Nevada Corporation', '2025-09-18', 0),
(33, 'SVB Financial Group', '2025-10-07', 0),
(34, 'Nustar GP Holdings, LLC', '2025-06-15', 0),
(35, 'SmartFinancial, Inc.', '2025-05-18', 1),
(36, 'SeaSpine Holdings Corporation', '2025-05-21', 0),
(37, 'Syros Pharmaceuticals, Inc.', '2026-01-07', 0),
(38, 'Stag Industrial, Inc.', '2026-03-23', 1),
(39, 'Sun Communities, Inc.', '2025-08-20', 0),
(40, 'Allegheny Technologies Incorporated', '2025-05-03', 0),
(41, 'Donegal Group, Inc.', '2026-04-18', 0),
(42, 'Brasilagro Cia Brasileira De Propriedades Agricolas', '2025-11-16', 1),
(43, 'Riverview Bancorp Inc', '2025-02-12', 1),
(44, 'General Mills, Inc.', '2025-09-25', 1),
(45, 'Village Bank and Trust Financial Corp.', '2025-05-01', 1),
(46, 'BlackRock California Municipal Income Trust', '2025-10-25', 1),
(47, 'Electronic Arts Inc.', '2025-01-13', 0),
(48, 'New Age Beverages Corporation', '2025-06-23', 0),
(49, 'Regional Management Corp.', '2026-04-28', 1),
(50, 'Ethan Allen Interiors Inc.', '2026-03-17', 0),
(51, 'Hawthorn Bancshares, Inc.', '2026-02-04', 1),
(52, 'Lipocine Inc.', '2025-01-28', 1),
(53, 'J P Morgan Chase & Co', '2026-02-11', 0),
(54, 'J P Morgan Chase & Co', '2025-02-27', 1),
(55, 'Nuveen Municipal Income Fund, Inc.', '2025-09-08', 1),
(56, 'TICC Capital Corp.', '2025-07-20', 1),
(57, 'Blackrock California Municipal 2018 Term Trust', '2025-11-23', 1),
(58, 'Synergy Pharmaceuticals, Inc.', '2025-12-21', 0),
(59, 'MakeMyTrip Limited', '2025-09-24', 1),
(60, 'Phillips 66', '2025-08-08', 1),
(61, 'Vonage Holdings Corp.', '2025-04-10', 1),
(62, 'The Travelers Companies, Inc.', '2026-01-24', 1),
(63, 'SI Financial Group, Inc.', '2025-09-23', 0),
(64, 'Apple Hospitality REIT, Inc.', '2025-02-13', 1),
(65, 'Duff & Phelps Utility & Corporate Bond Trust, Inc.', '2026-04-29', 1),
(66, 'Western Asset Mortgage Defined Opportunity Fund Inc', '2025-04-27', 0),
(67, 'OpGen, Inc.', '2025-01-22', 1),
(68, 'Dynasil Corporation of America', '2026-01-30', 1),
(69, 'Virco Manufacturing Corporation', '2026-01-15', 0),
(70, 'Colonial High Income Municipal Trust', '2026-02-18', 0),
(71, 'Neos Therapeutics, Inc.', '2026-01-12', 0),
(72, 'Western Asset Variable Rate Strategic Fund Inc.', '2025-12-07', 0),
(73, 'WisdomTree U.S. SmallCap Quality Dividend Growth Fund', '2025-09-30', 1),
(74, 'M.D.C. Holdings, Inc.', '2026-03-09', 0),
(75, 'Comfort Systems USA, Inc.', '2025-02-28', 0),
(76, 'Navient Corporation', '2026-02-04', 1),
(77, 'FS Investment Corporation', '2025-10-01', 1),
(78, 'Lehman ABS Corporation', '2025-03-07', 1),
(79, 'Lawson Products, Inc.', '2025-08-01', 1),
(80, 'One Liberty Properties, Inc.', '2025-02-21', 0),
(81, 'Silver Run Acquisition Corporation II', '2025-08-13', 0),
(82, 'Eagle Bancorp, Inc.', '2025-05-31', 1),
(83, 'Biocept, Inc.', '2025-04-14', 1),
(84, 'Merit Medical Systems, Inc.', '2025-05-13', 0),
(85, 'Aerie Pharmaceuticals, Inc.', '2025-08-06', 1),
(86, 'Keysight Technologies Inc.', '2025-05-10', 0),
(87, 'Urstadt Biddle Properties Inc.', '2026-02-09', 0),
(88, 'CafePress Inc.', '2025-08-22', 1),
(89, 'Allied World Assurance Company Holdings, AG', '2025-12-22', 0),
(90, 'BLDRS Emerging Markets 50 ADR Index Fund', '2025-10-07', 0),
(91, 'Albireo Pharma, Inc.', '2026-03-24', 1),
(92, 'Teva Pharmaceutical Industries Limited', '2025-07-21', 0),
(93, 'Cantel Medical Corp.', '2025-07-10', 1),
(94, 'TPG Specialty Lending, Inc.', '2025-05-29', 1),
(95, 'Nustar GP Holdings, LLC', '2026-04-26', 1),
(96, 'Post Holdings, Inc.', '2025-06-26', 1),
(97, 'ICON plc', '2025-10-30', 0),
(98, 'Energizer Holdings, Inc.', '2025-02-18', 0),
(99, 'Rush Enterprises, Inc.', '2025-02-08', 1),
(100, 'Shutterstock, Inc.', '2026-04-18', 1),
(101, 'Bank of Marin Bancorp', '2025-05-31', 1),
(102, 'SVB Financial Group', '2025-01-20', 0),
(103, 'NN, Inc.', '2025-10-24', 1),
(104, 'CM Finance Inc', '2026-01-06', 0),
(105, 'Waddell & Reed Financial, Inc.', '2025-04-08', 0),
(106, 'Oaktree Capital Group, LLC', '2025-01-15', 1),
(107, 'TechTarget, Inc.', '2025-08-18', 1),
(108, 'Recon Technology, Ltd.', '2025-09-04', 0),
(109, 'Banco Bilbao Viscaya Argentaria S.A.', '2026-02-11', 0),
(110, 'Safe Bulkers, Inc', '2025-05-11', 0),
(111, 'U S Concrete, Inc.', '2025-03-10', 0),
(112, 'TransAct Technologies Incorporated', '2025-02-28', 0),
(113, 'TransAct Technologies Incorporated', '2025-12-13', 1),
(114, 'Bank of Marin Bancorp', '2025-12-11', 0),
(115, 'Escalade, Incorporated', '2026-02-11', 1),
(116, 'Scudder Global High Income Fund, Inc.', '2025-08-14', 1),
(117, 'Arbor Realty Trust', '2025-11-28', 1),
(118, 'ENSCO plc', '2026-01-20', 0),
(119, 'CNO Financial Group, Inc.', '2025-01-28', 1),
(120, 'PowerShares DWA SmallCap Momentum Portfolio', '2025-02-26', 1),
(121, 'Fogo de Chao, Inc.', '2026-04-27', 0),
(122, 'First Trust New Opportunities MLP & Energy Fund', '2026-03-06', 0),
(123, 'VTTI Energy Partners LP', '2026-02-05', 1),
(124, 'PIMCO California Municipal Income Fund', '2025-10-25', 0),
(125, 'Philip Morris International Inc', '2025-08-09', 1),
(126, 'Twenty-First Century Fox, Inc.', '2025-06-06', 0),
(127, 'AbbVie Inc.', '2025-04-02', 1),
(128, 'Simon Property Group, Inc.', '2026-03-16', 1),
(129, 'Kennametal Inc.', '2025-05-15', 0),
(130, 'Digiliti Money Group, Inc.', '2025-09-05', 0),
(131, 'PHI, Inc.', '2025-01-25', 1),
(132, 'Financial Engines, Inc.', '2025-05-04', 0),
(133, 'Transcontinental Realty Investors, Inc.', '2025-10-04', 0),
(134, 'Capitol Federal Financial, Inc.', '2026-03-11', 0),
(135, 'iStar Financial Inc.', '2025-12-29', 0),
(136, 'Geron Corporation', '2026-04-10', 0),
(137, 'FIRST REPUBLIC BANK', '2026-04-06', 0),
(138, 'Fidelity National Information Services, Inc.', '2025-10-25', 1),
(139, 'FARO Technologies, Inc.', '2025-03-12', 0),
(140, 'Lianluo Smart Limited', '2025-12-01', 0),
(141, 'Weight Watchers International Inc', '2026-04-07', 0),
(142, 'Applied DNA Sciences Inc', '2025-06-06', 0),
(143, 'Citizens Holding Company', '2025-03-04', 1),
(144, 'Fulton Financial Corporation', '2026-04-16', 1),
(145, 'Viad Corp', '2025-04-15', 1),
(146, 'Horizon Technology Finance Corporation', '2025-03-20', 0),
(147, 'Silver Run Acquisition Corporation II', '2026-01-24', 0),
(148, 'Comtech Telecommunications Corp.', '2025-02-07', 0),
(149, 'Avon Products, Inc.', '2025-12-06', 0),
(150, 'Oceaneering International, Inc.', '2025-05-04', 1),
(151, 'Sunstone Hotel Investors, Inc.', '2025-06-13', 0),
(152, 'PulteGroup, Inc.', '2025-06-14', 0),
(153, 'Semiconductor  Manufacturing International Corporation', '2026-02-01', 1),
(154, 'Northwest Natural Gas Company', '2025-04-26', 1),
(155, 'Concordia International Corp.', '2026-01-04', 0),
(156, 'Moelis & Company', '2025-07-26', 1),
(157, 'RLJ Entertainment, Inc.', '2025-02-22', 1),
(158, 'Sumitomo Mitsui Financial Group Inc', '2025-02-16', 0),
(159, 'Natural Gas Services Group, Inc.', '2025-02-26', 1),
(160, 'Visteon Corporation', '2026-03-18', 1),
(161, 'Allegiance Bancshares, Inc.', '2025-06-04', 0),
(162, 'Xinyuan Real Estate Co Ltd', '2026-03-15', 0),
(163, 'Quality Systems, Inc.', '2025-10-03', 1),
(164, 'Enable Midstream Partners, LP', '2025-03-05', 1),
(165, 'Fiat Chrysler Automobiles N.V.', '2025-04-22', 1),
(166, 'Public Storage', '2025-05-13', 1),
(167, 'StoneCastle Financial Corp', '2025-10-17', 0),
(168, 'Wabco Holdings Inc.', '2026-04-01', 1),
(169, 'Vectrus, Inc.', '2025-04-24', 0),
(170, 'PS Business Parks, Inc.', '2026-03-18', 0),
(171, 'Harmony Gold Mining Company Limited', '2025-04-28', 1),
(172, 'Blackrock Core Bond Trust', '2026-04-12', 1),
(173, 'NetEase, Inc.', '2025-04-16', 1),
(174, 'Arrow DWA Tactical ETF', '2025-02-18', 1),
(175, 'Oaktree Capital Group, LLC', '2025-01-29', 1),
(176, 'Alder BioPharmaceuticals, Inc.', '2026-03-26', 1),
(177, 'Customers Bancorp, Inc', '2026-04-24', 0),
(178, 'Cognex Corporation', '2026-01-20', 1),
(179, 'Micronet Enertec Technologies, Inc.', '2025-10-31', 1),
(180, 'Global Indemnity Limited', '2026-02-11', 1),
(181, 'BioCryst Pharmaceuticals, Inc.', '2025-04-29', 1),
(182, 'Shaw Communications Inc.', '2025-09-23', 0),
(183, 'Pimco Income Opportunity Fund', '2025-04-16', 1),
(184, 'Teva Pharmaceutical Industries Limited', '2025-02-26', 1),
(185, 'Duff & Phelps Global Utility Income Fund Inc.', '2025-10-02', 1),
(186, 'Mitel Networks Corporation', '2025-04-24', 1),
(187, 'Blackrock MuniHoldings California Quality Fund,  Inc.', '2025-04-15', 0),
(188, 'Townsquare Media, Inc.', '2025-09-02', 0),
(189, 'Vanguard International Dividend Appreciation ETF', '2025-08-10', 1),
(190, 'John B. Sanfilippo & Son, Inc.', '2025-05-31', 0),
(191, 'Jernigan Capital, Inc.', '2025-07-22', 0),
(192, 'NV5 Global, Inc.', '2025-05-29', 0),
(193, 'United Rentals, Inc.', '2025-11-04', 0),
(194, 'Kennedy-Wilson Holdings Inc.', '2025-01-15', 1),
(195, 'Valmont Industries, Inc.', '2025-03-28', 1),
(196, 'BJ\'s Restaurants, Inc.', '2025-03-13', 1),
(197, 'Aevi Genomic Medicine, Inc.', '2025-12-17', 1),
(198, 'Antero Resources Corporation', '2025-06-24', 1),
(199, 'Briggs & Stratton Corporation', '2025-07-28', 0),
(200, 'PIMCO Strategic Income Fund, Inc.', '2026-04-16', 1),
(201, 'Belden Inc', '2025-09-29', 1),
(202, 'Retail Properties of America, Inc.', '2025-03-19', 0),
(203, 'Pioneer Floating Rate Trust', '2026-01-25', 1),
(204, 'Bank of America Corporation', '2026-01-20', 0),
(205, 'Universal Logistics Holdings, Inc.', '2026-04-23', 0),
(206, 'Centrais Electricas Brasileiras S.A.- Eletrobras', '2026-03-13', 1),
(207, 'John Hancock Investors Trust', '2025-08-15', 0),
(208, 'PowerShares Dividend Achievers Portfolio', '2025-05-20', 1),
(209, 'Heron Therapeutics, Inc.  ', '2025-12-03', 1),
(210, 'Tutor Perini Corporation', '2025-07-15', 1),
(211, 'Rush Enterprises, Inc.', '2025-04-13', 0),
(212, 'Ritter Pharmaceuticals, Inc.', '2025-06-12', 1),
(213, 'U.S. Physical Therapy, Inc.', '2025-09-08', 1),
(214, 'Summit Midstream Partners, LP', '2025-06-12', 0),
(215, 'Puma Biotechnology Inc', '2025-11-20', 1),
(216, 'Monogram Residential Trust, Inc.', '2025-09-17', 0),
(217, 'Nanometrics Incorporated', '2025-04-03', 0),
(218, 'Schmitt Industries, Inc.', '2025-01-18', 1),
(219, 'Vipshop Holdings Limited', '2025-04-14', 1),
(220, 'Allstate Corporation (The)', '2025-12-15', 1),
(221, 'Enduro Royalty Trust', '2025-06-06', 1),
(222, 'Telephone and Data Systems, Inc.', '2025-08-29', 1),
(223, 'The9 Limited', '2025-01-22', 1),
(224, 'TransAct Technologies Incorporated', '2025-11-23', 0),
(225, 'Matlin & Partners Acquisition Corporation', '2026-01-21', 1),
(226, 'Omega Flex, Inc.', '2026-04-05', 1),
(227, 'Alere Inc.', '2026-04-12', 1),
(228, 'Methanex Corporation', '2025-02-12', 1),
(229, 'Iridium Communications Inc', '2025-12-03', 1),
(230, 'Apptio, Inc.', '2026-04-20', 1),
(231, 'Chipotle Mexican Grill, Inc.', '2025-08-07', 1),
(232, 'Vornado Realty Trust', '2025-03-21', 1),
(233, 'Heico Corporation', '2025-12-23', 0),
(234, 'iShares GNMA Bond ETF', '2025-01-31', 0),
(235, 'Calamos Global Dynamic Income Fund', '2026-04-13', 1),
(236, 'Global Blood Therapeutics, Inc.', '2026-03-17', 0),
(237, 'iStar Financial Inc.', '2025-01-22', 1),
(238, 'PennantPark Floating Rate Capital Ltd.', '2026-03-03', 1),
(239, 'iShares Morningstar Mid-Cap ETF', '2025-07-26', 0),
(240, 'Otonomy, Inc.', '2025-05-10', 0),
(241, 'CBL & Associates Properties, Inc.', '2025-11-08', 0),
(242, 'Netflix, Inc.', '2025-12-17', 1),
(243, 'Albany International Corporation', '2026-03-11', 0),
(244, 'Nuveen Global High Income Fund', '2025-08-24', 0),
(245, 'Baxter International Inc.', '2025-06-24', 1),
(246, 'Kayne Anderson Acquisition Corp.', '2025-01-25', 1),
(247, 'AllianzGI Diversified Income & Convertible Fund', '2025-08-23', 1),
(248, 'Staffing 360 Solutions, Inc.', '2026-02-24', 0),
(249, 'Equinix, Inc.', '2025-04-17', 0),
(250, 'Fidelity Southern Corporation', '2025-07-22', 1),
(251, 'Horizon Pharma plc', '2025-08-21', 0),
(252, 'Delek Logistics Partners, L.P.', '2025-03-17', 0),
(253, 'MFC Bancorp Ltd.', '2025-09-18', 1),
(254, 'Summit Midstream Partners, LP', '2025-05-28', 1),
(255, 'Morgan Stanley Asia-Pacific Fund, Inc.', '2026-01-31', 1),
(256, 'Tenneco Inc.', '2025-08-18', 1),
(257, 'Moxian, Inc.', '2025-10-22', 1),
(258, 'General American Investors, Inc.', '2025-10-07', 0),
(259, 'Turquoise Hill Resources Ltd.', '2025-02-07', 1),
(260, 'InfoSonics Corp', '2026-04-20', 0),
(261, 'Synovus Financial Corp.', '2025-12-17', 0),
(262, 'Intel Corporation', '2025-12-19', 1),
(263, 'Bioanalytical Systems, Inc.', '2025-12-01', 1),
(264, 'Tri Continental Corporation', '2025-02-23', 1),
(265, 'Cree, Inc.', '2025-12-04', 0),
(266, 'Maiden Holdings, Ltd.', '2025-04-09', 0),
(267, 'Entegra Financial Corp.', '2025-10-20', 1),
(268, 'Anixter International Inc.', '2026-02-17', 0),
(269, 'Hershey Company (The)', '2025-08-16', 1),
(270, 'American International Group, Inc.', '2025-12-10', 1),
(271, 'Archrock Partners, L.P.', '2025-05-31', 0),
(272, 'M B T Financial Corp', '2025-07-03', 0),
(273, 'DDR Corp.', '2025-10-29', 0),
(274, 'Retail Properties of America, Inc.', '2025-10-10', 0),
(275, 'Capitala Finance Corp.', '2025-12-23', 0),
(276, 'Entercom Communications Corporation', '2025-10-20', 0),
(277, 'Investors Title Company', '2025-06-15', 1),
(278, 'Cytosorbents Corporation', '2025-07-25', 0),
(279, 'USLIFE Income Fund, Inc.', '2025-04-05', 0),
(280, 'CHS Inc', '2026-03-04', 1),
(281, 'Shenandoah Telecommunications Co', '2025-11-22', 0),
(282, 'Ovid Therapeutics Inc.', '2025-04-20', 0),
(283, 'Qwest Corporation', '2025-07-05', 0),
(284, 'Lincoln Educational Services Corporation', '2025-02-16', 1),
(285, 'HP Inc.', '2025-11-11', 0),
(286, 'Validea Market Legends ETF', '2025-01-21', 1),
(287, 'OneBeacon Insurance Group, Ltd.', '2025-03-01', 1),
(288, 'Aduro Biotech, Inc.', '2026-01-17', 0),
(289, 'Balchem Corporation', '2025-12-14', 1),
(290, 'Global Indemnity Limited', '2026-02-02', 0),
(291, 'CF Industries Holdings, Inc.', '2025-04-29', 1),
(292, 'Nuveen Short Duration Credit Opportunities Fund', '2025-09-29', 0),
(293, 'Northern Trust Corporation', '2025-05-11', 1),
(294, 'WAVE Life Sciences Ltd.', '2026-04-13', 1),
(295, 'K12 Inc', '2025-10-29', 1),
(296, 'MabVax Therapeutics Holdings, Inc.', '2025-05-24', 0),
(297, 'Sabre Corporation', '2025-04-29', 1),
(298, 'PowerShares S&P SmallCap Health Care Portfolio', '2026-02-21', 1),
(299, 'Telephone and Data Systems, Inc.', '2025-06-13', 1),
(300, 'Entergy Arkansas, Inc.', '2025-07-09', 0),
(301, 'Townsquare Media, Inc.', '2026-01-30', 0),
(302, 'Kansas City Southern', '2025-11-05', 0),
(303, 'Scorpio Bulkers Inc.', '2025-05-24', 1),
(304, 'Domtar Corporation', '2025-11-24', 0),
(305, 'Rogers Corporation', '2026-01-31', 0),
(306, 'Allison Transmission Holdings, Inc.', '2025-11-23', 1),
(307, 'Bio-Path Holdings, Inc.', '2025-04-15', 0),
(308, 'Boingo Wireless, Inc.', '2026-04-13', 1),
(309, 'Nuveen Tax-Advantaged Total Return Strategy Fund', '2025-08-24', 1),
(310, 'ChemoCentryx, Inc.', '2026-02-24', 1),
(311, 'Aegon NV', '2025-03-12', 1),
(312, 'Tempur Sealy International, Inc.', '2025-03-13', 0),
(313, 'ScanSource, Inc.', '2025-10-22', 1),
(314, 'Apollo Commercial Real Estate Finance', '2025-02-01', 0),
(315, 'Shaw Communications Inc.', '2026-01-24', 0),
(316, 'Haynes International, Inc.', '2026-03-09', 0),
(317, 'Applied DNA Sciences Inc', '2025-05-14', 0),
(318, 'Garmin Ltd.', '2025-09-17', 1),
(319, 'Photronics, Inc.', '2025-12-17', 0),
(320, 'OMNOVA Solutions Inc.', '2025-08-14', 0),
(321, 'Axar Acquisition Corp.', '2025-09-25', 0),
(322, 'TravelCenters of America LLC', '2026-03-11', 1),
(323, 'Dollar Tree, Inc.', '2025-03-29', 1),
(324, 'Basic Energy Services, Inc.', '2025-03-17', 1),
(325, 'WPX Energy, Inc.', '2025-01-17', 0),
(326, 'PrivateBancorp, Inc.', '2025-12-21', 1),
(327, 'Norfolk Souther Corporation', '2025-07-13', 1),
(328, 'Mercury Systems Inc', '2025-11-09', 0),
(329, 'iPath US Treasury Long Bond Bear ETN', '2025-03-22', 0),
(330, 'AppFolio, Inc.', '2026-04-22', 0),
(331, 'First Trust Eurozone AlphaDEX ETF', '2025-10-29', 1),
(332, 'Hilton Worldwide Holdings Inc.', '2025-05-07', 1),
(333, 'Taubman Centers, Inc.', '2026-01-24', 1),
(334, 'Union Pacific Corporation', '2026-01-26', 1),
(335, 'Gladstone Land Corporation', '2025-01-22', 0),
(336, 'Oncobiologics, Inc.', '2025-12-18', 0),
(337, 'Tecnoglass Inc.', '2026-04-30', 0),
(338, 'Denbury Resources Inc.', '2026-03-26', 0),
(339, 'Hanwha Q CELLS Co., Ltd. ', '2025-02-20', 1),
(340, 'American Homes 4 Rent', '2026-04-17', 1),
(341, 'MGIC Investment Corporation', '2025-10-25', 1),
(342, 'Vanda Pharmaceuticals Inc.', '2025-11-12', 1),
(343, 'Validus Holdings, Ltd.', '2026-04-19', 1),
(344, 'Union Bankshares Corporation', '2025-08-22', 1),
(345, 'J P Morgan Chase & Co', '2025-03-30', 0),
(346, 'ORBCOMM Inc.', '2025-05-27', 0),
(347, 'Kilroy Realty Corporation', '2026-01-30', 0),
(348, 'Western Alliance Bancorporation', '2026-01-05', 1),
(349, 'Waste Management, Inc.', '2025-02-05', 0),
(350, 'First Trust High Income ETF', '2025-07-21', 1),
(351, 'PowerShares DWA Utilities Momentum Portfolio', '2025-05-08', 0),
(352, 'DoubleLine Income Solutions Fund', '2025-09-25', 1),
(353, 'Baldwin & Lyons, Inc.', '2026-01-19', 0),
(354, 'NuVasive, Inc.', '2025-12-26', 1),
(355, 'Fifth Third Bancorp', '2025-03-26', 1),
(356, 'First US Bancshares, Inc.', '2026-01-04', 1),
(357, 'Public Storage', '2025-09-12', 1),
(358, 'M B T Financial Corp', '2026-02-26', 0),
(359, 'Garrison Capital Inc.', '2025-09-08', 1),
(360, 'Ocwen Financial Corporation', '2025-11-27', 0),
(361, 'Take-Two Interactive Software, Inc.', '2025-12-14', 0),
(362, 'Spark Therapeutics, Inc.', '2025-01-12', 0),
(363, 'Hersha Hospitality Trust', '2025-03-18', 0),
(364, 'Monolithic Power Systems, Inc.', '2025-07-28', 0),
(365, 'China Distance Education Holdings Limited', '2025-07-01', 0),
(366, 'Akamai Technologies, Inc.', '2025-12-19', 0),
(367, 'FRONTEO, Inc.', '2025-03-05', 0),
(368, 'American Railcar Industries, Inc.', '2025-05-30', 1),
(369, 'Unum Group', '2025-05-15', 1),
(370, 'iSectors Post-MPT Growth ETF', '2025-07-25', 0),
(371, 'Innovative Solutions and Support, Inc.', '2025-03-28', 0),
(372, 'Pro-Dex, Inc.', '2025-09-26', 0),
(373, 'NXP Semiconductors N.V.', '2025-02-07', 1),
(374, 'Nutraceutical International Corporation', '2025-02-04', 0),
(375, 'Ellington Financial LLC', '2025-12-02', 0),
(376, 'THL Credit, Inc.', '2025-05-25', 1),
(377, 'Capital One Financial Corporation', '2025-06-24', 1),
(378, 'Compania Cervecerias Unidas, S.A.', '2025-08-28', 0),
(379, 'CIRCOR International, Inc.', '2025-02-16', 1),
(380, 'P & F Industries, Inc.', '2025-05-11', 0),
(381, 'Hercules Capital, Inc.', '2025-10-14', 1),
(382, 'CardConnect Corp.', '2026-03-26', 1),
(383, 'Steel Dynamics, Inc.', '2025-08-07', 1),
(384, 'Codorus Valley Bancorp, Inc', '2025-10-19', 0),
(385, 'Monogram Residential Trust, Inc.', '2025-04-05', 1),
(386, 'Auburn National Bancorporation, Inc.', '2025-12-05', 0),
(387, 'GenVec, Inc.', '2026-03-18', 1),
(388, 'Central Garden & Pet Company', '2025-08-17', 0),
(389, 'PowerShares DWA Consumer Staples Momentum Portfolio', '2025-09-25', 0),
(390, 'Hyatt Hotels Corporation', '2025-05-03', 0),
(391, 'Korn/Ferry International', '2025-12-07', 1),
(392, 'ABIOMED, Inc.', '2025-08-23', 0),
(393, 'Akoustis Technologies, Inc.', '2025-10-25', 1),
(394, 'WisdomTree Interest Rate Hedged High Yield Bond Fund', '2026-01-24', 0),
(395, 'WisdomTree Western Asset Unconstrained Bond Fund', '2026-02-08', 1),
(396, 'Nathan\'s Famous, Inc.', '2025-08-22', 0),
(397, 'Reis, Inc', '2025-06-10', 0),
(398, 'Goldman Sachs Group, Inc. (The)', '2025-10-19', 0),
(399, 'Apollo Global Management, LLC', '2025-11-13', 0),
(400, 'iFresh Inc.', '2025-06-10', 1),
(401, 'China Finance Online Co. Limited', '2025-06-27', 1),
(402, 'Alliant Energy Corporation', '2025-03-13', 1),
(403, 'Lancaster Colony Corporation', '2025-08-15', 0),
(404, 'PetMed Express, Inc.', '2025-04-05', 0),
(405, 'Intrexon Corporation', '2025-02-26', 0),
(406, 'PowerShares S&P SmallCap Materials Portfolio', '2026-04-11', 1),
(407, 'Gamco Investors, Inc.', '2025-07-29', 1),
(408, 'New Germany Fund, Inc. (The)', '2025-01-17', 1),
(409, 'Dreyfus Strategic Municipal Bond Fund, Inc.', '2026-04-22', 1),
(410, 'ViaSat, Inc.', '2026-01-30', 0),
(411, 'Kayne Anderson Energy Total Return Fund, Inc.', '2026-02-16', 0),
(412, 'Intrawest Resorts Holdings, Inc.', '2025-09-05', 1),
(413, 'iShares S&P India Nifty 50 Index Fund', '2025-10-03', 0),
(414, 'GSI Technology, Inc.', '2025-07-21', 0),
(415, 'New Residential Investment Corp.', '2025-11-12', 0),
(416, 'Caesars Entertainment Corporation', '2025-07-18', 0),
(417, 'First Trust/Aberdeen Global Opportunity Income Fund', '2026-04-29', 1),
(418, 'ARMOUR Residential REIT, Inc.', '2025-12-21', 0),
(419, 'Teva Pharmaceutical Industries Limited', '2025-06-25', 0),
(420, 'Community West Bancshares', '2025-03-09', 0),
(421, 'Bruker Corporation', '2025-06-15', 1),
(422, 'Liberty Media Corporation', '2025-01-18', 1),
(423, 'Royal Bank Scotland plc (The)', '2025-09-07', 0),
(424, 'American Assets Trust, Inc.', '2025-05-30', 1),
(425, 'Simon Property Group, Inc.', '2026-04-16', 1),
(426, 'Encore Wire Corporation', '2025-11-02', 0),
(427, 'Alaska Air Group, Inc.', '2025-12-20', 0),
(428, 'Littelfuse, Inc.', '2025-02-11', 1),
(429, 'Laredo Petroleum, Inc.', '2025-04-13', 1),
(430, 'Nustar Energy L.P.', '2026-04-19', 1),
(431, 'Tarena International, Inc.', '2026-01-22', 1),
(432, 'Deswell Industries, Inc.', '2026-02-03', 1),
(433, 'Fortress Biotech, Inc.', '2025-04-13', 0),
(434, 'CBS Corporation', '2025-10-21', 0),
(435, 'Donnelley Financial Solutions, Inc.', '2025-02-26', 0),
(436, 'Piper Jaffray Companies', '2026-02-23', 0),
(437, 'Altria Group', '2026-03-13', 1),
(438, 'The Dixie Group, Inc.', '2025-03-30', 0),
(439, 'ShotSpotter, Inc.', '2025-05-20', 1),
(440, 'Kinder Morgan, Inc.', '2025-10-26', 0),
(441, 'Steel Partners Holdings LP', '2025-10-06', 0),
(442, 'Prudential Bancorp, Inc.', '2025-09-08', 1),
(443, 'PC Connection, Inc.', '2025-05-25', 0),
(444, 'Codexis, Inc.', '2025-10-14', 0),
(445, 'City Office REIT, Inc.', '2026-01-24', 1),
(446, 'Landauer, Inc.', '2025-05-05', 0),
(447, 'Tonix Pharmaceuticals Holding Corp.', '2025-06-15', 0),
(448, 'Qiagen N.V.', '2025-08-05', 0),
(449, 'Edge Therapeutics, Inc.', '2026-04-08', 1),
(450, 'C.H. Robinson Worldwide, Inc.', '2025-07-21', 1),
(451, 'Phoenix New Media Limited', '2025-03-02', 1),
(452, 'Acacia Research Corporation', '2025-03-11', 0),
(453, 'Bruker Corporation', '2025-05-27', 0),
(454, 'Axcelis Technologies, Inc.', '2026-02-19', 0),
(455, 'BofI Holding, Inc.', '2025-08-13', 1),
(456, 'MidSouth Bancorp', '2025-02-28', 0),
(457, 'EP Energy Corporation', '2025-05-07', 0),
(458, 'Seaspan Corporation', '2025-06-28', 0),
(459, 'FactSet Research Systems Inc.', '2025-02-16', 0),
(460, 'Dupont Fabros Technology, Inc.', '2025-08-05', 1),
(461, 'Just Energy Group, Inc.', '2025-05-15', 0),
(462, 'PAR Technology Corporation', '2026-02-15', 0),
(463, 'Crown Castle International Corporation', '2025-09-25', 1),
(464, 'Hope Bancorp, Inc.', '2025-02-13', 0),
(465, 'ABM Industries Incorporated', '2025-09-10', 1),
(466, 'Rexford Industrial Realty, Inc.', '2025-06-03', 1),
(467, 'Cincinnati Financial Corporation', '2025-11-02', 1),
(468, 'Nuveen Pennsylvania Quality Municipal Income Fund', '2025-10-25', 0),
(469, 'Xcerra Corporation', '2025-05-16', 0),
(470, 'Antero Midstream GP LP', '2025-07-20', 1),
(471, 'Dreyfus Municipal Bond Infrastructure Fund, Inc.', '2025-06-14', 1),
(472, 'Parke Bancorp, Inc.', '2026-04-13', 1),
(473, 'Yum China Holdings, Inc.', '2025-04-12', 1),
(474, 'THL Credit, Inc.', '2025-04-23', 1),
(475, 'Bank of Marin Bancorp', '2025-04-25', 0),
(476, 'Chesapeake Energy Corporation', '2026-01-17', 1),
(477, 'ClearBridge Energy MLP Opportunity Fund Inc.', '2026-02-07', 1),
(478, 'Regal Beloit Corporation', '2026-04-22', 1),
(479, 'iShares FTSE EPRA/NAREIT Global Real Estate ex-U.S. Index Fund', '2025-01-19', 1),
(480, 'Western Gas Partners, LP', '2025-05-04', 1),
(481, 'AG Mortgage Investment Trust, Inc.', '2026-04-01', 1),
(482, 'Halcon Resources Corporation', '2025-05-11', 0),
(483, 'Seadrill Partners LLC', '2025-09-22', 1),
(484, 'Vantage Energy Acquisition Corp.', '2025-07-13', 1),
(485, 'Black Diamond, Inc.', '2025-09-19', 0),
(486, 'Balchem Corporation', '2025-01-12', 1),
(487, 'Rigel Pharmaceuticals, Inc.', '2025-06-09', 0),
(488, 'Criteo S.A.', '2025-10-03', 0),
(489, 'Ideal Power Inc.', '2025-07-26', 1),
(490, 'American National Insurance Company', '2025-12-31', 1),
(491, 'MoSys, Inc.', '2025-08-06', 0),
(492, 'Denbury Resources Inc.', '2025-05-23', 1),
(493, 'Voya Global Advantage and Premium Opportunity Fund', '2025-11-27', 1),
(494, 'Impinj, Inc.', '2025-03-14', 0),
(495, 'First Bancorp, Inc (ME)', '2025-12-28', 0),
(496, 'Toyota Motor Corp Ltd Ord', '2025-02-16', 0),
(497, 'KapStone Paper and Packaging Corporation', '2025-08-06', 0),
(498, 'J.B. Hunt Transport Services, Inc.', '2025-04-24', 0),
(499, 'BlackRock Strategic Municipal Trust Inc. (The)', '2025-10-25', 1),
(500, 'Mid-Con Energy Partners, LP', '2025-05-14', 1),
(501, 'NorthWestern Corporation', '2025-05-25', 0),
(502, 'Fifth Street Finance Corp.', '2026-02-25', 1),
(503, 'Geospace Technologies Corporation', '2025-09-05', 0),
(504, 'Yelp Inc.', '2025-07-31', 1),
(505, 'Signature Bank', '2026-01-30', 0),
(506, 'Famous Dave\'s of America, Inc.', '2025-06-09', 0),
(507, 'LendingTree, Inc.', '2025-08-06', 0),
(508, 'First Financial Corporation Indiana', '2025-12-14', 0),
(509, 'Brookline Bancorp, Inc.', '2025-07-23', 0),
(510, 'Sprague Resources LP', '2026-03-14', 1),
(511, 'Microsemi Corporation', '2025-07-11', 1),
(512, 'JM Global Holding Company', '2025-06-27', 0),
(513, 'Concordia International Corp.', '2025-03-28', 1),
(514, 'First Trust Indxx Global Natural Resources Income ETF', '2025-03-25', 0),
(515, 'Cohen & Steers Global Income Builder, Inc.', '2026-03-18', 0),
(516, 'Nuveen Global High Income Fund', '2025-03-15', 0),
(517, 'Noble Midstream Partners LP', '2025-01-21', 1),
(518, 'Northeast Bancorp', '2025-07-21', 1),
(519, 'First Trust Specialty Finance and Financial Opportunities Fund', '2025-03-07', 0),
(520, 'Ares Management L.P.', '2026-04-16', 0),
(521, 'CEVA, Inc.', '2025-04-05', 1),
(522, 'Aerie Pharmaceuticals, Inc.', '2025-02-16', 0),
(523, 'Nuveen Global High Income Fund', '2025-07-24', 1),
(524, 'Allergan plc.', '2025-07-03', 1),
(525, 'Southwest Airlines Company', '2025-06-11', 1),
(526, 'Sina Corporation', '2025-12-18', 1),
(527, 'Cohen & Steers Infrastructure Fund, Inc', '2025-07-02', 0),
(528, 'RMG Networks Holding Corporation', '2025-03-19', 1),
(529, 'KNOT Offshore Partners LP', '2025-10-10', 1),
(530, 'Whiting Petroleum Corporation', '2026-03-15', 1),
(531, 'Principal Price Setters Index ETF', '2025-02-24', 1),
(532, 'T-Mobile US, Inc.', '2025-07-30', 0),
(533, 'GGP Inc.', '2026-04-26', 0),
(534, 'Alliance Resource Partners, L.P.', '2025-04-11', 1),
(535, 'Sequential Brands Group, Inc.', '2026-04-27', 1),
(536, 'Liberty Broadband Corporation', '2025-03-26', 0),
(537, 'CoreLogic, Inc.', '2025-05-06', 0),
(538, 'Inter Parfums, Inc.', '2025-08-01', 0),
(539, 'Viacom Inc.', '2025-05-07', 0),
(540, 'Federal Agricultural Mortgage Corporation', '2025-05-02', 1),
(541, 'Chimerix, Inc.', '2026-04-12', 0),
(542, 'National Health Investors, Inc.', '2025-06-27', 0),
(543, 'Brinker International, Inc.', '2025-05-16', 1),
(544, 'Titan International, Inc.', '2025-02-03', 0),
(545, 'M I Acquisitions, Inc.', '2025-03-12', 0),
(546, 'Blackrock MuniAssets Fund, Inc.', '2025-04-10', 0),
(547, 'Sabre Corporation', '2025-12-26', 0),
(548, 'CafePress Inc.', '2025-10-16', 1),
(549, 'TapImmune Inc.', '2026-03-19', 0),
(550, 'Eaton Vance Senior Income Trust', '2026-03-01', 0),
(551, 'Wix.com Ltd.', '2025-09-04', 0),
(552, 'Sabine Royalty Trust', '2025-05-09', 1),
(553, 'Tekla World Healthcare Fund', '2025-03-11', 1),
(554, 'Blackrock Enhanced Government Fund, Inc', '2026-01-18', 0),
(555, 'TELUS Corporation', '2025-02-11', 0),
(556, 'Nomura Holdings Inc ADR', '2025-09-19', 1),
(557, 'Federal Agricultural Mortgage Corporation', '2026-01-07', 1),
(558, 'Spectra Energy Partners, LP', '2025-05-14', 1),
(559, 'Adverum Biotechnologies, Inc.', '2026-04-25', 0),
(560, 'CoreSite Realty Corporation', '2026-04-13', 0),
(561, 'First Trust Intermediate Duration Preferred & Income Fund', '2025-10-15', 1),
(562, 'Teekay Corporation', '2025-10-21', 0),
(563, 'National General Holdings Corp', '2025-10-09', 1),
(564, 'Cincinnati Financial Corporation', '2025-03-22', 1),
(565, 'Dermira, Inc.', '2025-08-06', 0),
(566, 'Community Healthcare Trust Incorporated', '2026-03-12', 0),
(567, 'JetPay Corporation', '2026-02-24', 1),
(568, 'Dorman Products, Inc.', '2025-07-04', 0),
(569, 'Tecnoglass Inc.', '2025-03-19', 1),
(570, 'Gores Holdings II, Inc.', '2025-07-14', 1),
(571, 'Skyline Medical Inc.', '2025-01-28', 1),
(572, 'Western Asset High Income Fund II Inc.', '2025-11-25', 1),
(573, 'Strata Skin Sciences, Inc.', '2025-10-10', 0),
(574, 'Mosaic Company (The)', '2025-04-19', 0),
(575, 'RBC Bearings Incorporated', '2025-03-31', 1),
(576, 'Global X SuperDividend REIT ETF', '2026-03-12', 0),
(577, 'Intersections, Inc.', '2025-01-20', 1),
(578, 'ROBO Global Robotics and Automation Index ETF', '2025-06-13', 1),
(579, 'Morgan Stanley', '2025-02-10', 0),
(580, 'Pluristem Therapeutics, Inc.', '2025-09-02', 0),
(581, 'Main Street Capital Corporation', '2025-02-18', 0),
(582, 'Trevena, Inc.', '2025-04-28', 1),
(583, 'M.D.C. Holdings, Inc.', '2025-09-11', 0),
(584, 'Kilroy Realty Corporation', '2025-07-24', 0),
(585, 'Horizon Technology Finance Corporation', '2025-05-22', 0),
(586, 'KCAP Financial, Inc.', '2025-11-22', 0),
(587, 'Telecom Italia S.P.A.', '2025-08-23', 0),
(588, 'Tellurian Inc.', '2025-12-25', 0),
(589, 'IDEX Corporation', '2026-04-28', 1),
(590, 'PPL Capital Funding, Inc.', '2025-02-12', 1),
(591, 'Alcobra Ltd.', '2025-05-15', 1),
(592, 'Ryanair Holdings plc', '2025-03-23', 0),
(593, 'Cooper Tire & Rubber Company', '2026-01-24', 1),
(594, 'Sierra Oncology, Inc.', '2025-10-27', 0),
(595, 'Acco Brands Corporation', '2025-03-19', 1),
(596, 'BlackRock Credit Allocation Income Trust', '2026-01-13', 0),
(597, 'PetMed Express, Inc.', '2025-06-06', 1),
(598, 'Westlake Chemical Corporation', '2025-09-12', 0),
(599, 'AMN Healthcare Services Inc', '2026-04-27', 1),
(600, 'Templeton Dragon Fund, Inc.', '2025-10-21', 0),
(601, 'Computer Task Group, Incorporated', '2025-10-23', 1),
(602, 'Pharmerica Corporation', '2025-02-14', 0),
(603, 'Sanderson Farms, Inc.', '2025-02-07', 0),
(604, 'TiGenix', '2026-02-24', 0),
(605, 'Soligenix, Inc.', '2025-09-25', 1),
(606, 'Snyder\'s-Lance, Inc.', '2025-10-28', 0),
(607, 'Stifel Financial Corporation', '2025-08-21', 0),
(608, 'Customers Bancorp, Inc', '2026-04-20', 1),
(609, 'Iron Mountain Incorporated', '2025-11-23', 1),
(610, 'Hailiang Education Group Inc.', '2025-06-19', 1),
(611, 'WildHorse Resource Development Corporation', '2025-07-20', 1),
(612, 'Guangshen Railway Company Limited', '2025-07-23', 1),
(613, 'Total S.A.', '2025-05-01', 1),
(614, 'INC Research Holdings, Inc.', '2025-11-19', 0),
(615, 'Pingtan Marine Enterprise Ltd.', '2026-04-02', 1),
(616, 'Overstock.com, Inc.', '2025-09-03', 1),
(617, 'Regal Beloit Corporation', '2026-04-04', 1),
(618, 'RBC Bearings Incorporated', '2025-09-04', 0),
(619, 'MainSource Financial Group, Inc.', '2026-04-02', 0),
(620, 'Vocera Communications, Inc.', '2026-01-11', 1),
(621, 'Sussex Bancorp', '2025-06-20', 1),
(622, 'Liberty Expedia Holdings, Inc.', '2026-03-19', 1),
(623, 'SGOCO Group, Ltd', '2025-04-09', 0),
(624, 'Hewlett Packard Enterprise Company', '2025-09-14', 1),
(625, 'First Trust Eurozone AlphaDEX ETF', '2026-04-07', 1),
(626, 'Workday, Inc.', '2025-06-13', 1),
(627, 'ASA Gold and Precious Metals Limited', '2026-01-25', 0),
(628, 'Quality Care Properties, Inc.', '2026-05-03', 0),
(629, 'Canada Goose Holdings Inc.', '2025-11-12', 0),
(630, 'Precision Drilling Corporation', '2025-03-22', 1),
(631, 'Silicom Ltd', '2026-04-21', 0),
(632, 'Ruth\'s Hospitality Group, Inc.', '2025-01-21', 0),
(633, 'Intrepid Potash, Inc', '2025-01-17', 1),
(634, 'Liberty TripAdvisor Holdings, Inc.', '2025-05-02', 0),
(635, 'China Lodging Group, Limited', '2025-06-10', 1),
(636, 'World Wrestling Entertainment, Inc.', '2025-12-09', 0),
(637, 'BioMarin Pharmaceutical Inc.', '2025-10-06', 1),
(638, 'NantHealth, Inc.', '2025-12-02', 0),
(639, 'MicroStrategy Incorporated', '2025-10-12', 1),
(640, 'Norwood Financial Corp.', '2025-09-20', 1),
(641, 'Discover Financial Services', '2025-07-28', 1),
(642, 'Severn Bancorp Inc', '2025-09-11', 1),
(643, 'Electrum Special Acquisition Corporation', '2025-07-20', 0),
(644, 'MetLife, Inc.', '2026-01-30', 1),
(645, 'PIMCO Municipal Income Fund', '2025-02-13', 0),
(646, 'Gabelli Dividend', '2025-12-05', 0),
(647, 'Liquidity Services, Inc.', '2025-10-11', 0),
(648, 'Sanchez Energy Corporation', '2026-01-30', 0),
(649, 'FlexShares STOXX Global ESG Impact Index Fund', '2025-11-22', 1),
(650, 'Stoneridge, Inc.', '2026-03-22', 1),
(651, 'First Trust Nasdaq Retail ETF', '2025-02-23', 0),
(652, 'Yintech Investment Holdings Limited', '2025-11-14', 0),
(653, 'Alphabet Inc.', '2026-03-05', 0),
(654, 'Yum! Brands, Inc.', '2025-09-04', 1),
(655, 'Prima BioMed Ltd', '2025-05-10', 0),
(656, 'ObsEva SA', '2026-03-01', 0),
(657, 'Reading International Inc', '2026-04-24', 1),
(658, 'Orion Energy Systems, Inc.', '2025-08-03', 0),
(659, 'Bridge Bancorp, Inc.', '2025-08-10', 0),
(660, 'Virtus Global Multi-Sector Income Fund', '2025-04-09', 1),
(661, 'Matador Resources Company', '2026-01-24', 1),
(662, 'HomeTown Bankshares Corporation', '2025-06-15', 1),
(663, 'Greenlight Reinsurance, Ltd.', '2025-11-02', 1),
(664, 'Atomera Incorporated', '2025-06-22', 0),
(665, 'Ecopetrol S.A.', '2025-12-08', 0),
(666, 'China Natural Resources, Inc.', '2025-01-29', 0),
(667, 'Jensyn Acquistion Corp.', '2025-07-23', 1),
(668, 'New York & Company, Inc.', '2025-07-23', 0),
(669, 'Encore Capital Group Inc', '2025-08-19', 0),
(670, 'Recro Pharma, Inc.', '2026-02-08', 0),
(671, 'Maiden Holdings, Ltd.', '2025-01-24', 1),
(672, 'Kirby Corporation', '2026-03-18', 0),
(673, 'Seaspan Corporation', '2026-03-24', 1),
(674, 'Amerco', '2025-03-28', 0),
(675, 'Argo Group International Holdings, Ltd.', '2025-02-18', 0),
(676, 'American Vanguard Corporation', '2025-12-28', 1),
(677, 'MTGE Investment Corp.', '2025-02-05', 1),
(678, 'Amarin Corporation plc', '2025-01-16', 1),
(679, 'Costamare Inc.', '2025-06-03', 0),
(680, 'Simpson Manufacturing Company, Inc.', '2025-11-27', 1),
(681, 'Cellect Biotechnology Ltd.', '2025-08-14', 1),
(682, 'TerraForm Power, Inc.', '2026-03-09', 0),
(683, 'Stericycle, Inc.', '2025-10-19', 1),
(684, 'U.S. Auto Parts Network, Inc.', '2025-02-02', 1),
(685, 'JetPay Corporation', '2025-05-15', 1),
(686, 'Sangamo Therapeutics, Inc.', '2025-02-22', 0),
(687, 'RAIT Financial Trust', '2026-01-11', 1),
(688, 'Healthcare Realty Trust Incorporated', '2025-08-09', 1),
(689, 'IRSA Inversiones Y Representaciones S.A.', '2026-04-16', 0),
(690, 'First Trust RBA Quality Income ETF', '2025-02-23', 0),
(691, 'CoreLogic, Inc.', '2025-02-06', 1),
(692, 'First Trust Small Cap Growth AlphaDEX Fund', '2026-04-11', 1),
(693, 'iShares S&P Global Timber & Forestry Index Fund', '2025-01-22', 1),
(694, 'Verastem, Inc.', '2025-02-09', 1),
(695, 'Gores Holdings II, Inc.', '2025-08-17', 1),
(696, 'Atara Biotherapeutics, Inc.', '2025-12-21', 0),
(697, 'Ford Motor Company', '2025-03-23', 1),
(698, 'Blackrock Global', '2025-02-14', 1),
(699, 'Diana Containerships Inc.', '2025-09-10', 1),
(700, 'Gladstone Land Corporation', '2026-05-02', 0),
(701, 'Norwood Financial Corp.', '2026-04-29', 1),
(702, 'Hersha Hospitality Trust', '2025-10-09', 0),
(703, 'Wheeler Real Estate Investment Trust, Inc.', '2025-09-17', 0),
(704, 'OGE Energy Corporation', '2025-08-01', 0),
(705, 'Appliance Recycling Centers of America, Inc.', '2025-10-28', 0),
(706, 'Select Medical Holdings Corporation', '2026-01-10', 0),
(707, 'First Trust RiverFront Dynamic Developed International ETF', '2025-05-30', 1),
(708, 'WesBanco, Inc.', '2025-10-09', 1),
(709, 'Emerge Energy Services LP', '2025-05-25', 0),
(710, 'Consolidated Communications Holdings, Inc.', '2025-08-29', 0),
(711, 'Seaspan Corporation', '2026-01-24', 0),
(712, 'Nuveen New York Quality Municipal Income Fund', '2025-04-03', 1),
(713, 'Aoxin Tianli Group, Inc.', '2025-07-02', 0),
(714, 'Walker & Dunlop, Inc.', '2025-08-12', 1),
(715, 'Beasley Broadcast Group, Inc.', '2026-02-05', 1),
(716, 'Atrion Corporation', '2025-01-29', 1),
(717, 'Community Bank System, Inc.', '2025-06-12', 1),
(718, 'Cambrex Corporation', '2026-02-25', 0),
(719, 'Xilinx, Inc.', '2026-02-24', 1),
(720, 'PriceSmart, Inc.', '2026-03-15', 1),
(721, 'Fang Holdings Limited', '2025-07-26', 1),
(722, 'Stericycle, Inc.', '2025-03-02', 0),
(723, 'Pinnacle Foods, Inc.', '2025-10-21', 1),
(724, 'Putnam Municipal Opportunities Trust', '2025-10-24', 0),
(725, 'ClearBridge Energy MLP Opportunity Fund Inc.', '2025-06-09', 1),
(726, 'PhaseRx, Inc.', '2025-02-28', 1),
(727, 'Novan, Inc.', '2025-11-12', 0),
(728, 'Emerge Energy Services LP', '2025-07-22', 0),
(729, 'Fuel Tech, Inc.', '2025-03-22', 1),
(730, 'BorgWarner Inc.', '2025-03-07', 0),
(731, 'PerkinElmer, Inc.', '2025-10-04', 0),
(732, 'First Trust Mega Cap AlphaDEX Fund', '2026-03-21', 1),
(733, 'Vivint Solar, Inc.', '2026-01-20', 1),
(734, 'Aimmune Therapeutics, Inc.', '2025-02-07', 0),
(735, 'Northfield Bancorp, Inc.', '2025-02-28', 0),
(736, 'Till Capital Ltd.', '2026-02-19', 0),
(737, 'Lakeland Bancorp, Inc.', '2025-11-08', 0),
(738, 'Bank Mutual Corporation', '2026-01-23', 0),
(739, 'Top Image Systems, Ltd.', '2025-04-15', 1),
(740, 'Automatic Data Processing, Inc.', '2026-03-30', 1),
(741, 'Educational Development Corporation', '2025-02-05', 1),
(742, 'Summit Financial Group, Inc.', '2026-04-23', 0),
(743, 'Quantum Corporation', '2026-01-28', 1),
(744, 'United Security Bancshares', '2026-01-19', 0),
(745, 'Retrophin, Inc.', '2025-05-26', 1),
(746, 'e.l.f. Beauty, Inc.', '2025-02-06', 1),
(747, 'Psychemedics Corporation', '2025-05-12', 0),
(748, 'BlackRock 2022 Global Income Opportunity Trust', '2025-05-08', 0),
(749, 'Southern California Edison Company', '2025-12-29', 0),
(750, 'Royal Bank Scotland plc (The)', '2025-03-09', 0),
(751, 'Navient Corporation', '2025-07-26', 0),
(752, 'First Trust High Yield Long/Short ETF', '2025-11-06', 0),
(753, 'Nuveen California AMT-Free Quality Municipal Income Fund', '2025-03-22', 0),
(754, 'ManTech International Corporation', '2025-04-13', 1),
(755, 'Blackbaud, Inc.', '2025-10-27', 0),
(756, 'BlackRock Income Investment Quality Trust', '2025-12-15', 0),
(757, 'Versartis, Inc.', '2025-05-11', 0),
(758, 'Oaktree Capital Group, LLC', '2025-10-08', 1),
(759, 'VistaGen Therapeutics, Inc.', '2026-02-26', 1),
(760, 'Square, Inc.', '2026-03-11', 1),
(761, 'Meridian Waste Solutions, Inc', '2025-12-26', 1),
(762, 'John Hancock Income Securities Trust', '2025-06-29', 0),
(763, 'AllianzGI NFJ Dividend, Interest & Premium Strategy Fund', '2025-11-29', 1),
(764, 'Immune Design Corp.', '2025-07-12', 0),
(765, 'Donegal Group, Inc.', '2025-05-02', 1),
(766, 'Goldman Sachs Group, Inc. (The)', '2026-03-09', 1),
(767, 'HC2 Holdings, Inc.', '2026-01-23', 1),
(768, 'Diamondrock Hospitality Company', '2026-03-16', 1),
(769, 'Western Alliance Bancorporation', '2025-05-13', 1),
(770, 'Alico, Inc.', '2025-04-29', 1),
(771, 'Central Garden & Pet Company', '2025-09-27', 0),
(772, 'Jabil Inc.', '2026-01-22', 0),
(773, 'Aberdeen Greater China Fund, Inc.', '2026-04-23', 1),
(774, 'Duke Energy Corporation', '2025-06-07', 0),
(775, 'Hennessy Advisors, Inc.', '2026-01-16', 0),
(776, 'The Herzfeld Caribbean Basin Fund, Inc.', '2025-06-26', 0),
(777, 'Symantec Corporation', '2025-01-22', 0),
(778, 'Patheon N.V.', '2025-05-21', 1),
(779, 'DTE Energy Company', '2025-02-14', 1),
(780, 'GAMCO Natural Resources, Gold & Income Tust ', '2025-03-20', 1),
(781, 'Ferroglobe PLC', '2026-04-04', 1),
(782, 'Duke Energy Corporation', '2025-08-23', 1),
(783, 'ParkerVision, Inc.', '2025-11-23', 1),
(784, 'Blackrock MuniHoldings California Quality Fund,  Inc.', '2026-03-14', 1),
(785, 'Eaton Vance Enhance Equity Income Fund', '2025-02-25', 0),
(786, 'Everbridge, Inc.', '2025-12-17', 1),
(787, 'Westmoreland Coal Company', '2026-04-07', 1),
(788, 'Aaron\'s,  Inc.', '2025-02-16', 0),
(789, 'Pacific Special Acquisition Corp.', '2025-05-03', 1),
(790, 'Tutor Perini Corporation', '2025-11-19', 1),
(791, 'SpartanNash Company', '2025-10-10', 1),
(792, 'Cohen & Steers Select Preferred and Income Fund, Inc.', '2026-03-25', 1),
(793, 'SPX FLOW, Inc.', '2025-08-12', 1),
(794, 'Rayonier Advanced Materials Inc.', '2025-12-14', 0),
(795, 'Grupo Aval Acciones y Valores S.A.', '2026-02-21', 1),
(796, 'DNB Financial Corp', '2026-05-02', 0),
(797, 'Redhill Biopharma Ltd.', '2025-01-20', 0),
(798, 'Myriad Genetics, Inc.', '2025-06-13', 1),
(799, 'Juniper Networks, Inc.', '2026-04-27', 0),
(800, 'United Bankshares, Inc.', '2025-10-11', 0),
(801, 'Marrone Bio Innovations, Inc.', '2025-05-29', 0),
(802, 'Ollie\'s Bargain Outlet Holdings, Inc.', '2026-02-06', 1),
(803, 'OUTFRONT Media Inc.', '2025-12-07', 1),
(804, 'Vocera Communications, Inc.', '2025-05-19', 0),
(805, 'IBERIABANK Corporation', '2026-04-23', 1),
(806, 'Artisan Partners Asset Management Inc.', '2025-04-10', 1),
(807, 'Oconee Federal Financial Corp.', '2025-09-20', 1),
(808, 'ACI Worldwide, Inc.', '2026-04-18', 0),
(809, 'PowerShares DWA Utilities Momentum Portfolio', '2025-05-09', 0),
(810, 'Cooper Tire & Rubber Company', '2025-06-16', 1),
(811, 'SandRidge Mississippian Trust II', '2025-09-04', 0),
(812, 'athenahealth, Inc.', '2025-04-22', 0),
(813, 'MainSource Financial Group, Inc.', '2025-09-21', 1),
(814, 'McGrath RentCorp', '2025-04-28', 0),
(815, 'Pulse Biosciences, Inc', '2026-04-14', 0),
(816, 'Epizyme, Inc.', '2025-11-23', 1),
(817, 'Acadia Healthcare Company, Inc.', '2026-01-29', 1),
(818, 'Principal Healthcare Innovators Index ETF', '2025-11-13', 0),
(819, 'Deswell Industries, Inc.', '2025-09-29', 1),
(820, 'Shutterstock, Inc.', '2025-05-30', 0),
(821, 'Brown & Brown, Inc.', '2025-05-10', 1),
(822, 'Zosano Pharma Corporation', '2025-11-01', 1),
(823, 'Aduro Biotech, Inc.', '2026-05-01', 0),
(824, 'PTC Therapeutics, Inc.', '2025-10-19', 0),
(825, 'Murphy Oil Corporation', '2026-03-20', 1),
(826, 'Hormel Foods Corporation', '2025-12-07', 1),
(827, 'Capital One Financial Corporation', '2025-07-01', 0),
(828, 'Crossroads Systems, Inc.', '2025-09-03', 1),
(829, 'New York Community Bancorp, Inc.', '2026-03-01', 1),
(830, 'Soligenix, Inc.', '2025-06-13', 1),
(831, 'BB&T Corporation', '2026-02-27', 0),
(832, 'Inspired Entertainment, Inc.', '2025-07-26', 1),
(833, 'Approach Resources Inc.', '2025-03-31', 1),
(834, 'Tronox Limited', '2026-03-15', 1),
(835, 'Partner Communications Company Ltd.', '2025-04-05', 0),
(836, 'Putnam High Income Bond Fund', '2025-12-20', 1),
(837, 'O2Micro International Limited', '2025-01-28', 0),
(838, 'SandRidge Permian Trust', '2025-08-17', 1),
(839, 'Franklin Universal Trust', '2025-07-21', 1),
(840, 'Investors Bancorp, Inc.', '2025-11-12', 0),
(841, 'Capital One Financial Corporation', '2025-05-28', 0),
(842, 'Lennar Corporation', '2026-03-16', 1),
(843, 'John Hancock Premium Dividend Fund', '2026-02-24', 1),
(844, 'AmeriGas Partners, L.P.', '2025-08-24', 1),
(845, 'Monroe Capital Corporation', '2025-12-14', 0),
(846, 'Nexstar Media Group, Inc.', '2025-08-15', 1),
(847, 'Stone Harbor Emerging Markets Total Income Fund', '2025-05-07', 0),
(848, 'Gray Television, Inc.', '2025-01-27', 1),
(849, 'Korea Fund, Inc. (The)', '2026-03-23', 1),
(850, 'Sherwin-Williams Company (The)', '2025-01-20', 0),
(851, 'Plug Power, Inc.', '2026-05-03', 1),
(852, 'Gap, Inc. (The)', '2025-11-07', 1),
(853, 'Leaf Group Ltd.', '2025-11-25', 1),
(854, 'Eaton Vance Municipal Income Trust', '2025-09-12', 1),
(855, 'General Finance Corporation', '2025-07-28', 1),
(856, 'USA Technologies, Inc.', '2025-08-24', 1),
(857, 'Fifth Street Finance Corp.', '2025-10-28', 1),
(858, 'OM Asset Management plc', '2025-02-07', 0),
(859, 'Easterly Government Properties, Inc.', '2025-01-25', 1),
(860, 'Culp, Inc.', '2025-10-17', 0),
(861, 'Amplify Snack Brands, inc.', '2025-12-27', 0),
(862, 'WESCO International, Inc.', '2025-09-30', 0),
(863, 'ACADIA Pharmaceuticals Inc.', '2026-03-23', 1),
(864, 'FleetCor Technologies, Inc.', '2026-03-16', 1),
(865, 'Eaton Vance Tax-Managed Diversified Equity Income Fund', '2025-11-29', 1),
(866, 'Tri Continental Corporation', '2025-05-29', 0),
(867, 'AMN Healthcare Services Inc', '2026-02-12', 1),
(868, 'Alarm.com Holdings, Inc.', '2025-08-12', 0),
(869, 'Prosperity Bancshares, Inc.', '2025-07-11', 1),
(870, 'Materialise NV', '2025-12-12', 0),
(871, 'Arrowhead Pharmaceuticals, Inc.', '2025-08-22', 0),
(872, 'NextEra Energy, Inc.', '2025-09-25', 1),
(873, 'Northrim BanCorp Inc', '2025-11-01', 1),
(874, 'Sturm, Ruger & Company, Inc.', '2025-05-13', 1),
(875, 'Chesapeake Energy Corporation', '2025-07-26', 0),
(876, 'Navios Maritime Holdings Inc.', '2025-08-13', 0),
(877, 'Magic Software Enterprises Ltd.', '2025-11-12', 0),
(878, 'Liberty Broadband Corporation', '2025-07-09', 1),
(879, 'Skechers U.S.A., Inc.', '2026-02-17', 1),
(880, 'CubeSmart', '2025-07-04', 1),
(881, 'Churchill Downs, Incorporated', '2025-12-02', 1),
(882, 'Barrick Gold Corporation', '2025-08-17', 0),
(883, 'Vanguard Total International Stock ETF', '2026-01-03', 0),
(884, 'American Axle & Manufacturing Holdings, Inc.', '2025-04-16', 0),
(885, 'PDF Solutions, Inc.', '2025-07-16', 1),
(886, 'Brookfield Canada Office Properties', '2025-08-14', 0),
(887, 'Coca-Cola Company (The)', '2026-03-24', 1),
(888, 'Western Gas Partners, LP', '2026-03-02', 0),
(889, 'Immune Pharmaceuticals Inc.', '2026-02-18', 0),
(890, 'TC PipeLines, LP', '2025-10-20', 1),
(891, 'Invesco Value Municipal Income Trust', '2026-01-02', 1),
(892, 'Randgold Resources Limited', '2025-01-25', 0),
(893, 'Landcadia Holdings, Inc.', '2025-03-31', 0),
(894, 'BLDRS Developed Markets 100 ADR Index Fund', '2025-08-12', 1),
(895, 'First Trust Large Cap Growth AlphaDEX Fund', '2025-07-13', 0),
(896, 'Activision Blizzard, Inc', '2025-08-10', 1),
(897, 'USA Truck, Inc.', '2025-03-24', 1),
(898, 'Vipshop Holdings Limited', '2025-12-07', 0),
(899, 'Cott Corporation', '2025-04-11', 0),
(900, 'First Trust Mid Cap Core AlphaDEX Fund', '2025-10-22', 1),
(901, 'Cincinnati Financial Corporation', '2025-03-28', 1),
(902, 'PowerShares KBW Regional Banking Portfolio', '2025-02-03', 1),
(903, 'Edgewater Technology, Inc.', '2025-03-23', 0),
(904, 'Grifols, S.A.', '2025-04-07', 1),
(905, 'RAIT Financial Trust', '2025-10-02', 1),
(906, 'Gladstone Land Corporation', '2026-04-16', 1),
(907, 'Alkermes plc', '2025-03-20', 0),
(908, 'Ubiquiti Networks, Inc.', '2026-05-03', 0),
(909, 'Ocean Rig UDW Inc.', '2026-01-13', 1),
(910, 'Fifth Third Bancorp', '2026-01-13', 1),
(911, 'PowerShares High Yield Equity Dividend Achievers Portfolio', '2025-09-16', 1),
(912, 'CYS Investments, Inc.', '2026-01-04', 1),
(913, 'Akers Biosciences Inc', '2026-04-08', 0),
(914, 'International Game Technology', '2026-04-03', 0),
(915, 'MSCI Inc', '2025-11-22', 0),
(916, 'Shire plc', '2026-04-20', 1),
(917, 'ePlus inc.', '2025-09-19', 0),
(918, 'PartnerRe Ltd.', '2026-03-19', 0),
(919, 'Huntington Ingalls Industries, Inc.', '2025-10-21', 0),
(920, 'Ruby Tuesday, Inc.', '2026-01-13', 0),
(921, 'Berkshire Hills Bancorp, Inc.', '2025-07-21', 1),
(922, 'Matlin & Partners Acquisition Corporation', '2025-06-08', 0),
(923, 'Boingo Wireless, Inc.', '2025-12-20', 1),
(924, 'Limoneira Co', '2025-08-27', 0),
(925, 'Akari Therapeutics Plc', '2025-09-03', 1),
(926, 'Cantel Medical Corp.', '2026-02-10', 0),
(927, 'Zoetis Inc.', '2025-10-09', 0),
(928, 'Continental Building Products, Inc.', '2025-10-23', 1),
(929, 'ESSA Bancorp, Inc.', '2025-01-20', 0),
(930, 'Tile Shop Hldgs, Inc.', '2026-02-03', 0),
(931, 'Kayne Anderson Acquisition Corp.', '2026-04-06', 1),
(932, 'Wells Fargo & Company', '2025-06-24', 1),
(933, 'Haynes International, Inc.', '2025-11-24', 0),
(934, 'Liberty All-Star Growth Fund, Inc.', '2025-02-05', 0),
(935, 'ARMOUR Residential REIT, Inc.', '2025-09-05', 1),
(936, 'NetEase, Inc.', '2026-04-13', 1),
(937, 'First Trust NASDAQ Cybersecurity ETF', '2025-07-11', 0),
(938, 'Endologix, Inc.', '2025-08-29', 0),
(939, 'Cherokee Inc.', '2025-10-12', 1),
(940, 'Destination XL Group, Inc.', '2025-07-14', 0),
(941, 'Bank of America Corporation', '2025-05-29', 1),
(942, 'KKR & Co. L.P.', '2026-01-11', 1),
(943, 'Lexington Realty Trust', '2026-03-12', 1),
(944, 'DTE Energy Company', '2026-01-25', 0),
(945, 'Travelport Worldwide Limited', '2025-04-24', 1),
(946, 'Skyline Medical Inc.', '2025-04-19', 1),
(947, 'BB&T Corporation', '2025-10-06', 1),
(948, 'USA Compression Partners, LP', '2025-01-25', 1),
(949, 'Origo Acquisition Corporation', '2026-01-17', 1),
(950, 'China Rapid Finance Limited', '2026-04-12', 0),
(951, 'Chipotle Mexican Grill, Inc.', '2026-02-25', 1),
(952, 'Gulf Resources, Inc.', '2026-01-18', 1),
(953, 'M/I Homes, Inc.', '2025-03-09', 0),
(954, 'Boston Properties, Inc.', '2026-02-14', 1),
(955, 'Delcath Systems, Inc.', '2026-02-07', 1),
(956, 'Five9, Inc.', '2025-11-30', 0),
(957, 'BCB Bancorp, Inc. (NJ)', '2025-10-11', 0),
(958, 'BRF S.A.', '2026-03-18', 1),
(959, 'Clovis Oncology, Inc.', '2025-12-15', 0),
(960, 'Build-A-Bear Workshop, Inc.', '2026-04-21', 1),
(961, 'Synnex Corporation', '2025-04-25', 1),
(962, 'Archer-Daniels-Midland Company', '2025-10-04', 1),
(963, 'HomeTown Bankshares Corporation', '2025-02-16', 1),
(964, 'GCP Applied Technologies Inc.', '2025-07-29', 0),
(965, 'iStar Financial Inc.', '2025-01-20', 0),
(966, 'Amphastar Pharmaceuticals, Inc.', '2026-03-11', 0),
(967, 'Nord Anglia Education, Inc.', '2026-05-01', 0),
(968, 'BGC Partners, Inc.', '2025-08-22', 0),
(969, 'United Therapeutics Corporation', '2026-04-18', 1),
(970, 'Plantronics, Inc.', '2026-04-11', 1),
(971, 'Newmont Mining Corporation', '2025-01-25', 1);
INSERT INTO `comp` (`comp_id`, `comp_name`, `comp_date`, `is_comp`) VALUES
(972, 'Lindblad Expeditions Holdings Inc. ', '2025-07-08', 0),
(973, 'Navistar International Corporation', '2025-08-02', 1),
(974, 'Neovasc Inc.', '2025-07-21', 1),
(975, 'Federal Agricultural Mortgage Corporation', '2026-03-29', 1),
(976, 'Seabridge Gold, Inc.', '2025-05-03', 1),
(977, 'First Connecticut Bancorp, Inc.', '2025-10-09', 0),
(978, 'VBI Vaccines, Inc.', '2026-03-23', 1),
(979, 'Mesabi Trust', '2025-09-25', 1),
(980, 'Blackrock MuniEnhanced Fund, Inc.', '2026-03-23', 1),
(981, 'Malibu Boats, Inc.', '2025-09-07', 0),
(982, 'Twin Disc, Incorporated', '2026-01-04', 1),
(983, 'Ryerson Holding Corporation', '2025-10-27', 0),
(984, 'Community Bankers Trust Corporation.', '2025-05-23', 0),
(985, 'W.R. Berkley Corporation', '2025-07-08', 0),
(986, 'U.S. Bancorp', '2025-01-18', 0),
(987, 'Quanex Building Products Corporation', '2026-03-05', 0),
(988, 'Calamos Convertible and High Income Fund', '2026-04-12', 0),
(989, 'Educational Development Corporation', '2025-07-29', 0),
(990, 'Ionis Pharmaceuticals, Inc.', '2025-01-21', 1),
(991, 'Roka Bioscience, Inc.', '2025-11-28', 1),
(992, 'AmTrust Financial Services, Inc.', '2025-11-04', 1),
(993, 'Pool Corporation', '2025-10-16', 0),
(994, 'WEX Inc.', '2026-03-08', 1),
(995, 'Turquoise Hill Resources Ltd.', '2025-02-20', 1),
(996, 'Origo Acquisition Corporation', '2025-03-09', 1),
(997, 'BlackRock Capital Investment Corporation', '2025-01-26', 0),
(998, 'Esterline Technologies Corporation', '2025-08-10', 0),
(999, 'Trevena, Inc.', '2026-01-15', 0),
(1000, 'OncoMed Pharmaceuticals, Inc.', '2025-11-21', 1),
(1001, 'Club Competition', '2026-03-09', 1);

-- --------------------------------------------------------

--
-- Table structure for table `division`
--

CREATE TABLE `division` (
  `division_id` int(11) NOT NULL,
  `division_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `division`
--

INSERT INTO `division` (`division_id`, `division_name`) VALUES
(1, 'Recurve'),
(2, 'Compound'),
(3, 'Recurve Barebow'),
(4, 'Compound Barebow'),
(5, 'Longbow');

-- --------------------------------------------------------

--
-- Table structure for table `end_shot`
--

CREATE TABLE `end_shot` (
  `end_id` int(11) NOT NULL,
  `range_shot_id` int(11) NOT NULL,
  `end_number` tinyint(3) UNSIGNED NOT NULL COMMENT 'Position within range: 1 to num_ends'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `end_shot`
--

INSERT INTO `end_shot` (`end_id`, `range_shot_id`, `end_number`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 2, 1),
(8, 2, 2),
(9, 2, 3),
(10, 2, 4),
(11, 2, 5),
(12, 2, 6),
(13, 3, 1),
(14, 3, 2),
(15, 3, 3),
(16, 3, 4),
(17, 3, 5),
(18, 3, 6),
(19, 4, 1),
(20, 4, 2),
(21, 4, 3),
(22, 4, 4),
(23, 4, 5),
(24, 4, 6);

-- --------------------------------------------------------

--
-- Table structure for table `equivalent_rounds`
--

CREATE TABLE `equivalent_rounds` (
  `equivalent_id` int(11) NOT NULL,
  `base_round_id` int(11) NOT NULL COMMENT 'Male Open base round',
  `equivalent_round_id` int(11) NOT NULL COMMENT 'Round shot by this category',
  `category_id` int(11) NOT NULL,
  `valid_start` date DEFAULT NULL,
  `valid_end` date DEFAULT NULL COMMENT 'NULL = currently active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `equivalent_rounds`
--

INSERT INTO `equivalent_rounds` (`equivalent_id`, `base_round_id`, `equivalent_round_id`, `category_id`, `valid_start`, `valid_end`) VALUES
(1, 1, 2, 1, NULL, NULL),
(2, 1, 2, 2, NULL, NULL),
(3, 1, 2, 8, NULL, NULL),
(4, 1, 2, 9, NULL, NULL),
(5, 1, 2, 16, NULL, NULL),
(6, 1, 2, 17, NULL, NULL),
(7, 1, 2, 41, NULL, NULL),
(8, 1, 2, 42, NULL, NULL),
(9, 1, 2, 48, NULL, NULL),
(10, 1, 2, 49, NULL, NULL),
(11, 1, 2, 56, NULL, NULL),
(12, 1, 2, 57, NULL, NULL),
(13, 1, 3, 3, NULL, NULL),
(14, 1, 3, 4, NULL, NULL),
(15, 1, 3, 10, NULL, NULL),
(16, 1, 3, 11, NULL, NULL),
(17, 1, 3, 12, NULL, NULL),
(18, 1, 3, 13, NULL, NULL),
(19, 1, 3, 14, NULL, NULL),
(20, 1, 3, 18, NULL, NULL),
(21, 1, 3, 19, NULL, NULL),
(22, 1, 3, 26, NULL, NULL),
(23, 1, 3, 27, NULL, NULL),
(24, 1, 3, 28, NULL, NULL),
(25, 1, 3, 29, NULL, NULL),
(26, 1, 3, 36, NULL, NULL),
(27, 1, 3, 37, NULL, NULL),
(28, 1, 3, 38, NULL, NULL),
(29, 1, 3, 39, NULL, NULL),
(30, 1, 3, 43, NULL, NULL),
(31, 1, 3, 44, NULL, NULL),
(32, 1, 3, 50, NULL, NULL),
(33, 1, 3, 51, NULL, NULL),
(34, 1, 3, 52, NULL, NULL),
(35, 1, 3, 58, NULL, NULL),
(36, 1, 3, 59, NULL, NULL),
(37, 1, 4, 5, NULL, NULL),
(38, 1, 4, 15, NULL, NULL),
(39, 1, 4, 20, NULL, NULL),
(40, 1, 4, 21, NULL, NULL),
(41, 1, 4, 22, NULL, NULL),
(42, 1, 4, 23, NULL, NULL),
(43, 1, 4, 24, NULL, NULL),
(44, 1, 4, 25, NULL, NULL),
(45, 1, 4, 30, NULL, NULL),
(46, 1, 4, 31, NULL, NULL),
(47, 1, 4, 32, NULL, NULL),
(48, 1, 4, 33, NULL, NULL),
(49, 1, 4, 34, NULL, NULL),
(50, 1, 4, 35, NULL, NULL),
(51, 1, 4, 40, NULL, NULL),
(52, 1, 4, 45, NULL, NULL),
(53, 1, 4, 53, NULL, NULL),
(54, 1, 4, 54, NULL, NULL),
(55, 1, 4, 55, NULL, NULL),
(56, 1, 4, 60, NULL, NULL),
(57, 1, 4, 61, NULL, NULL),
(58, 1, 4, 62, NULL, NULL),
(59, 1, 4, 66, NULL, NULL),
(60, 1, 4, 67, NULL, NULL),
(61, 1, 5, 63, NULL, NULL),
(62, 1, 5, 64, NULL, NULL),
(63, 1, 5, 65, NULL, NULL),
(64, 1, 5, 68, NULL, NULL),
(65, 1, 5, 69, NULL, NULL),
(66, 1, 5, 70, NULL, NULL),
(67, 1, 5, 71, NULL, NULL),
(68, 1, 5, 72, NULL, NULL),
(69, 1, 5, 73, NULL, NULL),
(70, 1, 5, 74, NULL, NULL),
(71, 1, 5, 75, NULL, NULL),
(72, 1, 5, 76, NULL, NULL),
(73, 1, 5, 77, NULL, NULL),
(74, 1, 5, 78, NULL, NULL),
(75, 1, 5, 79, NULL, NULL),
(76, 1, 5, 80, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `range_def`
--

CREATE TABLE `range_def` (
  `round_def_id` int(11) NOT NULL,
  `distance` tinyint(3) UNSIGNED NOT NULL COMMENT 'Metres: 20,30,40,50,60,70,90',
  `target_size_cm` tinyint(3) UNSIGNED NOT NULL COMMENT 'Face diameter: 80 or 122',
  `num_ends` tinyint(3) UNSIGNED NOT NULL COMMENT 'Ends per range: typically 5 or 6'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `range_def`
--

INSERT INTO `range_def` (`round_def_id`, `distance`, `target_size_cm`, `num_ends`) VALUES
(1, 30, 80, 6),
(1, 50, 80, 6),
(1, 70, 122, 6),
(1, 90, 122, 6),
(2, 30, 80, 6),
(2, 50, 80, 6),
(2, 60, 122, 6),
(2, 70, 122, 6),
(3, 30, 80, 6),
(3, 40, 80, 6),
(3, 50, 122, 6),
(3, 60, 122, 6),
(4, 20, 80, 6),
(4, 30, 80, 6),
(4, 40, 122, 6),
(4, 50, 122, 6),
(5, 20, 80, 6),
(5, 30, 80, 6),
(5, 30, 122, 6),
(5, 40, 122, 6),
(6, 50, 122, 5),
(6, 60, 122, 5),
(6, 70, 122, 5),
(6, 90, 122, 5),
(7, 40, 122, 5),
(7, 50, 122, 5),
(7, 60, 122, 5),
(7, 70, 122, 5),
(8, 50, 80, 5),
(8, 60, 80, 5),
(8, 70, 122, 5),
(8, 90, 122, 5),
(9, 40, 80, 5),
(9, 50, 80, 5),
(9, 60, 122, 5),
(9, 70, 122, 5),
(10, 30, 80, 5),
(10, 40, 80, 5),
(10, 50, 122, 5),
(10, 60, 122, 5),
(11, 20, 80, 5),
(11, 30, 80, 5),
(11, 40, 122, 5),
(11, 50, 122, 5),
(12, 50, 122, 5),
(12, 70, 122, 5),
(12, 90, 122, 5),
(13, 50, 122, 5),
(13, 60, 122, 5),
(13, 70, 122, 5);

-- --------------------------------------------------------

--
-- Table structure for table `range_shot`
--

CREATE TABLE `range_shot` (
  `range_shot_id` int(11) NOT NULL,
  `round_shots_id` int(11) NOT NULL,
  `range_def_round_id` int(11) NOT NULL,
  `range_def_distance` tinyint(3) UNSIGNED NOT NULL,
  `range_def_target_size` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `range_shot`
--

INSERT INTO `range_shot` (`range_shot_id`, `round_shots_id`, `range_def_round_id`, `range_def_distance`, `range_def_target_size`) VALUES
(1, 1, 1, 90, 122),
(2, 1, 1, 70, 122),
(3, 1, 1, 50, 80),
(4, 1, 1, 30, 80);

-- --------------------------------------------------------

--
-- Table structure for table `round_def`
--

CREATE TABLE `round_def` (
  `round_def_id` int(11) NOT NULL,
  `round_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `round_def`
--

INSERT INTO `round_def` (`round_def_id`, `round_name`) VALUES
(1, 'WA90/1440'),
(2, 'WA70/1440'),
(3, 'WA60/1440'),
(4, 'AA50/1440'),
(5, 'AA40/1440'),
(6, 'Long Sydney'),
(7, 'Sydney'),
(8, 'Long Brisbane'),
(9, 'Brisbane'),
(10, 'Adelaide'),
(11, 'Short Adelaide'),
(12, 'Hobart'),
(13, 'Perth');

-- --------------------------------------------------------

--
-- Table structure for table `round_shot`
--

CREATE TABLE `round_shot` (
  `round_shots_id` int(11) NOT NULL,
  `round_def_id` int(11) NOT NULL,
  `archer_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `comp_id` int(11) DEFAULT NULL COMMENT 'NULL = practice round',
  `placement` tinyint(3) UNSIGNED DEFAULT NULL,
  `round_shots_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `round_shot`
--

INSERT INTO `round_shot` (`round_shots_id`, `round_def_id`, `archer_id`, `category_id`, `comp_id`, `placement`, `round_shots_date`) VALUES
(1, 1, 5, 46, 1001, NULL, '2026-03-09');

-- --------------------------------------------------------

--
-- Table structure for table `staging_arrow`
--

CREATE TABLE `staging_arrow` (
  `staging_arrow_id` int(11) NOT NULL,
  `staging_end_id` int(11) NOT NULL,
  `score` tinyint(3) UNSIGNED NOT NULL COMMENT 'Arrow score 0–10',
  `is_x` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staging_arrow`
--

INSERT INTO `staging_arrow` (`staging_arrow_id`, `staging_end_id`, `score`, `is_x`) VALUES
(1, 1, 10, 1),
(2, 1, 10, 0),
(3, 1, 9, 0),
(4, 1, 8, 0),
(5, 1, 7, 0),
(6, 1, 6, 0),
(7, 2, 10, 0),
(8, 2, 9, 0),
(9, 2, 8, 0),
(10, 2, 7, 0),
(11, 2, 5, 0),
(12, 2, 3, 0),
(13, 3, 10, 1),
(14, 3, 10, 0),
(15, 3, 9, 0),
(16, 3, 8, 0),
(17, 3, 7, 0),
(18, 3, 4, 0),
(19, 4, 10, 1),
(20, 4, 9, 0),
(21, 4, 8, 0),
(22, 4, 7, 0),
(23, 4, 6, 0),
(24, 4, 2, 0),
(25, 5, 10, 1),
(26, 5, 10, 0),
(27, 5, 9, 0),
(28, 5, 8, 0),
(29, 5, 7, 0),
(30, 5, 5, 0),
(31, 6, 10, 0),
(32, 6, 9, 0),
(33, 6, 8, 0),
(34, 6, 7, 0),
(35, 6, 7, 0),
(36, 6, 3, 0),
(37, 7, 10, 1),
(38, 7, 10, 0),
(39, 7, 9, 0),
(40, 7, 8, 0),
(41, 7, 7, 0),
(42, 7, 6, 0),
(43, 8, 10, 1),
(44, 8, 10, 0),
(45, 8, 9, 0),
(46, 8, 8, 0),
(47, 8, 8, 0),
(48, 8, 7, 0),
(49, 9, 10, 0),
(50, 9, 9, 0),
(51, 9, 9, 0),
(52, 9, 8, 0),
(53, 9, 7, 0),
(54, 9, 6, 0),
(55, 10, 10, 1),
(56, 10, 10, 0),
(57, 10, 9, 0),
(58, 10, 8, 0),
(59, 10, 7, 0),
(60, 10, 4, 0),
(61, 11, 10, 1),
(62, 11, 9, 0),
(63, 11, 8, 0),
(64, 11, 8, 0),
(65, 11, 7, 0),
(66, 11, 5, 0),
(67, 12, 10, 1),
(68, 12, 10, 0),
(69, 12, 9, 0),
(70, 12, 8, 0),
(71, 12, 7, 0),
(72, 12, 3, 0),
(73, 13, 10, 1),
(74, 13, 10, 0),
(75, 13, 9, 0),
(76, 13, 8, 0),
(77, 13, 7, 0),
(78, 13, 7, 0),
(79, 14, 10, 0),
(80, 14, 9, 0),
(81, 14, 8, 0),
(82, 14, 7, 0),
(83, 14, 6, 0),
(84, 14, 0, 0),
(85, 15, 10, 1),
(86, 15, 10, 0),
(87, 15, 9, 0),
(88, 15, 8, 0),
(89, 15, 7, 0),
(90, 15, 6, 0),
(91, 16, 10, 1),
(92, 16, 9, 0),
(93, 16, 8, 0),
(94, 16, 8, 0),
(95, 16, 7, 0),
(96, 16, 4, 0),
(97, 17, 10, 1),
(98, 17, 10, 0),
(99, 17, 9, 0),
(100, 17, 8, 0),
(101, 17, 7, 0),
(102, 17, 5, 0),
(103, 18, 10, 1),
(104, 18, 10, 0),
(105, 18, 9, 0),
(106, 18, 8, 0),
(107, 18, 8, 0),
(108, 18, 7, 0),
(109, 19, 10, 1),
(110, 19, 10, 0),
(111, 19, 9, 0),
(112, 19, 8, 0),
(113, 19, 7, 0),
(114, 19, 6, 0),
(115, 20, 10, 0),
(116, 20, 9, 0),
(117, 20, 9, 0),
(118, 20, 8, 0),
(119, 20, 7, 0),
(120, 20, 3, 0),
(121, 21, 10, 1),
(122, 21, 10, 0),
(123, 21, 9, 0),
(124, 21, 8, 0),
(125, 21, 7, 0),
(126, 21, 6, 0),
(127, 22, 10, 1),
(128, 22, 10, 0),
(129, 22, 9, 0),
(130, 22, 8, 0),
(131, 22, 8, 0),
(132, 22, 7, 0),
(133, 23, 10, 1),
(134, 23, 10, 0),
(135, 23, 9, 0),
(136, 23, 8, 0),
(137, 23, 7, 0),
(138, 23, 5, 0),
(139, 24, 10, 1),
(140, 24, 10, 0),
(141, 24, 9, 0),
(142, 24, 8, 0),
(143, 24, 7, 0),
(144, 24, 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `staging_end`
--

CREATE TABLE `staging_end` (
  `staging_end_id` int(11) NOT NULL,
  `staging_id` int(11) NOT NULL,
  `range_def_round_id` int(11) NOT NULL,
  `range_def_distance` tinyint(3) UNSIGNED NOT NULL,
  `range_def_target_size` tinyint(3) UNSIGNED NOT NULL,
  `end_number` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staging_end`
--

INSERT INTO `staging_end` (`staging_end_id`, `staging_id`, `range_def_round_id`, `range_def_distance`, `range_def_target_size`, `end_number`) VALUES
(1, 1, 2, 70, 122, 1),
(2, 1, 2, 70, 122, 2),
(3, 1, 2, 70, 122, 3),
(4, 1, 2, 70, 122, 4),
(5, 1, 2, 70, 122, 5),
(6, 1, 2, 70, 122, 6),
(7, 1, 2, 60, 122, 1),
(8, 1, 2, 60, 122, 2),
(9, 1, 2, 60, 122, 3),
(10, 1, 2, 60, 122, 4),
(11, 1, 2, 60, 122, 5),
(12, 1, 2, 60, 122, 6),
(13, 1, 2, 50, 80, 1),
(14, 1, 2, 50, 80, 2),
(15, 1, 2, 50, 80, 3),
(16, 1, 2, 50, 80, 4),
(17, 1, 2, 50, 80, 5),
(18, 1, 2, 50, 80, 6),
(19, 1, 2, 30, 80, 1),
(20, 1, 2, 30, 80, 2),
(21, 1, 2, 30, 80, 3),
(22, 1, 2, 30, 80, 4),
(23, 1, 2, 30, 80, 5),
(24, 1, 2, 30, 80, 6);

-- --------------------------------------------------------

--
-- Table structure for table `staging_table`
--

CREATE TABLE `staging_table` (
  `staged_id` int(11) NOT NULL,
  `archer_id` int(11) NOT NULL,
  `round_def_id` int(11) NOT NULL,
  `division_id` int(11) NOT NULL COMMENT 'Equipment used this session',
  `datetime` datetime NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staging_table`
--

INSERT INTO `staging_table` (`staged_id`, `archer_id`, `round_def_id`, `division_id`, `datetime`, `status`) VALUES
(1, 1, 2, 2, '2026-05-09 15:24:00', 'pending'),
(2, 5, 1, 1, '2026-03-09 16:15:00', 'pending');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `age_class`
--
ALTER TABLE `age_class`
  ADD PRIMARY KEY (`age_class_id`);

--
-- Indexes for table `archer_details`
--
ALTER TABLE `archer_details`
  ADD PRIMARY KEY (`archer_id`),
  ADD INDEX `division_id` (`division_id`);

--
-- Indexes for table `arrow_shot`
--
ALTER TABLE `arrow_shot`
  ADD PRIMARY KEY (`arrow_id`),
  ADD INDEX `end_id` (`end_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD INDEX `age_class_id` (`age_class_id`),
  ADD INDEX `division_id` (`division_id`);

--
-- Indexes for table `comp`
--
ALTER TABLE `comp`
  ADD PRIMARY KEY (`comp_id`);

--
-- Indexes for table `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`division_id`);

--
-- Indexes for table `end_shot`
--
ALTER TABLE `end_shot`
  ADD PRIMARY KEY (`end_id`),
  ADD INDEX `range_shot_id` (`range_shot_id`);

--
-- Indexes for table `equivalent_rounds`
--
ALTER TABLE `equivalent_rounds`
  ADD PRIMARY KEY (`equivalent_id`),
  ADD INDEX `base_round_id` (`base_round_id`),
  ADD INDEX `equivalent_round_id` (`equivalent_round_id`),
  ADD INDEX `category_id` (`category_id`);

--
-- Indexes for table `range_def`
--
ALTER TABLE `range_def`
  ADD PRIMARY KEY (`round_def_id`,`distance`,`target_size_cm`);

--
-- Indexes for table `range_shot`
--
ALTER TABLE `range_shot`
  ADD PRIMARY KEY (`range_shot_id`),
  ADD INDEX `round_shots_id` (`round_shots_id`),
  ADD INDEX `range_def_round_id` (`range_def_round_id`,`range_def_distance`,`range_def_target_size`);

--
-- Indexes for table `round_def`
--
ALTER TABLE `round_def`
  ADD PRIMARY KEY (`round_def_id`);

--
-- Indexes for table `round_shot`
--
ALTER TABLE `round_shot`
  ADD PRIMARY KEY (`round_shots_id`),
  ADD INDEX `round_def_id` (`round_def_id`),
  ADD INDEX `archer_id` (`archer_id`),
  ADD INDEX `category_id` (`category_id`),
  ADD INDEX `comp_id` (`comp_id`);

--
-- Indexes for table `staging_arrow`
--
ALTER TABLE `staging_arrow`
  ADD PRIMARY KEY (`staging_arrow_id`),
  ADD INDEX `staging_end_id` (`staging_end_id`);

--
-- Indexes for table `staging_end`
--
ALTER TABLE `staging_end`
  ADD PRIMARY KEY (`staging_end_id`),
  ADD INDEX `range_def_round_id` (`range_def_round_id`,`range_def_distance`,`range_def_target_size`),
  ADD INDEX `staging_id` (`staging_id`);

--
-- Indexes for table `staging_table`
--
ALTER TABLE `staging_table`
  ADD PRIMARY KEY (`staged_id`),
  ADD INDEX `archer_id` (`archer_id`),
  ADD INDEX `round_def_id` (`round_def_id`),
  ADD INDEX `division_id` (`division_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `age_class`
--
ALTER TABLE `age_class`
  MODIFY `age_class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `archer_details`
--
ALTER TABLE `archer_details`
  MODIFY `archer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `arrow_shot`
--
ALTER TABLE `arrow_shot`
  MODIFY `arrow_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `comp`
--
ALTER TABLE `comp`
  MODIFY `comp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT for table `division`
--
ALTER TABLE `division`
  MODIFY `division_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `end_shot`
--
ALTER TABLE `end_shot`
  MODIFY `end_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `equivalent_rounds`
--
ALTER TABLE `equivalent_rounds`
  MODIFY `equivalent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `range_shot`
--
ALTER TABLE `range_shot`
  MODIFY `range_shot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `round_def`
--
ALTER TABLE `round_def`
  MODIFY `round_def_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `round_shot`
--
ALTER TABLE `round_shot`
  MODIFY `round_shots_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `staging_arrow`
--
ALTER TABLE `staging_arrow`
  MODIFY `staging_arrow_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;

--
-- AUTO_INCREMENT for table `staging_end`
--
ALTER TABLE `staging_end`
  MODIFY `staging_end_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `staging_table`
--
ALTER TABLE `staging_table`
  MODIFY `staged_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `archer_details`
--
ALTER TABLE `archer_details`
  ADD CONSTRAINT `archer_details_ibfk_1` FOREIGN KEY (`division_id`) REFERENCES `division` (`division_id`);

--
-- Constraints for table `arrow_shot`
--
ALTER TABLE `arrow_shot`
  ADD CONSTRAINT `arrow_shot_ibfk_1` FOREIGN KEY (`end_id`) REFERENCES `end_shot` (`end_id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`age_class_id`) REFERENCES `age_class` (`age_class_id`),
  ADD CONSTRAINT `categories_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `division` (`division_id`);

--
-- Constraints for table `end_shot`
--
ALTER TABLE `end_shot`
  ADD CONSTRAINT `end_shot_ibfk_1` FOREIGN KEY (`range_shot_id`) REFERENCES `range_shot` (`range_shot_id`);

--
-- Constraints for table `equivalent_rounds`
--
ALTER TABLE `equivalent_rounds`
  ADD CONSTRAINT `equivalent_rounds_ibfk_1` FOREIGN KEY (`base_round_id`) REFERENCES `round_def` (`round_def_id`),
  ADD CONSTRAINT `equivalent_rounds_ibfk_2` FOREIGN KEY (`equivalent_round_id`) REFERENCES `round_def` (`round_def_id`),
  ADD CONSTRAINT `equivalent_rounds_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `range_def`
--
ALTER TABLE `range_def`
  ADD CONSTRAINT `range_def_ibfk_1` FOREIGN KEY (`round_def_id`) REFERENCES `round_def` (`round_def_id`);

--
-- Constraints for table `range_shot`
--
ALTER TABLE `range_shot`
  ADD CONSTRAINT `range_shot_ibfk_1` FOREIGN KEY (`round_shots_id`) REFERENCES `round_shot` (`round_shots_id`),
  ADD CONSTRAINT `range_shot_ibfk_2` FOREIGN KEY (`range_def_round_id`,`range_def_distance`,`range_def_target_size`) REFERENCES `range_def` (`round_def_id`, `distance`, `target_size_cm`);

--
-- Constraints for table `round_shot`
--
ALTER TABLE `round_shot`
  ADD CONSTRAINT `round_shot_ibfk_1` FOREIGN KEY (`round_def_id`) REFERENCES `round_def` (`round_def_id`),
  ADD CONSTRAINT `round_shot_ibfk_2` FOREIGN KEY (`archer_id`) REFERENCES `archer_details` (`archer_id`),
  ADD CONSTRAINT `round_shot_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `round_shot_ibfk_4` FOREIGN KEY (`comp_id`) REFERENCES `comp` (`comp_id`);

--
-- Constraints for table `staging_arrow`
--
ALTER TABLE `staging_arrow`
  ADD CONSTRAINT `staging_arrow_ibfk_1` FOREIGN KEY (`staging_end_id`) REFERENCES `staging_end` (`staging_end_id`);

--
-- Constraints for table `staging_end`
--
ALTER TABLE `staging_end`
  ADD CONSTRAINT `staging_end_ibfk_2` FOREIGN KEY (`range_def_round_id`,`range_def_distance`,`range_def_target_size`) REFERENCES `range_def` (`round_def_id`, `distance`, `target_size_cm`),
  ADD CONSTRAINT `staging_end_ibfk_3` FOREIGN KEY (`staging_id`) REFERENCES `staging_table` (`staged_id`);

--
-- Constraints for table `staging_table`
--
ALTER TABLE `staging_table`
  ADD CONSTRAINT `staging_table_ibfk_1` FOREIGN KEY (`archer_id`) REFERENCES `archer_details` (`archer_id`),
  ADD CONSTRAINT `staging_table_ibfk_2` FOREIGN KEY (`round_def_id`) REFERENCES `round_def` (`round_def_id`),
  ADD CONSTRAINT `staging_table_ibfk_3` FOREIGN KEY (`division_id`) REFERENCES `division` (`division_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
