-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 27, 2025 at 10:01 AM
-- Server version: 12.0.2-MariaDB-log
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add کارمند', 6, 'add_employee'),
(22, 'Can change کارمند', 6, 'change_employee'),
(23, 'Can delete کارمند', 6, 'delete_employee'),
(24, 'Can view کارمند', 6, 'view_employee'),
(25, 'Can add کارخانه', 7, 'add_factory'),
(26, 'Can change کارخانه', 7, 'change_factory'),
(27, 'Can delete کارخانه', 7, 'delete_factory'),
(28, 'Can view کارخانه', 7, 'view_factory'),
(29, 'Can add نقش', 8, 'add_role'),
(30, 'Can change نقش', 8, 'change_role'),
(31, 'Can delete نقش', 8, 'delete_role'),
(32, 'Can view نقش', 8, 'view_role'),
(33, 'Can add سطح دسترسی', 9, 'add_permissionlevel'),
(34, 'Can change سطح دسترسی', 9, 'change_permissionlevel'),
(35, 'Can delete سطح دسترسی', 9, 'delete_permissionlevel'),
(36, 'Can view سطح دسترسی', 9, 'view_permissionlevel'),
(37, 'Can add بخش', 10, 'add_department'),
(38, 'Can change بخش', 10, 'change_department'),
(39, 'Can delete بخش', 10, 'delete_department'),
(40, 'Can view بخش', 10, 'view_department'),
(41, 'Can add ارزیابی کارمند', 11, 'add_employeeevaluation'),
(42, 'Can change ارزیابی کارمند', 11, 'change_employeeevaluation'),
(43, 'Can delete ارزیابی کارمند', 11, 'delete_employeeevaluation'),
(44, 'Can view ارزیابی کارمند', 11, 'view_employeeevaluation'),
(45, 'Can add معیار ارزیابی', 12, 'add_evaluationcriteria'),
(46, 'Can change معیار ارزیابی', 12, 'change_evaluationcriteria'),
(47, 'Can delete معیار ارزیابی', 12, 'delete_evaluationcriteria'),
(48, 'Can view معیار ارزیابی', 12, 'view_evaluationcriteria'),
(49, 'Can add امتیاز ارزیابی', 13, 'add_evaluationscore'),
(50, 'Can change امتیاز ارزیابی', 13, 'change_evaluationscore'),
(51, 'Can delete امتیاز ارزیابی', 13, 'delete_evaluationscore'),
(52, 'Can view امتیاز ارزیابی', 13, 'view_evaluationscore'),
(53, 'Can add access attempt', 14, 'add_accessattempt'),
(54, 'Can change access attempt', 14, 'change_accessattempt'),
(55, 'Can delete access attempt', 14, 'delete_accessattempt'),
(56, 'Can view access attempt', 14, 'view_accessattempt'),
(57, 'Can add access log', 15, 'add_accesslog'),
(58, 'Can change access log', 15, 'change_accesslog'),
(59, 'Can delete access log', 15, 'delete_accesslog'),
(60, 'Can view access log', 15, 'view_accesslog'),
(61, 'Can add access failure', 16, 'add_accessfailurelog'),
(62, 'Can change access failure', 16, 'change_accessfailurelog'),
(63, 'Can delete access failure', 16, 'delete_accessfailurelog'),
(64, 'Can view access failure', 16, 'view_accessfailurelog'),
(65, 'Can add مشارکت', 17, 'add_participation'),
(66, 'Can change مشارکت', 17, 'change_participation'),
(67, 'Can delete مشارکت', 17, 'delete_participation'),
(68, 'Can view مشارکت', 17, 'view_participation'),
(69, 'Can add ارزیابی مشارکتی', 18, 'add_evaluation'),
(70, 'Can change ارزیابی مشارکتی', 18, 'change_evaluation'),
(71, 'Can delete ارزیابی مشارکتی', 18, 'delete_evaluation'),
(72, 'Can view ارزیابی مشارکتی', 18, 'view_evaluation'),
(73, 'Can add هلدینگ', 19, 'add_holding'),
(74, 'Can change هلدینگ', 19, 'change_holding'),
(75, 'Can delete هلدینگ', 19, 'delete_holding'),
(76, 'Can view هلدینگ', 19, 'view_holding'),
(77, 'Can add زیربخش', 20, 'add_subdepartment'),
(78, 'Can change زیربخش', 20, 'change_subdepartment'),
(79, 'Can delete زیربخش', 20, 'delete_subdepartment'),
(80, 'Can view زیربخش', 20, 'view_subdepartment'),
(81, 'Can add غذا', 21, 'add_fooditem'),
(82, 'Can change غذا', 21, 'change_fooditem'),
(83, 'Can delete غذا', 21, 'delete_fooditem'),
(84, 'Can view غذا', 21, 'view_fooditem'),
(85, 'Can add منوی هفتگی', 22, 'add_weeklymenu'),
(86, 'Can change منوی هفتگی', 22, 'change_weeklymenu'),
(87, 'Can delete منوی هفتگی', 22, 'delete_weeklymenu'),
(88, 'Can view منوی هفتگی', 22, 'view_weeklymenu'),
(89, 'Can add غذای منو', 23, 'add_menuitem'),
(90, 'Can change غذای منو', 23, 'change_menuitem'),
(91, 'Can delete غذای منو', 23, 'delete_menuitem'),
(92, 'Can view غذای منو', 23, 'view_menuitem'),
(93, 'Can add رزرو غذا', 24, 'add_foodreservation'),
(94, 'Can change رزرو غذا', 24, 'change_foodreservation'),
(95, 'Can delete رزرو غذا', 24, 'delete_foodreservation'),
(96, 'Can view رزرو غذا', 24, 'view_foodreservation'),
(97, 'Can add referral', 25, 'add_referral'),
(98, 'Can change referral', 25, 'change_referral'),
(99, 'Can delete referral', 25, 'delete_referral'),
(100, 'Can view referral', 25, 'view_referral'),
(101, 'Can add referral step', 26, 'add_referralstep'),
(102, 'Can change referral step', 26, 'change_referralstep'),
(103, 'Can delete referral step', 26, 'delete_referralstep'),
(104, 'Can view referral step', 26, 'view_referralstep'),
(105, 'Can add org unit', 27, 'add_orgunit'),
(106, 'Can change org unit', 27, 'change_orgunit'),
(107, 'Can delete org unit', 27, 'delete_orgunit'),
(108, 'Can view org unit', 27, 'view_orgunit'),
(109, 'Can add اعلان', 28, 'add_notification'),
(110, 'Can change اعلان', 28, 'change_notification'),
(111, 'Can delete اعلان', 28, 'delete_notification'),
(112, 'Can view اعلان', 28, 'view_notification'),
(113, 'Can add خواندن اعلان', 29, 'add_notificationread'),
(114, 'Can change خواندن اعلان', 29, 'change_notificationread'),
(115, 'Can delete خواندن اعلان', 29, 'delete_notificationread'),
(116, 'Can view خواندن اعلان', 29, 'view_notificationread'),
(117, 'Can add بانک', 30, 'add_banks'),
(118, 'Can change بانک', 30, 'change_banks'),
(119, 'Can delete بانک', 30, 'delete_banks'),
(120, 'Can view بانک', 30, 'view_banks'),
(121, 'Can add کشور', 31, 'add_country'),
(122, 'Can change کشور', 31, 'change_country'),
(123, 'Can delete کشور', 31, 'delete_country'),
(124, 'Can view کشور', 31, 'view_country'),
(125, 'Can add وضعیت تکفل', 32, 'add_dependencystatus'),
(126, 'Can change وضعیت تکفل', 32, 'change_dependencystatus'),
(127, 'Can delete وضعیت تکفل', 32, 'delete_dependencystatus'),
(128, 'Can view وضعیت تکفل', 32, 'view_dependencystatus'),
(129, 'Can add نوع استخدام', 33, 'add_employmenttype'),
(130, 'Can change نوع استخدام', 33, 'change_employmenttype'),
(131, 'Can delete نوع استخدام', 33, 'delete_employmenttype'),
(132, 'Can view نوع استخدام', 33, 'view_employmenttype'),
(133, 'Can add جنسیت', 34, 'add_gender'),
(134, 'Can change جنسیت', 34, 'change_gender'),
(135, 'Can delete جنسیت', 34, 'delete_gender'),
(136, 'Can view جنسیت', 34, 'view_gender'),
(137, 'Can add نوع بیمه تکمیلی', 35, 'add_insurancetype'),
(138, 'Can change نوع بیمه تکمیلی', 35, 'change_insurancetype'),
(139, 'Can delete نوع بیمه تکمیلی', 35, 'delete_insurancetype'),
(140, 'Can view نوع بیمه تکمیلی', 35, 'view_insurancetype'),
(141, 'Can add گروه شغلی', 36, 'add_jobgroup'),
(142, 'Can change گروه شغلی', 36, 'change_jobgroup'),
(143, 'Can delete گروه شغلی', 36, 'delete_jobgroup'),
(144, 'Can view گروه شغلی', 36, 'view_jobgroup'),
(145, 'Can add وضعیت تاهل', 37, 'add_maritalstatus'),
(146, 'Can change وضعیت تاهل', 37, 'change_maritalstatus'),
(147, 'Can delete وضعیت تاهل', 37, 'delete_maritalstatus'),
(148, 'Can view وضعیت تاهل', 37, 'view_maritalstatus'),
(149, 'Can add نسبت با بیمه‌شده', 38, 'add_relativetype'),
(150, 'Can change نسبت با بیمه‌شده', 38, 'change_relativetype'),
(151, 'Can delete نسبت با بیمه‌شده', 38, 'delete_relativetype'),
(152, 'Can view نسبت با بیمه‌شده', 38, 'view_relativetype'),
(153, 'Can add وابسته', 39, 'add_dependent'),
(154, 'Can change وابسته', 39, 'change_dependent'),
(155, 'Can delete وابسته', 39, 'delete_dependent'),
(156, 'Can view وابسته', 39, 'view_dependent'),
(157, 'Can add employee_ bimeh', 40, 'add_employee_bimeh'),
(158, 'Can change employee_ bimeh', 40, 'change_employee_bimeh'),
(159, 'Can delete employee_ bimeh', 40, 'delete_employee_bimeh'),
(160, 'Can view employee_ bimeh', 40, 'view_employee_bimeh'),
(161, 'Can add شماره تماس', 41, 'add_contactinfo'),
(162, 'Can change شماره تماس', 41, 'change_contactinfo'),
(163, 'Can delete شماره تماس', 41, 'delete_contactinfo'),
(164, 'Can view شماره تماس', 41, 'view_contactinfo'),
(165, 'Can add حساب بانکی', 42, 'add_bankaccount'),
(166, 'Can change حساب بانکی', 42, 'change_bankaccount'),
(167, 'Can delete حساب بانکی', 42, 'delete_bankaccount'),
(168, 'Can view حساب بانکی', 42, 'view_bankaccount'),
(169, 'Can add نوع حساب بانکی', 43, 'add_bankaccounttype'),
(170, 'Can change نوع حساب بانکی', 43, 'change_bankaccounttype'),
(171, 'Can delete نوع حساب بانکی', 43, 'delete_bankaccounttype'),
(172, 'Can view نوع حساب بانکی', 43, 'view_bankaccounttype'),
(173, 'Can add بیمه گر پایه', 44, 'add_baseinsurance'),
(174, 'Can change بیمه گر پایه', 44, 'change_baseinsurance'),
(175, 'Can delete بیمه گر پایه', 44, 'delete_baseinsurance'),
(176, 'Can view بیمه گر پایه', 44, 'view_baseinsurance'),
(177, 'Can add بیمه گر قبلی', 45, 'add_previousinsurer'),
(178, 'Can change بیمه گر قبلی', 45, 'change_previousinsurer'),
(179, 'Can delete بیمه گر قبلی', 45, 'delete_previousinsurer'),
(180, 'Can view بیمه گر قبلی', 45, 'view_previousinsurer');

-- --------------------------------------------------------

--
-- Table structure for table `axes_accessattempt`
--

CREATE TABLE `axes_accessattempt` (
  `id` int(11) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `http_accept` varchar(1025) NOT NULL,
  `path_info` varchar(255) NOT NULL,
  `attempt_time` datetime(6) NOT NULL,
  `get_data` longtext NOT NULL,
  `post_data` longtext NOT NULL,
  `failures_since_start` int(10) UNSIGNED NOT NULL CHECK (`failures_since_start` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `axes_accessfailurelog`
--

CREATE TABLE `axes_accessfailurelog` (
  `id` int(11) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `http_accept` varchar(1025) NOT NULL,
  `path_info` varchar(255) NOT NULL,
  `attempt_time` datetime(6) NOT NULL,
  `locked_out` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `axes_accesslog`
--

CREATE TABLE `axes_accesslog` (
  `id` int(11) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `http_accept` varchar(1025) NOT NULL,
  `path_info` varchar(255) NOT NULL,
  `attempt_time` datetime(6) NOT NULL,
  `logout_time` datetime(6) DEFAULT NULL,
  `session_hash` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `axes_accesslog`
--

INSERT INTO `axes_accesslog` (`id`, `user_agent`, `ip_address`, `username`, `http_accept`, `path_info`, `attempt_time`, `logout_time`, `session_hash`) VALUES
(1, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 04:11:14.046798', '2025-09-26 04:13:02.474994', '9c61e71af828ecd7b585feb98c579e631c9afa8d3169d082610913f32da333d5'),
(2, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 04:25:25.139037', '2025-09-26 04:25:28.856442', '2f18bad1cd90c3e8f4d3d071a88fd580aba15facdfdf670923f413d5eacc4092'),
(3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 04:30:24.873462', '2025-09-26 04:30:27.863083', '68a4f326ec91f3fc81ee079702e40ce4866e29fcdffc1cd290d24152292cbc94'),
(4, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 05:10:47.802458', '2025-09-26 05:11:07.045754', 'decc185be180a7b7b422f934046d350271db7026d1a69335550119b97941632d'),
(5, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 05:11:11.892755', '2025-09-26 05:11:20.808127', '0e9df947f6f31c743a3cfc0cd10f175aca595541f32f0c7a0b06c4785cbbdf06'),
(6, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 05:11:28.273163', '2025-09-26 07:28:52.478391', 'b42e04740ee24174397219a944953fdd3e0f4dd53025c246596f8e15135c044b'),
(7, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:33:17.776810', NULL, 'f9062a3f625ae5aa36f0ed524241256c68a768f9469d5170b46a8cfec2b27ecb'),
(8, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/admin/login/', '2025-09-26 07:33:50.566046', '2025-09-26 07:35:07.724667', 'aa709f7398a7f6fa3b0f3d84c9da7ee881b8eb274d1bdfa679d69588aa035490'),
(9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:35:13.155904', '2025-09-26 07:35:17.488134', 'a7e9c1bec3891fba03ecf01931d3ae2c9ff748a61caa948eb53741471a93a8b9'),
(10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:35:23.436480', '2025-09-26 07:42:02.660376', '4c8cca75c1330ccb2922ec7e0e93f24e202c5e5eff2887f92711d605df7dc57a'),
(11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:40:46.111272', '2025-09-26 07:42:02.660376', '4c8cca75c1330ccb2922ec7e0e93f24e202c5e5eff2887f92711d605df7dc57a'),
(12, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:49:31.366324', '2025-09-26 07:51:24.484259', 'd0e7d42188a2c4d72b7a91e261622c7b7afe90b52a5968fc82919646d3ff3b45'),
(13, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:51:29.472750', '2025-09-26 07:54:56.019610', '3b5715d18edd7ba78c66d7d530da1318b153ac13c428ccb64d80ce5b0879c335'),
(14, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 07:55:04.033608', '2025-09-26 08:25:49.471705', 'eaef7125c39ad6bf7fda5c7398b75e493a6591b96eee6909928e3fbb7b475998'),
(15, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:10:38.272094', '2025-09-26 08:25:49.471705', 'eaef7125c39ad6bf7fda5c7398b75e493a6591b96eee6909928e3fbb7b475998'),
(16, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:24:58.216357', '2025-09-26 08:25:49.471705', 'eaef7125c39ad6bf7fda5c7398b75e493a6591b96eee6909928e3fbb7b475998'),
(17, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:30:26.745418', '2025-09-26 08:40:21.525316', '02b3c572719616550aa0a5ce206f6919510a72e4a58fe9c5ad4e0885b811f1c6'),
(18, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:32:48.675813', '2025-09-26 08:40:21.525316', '02b3c572719616550aa0a5ce206f6919510a72e4a58fe9c5ad4e0885b811f1c6'),
(19, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:33:18.226738', '2025-09-26 08:40:21.525316', '02b3c572719616550aa0a5ce206f6919510a72e4a58fe9c5ad4e0885b811f1c6'),
(20, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:40:24.614879', '2025-09-26 09:25:52.163253', '8bf51633816e089524b656b933ed3f6fc6255f556627eabea1bf76479861c861'),
(21, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:42:14.695664', '2025-09-26 09:25:52.163253', '8bf51633816e089524b656b933ed3f6fc6255f556627eabea1bf76479861c861'),
(22, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 08:44:43.401980', '2025-09-26 09:25:52.163253', '8bf51633816e089524b656b933ed3f6fc6255f556627eabea1bf76479861c861'),
(23, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 09:13:27.910067', '2025-09-26 09:25:52.163253', '8bf51633816e089524b656b933ed3f6fc6255f556627eabea1bf76479861c861'),
(24, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 09:21:55.570275', '2025-09-26 09:25:52.163253', '8bf51633816e089524b656b933ed3f6fc6255f556627eabea1bf76479861c861'),
(25, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 09:25:56.751620', '2025-09-26 09:27:33.475028', 'd8f7f303a0b060db401f9b974627f445ecbb7a6cbd9c38474fdcb3a39883a4d8'),
(26, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 09:27:38.188660', '2025-09-26 09:32:59.633165', 'a624537f63b3893f171484b219b31c00036b5588689eba4c8be3446f91e9da96'),
(27, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 09:33:02.639408', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(28, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:31:10.048502', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(29, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:33:14.752322', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(30, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:34:15.059441', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(31, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:39:30.658177', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(32, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:42:07.326032', NULL, 'f4f75472b6ed21a2c56cb959b6178339531a3e7e97f7e22cff2943e6c30ef91d'),
(33, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:42:20.788683', '2025-09-26 14:42:29.150616', 'f9b568a29e6d111a9e9a665b059af80c51c81fe0e1277ddad94054d0b5912603'),
(34, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:42:58.410222', NULL, '7994c04d8639c286792c6f73916889a4e642c8b3836b83c776375352ef3a2fa8'),
(35, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:52:24.343936', NULL, '7994c04d8639c286792c6f73916889a4e642c8b3836b83c776375352ef3a2fa8'),
(36, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 14:58:07.504845', NULL, '7994c04d8639c286792c6f73916889a4e642c8b3836b83c776375352ef3a2fa8'),
(37, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:03:17.030033', '2025-09-26 15:03:21.783367', '2181535b277dd89d621a950bbbd6abccf1af97023a1c3349146445968a54cc80'),
(38, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:03:26.980313', '2025-09-26 15:05:06.664126', '254d3b36c2edc9ce0aeec7fd5706dc636f4bac25042a12af734dcad27094a5cb'),
(39, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:05:10.024325', '2025-09-26 15:06:32.477932', 'ea9efa6fb56b63768c901d9fe423e3657b86f70afa6545d54cf4fef656f56178'),
(40, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:06:36.000127', '2025-09-26 15:23:41.694273', '99547ba829dc2aba54f4401a773582079b5760d5ded3d3490be6426425272db0'),
(41, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:19:11.470134', '2025-09-26 15:23:41.694273', '99547ba829dc2aba54f4401a773582079b5760d5ded3d3490be6426425272db0'),
(42, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:23:47.797769', '2025-09-26 15:32:01.606043', '53a12f7bf130129d30cbdf9f86af1a4e84ca56a16374b976891ca951ae8ae631'),
(43, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:32:05.068186', '2025-09-26 15:51:08.377065', '5ee819613307474c356f7d021177bc0719722d9eab766773831b049a7669da87'),
(44, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 15:51:15.478849', '2025-09-26 16:12:27.734569', '1bfdc24bbf219b9aa92e3bf4cfc8cd3d83ccef5ac9cad7d86a0e180910f2957a'),
(45, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 16:12:31.265857', NULL, '68ce543c0cbbc3c601f2361f5760c2b0283d582d31e2dcb0e509fa54d13a29a9'),
(46, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 16:13:41.022217', '2025-09-26 16:14:20.572437', '24363b1ace2543ee879e253ce6d5e27c48d4b127b482985919c822f1bd57ede0'),
(47, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 16:14:49.817887', '2025-09-26 16:15:14.451630', '3b535494b7e7674a0f7c4dfb9c4a6f5ae54d72304138c55a820150d32ade968c'),
(48, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 17:10:51.828630', '2025-09-26 17:12:33.963189', 'e5afee36ee245d7c0728085eca713e67c509b983a66b8b43d9bf3d3081dfb69d'),
(49, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-26 17:12:39.930031', '2025-09-27 04:50:14.044830', '4dae9904444a3ff9d40e511b969d73be1fd7341ad045a1c85bbedce9702428b4'),
(50, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 04:50:19.327715', '2025-09-27 04:50:36.710465', '3c9e4353d4bc5476be9d177b344d88f020fbbcde86ec07d52da3ecc6de5974b3'),
(51, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 04:50:39.717733', '2025-09-27 04:50:42.491243', 'fcc283f12ad4e6210321829d0768243156c8b15ca8389915cf228aff24363fc5'),
(52, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 04:51:16.010498', '2025-09-27 04:52:15.757157', '5aaac8da194d1843a913650dde96a78c64edf678e592c344e71d055cdc4b8d66'),
(53, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 04:52:20.120669', '2025-09-27 05:10:00.260933', '9058dc34589214aa92c8aba9dd79ffe9c41bb22ced0ee37a70e26ae191b3613b'),
(54, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:28:22.080015', '2025-09-27 05:29:05.925465', '87449fb04816ba6c7e036666948d7c2a1b22f4388a1dea88337a4757a501b011'),
(55, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:30:46.626848', '2025-09-27 05:33:58.203818', 'b3e8e5f95dbf4c3a15b5291049a9228c011aba23b9f10933fd1f8c12008122a2'),
(56, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:34:01.522751', '2025-09-27 05:39:20.136425', 'be84a8cfce53931e0289391bbcaf955030ad53ca18bc60b5e4f37b9eaa347055'),
(57, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:39:23.076045', '2025-09-27 05:40:10.241724', '30887a2d6eff22b724db36c7cf3c04391961aa0e9f7ab0c72efbfb5543b04d0b'),
(58, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:40:48.410362', '2025-09-27 05:43:03.153263', 'e600770a0619e11222a2ce2d3c729140f0f8b63d8964c8ec26493cc5ca1f1fbc'),
(59, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:43:06.523663', '2025-09-27 05:44:09.893388', '94c24367ce25963a2124caac2a02e9c97f1b35c90d5c57abab22b95dd3b43bc5'),
(60, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:44:13.225480', '2025-09-27 05:45:14.631538', '3d7b26ebd8fdb6eb3593976096d7b6090ae84c61e0e987c38c79da8b2f916889'),
(61, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:45:20.507931', NULL, '631294470d2475658184251933da56e3d60c88e3550a7856610788e18bd9b98d'),
(62, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/admin/login/', '2025-09-27 05:50:46.794730', '2025-09-27 05:50:55.046469', '0a41dea4d968caa0849d35f567fbc14bc61f19d92cb56dfb17848fa7096b5d64'),
(63, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:50:59.020043', '2025-09-27 05:51:02.959258', '9e12bb274bd513b8296de8a5768552a58132b64d64ae47593d38aff54b7106b5'),
(64, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 05:51:34.495422', NULL, 'f94dd4f4c5e3b6d07b5b0bdb0643637375873b7cd967c73075a504a585b5e403'),
(65, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/admin/login/', '2025-09-27 06:03:10.569688', '2025-09-27 06:39:32.635894', 'd2d85d9f7ef5e3023a6c32147aa86c0e2da9c656e03263a841ea3051b45cd529'),
(66, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 06:38:08.210431', '2025-09-27 06:39:32.635894', 'd2d85d9f7ef5e3023a6c32147aa86c0e2da9c656e03263a841ea3051b45cd529'),
(67, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 06:39:38.465274', '2025-09-27 06:48:51.354764', '5f7057b2731b2a170fa12294f68d19c4057683641b0cf7e5a0c25a668870f4ca'),
(68, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 06:41:13.603075', '2025-09-27 06:48:51.354764', '5f7057b2731b2a170fa12294f68d19c4057683641b0cf7e5a0c25a668870f4ca'),
(69, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 06:48:55.006096', '2025-09-27 07:04:07.901724', 'ffbb3d2349c09eae64a167cefb768778fd258d4bb64360c0cf909db7a0ce205b'),
(70, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 06:55:02.396282', '2025-09-27 07:04:07.901724', 'ffbb3d2349c09eae64a167cefb768778fd258d4bb64360c0cf909db7a0ce205b'),
(71, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:00:16.956238', '2025-09-27 07:04:07.901724', 'ffbb3d2349c09eae64a167cefb768778fd258d4bb64360c0cf909db7a0ce205b'),
(72, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:04:11.430160', '2025-09-27 07:04:19.374046', 'bd449d71a08dee49bf5bc7ac865d2fd396dd9fafe82c27dbf0553231aa9b3522'),
(73, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:04:24.942965', '2025-09-27 07:04:52.141269', 'f700662de47440c8d9842cc01bd511f569246214ce08d68debfaa8e67f882e6d'),
(74, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:04:58.489353', '2025-09-27 07:16:01.953321', '3ec39a1d7637f8dbafd8588d0d94c786f050c06f8ce2a84ddf8ae49df46432ee'),
(75, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:16:06.334355', '2025-09-27 07:17:35.593573', '4ba3b7c68c4ab2c706c1406eadf1a7a025b67525d9582b2b1097fd6feee789fb'),
(76, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:17:38.878957', '2025-09-27 07:23:38.606904', '52c2849d934c70f2ea2a859ea4f6393d9555eadb5fcd1e24168b0a014b441b5a'),
(77, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:23:42.081877', '2025-09-27 07:33:37.176628', 'a63b6b01f93b5d03e4ec156c4c3fb0955a8aa8a1ae876b849c3318631ae2b363'),
(78, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:33:41.268239', '2025-09-27 07:36:56.721487', 'bf9899c1395ae653066e62e5c319511845140df66e873bd0a6a192a04635b24f'),
(79, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:37:05.630809', '2025-09-27 07:41:26.971596', 'dca0e52f1fc7c13a7074e3a0c536eb66d3c78347596a29fd38f28bec7267d0d2'),
(80, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:41:35.662056', '2025-09-27 07:55:00.843875', '463e10e5182c8a29a85fe7f03597992ac571ce27483792d6403ea33a05c18690'),
(81, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:55:04.111947', '2025-09-27 08:00:00.995320', '6218bdc1eca492368f9c584855a0b6dbd5cb57b754a1371762e83241e02ec646'),
(82, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 07:58:15.541788', '2025-09-27 08:00:00.995320', '6218bdc1eca492368f9c584855a0b6dbd5cb57b754a1371762e83241e02ec646'),
(83, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:00:17.247599', '2025-09-27 08:04:38.301391', '2d71fc991f52a2d90532d13a3a07efc6f8ff967074b6faba21eefa7393597240'),
(84, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:04:41.249216', '2025-09-27 08:09:39.648128', 'b20922046f95225a30b8f161cf9c8ee328ff95ac5a9499429b7edc3be3c89071'),
(85, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:09:42.831671', '2025-09-27 08:21:57.471079', '38de7de4755fbdd3982463f62ccda18b26f1861851673de359fab05e911b970e'),
(86, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:10:35.462521', '2025-09-27 08:21:57.471079', '38de7de4755fbdd3982463f62ccda18b26f1861851673de359fab05e911b970e'),
(87, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:13:56.624782', '2025-09-27 08:21:57.471079', '38de7de4755fbdd3982463f62ccda18b26f1861851673de359fab05e911b970e'),
(88, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:16:18.360090', '2025-09-27 08:21:57.471079', '38de7de4755fbdd3982463f62ccda18b26f1861851673de359fab05e911b970e'),
(89, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:22:00.640995', '2025-09-27 08:51:14.912720', '6314c61d46e145abab581e7eac4f69df0e64c2ae6de0b21cd0435f36ac5373a9'),
(90, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:51:21.088664', '2025-09-27 08:52:16.459010', 'e9d604b2ccebc4726663d052d06be408005caf838601e2bb666c8d80aea288dd'),
(91, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 08:52:21.614878', '2025-09-27 09:19:00.004929', 'edb867ca7b6ea30d23b1e8ecdad62c4c80823de84624b0dec5a9014c76c73e19'),
(92, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 09:19:10.092822', '2025-09-27 09:38:01.165952', '70e6a6354c677d9b64ba2768dc8f761c55241f2c2c4027234eee2d11bf32f025'),
(93, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 09:23:21.218079', '2025-09-27 09:38:01.165952', '70e6a6354c677d9b64ba2768dc8f761c55241f2c2c4027234eee2d11bf32f025'),
(94, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 09:26:35.108390', '2025-09-27 09:38:01.165952', '70e6a6354c677d9b64ba2768dc8f761c55241f2c2c4027234eee2d11bf32f025'),
(95, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-27 09:42:53.179865', '2025-09-28 01:42:49.412562', 'c811fff6ae76ee26ec841ce41424cfa6d21055821aeeca9b2a187ebeddb6d0a7'),
(96, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 01:42:52.879686', '2025-09-28 01:46:35.693793', '05bb0b43d89a3818364622564c09f382ce9ac1c8b76261010488a11d2dfb0f3d'),
(97, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 01:46:38.291361', '2025-09-28 01:49:23.938648', '0b9b2792a4430ab52903393ac669ec4f737b413db6f948167d840b0bb17019ff'),
(98, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 01:49:26.908091', '2025-09-28 01:54:54.634216', '579a1c2d781a1c48234eb5334f9e15ea963059bffecc145dc2d9181e9cdb6ac2'),
(99, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 01:54:57.565824', '2025-09-28 02:05:04.221472', '232cbf40cb68047bfd43263717ffe1aeca4317e14b9692ee0ef843363105b595'),
(100, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:05:07.856772', '2025-09-28 02:22:06.116736', 'b3b8e9eb7d9cdc7080ab4f77fb3bf8bd6b888f205d394139407ede07c631cced'),
(101, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2390000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:22:36.653082', NULL, '67f233478fca3812ee9eba64dcb1818bf58d20e28892032badee09f50e4e9530'),
(102, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2390000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:23:11.670029', '2025-09-28 02:24:57.795641', 'ac5f321515ba00a98197d912d8e748e4b07941800fa88098c1ce849c307f02b7'),
(103, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:28:20.215467', '2025-09-28 02:38:05.480676', '9da7c9416e14c7d152deecd543e8535e6c49f214fa33b58b4d96628cbb4c39be'),
(104, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2290000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:39:17.144037', NULL, 'b150543839f07e52ed38fbdb1314ada23220d0a1d0c476184eb852fda868fa25'),
(105, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2290000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:39:49.669571', '2025-09-28 02:40:25.419864', '3af651cad7520ee26c2b7484e330cf4c2a6f9b12990705b149827ce82abccb6a'),
(106, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:40:32.791571', '2025-09-28 02:41:07.636812', 'ef30d95dd68231d341ddfea3b879dbbb8c3c2eb7c76f24d5e38e01a8f6052a43'),
(107, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:41:22.205644', NULL, '80eb69e700a8c6407fde53e9f628ed3aee24c4eac4b86068b8d60f08a629f87a'),
(108, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:41:45.572081', '2025-09-28 02:42:04.171198', '96c437c6066161d754bc892bf12751e82acbab2b5fe492f6ff3ac19ebd91ea8d'),
(109, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:42:45.455570', '2025-09-28 02:42:48.263129', '677fa2e35ca420c8a7c3a236b9c7423b6528cbe78780bda804e17ac502b6a0c4'),
(110, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:42:58.083850', '2025-09-28 02:43:38.263204', '8da57447596bd4bdc932b9d3642481529002320ca4efe786da7aa6aac2f45c5a'),
(111, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:43:49.054101', NULL, 'fc19eced2d7483013aab97a0b91df7dc6e8f6d0f12ce6a64346c089307ce7433'),
(112, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:44:12.157786', '2025-09-28 02:44:30.198879', '517e23440772dd57fb5dd8b94123dbfc2250a492d87809671b837c8b16bb373c'),
(113, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 02:55:52.332785', '2025-09-28 03:19:46.779179', '9199610455d0d309d3ab098ff9af6f11ce4ac864ea52965f084d5258582c3577'),
(114, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:00:10.908015', '2025-09-28 03:19:46.779179', '9199610455d0d309d3ab098ff9af6f11ce4ac864ea52965f084d5258582c3577'),
(115, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:03:19.330280', '2025-09-28 03:19:46.779179', '9199610455d0d309d3ab098ff9af6f11ce4ac864ea52965f084d5258582c3577'),
(116, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:17:29.708660', '2025-09-28 03:19:46.779179', '9199610455d0d309d3ab098ff9af6f11ce4ac864ea52965f084d5258582c3577');
INSERT INTO `axes_accesslog` (`id`, `user_agent`, `ip_address`, `username`, `http_accept`, `path_info`, `attempt_time`, `logout_time`, `session_hash`) VALUES
(117, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:19:49.710300', '2025-09-28 03:24:50.157285', 'f5e25721720c28dd5d2ac992c64ba1294ef62398df121dd5bfb7f60ec8c1096f'),
(118, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:24:53.084775', '2025-09-28 03:43:35.743324', '12cd1d39ffa0c93f975e857f14871c30e3dcfc75964a75cb487fbc3d291be324'),
(119, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:27:12.900903', '2025-09-28 03:43:35.743324', '12cd1d39ffa0c93f975e857f14871c30e3dcfc75964a75cb487fbc3d291be324'),
(120, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:29:28.515290', '2025-09-28 03:43:35.743324', '12cd1d39ffa0c93f975e857f14871c30e3dcfc75964a75cb487fbc3d291be324'),
(121, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 03:43:38.862526', '2025-09-28 04:42:01.988575', '6f3f958def3e1677b30933dc7eed48987775a4567bf4f4b48335d4d55e7e036d'),
(122, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:30:19.707174', '2025-09-28 04:42:01.988575', '6f3f958def3e1677b30933dc7eed48987775a4567bf4f4b48335d4d55e7e036d'),
(123, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:32:30.172502', '2025-09-28 04:42:01.988575', '6f3f958def3e1677b30933dc7eed48987775a4567bf4f4b48335d4d55e7e036d'),
(124, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:42:07.969060', '2025-09-28 04:47:14.233923', '8af55aef17d23906ce0428bd99881a34d0f71a717a1373cee2773c0f780cb933'),
(125, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:47:20.291897', '2025-09-28 04:48:16.685543', '9f7e4ff502b0921afb27a20c3c3c4f786adc4cae281439bc1c506ecda1c4b4c2'),
(126, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2210000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:48:31.982814', '2025-09-28 04:50:26.922072', '9d8a39bf781acfb9d900d8e9afcbd6ca036825c09adcd0c450bcb6709a2c0ac2'),
(127, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 04:50:29.994445', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(128, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 05:33:49.130390', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(129, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-28 06:33:43.783166', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(130, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 01:28:55.732819', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(131, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 01:41:26.754413', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(132, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:23:58.598951', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(133, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:24:38.513279', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(134, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:27:47.586031', '2025-09-30 03:30:57.576361', '0b30339b522737877b970f2b950bede01b8f497f7a57a1407a04d0751cea867e'),
(135, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2392079625', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:31:03.040979', '2025-09-30 03:31:18.422544', '055b17b8f8c1ccd4a36af80a68bdade379dc3e8ec6fd641ed427a954b6336030'),
(136, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:31:23.768984', '2025-09-30 03:31:33.764065', 'b7a1402cd9c47bf06a7e958679c070acc256ffde075738e1d2e447534c9c812d'),
(137, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2290000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:31:42.275467', '2025-09-30 03:32:22.626420', 'd6861c26dbf9b4a6140ab251d9dfa61b5c51c9a95d4031f6ac389c7afea4fade'),
(138, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:32:30.245099', '2025-09-30 03:32:51.845810', '7d5d3b7cce0ea89f24ddac280180e5aa82cfd2afa8e03178b6615184dc43b601'),
(139, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:35:13.200548', '2025-09-30 03:48:39.893901', '66aed6af33be0f36416e278413828c479b76b0f1e38162b3b4ebbc26a133f8ac'),
(140, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:36:54.987512', '2025-09-30 03:48:39.893901', '66aed6af33be0f36416e278413828c479b76b0f1e38162b3b4ebbc26a133f8ac'),
(141, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:47:59.598997', '2025-09-30 03:48:39.893901', '66aed6af33be0f36416e278413828c479b76b0f1e38162b3b4ebbc26a133f8ac'),
(142, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:48:51.297286', '2025-09-30 03:48:56.517948', 'a40dc92ac1872f0b5826723a1fad73b961a82f82861d1a7a9e582657eb7492fc'),
(143, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:49:04.990808', '2025-09-30 03:49:56.411747', '62c55236d129ed0a08fe905dc1e9efbcfc00e19df52a16f657f20d6901bbe74f'),
(144, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 03:50:00.989255', '2025-09-30 04:03:19.554269', '2612177118b455a7e6965b2c44dbc6c039a214df8ddee59461e038e74547d115'),
(145, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:03:25.494233', '2025-09-30 04:03:36.845825', 'd779cb996e671c12e5b67bf189661709ccb0c0ecdcf033272047307e421097ae'),
(146, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:03:45.524144', '2025-09-30 04:21:56.928866', 'a01330a51947ad7843441b3ede73f88073e97efd8e6ac7990a190cf7dab23cda'),
(147, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:22:02.544156', '2025-09-30 04:28:42.319810', 'd41b71e18c1ba7652ab7d68a18feb4ef68d336bacc3b71317ca310036e7a0ab0'),
(148, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:28:48.082505', '2025-09-30 04:29:21.941234', 'f8785c2d19fbc55fdf1b8e86cd66b7e0c0ad0ffd48005bc010598f908ce69a1a'),
(149, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:33:18.388101', '2025-09-30 04:33:26.193722', 'c90222cb6a98a8848cbe9adb88583e2b09f52e12ca9da436badd15dca30803cd'),
(150, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:33:33.260129', '2025-09-30 04:54:02.303829', '1462074d76124dd0bb0f98ca0d56e9a0966789ca8fd87a0031b6eaa6fa60f9e3'),
(151, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 04:54:07.339513', '2025-09-30 05:05:02.928309', 'd4fdf1cf05a4e23ecaa4f56610ddbaaf4928bc6969fb01dfce0738d4196eb910'),
(152, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:05:08.283183', '2025-09-30 05:06:18.381828', 'b7fab1ac4ea4069819783354be55ac9c79041621403e7af904351ce55a62661e'),
(153, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:06:23.482701', '2025-09-30 05:14:44.962717', 'aa7cdf8bb3be1f3afd48dcc6dce3a876f498943da9a8de87bf733efd44ce4138'),
(154, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:14:49.915929', '2025-09-30 05:15:34.504201', 'cb4c5888352dd34f952baecd3d38f5182fee2320e942b9b9d454d0d2aa42105c'),
(155, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:15:43.929721', '2025-09-30 05:16:00.913691', '4e82d2fe41202b66bac3dcf4c3da77ab54fca3954b1e25f31323142904821d7a'),
(156, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:16:06.367465', '2025-09-30 05:17:24.413274', 'b849d9b2824ad608d36c4d585a0669b91fc39bc5d62d0f5bef92f048c1c327fc'),
(157, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:17:28.848154', '2025-09-30 05:24:51.726212', 'db5ae13ef5b060fffba0a22c4945883e987c3c1184eb947899b6401d8b411e4b'),
(158, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:21:35.249430', '2025-09-30 05:24:51.726212', 'db5ae13ef5b060fffba0a22c4945883e987c3c1184eb947899b6401d8b411e4b'),
(159, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:24:56.955209', '2025-09-30 05:31:27.339940', '374896706743b2d8b284c26c93eab3c74580ada4f2f3c848b608bbb379b6356a'),
(160, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 05:31:30.044860', '2025-09-30 14:22:19.226503', '0bc3a0a831cb7961aa21a680f526c136f5b6651cf7ccd316ec75c1898002965c'),
(161, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:21:43.786557', '2025-09-30 14:22:19.226503', '0bc3a0a831cb7961aa21a680f526c136f5b6651cf7ccd316ec75c1898002965c'),
(162, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:22:25.042979', '2025-09-30 14:23:01.256350', '68d2a1c435ddeeed3249c5b8af00bc6104fbc0484120161b1ad574cabdca6596'),
(163, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:23:19.471979', '2025-09-30 14:23:43.140158', '02c13b99069baa12afc80f33558f4c16bcb82bf1a56d5ce76c6526749a7528c0'),
(164, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:26:27.954413', '2025-09-30 14:32:40.174315', '2aa22a40d333c21e1f65b249c55d56e8c217c2f8605d410db666db8f18d3c6c7'),
(165, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:32:45.445026', '2025-09-30 14:48:34.535766', '25c610189b71966d6e1866c6de12cb118c16804c180e0a207a51be7cc41a4715'),
(166, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:48:40.298336', '2025-09-30 14:49:42.113925', '4620f5ddc44e3dd5b5816f3bcdc59e53cb95b088645e2c334d89a078436823ba'),
(167, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 14:49:47.754222', '2025-09-30 15:10:39.817618', '025a1268fcfe999c6164138d93c6cffafbc3613d2f7bd92f0bb6fb46ddd525b3'),
(168, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 15:10:45.034479', '2025-09-30 15:10:52.723218', 'd951360bd8f3d7f6907e90bd9aea6f69087576a09c7ad05cec1a1c7585b01f2a'),
(169, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 15:11:00.590515', '2025-09-30 15:15:19.348986', '900fbc5dc24f60a548cd3674434a6b966079680b8c3e03af28fbd9353eae0dac'),
(170, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-09-30 15:15:24.416282', '2025-10-01 02:14:45.890525', '052434973e20a863b2c221fb148c0e407dc003a0a81d808d9bf073d4cf8aa32c'),
(171, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 02:14:53.842228', '2025-10-01 03:01:06.472686', '554832254fa11a7ecdb077ed14efcbb2d27b21973e23644e4b94d7350617c5b8'),
(172, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:01:11.907889', '2025-10-01 03:02:17.507344', 'e3bcf4b4aff22a4d7cf8d3cc7d40a25fa0d4b4929fb222eec3e38246e29bd84f'),
(173, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:02:23.596493', '2025-10-01 03:09:29.537548', 'd4602fd11c704f282559e624249b91ecd622591dc05e09279d7cc9d7df1e3a88'),
(174, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:09:35.635697', '2025-10-01 03:10:14.721847', 'ea696fa806878f5bfd8b696f88ec5d7bbbc53015106b10c233bc5993d965904c'),
(175, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:10:19.866568', '2025-10-01 03:11:01.689679', '4c81d7800ff224a816c611596c744a3b4bcbd3073a110d9a0dcc427dc71b2899'),
(176, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:11:06.446607', '2025-10-01 03:16:08.409835', 'fade15943d8f79c15fd8b7e12ef4115c539276f6673766dbc8cd87382d71f236'),
(177, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:16:13.150097', '2025-10-01 03:18:49.628906', 'a7c9c9437c25b133934dda5795ded156a4985bd167faf05fe5578f387df72e68'),
(178, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:18:58.260648', '2025-10-01 03:20:04.816556', 'd8a4f6759053d93e1b69b9bcf6528877f3420f376e9c40d7523e283b3b68c308'),
(179, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:20:10.196103', '2025-10-01 03:33:09.256145', '79224e0b516f31768e4cdc926ae665275280261fc0615a74664f01090f5480ef'),
(180, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:33:13.716338', '2025-10-01 03:33:39.347087', '1328d2d055aec6bd5be45d5775e538e71928b2b030c1d7f9087b78910e91586c'),
(181, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 03:34:47.375738', '2025-10-01 04:36:22.682907', '6826c05b0aae56a8b3e4ba92ef631cab3e9276e9a363f07aa26b7e289b4198cb'),
(182, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 04:31:13.713995', '2025-10-01 04:36:22.682907', '6826c05b0aae56a8b3e4ba92ef631cab3e9276e9a363f07aa26b7e289b4198cb'),
(183, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 04:34:10.855481', '2025-10-01 04:36:22.682907', '6826c05b0aae56a8b3e4ba92ef631cab3e9276e9a363f07aa26b7e289b4198cb'),
(184, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 04:36:26.525084', '2025-10-01 05:33:27.411426', 'f5ec7c8173ea085987f96ebec1b89724bcf9d3a517e9e05c418e8621496fe244'),
(185, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 04:47:25.486843', '2025-10-01 05:33:27.411426', 'f5ec7c8173ea085987f96ebec1b89724bcf9d3a517e9e05c418e8621496fe244'),
(186, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 04:51:29.043200', '2025-10-01 05:33:27.411426', 'f5ec7c8173ea085987f96ebec1b89724bcf9d3a517e9e05c418e8621496fe244'),
(187, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:30:39.230248', '2025-10-01 05:33:27.411426', 'f5ec7c8173ea085987f96ebec1b89724bcf9d3a517e9e05c418e8621496fe244'),
(188, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:33:32.557167', '2025-10-01 05:43:57.534376', 'f8a40bf75d71e5fd7ce52dab47541644963f6a88a28a16598d86d122f3b731e3'),
(189, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:44:02.793836', '2025-10-01 05:44:21.099842', '168dc3f85bb27ecb3d1055bd30f234c667bcf73e925a13443148bd1059991efd'),
(190, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:44:26.989827', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(191, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:56:20.107996', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(192, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:57:00.253858', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(193, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 05:59:49.859658', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(194, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:00:20.354040', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(195, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:01:17.208162', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(196, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:03:17.216636', '2025-10-01 06:03:30.701928', '3547dd6d4f7a21b420434e606022b563ec23812f70af14793bf6bfe9259dd409'),
(197, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:03:35.648832', '2025-10-01 06:15:54.055581', '2c4f9ef9a1aba379f68e2cf3578022dcf7dbd8b957e8333adc3c0ee78f43c59a'),
(198, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:11:02.555938', '2025-10-01 06:15:54.055581', '2c4f9ef9a1aba379f68e2cf3578022dcf7dbd8b957e8333adc3c0ee78f43c59a'),
(199, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:16:03.411911', '2025-10-01 23:48:32.298013', '6bb7e15640315702bde04068865ceb1a5bc96e2a61d5fa36d6db433b9b017bc2'),
(200, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:19:41.977483', '2025-10-01 23:48:32.298013', '6bb7e15640315702bde04068865ceb1a5bc96e2a61d5fa36d6db433b9b017bc2'),
(201, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 06:24:24.205894', '2025-10-01 23:48:32.298013', '6bb7e15640315702bde04068865ceb1a5bc96e2a61d5fa36d6db433b9b017bc2'),
(202, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 23:48:46.606202', '2025-10-01 23:49:26.857837', 'dc60a2dc93b4cb6c7d4e84b194fa2241499109c014b1f6a9833429e29535ff32'),
(203, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-01 23:49:38.616841', '2025-10-02 00:33:00.231530', 'b16a6b57e3fc3b3bf88e94887c75b53fd506543887c2b00496338fec19474cf1'),
(204, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:08:37.294549', '2025-10-02 00:33:00.231530', 'b16a6b57e3fc3b3bf88e94887c75b53fd506543887c2b00496338fec19474cf1'),
(205, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:13:17.971102', '2025-10-02 00:33:00.231530', 'b16a6b57e3fc3b3bf88e94887c75b53fd506543887c2b00496338fec19474cf1'),
(206, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:33:06.132222', '2025-10-02 00:33:35.516215', '48d58137fcd4e4bb85514f3aa8ee60d135cd8c20927751499f46eb3be6382e12'),
(207, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:33:47.289897', '2025-10-02 00:35:59.392403', '52a91703c99204f7361d21036d354ef9dc040d173615db57c25c97b67f57e9b0'),
(208, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:37:13.535697', '2025-10-02 00:37:41.641101', '9ae8c160922f77e93b057f62ebd633534f46030681749da87199b49c686af17f'),
(209, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:38:12.416107', '2025-10-02 00:38:24.488348', 'ab940c319a0236687997bafabba9aa3f498eac761dcfb1a61ce29a52bbb4b988'),
(210, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:38:29.424700', '2025-10-02 00:39:45.257164', 'cf2413498ef02625908b9f184e193c68c368f4e3253f6b2b6971225faca48cee'),
(211, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:39:52.229964', '2025-10-02 00:43:23.941954', 'ae5c3b8690935047bfb4c2c99dac800f871af5a49da5c08d08a1cf88fa533a32'),
(212, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:43:32.822128', '2025-10-02 00:51:54.544318', '826c2a1b21d1e57d72c237245ebc661637a84e62cf29ab21e843b36e7ca82b54'),
(213, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 00:52:19.400809', '2025-10-02 01:07:05.568582', 'f5eb6b9ab32651741f7009ba0f3522fbcfb786216318e5e0d6b529f9de6bdd40'),
(214, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 01:07:12.480006', '2025-10-02 01:07:20.176487', 'e489e75ae35c1c745b8653fd527021b2069a300019866cfc055d985292878eb3'),
(215, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-02 01:07:25.545261', '2025-10-02 01:07:46.318219', 'e66f155c7151281a98f0c72f381be8ede9bc095d5219d0bf36ae18f4ec29a7a8'),
(216, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-04 01:40:09.578155', '2025-10-04 03:33:58.265332', 'c399facf7da72aeb05f325b6c0f15d27d0c83c8fa2a3f3a196a60f8936e8e50c'),
(217, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-04 03:33:54.805153', '2025-10-04 03:33:58.265332', 'c399facf7da72aeb05f325b6c0f15d27d0c83c8fa2a3f3a196a60f8936e8e50c'),
(218, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-04 03:34:03.813224', '2025-10-04 07:35:31.186193', '580c22c628a1a8bbb000b0a0e51bd78f39d57afa8ff3f8e139042c3f08c770b6'),
(219, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-04 07:35:38.012814', '2025-10-04 07:35:46.672914', '3aa1896c5a34300f83a1f22bf6eaa41e90a625185b44457f44e0b122e1e3fcaa'),
(220, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-04 07:36:02.709664', NULL, 'aaee33b352a876e4a815a6d46db2107525ed4d1ed675863b6334850c222681a8'),
(221, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-05 01:47:23.657658', '2025-10-05 03:08:38.208988', 'a3ea991370595fd3c6d8875b139f218b4f7cd010fc9bda464a1de7847f2eee65'),
(222, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-05 03:06:28.528927', '2025-10-05 03:08:38.208988', 'a3ea991370595fd3c6d8875b139f218b4f7cd010fc9bda464a1de7847f2eee65'),
(223, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-05 03:08:55.626632', '2025-10-05 03:44:08.133948', '4e16206af264b9dac052cf5730661ac735ef63e1ee46545729e8474b18c94b29'),
(224, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-05 03:44:14.394218', '2025-10-05 06:41:24.791470', '7b70f5de7ff497914cd8c95a5628fc8194a7a78a5ad4d06f4b03cc0a3215f561'),
(225, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-05 06:41:36.785363', '2025-10-08 04:40:16.907503', '76e3b1e560213bc4ec14c256daa3906c59ea033788c705fab77927eaa5f254e3'),
(226, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-08 04:34:59.960340', '2025-10-08 04:40:16.907503', '76e3b1e560213bc4ec14c256daa3906c59ea033788c705fab77927eaa5f254e3'),
(227, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-08 04:40:28.526576', '2025-10-08 07:25:53.145032', '9246d242ffce22f760f13800b85ef5024cfe9899ac0fe9cad0fa52f3d7bfa58c'),
(228, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2290000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-08 07:25:58.614372', '2025-10-11 03:54:38.504207', '3d00cae9f743f89a9e157fb6530f21f08c36367648f55fc83d571b80b00d5007'),
(229, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 03:54:45.595592', '2025-10-11 03:55:38.642939', '42e6ef9f37bab5dc75f6bc01e7860fd8ffbc2abe81ca41d8cd2bd721194c088e'),
(230, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 03:55:46.924953', '2025-10-11 03:56:43.492244', '8300eef42afe7a0b34e80f509492e474afb99d7c932be95546eeb146f69e9de4'),
(231, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 03:56:51.277869', '2025-10-11 03:57:10.111579', '32ae18394ae5ab9ceb48b8cb7e727b8c9bba03bf7848340b18c1d5e64d4893d1');
INSERT INTO `axes_accesslog` (`id`, `user_agent`, `ip_address`, `username`, `http_accept`, `path_info`, `attempt_time`, `logout_time`, `session_hash`) VALUES
(232, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 03:57:24.470988', '2025-10-11 04:01:57.094933', '08d38e5b5df86cac868482d8cfcd0bff9958a6450c96bde096a6200cebbc7618'),
(233, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:02:03.915446', '2025-10-11 04:19:56.738893', '283c8ec400ce7f8970398cd962f916045ceffcd6b4e4d85078ba92d0f81cba19'),
(234, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:20:05.246970', '2025-10-11 04:20:12.778085', '3cc08dde3df98f92629cf089f9e4aea51eba566f0b1b1cf2bc476d0b49092fb1'),
(235, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:20:17.738424', '2025-10-11 04:20:20.212723', '61b3fd708ec59a4b6fef347ff7d2ed09fcafaac25b0a6b632b65e3dbd99025a4'),
(236, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:20:26.762541', '2025-10-11 04:23:38.837134', 'adf324dfb839081309e0fefa5b56ea5ddc380c589b7536e074a589f73dcd1669'),
(237, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:23:45.589722', '2025-10-11 04:24:43.361222', '7b06f694105ab7fc8b94ebc1ee0727412ecd426948b84e409ef720fc18877e5c'),
(238, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 04:24:51.616684', '2025-10-11 05:49:26.589387', '1a0075a36fd380c6a219083be6b452eb9bc2fa65acc7ee65343c91e3b4825c8c'),
(239, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 05:49:40.536392', '2025-10-11 05:51:52.344000', '0c12e39d2f48289e3e4429e80ac477ab45a2c0ae393cbdefcb123e60d30f33c5'),
(240, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 05:51:58.393488', '2025-10-11 06:20:29.079013', '0c046ba0383bc148bf06024645bb865c4b292878aa7a07ddebf3d7ca224c236e'),
(241, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 06:20:36.325342', '2025-10-11 07:01:55.051214', 'bb1a8ea010cebfc202b380ba8ba919c8fb0094dadd9b96cc6282b15427ebb886'),
(242, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:02:02.094749', '2025-10-11 07:02:28.272904', '0d282717a9d296ab312fcc758cdf32a855202487f39052dd50676baaf9ad28eb'),
(243, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:02:38.232520', '2025-10-11 07:03:21.422767', 'd6b3b834a6efd1106e449e8973e169490e2e9cc6d18b3f696ce505f3e85fc40f'),
(244, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:03:32.462016', '2025-10-11 07:04:56.455072', 'cd970e780e88b65aa5cf6d053c793be3c86a9ab930b77b13c3502876cedb9d6a'),
(245, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:05:13.713103', '2025-10-11 07:06:27.485093', '72f96f6c068562168a31adf6e49644ac6af6a3e7e87ac454b108e5e813372a6b'),
(246, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:06:32.566626', '2025-10-11 07:06:35.734498', 'f6550487983fa432e25fe7c00d262138701780bceb7b98d78a47aefc748759c1'),
(247, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:06:40.737997', '2025-10-11 07:07:01.297612', '82f76513a3a0716bc02065883a2ab5f81f041f687042ef2414d0a4d915ddd034'),
(248, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:07:07.964607', '2025-10-11 07:07:13.872684', 'a0666207ca06494822317fff46f41bc72ad0e27067ed9343da730964035eaefd'),
(249, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:07:19.644859', '2025-10-11 07:07:27.869117', '957f26ff8e1e862e111dfc872a5cabb37dc3ec5a72b91c12e1d2f79952614c99'),
(250, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 07:07:32.611389', '2025-10-11 08:30:56.559321', 'eca25a36e36f3bd5f84e85cb76b9741fe743317232ecc6e04e6d7565a11cf90e'),
(251, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:10:11.701735', '2025-10-11 08:30:56.559321', 'eca25a36e36f3bd5f84e85cb76b9741fe743317232ecc6e04e6d7565a11cf90e'),
(252, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:19:22.701837', '2025-10-11 08:30:56.559321', 'eca25a36e36f3bd5f84e85cb76b9741fe743317232ecc6e04e6d7565a11cf90e'),
(253, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:30:02.418648', '2025-10-11 08:30:56.559321', 'eca25a36e36f3bd5f84e85cb76b9741fe743317232ecc6e04e6d7565a11cf90e'),
(254, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:31:05.495636', '2025-10-11 08:31:54.118920', '056bb0176eb2111d52582945ddcd3d7cfa879e5f818b597f6bdf71370d2f09d7'),
(255, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:32:04.821539', '2025-10-11 08:32:28.025843', 'c0115e43a65f5a0141445139c4ae18bc3c1eb1ee50598cf402102542c3615511'),
(256, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:32:33.310627', '2025-10-11 08:32:57.279804', '99f315a3aa92350f7e5ff8ba191c80b2dd5fa100555d3a0a1c08f514b06aee0d'),
(257, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:33:05.138705', '2025-10-11 08:33:22.618781', '4e79204e9e93cb63e295773428da007f1c2fac4258b1196b6d54e644d069fc31'),
(258, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:33:32.256413', '2025-10-11 08:33:50.496490', '9ef20d7155d06f0239b8766501fe517f08c7f8604ae59b45b013058f84a2b12d'),
(259, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:33:58.295408', '2025-10-11 08:37:47.337903', '13d760853b07c935e9d82439343441724d5e110dc15aa419cff5b0a47b3b2095'),
(260, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:37:52.084291', '2025-10-11 08:38:08.838766', 'eff2a5fb6160ffcafa3067b7475a84ab725d6c99cd922f2b25a2fdc273263f07'),
(261, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:38:13.712592', '2025-10-11 08:39:02.407309', '63a51daad78df12a05088edbddb4a5927a5390dfe7029fcd8ffa750895182f79'),
(262, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:39:16.256364', '2025-10-11 08:39:31.965826', '1bbedf622ea76bab3b3a0f74797826062b864ab9928bf6cd9d4881218f13bd4e'),
(263, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797665', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:39:37.480452', '2025-10-11 08:40:11.324141', 'ef10337517bfa1d4b62ece66c251ee42c0805968edbd3fe2adf0ff93585218b3'),
(264, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:40:18.316442', '2025-10-11 08:43:23.999780', '1873efb443413b20367dbfde250f36aac04734f7192b5601981640b4e71e7a85'),
(265, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:43:33.340362', '2025-10-11 08:43:56.463680', 'b1bf94fddc06570daf73bff3d26bfb3e008bf0f7352f853acd6faf59c245bf27'),
(266, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:44:05.815132', '2025-10-11 08:44:26.403767', '96e13fc537f53738bc80565002ab389f90c7d109395af6bbc45fa5d2d137b0e6'),
(267, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:44:42.975805', '2025-10-11 08:45:46.372992', '7b6abb08e802b258bb580a9d36792153c9757e3e0560ff4c588231cda8a39aa0'),
(268, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:45:49.176513', '2025-10-11 08:46:22.525648', '1881417bd43d3c28d28e7697e66f4ffa7d3f3ee3de1b62dc75de636c195917d2'),
(269, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:46:27.499564', '2025-10-11 08:47:02.965285', 'edf88b9badad3025d9c01ee3fb13782cfeb09fcad37c1e50f89a89ed9c96d463'),
(270, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:47:11.840118', '2025-10-11 08:54:35.213056', '9e318471d3e81ed945a2585201b2f77634c9b60949abbc1069bd44e116ce9e39'),
(271, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 08:54:41.245199', '2025-10-11 10:09:14.431684', '7b86e8c57f44679ed28e71bf961d32babf7af37a981824448ed554fe834eb64d'),
(272, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:09:17.441484', '2025-10-11 10:10:49.183509', '42d55ab635b8d46d0bc87af43f6b8a4bf14612a38a59d8927afaf7cf29ac2722'),
(273, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:10:58.969384', '2025-10-11 10:11:47.406680', 'ff841a8ca34faef0cb732966ad2fa24ec84002d7a914d107a887ba31d142a797'),
(274, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:11:53.058477', '2025-10-11 10:26:00.595410', '7dddf459bc2e71edef1182478d3eab9e02337ccc5243d09ff00836d13b6b85d6'),
(275, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:13:01.826715', '2025-10-11 10:26:00.595410', '7dddf459bc2e71edef1182478d3eab9e02337ccc5243d09ff00836d13b6b85d6'),
(276, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:26:04.263302', '2025-10-11 10:49:59.500191', '8a5b3b606a0a85ef439a3355fa4c6cb4d55510463a2a9c47236c1256d4e16f6d'),
(277, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:50:05.733827', '2025-10-11 10:50:31.097913', '8a753e29a4be696c9acb64fd315b32c002d0383161b7a53c6f2a0cf34f3db3ee'),
(278, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:50:37.628183', '2025-10-11 10:51:00.840882', 'cb8f9dbccd8231b543a6bfdcf1bf5b0a1b8ed53c7fd4f3cff9c195a5531aa610'),
(279, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:51:15.810313', '2025-10-11 10:52:52.501934', 'e68794a99d0f8bb73b6e4ca45e6fa7fef234aa5838b7e3834cd058b723a272d3'),
(280, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:53:03.980194', '2025-10-11 10:53:43.880248', '69d43205673a275692573f526da046e449fc0816979c2baba3446a562d2fcb8e'),
(281, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:53:48.555447', '2025-10-11 10:53:58.840248', '40bc32a0360635ee636e95423dea02045a0465dadb4dbd2ee494764157f341ae'),
(282, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 10:54:03.716716', '2025-10-11 11:26:13.843047', '8c8074f84925c6a19e3c7c4b145955b8268196b311d32c144d20e0387aeca99d'),
(283, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:09:44.541455', '2025-10-11 11:26:13.843047', '8c8074f84925c6a19e3c7c4b145955b8268196b311d32c144d20e0387aeca99d'),
(284, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:26:21.001606', '2025-10-11 11:27:38.641163', '68d64154a8c0684b03a26ada9b9155fe0b1b592af7cb269ba93f90989dfecb71'),
(285, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:27:44.086874', '2025-10-11 11:28:13.452159', '3b6738b2463d0ff211c1c01d7f21f1484b6e1667ecaf8b9b905105b8f1c2fcc9'),
(286, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:28:23.100078', '2025-10-11 11:28:32.857873', '0dedc14da8b00bb0701a6bece66965e2018f9b661a6300c50990317905115089'),
(287, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:28:43.620699', '2025-10-11 11:29:14.704120', '938aaadf6ac456cebeef76e0734fd2002254deb4d41ff7a944acd81aaaad0c88'),
(288, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-11 11:29:19.590360', '2025-10-12 10:28:56.498664', 'fcf130b24c0236f404ac94b1d1053202c9f2b6cd150eff0dedd8def48a975697'),
(289, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-12 09:02:29.242260', '2025-10-12 10:28:56.498664', 'fcf130b24c0236f404ac94b1d1053202c9f2b6cd150eff0dedd8def48a975697'),
(290, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-12 10:23:31.974267', '2025-10-12 10:28:56.498664', 'fcf130b24c0236f404ac94b1d1053202c9f2b6cd150eff0dedd8def48a975697'),
(291, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-12 10:29:20.807755', '2025-10-12 10:30:05.499134', '32853188224f3cba7d64f5cd0b4aefd5b6284957ed31321cf125b0b429f93f29'),
(292, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-12 10:30:30.373119', '2025-10-12 10:53:13.545796', '4ed884b4ed6b773a2cf4efdfd65e8ccc0584ecb5fbc7b8ad77aac6c88ff910bb'),
(293, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-12 10:53:49.566195', NULL, 'df70986a2e8fdaeab048aee754152318fdd41a71beaf0bdbf455aae5b592e4ba'),
(294, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-13 04:20:06.646329', NULL, 'd12493307d3fee6733ed7cb988197f2eed77b9f179affe5db507f0df13bbda80'),
(295, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-13 05:50:41.594532', NULL, '2aa25e1612ac479085141e6482a9038cdf4bd87541d046ee74452052cf168879'),
(296, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 05:58:53.275461', '2025-10-14 05:59:06.195126', '9d5d0351a813d4e18d7e5e5ff8d0b3d885e66e39d3ac6b583f05ac64649f14e4'),
(297, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 05:59:20.156771', '2025-10-14 05:59:23.710721', 'f07aa4602c04c8091982a0dad3298308ab1cd3222323b968e61168dcf688d811'),
(298, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 05:59:41.497060', '2025-10-14 05:59:44.656369', '08c35073bee6d6dee94c87245052eb4c14b755845399b820bfa3f87bca151067'),
(299, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:03:06.815116', '2025-10-14 06:03:09.165531', '6c68f3654f65dcedabaa20b4fb068e31f14733896ea51517c406dcc5e3847bb5'),
(300, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:03:14.341258', '2025-10-14 06:03:16.399850', '110f6adc8353ed33a751daa726f3650b7788155b936b6a3ecb3f5b7d9e08987d'),
(301, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:03:20.140276', '2025-10-14 06:03:21.915397', '31e77e69f3053426a6979a6ecf9ebc8296baeb1710c35c48bc3d93b6f389d1c2'),
(302, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:17:51.289182', NULL, 'e8e7e5d0376d54621bf5781a632d0e3150626c07e566bf933d42908905b47390'),
(303, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:49:51.143462', NULL, '0fa71231942ac2714ff43aa2eebc8dcf6b3ebd5ddff80ff122f9bae3b58213a7'),
(304, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:50:14.400401', '2025-10-14 08:39:45.245056', '6c1493b8a4975b832861ee27b471353f4409865c58a4720eb64057a6a825e002'),
(305, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 06:50:23.401648', '2025-10-14 08:39:45.245056', '6c1493b8a4975b832861ee27b471353f4409865c58a4720eb64057a6a825e002'),
(306, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 08:39:53.724961', '2025-10-14 08:41:30.797182', '9941cd27abe918c172dc6164046c48822ecfc5ae14e8b5142b035de3be3d5055'),
(307, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 08:41:38.385719', '2025-10-14 08:42:25.334346', 'a015c262671da1f290576ee8ed6703056884108c674f146a0c11f07afe3d1f85'),
(308, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 08:42:31.115878', '2025-10-14 08:42:39.157321', '81dc79456a85961cedaa09756f5fc1bf3deb529cd9ac1d8d45daaf6d099510e6'),
(309, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 08:42:48.548848', '2025-10-14 08:43:24.055478', '8a4f4340ec9d512f4f2607a3723aa237c89f1bddaecd8e87f4dbf50e280a5eee'),
(310, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 08:43:28.034964', '2025-10-14 11:42:38.217208', '23e36ee32820640758a767a72bc119c66966b9fb56d0381280b46bb60080aa76'),
(311, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:42:51.697369', '2025-10-14 11:43:29.538877', 'ad6a40955f7ded9865a80cafd752b5c4e1971280ba5dfb3d35ab1143ca4c20e0'),
(312, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:43:35.917730', '2025-10-14 11:43:54.835058', 'fa6ebad41dbae103164d20636ad4f7a718b5b2a20210da1aed5ef56181e6cb4c'),
(313, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:44:00.160623', '2025-10-14 11:44:33.078368', '604f95991b04cf9a8dab946af345debb0a16f738aebc0cf98be8531be7d9e369'),
(314, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:44:38.698490', '2025-10-14 11:45:00.674588', '625d71e93cb734a2cdd592757ab7dd092a9973673c991833096cf6335896285f'),
(315, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:45:06.090101', '2025-10-14 11:45:18.763025', '4fca14c04fdfdffa21ef5c88e509f1d23d1bdbb3678d2982a638abfc652d5f68'),
(316, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:45:25.311757', '2025-10-14 11:50:04.567330', 'd71350278aa3e93a335eaeb3815a50bda0cfc437f7d201b055432e587b1e9559'),
(317, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:50:12.152039', '2025-10-14 11:50:27.756315', '6d7a4be87242a42e2e555b9b464dc840b10c055c3be9eaf25dbfe4296b923672'),
(318, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:50:33.246276', '2025-10-14 11:50:44.019019', 'e9a787b89d7d5245825ce6249ff9374a3527b78e77ef5ca46fbca4ece6d5078d'),
(319, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:50:49.390571', '2025-10-15 05:01:30.067170', 'e4966d5bf5aeca0fdb0fe3ddb4bd115c2f0d1c18a3b604e915b863f84df19c59'),
(320, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-14 11:55:18.207552', '2025-10-15 05:01:30.067170', 'e4966d5bf5aeca0fdb0fe3ddb4bd115c2f0d1c18a3b604e915b863f84df19c59'),
(321, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:01:40.765003', '2025-10-15 05:04:39.373813', 'c50b347c38ac72599aa84e16ebbf015f1f8d01f275aff59a97cd4bcf35afd122'),
(322, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:04:47.266466', '2025-10-15 05:07:50.357444', '5180a996905f40c21b8d1b5bd2206feb7c17ed99623904aeffe10cb2f6503a48'),
(323, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:07:56.305896', '2025-10-15 05:13:03.705047', '765620bccb50e011d9af42d28f169e59a6523f6c64d6783a483e3a4aaa3761d2'),
(324, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:13:12.930421', '2025-10-15 05:13:15.080525', '2cc5f0ab4496b108f9327df8e4cde0a328bc9ef8457c401f894bdd455284f75e'),
(325, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:13:19.972919', '2025-10-15 05:13:57.382284', '45381de1f57e480df93fd084bdfd46df47a3b4e9ed5071eb55bdbc94c128b9ff'),
(326, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:14:01.249920', '2025-10-15 05:14:10.614227', 'be186ab5d90f9bbc7415b37ad3661d116e8bb83a8b025c682af83b3103f9a63e'),
(327, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:14:14.345274', '2025-10-15 05:22:52.175399', '42f4d00d55fcb462d346c94de1342eb0c1c3b267cba638e1c890c9f1c7efecb8'),
(328, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:23:02.020301', '2025-10-15 05:23:15.835187', '724750a8d3edd09a393cdfc0dd77905825ec92e2a3ab117bd990484c9818a467'),
(329, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:23:24.816990', '2025-10-15 05:23:33.383229', '89c9f6a294127253a4272cb493428e9aab3a4704466cdb79276587ee3d78d9ea'),
(330, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:23:38.900995', '2025-10-15 05:23:56.680483', 'c92855273d951886014bb22fc0444a5935b2be55f3a486ce6c58e4f28c85cdf8'),
(331, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:24:02.480523', '2025-10-15 05:24:22.925590', 'd9b0cace713bef9da3e473b713cc903034f235b3ace4354522902a8535cc1865'),
(332, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:24:27.422482', '2025-10-15 05:40:06.220230', '7cb6f3f9cdfb59ee50017290b4c911bc6aed4cb9160fec0e71a9b85a266e6f60'),
(333, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:40:10.427724', '2025-10-15 05:53:27.955564', '9ae216166836f42af061dc6714602854d35a9bb657fef8860a60b40ce0a6de51'),
(334, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 05:53:32.713956', '2025-10-15 06:41:29.838918', '0929595619da6143d3dda040e8521ced830c468d180c6f35fd33d8b05a878df9'),
(335, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 06:41:39.699034', '2025-10-15 06:41:49.281738', 'c78d222e86bfb16ac6a9dfd69d1ee9d67df5655d4730d2287ab02a6ccce4e579'),
(336, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 06:41:53.011695', '2025-10-15 06:42:01.923253', 'dd3ef09ff299864f7d7a755d02e7d0a32dae23bb48bf117119c86784413f2974'),
(337, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 06:42:05.091557', '2025-10-15 08:04:26.015748', 'ff817ec5a1bb47c0fd1465c2ed51799b25a8f1390451007c6a09cab37ae4acfc'),
(338, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:04:37.318338', '2025-10-15 08:05:00.828230', 'bc245ba220cee40267ea51d1d45431d518b578f8cca8676316234567edfbf9ff'),
(339, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:05:03.759352', '2025-10-15 08:06:55.275418', 'cb5013ec85f9309d02f53a8b18432bb0bc510fd2544bf0ec5a1ac77c704d335d'),
(340, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:07:04.853877', '2025-10-15 08:07:11.936914', '3ce99932a8f46cbfa1324db093904a881add8757de7325d96c9d977ce40ee2f6'),
(341, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:07:15.151421', '2025-10-15 08:08:26.804789', 'cdc969f12c05753e17eedc00c417e04342e731c412b9c2919fde16eb75d4526e'),
(342, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:08:32.136275', '2025-10-15 08:08:41.460847', '8a9599aefe4fb388932156476928bb9db8ef05d43a47e587475eac97ba7459d5'),
(343, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:08:47.601876', '2025-10-15 08:09:01.024631', 'e3e5fd776208c2e3413457043ee152c4baa5b20622dbed8a0cb818231ffc861f'),
(344, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:09:05.133197', '2025-10-15 08:42:40.447916', 'd7c0125d1b871370df677eee6aa6c73817ddde1fe5bb6e0474688b33ed879dcf'),
(345, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:42:44.863772', '2025-10-15 08:42:54.744843', 'fd2087bd3728662d60dc83358ed60cd0040ac181715b0c4da29f595d2ffdfa35'),
(346, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:42:58.684344', NULL, 'b79b3c9e5740008135799252da2813e4feecbcee1e028a8c1771cb3dafd02a75'),
(347, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-15 08:44:20.407946', NULL, 'aa79ba925ddaab240be008381c5e0905003b02615f23d29f3f642b3c3ee085e2');
INSERT INTO `axes_accesslog` (`id`, `user_agent`, `ip_address`, `username`, `http_accept`, `path_info`, `attempt_time`, `logout_time`, `session_hash`) VALUES
(348, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-18 11:14:49.283754', '2025-10-18 12:12:06.967216', 'cb30d8e4f9d1597da14d55e26bf2fbdf3217bb60243865f66ade8affd53e7ac9'),
(349, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-18 12:12:12.326510', '2025-10-18 12:12:25.683620', '1aab994e2ab2d5b3812a6682764a74a2f3ffb53a34e41dbe8c073fbdb09ed60d'),
(350, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-18 12:12:30.371442', '2025-10-18 12:27:32.476553', '793322c703933f459e8ba9b926d44ff558b769dff249fb07337a4b321646bd52'),
(351, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-18 12:27:38.052710', '2025-10-19 04:26:58.233117', 'c231cd7b16893f4e22a15fae321c62b8ea4f0c134240281d64fdb84a70533688'),
(352, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 04:27:10.443762', '2025-10-19 05:09:58.842298', 'd6daf9aeece998bed7b2f486949f709928e637ce5807c7c4684944d2cf747d55'),
(353, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 05:10:04.570379', '2025-10-19 05:12:22.384924', '73fbaf94651ad4e4b0591f8c2f57e79ced2714ef37dbae155184184fcd593244'),
(354, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 05:12:28.668908', '2025-10-19 05:13:09.148204', '3e0bcbbe018b09145932fe41c5e19311ce736c3de525efc1e27b0193f4aa3368'),
(355, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 05:13:12.584816', '2025-10-19 05:14:30.133428', '158a0c7ac0c97ab2d8893dadb8833f14ad7648f2a130c81a57ea526c65d4b702'),
(356, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 05:14:34.856011', '2025-10-19 05:47:10.001743', '3cc20297218800363a28b7cc91a7310c36bbc3ebfc7ce26e3bfeeb9fc381bf9c'),
(357, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 05:47:13.449760', '2025-10-19 05:59:35.021267', '1b9472c1b0a0a542bac7a8536a1ff756da620fe0738ca0c0b4f07c5cb2790089'),
(358, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 06:12:09.752864', '2025-10-19 06:17:35.451964', '085f9de679f7d12112b44b76af4f3ae3de3746d4f851e8ee54302ef2a7d628eb'),
(359, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 06:17:38.130890', '2025-10-19 06:20:30.444940', '6320e8590d998a72bccbe647b3fc005ad01d4ab47c55db7060247a9d47672042'),
(360, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 06:18:23.070213', NULL, '1ddcd099ba8d771e5b546daebd3c860fab416fd3f0acc8461eed8bd5c3c0d98b'),
(361, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 06:20:22.717535', '2025-10-19 06:20:30.444940', '6320e8590d998a72bccbe647b3fc005ad01d4ab47c55db7060247a9d47672042'),
(362, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 06:20:34.158445', '2025-10-19 07:35:26.054885', '4ef00ddce6c498f277be2a1cc76ade9d07129aa8dd3f732e87cdb9b2ca2aae9e'),
(363, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:35:29.355040', '2025-10-19 07:36:00.906074', '86c6e166500e20949c8b1c758a8cdcc928d871c316c05f09e268a5eafa4e9009'),
(364, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:36:04.560707', '2025-10-19 07:39:48.576544', '54f6b7b33ddc8dfb21c49fa1c6f7419541fad44b2497d2aa6bd4f10827e49c7d'),
(365, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:39:51.918850', '2025-10-19 07:40:10.719182', '2159616012c9feb29e71055c080ec0f982260090cbecca9117db60ec00f14d9a'),
(366, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:40:14.541535', '2025-10-19 07:40:29.938334', '3367e16f6a9c626b76f34f5f14664baff0f867acfda37e930cda046d03de28ae'),
(367, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:40:32.901921', '2025-10-19 07:41:00.347656', 'fd1d77f69ed4b3848195dde00711e0d9539f17ed73b7f35b7a49b3544b48f06c'),
(368, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:41:04.379729', '2025-10-19 07:49:09.893396', '0d3beb80dfa329b365d1f529fef17dc82e94550d99e052efdb17e441a592e222'),
(369, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:49:13.020786', '2025-10-19 07:49:41.721591', '8ab9a19384329f83d2f6eb6d40a593bfe9790cac0bfa77d263976bda44aec25a'),
(370, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:49:46.820640', '2025-10-19 07:51:23.443119', 'd9e83f83e5dd29f94e01addd5e4fe08e2effa5b5c06f0f3e95331575252fe505'),
(371, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:51:29.094401', '2025-10-19 07:51:51.410812', '91c5ecd2d5ec8aea921bda505f59edefcc74260c10a99360df3c208a7b472e2b'),
(372, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:51:56.017657', '2025-10-19 07:52:03.025540', 'b210debdc8a133d5ff2c208045f348944e7a4464b13d5f0f0119681f3c2545c4'),
(373, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-19 07:52:07.326493', NULL, '94d62d631da02e0646d37273d494fb7e0c4b879a51dc6135aeb5f6ac598dd00c'),
(374, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 04:34:20.584903', '2025-10-20 04:35:07.759655', 'db17ff627c6b72cbb68755b8164d7804c6aafb22f67ac0cd25e4bdb3e3876eaa'),
(375, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 04:35:13.395349', NULL, 'e4774efd68c77f9fd1d290c540ea62cc673fc25bf3bbbd0bb181382d3307f78f'),
(376, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 09:26:45.026569', '2025-10-20 09:34:59.675770', 'cf0bfca228c0519666942172ebc7c59bb388a715e5e775ff26d0e65b2e264eb5'),
(377, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 10:32:43.058036', '2025-10-20 10:33:47.210847', 'ddc8598f87019701499ae742f40ca6661751f87d9526682595147a7cdd78b68c'),
(378, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 12:28:38.648984', '2025-10-20 12:30:02.654304', '38ea0e7555e689081ad908a1fe616e9681d2900c1883692b9f8b85dec2206768'),
(379, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-20 12:30:07.479004', '2025-10-21 05:24:08.072540', '118184c100c5976cc39f579fcdc9814bdbaaf8f045d267268f78ddbe5c47157f'),
(380, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:24:13.691621', '2025-10-21 05:24:50.299524', 'b20edf393fde3314d7b58490047dd93906d44fe5fe9d68b81e750d77b48c6396'),
(381, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:24:55.655042', '2025-10-21 05:25:09.784952', '8374b27049aea581b0f63dc04f08702ff157550ffae86c6dc01e6be1e9b9654f'),
(382, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:25:15.769394', '2025-10-21 05:28:45.607932', '58261089f08f095e34fe3d6028cb4e760c99697a8ec77c40d70710ce184ea75a'),
(383, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:28:50.832294', '2025-10-21 05:29:09.719809', '622e68c8ca1be63fc75cf7b20b27d08abda27ec84046e880528dd591426e1f2c'),
(384, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:29:14.516103', '2025-10-21 05:30:38.998059', '777f160448be961209aa96574541e8acfdeb0ba8a5eb3c640e3075bf8147cb34'),
(385, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:30:44.955625', '2025-10-21 05:31:10.457291', '3e9ceaafed49931989cc24e28dd22b4d859f375bb3e72ab62d23c07259020442'),
(386, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:31:15.878269', '2025-10-21 05:38:12.752644', '4c8e0a82ce11d5659dbd7885258af83a1750792436a624b209ec1136d42aaa88'),
(387, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:38:18.602223', '2025-10-21 05:38:31.258042', '55ea0500a30ecde39853f7117d99b89a1b646113bc638d4e1bb6a68de4ad58af'),
(388, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:38:36.445259', '2025-10-21 05:40:18.750863', '414fa895eafa9fa1fbe236eb29dc63a5e42a5527d41ef684e4c530b9a4bacafe'),
(389, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:40:26.132968', '2025-10-21 05:41:50.766130', '54b4a59b36c8b4a2a75cd8779981707c4c1d0e1905dcd7f201188f623115eb90'),
(390, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:41:55.017351', '2025-10-21 05:42:26.115908', '2c770c634bdbbe679361f12382ff2a31836978e67b1f1b75fd47af6933db62c4'),
(391, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:42:31.194670', '2025-10-21 05:42:45.034307', '74c22773fb3b0db2f2508900334a8baf7153b08353a9f4064146b4ffaba317c8'),
(392, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:42:48.473316', '2025-10-21 05:43:22.045549', '8e3d6a1c5894840e4d2c0a5d3c7df84b70b53fa0f5c104181183b09d37e3de38'),
(393, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:43:28.280141', '2025-10-21 05:43:47.293173', 'bc4d199a367436234d82f87ab5a51cc7b670938b4b9f4348887482d4e01bbd17'),
(394, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:43:50.843680', '2025-10-21 05:45:02.607804', 'b6d202723a2e441419ec20e708a55502e8a9830cce68cbce3c3bc84ba17f4e81'),
(395, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:45:07.122952', '2025-10-21 05:45:30.215897', '22e66eaac2a1d098db897c7d028eee7e09d5935ac37bd00846be6d49932efa3c'),
(396, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:45:36.685193', '2025-10-21 05:55:14.032291', '7f757ab99dc627d57b086c9cda6e941ab23085fff560ad7eea0ce1b746c1a593'),
(397, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:55:23.716597', '2025-10-21 05:55:36.389798', '020319e533d1ed4017ad20b6c535119d658f12ba6a47a685533708b3b0568a6e'),
(398, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:55:40.635931', '2025-10-21 05:56:38.405774', 'e3b974872953adcd49d9a26d771d0589c5f93f10fcbc3a12b0d9172cb188d0dd'),
(399, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 05:56:44.887315', '2025-10-21 06:08:32.217055', '844e93ab76323cbff4199d1529dcf9671df31dbdb6993967c0a5c721b98085fe'),
(400, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 06:08:34.982946', '2025-10-21 06:14:58.181807', 'ed611b9540ba1f99eb1ab1ee9189d99b3888fb8dffb1913d5f7674adc03d5ac8'),
(401, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2380000002', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 06:15:08.265789', '2025-10-21 06:49:04.643511', '400fdca15f9ce142f0b4deb7a35ccd60a8c1dd84762a9149133529f1931c003f'),
(402, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-21 06:49:36.916031', '2025-10-22 06:18:46.962630', '57d929463f85de73c60779a9bfdf6bf954583d2aea9cf833f03ba866ed308bfc'),
(403, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 06:18:49.737242', '2025-10-22 06:19:32.308637', '5931a2c3448373aad60662fdf1b1c169acf4287e269499fafb209ad2bbe76532'),
(404, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 06:19:37.168155', '2025-10-22 06:29:06.135514', '99627cc9a3023ab0c274d77156c830218b2b2112cff04c98e8bb214e74827ed7'),
(405, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 06:38:03.373806', '2025-10-22 06:52:39.380162', '9c83debc64d0ec680da23217374846ba8bd850d76c149b569d3131db2c44bd5c'),
(406, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 06:52:48.313921', '2025-10-22 06:54:00.254642', '96d5115c0124da171ce30795d8b9cc0e7129c3c3f9243b3b3b515714638ee10b'),
(407, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 06:54:09.941799', '2025-10-22 08:02:13.607467', 'bf11c27c60f33a500ea9293fde4893fe3fad2200e5bb0af2b29e19bf00262fc9'),
(408, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 08:02:18.476063', '2025-10-22 08:02:25.304396', 'a4ef0f3ae70419427a4faa021cc07b196d9f57d880dedadf857685e61ce52b07'),
(409, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 08:02:33.612837', '2025-10-22 08:04:55.872400', '8cd5d13911dcb5f49488b10b0865487803e2000a945b9a74f3bac5093ef0df00'),
(410, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-22 08:04:58.946402', '2025-10-23 07:34:33.297747', '6157ff026198849d892129b3cc502da8a5ece1d410b270253ea71255bba6f2ad'),
(411, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-23 07:34:38.077509', NULL, '1db004eb4016c65b92a17820575d6c714354b9c2dd79e65cc152592b94ce767a'),
(412, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 04:38:00.907962', '2025-10-25 04:41:36.933660', '483878ca10a82a188bfddd9af6437e6284aaad4f3cfebab7ceb7997dc8028385'),
(413, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 04:41:41.138124', '2025-10-25 05:05:47.418367', '46b2287c0a7df51f0893e19eb2d581038b3de67720ab6faef35e2be017551c82'),
(414, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 05:02:48.780097', '2025-10-25 05:05:47.418367', '46b2287c0a7df51f0893e19eb2d581038b3de67720ab6faef35e2be017551c82'),
(415, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 05:05:49.940138', NULL, '1cde59d73fd445cbd364fe5ef9854fe7571b0389f03a759d334fd2d682253d46'),
(416, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 05:13:39.195298', '2025-10-25 05:52:19.444797', '3c8c00735dcfea6c11337de0d0163c11de786670c535bb3f3f60e7dbeab29e98'),
(417, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 05:52:22.985833', '2025-10-25 06:54:05.600507', '7e104aefea801219b52bd3998116a3452be23a7a1494569c3485b580828b72ea'),
(418, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 05:58:24.823220', '2025-10-25 06:54:05.600507', '7e104aefea801219b52bd3998116a3452be23a7a1494569c3485b580828b72ea'),
(419, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 06:53:43.291442', '2025-10-25 06:54:05.600507', '7e104aefea801219b52bd3998116a3452be23a7a1494569c3485b580828b72ea'),
(420, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 06:54:09.113306', '2025-10-25 08:07:22.243711', '81021c8515bf07d0b77d63ba8774457363abe79c02a76ffc87c07efae4dbeace'),
(421, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 08:07:27.611239', '2025-10-25 08:08:46.383052', '3effb80036be6548ba45a22e461a8c7ae6f48d77b36e325f8c06e0c9bda10044'),
(422, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 08:08:52.478497', NULL, '759c75413652fe1e72080204bdae1f4e56aaeced2f0c6b5468383d3d9cdffa73'),
(423, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 08:16:30.080975', '2025-10-25 08:39:13.422125', 'd7c35fed431df209b5d7605761af4179d73b8607a64baaefbc97efa72926b143'),
(424, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 08:39:19.445237', NULL, 'd91cb6750888069a080ea7a70f2b0ffc84affb2c99ce7dd4b245cd7194781b95'),
(425, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 09:20:04.369325', NULL, 'd91cb6750888069a080ea7a70f2b0ffc84affb2c99ce7dd4b245cd7194781b95'),
(426, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 09:36:31.440867', '2025-10-25 09:41:03.293359', 'f5c0624fd4d6780f02efbda2c3d122f110685be92bc70a5ecae25a5cd03e67c2'),
(427, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 09:41:00.847061', '2025-10-25 09:41:03.293359', 'f5c0624fd4d6780f02efbda2c3d122f110685be92bc70a5ecae25a5cd03e67c2'),
(428, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 09:41:07.494742', NULL, '3e541e5332221cb0f6b03843cbd63d5e1531c328b3e97ca502c8d6799b5bc3cf'),
(429, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 10:14:08.141698', NULL, '7eb3acce67c01b6c80d28726ef8a3741796a03e41b43452b70f6b3fd96109271'),
(430, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 10:17:11.157896', NULL, 'ba2ea712a6f1786702e19c91f3a7ae09e73c1fc8b5c11462e2825b872851c9ac'),
(431, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 10:34:53.382331', NULL, '95903299704d0f1265d8360d30e3fb9dd4344a5f9bad972bddef7f25ccb408b3'),
(432, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 11:00:15.364007', '2025-10-25 11:00:24.676696', 'e3133f924a88215b84cbd08267eaab4e9b4d12ff3912a4ec3f4ddbfd19e91be0'),
(433, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 11:00:45.808891', NULL, '7dad43c45908b4c14ff6933ec99d9ee442992658949dd994ce3cb5ef39fbf26d'),
(434, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 11:01:12.933172', '2025-10-25 11:01:18.120322', '67e243caa1806e29ee399445fa15fce2cc37d86fe7b26d269c0b1dbb65b18c82'),
(435, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-25 11:03:14.090596', '2025-10-26 06:04:34.452443', 'cae8802ca2b8e6d513625e8e3ffaabd72263085c9853d6baa383bdf3740e2d93'),
(436, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-26 06:04:57.274791', '2025-10-26 06:18:42.821660', '5d03da1971a76794829f3ef544600d15a6d93b8563f141153c5600b2b2105dcd'),
(437, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-26 06:18:45.059080', '2025-10-26 06:18:53.835684', '6bba39d3467e7fb92f0668d41b9de33d314156751667bcd0c37ac1e0a99c5498'),
(438, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-26 06:18:58.404926', '2025-10-26 07:26:08.324617', '36f7eff86b5c281b5695bbae90e33e17123a4afa13cd3f6405ec1501e291a444'),
(439, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-26 07:26:54.082059', '2025-10-26 07:26:58.702181', '299cda96d28177d6dd3b4aa84ecc5bc8010e4f6cdeb47baad18ba886017b26cc'),
(440, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-26 07:27:02.969516', '2025-10-28 05:03:37.751536', 'f95489a6bf0c7f385521bef85a5cdf83dd6911878b3f2af647cb5c42f57db9d2'),
(441, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 05:04:09.442245', '2025-10-28 05:34:45.403157', 'ec7eb4bc24ce04813d92bed321d5559f8051c44653d58421fac19408a194c480'),
(442, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 05:34:51.433981', '2025-10-28 06:25:25.518842', '99710e3ee2210ad1b778983c7805311dae9c1948d3b24902d3454174558e53cf'),
(443, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 05:56:12.895312', '2025-10-28 06:25:25.518842', '99710e3ee2210ad1b778983c7805311dae9c1948d3b24902d3454174558e53cf'),
(444, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 05:59:25.861492', '2025-10-28 06:25:25.518842', '99710e3ee2210ad1b778983c7805311dae9c1948d3b24902d3454174558e53cf'),
(445, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 06:22:29.156364', '2025-10-28 06:25:25.518842', '99710e3ee2210ad1b778983c7805311dae9c1948d3b24902d3454174558e53cf'),
(446, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 06:25:30.752433', '2025-10-28 06:33:51.195812', 'a6f2809c1a1820afa222702010935353cb3c702ca0e6d408c1056d44092636a0'),
(447, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 06:35:23.020165', '2025-10-28 07:23:04.319550', '16631017bb4e0875d261660da23c29c0028902b4cb13f781e2794296fc3b7990'),
(448, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 07:24:32.692830', '2025-10-28 07:46:42.555654', 'c04ccbf675c05c4eaf79fef99e9d160d51c0fa870157e69507f98119ea76a50c'),
(449, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 07:38:47.955311', '2025-10-28 07:46:42.555654', 'c04ccbf675c05c4eaf79fef99e9d160d51c0fa870157e69507f98119ea76a50c'),
(450, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 07:46:46.525184', '2025-10-28 09:02:39.963389', '4aa885ad906bfe47fd7f6019a290b3afbefb8c0da4fa571f673b4a56b6954590'),
(451, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000001', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 09:02:42.682302', '2025-10-28 09:02:45.615657', '2d492f69f7682989a8e14ad43b697d421ba076792198ade1d9ce42de3f14e6ac'),
(452, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2280000000', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 09:02:49.114540', '2025-10-28 09:03:12.045336', '1a013f60dee0fbe8f0dc8775ec4ba21fb16e46aaf55d51af1aa58825d1557f23'),
(453, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-28 09:03:16.827775', NULL, '2821d3627709f87ea10d9f435e85b52f9775f19c82268267688876b9b0b25511'),
(454, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '1000111101', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-29 05:29:39.034257', '2025-10-29 05:29:58.562228', 'f0abfd649b5b578a9724da5cd1bb3e914359a9af8a173b8854921b713b0ea0fa'),
(455, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '2391797664', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-29 05:30:02.173410', '2025-10-29 05:31:20.736371', '281d72e5d28957993c2a7b9cbd7d010ae4f3004e00bc4b6238c23b837c633e7a'),
(456, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '127.0.0.1', '1000111101', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7', '/users/login/', '2025-10-29 05:31:44.455977', NULL, '3c48b13bdbf480d0990d2d6fb49d311e7e8ff50333e003692f9215f715f5553b');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2025-09-23 07:22:11.246588', '1', 'اصفهان مقدم', 1, '[{\"added\": {}}]', 7, 1),
(2, '2025-09-23 07:22:34.995726', '1', 'هوش مصنوعی - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(3, '2025-09-23 07:23:13.628066', '1', 'مدیر کل', 1, '[{\"added\": {}}]', 8, 1),
(4, '2025-09-23 07:23:17.767771', '2', 'مدیر بخش', 1, '[{\"added\": {}}]', 8, 1),
(5, '2025-09-23 07:23:20.808774', '3', 'سرپرست', 1, '[{\"added\": {}}]', 8, 1),
(6, '2025-09-23 07:23:23.709881', '4', 'پرسنل', 1, '[{\"added\": {}}]', 8, 1),
(7, '2025-09-23 07:23:40.028045', '1', 'سطح دسترسی super_admin', 1, '[{\"added\": {}}]', 9, 1),
(8, '2025-09-23 07:23:49.403064', '2', 'سطح دسترسی department_manager', 1, '[{\"added\": {}}]', 9, 1),
(9, '2025-09-23 07:23:56.077935', '3', 'سطح دسترسی supervisor', 1, '[{\"added\": {}}]', 9, 1),
(10, '2025-09-23 07:23:59.085834', '4', 'سطح دسترسی employee', 1, '[{\"added\": {}}]', 9, 1),
(11, '2025-09-24 03:43:22.273602', '1', 'هوش مصنوعی2 - اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0627\\u0645 \\u0628\\u062e\\u0634\"]}}]', 10, 1),
(12, '2025-09-24 03:43:38.311749', '1', 'هوش مصنوعی - اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0627\\u0645 \\u0628\\u062e\\u0634\"]}}]', 10, 1),
(13, '2025-09-24 04:33:34.157398', '2', 'hosin ghaedi - 2392079625', 1, '[{\"added\": {}}]', 6, 1),
(14, '2025-09-24 05:43:50.345923', '1', 'younes2 ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"First name\", \"\\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\", \"\\u0628\\u062e\\u0634\", \"\\u0646\\u0642\\u0634\"]}}]', 6, 1),
(15, '2025-09-24 05:44:00.900508', '2', 'hosin ghaedi2 - 2392079625', 2, '[{\"changed\": {\"fields\": [\"Last name\"]}}]', 6, 1),
(16, '2025-09-24 05:44:08.688103', '1', 'younes ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"First name\"]}}]', 6, 1),
(17, '2025-09-24 05:56:12.357745', '5', 'بازرس', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"\\u0633\\u0637\\u062d \\u062f\\u0633\\u062a\\u0631\\u0633\\u06cc\", \"object\": \"\\u0633\\u0637\\u062d \\u062f\\u0633\\u062a\\u0631\\u0633\\u06cc \\u0628\\u0627\\u0632\\u0631\\u0633\"}}]', 8, 1),
(18, '2025-09-24 05:56:32.587110', '4', 'employee', 2, '[{\"changed\": {\"name\": \"\\u0633\\u0637\\u062d \\u062f\\u0633\\u062a\\u0631\\u0633\\u06cc\", \"object\": \"\\u0633\\u0637\\u062d \\u062f\\u0633\\u062a\\u0631\\u0633\\u06cc employee\", \"fields\": [\"\\u0627\\u0631\\u0632\\u06cc\\u0627\\u0628\\u06cc \\u067e\\u0631\\u0633\\u0646\\u0644\"]}}]', 8, 1),
(19, '2025-09-24 06:06:11.238714', '1', 'younes ghaedi - 2391797664', 2, '[]', 6, 1),
(20, '2025-09-24 06:54:21.492194', '6', 'جدید 2', 1, '[{\"added\": {}}]', 8, 1),
(21, '2025-09-24 06:54:34.145020', '1', 'younes ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"Email address\"]}}]', 6, 1),
(22, '2025-09-24 12:06:52.905926', '2', 'منابع انسانی - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(23, '2025-09-24 12:33:26.988078', '7', 'ارسال مطالب', 1, '[{\"added\": {}}]', 8, 1),
(24, '2025-09-24 12:33:35.528648', '6', 'سطح دسترسی ارسال مطالب', 1, '[{\"added\": {}}]', 9, 1),
(25, '2025-09-24 12:34:36.569040', '8', 'تست', 1, '[{\"added\": {}}]', 8, 1),
(26, '2025-09-25 02:26:29.339848', '8', 'تست', 3, '', 8, 1),
(27, '2025-09-25 02:26:29.350852', '7', 'ارسال مطالب', 3, '', 8, 1),
(28, '2025-09-25 02:26:29.353872', '6', 'جدید 2', 3, '', 8, 1),
(29, '2025-09-25 02:26:29.357027', '5', 'بازرس', 3, '', 8, 1),
(30, '2025-09-25 02:52:23.403423', '1', 'younes ghaedi - 2391797664', 2, '[]', 6, 1),
(31, '2025-09-25 02:52:29.208689', '1', 'اصفهان مقدم', 2, '[]', 7, 1),
(32, '2025-09-25 03:27:29.814062', '2', 'hosin ghaedi2 - 2392079625', 3, '', 6, 1),
(33, '2025-09-25 03:28:22.178445', '3', 'hosin ghaedi - 2392079625', 1, '[{\"added\": {}}]', 6, 1),
(34, '2025-09-25 15:15:40.590322', '3', 'hosin ghaedi - 2392079625', 2, '[{\"changed\": {\"fields\": [\"\\u0628\\u062e\\u0634\"]}}]', 6, 1),
(35, '2025-09-25 15:15:49.368499', '1', 'اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u06a9\\u0627\\u0646\"]}}]', 7, 1),
(36, '2025-09-25 15:15:59.481147', '9', 'jj', 1, '[{\"added\": {}}]', 8, 1),
(37, '2025-09-26 05:13:53.129209', '3', 'hosin ghaedi - 2392079625', 2, '[]', 6, 1),
(38, '2025-09-27 05:44:05.831052', '1', 'younes ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\"]}}]', 6, 1),
(39, '2025-09-27 05:45:11.725388', '3', 'hosin ghaedi - 2392079625', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\"]}}]', 6, 1),
(40, '2025-09-28 02:07:49.419183', '3', 'مالی - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(41, '2025-09-28 02:15:21.082948', '8', 'MALI MODIR - 2280225654', 1, '[{\"added\": {}}]', 6, 1),
(42, '2025-09-28 02:15:40.222096', '8', 'MALI MODIR - 2280000000', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u062f \\u0645\\u0644\\u06cc\"]}}]', 6, 1),
(43, '2025-09-28 02:15:55.738268', '3', 'مالی - اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u062f\\u06cc\\u0631 \\u0628\\u062e\\u0634\"]}}]', 10, 1),
(44, '2025-09-28 02:16:56.207161', '9', 'MALI EMP - 2280000001', 1, '[{\"added\": {}}]', 6, 1),
(45, '2025-09-28 02:18:33.879953', '10', 'HS MODIR - 2290000000', 1, '[{\"added\": {}}]', 6, 1),
(46, '2025-09-28 02:19:18.233294', '11', 'HS EMP - 2290000001', 1, '[{\"added\": {}}]', 6, 1),
(47, '2025-09-28 02:19:45.712265', '4', 'MODIRIAT - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(48, '2025-09-28 02:20:17.366326', '1', 'younes ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"\\u0628\\u062e\\u0634\"]}}]', 6, 1),
(49, '2025-09-28 02:21:13.892598', '12', 'AI EMP - 2390000001', 1, '[{\"added\": {}}]', 6, 1),
(50, '2025-09-28 04:48:07.030270', '13', 'test1 rfd - 2210000000', 1, '[{\"added\": {}}]', 6, 1),
(51, '2025-10-01 23:48:21.844609', '14', 'younes2 ghaedi2 - 2391797665', 1, '[{\"added\": {}}]', 6, 1),
(52, '2025-10-02 00:35:50.146423', '15', 'MALI sarparast - 2380000002', 1, '[{\"added\": {}}]', 6, 1),
(53, '2025-10-28 07:18:02.301171', '23', 'مدیر هلدینگ - 1000001111', 1, '[{\"added\": {}}]', 6, 1),
(54, '2025-10-28 07:19:51.301410', '23', 'مدیر هلدینگ - 1000001111', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\"]}}]', 6, 1),
(55, '2025-10-28 10:24:07.680057', '1', 'اصفهان مقدم', 2, '[]', 7, 1),
(56, '2025-10-28 10:24:11.797335', '1', 'اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0647\\u0644\\u062f\\u06cc\\u0646\\u06af\"]}}]', 7, 1),
(57, '2025-10-28 10:25:18.382428', '3', 'هلدینگ تست 2', 1, '[{\"added\": {}}]', 19, 1),
(58, '2025-10-28 10:26:56.486669', '24', 'مدیر هلدینگ تست 2 - 1000002111', 1, '[{\"added\": {}}]', 6, 1),
(59, '2025-10-28 10:27:52.680971', '3', 'هلدینگ تست 2', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u062f\\u06cc\\u0631 \\u0647\\u0644\\u062f\\u06cc\\u0646\\u06af\"]}}]', 19, 1),
(60, '2025-10-28 10:30:54.249837', '23', 'مدیر هلدینگ - 1000001000', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u062f \\u0645\\u0644\\u06cc\"]}}]', 6, 1),
(61, '2025-10-28 10:31:03.223542', '24', 'مدیر هلدینگ تست 2 - 1000002000', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u062f \\u0645\\u0644\\u06cc\"]}}]', 6, 1),
(62, '2025-10-29 04:48:16.983873', '25', 'مدیر کارخانه 1 هلدینگ اصفهان - 1000001100', 1, '[{\"added\": {}}]', 6, 1),
(63, '2025-10-29 04:48:43.917477', '2', 'کارخانه تست1', 1, '[{\"added\": {}}]', 7, 1),
(64, '2025-10-29 04:49:12.084520', '3', 'کارخانه تست 2 هلدینگ 1', 1, '[{\"added\": {}}]', 7, 1),
(65, '2025-10-29 04:49:29.509466', '4', 'هلدینگ تست 1 کارخانه تست 2', 1, '[{\"added\": {}}]', 7, 1),
(66, '2025-10-29 04:49:45.138274', '5', 'کارخانه تست 2 هلدینگ تست 2', 1, '[{\"added\": {}}]', 7, 1),
(67, '2025-10-29 04:50:16.125723', '2', 'کارخانه تست1 هلدینگ اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0627\\u0645 \\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\"]}}]', 7, 1),
(68, '2025-10-29 04:50:33.925463', '3', 'کارخانه تست 2 هلدینگ اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0627\\u0645 \\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\"]}}]', 7, 1),
(69, '2025-10-29 04:50:57.341530', '2', 'کارخانه تست 1 هلدینگ اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0627\\u0645 \\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\"]}}]', 7, 1),
(70, '2025-10-29 04:52:04.942216', '5', 'بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - کارخانه تست 1 هلدینگ اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(71, '2025-10-29 04:52:31.436474', '6', 'بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم - کارخانه تست 1 هلدینگ اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(72, '2025-10-29 04:52:41.022956', '7', 'بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم - کارخانه تست 2 هلدینگ اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(73, '2025-10-29 04:52:52.653119', '8', 'بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم - کارخانه تست 2 هلدینگ اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(74, '2025-10-29 04:53:19.063744', '9', 'بخش 1 کارخانه تست 1 هلدینگ تست 2 - هلدینگ تست 1 کارخانه تست 2', 1, '[{\"added\": {}}]', 10, 1),
(75, '2025-10-29 04:53:34.878420', '10', 'بخش 2 کارخانه تست 1 هلدینگ تست 2 - هلدینگ تست 1 کارخانه تست 2', 1, '[{\"added\": {}}]', 10, 1),
(76, '2025-10-29 04:53:45.583345', '11', 'بخش 1 کارخانه تست 2 هلدینگ تست 2 - کارخانه تست 2 هلدینگ تست 2', 1, '[{\"added\": {}}]', 10, 1),
(77, '2025-10-29 04:53:51.960643', '12', 'بخش 2 کارخانه تست 2 هلدینگ تست 2 - کارخانه تست 2 هلدینگ تست 2', 1, '[{\"added\": {}}]', 10, 1),
(78, '2025-10-29 04:55:19.728369', '1', 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(79, '2025-10-29 04:55:44.430446', '2', 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(80, '2025-10-29 04:55:59.703280', '3', 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(81, '2025-10-29 04:56:16.079184', '4', 'زیر بخش 2 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(82, '2025-10-29 04:56:31.094331', '5', 'زیر بخش 1 بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم (کارخانه تست 2 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(83, '2025-10-29 04:56:43.334356', '6', 'زیر بخش 2 بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم (کارخانه تست 2 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(84, '2025-10-29 04:56:58.006356', '7', 'زیر بخش 1 بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم (کارخانه تست 2 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(85, '2025-10-29 04:57:08.886368', '8', 'زیر بخش 2 بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم (کارخانه تست 2 هلدینگ اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(86, '2025-10-29 04:57:28.221868', '9', 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ تست 2 - بخش 1 کارخانه تست 1 هلدینگ تست 2 (هلدینگ تست 1 کارخانه تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(87, '2025-10-29 04:57:37.623538', '10', 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ تست 2 - بخش 1 کارخانه تست 1 هلدینگ تست 2 (هلدینگ تست 1 کارخانه تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(88, '2025-10-29 04:57:45.831399', '11', 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ تست 2 - بخش 2 کارخانه تست 1 هلدینگ تست 2 (هلدینگ تست 1 کارخانه تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(89, '2025-10-29 04:57:58.190337', '12', 'زیر بخش 2 بخش 2 کارخانه تست 1 هلدینگ تست 2 - بخش 2 کارخانه تست 1 هلدینگ تست 2 (هلدینگ تست 1 کارخانه تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(90, '2025-10-29 04:58:07.110339', '13', 'زیر بخش 1 بخش 1 کارخانه تست 2 هلدینگ تست 2 - بخش 1 کارخانه تست 2 هلدینگ تست 2 (کارخانه تست 2 هلدینگ تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(91, '2025-10-29 04:58:13.281832', '14', 'زیر بخش 2 بخش 1 کارخانه تست 2 هلدینگ تست 2 - بخش 1 کارخانه تست 2 هلدینگ تست 2 (کارخانه تست 2 هلدینگ تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(92, '2025-10-29 04:58:19.838355', '15', 'زیر بخش 1 بخش 2 کارخانه تست 2 هلدینگ تست 2 - بخش 2 کارخانه تست 2 هلدینگ تست 2 (کارخانه تست 2 هلدینگ تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(93, '2025-10-29 04:58:34.550306', '16', 'زیر بخش 2 بخش 2 کارخانه تست 2 هلدینگ تست 2 - بخش 2 کارخانه تست 2 هلدینگ تست 2 (کارخانه تست 2 هلدینگ تست 2)', 1, '[{\"added\": {}}]', 20, 1),
(94, '2025-10-29 05:08:59.212489', '18', 'holding manager - 5111', 3, '', 6, 1),
(95, '2025-10-29 05:08:59.212489', '13', 'test1 rfd - 2210000000', 3, '', 6, 1),
(96, '2025-10-29 05:08:59.212489', '16', 'ss ss55555554444 - 111', 3, '', 6, 1),
(97, '2025-10-29 05:08:59.212489', '24', 'مدیر هلدینگ تست 2 - 1000002000', 3, '', 6, 1),
(98, '2025-10-29 05:08:59.212489', '23', 'مدیر هلدینگ - 1000001000', 3, '', 6, 1),
(99, '2025-10-29 05:08:59.212489', '25', 'مدیر کارخانه 1 هلدینگ اصفهان - 1000001100', 3, '', 6, 1),
(100, '2025-10-29 05:14:17.356837', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111110', 1, '[{\"added\": {}}]', 6, 1),
(101, '2025-10-29 05:14:42.708060', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111110', 2, '[{\"changed\": {\"fields\": [\"\\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 6, 1),
(102, '2025-10-29 05:16:54.181934', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u062f \\u0645\\u0644\\u06cc\"]}}]', 6, 1),
(103, '2025-10-29 05:18:43.834131', '27', 'سرپرست زیربخش 2 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111200', 1, '[{\"added\": {}}]', 6, 1),
(104, '2025-10-29 05:20:28.295404', '28', 'مدیر بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111000', 1, '[{\"added\": {}}]', 6, 1),
(105, '2025-10-29 05:20:56.299422', '27', 'سرپرست زیربخش 2 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111200', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 6, 1),
(106, '2025-10-29 05:22:50.966033', '29', 'مدیر کارخانه 1 هلدینگ اصفهان مقدم تست - 1000110000', 1, '[{\"added\": {}}]', 6, 1),
(107, '2025-10-29 05:24:14.973277', '30', 'مدیر هلدینگ اصفهان مقدم تست - 1000100000', 1, '[{\"added\": {}}]', 6, 1),
(108, '2025-10-29 05:27:11.471681', '31', ';کارمند زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111101', 1, '[{\"added\": {}}]', 6, 1),
(109, '2025-10-29 05:29:12.215842', '32', ';کارمند زیربخش 2 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111201', 1, '[{\"added\": {}}]', 6, 1),
(110, '2025-11-01 05:38:24.891266', '1', 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 1),
(111, '2025-11-01 06:46:51.630303', '2', 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 1),
(112, '2025-11-01 06:53:38.678624', '5', 'بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - کارخانه تست 1 هلدینگ اصفهان مقدم', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u062f\\u06cc\\u0631 \\u0628\\u062e\\u0634\"]}}]', 10, 1),
(113, '2025-11-01 07:07:43.738564', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(114, '2025-11-01 07:09:32.061199', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(115, '2025-11-01 07:28:35.704835', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(116, '2025-11-01 07:29:32.310355', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(117, '2025-11-01 07:29:50.062825', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(118, '2025-11-01 07:30:10.544003', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(119, '2025-11-01 08:10:09.834053', '1', 'younes ghaedi - 2391797664', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 6, 1),
(120, '2025-11-01 08:13:07.103109', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(121, '2025-11-01 08:13:32.157440', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(122, '2025-11-01 09:15:24.341920', '33', 'کارمند تست نقش 1 - 2222222222', 1, '[{\"added\": {}}]', 6, 1),
(123, '2025-11-01 09:15:56.497839', '13', 'بخش تست تولید - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(124, '2025-11-01 09:16:13.834198', '14', 'بخش کمیته ها ، تست - اصفهان مقدم', 1, '[{\"added\": {}}]', 10, 1),
(125, '2025-11-01 09:16:27.480378', '33', 'کارمند تست نقش 1 - 2222222222', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(126, '2025-11-01 09:17:58.794600', '17', 'تولید پاکت سازی تست - بخش تست تولید (اصفهان مقدم)', 1, '[{\"added\": {}}]', 20, 1),
(127, '2025-11-01 09:25:55.366303', '33', 'کارمند تست نقش 1 - 2222222222', 2, '[{\"changed\": {\"fields\": [\"\\u0628\\u062e\\u0634\", \"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(128, '2025-11-01 12:47:05.431235', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(129, '2025-11-03 12:33:35.819356', '2', 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 1),
(130, '2025-11-03 12:40:17.210291', '5', 'کارخانه تست 2 هلدینگ تست 2', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u062f\\u06cc\\u0631 \\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647\"]}}]', 7, 1),
(131, '2025-11-05 06:01:34.099468', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(132, '2025-11-05 09:42:24.166596', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\\u200c\\u0647\\u0627\\u06cc \\u062a\\u062e\\u0635\\u06cc\\u0635\\u200c\\u06cc\\u0627\\u0641\\u062a\\u0647\"]}}]', 6, 1),
(133, '2025-11-09 10:12:25.492045', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\"]}}]', 6, 1),
(134, '2025-11-17 05:33:01.450749', '2', 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 26),
(135, '2025-11-23 12:15:47.094980', '14', 'زیر بخش 2 بخش 1 کارخانه تست 2 هلدینگ تست 2 - بخش 1 کارخانه تست 2 هلدینگ تست 2 (کارخانه تست 2 هلدینگ تست 2)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 26),
(136, '2025-11-25 05:03:01.202287', '3', 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 26),
(137, '2025-11-25 05:08:02.884477', '3', 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 26),
(138, '2025-12-01 09:22:51.739983', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634 \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647 \\u063a\\u0630\\u0627\", \"\\u0647\\u0644\\u062f\\u06cc\\u0646\\u06af \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647\"]}}]', 6, 26),
(139, '2025-12-01 10:11:44.642588', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634 \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647 \\u063a\\u0630\\u0627\", \"\\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647 \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647\", \"\\u0647\\u0644\\u062f\\u06cc\\u0646\\u06af \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647\"]}}]', 6, 26),
(140, '2025-12-01 10:13:28.564306', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634 \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647 \\u063a\\u0630\\u0627\", \"\\u06a9\\u0627\\u0631\\u062e\\u0627\\u0646\\u0647 \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647\", \"\\u0647\\u0644\\u062f\\u06cc\\u0646\\u06af \\u062a\\u062d\\u0648\\u06cc\\u0644\\u200c\\u06af\\u06cc\\u0631\\u0646\\u062f\\u0647\"]}}]', 6, 26),
(141, '2025-12-13 10:05:50.284861', '1', 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم - بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم (کارخانه تست 1 هلدینگ اصفهان مقدم)', 2, '[{\"changed\": {\"fields\": [\"\\u0633\\u0631\\u067e\\u0631\\u0633\\u062a \\u0632\\u06cc\\u0631\\u0628\\u062e\\u0634\"]}}]', 20, 26),
(142, '2025-12-15 07:23:56.987244', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u0645\\u062c\\u0648\\u0632 \\u0631\\u0632\\u0631\\u0648 \\u0646\\u0627\\u0645\\u062d\\u062f\\u0648\\u062f\"]}}]', 6, 26),
(143, '2025-12-24 09:49:33.553819', '26', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم تست - 1000111100', 2, '[{\"changed\": {\"fields\": [\"\\u06a9\\u062f \\u067e\\u0631\\u0633\\u0646\\u0644\\u06cc\"]}}]', 6, 26),
(144, '2025-12-27 07:12:21.536744', '37', 'آروین کورنگ بهشتی - 1272715434', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 6, 26),
(145, '2025-12-27 07:13:01.935707', '37', 'آروین کورنگ بهشتی - 1272715434', 2, '[{\"changed\": {\"fields\": [\"\\u0646\\u0642\\u0634\\u200c\\u0647\\u0627\", \"\\u0627\\u0648\\u0644\\u06cc\\u0646 \\u0648\\u0631\\u0648\\u062f\"]}}]', 6, 26);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(14, 'axes', 'accessattempt'),
(16, 'axes', 'accessfailurelog'),
(15, 'axes', 'accesslog'),
(4, 'contenttypes', 'contenttype'),
(11, 'evaluations', 'employeeevaluation'),
(12, 'evaluations', 'evaluationcriteria'),
(13, 'evaluations', 'evaluationscore'),
(5, 'sessions', 'session'),
(42, 'users', 'bankaccount'),
(43, 'users', 'bankaccounttype'),
(30, 'users', 'banks'),
(44, 'users', 'baseinsurance'),
(41, 'users', 'contactinfo'),
(31, 'users', 'country'),
(10, 'users', 'department'),
(32, 'users', 'dependencystatus'),
(39, 'users', 'dependent'),
(6, 'users', 'employee'),
(40, 'users', 'employee_bimeh'),
(33, 'users', 'employmenttype'),
(18, 'users', 'evaluation'),
(7, 'users', 'factory'),
(21, 'users', 'fooditem'),
(24, 'users', 'foodreservation'),
(34, 'users', 'gender'),
(19, 'users', 'holding'),
(35, 'users', 'insurancetype'),
(36, 'users', 'jobgroup'),
(37, 'users', 'maritalstatus'),
(23, 'users', 'menuitem'),
(28, 'users', 'notification'),
(29, 'users', 'notificationread'),
(27, 'users', 'orgunit'),
(17, 'users', 'participation'),
(9, 'users', 'permissionlevel'),
(45, 'users', 'previousinsurer'),
(25, 'users', 'referral'),
(26, 'users', 'referralstep'),
(38, 'users', 'relativetype'),
(8, 'users', 'role'),
(20, 'users', 'subdepartment'),
(22, 'users', 'weeklymenu');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-09-23 04:44:47.626848'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-09-23 04:44:47.704653'),
(3, 'auth', '0001_initial', '2025-09-23 04:44:47.892512'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-09-23 04:44:47.923470'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-09-23 04:44:47.939401'),
(6, 'auth', '0004_alter_user_username_opts', '2025-09-23 04:44:47.954712'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-09-23 04:44:47.954712'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-09-23 04:44:47.954712'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-09-23 04:44:47.970740'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-09-23 04:44:47.985985'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-09-23 04:44:47.985985'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-09-23 04:44:48.033176'),
(13, 'auth', '0011_update_proxy_permissions', '2025-09-23 04:44:48.048650'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-09-23 04:44:48.048650'),
(15, 'users', '0001_initial', '2025-09-23 04:44:48.502182'),
(16, 'admin', '0001_initial', '2025-09-23 04:44:48.580568'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-09-23 04:44:48.595989'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-09-23 04:44:48.610781'),
(19, 'evaluations', '0001_initial', '2025-09-23 04:44:48.829988'),
(20, 'sessions', '0001_initial', '2025-09-23 04:44:48.861195'),
(21, 'users', '0002_employee_can_access_all_departments', '2025-09-23 05:51:04.908044'),
(22, 'users', '0003_employee_can_access_dashboard', '2025-09-23 05:58:16.190144'),
(23, 'users', '0004_alter_role_name', '2025-09-24 05:55:38.657852'),
(24, 'users', '0005_alter_role_name', '2025-09-24 06:03:18.314271'),
(25, 'users', '0006_alter_role_name', '2025-09-24 06:52:06.587435'),
(26, 'axes', '0001_initial', '2025-09-26 04:05:01.405855'),
(27, 'axes', '0002_auto_20151217_2044', '2025-09-26 04:05:01.569254'),
(28, 'axes', '0003_auto_20160322_0929', '2025-09-26 04:05:01.583639'),
(29, 'axes', '0004_auto_20181024_1538', '2025-09-26 04:05:01.598839'),
(30, 'axes', '0005_remove_accessattempt_trusted', '2025-09-26 04:05:01.620970'),
(31, 'axes', '0006_remove_accesslog_trusted', '2025-09-26 04:05:01.641109'),
(32, 'axes', '0007_alter_accessattempt_unique_together', '2025-09-26 04:05:01.679845'),
(33, 'axes', '0008_accessfailurelog', '2025-09-26 04:05:01.749328'),
(34, 'axes', '0009_add_session_hash', '2025-09-26 04:05:01.785891'),
(35, 'users', '0007_participation', '2025-09-26 05:06:55.771563'),
(36, 'users', '0008_alter_participation_attachment', '2025-09-26 07:49:00.851855'),
(37, 'users', '0009_evaluation', '2025-09-28 02:55:34.213007'),
(38, 'users', '0010_participation_feedback_participation_is_finalized_and_more', '2025-09-30 03:27:26.764735'),
(39, 'users', '0011_alter_participation_options_and_more', '2025-09-30 03:46:01.357911'),
(40, 'users', '0012_alter_participation_attachment', '2025-09-30 05:04:44.795869'),
(41, 'users', '0013_participation_factory_and_more', '2025-10-21 04:32:16.064654'),
(42, 'users', '0014_participation_summarized_content_and_more', '2025-10-21 10:31:05.575546'),
(43, 'users', '0015_participation_orginal_content_and_more', '2025-10-21 11:35:15.196030'),
(44, 'users', '0016_participation_changed_content', '2025-10-21 12:22:52.861315'),
(45, 'users', '0017_participation_count_sumerized', '2025-10-22 05:56:04.445057'),
(46, 'users', '0016_participation_count_sumerized', '2025-10-22 06:05:42.043831'),
(47, 'users', '0017_employee_day_usage_employee_last_file_upload', '2025-10-22 08:38:48.502595'),
(48, 'users', '0018_employee_mac_address', '2025-10-25 08:59:16.814133'),
(49, 'users', '0019_remove_employee_mac_address', '2025-10-25 11:04:01.142633'),
(50, 'users', '0020_remove_employee_role_employee_roles_and_more', '2025-10-28 04:53:33.129741'),
(51, 'users', '0021_alter_participation_options_participation_department_and_more', '2025-11-01 12:20:10.649981'),
(52, 'users', '0022_factory_manager', '2025-11-01 12:42:38.778146'),
(53, 'users', '0023_participation_role_name_and_more', '2025-11-05 06:46:13.636385'),
(54, 'users', '0024_remove_employee_department_remove_employee_factory_and_more', '2025-11-05 09:32:56.871429'),
(55, 'users', '0025_department_is_committee_department_manager_2_and_more', '2025-11-12 07:58:14.015359'),
(56, 'users', '0026_alter_participation_status', '2025-11-12 08:24:21.390803'),
(57, 'users', '0027_factory_linked_factory', '2025-11-12 11:29:06.160924'),
(58, 'users', '0028_department_linked_factory_and_more', '2025-11-12 11:57:26.202924'),
(59, 'users', '0029_participation_department_committee_and_more', '2025-11-12 12:33:27.522370'),
(60, 'users', '0030_participation_manager_1_status_and_more', '2025-11-13 08:41:54.809763'),
(61, 'users', '0031_participation_supervisor_feedback', '2025-11-13 08:55:25.040438'),
(62, 'users', '0032_rename_manager_1_feedback_participation_manager_feedback_and_more', '2025-11-15 06:44:00.265726'),
(63, 'users', '0033_alter_subdepartment_linked_factory', '2025-11-15 11:03:27.309551'),
(64, 'users', '0034_employee_personnel_code_and_more', '2025-11-16 07:57:54.562686'),
(65, 'users', '0035_rename_personnel_code_employee_personnel_code', '2025-11-17 05:45:27.121395'),
(66, 'users', '0036_alter_participation_status', '2025-11-20 06:50:46.739276'),
(67, 'users', '0037_alter_participation_status', '2025-11-20 06:50:46.754896'),
(68, 'users', '0038_department_is_restaurant', '2025-11-20 06:50:46.801770'),
(69, 'users', '0039_fooditem_remove_department_is_restaurant_and_more', '2025-11-20 06:50:47.192266'),
(70, 'users', '0040_menuitem_food', '2025-11-20 06:52:43.817054'),
(71, 'users', '0041_alter_menuitem_options_and_more', '2025-11-20 06:53:43.295424'),
(72, 'users', '0042_remove_menuitem_food_name', '2025-11-20 06:54:01.672868'),
(73, 'users', '0043_alter_menuitem_options_and_more', '2025-11-20 06:54:27.402725'),
(74, 'users', '0044_fooditem_real_price_alter_fooditem_default_price', '2025-11-22 08:45:43.505761'),
(75, 'users', '0045_alter_foodreservation_unique_together_and_more', '2025-11-23 04:52:25.187394'),
(76, 'users', '0046_foodreservation_related_factory', '2025-11-25 09:01:48.737953'),
(77, 'users', '0047_participation_return_count_and_more', '2025-11-26 05:34:05.422938'),
(78, 'users', '0048_alter_participation_return_count', '2025-11-26 05:35:15.237621'),
(79, 'users', '0049_alter_participation_return_count', '2025-11-26 05:36:12.027118'),
(80, 'users', '0050_participation_is_audio', '2025-11-26 06:14:55.324894'),
(81, 'users', '0051_foodreservation_feedback_foodreservation_rating', '2025-11-27 09:38:52.935546'),
(82, 'users', '0052_employee_is_food_receiver', '2025-12-01 08:45:58.805384'),
(83, 'users', '0053_remove_employee_is_food_receiver', '2025-12-01 08:54:37.639705'),
(84, 'users', '0054_employee_food_receiver_factory_and_more', '2025-12-01 09:04:30.247797'),
(85, 'users', '0055_alter_employee_food_receiver_role', '2025-12-01 09:17:16.376295'),
(86, 'users', '0056_foodreservation_is_delivered', '2025-12-01 10:05:45.322186'),
(87, 'users', '0057_foodreservation_guest', '2025-12-02 10:15:34.365551'),
(88, 'users', '0058_foodreservation_total_price_at_reservation_and_more', '2025-12-02 10:48:33.607246'),
(89, 'users', '0059_remove_foodreservation_total_price_at_reservation_and_more', '2025-12-02 10:50:28.176914'),
(90, 'users', '0060_remove_foodreservation_final_price_at_reservation_and_more', '2025-12-02 10:57:11.464393'),
(91, 'users', '0061_remove_foodreservation_final_price_and_more', '2025-12-02 11:31:25.644673'),
(92, 'users', '0062_rename_default_price_fooditem_factory_price_and_more', '2025-12-03 08:53:41.572052'),
(93, 'users', '0063_referral_referralstep', '2025-12-10 04:10:16.879433'),
(94, 'users', '0064_remove_referralstep_referral_and_more', '2025-12-10 05:08:03.272451'),
(95, 'users', '0065_orgunit_referral_referralstep', '2025-12-10 05:08:44.747134'),
(96, 'users', '0066_orgunit_employee_alter_orgunit_unit_type', '2025-12-13 09:45:41.273152'),
(97, 'users', '0067_remove_orgunit_employee_alter_orgunit_unit_type', '2025-12-13 09:55:29.442243'),
(98, 'users', '0068_employee_unlimit_reservation_notification_and_more', '2025-12-15 07:10:22.288547'),
(99, 'users', '0069_remove_employee_unlimit_reservation', '2025-12-15 07:13:51.973432'),
(100, 'users', '0070_employee_unlimit_reservation', '2025-12-15 07:14:12.525003'),
(101, 'users', '0071_alter_notification_target_factories_and_more', '2025-12-16 11:03:28.612797'),
(102, 'users', '0072_banks_country_dependencystatus_employmenttype_gender_and_more', '2025-12-23 07:28:16.026876'),
(103, 'users', '0073_bankaccounttype_bankaccount_bank_account_type', '2025-12-23 14:05:00.854995'),
(104, 'users', '0074_baseinsurance_employee_bimeh_base_insurance', '2025-12-24 07:29:48.437934'),
(105, 'users', '0075_previousinsurer_employee_father_name_and_more', '2025-12-24 10:53:16.639545'),
(106, 'users', '0076_remove_employee_bimeh_insurance_type_and_more', '2025-12-24 11:25:15.680493'),
(107, 'users', '0077_alter_bankaccount_account_number_and_more', '2025-12-24 12:39:12.378149'),
(108, 'users', '0078_rename_title_jobgroup_name', '2025-12-24 12:49:30.472546'),
(109, 'users', '0079_alter_bankaccount_bank', '2025-12-25 05:46:00.083183'),
(110, 'users', '0080_alter_bankaccount_account_number', '2025-12-25 09:34:01.726534');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('08geuzg4hr7b4k34g8ds29aabszxzqe6', '.eJxVjDsOwjAQBe_iGllx4m9Kek6AkLXrNTiAbCl2CoS4O4mUAto38-bNPCwt-aXG2U_ERibY4XdDCI-YN0B3yLfCQ8ltnpBvCt9p5adC8Xnc3b9AgprWt6NBAUIkZa0zpCS5PqDRQUZrghayG8wgpEbjVIwqoNWdkKZH7OGqqFujIUHzaaqtzC82ni-fLwgTPiM:1vCZKY:VvmPT3CuzlW0Eub4qNkbh36-h2d8rYi64mw8lMDWkKE', '2025-11-08 08:08:54.464446'),
('0f8lkot1gwj9araofxc2t6g503zyjszl', '.eJzdV9uOmzAQ_ZWIZxThK2Ef-94vaFfIgEnocom4VFqt9t_rG7HZAGlWaVX64sQztuec4xljv3kxG_pTPHS8jYvMe_Ig9XzXmLD0hdfSk_1g9bHZp03dt0Wyl0P2xtvtvzYZL7-YsZMFTqw7idkhyVmSBwSEEAEMGECBMIQ0ogwDzCIa5QmJsgBFAcoJBgTRlGICspAFQU4lqorV7MgrXvdx33LuPX178yTmeihL36tZJUze9yEQ02QLc9mmqWwR2MkfFik3Vh2EHL_6D5meLWK1TSlX64azoMCyqqiF8dSUWVEfu0tkMA0b6tU_BsdUxc5VVKgGIYUQAztN2zHdWQIY2pVcUAZGrPVohSNnad-0BbfI4ASZ5m1Cq6CQu0E1jJ3VYNRjp3X7W8w0j1eHWcbPrO3lnltuZMINHiwfhHfuRv_7hC09h7P0SbZz3mdf5GQyp8o0FxG8Sv5ZobarnlJI1efPomukbrw6l82rOBie3_25KritCfyfNbmoQtfqB26H7XjyG-a6s1Ad6BHVsSFtVCZcFwR-REFsWIaLEGC1CCxcjQ-DP3NkR9PtAK5MKu7BUdelbDoHDXGh-u0xGHw6Tu7EWTplpKwLh4u5cBG7vSZguJ0c-u17CcAz3A0gcsXd5JfuGKrACrExhe6uCn_GGKO1Yjnck1luRutjzpT1JgS98R13yg194gUypQU_fE2v3xLkQW8JeIeASxhvlqLRx_fSoW1lbq0l6DhmfFGZe_RoHmOZq-RodpZST2ZAnaUm2Rvb5-noL7o4baqq6Hv5gs1Z2XEHK2flCuD3X1zCq4A:1vLydm:xNsq9HQGrn8qvqF9Ntuou3pvOzAU4BMn2uUWUpAX9o8', '2025-12-04 06:59:38.534440'),
('0sfgmmfnn9ty24cis8yerb9xy98nib8n', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCR0uURcKq1W--_1jdhsIGlWaVX6QmKP7TnneGZg3vyEjcMxGXveJWXuP_mQ-oE7mbLshTfSkv9gzaHdZW0zdGW6k0t2xtrvvrY5r76YtbMDjqw_it0RKVhahAREEAEMGEChmIhoTBkGmMU0LlIS5yGKQ1QQDAiiGcUE5BELw4JKVDVr2IHXvBmSoePcf_r25kvMzVhVgd-wWkz538dQbJNPWMhnlsknAp78YbEyYzVAyLGr_5Dp3cJX11bytH48CQosr8tGTB7bKi-bQ3_2DOZuI336R-eYKt-F8grVIqQQYmC36XlMPUsAQ3uSC8rASLQenTAULBvaruQWGZwh07yNa-UUctephuFZDSY9PK3b32Kmebw6zHJ-Yt0g79xyIzNucG_5IOy5F_3vE7b0HM7SJtkuWZ8DEZPpkirzWETwIvgXhdquekohXp-q9lXUguf3YCnwb8sA_wcZVJn6WfatDB9Hk7Mq9FrKwO2wnYq9Ya4HKwmBHpEQG9JmJSHwIxJiwzKchQBXk8DC1fgw-DNVOp5fB3BlUn73jrouZTPYa4gr2W_LYPhpP4XjZ63KSFlXiov5xiL2eo3DaDsx9NufIgAvcDeAyAV3E196YKgCK8TGFLo7K4KFyQRdS5b9PZHlRrQucyatNyHojfe4k27oE03HnBb88Da9bB_Ig9oHeIeAaxhvpqLRJ_CzsetkbC02b5Nx6p5s5zhZJj-XFiduL42z4F2wl32StXVdDoPsWQtW9dyBylmV2Lt4_wU_yKID:1vZOTN:ekgofvpyAxVvy1WfIeLeFBlvnb6UPs6JKoXxEuP4mOI', '2026-01-10 07:12:21.545777'),
('19e7utu957catv2z0a41g0z7fj4m77w4', '.eJzdV9uOmzAQ_ZWIZxThCxD2se_9gnaFDNgJXcARl0qr1f57fSM2CyTNKq1KX0jssT3nHM8MzJuXkqE_pUNH27QsvCcPRp7vTmYkf6GNtBQ_SHPk-5w3fVtme7lkb6zd_isvaPXFrJ0ccCLdSeyOQ0YyFoQghghgQAAKxEQcJRHBAJMkSlgWJkWAkgCxEIMQRXmEQ1DEJAhYJFHVpCFHWtOmT_uWUu_p25snMTdDVfleQ2ox5X0fArFNPiGTzzyXTwR28ockyozVACHHrv5DoncLXy2v5GndcBYUSFGXjZg88aoom2N38QymbmN9-kfnOFK-mfIK1SKkEGJgt-l5HO0sAQztSS4oAyPVerTCwEje87akFhmcINO8jWvlFFLXqYaxsxqMeuy0bn-Lmebx6jAr6Jm0vbxzyy2ccIMHywfhnXvR_z5hS8_hLG2S7ZL12RcxmS2pMo1FBGfBvyjUdtVTCtH6XPFXUQue3_2lwL8tA_wfZFBl6mfZcRk-jiYXVaJrKQO3w3Ys9oa5HqwkBHpEQmxIm5WEwI9IiA3LcBECXE0CC1fjw-DPVOlkeh3AlUn5PTjqupTN4KAhrmS_LYPBp_0wx89alZGyrhQX840V2us1DuPtxNBvf4oAvMDdAApn3E186YGhCqwQG1Po7qzwFyZTdC1ZDvdElhvRusyZtN6EoDfe4066oU80HVNa8MPbdN4-hA9qH-AdAq5hvJmKRh_fy4e2lbG12LyNxrF7sp3jaBn9zC1O3M6Nk-BdsJddmvO6Lvte9qyMVB11oFJSpZO74LxIe9Ie6RQQfP8F4ECr8A:1vWALr:DRUX9jxfosf-AjjIT4kPyV6VuIawYzKdHJDXCY3i9j4', '2026-01-01 09:31:15.333942'),
('2dyxl1w7yvofqdfmoy11ir6v5yewt4e1', '.eJzdV9uOmzAQ_ZWIZxThCxD2se_9gnaFDJiELuDIQKXVav-9-EJsL5A0q7QqfSGxx_acczwzMG9eSob-lA4d5WlVeE8ejDzfnsxI_kJbYSl-kPbI9jlre15le7Fkr63d_israP1Fr3UOOJHuNO6Ow5JkZRCCGCKAAQEoGCfiKIkIBpgkUVJmYVIEKAlQGWIQoiiPcAiKmARBGQlUDWnJkTa07dOeU-o9fXvzBOZ2qGvfa0kzTnnfh2DcJp6wFM88F08EduKHJNKM5QAhyy7_Q6J2j744q8Vp3XAeKZCiqdpx8sTqomqP3cUzcN3G6vSPznEkfZfSK5SLkESIgdmm5nG0MwQwNCfZoDSMVOnBR0NJ8p7xihpk0EGmeGvX0imktlMFY2c0mPTYKd3-FjPF49ViVtAz4b24c8MtdLjBg-GD8M6-6H-fsKFncRY2wXbJ-uyPMZktqeLGIoKz4F8UarvqSYVkfv6sOiZ0o825Zq9jYXh-95ey4LYm8H_W5KJKdC1_4HbYTpVfM1eDlexAj8iODWkjI2GeEPgRCbFhGS5CgKtJYOAqfBj8mZKduNcBbJmk34Olrk1ZDw4K4kr2mzIYfNpPaflZqzJC1pXioj-4QnO92mG8nRj67e8SgBe4a0DhjLuOLzXQVIERYmMK3Z0V_sJkiq4ly-GeyLIjWpU5ndabEPTGe9xKN_SJDsSlBT-8Tee9RPigXgLeIeAaxpupqPXxvXzgXMTWYic3GadWyrSRk2XyM7dYcTs3OsG7YK-6NGdNU_W9aGBLUnfUgkpJnTp3wViR9oQfqQsIvv8C9hewwg:1vQhSA:RkwUx0_qO_WHnOiOvwgHTJ0I_JuUeClKGK6xzc7O4zI', '2025-12-17 07:39:10.232638'),
('2ycyvxx7v3zeq2kv2silkgslamchtxmu', 'e30:1vGXxx:umnx88yvfWqCxSOn0jvLKy4-V8i-9HJKofrGU8_uIG0', '2025-11-19 07:30:01.941671'),
('38l8gfx9fs80s2ru8vtrak8et9fx81z5', '.eJxVjDsOwjAQBe_iGlmJv9mU9JwAIWu9NjiAbCl2CoS4O4mUAto38-bNHC4tuaXG2U2BjQzY4XfzSI-YNxDumG-FU8ltnjzfFL7Tyk8lxOdxd_8CCWta3wi2J6khWtP7MCCg8FZGDFpZBQaMsIQkBBrUwg9XrUwnu9gNQCSjUWuUEjaXptrK_GLj-fL5AgDAPfc:1vCZWt:4CMRVmfQqb8_CUesfsDUA9YJ4ApEA8Y9P4YyVPFEqPo', '2025-11-08 08:21:39.658912'),
('43rysse0ste3xcjmtgmf5rm6z0fs6dce', '.eJzdVtuOmzAQ_RXkZxThC6bsY9_7BbsVGsAktGAiA5VWq_33-gKxyaXbSlHVVEgmmbE95xzPMH5DBczToZhHoYq2Rk-IcBSHxhKq70IaT_0N5H7YVYOcVFvuzJTd4h13X4ZadJ-XuZsNDjAe9OosbaBskhRnhGKGAdNEGzKec2CYQc7zpkzzOqF5QpuU4ZTyirMU1xkkScMNqh4k7EUv5FRMSgj09PyGDGY5d12MJPTahF7mRC8zI2nMWFVmpDgyL8itm9k_lAZ--5uAW61jqaEzu43zUVOAum-lNh6Grm7lfjxFxtuwmdv9PDjjNnZjoxI7iVqEDPtlzs545Akw4ncKQS0wCqeH0o4GqmlQrfDIyAaZ472EtkGJCIM6GJHXYNUjcrr9LWaOx2vArBZHUJM5c88t3XAjnzwfyqLwoP99wp5ewHmcy2u0t8lGyUV2X1XiceUxzF0B_mjHwQgj-mM3vOrK__oeX0vzjzUh_4MmgQwnIfivaoI8DsH1a36jBug9auCB5Dg_7-W02T3S_oFlcE98LSd-D8-WCTlLvst2mt6pnZI_0OwWxg-75KJPjKpZKdNabt4b1gmrx94AceBYQ_lr1uoJOtelc1O9J__7T6MRFCg:1vIlqD:gt8TqCVOBAD6FsXNtUc1JysyhPITtVmA2GlnAGMt7MU', '2025-11-25 10:43:13.150127'),
('4n12o3t9v25aqm2wxhiwlvx72n5be0yo', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCR0uUQGKq1W--_FF2KzgaRZpVXpC4k9tmfO8ZyBefMTNvTHZOi4SMrcf_Ih9QN3MmXZC2-kJf_BmkO7y9qmF2W6k0t2xtrtvrY5r76YtbMDjqw7jrsjUrC0CAmIIAIYMIDCcSKiMWUYYBbTuEhJnIcoDlFBMCCIZhQTkEcsDAsqo6pZww685k2f9IJz_-nbmy9jboaqCvyG1eOU_30Ix23yCQv5zDL5RMCTPyxWZqwGCDl29R8yvXv0JdpKntYNpxECy-uyGSePbZWXzaE7ewZzt5E-_aNzTJXvQnmFahFSEWJgt-l5TD0LAEN7khuUCSPRfIjRULCsb0XJbWRwFpnGbVwrp5C7TnUYnuVg4sPTvP0tZBrHq4Ms5ycmennnFhuZYYN7iwdhz73ofx-whedgljaJdsn6HIw5mS6xMs9FBC-Sf5Go7bKnGFL6_Fl2reSN16eqfR0Lw_N7sKSC25zA_5mTMyv0mn7gdtBOld8g14MVdaBHqGND3KhMuBQEfoQgNkzDmQhwVQQ2XB0fBn-mZMfz6wAuTcrv3mHXhWwGex3iivptGQw_7adw_KxVGUnrSnExH1zEXq9xGG0nh377uwTgBewmIHKB3eSXHhiowBKxMYbuVkWwMJmga2LZ35NZbkbrMmdkvQlCb7zHHbmhT3Qgc1jww9v0spcgD-ol4B0ErsV4U4qGn8DPBiFkbq3umxZM7ZT5iJ6mpw2qK6bOeidvbfc5GWfJu2AvuyRr67rse9nA9mLgTqScVYm9ivdfn7ulWg:1vNqOa:P0Q-Evai7SNpFciXsJ6t5vevrJKAH9ALRFBgt46oW8M', '2025-12-09 10:35:40.668878'),
('5iio3h0v5c6spyuf0ruv1usgy5r8eox8', '.eJzdV9uOmzAQ_RXEM4rwDcI-9r1f0K6QATuhyyXiUmm12n-vb8RmA0mzSqvSFxLPYJ85xzOD_eandByO6dizLi0L_8mHkR-4xozmL6yRnuIHbQ7tLm-boSuznXxlZ7z97mtbsOqLeXe2wJH2RzE7JpxmPCQghghgQAEKhSGOkohigGkSJTwjSRGiJEScYEBQlEeYgCKmYcgjGVVNG3pgNWuGdOgY85--vfky5masqsBvaC1M_vcxFNPkE3L5zHP5RMCTPzRRbqwGCDl-9R9SPVtgdW0lV-vHk6BAi7pshPHYVkXZHPozMpjDxnr1j-A4UthcoUL1ElIRYmCnaTuOPEsAQ7uSG5QJI9V6dMLBaT60XclsZHAWmeZtoBUoZC6oDsOzGkx6eFq3v8VM83h1mBXsRLtB7rnlRmbc4N7yQdhzN_rfJ2zpOZylT7Jd8j4HIiezJVXmuYjgRfIvCrVd9ZRCqj5_ln0rdWP1qWpfRWN4fg-WquC2JvB_1uSsSnStfuB22E6d3zDXg5XqQI-ojg1pozLhsiDwIwpiwzKchQBXi8CGq-PD4M-07GS-HcCVSeHuHXVdymaw1yGuVL9tg-GncbiDs9ZlpKwrzcUcuIjdXgMYbyeHfvtcAvACdxMQueBu8ksPDFVghdiYQndXRbBgTNG1Ytnfk1luRus2Z8p6E4Le-I475YY-cQOZ04IfvqaXdwnyoLsEvEPAtRhvlqLRJ_Dzsetkbrk3uUnNyTfdpMz5eTJPGOYIOZmdhDWyTJ5Zypp7tANT9mne1nU5DPLWymnVMyc-RqvUbsD7Lyh8oMI:1vMhtf:tAlgKVFHA11Zn8sFqE-khmNJixpE0y5BBBiYQANdWdM', '2025-12-06 07:19:03.394134'),
('64ug50sewfk94jn0yec5a10m5wq7e823', '.eJzdWMtuozAU_ZUM6yjCLwjddbKeVTWraYUcYxpmeFQYRqqq_vv4RW0S0qQPVUMkRGxfc-85x_dik6cgpX23S3vB27TIgqsARsHSH9xS9ofXypL9pvV9s2JN3bXFdqWmrKxVrH40GS-_27kjBzsqdvLpmOR0m4cExBABDChAoRyIoySiGGCaREm-JUkWoiREOcGAoIhFmIAspmGYRwpVRWt6zyted2nXch5c_XoKFOa6L8tlUNNKDgW3fSgfU3eYqztj6o7AQv3QRJux7iDk2XUbUvO0jNU2pfIm-gdJgWZVUcvBXVNmRX0vXiKDcdjYeN8PjiMdO9dRoZ6ENEIM3GNmHEcLRwBD58kHZWGkRo9WGnLKuqYtuEMGR8gMbxtaB4XcD2pgLJwGgx4Lo9tXMTM8Hj1mGX-gbafW3HEjI25w7fggvPAX-v8n7Oh5nJVNsZ2y3i1lTm6nVBnnIoIHyT8p1HzV0wrp-vxbiEbpxquHsnmUL4a75-VUFZzWBF6yJi-qRK_VD5wP2-HNb5mbzpHqQJ9RHTPSRmfCYUHgzyiIGctwtArsyYA4HPYwEM-H7NkbKMAT3C0gcsDdULEdSxU4IWam0Jt33OXEYIpe24jXb8ksvHaKmXpEeD6CnthwvHJD7zgqj2nBvdf-4aGXfNKhF75BwGMYT5ai1WcZsL5tVW5NfnIMxuHM7753BssQ59Di5e2hcZS8E_ZCpKypqqLr1JdWTkvBPaiclqm_FmxHJcZCKCR6OdRXopyp-AhJQzR9yxS7n_KTMFA54Sa4NRn09bPOlEfktZPF_lra1WV-StudK99fcVtd1rtNgpUP8VoISYRKbGOcF0PEZaxNbuOVaH9r4zzefzcxdgb7Ka_qHjKPqvFqzhQ2qCXhUzHmaGW2IOzsMD6B08kF8rPWlTIq1HVbX99sTJMyIXsb2ZeXHn-leWR8cyOvoWfcXngCvTNDvh1dUA-gUgSGob-Brj3gxP9_h5i2PxQ5w3lZ8eFamEp2rxa-OuXvnv8B33vohQ:1vLKgO:puoFHc9VDQog9WCobshFKGJ3YXJJ6ioe-w35HH7gew4', '2025-12-02 12:19:40.365278'),
('6be45kmbqna6yrtp1a48r6rpmw1lb5x6', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCR0uURcKq1W--_1jdhsIGlWaVX6QmKP7TnneGZg3vyEjcMxGXveJWXuP_mQ-oE7mbLshTfSkv9gzaHdZW0zdGW6k0t2xtrvvrY5r76YtbMDjqw_it0RKVhahAREEAEMGEChmIhoTBkGmMU0LlIS5yGKQ1QQDAiiGcUE5BELw4JKVDVr2IHXvBmSoePcf_r25kvMzVhVgd-wWkz538dQbJNPWMhnlsknAp78YbEyYzVAyLGr_5Dp3cJX11bytH48CQosr8tGTB7bKi-bQ3_2DOZuI336R-eYKt-F8grVIqQQYmC36XlMPUsAQ3uSC8rASLQenTAULBvaruQWGZwh07yNa-UUctephuFZDSY9PK3b32Kmebw6zHJ-Yt0g79xyIzNucG_5IOy5F_3vE7b0HM7SJtkuWZ8DEZPpkirzWETwIvgXhdquekohXp-q9lXUguf3YCnwb8sA_wcZVJn6WfatDB9Hk7Mq9FrKwO2wnYq9Ya4HKwmBHpEQG9JmJSHwIxJiwzKchQBXk8DC1fgw-DNVOp5fB3BlUn73jrouZTPYa4gr2W_LYPhpP4XjZ63KSFlXiov5xiL2eo3DaDsx9NufIgAvcDeAyAV3E196YKgCK8TGFLo7K4KFyQRdS5b9PZHlRrQucyatNyHojfe4k27oE03HnBb88Da9bB_Ig9oHeIeAaxhvpqLRJ_CzsetkbC02b5Nx6p5s5zhZJj-XFiduL42z4F2wl32StXVdDoPsWQtW9dyBylmV2Lt4_wU_yKID:1vXvyf:nTzZMOjW1DMayd3M2TKUKlw_A3AwmPssFZ8YOOladuE', '2026-01-06 06:34:37.917819'),
('6soejvascpv4nbu03ot9qos5pgng7ild', '.eJzdV9uOmzAQ_ZWIZxThCxD2se_7Be0KGbATuoAjLpVWq_33-kZsEkiaVVqVfSHxDPacczwz2O9eSob-kA4dbdOy8J48GHm-a8xI_kob6Sl-kmbPtzlv-rbMtvKVrfF222de0OqbeXeywIF0BzE7DhnJWBCCGCKAAQEoEIY4SiKCASZJlLAsTIoAJQFiIQYhivIIh6CISRCwSKKqSUP2tKZNn_Ytpd7T93dPYm6GqvK9htTC5P0YAjFNPiGTzzyXTwQ28ockyo3VACHHr_5DomeLWC2v5GrdcBQUSFGXjTAeeFWUzb47RQbTsLFe_Tw4jlRspqJC9RJSCDGw07QdRxtLAEO7kgvKwEi1Hq1wMJL3vC2pRQYnyDRvE1oFhdQNqmFsrAajHhut279ipnm8OcwKeiRtL_fccgsn3ODO8kF44270_0_Y0nM4S59kO-d98UVOZnOqTHMRwYvknxVqveophWh9rPib6AUvH_5c4t-WAX4FGVSb-lV2XKaPo8lJlehaycD1sB2bvWGuBwsFgR5RECvSZqEg8CMKYsUynIQAV4vAwtX4MPg7XTqZbgdwZVJxd466LmUz2GmIC9Vv22Dw6TjMibPUZaSsC83FnLFCu70mYLyeHPrjowjAM9wNoPCCu8kvPTBUgRViZQrdXRX-jDFF14pld09muRmt25wp61UIeuM77pQb-sSlY0oLnn1NL68P4YOuD_AOAZcw3ixFo4_v5UPbytwy804CWs94dTIH5tE8RjAHyNHspKsRZfRMElZfnIETpuzSnNd12ffymspI1VEHHSVVOpGf8yLtSbunZ0g-fgNHx6Ta:1vVjQ6:nazpKgXz_G0x2Bws0oIUejlWJ6yuqm7ei_sRyz3jKKY', '2025-12-31 04:45:50.607887'),
('79orza2h2yvnk64hki9vmam7iri0qf7m', '.eJzdVttuozAQ_RXkZxThC2bp4773C9oKDWASdsFEBipVVf-9NraLSdPtrhRVmyqSk8zYPnOOZzx-RgXM06GYR6GKtkY3iHAUh8YSqt9CGk_9C-R-2FWDnFRb7syUnfOOu9uhFt1PN3ezwQHGg16dpQ2UTZLijFDMMGCaaEPGcw4MM8h53pRpXic0T2iTMpxSXnGW4jqDJGm4iaoHCXvRCzkVkxIC3dw9IxOznLsuRhJ6bUL3c6KXmZE0ZqwqM1IcmS_IFzdb_lAa-JffBOxqjaWGzuw2zkdNAeq-ldp4GLq6lfvxDRlvYTO7-yk44wt2s6CSZRJdImR4XWbtjEcrAUbWncKgXBiF1UNpRwPVNKhWrJGRTWSWt4NeQIkIQW0Y0aqB1yOyun0VM8vjKWBWiyOoyZz5yi3dcCM_Vj6UReFB__-EV3oB53Euz9HeJhsl77L7rBLXK49hbgvwsR0HI4zoj93wpCv_4SU-l-afa0K-gyaBDG9C8D_VBLkegv42_6AG6CVq4IrkOD1vd9rsEml_xTLYT3wuJ_4uni0TcpJ879tpeqF2Sv5Bs49i_LRLOn1iVM1KmdYSPmb8Xep9_jHhOow3ewx3yXpz0K-cLN6zKVj7lMTo5RXA-Q3S:1vI31E:itsaa54Rska8Qh6s0O7jKUegnMb3pb3YUQXEj9OGVjI', '2025-11-23 10:51:36.225901'),
('7jiqbwiev1mw438qgv2arganql9lpuxb', '.eJzdVtuOmzAQ_RXkZxThC6bsY9_7BbsVGsAktGAiA5VWq_33-gKxyaXbSlHVVEgmmbE95xzPMH5DBczToZhHoYq2Rk-IcBSHxhKq70IaT_0N5H7YVYOcVFvuzJTd4h13X4ZadJ-XuZsNDjAe9OosbaBskhRnhGKGAdNEGzKec2CYQc7zpkzzOqF5QpuU4ZTyirMU1xkkScMNqh4k7EUv5FRMSgj09PyGDGY5d12MJPTahF7mRC8zI2nMWFVmpDgyL8itm9k_lAZ--5uAW61jqaEzu43zUVOAum-lNh6Grm7lfjxFxtuwmdv9PDjjNnZjoxI7iVqEDPtlzs545Akw4ncKQS0wCqeH0o4GqmlQrfDIyAaZ472EtkGJCIM6GJHXYNUjcrr9LWaOx2vArBZHUJM5c88t3XAjnzwfyqLwoP99wp5ewHmcy2u0t8lGyUV2X1XiceUxzF0B_mjHwQgj-mM3vOrK__oeX0vzjzUh_4MmgQwnIfivaoI8DsH1a36jBug9auCB5Dg_7-W02T3S_oFlcE98LSd-D8-WCTlLvst2mt6pnZI_0OwWxg-75KJPjKpZKdNabt4b1gmrx94AceBYQ_lr1uoJOtelc1O9J__7T6MRFCg:1vIkwz:LxhxjUK1VdIdWDqEiohQMvWuALf4m_TWyqdKJOgR9PE', '2025-11-25 09:46:09.793460'),
('7tbstu5979a1ew6l7ozry9zyul6j7wsm', '.eJzdV9uOmzAQ_ZWIZxThG4R97Hu_oF0hAyahyyUyUGm12n-vb8RmA6RZpVXpC4lnbM85xzMDfvMSOvSnZOgYT8rce_Jg6PmuMaXZC2ukJ_9Bm2O7z9qm52W6l1P2xtvtv7Y5q76YuZMNTrQ7idURKWhaBAREEAEMKECBMERhHFIMMI3DuEhJnAcoDlBBMCAozEJMQB7RIChCiaqmDT2ymjV90nPGvKdvb57E3AxV5XsNrYXJ-z4EYpl8wkI-s0w-EdjJHxorN1YDhBy_-g-pXi1i8baSu3XDWVCgeV02wnhqq7xsjt0lMpiGjfTuH4PjUMUuVFSoJiGFEAO7TNtxuLMEMLQ7uaAMjETrwYWjoFnf8pJZZHCCTPM2oVVQyNygGsbOajDqsdO6_S1mmserwyxnZ8p7eeaWG5lwgwfLB-Gde9D_PmFLz-EsfZLtnPfZFzmZzqkyzUUEr5J_VqjtqqcUUvX5s-xaqRurz1X7KhrD87s_VwW3NYH_syYXVcK1-oHbYTt2fsNcDxaqAz2iOjakjcqE64LAjyiIDctwEQKsFoGFq_Fh8Gdadjw9DuDKpOIeHHVdymZw0BAXqt-2weDTcQonzlKXkbIuNBfzwUXs8ZqA0XZy6Le_SwCe4W4AkSvuJr_0wFAFVoiNKXR3VfgzxgStFcvhnsxyM1q3OVPWmxD0xnvcKTf0iRvIlBb88Da9vkuQB90l4B0CLmG8WYpGH9_LBs5lbq0l6DhnvFGZ7-jRPMYyfW00O1upKzPAzlaT7E3s9XT0l12StXVd9r28wfZ8YA5URqsVvO-_ALaEqzc:1vOBB6:f8Mt5SKJ5jedwJFMYVSGKPC9XqpfcF2TS9r1rvoqvRI', '2025-12-10 08:47:08.362689'),
('872u9lrm1jrrbr918amthcxpd1596rq4', '.eJzdV9luozAU_RXEM4rwSujjvM8XzFTIgEloWSKWkaqq_z7eqE0gaVNF1TAvJL7X9j3n-F4vr37CxuGYjD3vkjL3H3xI_cA1pix75o305E-sObS7rG2Grkx3ssvOePvdzzbn1Q_TdzbBkfVHMToiBUuLkIAIIoABAygUhojGlGGAWUzjIiVxHqI4RAXBgCCaUUxAHrEwLKhEVbOGHXjNmyEZOs79h1-vvsTcjFUV-A2rhcn_PYZimPzCQn6zTH4R8OQPi5UbqwZCjl_9h0yPFrG6tpKz9eNJUGB5XTbCeGyrvGwO_XtkMA8b6dnPg2OqYhcqKlSdkEKIgR2m7Zh6lgCGdiYXlIGRaD064ShYNrRdyS0yOEOmeZvQKijkblANw7MaTHp4WrfvYqZ5vDjMcn5i3SDX3HIjM25wb_kg7LkL_e8TtvQcztIn2a55HwORk-maKvNcRHCR_KtCbVc9pZCqzz9l30rdeH2q2hexMTy-BWtV8LEm8H_QxJHhXQh6rWTgdghOm70hqxsXCgLdoyA2pM354pulx_eogQ3LcLEKzGWAWBzm_I-2Q_bTZybAK9wNILLgrqmYhqEKrBAbU-jmQzZYMSbo2tm7vyWz8N4qpusR4e0IevXcnZUb-sLteE4Lnm37y3suudM9F94g4CWMH5ai0Sfws7HrZG6tvjIm53TNt0-cyTPFWXqcvF06Z8m74i_7JGvruhwG-bgqWNVzBypnVWLX4u0v9Ew50w:1vKUUm:YGxnnEKT7TnmWNr-8_rXzFwzscaw3Jq3KnBwknfjbqM', '2025-11-30 04:36:12.755681'),
('898mc6ovjlwtcthy41a3minkre509qn3', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCS0XCIDlVar_ff6xtokJNusoqr0hcQzHs-c4xl7_BpmbBqP2TRwkdVl-BRCGka-MGfFT94pTfmDdYd-V_TdKOp8p6bsrHbYfe1L3nyxcxcLHNlwlNYJqVhexQQkEAEMGECxFCQ0pQwDzFKaVjlJyxilMaoIBgTRgmICyoTFcUVVVC3r2IG3vBuzUXAePn17DVXM3dQ0UdixVorC71MszdQXVupbFOqLQKB-WKrVWA8Q8vT6P2TGWvoSfaNWG6aThMDKtu6k8Ng3Zd0dhnfPYOk2MaufO8dU-660V6gnIR0hBs7MyDENHAAM3Up-UDaMzPAhpKJixdiLmrvI4CIyg9u61k4h952aMALHwcxHYHj7W8gMjhcPWclPTIxqzx02ssAG9w4PwoG_0f8-YAfPw6x0Cu2a9jmSOZmvsbLMRQQvkn-VqO2ypxnS9fmrHnrFG29PTf8iD4bnt2itCj7mBP4PnHg0vBNBb5UM3A7A-bC3YM3gSkGgRxTEhrg533y79fgRNbBhGq5WgW0GiIvD3v_JdsD-8Z0J8Ap2GxC5wG6g2IGFChwRG2Po7ks2WhFm6Nbdu78ns_DeMWbqEeHtEHrz3l2UG_pEd7yEBc-O_cs-lzyoz4V3EHgtxg9L0fIThcUkhMqtq3bzhLnVtw3eLJ4N9IuNevO9vHUvo1m5SN4VfT1kRd-29Tiqx9UoJu5FylmTua14-w0trjhY:1vKBSm:0arRRhd_7wVmR7YDIaaPP3J4eL1miCRnjFlN65uMHtU', '2025-11-29 08:16:52.744766'),
('8eafbq27g56ezb369mkp73zfov6oykar', 'e30:1vK8fe:WfzMzEKoM3pu_vDUzTAYf9Vr4dFIZmjmHEC_UV15kEI', '2025-11-29 05:17:58.676676'),
('93jsncpsoq97x4kiymrhgyxnr5pb3rmz', '.eJxVjDsOwjAQBe_iGlmO_0tJnzNY6_WCA8iR4qRC3B0ipYD2zcx7iYTbWtPWeUlTEWcB4vS7ZaQHtx2UO7bbLGlu6zJluSvyoF2Oc-Hn5XD_Dir2-q0RwkDGAQc_5BIRUOdgGIuzwYIHrwMhaY0enc7x6qxXRrGKQGTYW_H-AN-kN4Q:1v8BSD:bcEYlt7pSS2eW34iWDSd8pRJIvtu09Re58Sh3ac4hfY', '2025-10-27 05:50:41.599496'),
('adsaq9ovdx99aigckd0gt3zwirtmgkn9', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCR0uURcKq1W--_1jdhsIGlWaVX6QmKP7TnneGZg3vyEjcMxGXveJWXuP_mQ-oE7mbLshTfSkv9gzaHdZW0zdGW6k0t2xtrvvrY5r76YtbMDjqw_it0RKVhahAREEAEMGEChmIhoTBkGmMU0LlIS5yGKQ1QQDAiiGcUE5BELw4JKVDVr2IHXvBmSoePcf_r25kvMzVhVgd-wWkz538dQbJNPWMhnlsknAp78YbEyYzVAyLGr_5Dp3cJX11bytH48CQosr8tGTB7bKi-bQ3_2DOZuI336R-eYKt-F8grVIqQQYmC36XlMPUsAQ3uSC8rASLQenTAULBvaruQWGZwh07yNa-UUctephuFZDSY9PK3b32Kmebw6zHJ-Yt0g79xyIzNucG_5IOy5F_3vE7b0HM7SJtkuWZ8DEZPpkirzWETwIvgXhdquekohXp-q9lXUguf3YCnwb8sA_wcZVJn6WfatDB9Hk7Mq9FrKwO2wnYq9Ya4HKwmBHpEQG9JmJSHwIxJiwzKchQBXk8DC1fgw-DNVOp5fB3BlUn73jrouZTPYa4gr2W_LYPhpP4XjZ63KSFlXiov5xiL2eo3DaDsx9NufIgAvcDeAyAV3E196YKgCK8TGFLo7K4KFyQRdS5b9PZHlRrQucyatNyHojfe4k27oE03HnBb88Da9bB_Ig9oHeIeAaxhvpqLRJ_CzsetkbC02b5Nx6p5s5zhZJj-XFiduL42z4F2wl32StXVdDoPsWQtW9dyBylmV2Lt4_wU_yKID:1vVkml:fBas3zmr67o9W5sw60DUh6nmPYU-BWerb4Me-CeUXXU', '2025-12-31 06:13:19.498311'),
('af0fwt3yi64b9cwt1sfb4s0n6mbq9o03', '.eJxVjDsOwjAQBe_iGlm24y8lfc5g7XoXHECOFCcV4u4QKQW0b2beS2TY1pq3zkueSJyFFqffDaE8uO2A7tBusyxzW5cJ5a7Ig3Y5zsTPy-H-HVTo9VsnGhwgMLkYUyBnKZmCwRfLMRSvrRrCoK3HkByzKxi90jYYRANXR0q8P-PfN7A:1vAhc1:tUprNV2VfpP8uIqbskH07fAC49saW337-2MJClYNFMk', '2025-11-03 04:35:13.396346'),
('cn8qarc6h8oawqo1pvsyz2d3t24vnjzp', '.eJxVjDsOwjAQBe_iGlm24y8lfc5g7XoXHECOFCcV4u4QKQW0b2beS2TY1pq3zkueSJyFFqffDaE8uO2A7tBusyxzW5cJ5a7Ig3Y5zsTPy-H-HVTo9VsnGhwgMLkYUyBnKZmCwRfLMRSvrRrCoK3HkByzKxi90jYYRANXR0q8P-PfN7A:1v8A2Y:YeP9j71xMlsNWT2iNyQYXcly0IcDiO4cW3LIu_BGbMg', '2025-10-27 04:20:06.650328'),
('fgx78rctf2jaa4howr1gpfeddz9tnbqb', '.eJzdVl1PgzAU_Sukz2ShHxTx0Xd_gRpygbKhUJYCJovxv9tSGMXhV7IYZ5Z0W0_bc8_pvbl9QQn03S7pW6GSMkfXiHDku5MpZE9CGiR_BLltNlkjO1WmG7NkM6Lt5rbJRXUzrl0csIN2p3dHYQFpEYQ4IhQzDJgGeiLiMQeGGcQ8LtIwzgMaB7QIGQ4pzzgLcR5BEBTcRFWDhK2oheySTgmBru9ekIlZ9lXlIwm1nkL3faC3mZEUZswyM1LsmS-IB5gNfyh18OE3Abtbc6mmMqe1_V5LgLwupZ7cNVVeym17ZMZL2sie_p6c8YG7GFjJsIgOETI8b7PzjHuzAEbmk5ygrNwCsq5RpZiDIYtgrNSRbeAhwuWxzN4se7LAs1b9qphc7EF15mZnOeFCDrmaJVDmudf55zU68hKbw0pjbZ-uyV6mFCUnObzqxOXaY5TbMnsu28YYI-p91Rx0fT-8-muZ_bUn5D944thwNIJ_VhPkcgROdf9BDdBz1MAF2fH-vsfbZudI-wu2wX78tZz4XjxLJeTLDhqeqYOSH3j2UYxjeAenYyxLZfTHR1mvlGktq0-WCRyfLsn8XpqQiecUcdrWKbgo3SP--gatcgqD:1vGsdK:K7j70XM8ULI2tMVYVF-BowTAjSNTqmFFDpro8Jz8pI8', '2025-11-20 05:34:06.845811'),
('flyvja2cdvcdam92o748bwp3zupefkrx', '.eJxVjEEOwiAQRe_C2pC2Awy4dO8ZyAxDpWpoUtqV8e7apAvd_vfef6lI21ri1vISJ1FnFdTpd2NKj1x3IHeqt1mnua7LxHpX9EGbvs6Sn5fD_Tso1Mq3ZglBgJ1H7AwEdmYkHjPaBIhkvXHYOTQAGaXP4FJyDEOPGBKJH6x6fwDdXDdp:1vCc1F:d3R-cn4gkbRob6UuqeI2rkbGB3BVsHKetGglROcAmc4', '2025-11-08 11:01:09.441395'),
('hhyhyjn0qo5uzdel56gwvhix42wnmbgz', '.eJzdV9uOmzAQ_ZWIZxThK2Ef-94vaFfIgEnocom4VFqt9t_rG7FZIGlWaVX6QmKP7ZlzPGdg3ryYDf0pHjrexkXmPXmQer47mbD0hdfSkv1g9bHZp03dt0Wyl0v2xtrtvzYZL7-YtZMDTqw7id0hyVmSBwSEEAEMGECBmAhpRBkGmEU0yhMSZQGKApQTDAiiKcUEZCELgpzKqCpWsyOveN3Hfcu59_TtzZMx10NZ-l7NKjHlfR8CsU0-YS6faSqfCOzkD4uUGasBQo5d_YdM7xa-2qaUp3XDWUBgWVXUYvLUlFlRH7uLZzB1G-rTPzrHVPnOlVeoFiEVIQZ2m57HdGcBYGhPcoMyYcSaj1YYcpb2TVtwGxmcRKZxG9fKKeSuUx3GznIw8rHTvP0tZBrHq4Ms42fW9vLOLTYywQYPFg_CO_ei_33AFp6DWdok2iXrsy9yMlliZZqLCM6Sf5Go7bKnGFL6_Fl0jeSNV-eyeRWF4fndX1LBbU7g_8zJhRV6TT9wO2jHym-Q68GKOtAj1LEhblQmzAWBHyGIDdNwIQJcFYENV8eHwZ8p2dH0OoBLk_J7cNh1IZvBQYe4on5bBoNP-8kdP2tVRtK6UlzMBxex12schtvJod_-LgF4AbsJiMywm_zSAwMVWCI2xtDdqvAXJmN0TSyHezLLzWhd5oysN0Hojfe4Izf0iQ5kCgt-eJvOewnyoF4C3kHgWow3pWj48b10aFuZW4ud3GgcWynbRo6W0c_c4uTt3DhJ3gV70cVpU1VF38sGNmdlx51QOStjexfvvwDTaqbV:1vNluS:k6Mlsoij3ftV0x6g5QQ1G2ke0OB8pQttExIUltSE-KE', '2025-12-09 05:48:16.182092'),
('hsr10jimr7ki4097uagoinyzzjc1x1qn', '.eJzVU8tugzAQ_JXIZ4TiBzbpsff2B9rIMsYOtGAqYw5VlH9vjE0xbZRjpQrJwM7uzuzAngEXk2v4NCrL2xo8AMRAlgYrId-V8Uj9JsxpyOVgnG2r3KfkER3zp6FW3WPM3TRoxNj4akjKSlOMmGZ7iAmkGhVQ6GpfMEbLQ8EgLgWhUEop2EHVVOKiLIhkDEGk1bVpL4w4qV4Zx51VCjy8nIHXbKauy4AR_TUEXqc9JYU_kfanlP7EcOdv4jDDZH7BOMHnZyRC9ZXLDp3v9jwYz9wMXd2a0_hNCbd8LLT9yUroTKpnOjQn4VkagWtZiBO6W5UTtHZK1IQ5tZBusK1axdCNmDhjscqIY7HEgihmloFUKiNJDXWLNbtg4Z_OWqsPYZ3_4on15Ma4UUPxa9ygPr7E6eA6-_8yJfGDh2WwEfP23EA5AscMjFO1NfJ4iVcG5GStL7hHsOTELeBxAZZw-CE_efwVl3DSavlsC7QRxNcVXvB25HLo-9Y5v-XOTioRqkR3R-3lC5-TgO0:1vK9Sk:TK_H-YIDXCT2fkhZtPN0Osahfx3tAJOxphPqXsss42k', '2025-11-29 06:08:42.311922'),
('ia4d1jh77i9y0zpbnfrzg8qyr5b59u9m', '.eJzNU0tuwyAUvIrFOrL4U7LsvidoK-sZQ5wmsStsryLfvQbc4qhRl1U2T3hmmBmQuaIKprGtpsH66tigPaIS7bZgDeZku8A0H9Ad-tL03eiPdRkk5coO5Uvf2PPzqr0xaGFol91KOKgdFkRRRjgBwvACKKklcMJBS-1qoRvMNGZOcCKYNJIL0ijA2MnQKtr5_myHavTWov0VvU1YchUnD5O6MI2JiAwTXBGJKGIiEiRvSziXUcQTTbMTF98poDc20YDarUGyTFkQRSytC1L8X0v6lJsxvkY_evVXlLmtP0vxt2da_oNcMZ1G2bz-qR4_6Nbszv38Ft1JLP4AH_xq3-d53iEzeW-7MT6d8I7tJ_jxEpALdHCwHs1fF8Qpig:1vFpnO:uNZcqc3PkeVAUFheYcWysDZMp-7FEqtSsZG4qKpG0Y4', '2025-11-17 08:20:10.117370'),
('ickuioeo1eh6yrikwjmyh7jiks9hg1st', '.eJzdV9uOmzAQ_RXEM4rwlbCPfe8XtCtkwCR0uURcKq1W--_1jdhsIGlWaVX6QmKP7TnneGZg3vyEjcMxGXveJWXuP_mQ-oE7mbLshTfSkv9gzaHdZW0zdGW6k0t2xtrvvrY5r76YtbMDjqw_it0RKVhahAREEAEMGEChmIhoTBkGmMU0LlIS5yGKQ1QQDAiiGcUE5BELw4JKVDVr2IHXvBmSoePcf_r25kvMzVhVgd-wWkz538dQbJNPWMhnlsknAp78YbEyYzVAyLGr_5Dp3cJX11bytH48CQosr8tGTB7bKi-bQ3_2DOZuI336R-eYKt-F8grVIqQQYmC36XlMPUsAQ3uSC8rASLQenTAULBvaruQWGZwh07yNa-UUctephuFZDSY9PK3b32Kmebw6zHJ-Yt0g79xyIzNucG_5IOy5F_3vE7b0HM7SJtkuWZ8DEZPpkirzWETwIvgXhdquekohXp-q9lXUguf3YCnwb8sA_wcZVJn6WfatDB9Hk7Mq9FrKwO2wnYq9Ya4HKwmBHpEQG9JmJSHwIxJiwzKchQBXk8DC1fgw-DNVOp5fB3BlUn73jrouZTPYa4gr2W_LYPhpP4XjZ63KSFlXiov5xiL2eo3DaDsx9NufIgAvcDeAyAV3E196YKgCK8TGFLo7K4KFyQRdS5b9PZHlRrQucyatNyHojfe4k27oE03HnBb88Da9bB_Ig9oHeIeAaxhvpqLRJ_CzsetkbC02b5Nx6p5s5zhZJj-XFiduL42z4F2wl32StXVdDoPsWQtW9dyBylmV2Lt4_wU_yKID:1vYLUX:9USTeD5Dn8oGusypic3ady3R8-P5PCysgVjMVQcyy9s', '2026-01-07 09:49:13.578197'),
('iwztlo4vp75gtdtwtlfot01di5po7g3x', '.eJzVVdtunDAQ_ZWVn9FqfWfz2Pf0B9rIMsbskoIdGagURfn3rC8Ek9BUSatUFZLBM-OZc47H5gEIOY1nMQ3aibYGVwBxUOTGSqof2nhPfSvNye6VNaNrq70P2SfvsL-2te6-pNhVgrMczn41JGXVMIx4ww8QE8gaRKFsqgPlnJVHyiEuJWFQKSX5UddMYVpSojhHEDX6krSXRp50r80oRqc1uPr2ADxmM3VdAYzsLybwfTowQv2IGj8q5UcMd_4lj8FNwgTjzB--kYyrL7Wc7Xy2r9b4ymfb1a05Dc8l4boej2lfViUsFG1CORSCcIBG4LIs2gnbLcgJWjJlaCLPRqrRulYvYNgKTOJIFxiJFs8kSGACDKRzGFloXDdLs4sSfirXWt9JN_odz6QnG3QTBvqKbkSfJokdXLj_X6Jkeoh4GFzyeXk2vAKBmwIMU7UW8ubRP0XUE3-gldcaoN92KN3Yso-ojd6h9tsYNztrfapRuUDDZAf_sFP-Hva04XHyanM3TwlGS6l0F76gh7aM_55zaOxhutPuZztYB2LrhqcAanLOd_tbp2OOSVe4SLf3bI69ei_SPTqbs1SzmrNrJbhY_j-zvx2Esn3fjqP_RY1u0hlQLbtfo72c1scn7DtNNQ:1vNlaW:6KFUVOpnqGsg3sqw1amHo08t4cjW7NvnVYI2I4smFIo', '2025-12-09 05:27:40.173158'),
('kd5c179wu3hgu4gyw3660ybs5qmfmn3q', '.eJzdVl1PgzAU_Sukz2ShHxTx0Xd_gRpygbKhUJYCJovxv9tSGMXhV7IYZ5Z0W0_bc8_pvbl9QQn03S7pW6GSMkfXiHDku5MpZE9CGiR_BLltNlkjO1WmG7NkM6Lt5rbJRXUzrl0csIN2p3dHYQFpEYQ4IhQzDJgGeiLiMQeGGcQ8LtIwzgMaB7QIGQ4pzzgLcR5BEBTcRFWDhK2oheySTgmBru9ekIlZ9lXlIwm1nkL3faC3mZEUZswyM1LsmS-IB5gNfyh18OE3Abtbc6mmMqe1_V5LgLwupZ7cNVVeym17ZMZL2sie_p6c8YG7GFjJsIgOETI8b7PzjHuzAEbmk5ygrNwCsq5RpZiDIYtgrNSRbeAhwuWxzN4se7LAs1b9qphc7EF15mZnOeFCDrmaJVDmudf55zU68hKbw0pjbZ-uyV6mFCUnObzqxOXaY5TbMnsu28YYI-p91Rx0fT-8-muZ_bUn5D944thwNIJ_VhPkcgROdf9BDdBz1MAF2fH-vsfbZudI-wu2wX78tZz4XjxLJeTLDhqeqYOSH3j2UYxjeAenYyxLZfTHR1mvlGktq0-WCRyfLsn8XpqQiecUcdrWKbgo3SP--gatcgqD:1vGuVK:iIE75K9qPHqZNJ6trMQ7mUAeViDUswYThfwyKHZJ8_g', '2025-11-20 07:33:58.152885'),
('knw9fc1qzt0mab6bexb97hzen0kns4yj', '.eJzdV9uOmzAQ_ZWIZxThK2Ef-94vaFfIgElouUQGKq1W--_1jbVJCNusoqr0hcQztuec4xlfXoOUjcMpHXsu0qoIngJIg9A3Ziz_yVvlKX6w9tjt864dRJXtVZe99fb7r13B6y-272yCE-tPcnRMSpaVEQExRAADBlAkDTFNKMMAs4QmZUaSIkJJhEqCAUE0p5iAImZRVFKFqmEtO_KGt0M6CM6Dp2-vgcLcjnUdBi1rpCn4PkZymPrCUn3zXH0R2Kkflmg31g2EPL_-D5kZLWOJrlaz9eNZUmBFU7XSeOrqomqP_XtkMA8bm9kvg2OqY5c6KtSdkEaIgRtm7JjuHAEM3Uw-KAsjNXoI6ShZPnSi4g4ZnCEzvG1oHRRyP6iBsXMaTHrsjG5_i5nh8eIxK_iZiUGtueNGZtzgwfFBeOcv9L9P2NHzOCufYrvkfQ5lTmZLqsxzEcGr5F8UarvqaYV0ff6q-k7pxptz3b3IjeH5LVyqgo81gf-DJp4M70LQtZKB2yE4bfaWrGncKAj0iILYkDaXi2-XHj-iBjYsw80qsJcB4nDY8z_eDtk_PjMBXuBuAZEr7oaKbViqwAmxMYXuPmTDBWOK1s7ewz2ZhQ9OMVOPCG9H0NVzd1Zu6BO34zkteLHtX99zyYPuufAOAW9h_LAUrT5hkI9CqNxaS9Cpz3Tbt3e8yTzFsvvaZPam0s85gL2pZtmbuqfT5K_6NO-aphoG9boaxMg9qJzVK3jffgMG7D41:1vKCm6:Ob2UhsdbHUhaZ-hWbbUIC3KH_rUrKITmGA2byTAD-XQ', '2025-11-29 09:40:54.849644'),
('ld9bnlseeayqtnhx0mo77tyqkhdaqq2i', '.eJzVU8tugzAQ_JXIZ4TiBzbpsff2B9rIMsYOtGAqYw5VlH9vjE0xbZRjpQrJwM7uzuzAngEXk2v4NCrL2xo8AMRAlgYrId-V8Uj9JsxpyOVgnG2r3KfkER3zp6FW3WPM3TRoxNj4akjKSlOMmGZ7iAmkGhVQ6GpfMEbLQ8EgLgWhUEop2EHVVOKiLIhkDEGk1bVpL4w4qV4Zx51VCjy8nIHXbKauy4AR_TUEXqc9JYU_kfanlP7EcOdv4jDDZH7BOMHnZyRC9ZXLDp3v9jwYz9wMXd2a0_hNCbd8LLT9yUroTKpnOjQn4VkagWtZiBO6W5UTtHZK1IQ5tZBusK1axdCNmDhjscqIY7HEgihmloFUKiNJDXWLNbtg4Z_OWqsPYZ3_4on15Ma4UUPxa9ygPr7E6eA6-_8yJfGDh2WwEfP23EA5AscMjFO1NfJ4iVcG5GStL7hHsOTELeBxAZZw-CE_efwVl3DSavlsC7QRxNcVXvB25HLo-9Y5v-XOTioRqkR3R-3lC5-TgO0:1vKB7d:p0TXmZClpwT59sYpNqfXftGqeTGHPjVm34wnmJiFw_8', '2025-11-29 07:55:01.636543'),
('ljl93hgci85oddavl8mwm1tx49rukg0z', '.eJzdVttunDAQ_RXkZ7TCV0oe-94vSCo0gNmlBbMyUCmK8u_1jWDSTdJKq6pbIZndsT1nzvEM4ydUwjKfymWSuuwadIeIQGlsrKD-LpWdab6BOo6HelSz7qqDXXIIs9Phy9jI_nNYu3Nwgulkdue8harNOM4JxQwDppkx5KIQwDCDQhRtxYsmo0VGW84wp6IWjOMmhyxrhY1qAAVHOUg1l7OWEt3dPyEbs1r6PkUKBmNCD0tmttmRtHasaztSnNgXFG6auT-URvPuNwG_22DpsbfepuVsKEAzdMoYT2PfdOo4vSDjPWzuvb8GZ8Jhtw6VuEXURcjwts3bmUg2AoxsnqKgPN0W6nnUndyCIbtgPNWA5nCIjHE8crLRXiVIvFR_lUwjz6Bne7IbHb6jQz5tFChL4uP85zlG9Eqfw9rMTUt1ifY-pSj5JYcvKnG78ljmvsx-dNNohZHDuR8fTX1_fU4vZfbHmpD_QZNIhhchxHs1QW6H4Fr3b9QAvUYN3JAcr887nDa7RtrfsAz-SS_lxO_Fs2dCPuyg_EodlPyBZm_FGMJ7jDrGvlSCPimqF61ta3mv2axrwg2mDJ1mNa9Y4WO7miNX7m7II0-70i3Xa9jzT2oSCQU:1vGtT5:9-oBK_Qvkv6vnGei_VPgZaUeKww5f6R-JSnitIDjpdw', '2025-11-20 06:27:35.701961'),
('m1onufqm2hrehnmwd7ood3vd1wf0c795', '.eJxVjDsOwyAQBe9CHSE-hjUp0_sMCFgITiKQjF1FubuN5MLpRm9G70us29ZstxYXOyO5E8nJ7Tp6F96xdIMvV56VhlrWZfa0J_S0jU4V4-dxtn8H2bXcf1EoBsCU0EkDgEgRkGmepEBQBkc2ouScqQN4VMYHrdMBAwQzQELy2wHNCjbR:1vE2Wy:j-3AKADgZk9I7jrI7TkxQmKjgIiybWmnanOOLBeCqaU', '2025-11-12 09:31:48.697842'),
('pklvcf9zvuknhfk9xswowerxis6olshk', '.eJxVjssOwiAURP-FtSHc8gou3fsN5AIXW63Q0HZhjP9um3Sh2zMzJ_NmHtel9-tMzQ-JnVln2OkXBowPKnuS7lhulcdaljYEvlf4kc78WhONl6P7J-hx7re11RlDFhpsJ0EBghQbsMYZVKDQGZeDdklIJ2TWCrQ00SgNyaIQ2eyv4toalcW3OtJmpOc01hcR-3wB9UlAPg:1vFQPY:MCvU3YeKe_MqPYBVFlBM3dy5Hp8jKAl4CTdgUf9ks6Y', '2025-11-16 05:13:52.774588'),
('rdlitmemm1q3pvb7nd3u3scdmexhcf4j', '.eJzdV9uOmzAQ_ZWIZxThCybsY9_7Be0KGbATuoAjLpVWq_334gux2QBpVmlV-uLEM7bnnOMZY795Ce27U9K3rEmK3HvyIPF815jS7IXV0pP_oPVR7DNRd02R7uWQvfG2-68iZ-UXM3aywIm2p2F2FHKa8iAEEUQAAwpQMBgiEhOKAaYxiXkaxnmA4gDxEIMQkYzgEOQRDQJOJKqK1vTIKlZ3Sdcw5j19e_Mk5rovS9-raTWYvO99MEyTLeSyzTLZIrCTPzRWbqw6CDl-9R9SPXuI1YhSrtb254ECzauiHownUeZFfWwvkcE0bKRX_xgcExWbq6hQDUIKIQZ2mrZjsrMEMLQruaAMjETr0QwOTrNONAWzyOAEmeZtQqugkLlBNYyd1WDUY6d1-1vMNI9Xh1nOzrTp5J5bbuGEGzxYPgjv3I3-9wlbeg5n6ZNs57zP_pCT6Zwq01xE8Cr5Z4XarnpKIVWfP4tWSN1YdS7F63AwPL_7c1VwWxP4P2tyUYWs1Q_cDtvx5DfMdWehOtAjqmND2qhMuC4I_IiC2LAMFyHAahFYuBofBn_myI6n2wFcmVTcg6OuS9l0DhriQvXbYzD4dBzuxFk6ZaSsC4eLuXCFdntNwGg7OfTb9xKAZ7gbQOEVd5NfumOoAivExhS6uyr8GWOC1orlcE9muRmtjzlT1psQ9MZ33Ck39IkXyJQW_PA1vX5LhA96S8A7BFzCeLMUjT6-l_VNI3NrLUHHMeOLytyjR_MYy1wlR7OzlHoyA-IsNcnexD5PR3_RJpmoqqLr5AuW07JlDlZGy1XAXIg86WhzZFN04P0X_Xa1bA:1vRlUM:UXu1X5eTIQMKCppRUZ7JgTS_urUjhwMQGjS1sZ20ihA', '2025-12-20 06:09:50.391762'),
('rg4x0fhr9s9p59r8dklvknhn6dtqpuil', '.eJzdVttuozAQ_RXkZxThC2bp4773C9oKDWASdsFEBipVVf-9NraLSdPtrhRVmyqSk8zYPnOOZzx-RgXM06GYR6GKtkY3iHAUh8YSqt9CGk_9C-R-2FWDnFRb7syUnfOOu9uhFt1PN3ezwQHGg16dpQ2UTZLijFDMMGCaaEPGcw4MM8h53pRpXic0T2iTMpxSXnGW4jqDJGm4iaoHCXvRCzkVkxIC3dw9IxOznLsuRhJ6bUL3c6KXmZE0ZqwqM1IcmS_IFzdb_lAa-JffBOxqjaWGzuw2zkdNAeq-ldp4GLq6lfvxDRlvYTO7-yk44wt2s6CSZRJdImR4XWbtjEcrAUbWncKgXBiF1UNpRwPVNKhWrJGRTWSWt4NeQIkIQW0Y0aqB1yOyun0VM8vjKWBWiyOoyZz5yi3dcCM_Vj6UReFB__-EV3oB53Euz9HeJhsl77L7rBLXK49hbgvwsR0HI4zoj93wpCv_4SU-l-afa0K-gyaBDG9C8D_VBLkegv42_6AG6CVq4IrkOD1vd9rsEml_xTLYT3wuJ_4uni0TcpJ879tpeqF2Sv5Bs49i_LRLOn1iVM1KmdYSPmb8Xep9_jHhOow3ewx3yXpz0K-cLN6zKVj7lMTo5RXA-Q3S:1vHxkv:3j9CpbHJUCzCXS6EQFCGJWDSZyvRHPByd0YPG7P3aY4', '2025-11-23 05:14:25.668055'),
('rj1ot8yot27nwecud96fddy4ser1d30i', '.eJytUstugzAQ_JXI5whhYyDk1qqXHKJKVW9thRbbBFowkYFDFeXf60cSTMspKkiL2VnvzD5OKIdxqPKxFyqvOdoijNa-rwD2JaQB-CfIQxewTg6qLgITElzQPth3XDSPl9hZggr6yqQtQ56SLExLIAXDacFZgsNM6AdzQaGI9aFgCYvjVLAojkiKk7jc4KwkwCHTSVuQcBCtkEM-KCHQ9u2EjGQ5Ns0aSWi1C72PYUJjY0lpLGPGRnhlPpBZmNqfKPJweybgbmsu1TUmWz8edQnA21pqZwls6FQtek39cV47djynTh3DbwE0sfylZSY2KLIqKZ6uOT9NVlMRlEyZPGGuZF_Pkpj_4uHiCGowjZ-Y6I1p__y0e9k9vE5dm-JzNzOlsX4s5nluHSQLw3P9ckLJxpaRrXzt3tQ8D2N3q1ico2OmXqMiT94Fzu5ltu8asVEpE7u4c1ew6hpey0M-LfwVcVvwvYB4Ov6CMz03_PwDN2NNXQ:1vGbFo:R_MZ42tNftOOKMMollTnhqW_kEyDydG8eUAyfeqgyxw', '2025-11-19 11:00:40.523945'),
('s4ldhrsnrpoiir8w4kmzs5g1t0kvoshf', '.eJzdV9uOmzAQ_ZWIZxThK2Ef-94vaFfIgEnocom4VFqt9t_rG7HZAGlWaVX6QuIZ7DnneGaw37yYDf0pHjrexkXmPXmQer5rTFj6wmvpyX6w-tjs06bu2yLZy1f2xtvtvzYZL7-YdycLnFh3ErNDkrMkDwgIIQIYMIACYQhpRBkGmEU0yhMSZQGKApQTDAiiKcUEZCELgpxKVBWr2ZFXvO7jvuXce_r25knM9VCWvlezSpi870MgpsknzOUzTeUTgZ38YZFyYzVAyPGr_5Dp2SJW25RytW44Cwosq4paGE9NmRX1sbtEBtOwoV79Y3BMVexcRYXqJaQQYmCnaTumO0sAQ7uSC8rAiLUerXDkLO2btuAWGZwg07xNaBUUcjeohrGzGox67LRuf4uZ5vHqMMv4mbW93HPLjUy4wYPlg_DO3eh_n7Cl53CWPsl2zvvsi5xM5lSZ5iKCV8k_K9R21VMK8epcNq-iFzy_-3OJf1sG-D_IoNrUz6JrZPo4mlxUoWslA7fDdmz2hrkeLBQEekRBbEibhYLAjyiIDctwEQKsFoGFq_Fh8Ge6dDTdDuDKpOIeHHVdymZw0BAXqt-2weDTcXInzlKXkbIuNBdzxiJ2e03AcDs59NtHEYBnuBtA5Iq7yS89MFSBFWJjCt1dFf6MMUZrxXK4J7PcjNZtzpT1JgS98R13yg194tIxpQU_fE2vrw_kQdcHeIeASxhvlqLRx_fSoW1lbq0l6PjOeIkyR-fRPMYyR8nR7CylbsmAOktNsje2N9LRX3Rx2lRV0ffy0pqzsuMOVs7KFcDvvwB3H6au:1vWrk8:ldEk7U2oGHbmOFowFIJJZun3PiG5tGJQmfocmrOgWyA', '2026-01-03 07:51:12.822227'),
('t5zjvwx0v89yp04l9uj3poj3zounghlu', '.eJzdV9uOmzAQ_ZWIZxThK2Ef-94vaFfIgEnocom4VFqt9t_rG7FZIGlWaVX6QmKP7ZlzPGdg3ryYDf0pHjrexkXmPXmQer47mbD0hdfSkv1g9bHZp03dt0Wyl0v2xtrtvzYZL7-YtZMDTqw7id0hyVmSBwSEEAEMGECBmAhpRBkGmEU0yhMSZQGKApQTDAiiKcUEZCELgpzKqCpWsyOveN3Hfcu59_TtzZMx10NZ-l7NKjHlfR8CsU0-YS6faSqfCOzkD4uUGasBQo5d_YdM7xa-2qaUp3XDWUBgWVXUYvLUlFlRH7uLZzB1G-rTPzrHVPnOlVeoFiEVIQZ2m57HdGcBYGhPcoMyYcSaj1YYcpb2TVtwGxmcRKZxG9fKKeSuUx3GznIw8rHTvP0tZBrHq4Ms42fW9vLOLTYywQYPFg_CO_ei_33AFp6DWdok2iXrsy9yMlliZZqLCM6Sf5Go7bKnGFL6_Fl0jeSNV-eyeRWF4fndX1LBbU7g_8zJhRV6TT9wO2jHym-Q68GKOtAj1LEhblQmzAWBHyGIDdNwIQJcFYENV8eHwZ8p2dH0OoBLk_J7cNh1IZvBQYe4on5bBoNP-8kdP2tVRtK6UlzMBxex12schtvJod_-LgF4AbsJiMywm_zSAwMVWCI2xtDdqvAXJmN0TSyHezLLzWhd5oysN0Hojfe4Izf0iQ5kCgt-eJvOewnyoF4C3kHgWow3pWj48b10aFuZW4ud3GgcWynbRo6W0c_c4uTt3DhJ3gV70cVpU1VF38sGNmdlx51QOStjexfvvwDTaqbV:1vSrMZ:M_gb9GxiUJMzUFo55yDgavzgwLE9Bmvn5RX59rPgcpM', '2025-12-23 06:38:19.413596'),
('tdzxri2mxx4h8z7dh4gq8s0jmrp7108i', '.eJzdV9uOmzAQ_ZWIZxThCybsY9_7Be0KGbATuoAjLpVWq_334gux2QBpVmlV-uLEM7bnnOMZY795Ce27U9K3rEmK3HvyIPF815jS7IXV0pP_oPVR7DNRd02R7uWQvfG2-68iZ-UXM3aywIm2p2F2FHKa8iAEEUQAAwpQMBgiEhOKAaYxiXkaxnmA4gDxEIMQkYzgEOQRDQJOJKqK1vTIKlZ3Sdcw5j19e_Mk5rovS9-raTWYvO99MEyTLeSyzTLZIrCTPzRWbqw6CDl-9R9SPXuI1YhSrtb254ECzauiHownUeZFfWwvkcE0bKRX_xgcExWbq6hQDUIKIQZ2mrZjsrMEMLQruaAMjETr0QwOTrNONAWzyOAEmeZtQqugkLlBNYyd1WDUY6d1-1vMNI9Xh1nOzrTp5J5bbuGEGzxYPgjv3I3-9wlbeg5n6ZNs57zP_pCT6Zwq01xE8Cr5Z4XarnpKIVWfP4tWSN1YdS7F63AwPL_7c1VwWxP4P2tyUYWs1Q_cDtvx5DfMdWehOtAjqmND2qhMuC4I_IiC2LAMFyHAahFYuBofBn_myI6n2wFcmVTcg6OuS9l0DhriQvXbYzD4dBzuxFk6ZaSsC4eLuXCFdntNwGg7OfTb9xKAZ7gbQOEVd5NfumOoAivExhS6uyr8GWOC1orlcE9muRmtjzlT1psQ9MZ33Ck39IkXyJQW_PA1vX5LhA96S8A7BFzCeLMUjT6-l_VNI3NrLUHHMeOLytyjR_MYy1wlR7OzlHoyA-IsNcnexD5PR3_RJpmoqqLr5AuW07JlDlZGy1XAXIg86WhzZFN04P0X_Xa1bA:1vPF5R:_QoFMJsysYS-ae8P0Gie2AnDOurNInfFpSO4SThEQUM', '2025-12-13 07:09:41.841080'),
('w3dt8ueabvczz4dhhh7ql98csgcdb0wr', '.eJzdV9uOmzAQ_RXEM4rwBRP2se_7Be0KOWAndAFHXCqtVvvvxRdikxDSrNKq7IsTz9iec45njP3up7TvDmnfsiYtcv_Jh8QPXOOOZq-slp78J633YpOJumuK3UYO2Rhvu3kWOSu_mbGTBQ60PQyz44jTHQ8jEEMEMKAAhYMhJgmhGGCakITvoiQPURIiHmEQIZIRHIE8pmHIiURV0ZruWcXqLu0axvyn7---xFz3ZRn4Na0Gk_-jD4dpsoVctlkmWwQ8-UMT5caqg5DjV_8h1bOHWI0o5Wptfxwo0Lwq6sF4EGVe1Pv2FBlMw8Z69fPgmKjYXEWFahBSCDGw07QdE88SwNCu5IIyMFKtRzM4OM060RTMIoMTZJq3Ca2CQuYG1TA8q8Goh6d1-1fMNI83h1nOjrTp5J5bbtGEG9xaPgh77kb__4QtPYez9Em2c96XYMjJ3Zwq01xE8CL5Z4Var3pKIVWfv4pWSN1YdSzF23AwvHwEc1VwWxP4lTU5qUKW6geuh-148hvmunOlOtAjqmNF2qhMuCwI_IiCWLEMJyHAYhFYuBofBn_nyE6m2wFcmVTcraOuS9l0thrileq3x2D46TjciXPtlJGyXjlczIUrsttrAsbryaE_vpcAPMPdAIouuJv80h1DFVghVqbQ3VURzBhTtFQs23syy81ofcyZsl6FoDe-4065oU-8QKa04NnX9PItET3oLQHvEPAaxpulaPQJ_KxvGplbSwk6jhlfVOYePZrHWOYqOZqdpdSTGRBnqUn2pvZ5OvqLNs1EVRVdJ1-wnJYtc7AyWi4C5kLkaUebPTtD9_Eb_Xi1bQ:1vOYf3:sOd4XnQxsFAg83l5Ets5FA3c_ipH2WyjtcnQHBNbSg4', '2025-12-11 09:51:37.689512'),
('xbfjhofcaqie7ytz2mc86gqpo0dchq3l', '.eJx9kMFuwyAMhl9l4lxFIRBIetx9T7BVkQGnyUagAnKYqr77QpZqmVbtYsCff_s3V9LBnIZujhi60ZAjYZIc9kkF-gNdJuYd3NkX2rsURlXkkmKjsXjxBu3zVvurwQBxWNRUVgJRlkLQthRUC6ha3vScomwUk7ypm5YKyaUqK4aUKVlC3UvDUdSoJCxNJ3Bwxgld6lJAJMfXK8me3WztgTiYlhR5m0vB6xyrPketc2T0KR_QrpivD8Z2fL1X8K1eZgVvc7c4X5YVwEyjW5KDt2Z057hMPt1OB6LnELKbh8V3uIm6H6d30oNOPnw-IAYvENK66V8YZ_UvH2On_TSNKeU_6sFG3FlFsJvfrLp9Acjurrs:1vZOUI:GuXx6kL7gvmnF8gqYszJ4beGi96uncxYNX-wUufLpHU', '2026-01-10 07:13:18.630111'),
('yysp8nqvruzmrr0mhazummcuk7zcnfmq', '.eJzdVttuozAQ_RXkZxThK0sf971f0F2hAUxCCyYysFJV9d_XFygmTW9StGpWSCYZ2zPnHM8wfkI5TOMhnwap86ZCN4gIFIfGAsoHqexMdQ9q3-_KXo26KXZ2yW6eHXa3fSXbn_PajYMDDAezO-U1FHXCcUooZhgwTYwhFZkAhhlkIqsLnlUJzRJac4Y5FaVgHFcpJEktLKoOFOxlJ9WYj1pKdHP3hCxmNbVtjBR0xoR-TYnZZkdS27Es7UhxZF-QuWnm_lAazLvfBPxuE0v3rfU2TEdDAaquUcZ46NuqUfvhJTLehk2999PgTLjYtYtK3CLqEDK8bvN2JqKVACOrpxDUDCP3emgzUUM59rqRKzKyQeZ5z6FdUCLDoB5GtGqw6BF53f4VM8_jMWBWySPo0Z75yo1vuJEfKx_KovCgvz_hlV7AeZiKc7S3yUbJq-w-q8T1ymOZ-wL80wy9FUZ2x7Z_NJX_-zk-l-Yfa0L-B00CGV6EEO_VBLkegsvX_I0aoJeogSuS4_S859Nml0j7K5bBP_G5nPgcni0TcpJ8r9spv1A7JV_Q7C2MH3bJWZ8YlZPWtrW812yWNculYu40i3mJNX9sF3Pgyt0aeeBpU7r5ckF7_gtyUBJo:1vILWb:lupWzbrKE4fEwbWrX2MQQGZgrDIJbJ1mwOA9j9Xh0kI', '2025-11-24 06:37:13.636420'),
('z2swzo2g3o4vzbr0rssqyt4gtmss6bqq', '.eJztWU1v4zYQ_SuqTy1gGBJJyXJu7b3HntrAYGQpceuPwB8FFov975XEoflGpCx5kW3rbLCA1xZFcubNzJtH5vNkqc-nl-X5WB6W69XkYSKyyRQfPunir3LXjKz-1Lvn_azY706H9dOseWVGo8fZr_tVufmF3mULvOjjSz17nlb6qYrTZC5kohKdyLh-MM8WmVaJ0otsUT2li1UsF7GsUpWkMisylSaruY7jKmus2uqdfi635e60PB3KcvLw--dJY_PuvNlMJzu9rR9N_jjH9bTmU1TNZ1E0nzKJmv_0oh1W7Q8pYbz9LrSZXe912G-a1Y7n19oFvdqud_XDl_1mtd49Hy87J3zbuVm9u7nK2r2rdlfRviRbC1XippnnKoucA0q4ldAoMmNp8DjUA5UuTvvDunSWCWaZ8Zu2bjcVJW5qzIgcBhaPyOD2b3lm_PgEnq3KV304NTF3vqXMN5E7f6SKMND_f4ede-BzM9Z4Gxp9nNY5-RRCheeiFF7yB4G6X_RahNr6_Ht93De4ldvXzf5TTQyPX6ahKhjGRLxnTC6oZNfqR9yPt5b5yXPzo6c65FtUxx1h02aCXxDqLQrijmHorQJSBqmzg8TA_H6cHd1AExXwnQxKPd-NK_SDXE0cEHeG0M0ddxp4uJTXGnF-S2ap3CFm6lGq-wF0oOFAucmvkMrcLdGhfV_0pm8kesUNAPbZOFiKhM90UpwPhya3riWofcdKfxJ89rHdizSPfQxLtWe7FFZiybt0xyg7vj4ui_12uz6dmpNWpTfHEkwt9ea6vS-6NnZ9bKxqw9OcGutXbOORAK2BOW3hzFts5bxbGUVRL3rcnw9Fs-Vv9bly0iQWrLqr__Ws3HzGReQywKxsuppKZzBi4mwmihUsYuoz_wHN-Pl4rD3U9f4dW7oLVVjvUF9F4VEAmVbBMNFFDq2Y1soxh6UCtlFY3XC2TaqROFoDfRowxmbwfYEAYrkVaAVJCcDFFBLRHa1OHs3G4kwWzr3F0WvGZmSbCYPh4xzspIJWEVrYtdlGJjdMYLAYiayxWC9usFj6ufQQRYHlBnoN-ZZ2X2q-izgunDdWEzqXWRILyFiWyixtIKJ2WCDEbtMhnCuzXdTj8C0cD1VCZiooH1HNMGcXLte5mwLCw_I7dPXkBZReKiFA7e7q9qOmoQMgDRstzAd8FyNEbxG8eAXmxdcYKCG_FMbPJzUqLUZkfVnTfxN3fQsom3np1mZtegHWt6PUCVgMKIIQIhm7YVYMc0zknPgbaJz1jspzz0YVHYAOQ7NpeOX5ZJJMYmrAfgW61sy4FPUCJrA0maHUSQGGtJtxhNtA-WHRk_u01MoFgpV1P_lhhpCvLJGNCRWM59YZ6zjLF05t4AADBluJjRPuQVUbuaxD_y2va1cuLIChbftL1QuOD7iNeeY8pFKBdLS8k6NsuIigayWWu6hhH4hxVwFQEzBc_iCnMklBkOcQY2NWUfirwL4Eb-IgoQk52s50B2osIHTKV0gZDJe9IPHacF-RXBRd5OLv6DIYeDxLc7rEFETxZU5iEv3WI6KIdDJUYtRkUlyqO0_79vmcc-GZ0cIZBa5EyZlAfiGtk_05CwBKoAqgy9zzd6eFGQLYyAN8yxSXxv5VwPfKm2e74LsEkB0mqBuqriFEwfr6YSLUlnrADEhncSO-yNLt1DhAIUx-lV6x9Hvqc8ut7Vt4aPBs-u87-UDDlspflzn-4IsjTuy-Lf3iAbwLqQO-C7uQDXiMtxjKOwjYmxLswIkDhPXpEGwMBEDyqjoL9xzmIzue5sOPwkp3jEhRQyIlEEe7Pcpm7Kv-HaqByPbsvoxF2UzTcx8odkcvIAwLP2Myb11MO-Mnl2Sov_yzovV8jNzsTXCu5lm2ehKMC1jRhZqlvALm4XoRAsUyk5oO3vb4ORW4y2OnJy7Usm4GWInmK3ufO9kpMMA2IiDgMS54m0BTsCPafo8RAZh6mxYPmN-CB45GoTQTAH_vuTRQjUOnBD8iOasBb8FRfZ6HDc4GAgQlIxd-FefXLdJFDvPMxYPlhnHNZ7TA-Qb37j2rQlb137mHdu3hdZSztk49nJ1gca_6ZNi-yrXVsKoOQeOfNPqMZMWElC2y7hrsz6nWrVFO9EQHs05IiJd3EAwKpoB8gEdGurNCQ72ITcGeMtB7X56SDax1SJdFyNqWVYB2-RXiLPrRzZT-sZh6MhCKTH76XtLiXs5kIXL57jnpK0H5oIJvQgUfKfoBShCUxy__APlXp0s:1vLGlW:gJT9i182j5jsk6h9hH-ncG5LUiObJy-7queH1oAoFR0', '2025-12-02 08:08:42.362993'),
('zpu5jh3tp4snie0r3774x9m4vl7quehd', '.eJzdVttOhDAQ_RXSZ7KhF4r46LtfoIYMUHZRKJsCJhvjv9vSIkXXW7IxriEpuzNtz5zTGaZPKINx2GVjL1RWl-gSEY5C35hD8SCk8ZT3ILfdpujkoOp8Y6ZsnLffXHelaK7c3NUGO-h3enUSV5BXUYwTQjHDgGmkDQlPOTDMIOVplcdpGdE0olXMcEx5wVmMywSiqOImqhYkbEUr5JANSgh0efOETMxybJoQSWi1Cd2OkV5mRlKZsSjMSHFgXpBObjb9odTzT78J2NUaS3WN2a0f95oClG0ttXHXNWUtt_0rMl7DJnb3t-CMT9jVhEqmSXSKkOFlmbUzHiwEGFl28oKydCsohk7VYgmGrIKxVB3ahEOEj2ORg4X2LEFgpfpVMqXYgxrMyS504hUdcrFQoCzwj_PPc_ToZTaHlfb1Y36M9jqlKHmXw0eVOF95DHNbZo913xlhRLtvuoOu77vn8Fhmf60J-Q-aeDK8CsE_qwlyPgTnuv-gBugpauCM5Hh73u602SnS_oxlsE94LCe-F8-aCfmyg8Yn6qDkB5p9FKML7-B1jHWpOH1CVIxKmdbiX1nmb-nsczeXzHWY2TxjuI_sbPb6lZNl9qwK1l4YMXp-ASALBG8:1vHftg:zcEUFo2Nvn8Y2a_Sl-HhKVvxw4V3TNSx9O5Jq4ukhrg', '2025-11-22 10:10:16.142017');

-- --------------------------------------------------------

--
-- Table structure for table `evaluations_employeeevaluation`
--

CREATE TABLE `evaluations_employeeevaluation` (
  `id` bigint(20) NOT NULL,
  `comments` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `criteria_id` bigint(20) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `evaluator_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `evaluations_evaluationcriteria`
--

CREATE TABLE `evaluations_evaluationcriteria` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `weight` double NOT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `evaluations_evaluationscore`
--

CREATE TABLE `evaluations_evaluationscore` (
  `id` bigint(20) NOT NULL,
  `score` double NOT NULL,
  `comments` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `evaluation_id` bigint(20) NOT NULL,
  `scored_by_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_bankaccount`
--

CREATE TABLE `users_bankaccount` (
  `id` bigint(20) NOT NULL,
  `account_number` varchar(10) DEFAULT NULL,
  `card_number` varchar(16) DEFAULT NULL,
  `ir` varchar(2) NOT NULL,
  `sheba_number` varchar(24) DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `bank_id` smallint(5) UNSIGNED DEFAULT NULL,
  `dependent_id` bigint(20) DEFAULT NULL,
  `bank_account_type_id` smallint(5) UNSIGNED DEFAULT NULL
) ;

--
-- Dumping data for table `users_bankaccount`
--

INSERT INTO `users_bankaccount` (`id`, `account_number`, `card_number`, `ir`, `sheba_number`, `employee_id`, `bank_id`, `dependent_id`, `bank_account_type_id`) VALUES
(1, '', NULL, 'ir', NULL, NULL, 5, 8, 2),
(2, '', '', 'ir', NULL, 26, 3, NULL, 2),
(3, '65666666', NULL, 'ir', '44444444444444', 37, 1, NULL, 2),
(4, '55555555', NULL, 'ir', '645654465465654016', NULL, 1, 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_bankaccounttype`
--

CREATE TABLE `users_bankaccounttype` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_bankaccounttype`
--

INSERT INTO `users_bankaccounttype` (`code`, `name`) VALUES
(3, 'بلند مدت'),
(1, 'قرض الحسنه جاری'),
(4, 'قرض الحسنه پس انداز'),
(5, 'نامشخص'),
(2, 'کوتاه مدت');

-- --------------------------------------------------------

--
-- Table structure for table `users_banks`
--

CREATE TABLE `users_banks` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_banks`
--

INSERT INTO `users_banks` (`code`, `name`) VALUES
(19, 'name'),
(1, 'آینده'),
(2, 'اقتصاد نوین'),
(12, 'انصار'),
(35, 'انصارالمجاهدین'),
(3, 'ایران زمین'),
(41, 'بانک خاورمیانه'),
(4, 'تجارت'),
(18, 'توسعه تعاون'),
(5, 'توسعه صادرات'),
(32, 'حکمت ایرانیان'),
(20, 'دی'),
(13, 'رسالت'),
(6, 'رفاه کارگران'),
(21, 'سامان'),
(30, 'سایر'),
(22, 'سرمایه'),
(7, 'سپه'),
(23, 'سینا'),
(14, 'شهر'),
(8, 'صادرات'),
(15, 'صنعت و معدن'),
(24, 'قرض الحسنه مهر ایران'),
(31, 'قوامین'),
(25, 'مالی اعتباری بنیاد'),
(37, 'مرکزی'),
(10, 'مسکن'),
(16, 'ملت'),
(11, 'ملی'),
(36, 'مهراقتصاد'),
(26, 'موسسه مالی و اعتباری عسکریه'),
(38, 'موسسه مالی و اعتباری ملل'),
(39, 'موسسه نور'),
(40, 'نامشخص'),
(27, 'پارسیان'),
(17, 'پاسارگاد'),
(28, 'پست بانک'),
(29, 'کارآفرین'),
(9, 'کشاورزی'),
(33, 'کوثر'),
(34, 'گردشگری');

-- --------------------------------------------------------

--
-- Table structure for table `users_baseinsurance`
--

CREATE TABLE `users_baseinsurance` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_baseinsurance`
--

INSERT INTO `users_baseinsurance` (`code`, `name`) VALUES
(5, 'ایران'),
(38, 'بانک ها'),
(32, 'بیمه سلامت'),
(144, 'تامین اجتماعی'),
(147, 'خدمات درمانی'),
(7, 'دانا'),
(19, 'دی'),
(34671, 'سازمان صدا و سیمای جمهوری اسلامی ایران'),
(33, 'سامانه ایزی مد'),
(28, 'سایر'),
(39, 'شرکت ملی نفتکش'),
(40, 'فاقد بیمه گر پایه'),
(41, 'ملی صنایع مس ایران'),
(145, 'نیروهای مسلح'),
(20, 'هما'),
(42, 'پالایش نفت'),
(146, 'کمیته امداد');

-- --------------------------------------------------------

--
-- Table structure for table `users_contactinfo`
--

CREATE TABLE `users_contactinfo` (
  `id` bigint(20) NOT NULL,
  `phone_number` varchar(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `dependent_id` bigint(20) DEFAULT NULL
) ;

--
-- Dumping data for table `users_contactinfo`
--

INSERT INTO `users_contactinfo` (`id`, `phone_number`, `created_at`, `employee_id`, `dependent_id`) VALUES
(1, '09136304789', '2025-12-24 11:47:45.790872', NULL, 9),
(2, '09136304789', '2025-12-25 05:10:55.221461', 26, NULL),
(4, '9192215634', '2025-12-25 07:05:33.615164', NULL, 10);

-- --------------------------------------------------------

--
-- Table structure for table `users_country`
--

CREATE TABLE `users_country` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_country`
--

INSERT INTO `users_country` (`code`, `name`) VALUES
(892, 'name1'),
(11982, 'آبهای بین المللی'),
(11940, 'آذربایجان شوروی'),
(11920, 'آرژانتین'),
(11971, 'آلبانی'),
(4566, 'آلمان'),
(11965, 'آمریکا'),
(11966, 'آمریکای جنوبی'),
(11964, 'آمریکای شمالی'),
(11912, 'اتریش'),
(11991, 'اتیوپی'),
(11909, 'اردن'),
(11917, 'ارمنستان'),
(11924, 'ازبکستان'),
(11907, 'استرالیا'),
(11983, 'اسلواکی'),
(11990, 'اسلوونی'),
(11943, 'اسپانیا'),
(12004, 'اسکاتلند'),
(11963, 'افریقا'),
(204, 'افغانستان'),
(11967, 'اقیانوسیه'),
(12002, 'الجزایر'),
(11913, 'امارات متحده'),
(11969, 'اندونزی'),
(11901, 'انگلستان'),
(11954, 'اوکراین'),
(11978, 'اکوادور'),
(11914, 'ایتالیا'),
(999, 'ایران'),
(11992, 'ایرلند'),
(11984, 'ایسلند'),
(11950, 'بحرین'),
(11903, 'برزیل'),
(11974, 'بلاروس'),
(11968, 'بلغارستان'),
(11918, 'بلژیک'),
(11959, 'بنگلادش'),
(11946, 'تاجیکستان'),
(11993, 'تانزانیا'),
(11922, 'تایلند'),
(11945, 'تایوان'),
(11942, 'ترکمنستان'),
(11935, 'ترکیه'),
(11988, 'ترینیداد و توباگو'),
(11985, 'تونس'),
(11973, 'جمهوری چک'),
(11994, 'جیبوتی'),
(11947, 'داغستان'),
(11938, 'دانمارک'),
(11925, 'روسیه'),
(11902, 'رومانی'),
(11956, 'سریلانکا'),
(11975, 'سنگاپور'),
(11923, 'سوئد'),
(11937, 'سوئیس'),
(11986, 'سودان'),
(11953, 'سوریه'),
(11998, 'شیلی'),
(4567, 'عراق'),
(11952, 'عربستان'),
(11951, 'عمان'),
(11910, 'فرانسه'),
(11919, 'فنلاند'),
(11906, 'فیلیپین'),
(11981, 'قبرس'),
(11933, 'قرقیزستان'),
(11941, 'قزاقستان'),
(11929, 'قطر'),
(11927, 'لبنان'),
(4569, 'لهستان'),
(11980, 'لوکزامبورگ'),
(11987, 'لیتوانی'),
(11989, 'مالتا'),
(11915, 'مالزی'),
(11961, 'مجارستان'),
(11916, 'مصر'),
(12001, 'مغولستان'),
(11996, 'مقدونیه'),
(12000, 'موزامبیک'),
(11997, 'میانمار'),
(4570, 'نامشخص'),
(11979, 'نروژ'),
(11960, 'نیجریه'),
(11958, 'نیوزیلند'),
(11905, 'هلند'),
(4568, 'هند'),
(11949, 'هندوستان'),
(11957, 'ونزوئلا'),
(11970, 'ویتنام'),
(12003, 'پاراگوئه'),
(11911, 'پاکستان'),
(11972, 'پرتغال'),
(11936, 'چین'),
(11908, 'ژاپن'),
(11999, 'کامرون'),
(11921, 'کانادا'),
(11930, 'کره جنوبی'),
(11932, 'کره شمالی'),
(11995, 'کنیا'),
(11934, 'کویت'),
(11944, 'گرجستان'),
(11977, 'گواتمالا'),
(11976, 'یمن'),
(11926, 'یونان'),
(11939, 'یوگسلاوی');

-- --------------------------------------------------------

--
-- Table structure for table `users_department`
--

CREATE TABLE `users_department` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `factory_id` bigint(20) NOT NULL,
  `manager_id` bigint(20) DEFAULT NULL,
  `is_committee` tinyint(1) NOT NULL,
  `manager_2_id` bigint(20) DEFAULT NULL,
  `manager_3_id` bigint(20) DEFAULT NULL,
  `linked_factory_id` bigint(20) DEFAULT NULL,
  `is_self` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_department`
--

INSERT INTO `users_department` (`id`, `name`, `created_at`, `factory_id`, `manager_id`, `is_committee`, `manager_2_id`, `manager_3_id`, `linked_factory_id`, `is_self`) VALUES
(2, 'منابع انسانی', '2025-09-24 12:06:52.902934', 1, 1, 0, NULL, NULL, NULL, 0),
(5, 'بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:52:04.941219', 2, 26, 0, NULL, NULL, NULL, 0),
(6, 'بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:52:31.435478', 2, NULL, 0, NULL, NULL, NULL, 0),
(7, 'بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:52:41.022956', 3, NULL, 0, NULL, NULL, NULL, 0),
(8, 'بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:52:52.652121', 3, NULL, 0, NULL, NULL, NULL, 0),
(9, 'بخش 1 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:53:19.061750', 4, NULL, 0, NULL, NULL, NULL, 0),
(10, 'بخش 2 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:53:34.878420', 4, NULL, 0, NULL, NULL, NULL, 0),
(11, 'بخش 1 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:53:45.582324', 5, NULL, 0, NULL, NULL, NULL, 0),
(12, 'بخش 2 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:53:51.959645', 5, NULL, 0, NULL, NULL, NULL, 0),
(13, 'بخش تست تولید', '2025-11-01 09:15:56.496842', 1, 33, 0, NULL, NULL, NULL, 0),
(14, 'کیمته سه نفره کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-11-12 10:41:27.000000', 6, 26, 1, 27, 26, 2, 0),
(16, 'بخش سلف', '2025-11-20 10:27:26.000000', 2, 26, 0, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_dependencystatus`
--

CREATE TABLE `users_dependencystatus` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_dependencystatus`
--

INSERT INTO `users_dependencystatus` (`code`, `name`) VALUES
(3, 'بیمه شده اصلی'),
(1, 'تحت تکفل'),
(4, 'سایر'),
(2, 'غیر تحت تکفل');

-- --------------------------------------------------------

--
-- Table structure for table `users_dependent`
--

CREATE TABLE `users_dependent` (
  `id` bigint(20) NOT NULL,
  `national_id` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `father_name` varchar(50) NOT NULL,
  `birth_certificate_number` varchar(50) NOT NULL,
  `birth_date` date NOT NULL,
  `country_id` smallint(5) UNSIGNED NOT NULL,
  `dependency_status_id` smallint(5) UNSIGNED DEFAULT NULL,
  `employee_id` bigint(20) NOT NULL,
  `gender_id` smallint(5) UNSIGNED NOT NULL,
  `marital_status_id` smallint(5) UNSIGNED DEFAULT NULL,
  `relative_type_id` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_dependent`
--

INSERT INTO `users_dependent` (`id`, `national_id`, `first_name`, `last_name`, `father_name`, `birth_certificate_number`, `birth_date`, `country_id`, `dependency_status_id`, `employee_id`, `gender_id`, `marital_status_id`, `relative_type_id`) VALUES
(1, '1000111100', 'qqwwqwq', 'wqwqwqwq', 'qwwqwqwq', '12345678901', '2025-12-22', 999, 1, 26, 1, 2, 11),
(3, '2391797664', 'فقفا', 'قبلذبذبلذ', 'بلذلبلذ', '111111111111111', '2025-12-22', 999, 1, 26, 1, 1, 13),
(4, '2280000001', 'rthrt', 'rthrthrth', 'rthtrhthr', '111111111111111', '2025-12-20', 999, 3, 26, 2, 2, 11),
(5, '2380000002', 'qqqqqqqqqq', 'qqqqqqqqqqq', 'qqqqqqqqqqqq', '111111111111111', '2025-12-20', 999, 2, 26, 2, 2, 11),
(6, '2280000000', 'جدید', 'ششش', 'ششش', '111111111111111', '2025-12-20', 999, 2, 26, 1, 1, 11),
(8, '2222222222', 'Arvin', 'Beheshti', 'ضضضضض', '222222222222222222', '2025-12-20', 999, 2, 26, 2, 1, 12),
(9, '1222222222', 'صصصص', 'صصصص', 'صصصص', '1111111223444', '2025-12-20', 999, 1, 26, 1, 1, 10),
(10, '1282828282', 'احمد', 'کورنگ بهشتی', 'حسن', '302', '1965-03-18', 999, 2, 37, 1, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `users_employee`
--

CREATE TABLE `users_employee` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `national_id` varchar(10) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `is_first_login` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `can_access_all_departments` tinyint(1) NOT NULL,
  `can_access_dashboard` tinyint(1) NOT NULL,
  `day_usage` int(11) NOT NULL,
  `last_file_upload` datetime(6) DEFAULT NULL,
  `personnel_code` varchar(15) DEFAULT NULL,
  `food_receiver_factory_id` bigint(20) DEFAULT NULL,
  `food_receiver_holding_id` bigint(20) DEFAULT NULL,
  `food_receiver_role` smallint(5) UNSIGNED NOT NULL CHECK (`food_receiver_role` >= 0),
  `unlimit_reservation` tinyint(1) NOT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `birth_certificate_number` varchar(50) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `dependency_status_id` smallint(5) UNSIGNED DEFAULT NULL,
  `gender_id` smallint(5) UNSIGNED DEFAULT NULL,
  `marital_status_id` smallint(5) UNSIGNED DEFAULT NULL,
  `father_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_employee`
--

INSERT INTO `users_employee` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `national_id`, `phone_number`, `is_first_login`, `date_joined`, `is_active`, `can_access_all_departments`, `can_access_dashboard`, `day_usage`, `last_file_upload`, `personnel_code`, `food_receiver_factory_id`, `food_receiver_holding_id`, `food_receiver_role`, `unlimit_reservation`, `address`, `birth_certificate_number`, `birth_date`, `dependency_status_id`, `gender_id`, `marital_status_id`, `father_name`) VALUES
(1, 'pbkdf2_sha256$1000000$t1JZDG7fkowbfO5YPBOKVm$bsyTPvQOZJdgsK8PvT/iIUv56x3r4mpHzK9BruapjGg=', '2025-12-17 07:12:27.838547', 1, 'younes', 'younes', 'ghaedi', 'younes_ghaedi@yahoo.com', 1, '2391797664', '09936082811', 0, '2025-09-23 04:47:13.298845', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'pbkdf2_sha256$1000000$cR7lNMp6Q8W4iw1LewhkCf$31krI2fAdL3XRoUFU6HK0a04UJJ2uf4jR0YKoFxkAwc=', '2025-09-30 03:31:03.035811', 0, '', 'hosin', 'ghaedi', '', 0, '2392079625', '09173226853', 0, '2025-09-25 03:28:21.596992', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 'pbkdf2_sha256$1000000$8VM1xln50P3OoPMHXO7LoJ$1uRORWomI33H66U4YNGgMAOXKuU8UrRxeoqoW2l3J3E=', '2025-10-28 09:02:49.114540', 0, '2280225654', 'MALI', 'MODIR', '', 0, '2280000000', '09171235468', 0, '2025-09-28 02:15:20.195889', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 'pbkdf2_sha256$1000000$CvgJQCfYdDZ14vENRDcqll$sg2BrLJ57FmERPULRRkRJXfmOauGGUougl8RuwzqWHQ=', '2025-11-06 07:21:17.066761', 0, '2280000001', 'MALI', 'EMP', '', 0, '2280000001', '09936082812', 0, '2025-09-28 02:16:55.246011', 1, 0, 1, 14290, '2025-10-22 10:44:53.346923', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'pbkdf2_sha256$1000000$WFSKytBSHaE4iTMghHBYz0$++ynO9z96M17OAEO6tUVSOVYtdbt2xLEyNWAUQp7B1w=', NULL, 0, '2290000000', 'HS', 'MODIR', '', 0, '2290000000', '09173226853', 0, '2025-09-28 02:18:32.967909', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'pbkdf2_sha256$1000000$Pyxup5CiFumlXKklxVuyb8$lsf0iyzdowDGGWdiNNjweGq3Weh/WoL3LDogULJZUgY=', '2025-10-08 07:25:58.609363', 0, '2290000001', 'HS', 'EMP', '', 0, '2290000001', '2391797664', 0, '2025-09-28 02:19:17.325368', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 'pbkdf2_sha256$1000000$jbxwivNSEV4dShKt1RVy8T$ErZYqMTJ0rYJY4xxNfAvvEv9VcUNW0SW2hN+898UXbI=', '2025-09-28 02:23:11.664578', 0, '2390000001', 'AI', 'EMP', '', 0, '2390000001', '09936082812', 0, '2025-09-28 02:21:12.998239', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'pbkdf2_sha256$1000000$2AJ6NsQmLu1p7vIxq93iKQ$6YXqVxcNwdxKAmyjT2QXt9mAtXVzMiM5FqaTBP0SZ9s=', '2025-10-11 08:39:37.474419', 0, '2391797665', 'younes2', 'ghaedi2', '', 0, '2391797665', '09936082812', 1, '2025-10-01 23:48:20.922458', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 'pbkdf2_sha256$1000000$p7flx8sVadxhqEWL4cjHYX$qAkh7NDP82SSICrgNFcEc8algtel0GjAROZsD0iQkbw=', '2025-10-21 06:15:08.261799', 0, '2380000002', 'MALI', 'sarparast', '', 0, '2380000002', '09936082811', 1, '2025-10-02 00:35:49.230597', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(26, 'pbkdf2_sha256$1000000$ogvfqJE4T8bLBxTnob3kXh$WMVK0XGVqbPHqXZQmB7/bSgeIL7hbGeHmR6JtzHfHQw=', '2025-12-27 06:13:27.841007', 1, '1000111100', 'سرپرست زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 1, '1000111100', '0900000000', 0, '2025-10-29 05:14:16.498035', 1, 0, 1, 3170732, '2025-12-27 07:25:38.301585', '111111111', NULL, 1, 2, 1, NULL, 'شششش', '2026-01-17', NULL, 1, 2, 'احمد'),
(27, 'pbkdf2_sha256$1000000$5GvLcEN5xw7weiiqibt15p$Y1+VTaNp1V1V3ucpxS76dM/TeW2tSlQl0m9gaZKtgEY=', '2025-12-13 10:07:29.161394', 0, '1000111200', 'سرپرست زیربخش 2 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 0, '1000111200', '0900000000', 0, '2025-10-29 05:18:42.974086', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(28, 'pbkdf2_sha256$1000000$fQzxfYONpQvTC0zcCc9cSY$BY5FbC9K5BxUAK637tLczNJEsG2JKNngh6KZ5U98uzE=', '2025-11-01 06:56:51.431715', 0, '1000111000', 'مدیر بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 0, '1000111000', '0900000000', 0, '2025-10-29 05:20:27.417630', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29, 'pbkdf2_sha256$1000000$UvNsZKZtEKqSYT78bxBOkj$l2RqizhyVU/v/k0ze4aIJns6xM+1l2nTQ/MJQPvyg8o=', NULL, 0, '1000110000', 'مدیر کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 0, '1000110000', '0900000000', 0, '2025-10-29 05:22:50.088988', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30, 'pbkdf2_sha256$1000000$kKCSbA3AXiGs7wrYDDRBIy$don7URAs2jReMzNrUC2YOEvDlmf3HKbEH+4KU+pIVB0=', NULL, 0, '1000100000', 'مدیر هلدینگ اصفهان مقدم', 'تست', '', 0, '1000100000', '0900000000', 0, '2025-10-29 05:24:14.045251', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 'pbkdf2_sha256$1000000$5MKTI4s3lEerStjIQGz15H$zxBPCAJQJwfTCiLyznDLJKkpFHaHeQWAkTW0vpKIr90=', '2025-11-15 05:21:46.138681', 0, '1000111101', ';کارمند زیربخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 0, '1000111101', '0900000000', 0, '2025-10-29 05:27:10.612947', 1, 0, 1, 71450, '2025-11-01 05:15:18.085330', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 'pbkdf2_sha256$1000000$xneLgLfw0kiG2BEQs2obSf$r73RmvtQUH+dzPl63Yp/Gr+mtYrT5MRWtkj7p531DOY=', '2025-11-01 06:49:54.532094', 0, '1000111201', ';کارمند زیربخش 2 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'تست', '', 0, '1000111201', '0900000000', 0, '2025-10-29 05:29:11.364820', 1, 0, 1, 14290, '2025-11-01 05:25:09.852665', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(33, 'pbkdf2_sha256$1000000$8XIPYHXdxy8p7Fhe2Ml4Tf$4KWz6L0XObqjez8swrmlksWSoaVIF0BhMDkP0yEk/nE=', NULL, 0, '2222222222', 'کارمند تست نقش', '1', '', 0, '2222222222', '0900000000', 1, '2025-11-01 09:15:23.495061', 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 'pbkdf2_sha256$1000000$REismd1XHUSYMqceXw7eu4$uXGtJgBshlHU9mdhO4TXfQtnB9J+Mfa4mMU5FK9RLJM=', NULL, 0, '1111111111', 'تست', 'اکسل', '', 0, '1111111111', '994994444', 1, '2025-11-12 05:48:56.265707', 1, 0, 1, 0, NULL, '1234567891', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 'pbkdf2_sha256$1000000$vC9vdtqWggO03dLjuHhdZ3$ECo+IVGUhZ9gd0baSKjs+goYoPe8Q8xXPW3F/on5Hto=', '2025-12-27 07:13:18.621561', 0, '1272715434', 'آروین', 'کورنگ بهشتی', '', 0, '1272715434', '', 0, '2025-12-25 07:05:33.595157', 1, 0, 1, 0, NULL, '404072615', NULL, NULL, 0, 0, NULL, '1272715434', '1998-07-31', 3, 1, 2, 'احمد');

-- --------------------------------------------------------

--
-- Table structure for table `users_employee_assigned_subdepartments`
--

CREATE TABLE `users_employee_assigned_subdepartments` (
  `id` bigint(20) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `subdepartment_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_employee_assigned_subdepartments`
--

INSERT INTO `users_employee_assigned_subdepartments` (`id`, `employee_id`, `subdepartment_id`) VALUES
(1, 26, 1),
(2, 26, 2),
(3, 26, 3),
(4, 26, 4),
(7, 26, 18);

-- --------------------------------------------------------

--
-- Table structure for table `users_employee_bimeh`
--

CREATE TABLE `users_employee_bimeh` (
  `id` bigint(20) NOT NULL,
  `bimeh_nubmer` varchar(50) DEFAULT NULL,
  `employment_date` date DEFAULT NULL,
  `country_id` smallint(5) UNSIGNED DEFAULT NULL,
  `employee_id` bigint(20) NOT NULL,
  `employment_type_id` smallint(5) UNSIGNED DEFAULT NULL,
  `job_group_id` smallint(5) UNSIGNED DEFAULT NULL,
  `base_insurance_id` smallint(5) UNSIGNED DEFAULT NULL,
  `coverage_duration` int(10) UNSIGNED DEFAULT NULL CHECK (`coverage_duration` >= 0),
  `previous_insurer_id` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_employee_bimeh`
--

INSERT INTO `users_employee_bimeh` (`id`, `bimeh_nubmer`, `employment_date`, `country_id`, `employee_id`, `employment_type_id`, `job_group_id`, `base_insurance_id`, `coverage_duration`, `previous_insurer_id`) VALUES
(1, NULL, '2025-12-22', 999, 26, 1, 1, 19, 1, 14),
(3, NULL, '2025-10-04', 999, 37, NULL, 3, 5, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_employee_groups`
--

CREATE TABLE `users_employee_groups` (
  `id` bigint(20) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_employee_roles`
--

CREATE TABLE `users_employee_roles` (
  `id` bigint(20) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_employee_roles`
--

INSERT INTO `users_employee_roles` (`id`, `employee_id`, `role_id`) VALUES
(1, 1, 1),
(23, 26, 1),
(17, 26, 2),
(13, 26, 3),
(21, 26, 4),
(24, 26, 5),
(22, 26, 6),
(27, 27, 2),
(6, 27, 3),
(28, 27, 4),
(7, 28, 2),
(8, 29, 6),
(9, 30, 5),
(10, 31, 4),
(11, 32, 4),
(19, 33, 2),
(20, 33, 3),
(29, 37, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_employee_user_permissions`
--

CREATE TABLE `users_employee_user_permissions` (
  `id` bigint(20) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_employmenttype`
--

CREATE TABLE `users_employmenttype` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_employmenttype`
--

INSERT INTO `users_employmenttype` (`code`, `name`) VALUES
(2, 'رسمی بازنشسته'),
(4, 'رسمی شاغل'),
(5, 'روزمزد'),
(9, 'سایر'),
(1, 'قراردادي'),
(3, 'پیمانی'),
(8, 'کارشناس آزاد'),
(6, 'کارمند نمایندگی'),
(7, 'کارمند کارگزاری');

-- --------------------------------------------------------

--
-- Table structure for table `users_evaluation`
--

CREATE TABLE `users_evaluation` (
  `id` bigint(20) NOT NULL,
  `period` varchar(20) NOT NULL,
  `participation_count` int(10) UNSIGNED NOT NULL CHECK (`participation_count` >= 0),
  `audio_count` int(10) UNSIGNED NOT NULL CHECK (`audio_count` >= 0),
  `score` double NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_evaluation`
--

INSERT INTO `users_evaluation` (`id`, `period`, `participation_count`, `audio_count`, `score`, `created_at`, `user_id`) VALUES
(1, 'monthly', 0, 0, 0, '2025-09-28 05:20:07.251532', 1),
(2, 'monthly', 0, 0, 0, '2025-09-28 05:45:52.342813', 8),
(3, 'monthly', 0, 0, 0, '2025-09-28 05:45:52.355550', 9),
(4, 'monthly', 0, 0, 0, '2025-09-28 05:45:52.363115', 11),
(5, 'monthly', 0, 0, 0, '2025-09-28 05:45:52.373838', 12),
(6, 'monthly', 0, 0, 0, '2025-09-28 05:45:52.391275', 3),
(7, 'monthly', 0, 0, 0, '2025-10-02 00:41:34.759880', 15),
(8, 'monthly', 0, 0, 0, '2025-10-11 04:03:19.735866', 14),
(9, 'monthly', 0, 0, 0, '2025-10-29 06:34:42.281180', 31),
(10, 'monthly', 0, 0, 0, '2025-11-01 05:25:09.863652', 32),
(11, 'monthly', 0, 0, 0, '2025-11-17 11:45:25.415007', 26);

-- --------------------------------------------------------

--
-- Table structure for table `users_factory`
--

CREATE TABLE `users_factory` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `location` varchar(200) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `holding_id` bigint(20) DEFAULT NULL,
  `manager_id` bigint(20) DEFAULT NULL,
  `is_committee` tinyint(1) NOT NULL,
  `linked_factory_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_factory`
--

INSERT INTO `users_factory` (`id`, `name`, `location`, `created_at`, `holding_id`, `manager_id`, `is_committee`, `linked_factory_id`) VALUES
(1, 'اصفهان مقدم', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-09-23 07:22:11.244589', 1, NULL, 0, NULL),
(2, 'کارخانه تست 1 هلدینگ اصفهان مقدم', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-29 04:48:43.917477', 1, 26, 0, NULL),
(3, 'کارخانه تست 2 هلدینگ اصفهان مقدم', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-29 04:49:12.084520', 1, NULL, 0, NULL),
(4, 'هلدینگ تست 1 کارخانه تست 2', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-29 04:49:29.509466', 3, NULL, 0, NULL),
(5, 'کارخانه تست 2 هلدینگ تست 2', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-29 04:49:45.137305', 3, 26, 0, NULL),
(6, 'کمیته کارخانه تست 1 هلدینگ اصفهان مقدم', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-11-12 10:30:26.000000', 1, 26, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `users_fooditem`
--

CREATE TABLE `users_fooditem` (
  `id` bigint(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `factory_price` int(10) UNSIGNED NOT NULL CHECK (`factory_price` >= 0),
  `is_active` tinyint(1) NOT NULL,
  `free_price` int(10) UNSIGNED NOT NULL CHECK (`free_price` >= 0),
  `guest_price` int(10) UNSIGNED NOT NULL CHECK (`guest_price` >= 0),
  `price` int(10) UNSIGNED NOT NULL CHECK (`price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_fooditem`
--

INSERT INTO `users_fooditem` (`id`, `name`, `factory_price`, `is_active`, `free_price`, `guest_price`, `price`) VALUES
(5, 'قیمه', 23423535, 1, 33, 0, 0),
(6, 'کوبیده', 33333, 1, 66, 0, 0),
(7, 'جوجه', 444444, 1, 77, 0, 0),
(8, 'aa', 121, 1, 88, 0, 0),
(9, 'sss', 111, 1, 2222, 0, 0),
(10, 'TEST', 50000, 1, 100000, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_foodreservation`
--

CREATE TABLE `users_foodreservation` (
  `id` bigint(20) NOT NULL,
  `reservation_date` date NOT NULL,
  `reserved_at` datetime(6) NOT NULL,
  `is_canceled` tinyint(1) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `menu_item_id` bigint(20) NOT NULL,
  `related_factory_id` bigint(20) DEFAULT NULL,
  `feedback` longtext DEFAULT NULL,
  `rating` smallint(5) UNSIGNED DEFAULT NULL CHECK (`rating` >= 0),
  `is_delivered` tinyint(1) NOT NULL,
  `factory_price` int(10) UNSIGNED NOT NULL CHECK (`factory_price` >= 0),
  `factory_quantity` int(10) UNSIGNED NOT NULL CHECK (`factory_quantity` >= 0),
  `free_price` int(10) UNSIGNED NOT NULL CHECK (`free_price` >= 0),
  `free_quantity` int(10) UNSIGNED NOT NULL CHECK (`free_quantity` >= 0),
  `guest_price` int(10) UNSIGNED NOT NULL CHECK (`guest_price` >= 0),
  `guest_quantity` int(10) UNSIGNED NOT NULL CHECK (`guest_quantity` >= 0),
  `total_price` int(10) UNSIGNED NOT NULL CHECK (`total_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_foodreservation`
--

INSERT INTO `users_foodreservation` (`id`, `reservation_date`, `reserved_at`, `is_canceled`, `employee_id`, `menu_item_id`, `related_factory_id`, `feedback`, `rating`, `is_delivered`, `factory_price`, `factory_quantity`, `free_price`, `free_quantity`, `guest_price`, `guest_quantity`, `total_price`) VALUES
(190, '2025-11-26', '2025-11-26 13:26:01.000000', 0, 26, 355, 2, 'تتتت', 4, 0, 0, 0, 0, 0, 0, 0, 0),
(191, '2025-11-26', '2025-11-26 13:26:01.000000', 0, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(192, '2025-11-26', '2025-11-26 13:26:01.000000', 0, 26, 356, 2, 'سیرسیر', 3, 0, 0, 0, 0, 0, 0, 0, 0),
(195, '2025-11-28', '2025-11-27 10:50:27.794178', 0, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(196, '2025-11-26', '2025-11-26 09:03:17.000000', 0, 27, 355, 2, 'mmmmm', 1, 0, 0, 0, 0, 0, 0, 0, 0),
(259, '2025-12-05', '2025-11-30 06:32:26.276194', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(260, '2025-12-04', '2025-11-30 06:32:34.023541', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(264, '2025-12-05', '2025-11-30 06:32:34.039981', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(265, '2025-12-05', '2025-11-30 06:32:34.057124', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(266, '2025-12-03', '2025-11-30 11:02:05.942857', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(267, '2025-12-04', '2025-11-30 11:02:05.942857', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(268, '2025-12-04', '2025-11-30 11:02:05.959620', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(269, '2025-12-04', '2025-11-30 11:02:05.959620', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(270, '2025-12-05', '2025-11-30 11:02:05.959620', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(271, '2025-12-05', '2025-11-30 11:02:05.975798', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(272, '2025-12-05', '2025-11-30 11:02:05.975798', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(273, '2025-12-03', '2025-11-30 11:02:12.342818', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(274, '2025-12-04', '2025-11-30 11:02:12.342818', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(275, '2025-12-04', '2025-11-30 11:02:12.358799', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(276, '2025-12-04', '2025-11-30 11:02:12.358799', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(277, '2025-12-05', '2025-11-30 11:02:12.358799', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(278, '2025-12-05', '2025-11-30 11:02:12.376058', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(279, '2025-12-05', '2025-11-30 11:02:12.376058', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(280, '2025-12-03', '2025-11-30 11:02:24.792116', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(281, '2025-12-04', '2025-11-30 11:02:24.792116', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(282, '2025-12-04', '2025-11-30 11:02:24.792116', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(283, '2025-12-04', '2025-11-30 11:02:24.808671', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(284, '2025-12-05', '2025-11-30 11:02:24.808671', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(285, '2025-12-05', '2025-11-30 11:02:24.808671', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(286, '2025-12-05', '2025-11-30 11:02:24.825629', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(287, '2025-12-04', '2025-11-30 11:02:52.437266', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(288, '2025-12-04', '2025-11-30 11:02:52.437266', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(289, '2025-12-04', '2025-11-30 11:02:52.437266', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(290, '2025-12-05', '2025-11-30 11:02:52.453683', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(291, '2025-12-05', '2025-11-30 11:02:52.453683', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(292, '2025-12-05', '2025-11-30 11:02:52.453683', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(293, '2025-12-03', '2025-11-30 11:02:57.453166', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(294, '2025-12-04', '2025-11-30 11:02:57.453166', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(295, '2025-12-04', '2025-11-30 11:02:57.453166', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(296, '2025-12-04', '2025-11-30 11:02:57.469807', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(297, '2025-12-05', '2025-11-30 11:02:57.469807', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(298, '2025-12-05', '2025-11-30 11:02:57.469807', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(299, '2025-12-05', '2025-11-30 11:02:57.489819', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(300, '2025-12-03', '2025-11-30 11:03:03.420652', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(301, '2025-12-04', '2025-11-30 11:03:03.437805', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(302, '2025-12-04', '2025-11-30 11:03:03.437805', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(303, '2025-12-05', '2025-11-30 11:03:03.437805', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(304, '2025-12-05', '2025-11-30 11:03:03.454156', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(305, '2025-12-05', '2025-11-30 11:03:03.454156', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(306, '2025-12-03', '2025-11-30 11:03:10.503332', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(307, '2025-12-04', '2025-11-30 11:03:10.503332', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(308, '2025-12-04', '2025-11-30 11:03:10.503332', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(309, '2025-12-05', '2025-11-30 11:03:10.520095', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(310, '2025-12-05', '2025-11-30 11:03:10.520095', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(311, '2025-12-05', '2025-11-30 11:03:10.520095', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(312, '2025-12-03', '2025-11-30 11:03:52.814908', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(313, '2025-12-04', '2025-11-30 11:03:52.814908', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(314, '2025-12-04', '2025-11-30 11:03:52.814908', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(315, '2025-12-05', '2025-11-30 11:03:52.831356', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(316, '2025-12-05', '2025-11-30 11:03:52.831356', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(317, '2025-12-05', '2025-11-30 11:03:52.831356', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(318, '2025-12-02', '2025-11-30 11:04:22.710049', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(319, '2025-12-03', '2025-11-30 11:04:22.710049', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(320, '2025-12-04', '2025-11-30 11:04:22.726651', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(321, '2025-12-04', '2025-11-30 11:04:22.726651', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(322, '2025-12-05', '2025-11-30 11:04:22.742273', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(323, '2025-12-05', '2025-11-30 11:04:22.742990', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(324, '2025-12-05', '2025-11-30 11:04:22.742990', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(325, '2025-12-02', '2025-11-30 11:04:37.294158', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(326, '2025-12-03', '2025-11-30 11:04:37.294158', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(327, '2025-12-04', '2025-11-30 11:04:37.294158', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(328, '2025-12-04', '2025-11-30 11:04:37.308654', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(329, '2025-12-05', '2025-11-30 11:04:37.308654', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(330, '2025-12-05', '2025-11-30 11:04:37.308654', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(331, '2025-12-05', '2025-11-30 11:04:37.325324', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(332, '2025-12-02', '2025-11-30 11:05:29.797497', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(333, '2025-12-03', '2025-11-30 11:05:29.802626', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(334, '2025-12-04', '2025-11-30 11:05:29.808635', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(335, '2025-12-04', '2025-11-30 11:05:29.814594', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(336, '2025-12-05', '2025-11-30 11:05:29.820634', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(337, '2025-12-05', '2025-11-30 11:05:29.826619', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(338, '2025-12-05', '2025-11-30 11:05:29.831348', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(339, '2025-12-02', '2025-11-30 11:05:40.937062', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(340, '2025-12-03', '2025-11-30 11:05:40.950934', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(341, '2025-12-03', '2025-11-30 11:05:40.951029', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(342, '2025-12-04', '2025-11-30 11:05:40.951029', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(343, '2025-12-04', '2025-11-30 11:05:40.951029', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(344, '2025-12-05', '2025-11-30 11:05:40.967263', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(345, '2025-12-05', '2025-11-30 11:05:40.967263', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(346, '2025-12-05', '2025-11-30 11:05:40.967263', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(347, '2025-12-02', '2025-11-30 11:05:52.116621', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(348, '2025-12-02', '2025-11-30 11:05:52.116621', 1, 26, 350, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(349, '2025-12-03', '2025-11-30 11:05:52.116621', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(350, '2025-12-03', '2025-11-30 11:05:52.136014', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(351, '2025-12-04', '2025-11-30 11:05:52.136014', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(352, '2025-12-04', '2025-11-30 11:05:52.149560', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(353, '2025-12-05', '2025-11-30 11:05:52.152656', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(354, '2025-12-05', '2025-11-30 11:05:52.152656', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(355, '2025-12-05', '2025-11-30 11:05:52.152656', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(356, '2025-12-01', '2025-11-30 11:06:01.533477', 1, 26, 367, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(357, '2025-12-01', '2025-11-30 11:06:01.533477', 1, 26, 367, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(358, '2025-12-02', '2025-11-30 11:06:01.533477', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(359, '2025-12-02', '2025-11-30 11:06:01.550513', 1, 26, 350, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(360, '2025-12-03', '2025-11-30 11:06:01.550513', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(361, '2025-12-03', '2025-11-30 11:06:01.550513', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(403, '2025-12-01', '2025-11-30 11:41:51.500207', 0, 26, 367, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(404, '2025-12-01', '2025-11-30 11:41:51.500207', 0, 26, 367, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(405, '2025-12-02', '2025-11-30 11:41:51.500207', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(406, '2025-12-02', '2025-11-30 11:41:51.515037', 1, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(407, '2025-12-02', '2025-11-30 11:41:51.515037', 1, 26, 350, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(408, '2025-12-03', '2025-11-30 11:41:51.515037', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(409, '2025-12-03', '2025-11-30 11:41:51.534712', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(410, '2025-12-04', '2025-11-30 11:41:51.534712', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(411, '2025-12-04', '2025-11-30 11:41:51.534712', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(412, '2025-12-05', '2025-11-30 11:41:51.548282', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(413, '2025-12-05', '2025-11-30 11:41:51.548282', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(414, '2025-12-05', '2025-11-30 11:41:51.565112', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(416, '2025-12-01', '2025-12-01 14:12:05.000000', 0, 26, 444, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(417, '2025-12-02', '2025-12-01 11:06:38.868287', 0, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(418, '2025-12-02', '2025-12-01 11:06:38.868287', 0, 26, 353, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(419, '2025-12-02', '2025-12-01 11:06:38.868287', 0, 26, 350, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(420, '2025-12-03', '2025-12-01 11:06:38.889650', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(421, '2025-12-03', '2025-12-01 11:06:38.894721', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(422, '2025-12-03', '2025-12-01 11:06:38.904754', 1, 26, 451, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(423, '2025-12-04', '2025-12-01 11:06:38.905903', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(424, '2025-12-04', '2025-12-01 11:06:38.916594', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(425, '2025-12-05', '2025-12-01 11:06:38.917584', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(426, '2025-12-05', '2025-12-01 11:06:38.917584', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(427, '2025-12-05', '2025-12-01 11:06:38.934278', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(428, '2025-12-03', '2025-12-02 11:55:41.020462', 1, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(429, '2025-12-03', '2025-12-02 11:55:41.020462', 1, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(430, '2025-12-03', '2025-12-02 11:55:41.035157', 1, 26, 451, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(431, '2025-12-04', '2025-12-02 11:55:41.036162', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(432, '2025-12-04', '2025-12-02 11:55:41.036162', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(433, '2025-12-05', '2025-12-02 11:55:41.050094', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(434, '2025-12-05', '2025-12-02 11:55:41.050094', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(435, '2025-12-05', '2025-12-02 11:55:41.050094', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(436, '2025-12-04', '2025-12-03 06:33:20.826553', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(437, '2025-12-04', '2025-12-03 06:33:20.826553', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(438, '2025-12-04', '2025-12-03 06:33:20.840140', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(439, '2025-12-04', '2025-12-03 06:33:20.840140', 1, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(440, '2025-12-04', '2025-12-03 06:33:20.857444', 1, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(441, '2025-12-04', '2025-12-03 06:33:20.857444', 1, 26, 446, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(442, '2025-12-05', '2025-12-03 06:33:20.872806', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(443, '2025-12-05', '2025-12-03 06:33:20.873933', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(444, '2025-12-05', '2025-12-03 06:33:20.873933', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(445, '2025-12-03', '2025-12-03 06:34:20.085787', 0, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(446, '2025-12-03', '2025-12-03 06:34:20.085787', 0, 26, 356, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(447, '2025-12-03', '2025-12-03 06:34:20.085787', 0, 26, 451, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(448, '2025-12-03', '2025-12-03 06:34:20.102354', 0, 26, 355, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(449, '2025-12-03', '2025-12-03 06:34:20.102354', 0, 26, 441, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(450, '2025-12-03', '2025-12-03 06:34:20.118551', 0, 26, 431, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(451, '2025-12-03', '2025-12-03 06:34:20.118551', 0, 26, 436, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(452, '2025-12-04', '2025-12-03 06:34:20.118551', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(453, '2025-12-04', '2025-12-03 06:34:20.135562', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(454, '2025-12-04', '2025-12-03 06:34:20.135562', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(455, '2025-12-04', '2025-12-03 06:34:20.135562', 1, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(456, '2025-12-04', '2025-12-03 06:34:20.151953', 1, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(457, '2025-12-04', '2025-12-03 06:34:20.151953', 1, 26, 446, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(458, '2025-12-05', '2025-12-03 06:34:20.151953', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(459, '2025-12-05', '2025-12-03 06:34:20.168371', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(460, '2025-12-05', '2025-12-03 06:34:20.168371', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(461, '2025-12-04', '2025-12-03 07:00:14.454964', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(462, '2025-12-04', '2025-12-03 07:00:14.454964', 1, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(463, '2025-12-04', '2025-12-03 07:00:14.471262', 1, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(464, '2025-12-04', '2025-12-03 07:00:14.471262', 1, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(465, '2025-12-04', '2025-12-03 07:00:14.471262', 1, 26, 446, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(466, '2025-12-05', '2025-12-03 07:00:14.487709', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(467, '2025-12-05', '2025-12-03 07:00:14.487709', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(468, '2025-12-05', '2025-12-03 07:00:14.487709', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(469, '2025-12-04', '2025-12-03 07:00:53.181640', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(470, '2025-12-04', '2025-12-03 07:00:53.183513', 1, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(471, '2025-12-04', '2025-12-03 07:00:53.183513', 1, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(472, '2025-12-04', '2025-12-03 07:00:53.198300', 1, 26, 446, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(473, '2025-12-05', '2025-12-03 07:00:53.199787', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(474, '2025-12-05', '2025-12-03 07:00:53.199787', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(475, '2025-12-05', '2025-12-03 07:00:53.216295', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(476, '2025-12-04', '2025-12-03 07:09:34.639343', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(477, '2025-12-04', '2025-12-03 07:09:34.639343', 1, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(478, '2025-12-04', '2025-12-03 07:09:34.639343', 1, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(479, '2025-12-04', '2025-12-03 07:09:34.656024', 1, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(480, '2025-12-05', '2025-12-03 07:09:34.656024', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(481, '2025-12-05', '2025-12-03 07:09:34.669912', 1, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(482, '2025-12-05', '2025-12-03 07:09:34.671852', 1, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(483, '2025-12-04', '2025-12-03 07:39:10.183002', 0, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(484, '2025-12-04', '2025-12-03 07:39:10.183002', 0, 26, 427, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(485, '2025-12-04', '2025-12-03 07:39:10.200003', 0, 26, 437, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(486, '2025-12-04', '2025-12-03 07:39:10.200003', 0, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(487, '2025-12-04', '2025-12-03 07:39:10.200003', 0, 26, 354, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(488, '2025-12-04', '2025-12-03 07:39:10.216149', 0, 26, 352, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(489, '2025-12-04', '2025-12-03 07:39:10.216149', 0, 26, 446, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(490, '2025-12-05', '2025-12-03 07:39:10.216149', 0, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(491, '2025-12-05', '2025-12-03 07:39:10.232638', 0, 26, 349, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(492, '2025-12-05', '2025-12-03 07:39:10.232638', 0, 26, 351, 2, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0),
(571, '2025-12-08', '2025-12-08 06:13:12.861286', 0, 26, 422, 2, 'eeeeee', 2, 0, 33333, 1, 66, 1, 0, 0, 33399),
(572, '2025-12-08', '2025-12-08 06:13:12.874176', 0, 26, 449, 2, 'ooooo', 3, 0, 33333, 0, 66, 4, 0, 0, 264),
(573, '2025-12-08', '2025-12-08 06:13:12.890628', 0, 26, 425, 2, 'iiiii', 1, 0, 121, 0, 88, 0, 0, 5, 0),
(587, '2025-12-07', '2025-12-07 10:25:47.000000', 0, 26, 416, 2, 'فقط کار کن', 4, 0, 222, 1, 0, 1, 0, 1, 222),
(588, '2025-12-08', '2025-12-08 14:42:42.000000', 0, 27, 425, 2, 'این تست جدیده', 2, 0, 0, 1, 0, 2, 0, 3, 0),
(589, '2025-12-09', '2025-12-09 05:39:40.928234', 0, 26, 414, 2, NULL, NULL, 0, 111, 1, 2222, 0, 0, 0, 111),
(590, '2025-12-09', '2025-12-09 05:39:40.928234', 0, 26, 450, 2, NULL, NULL, 0, 33333, 0, 66, 5, 0, 0, 330),
(591, '2025-12-09', '2025-12-09 05:39:40.945182', 0, 26, 430, 2, NULL, NULL, 0, 111, 0, 2222, 0, 0, 5, 0),
(592, '2025-12-10', '2025-12-09 05:39:40.945182', 0, 26, 421, 2, NULL, NULL, 0, 23423535, 1, 33, 0, 0, 0, 23423535),
(593, '2025-12-10', '2025-12-09 05:39:40.962467', 0, 26, 451, 2, NULL, NULL, 0, 33333, 0, 66, 5, 0, 0, 330),
(594, '2025-12-10', '2025-12-09 05:39:40.962467', 0, 26, 441, 2, NULL, NULL, 0, 444444, 0, 77, 0, 0, 5, 0),
(675, '2025-12-11', '2025-12-11 05:06:25.499791', 0, 26, 417, 2, NULL, NULL, 0, 50000, 1, 100000, 0, 0, 0, 50000),
(676, '2025-12-11', '2025-12-11 05:06:25.508621', 0, 26, 446, 2, NULL, NULL, 0, 23423535, 0, 33, 5, 0, 0, 165),
(677, '2025-12-12', '2025-12-11 05:06:25.517437', 0, 26, 415, 2, NULL, NULL, 0, 111, 1, 2222, 2, 0, 0, 4555),
(678, '2025-12-12', '2025-12-11 05:06:25.540464', 0, 26, 452, 2, NULL, NULL, 0, 33333, 0, 66, 2, 0, 0, 132),
(684, '2025-12-14', '2025-12-13 11:09:26.847843', 0, 26, 416, 2, NULL, NULL, 0, 50000, 1, 100000, 4, 0, 0, 450000),
(685, '2025-12-14', '2025-12-13 11:09:26.869239', 0, 26, 418, 2, NULL, NULL, 0, 444444, 0, 77, 1, 0, 5, 77),
(719, '2025-12-17', '2025-12-16 07:40:01.709525', 0, 26, 421, 2, NULL, NULL, 0, 23423535, 1, 33, 4, 0, 1, 23423667),
(720, '2025-12-17', '2025-12-16 07:40:01.744475', 0, 26, 431, 2, NULL, NULL, 0, 111, 0, 2222, 46, 0, 0, 102212),
(754, '2025-12-23', '2025-12-23 08:13:07.936588', 0, 26, 414, 2, NULL, NULL, 0, 111, 1, 2222, 0, 0, 0, 111),
(758, '2025-12-24', '2025-12-23 08:13:30.993612', 0, 26, 423, 2, NULL, NULL, 0, 33333, 1, 66, 0, 0, 0, 33333),
(759, '2025-12-25', '2025-12-23 08:13:31.005008', 0, 26, 417, 2, NULL, NULL, 0, 50000, 1, 100000, 0, 0, 0, 50000),
(760, '2025-12-26', '2025-12-23 08:13:31.011128', 0, 26, 442, 2, NULL, NULL, 0, 444444, 1, 77, 0, 0, 0, 444444),
(761, '2025-12-27', '2025-12-27 06:16:26.775609', 0, 26, 411, 2, NULL, NULL, 0, 121, 1, 88, 0, 0, 0, 121),
(762, '2025-12-27', '2025-12-27 06:16:26.782411', 0, 26, 413, 2, NULL, NULL, 0, 111, 0, 2222, 3, 0, 0, 6666),
(763, '2025-12-27', '2025-12-27 06:16:26.791296', 0, 26, 443, 2, NULL, NULL, 0, 23423535, 0, 33, 0, 0, 9, 0),
(764, '2025-12-28', '2025-12-27 06:16:26.798644', 0, 26, 418, 2, NULL, NULL, 0, 444444, 1, 77, 0, 0, 0, 444444),
(765, '2025-12-28', '2025-12-27 06:16:26.807250', 0, 26, 416, 2, NULL, NULL, 0, 50000, 0, 100000, 0, 0, 4, 0),
(766, '2025-12-28', '2025-12-27 06:16:26.815885', 0, 26, 434, 2, NULL, NULL, 0, 50000, 0, 100000, 0, 0, 4, 0),
(767, '2025-12-28', '2025-12-27 06:16:26.823664', 0, 26, 439, 2, NULL, NULL, 0, 444444, 0, 77, 7, 0, 0, 539),
(768, '2025-12-29', '2025-12-27 06:16:26.831563', 0, 26, 425, 2, NULL, NULL, 0, 121, 1, 88, 0, 0, 0, 121),
(769, '2025-12-29', '2025-12-27 06:16:26.839442', 0, 26, 449, 2, NULL, NULL, 0, 33333, 0, 66, 1, 0, 4, 66),
(770, '2025-12-30', '2025-12-27 06:16:26.864558', 0, 26, 445, 2, NULL, NULL, 0, 23423535, 1, 33, 1, 0, 0, 23423568),
(771, '2025-12-30', '2025-12-27 06:16:26.881962', 0, 26, 414, 2, NULL, NULL, 0, 111, 0, 2222, 0, 0, 2, 0),
(772, '2025-12-31', '2025-12-27 06:16:26.897042', 0, 26, 431, 2, NULL, NULL, 0, 111, 1, 2222, 0, 0, 0, 111),
(773, '2025-12-31', '2025-12-27 06:16:26.905013', 0, 26, 451, 2, NULL, NULL, 0, 33333, 0, 66, 1, 0, 1, 66),
(774, '2025-12-31', '2025-12-27 06:16:26.920701', 0, 26, 441, 2, NULL, NULL, 0, 444444, 0, 77, 1, 0, 0, 77),
(775, '2025-12-31', '2025-12-27 06:16:26.929052', 0, 26, 436, 2, NULL, NULL, 0, 50000, 0, 100000, 0, 0, 1, 0),
(776, '2026-01-01', '2025-12-27 06:16:26.937732', 0, 26, 446, 2, NULL, NULL, 0, 23423535, 1, 33, 0, 0, 0, 23423535),
(777, '2026-01-01', '2025-12-27 06:16:26.945490', 0, 26, 417, 2, NULL, NULL, 0, 50000, 0, 100000, 1, 0, 1, 100000),
(778, '2026-01-01', '2025-12-27 06:16:26.960933', 0, 26, 427, 2, NULL, NULL, 0, 121, 0, 88, 1, 0, 0, 88),
(779, '2026-01-01', '2025-12-27 06:16:26.967526', 0, 26, 420, 2, NULL, NULL, 0, 444444, 0, 77, 1, 0, 1, 77),
(780, '2026-01-02', '2025-12-27 06:16:26.983452', 0, 26, 432, 2, NULL, NULL, 0, 111, 1, 2222, 0, 0, 1, 111),
(781, '2026-01-02', '2025-12-27 06:16:26.992807', 0, 26, 452, 2, NULL, NULL, 0, 33333, 0, 66, 0, 0, 1, 0),
(782, '2026-01-02', '2025-12-27 06:16:27.000260', 0, 26, 415, 2, NULL, NULL, 0, 111, 0, 2222, 1, 0, 0, 2222),
(783, '2026-01-02', '2025-12-27 06:16:27.007507', 0, 26, 412, 2, NULL, NULL, 0, 121, 0, 88, 1, 0, 0, 88);

-- --------------------------------------------------------

--
-- Table structure for table `users_gender`
--

CREATE TABLE `users_gender` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `title` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_gender`
--

INSERT INTO `users_gender` (`code`, `title`) VALUES
(3, 'دوجنسی/نامشخص'),
(2, 'زن'),
(1, 'مرد'),
(4, 'نامشخص');

-- --------------------------------------------------------

--
-- Table structure for table `users_holding`
--

CREATE TABLE `users_holding` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `location` varchar(200) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `manager_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_holding`
--

INSERT INTO `users_holding` (`id`, `name`, `location`, `created_at`, `manager_id`) VALUES
(1, 'هلدینگ اصفهان مقدم', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-28 08:28:06.000000', 26),
(3, 'هلدینگ تست 2', 'خیابان هشتم2 شهرک صنعتی سه راهی مبارکه', '2025-10-28 10:25:18.382428', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_jobgroup`
--

CREATE TABLE `users_jobgroup` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_jobgroup`
--

INSERT INTO `users_jobgroup` (`code`, `name`) VALUES
(13, 'اتباع خارجه'),
(4, 'بازنشستگان'),
(31, 'بیماران خاص'),
(32, 'بیماران صعب العلاج'),
(25, 'بیمه شدگان هما'),
(17, 'جانباز'),
(1, 'جانبازان معزز 70درصد'),
(23, 'جانبازان معزز شیمیایی شدید'),
(24, 'جانبازان معزز شیمیایی متوسط'),
(14, 'خانواده جانباز'),
(11, 'خانواده شهيد'),
(16, 'خانواده فوتی'),
(18, 'درمان خانواده'),
(7, 'روحانيون و کادر پزشکي و عوامل اجرايي حج'),
(8, 'زائرين'),
(22, 'سایر'),
(3, 'شاغلين'),
(10, 'شهيد'),
(29, 'صندوق آینده ساز شرکت سایپا'),
(9, 'عوامل ستادي و اجرائي حج'),
(30, 'مدیران ارشد'),
(5, 'مستمري بگيران'),
(27, 'همسران شهدای بالای 60 سال'),
(6, 'وظيفه بگيران'),
(15, 'کارکنان اناث'),
(26, 'گروه اشخاص والدین شهدا'),
(28, 'یاس');

-- --------------------------------------------------------

--
-- Table structure for table `users_maritalstatus`
--

CREATE TABLE `users_maritalstatus` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_maritalstatus`
--

INSERT INTO `users_maritalstatus` (`code`, `name`) VALUES
(3, 'سایر'),
(2, 'متاهل'),
(1, 'مجرد');

-- --------------------------------------------------------

--
-- Table structure for table `users_menuitem`
--

CREATE TABLE `users_menuitem` (
  `id` bigint(20) NOT NULL,
  `day_persian` varchar(10) NOT NULL,
  `weekly_menu_id` bigint(20) NOT NULL,
  `food_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_menuitem`
--

INSERT INTO `users_menuitem` (`id`, `day_persian`, `weekly_menu_id`, `food_id`) VALUES
(367, '2shanbe', 17, 5),
(355, '4shanbe', 17, 5),
(356, '4shanbe', 17, 6),
(353, '3shanbe', 17, 7),
(354, '5shanbe', 17, 7),
(349, 'jome', 17, 8),
(350, '3shanbe', 17, 9),
(351, 'jome', 17, 9),
(352, '5shanbe', 17, 10),
(421, '4shanbe', 19, 5),
(422, '2shanbe', 19, 6),
(423, '4shanbe', 19, 6),
(418, '1shanbe', 19, 7),
(419, '3shanbe', 19, 7),
(420, '5shanbe', 19, 7),
(412, 'jome', 19, 8),
(411, 'shanbe', 19, 8),
(414, '3shanbe', 19, 9),
(415, 'jome', 19, 9),
(413, 'shanbe', 19, 9),
(416, '1shanbe', 19, 10),
(417, '5shanbe', 19, 10),
(444, '2shanbe', 20, 5),
(445, '3shanbe', 20, 5),
(446, '5shanbe', 20, 5),
(443, 'shanbe', 20, 5),
(448, '1shanbe', 20, 6),
(449, '2shanbe', 20, 6),
(450, '3shanbe', 20, 6),
(451, '4shanbe', 20, 6),
(452, 'jome', 20, 6),
(447, 'shanbe', 20, 6),
(439, '1shanbe', 20, 7),
(440, '2shanbe', 20, 7),
(441, '4shanbe', 20, 7),
(442, 'jome', 20, 7),
(438, 'shanbe', 20, 7),
(425, '2shanbe', 20, 8),
(426, '3shanbe', 20, 8),
(427, '5shanbe', 20, 8),
(424, 'shanbe', 20, 8),
(429, '2shanbe', 20, 9),
(430, '3shanbe', 20, 9),
(431, '4shanbe', 20, 9),
(432, 'jome', 20, 9),
(428, 'shanbe', 20, 9),
(434, '1shanbe', 20, 10),
(435, '2shanbe', 20, 10),
(436, '4shanbe', 20, 10),
(437, '5shanbe', 20, 10),
(433, 'shanbe', 20, 10);

-- --------------------------------------------------------

--
-- Table structure for table `users_notification`
--

CREATE TABLE `users_notification` (
  `id` bigint(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification`
--

INSERT INTO `users_notification` (`id`, `title`, `description`, `created_at`, `expires_at`, `is_active`, `created_by_id`) VALUES
(2, 'شششش', 'ششششش', '2025-12-16 11:30:13.391837', '2025-12-15 20:30:00.000000', 1, 26),
(3, 'ششش', 'ششششش', '2025-12-16 11:32:34.443190', '2025-12-16 20:30:00.000000', 1, 26),
(4, 'یه اعلان تست', 'اعلان تست', '2025-12-16 11:42:04.443991', '2025-12-15 20:30:00.000000', 1, 26);

-- --------------------------------------------------------

--
-- Table structure for table `users_notificationread`
--

CREATE TABLE `users_notificationread` (
  `id` bigint(20) NOT NULL,
  `read_at` datetime(6) NOT NULL,
  `employee_id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_employee_subdepartments`
--

CREATE TABLE `users_notification_employee_subdepartments` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `subdepartment_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification_employee_subdepartments`
--

INSERT INTO `users_notification_employee_subdepartments` (`id`, `notification_id`, `subdepartment_id`) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 4),
(5, 3, 5),
(6, 3, 6),
(7, 3, 7),
(8, 3, 8),
(9, 3, 9),
(10, 3, 10),
(11, 3, 11),
(12, 3, 12),
(13, 3, 13),
(14, 3, 14),
(15, 3, 15),
(16, 3, 16),
(17, 3, 17),
(18, 3, 18),
(19, 3, 19),
(20, 3, 20);

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_target_departments`
--

CREATE TABLE `users_notification_target_departments` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `department_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification_target_departments`
--

INSERT INTO `users_notification_target_departments` (`id`, `notification_id`, `department_id`) VALUES
(1, 3, 2),
(2, 3, 5),
(3, 3, 6),
(4, 3, 7),
(5, 3, 8),
(6, 3, 9),
(7, 3, 10),
(8, 3, 11),
(9, 3, 12),
(10, 3, 13),
(11, 3, 14),
(12, 3, 16),
(13, 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_target_factories`
--

CREATE TABLE `users_notification_target_factories` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `factory_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification_target_factories`
--

INSERT INTO `users_notification_target_factories` (`id`, `notification_id`, `factory_id`) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 4),
(5, 3, 5),
(6, 3, 6),
(7, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_target_holdings`
--

CREATE TABLE `users_notification_target_holdings` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `holding_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification_target_holdings`
--

INSERT INTO `users_notification_target_holdings` (`id`, `notification_id`, `holding_id`) VALUES
(1, 3, 1),
(2, 3, 3),
(3, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_target_roles`
--

CREATE TABLE `users_notification_target_roles` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_notification_target_subdepartments`
--

CREATE TABLE `users_notification_target_subdepartments` (
  `id` bigint(20) NOT NULL,
  `notification_id` bigint(20) NOT NULL,
  `subdepartment_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_notification_target_subdepartments`
--

INSERT INTO `users_notification_target_subdepartments` (`id`, `notification_id`, `subdepartment_id`) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 4),
(5, 3, 5),
(6, 3, 6),
(7, 3, 7),
(8, 3, 8),
(9, 3, 9),
(10, 3, 10),
(11, 3, 11),
(12, 3, 12),
(13, 3, 13),
(14, 3, 14),
(15, 3, 15),
(16, 3, 16),
(17, 3, 17),
(18, 3, 18),
(19, 3, 19),
(20, 3, 20);

-- --------------------------------------------------------

--
-- Table structure for table `users_orgunit`
--

CREATE TABLE `users_orgunit` (
  `id` bigint(20) NOT NULL,
  `unit_type` varchar(20) NOT NULL,
  `path_key` varchar(100) NOT NULL,
  `department_id` bigint(20) DEFAULT NULL,
  `factory_id` bigint(20) DEFAULT NULL,
  `holding_id` bigint(20) DEFAULT NULL,
  `subdepartment_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_orgunit`
--

INSERT INTO `users_orgunit` (`id`, `unit_type`, `path_key`, `department_id`, `factory_id`, `holding_id`, `subdepartment_id`) VALUES
(7, 'department', 'department-0-0-16-0', 16, NULL, NULL, NULL),
(8, 'system', 'system-0-0-0-0', NULL, NULL, NULL, NULL),
(11, 'department', 'department-0-0-5-0', 5, NULL, NULL, NULL),
(12, 'holding', 'holding-1-0-0-0', NULL, NULL, 1, NULL),
(13, 'factory', 'factory-3-5-0-0', NULL, 5, 3, NULL),
(14, 'subdepartment', 'subdepartment-0-0-0-1', NULL, NULL, NULL, 1),
(18, 'employee', 'employee-0-0-0-1', NULL, NULL, NULL, 1),
(20, 'subdepartment', 'subdepartment-0-0-0-2', NULL, NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `users_participation`
--

CREATE TABLE `users_participation` (
  `id` bigint(20) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `file_size` int(10) UNSIGNED DEFAULT NULL CHECK (`file_size` >= 0),
  `user_id` bigint(20) NOT NULL,
  `feedback` longtext NOT NULL,
  `is_finalized` tinyint(1) NOT NULL,
  `status` varchar(30) NOT NULL,
  `text_content` longtext DEFAULT NULL,
  `factory_id` bigint(20) DEFAULT NULL,
  `summarized_content` longtext DEFAULT NULL,
  `orginal_content` longtext DEFAULT NULL,
  `count_sumerized` int(11) DEFAULT NULL,
  `department_id` bigint(20) DEFAULT NULL,
  `holding_id` bigint(20) DEFAULT NULL,
  `subdepartment_id` bigint(20) DEFAULT NULL,
  `role_name` varchar(200) DEFAULT NULL,
  `is_committee` tinyint(1) NOT NULL,
  `manager_feedback` longtext DEFAULT NULL,
  `manager_2_feedback` longtext DEFAULT NULL,
  `manager_3_feedback` longtext DEFAULT NULL,
  `department_committee_id` bigint(20) DEFAULT NULL,
  `factory_committee_id` bigint(20) DEFAULT NULL,
  `holding_committee_id` bigint(20) DEFAULT NULL,
  `subdepartment_committee_id` bigint(20) DEFAULT NULL,
  `manager_status` varchar(30) DEFAULT NULL,
  `manager_2_status` varchar(30) DEFAULT NULL,
  `manager_3_status` varchar(30) DEFAULT NULL,
  `supervisor_status` varchar(30) DEFAULT NULL,
  `supervisor_feedback` longtext DEFAULT NULL,
  `return_count` int(11) NOT NULL,
  `is_audio` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_participation`
--

INSERT INTO `users_participation` (`id`, `item_type`, `title`, `description`, `attachment`, `created_at`, `file_size`, `user_id`, `feedback`, `is_finalized`, `status`, `text_content`, `factory_id`, `summarized_content`, `orginal_content`, `count_sumerized`, `department_id`, `holding_id`, `subdepartment_id`, `role_name`, `is_committee`, `manager_feedback`, `manager_2_feedback`, `manager_3_feedback`, `department_committee_id`, `factory_committee_id`, `holding_committee_id`, `subdepartment_committee_id`, `manager_status`, `manager_2_status`, `manager_3_status`, `supervisor_status`, `supervisor_feedback`, `return_count`, `is_audio`) VALUES
(1, 'performance_file', 'گزارش روزانه 27-05-1403', 'توضیحات ندارد', 'participations/100500.jpg', '2025-09-26 07:41:41.177602', 106035, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(2, 'work_experience', 'ارسال صورت جلسه کمیته ها', 'بنا به درخواست مدیریت کارخانه', 'participations/2025/09/26/yasin.mp4', '2025-09-26 07:50:24.369345', 72762459, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(3, 'critiques', 'انتقاد', 'انتقاد از خودم', 'participations/2025/09/26/forprint.pdf', '2025-09-26 08:25:37.303011', 63345, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(4, 'suggestions', 'تست', 'برای تست', 'participations/2025/09/26/800.jpg', '2025-09-26 09:25:41.669615', 114856, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(5, 'meeting_minutes', 'صورت جلسه نهایی', 'برای تست', 'participations/2025/09/26/224.mp3', '2025-09-26 15:08:37.924913', 2008324, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(6, 'work_experience', 'تست 2', 'برای تست', 'participations/2025/09/27/1.html', '2025-09-27 04:53:42.372419', 262675, 3, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(7, 'suggestions', 'عملکردامروز', 'توضیحات تستنی', 'participations/2025/09/28/224.mp3', '2025-09-28 02:23:54.715361', 2008324, 12, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(8, 'suggestions', 'یبیب', 'سیبیسب', 'participations/2025/09/28/2525.csv', '2025-09-28 02:24:28.622525', 453257, 12, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(9, 'performance_file', 'یسبسی', 'بیسب', 'participations/2025/09/28/6363.jpg', '2025-09-28 02:24:51.087753', 55543, 12, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(10, 'work_experience', 'dfsgsd', 'sdgsd', 'participations/2025/09/28/yasin.mp4', '2025-09-28 02:40:06.900656', 72762459, 11, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(11, 'critiques', 'sdgsdg', 'sdgsdg', 'participations/2025/09/28/300.jpg', '2025-09-28 02:40:21.634909', 686563, 11, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(12, 'suggestions', 'dsfsd', 'dsfds', 'participations/2025/09/28/6363_vccS3bl.jpg', '2025-09-28 02:42:00.212657', 55543, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(13, 'critiques', 'sadfs', 'fdsf', 'participations/2025/09/28/6363_qlo4V3T.jpg', '2025-09-28 02:44:26.803352', 55543, 8, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(14, 'performance_file', 'xcfgc', 'fdgf', 'participations/2025/09/28/1.txt', '2025-09-28 05:20:07.223698', 9250, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(15, 'performance_file', 'تست فرمت', 'بریا تست فرمت ذخیره شده', 'participations/2025/09/28/WhatsApp_Ptt_2025-09-24_at_4.20.20_PM.ogg', '2025-09-28 07:31:32.924874', 72779, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(16, 'work_experience', 'تست فرمت 2', 'یسب', 'participations/2025/09/28/WhatsApp_Ptt_2025-09-24_at_4_fxgORTU.20.20_PM.ogg', '2025-09-28 07:39:39.895618', 72779, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(17, 'meeting_minutes', 'سی5252', 'سشیس', 'participations/2025/09/28/participations/2025/09/28/WhatsApp_Ptt_2025-09-24_at__5iiCOX7.20.20_PM.mp3', '2025-09-28 07:43:12.657036', 257708, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(18, 'work_experience', 'تست تبدیل فرمت 2', 'یسبیسب', 'participations/2025/09/28/participations/2025/09/28/Voice_250928_144813.mp3', '2025-09-28 07:49:15.235648', 215084, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(19, 'suggestions', 'تتست اقای معاصدی', 'یسبلی', 'participations/2025/09/28/participations/2025/09/28/WhatsApp_Audio_2025-09-28_at_3.28.18_PM.mp3', '2025-09-28 08:31:06.339590', 488108, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(20, 'meeting_minutes', 'تست ذخیره', 'تبدیل صوت به متن و mp3', 'participations/2025/09/30/WhatsApp_Audio_2025-09-28_at_3.28.18_PM.mp3', '2025-09-30 01:29:36.676875', 488108, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(21, 'meeting_minutes', 'تست سرعت', 'ندارد', 'participations/2025/09/30/participations/2025/09/30/WhatsApp_Ptt_2025-09-24_at_4.20.20_PM.mp3', '2025-09-30 01:43:15.986176', 257708, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(22, 'work_experience', 'تست سرع حجم بالا', 'یبی', 'participations/2025/09/30/participations/2025/09/30/صدا_۰۰۱.mp3', '2025-09-30 01:57:52.760323', 44999801, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(23, 'meeting_minutes', 'تست انواع فرمت ها', 'یسی', 'participations/2025/09/30/WhatsApp_Video_2025-05-29_at_11.06.161_2_2_1.mp4', '2025-09-30 02:15:32.431743', 4073243, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(24, 'meeting_minutes', 'تست انواع', 'سسشبسش', 'participations/2025/09/30/participations/2025/09/30/Voice_250928_144813.mp3', '2025-09-30 02:16:14.243914', 215084, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(25, 'work_experience', 'تست تبدیل متن', 'یبیب', 'participations/2025/09/30/participations/2025/09/30/Voice_250928_144813_hCoueq1.mp3', '2025-09-30 03:32:15.679066', 215084, 11, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(26, 'performance_file', 'فلو1', 'یب', 'participations/2025/09/30/participations/2025/09/30/Voice_250928_144813_6bwer8J.mp3', '2025-09-30 03:49:32.453902', 215084, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(27, 'meeting_minutes', 'فلو2', 'ب', 'participations/2025/09/30/Voice_250928_144813.mp3', '2025-09-30 04:22:44.896193', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(28, 'work_experience', 'فلو3', 'بیسب', 'participations/2025/09/30/participations/2025/09/30/Voice_250928_144813_jM4IWQa.mp3', '2025-09-30 04:33:59.529062', 215084, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(29, 'work_experience', 'سی', 'سیسی', 'participations/2025/09/30/participations/2025/09/30/55.mp3', '2025-09-30 04:36:09.705799', 257708, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(30, 'work_experience', 'بیب', 'یبی', 'participations/2025/09/30/participations/2025/09/30/صدا_۰۰۱_9iMLIlv.mp3', '2025-09-30 04:54:21.846160', 44999801, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(31, 'work_experience', 'تست مسیر', 'سیس', 'participations/2025/09/30/Voice_250928_144813_PcRtkK2.mp3', '2025-09-30 04:57:20.959282', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(32, 'meeting_minutes', 'تشت مسیر 2', 'ی', 'participations/2025/09/30/participations/2025/09/30/200.mp3', '2025-09-30 04:58:25.299121', 215084, 9, 'بدون فیدبک', 0, 'user_review', 'سلام یک تست امروز ششم مهر ماه ۱۴۰۴ ما در قسمت هوش مصنوعی کارخانه اسلام مقدم هستیم و در حال روی در حال پروژه‌ای برای پلتفرم تبدیل تکست به متن هستیم و برگزاری جلسات قسمت‌های مختلف', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(33, 'work_experience', 'تست مسیر 3', 'یسیس', 'participations/2025/09/30/55.mp3', '2025-09-30 05:05:48.207108', 257708, 9, 'بدون فیدبک', 0, 'user_review', 'لطفاً شماره تلفن خانم دکتر جوانه را در اختیار اینجانب قرار دهید. همچنین، شماره تلفن حاج آقا مقدم را بفرمایید و ذکر نمایید که بنده ایشان را می‌شناسم. در این حوزه، با توجه به اینکه مسئولیت هوش مصنوعی و امور مرتبط را بر عهده دارید، لطفاً به ایشان اطلاع دهید که چگونه می‌توان اقدامات بعدی را در خصوص وامی که خانم احمدی در مورد ۵۰ میلیارد تومان صحبت کرد، پیگیری نمود. سپاسگزارم. موفق باشید.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(34, 'critiques', 'تست دکمه 1', 'ندارد', 'participations/2025/09/30/WhatsApp_Audio_2025-09-28_at_3.28.18_PM.mp4', '2025-09-30 05:15:24.154092', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'در مورد سمینار نهم صحبت می‌کنیم. یکی از موارد مهم، تست هدست و پاورپوینت پیش از آغاز جلسه است تا از عملکرد صحیح آن‌ها اطمینان حاصل شود. پذیرایی صبحانه را با گوجه گیلاسی تدارک دیده‌ایم که شرکت‌کنندگان شخصاً از بوفه دریافت خواهند کرد. لازم به ذکر است در میانه جلسه، ارائه شیرینی یا میان‌وعده دیگری پیش‌بینی نشده است. هماهنگی نهایی و تحویل به موقع تجهیزات بر عهده تیم اجرایی خواهد بود.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(35, 'suggestions', 'تست دکمه 3', 'یب', 'participations/2025/09/30/WhatsApp_Audio_2025-09-28_at_3_bxEYQdP.28.18_PM.mp4', '2025-09-30 05:31:55.938459', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(36, 'performance_file', 'تست دکمه 3', 'یبیب', 'participations/2025/09/30/WhatsApp_Ptt_2025-09-24_at_4.20.20_PM.mp3', '2025-09-30 14:22:08.774420', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(37, 'meeting_minutes', 'تست دکمه 4', 'سیبس', 'participations/2025/09/30/صدا_۰۰۱_1.mp3', '2025-09-30 14:27:20.800823', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(38, 'work_experience', 'تست دکمه6', 'سیس', 'participations/2025/09/30/WhatsApp_Audio_2025-09-28_at_3_tSxnScs.28.18_PM.mp4', '2025-09-30 14:49:14.370804', NULL, 9, 'رد شد ', 1, 'rejected', 'ما در مورد سمینار نهم صحبت می‌کنیم. یکی از موارد مهم این است که هدست قبل از جلسه حتماً تست شده باشد. پاورپوینت سمینار نیز باید تست شده باشد. اگر ساعت ۵ صبح پاورپوینت کار نکند، چه می‌شود؟ برای پذیرایی چه کارهایی انجام داده‌اید؟ صبحانه را توضیح دهید. گوجه گیلاسی را خودش بردارد. ما انجام می‌دهیم. خوب، خیلی عالی، دستتان درد نکند.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(39, 'meeting_minutes', 'تست دکمه8', 'سی', 'participations/2025/09/30/99.mp3', '2025-09-30 14:54:57.393954', NULL, 1, 'بدون فیدبک', 1, 'supervisor_review', ' سلام این یک تست امروز شیشمه نه ماه هزار سال ساعت چهاره ما در قسمت حوش مصنوعی کارخانه استان مقدم هستیم و در حال روی در حال کار روی پروژه برای پلت فارم تبدیل تکست به مد هستیم و برگزایی جلسات قسمت های مختلف', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(40, 'meeting_minutes', 'تست 10', 'سیس', 'participations/2025/09/30/99_qsHPfz4.mp3', '2025-09-30 15:11:23.502350', NULL, 1, 'بدون فیدبک', 0, 'user_review', 'امروز ششم مهرماه ۱۴۰۴، در بخش هوش مصنوعی کارخانه اسلام مقدم، روی پروژه پلتفرم تبدیل متن به متن کار می‌کنیم و جلسات قسمت‌های مختلف را برگزار می‌کنیم.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(41, 'performance_file', 'تست 11', 'سیس', 'participations/2025/09/30/WhatsApp_Ptt_2025-09-24_at_4_ao6CgXe.20.20_PM.mp3', '2025-09-30 15:15:42.425836', 257708, 9, 'بدون فیدبک', 1, 'user_review', 'شماره تلفن خانم دکتر جوانه که میتونید بفرمایید هم شماره حاج آقا مقدم و میتونید بگید بنده میشناسه و بفرمایید که تو این حوزه می خوام با توجه به اینکه مسئولیت هوش مصنوعی و اینا رو بر عهده دارید به ایشون بفرمایید که چگونه بابت اون وامی که خانم احمدی ۵۰ میلیارد صحبت کرد مثلا اقدامات بعدی ممنونم موفق باشید', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(42, 'performance_file', 'تست دکمه 15', 'تست دکمه 15', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at_4.20.20_PM.mp3', '2025-10-01 02:53:14.647715', 257708, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(43, 'performance_file', 'تست دکمه 16', 'سیسی', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3.28.18_PM.mp4', '2025-10-01 03:01:41.051842', NULL, 9, 'بدون فیدبک', 1, 'approved', 'در مورد سمینار نهم در حال صحبت هستیم. یکی از موارد مهم این است که هدست قبل از جلسه حتماً باید تست شده باشد. پاورپوینت سمینار نیز باید تست شده باشد. در صورتی که ساعت ۵ صبح پاورپوینت کار نکند، برای پذیرایی چه اقدامی انجام داده‌اید؟ در مورد صبحانه توضیح دهید. گوجه گیلاسی را خودمان برمی‌داریم و انجام می‌دهیم. خوب، خیلی عالی، دستتان درد نکند.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(44, 'work_experience', 'تست دکمه 20', 'یسبی', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_gD9FB6B.28.18_PM.mp4', '2025-10-01 03:05:48.836678', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(45, 'work_experience', 'تست دمکمه 21', 'سیبس', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-08_at_9.27.04_AM.mp3', '2025-10-01 03:10:05.587823', 675692, 9, 'بدون فیدبک', 0, 'user_review', 'دکتر سلام باورت میشه دکتر چیزی که الان می‌خوام بگم الان مثلاً باید حضوری بگم دیگه یه ماهه من می‌خوام به شما بگم یادم میره دیگه الان گفتم ویسشو بزارم که لااقل دیگه شما باید یاد من میره که آقا این موضوع اینجوری بود یعنی ۲۰ بار خواستم بگم یادم رفت دکتر من یه سری جزوه دارم سر کلاس های که میرم یعنی ویساشو گوش می‌کنم جزواتم نوشتم این جزوه ها دست نویسه و چون من با سرعت نوشتم خوش خط هم نیست خواناست ولی خوش خط نیست چه جور میتونم این همه جزوه دکتر در هوش مصنوعی آیا امکان وجود داره اصلا که ما بتونیم اینا تبدیلش کنم به متن تایپ شده ببخشید تلفن طولانی یکی زنگ زد ببینید دکتر ویس های کلاس هامو دارما ولی تو ویسا چون شاگردا لابلاش سوال میکنن دیگه اون حرف یکپارچه از دست میره ولی اون چیزی که خودم مثلاً می‌نویسم خب دیگه اونا را برداشتم وگرنه فایل های صوتی همه کلاسامو دارم اما مشکلش اینه که لابلاش بحث های حاشیه ای هم مطرح شده از طرف دانشجو یا حتی استاد.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(46, 'meeting_minutes', 'تست دکمه 25', 'سیس', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at__5iiCOX7.20.20_PM.mp3', '2025-10-01 03:15:40.506263', NULL, 8, 'بدون فیدبک', 0, 'user_review', 'شماره تلفن خانم دکتر جوانه که میتونید بفرمایید هم شماره حاج آقا مقدم و میتونید بگید بنده میشناسه و بفرمایید که تو این حوزه می خوام با توجه به اینکه مسئولیت هوش مصنوعی و اینا رو بر عهده دارید به ایشون بفرمایید که چگونه بابت اون وامی که خانم احمدی ۵۰ میلیارد صحبت کرد مثلا اقدامات بعدی ممنونم موفق باشید.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(47, 'work_experience', 'تست 26', 'نهدارد', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_Z44SSrp.28.18_PM.mp4', '2025-10-01 03:19:52.457693', NULL, 9, 'بدون فیدبک', 1, 'approved', 'در مورد سمینار نهم داریم صحبت می‌کنیم یکی از موارد مهم این هدست قبل از جلسه حتما باید تست شده باشه سمینار پاورپوینت باید تست شده باشه ساعت ۵ صبح پاورپوینت کار نکنه پذیرایی چیکار کردین صبحانه شما توضیح بدین گوجه گیلاسی خودش برداره انجام میدیم خوب خیلی عالی دستتون', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(48, 'work_experience', 'یبیب', 'یبیب', 'participations/2025/10/01/WhatsApp_Video_2025-05-29_at_11.06.161_2_2_2.mp4', '2025-10-01 03:20:41.445575', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(49, 'work_experience', 'یبی', 'بیبیب', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_p8a9qsH.28.18_PM.mp4', '2025-10-01 03:21:24.648038', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(50, 'meeting_minutes', 'تست فایل ی', 'بیبیب', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_ANEGUcj.28.18_PM.mp4', '2025-10-01 03:22:33.185892', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(51, 'work_experience', 'تست دکمه 30', 'برای تست', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3.28.18_PM.mp3', '2025-10-01 03:47:27.476903', NULL, 1, 'بدون فیدبک', 0, 'user_review', 'در سمینار نهم، تست هدست و پاورپوینت قبل از جلسه ضروری است تا مشکلی مانند کار نکردن پاورپوینت صبح ساعت ۵ پیش نیاید. برای پذیرایی، صبحانه شامل ساندویچ پنیر و گوجه گیلاسی است که شرکت‌کنندگان خود برمی‌دارند و کی جا می‌دهد و همراه انجام می‌شود. خیلی عالی؛ دستتان درد نکند.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(52, 'work_experience', 'تست فایل 13', 'سیبب', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_mFqxmu7.28.18_PM.mp3', '2025-10-01 04:34:36.081973', NULL, 1, 'بدون فیدبک', 0, 'user_review', 'در سمینار نهم، تأکید بر آزمایش هدست و پاورپوینت پیش از برگزاری جلسه است تا مشکلی مانند خرابی صبحگاهی رخ ندهد. برای پذیرایی، صبحانه شامل ساندویچ پنیر و گوجه‌فرنگی خواهد بود؛ کی فضا را فراهم و همراهی را مدیریت می‌کند. از زحمات تشکر می‌شود.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(53, 'work_experience', 'تست فایل 32', 'یبیب', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at_4_3kxuTYT.20.20_PM.mp3', '2025-10-01 04:48:35.740050', NULL, 1, 'بدون فیدبک', 0, 'user_review', 'لطفاً شماره تلفن خانم دکتر جوانه را ارائه دهید، همچنین شماره تلفن حاج آقا مقدم را؛ و بگویید که ایشان ما را می‌شناسد. لطفاً در این زمینه، با توجه به اینکه مسئولیت هوش مصنوعی و موارد مشابه را بر عهده دارید، به ایشان اطلاع دهید که چگونه اقدامات بعدی را در خصوص وامی که خانم احمدی در مورد ۵۰ میلیارد تومان صحبت کرد، انجام دهیم. ممنونم. موفق باشید.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(54, 'suggestions', 'تلاش 1', 'سشیشس', 'participations/2025/10/01/Bastani_AzarGol-haj_ein_allah-1404-7_2.pdf', '2025-10-01 04:50:22.458880', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(55, 'work_experience', 'فثسف فایل 14', 'سیسیس', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at_4_R0MeIAj.20.20_PM.mp3', '2025-10-01 05:32:25.925281', 257708, 1, 'بدون فیدبک', 0, 'user_review', 'شماره تلفن خانم دکتر جوانه را که می‌توانید ارائه دهید، همچنین شماره حاج آقا مقدم را؛ و می‌توانید بگویید که بنده ما را می‌شناسد. بفرمایید که در این حوزه، با توجه به اینکه مسئولیت هوش مصنوعی و امثال آن را بر عهده دارید، به ایشان اطلاع دهید که چگونه بابت آن وامی که خانم احمدی در مورد ۵۰ میلیارد تومان صحبت کرد، اقدامات بعدی را انجام دهیم. ممنونم. موفق باشید.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(56, 'work_experience', 'تست فایل 55', 'توضیحات', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at_4_4Shg7H6.20.20_PM.mp3', '2025-10-01 05:43:45.801503', 257708, 9, 'بدون فیدبک', 0, 'user_review', 'شماره تلفن خانم دکتر جوانه که میتونید بفرمایید هم شماره حاج آقا مقدم و میتونید بگید بنده میشناسه و بفرمایید که تو این حوزه می خوام با توجه به اینکه مسئولیت هوش مصنوعی و اینا رو بر عهده دارید به ایشون بفرمایید که چگونه بابت اون وامی که خانم احمدی ۵۰ میلیارد صحبت کرد مثلا اقدامات بعدی ممنونم موفق باشید', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(57, 'meeting_minutes', 'تست دکمه 55', 'سیسیس', 'participations/2025/10/01/WhatsApp_Ptt_2025-09-24_at_4_mF15DXu.20.20_PM.mp3', '2025-10-01 06:04:20.424790', 257708, 9, 'بدون فیدبک', 0, 'user_review', ' این شمارت الیفونه خانوم دوگتورت جایبانه که میتنید فرمه ایت هم شماره هجر مرددام و میتنید بگید بنده مرمیش نصی و به فرمه کتنی هوزیم خم این بطور اجب این کم اصولیاته اوشه مصنویی ایو این رو بار اخدی دارید بیشون بیفرمکی که چیگونه با بیتون با مکیخانه با احمدی پندرمیدی اتسوکاتیات مسندی ردامتی بایدی بایدی بایدی نم نام آثقش', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(58, 'work_experience', 'تست 8585', 'ندارد', 'participations/2025/10/01/200.mp3', '2025-10-01 06:12:51.301770', 215084, 9, 'بدون فیدبک', 0, 'user_review', ' سالام ایک تیسده نمیش شیشونه موه از ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(59, 'meeting_minutes', 'تست ترجمه 11', 'تست ترجمه', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_G4qp1lA.28.18_PM.mp4', '2025-10-01 06:51:49.682155', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(60, 'suggestions', 'تست ترجمه 10', 'ندارد', 'participations/2025/10/01/WhatsApp_Audio_2025-09-28_at_3_gH9xGzY.28.18_PM.mp4', '2025-10-01 23:50:29.365963', NULL, 9, 'بدون فیدبک', 1, 'supervisor_review', 'خیلی بد ترجمه شده ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(61, 'performance_file', 'تست ترجمه', 'تست فلو و ترجمه', 'participations/2025/10/02/200.mp3', '2025-10-02 00:41:33.717477', 215084, 15, 'بدون فیدبک', 1, 'approved', ' سالام ایک تیسده نمیش شیشونه موه از ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(62, 'suggestions', 'تست ترجمه 2', 'ندارد', 'participations/2025/10/02/200_OYbJwkG.mp3', '2025-10-02 00:52:46.428685', 215084, 9, 'بدون فیدبک', 1, 'approved', ' سالام ایک تیسده نمیش شیشونه موه از ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس ارس', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(63, 'meeting_minutes', 'تجزبه برنامه نوئیسی', 'ندادراد', 'participations/2025/10/04/a0c1d359f4902fcd33fda0b43abec60058438437-720p.mp4', '2025-10-04 07:50:03.359823', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(64, 'meeting_minutes', 'تست 110', 'برای دقت ترجمه', 'participations/2025/10/05/200.mp3', '2025-10-05 03:12:00.148229', 215084, 15, 'بدون فیدبک', 0, 'user_review', 'برای تست ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(65, 'suggestions', 'تست صدا در شلوغی', 'برای', 'participations/2025/10/05/Voice_251005_101054.mp3', '2025-10-05 03:14:06.837970', 148652, 15, 'بدون فیدبک', 1, 'super_admin_review', 'سلام ۱۳ شهریور ۱۳ مهر', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(66, 'suggestions', 'تست ترجمه در شلوغی 2', 'یبیبی', 'participations/2025/10/05/Interview_251005_101631.mp3', '2025-10-05 03:17:59.301855', 417644, 15, 'بدون فیدبک', 0, 'user_review', 'گوشی صدا اذیتشون نکند حالا ما هم به خاطر این قضیه', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(67, 'meeting_minutes', 'تست صدا رد شلوغی دو نفره 3ی', 'یبیب', 'participations/2025/10/05/Voice_251005_101903.mp3', '2025-10-05 03:20:10.454339', 186476, 15, 'بدون فیدبک', 0, 'user_review', 'استفاده کردی این از یه مدلی مربوط به خود لامائه حالا تبدیل فارسیشم مدل دیگه استفاده کرده خودش آموزش', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(68, 'suggestions', 'تست 4', 'یسبیسب', 'participations/2025/10/05/WhatsApp_Ptt_2025-09-24_at_4.20.20_PM.mp3', '2025-10-05 03:23:35.742304', 257708, 15, 'بدون فیدبک', 1, 'approved', 'شماره تلفن خانم دکتر جوانه که میتونید بفرمایید هم شماره حاج آقا مقدم و میتونید بگید بنده میشناسه و بفرمایید که تو این حوزه می خوام با توجه به اینکه مسئولیت هوش مصنوعی و اینا رو بر عهده دارید به ایشون بفرمایید که چگونه بابت اون وامی که خانم احمدی ۵۰ میلیارد صحبت کرد مثلا اقدامات بعدی ممنونم موفق باشید', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(69, 'work_experience', 'تست پاکسازی', 'تست پاکسازی', 'participations/2025/10/05/Voice_250928_144813.mp3', '2025-10-05 04:10:05.489848', 215084, 8, 'بدون فیدبک', 0, 'user_review', 'سلام یک تست امروز ششم مهر ماه ۱۴۰۴ ما در قسمت هوش مصنوعی کارخانه اسلام مقدم هستیم و در حال روی در حال پروژه‌ای برای پلتفرم تبدیل تکست به متن هستیم و برگزاری جلسات قسمت‌های مختلف.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(70, 'work_experience', 'تست پاکسازی 2', 'سیس', 'participations/2025/10/05/Voice_251005_110759.mp3', '2025-10-05 04:11:46.033930', 883628, 8, 'بدون فیدبک', 0, 'user_review', 'من دیروز رفتم یه پارک به جون دوتایی به خدا اگه دروغ بگم یه یارو داشت از درخت بالا می‌رفت اصلاً باورم نمی‌شد من این هاج و واج مونده بودم مگه میشه مگه داریم یارو رفته بود دنبال گربه من گربه هی اون بالا میو میو می‌کرد من نمی‌دونم آخه برای چی این تو این کارو داشتیم می‌کرد تو چیکار گربه داری حالا هی ما داشتیم گفتیم خره تو رو خدا بیا پایین گربه گناه داره زبون بسته خداست خدا لعنتت میکنه بعدش رفتیم نگهبان پارک گفتیم داره صداش در نمیاد ما هیچی به هیچی هرچی ما می‌گفتیم هیچکی گوش نمی‌داد نه نگهبان گوش میداد نه مردم کاری داشتن اصلاً گربه بنده خدا دیگه اصلاً صداش در نمیومد دیگه رفتیم یه چوب برداشتیم افتادیم به جون یارو بالا درخت می‌گفتیم بیا پایین بیا پایین تا نکشتم هیچی هیچی باورم نمیشد که اینطوریه چوبه رو پرت کردیم زدیم تو سرش زدیم تو دست و پاش هیچی گفتیم بابا بیا بیرون بیا پایین بیا پایین که گوش می‌دادین آره خلاصه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(71, 'work_experience', 'تست فایل حجم بالا', 'تست پارسا', 'participations/2025/10/05/WhatsApp_Audio_2025-10-05_at_10.52.58_16a14072.dat.mp3', '2025-10-05 04:58:22.228130', NULL, 8, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(72, 'work_experience', 'تجربه کاری عطر', 'تست', 'participations/2025/10/08/Voice_251005_110759.mp3', '2025-10-08 04:36:36.110914', 883628, 9, 'بدون فیدبک', 1, 'approved', 'دیروز به پارک رفتم. به جان دوتایی‌ام قسم، اگر دروغ بگویم، مردی داشت از درخت بالا می‌رفت. اصلاً باورم نمی‌شد؛ من کاملاً هاج و واج مانده بودم. مگر می‌شود؟ مگر داریم؟ آن مرد رفته بود دنبال گربه. گربه هم مدام از آن بالا میو میو می‌کرد. من نمی‌دانم، آخه برای چه این کار را می‌کرد؟ گربه به تو چه ربطی دارد؟ حالا ما مدام می‌گفتیم: «ای احمق، به خدا بیا پایین؛ گربه بی‌گناه است، زبون‌بسته خداست، خدا لعنتت کند.» بعدش رفتیم نزد نگهبان پارک و گفتیم، اما صدای گربه دیگر در نمی‌آمد. ما هیچ به هیچ؛ هرچه ما می‌گفتیم، هیچ‌کس گوش نمی‌داد؛ نه نگهبان توجه می‌کرد، نه مردم کاری داشتند. اصلاً گربه، بنده خدا، دیگر اصلاً صدایی از او در نمی‌آمد. دیگر رفتیم چوبی برداشتیم و افتادیم به جان آن مرد بالای درخت؛ می‌گفتیم: «بیا پایین، بیا پایین؛ تا نکشمت هیچی.» هیچی، باورم نمی‌شد که اوضاع این‌طوری باشد. چوب را پرت کردیم، زدیم به سرش، زدیم به دست و پایش؛ هیچی. می‌گفتیم: «بابا بیا بیرون، بیا پایین، بیا پایین.» که گوش می‌داد، آره. خلاصه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(73, 'work_experience', 'تست 2', 'رذزرذر', 'participations/2025/10/08/Voice_251005_110759_T9iUaos.mp3', '2025-10-08 07:26:52.859185', 883628, 11, 'بدون فیدبک', 0, 'user_review', 'دیروز به پارک رفتم. به جان دوتایی‌ام قسم، اگر دروغ بگویم، مردی داشت از درخت بالا می‌رفت. اصلاً باورم نمی‌شد؛ من کاملاً هاج و واج مانده بودم. مگر می‌شود؟ مگر داریم؟ آن مرد رفته بود دنبال گربه. گربه هم مدام از آن بالا میو میو می‌کرد. من نمی‌دانم، آخه برای چه این کار را می‌کرد؟ گربه به تو چه ربطی دارد؟ حالا ما مدام می‌گفتیم: «ای احمق، به خدا بیا پایین؛ گربه بی‌گناه است، زبون‌بسته خداست، خدا لعنتت کند.» بعدش رفتیم نزد نگهبان پارک و گفتیم، اما صدای گربه دیگر در نمی‌آمد. ما هیچ به هیچ؛ هرچه ما می‌گفتیم، هیچ‌کس گوش نمی‌داد؛ نه نگهبان توجه می‌کرد، نه مردم کاری داشتند. اصلاً گربه، بنده خدا، دیگر اصلاً صدایی از او در نمی‌آمد. دیگر رفتیم چوبی برداشتیم و افتادیم به جان آن مرد بالای درخت؛ می‌گفتیم: «بیا پایین، بیا پایین؛ تا نکشمت هیچی.» هیچی، باورم نمی‌شد که اوضاع این‌طوری باشد. چوب را پرت کردیم، زدیم به سرش، زدیم به دست و پایش؛ هیچی. می‌گفتیم: «بابا بیا بیرون، بیا پایین، بیا پایین.» که گوش می‌داد، آره. خلاصه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(74, 'meeting_minutes', 'تست تبدیل متن و پاکسازی 10', 'سیسی', 'participations/2025/10/08/test256.mp3', '2025-10-08 11:02:04.903499', 68972, 11, 'بدون فیدبک', 0, 'user_review', 'در حال حاضر در حال آزمایش رسمی‌سازی هستیم تا ببینیم وضعیت آن چگونه است و چه اتفاقی برایش می‌افتد و همین‌طور.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(75, 'meeting_minutes', 'اموزش دستگاه qc', 'جهت تست', 'participations/2025/10/11/New_Recording_9.mp3', '2025-10-11 04:03:00.311338', 11543660, 14, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(76, 'performance_file', 'بریا تست فلو2', 'ندارد', 'participations/2025/10/11/WhatsApp_Audio_2025-09-02_at_11.47.33_AM.mp4', '2025-10-11 04:22:20.612250', NULL, 15, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(77, 'meeting_minutes', 'تست فلو 454', 'لاتا', 'participations/2025/10/11/Voice_251005_110759.mp3', '2025-10-11 04:25:50.945145', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'دیروز به پارک رفتم. به جان دوتایی‌ام قسم می‌خورم، اگر دروغ بگویم، مردی در حال بالا رفتن از درخت بود. اصلاً باورم نمی‌شد؛ من کاملاً حیرت‌زده مانده بودم. مگر می‌شود؟ مگر چنین چیزی ممکن است؟ آن مرد برای نجات گربه به بالای درخت رفته بود. گربه مدام از بالای درخت میو میو می‌کرد. من نمی‌دانستم واقعاً برای چه این کار را می‌کرد. تو با گربه چه کار داری؟ حالا ما مدام می‌گفتیم: «ای احمق، به خدا بیا پایین؛ گربه بی‌گناه است، بی‌زبان است، خدا لعنتت کند.» بعدش به نگهبان پارک رفتیم و به او گفتیم، اما صدایش در نمی‌آمد. ما هیچ توجهی به ما نمی‌شد؛ هر چه ما می‌گفتیم، هیچ‌کس گوش نمی‌داد. نه نگهبان گوش می‌داد، نه مردم توجهی داشتند. اصلاً گربه بنده خدا دیگر صدایی در نمی‌آورد. دیگر رفتیم یک چوب برداشتیم و به جان آن مرد بالای درخت افتادیم. می‌گفتیم: «بیا پایین، بیا پایین.» تا نکشتم، هیچ. هیچ. باورم نمی‌شد که اوضاع این‌چنین باشد. چوب را پرت کردیم، به سرش زدیم، به دست و پایش زدیم. هیچ. می‌گفتیم: «بابا، بیا بیرون، بیا پایین، بیا پایین.» که گوش می‌دادند، آری. خلاصه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(78, 'meeting_minutes', 'تتسفلو 100', 'یبیبی', 'participations/2025/10/11/Voice_251005_110759_y1FPCKW.mp3', '2025-10-11 07:05:40.472799', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'من دیروز رفتم یه پارک به جون دوتایی به خدا اگه دروغ بگم یه یارو داشت از درخت بالا می‌رفت اصلاً باورم نمی‌شد من این هاج و واج مونده بودم مگه میشه مگه داریم یارو رفته بود دنبال گربه من گربه هی اون بالا میو میو می‌کرد من نمی‌دونم آخه برای چی این تو این کارو داشتیم می‌کرد تو چیکار گربه داری حالا هی ما داشتیم گفتیم خره تو رو خدا بیا پایین گربه گناه داره زبون بسته خداست خدا لعنتت میکنه بعدش رفتیم نگهبان پارک گفتیم داره صداش در نمیاد ما هیچی به هیچی هرچی ما می‌گفتیم هیچکی گوش نمی‌داد نه نگهبان گوش میداد نه مردم کاری داشتن اصلاً گربه بنده خدا دیگه اصلاً صداش در نمیومد دیگه رفتیم یه چوب برداشتیم افتادیم به جون یارو بالا درخت می‌گفتیم بیا پایین بیا پایین تا نکشتم هیچی هیچی باورم نمیشد که اینطوریه چوبه رو پرت کردیم زدیم تو سرش زدیم تو دست و پاش هیچی گفتیم بابا بیا بیرون بیا پایین بیا پایین که گوش می‌دادین آره خلاصه', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(79, 'critiques', '110120', 'mkjhkj', 'participations/2025/10/11/Voice_251005_110759_CR19Gku.mp3', '2025-10-11 11:26:53.790031', 883628, 9, 'رد شد تایید نشد ', 1, 'rejected', 'من دیروز رفتم یه پارک به جون دوتایی به خدا اگه دروغ بگم یه یارو داشت از درخت بالا می‌رفت اصلاً باورم نمی‌شد من این هاج و واج مونده بودم مگه میشه مگه داریم یارو رفته بود دنبال گربه من گربه هی اون بالا میو میو می‌کرد من نمی‌دونم آخه برای چی این تو این کارو داشتیم می‌کرد تو چیکار گربه داری حالا هی ما داشتیم گفتیم خره تو رو خدا بیا پایین گربه گناه داره زبون بسته خداست خدا لعنتت میکنه بعدش رفتیم نگهبان پارک گفتیم داره صداش در نمیاد ما هیچی به هیچی هرچی ما می‌گفتیم هیچکی گوش نمی‌داد نه نگهبان گوش میداد نه مردم کاری داشتن اصلاً گربه بنده خدا دیگه اصلاً صداش در نمیومد دیگه رفتیم یه چوب برداشتیم افتادیم به جون یارو بالا درخت می‌گفتیم بیا پایین بیا پایین تا نکشتم هیچی هیچی باورم نمیشد که اینطوریه چوبه رو پرت کردیم زدیم تو سرش زدیم تو دست و پاش هیچی گفتیم بابا بیا بیرون بیا پایین بیا پایین که گوش می‌دادین آره خلاصه', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(80, 'performance_file', 'test', 'p[,[fw[ef[ef[wefeee', 'participations/2025/10/13/test.mp3', '2025-10-13 05:51:34.536968', NULL, 9, 'بدون فیدبک', 1, 'approved', 'در حال آزمایش هستم؛ همه چیز برای آزمایش است تا متوجه شوم آیا عمل می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(81, 'performance_file', 'test arvin', 'test test', 'participations/2025/10/14/test.mp3', '2025-10-14 08:40:37.262320', NULL, 9, 'بدون فیدبک', 1, 'approved', 'در حال انجام آزمایش هستم؛ همه این آزمایش‌ها برای این است که بدانم آیا کار می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(82, 'performance_file', 'new test', 'این فقط یه تستس هستش', 'participations/2025/10/15/test.mp3', '2025-10-15 08:06:39.815753', NULL, 9, 'بدون فیدبک', 1, 'approved', 'آزمایش می‌کنم؛ تماماً برای آزمایش، تا بدانم آیا کار می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(83, 'performance_file', 'zxzxxz', 'zxzx', 'participations/2025/10/15/test2.mp3', '2025-10-15 08:44:50.655272', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'در حال آزمایش هستم؛ تمام این‌ها برای آزمایش است تا دریابم که آیا عمل می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(84, 'suggestions', 'ثصث', 'صثصث', 'participations/2025/10/15/test3.mp3', '2025-10-15 11:27:53.071700', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'در حال آزمایش هستم؛ تمام این‌ها برای آزمایش است تا دریابم که آیا عمل می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(85, 'performance_file', 'عغلشسیزذسشی', 'سشیزسیزسیز', 'participations/2025/10/15/New_Recording_11.mp3', '2025-10-15 11:33:13.023032', 25292396, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(86, 'performance_file', 'ثصب', 'صثبصثب', 'participations/2025/10/15/test4.mp3', '2025-10-15 11:40:01.138021', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'آزمایش می‌کنم؛ همه این‌ها صرفاً برای آزمایش است تا دریابم که آیا عمل می‌کند یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(87, 'work_experience', 'dfvdv', 'dfvdfvdfv', 'participations/2025/10/16/test4.mp3', '2025-10-16 10:06:50.812659', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'با تشکر از فرصتی که فراهم کردید. در ادامه، متن ویرایش‌شده را ملاحظه میفرمایید:\n\n**متن ویرایششده:**\n\nآزمایش می‌کنم. تمام این‌ها را جهت آزمایش انجام می‌دهم تا مشخص شود که آیا عملکرد دارد یا خیر.<｜begin▁of▁sentence｜>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(88, 'meeting_minutes', 'erge', 'ergergerg', 'participations/2025/10/16/test.mp3', '2025-10-16 10:14:01.332892', NULL, 9, 'بدون فیدبک', 1, 'supervisor_review', 'تست میکنم؛ تمامی این اقدامات صرفاً بهمنظور اطمینان از عملکرد صحیح سیستم و بررسی کارایی آن انجام میپذیرد.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(89, 'meeting_minutes', 'قلثقل', 'ثثقلثلث', 'participations/2025/10/18/test.mp3', '2025-10-18 12:28:10.108658', NULL, 8, 'بدون فیدبک', 0, 'user_review', 'آزمایش انجام می‌دهم. تمامی این اقدامات صرفاً برای بررسی عملکرد و اطمینان از صحت کارکرد سیستم صورت می‌گیرد.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(90, 'performance_file', 'مشارکت مدیر', '555', '', '2025-10-19 04:27:38.864917', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(91, 'work_experience', 'مممم', 'نتلهعم', 'participations/2025/10/19/test.mp3', '2025-10-19 04:30:26.325080', NULL, 1, 'بدون فیدبک', 1, 'user_review', 'تست سیستم برای اطمینان از عملکرد صحیح آن انجام شده است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(92, 'performance_file', 'wef', 'wefwef', '', '2025-10-19 05:10:15.501740', NULL, 8, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(93, 'work_experience', 'cvc', 'bcvbc', 'participations/2025/10/19/test2.mp3', '2025-10-19 05:11:39.576595', NULL, 8, 'بدون فیدبک', 1, 'user_review', 'این تست صرفاً برای آزمایش و اطمینان از عملکرد صحیح است تا فهمیده شود که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(94, 'suggestions', 'user', 'ghmgmg', 'participations/2025/10/19/test3.mp3', '2025-10-19 05:13:38.329820', NULL, 9, 'بدون فیدبک', 1, 'user_review', 'این تست صرفاً برای آزمایش و اطمینان از عملکرد صحیح است تا فهمیده شود که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(95, 'meeting_minutes', 'ewf', 'wefwf', 'participations/2025/10/19/test4.mp3', '2025-10-19 05:20:18.918461', NULL, 15, 'بدون فیدبک', 1, 'user_review', 'این تست برای فهمیدن کارکرد تست است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(96, 'performance_file', 'sdv', 'sdvsdv', 'participations/2025/10/19/test5.mp3', '2025-10-19 05:22:07.089968', NULL, 15, 'بدون فیدبک', 1, 'user_review', 'این متن صرفاً برای تست و ارزیابی عملکرد است تا اطمینان حاصل شود که همه چیز به درستی کار می‌کند.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(97, 'work_experience', 'sdv', 'sdvsdv', 'participations/2025/10/19/test6.mp3', '2025-10-19 05:24:30.688033', NULL, 15, 'بدون فیدبک', 1, 'user_review', 'این تست صرفاً برای اطمینان از عملکرد صحیح سیستم است تا از کارکرد آن مطمئن شویم.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(98, 'performance_file', 'test', 'dfbdfb', 'participations/2025/10/19/test7.mp3', '2025-10-19 05:34:34.454219', NULL, 15, 'بدون فیدبک', 1, 'user_review', 'این تست برای فهمیدن کارکرد سیستم است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(99, 'work_experience', 'ddd', 'sdvsdv', 'participations/2025/10/19/test8.mp3', '2025-10-19 05:39:32.686842', NULL, 15, 'بدون فیدبک', 1, 'user_review', 'این تست صرفاً برای آزمایش کارکرد سیستم است تا اطمینان حاصل شود که همه چیز به درستی عمل می‌کند.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(100, 'work_experience', 'svd', 'sdvsdv', 'participations/2025/10/19/test9.mp3', '2025-10-19 05:41:17.256985', NULL, 15, 'بدون فیدبک', 1, 'approved', 'این متن برای تست است و به منظور درک کارکرد سیستم می‌باشد.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(101, 'work_experience', 'user', 'sdvsv', 'participations/2025/10/19/test10.mp3', '2025-10-19 05:47:36.763230', NULL, 9, 'tessssssss', 1, 'rejected', 'من این تست را انجام می‌دهم تا بفهمم که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(102, 'work_experience', 'jk.k', 'kl.k.', 'participations/2025/10/19/test11.mp3', '2025-10-19 06:34:05.011933', NULL, 1, 'بدون فیدبک', 1, 'supervisor_review', 'این تست برای درک کارکرد فرآیند است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(103, 'work_experience', '22', '22', '', '2025-10-19 06:52:54.950778', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(104, 'meeting_minutes', 'sd', 'sdsd', 'participations/2025/10/19/test12.mp3', '2025-10-19 06:57:19.171059', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(105, 'performance_file', 'fgnb', 'fgnfgn', 'participations/2025/10/19/test12_Ap7FD6X.mp3', '2025-10-19 07:09:18.055748', 50156, 1, 'بدون فیدبک', 0, 'user_review', 'تست می‌کنم تا بفهمم که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(106, 'suggestions', 'qwdqwd', 'qwdqdwqwd', 'participations/2025/10/19/VID_20251019_104700.mp4', '2025-10-19 07:18:18.584318', NULL, 1, 'بدون فیدبک', 1, 'supervisor_review', 'خوب، تست می‌کنیم تا ببینیم که آیا پاسخ می‌دهد یا خیر؛ این نیز یک تست ویدیو است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(107, 'suggestions', 'wefwef', 'wefwefw', 'participations/2025/10/19/VID_20251019_104700_1EMJAz2.mp4', '2025-10-19 07:19:43.401968', NULL, 9, 'gjhmnghjm', 1, 'rejected', 'خوب، تست می‌کنیم تا ببینیم که آیا پاسخ می‌دهد یا خیر؛ این نیز یک تست ویدیو است.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(108, 'work_experience', 'test', 'aaaaaaaaa', 'participations/2025/10/20/test.mp3', '2025-10-20 09:27:59.691813', NULL, 9, '', 0, 'user_review', 'این تست فقط برای فهمیدن اینه که آیا کار می‌کنه یا نه.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(109, 'suggestions', 'rthrth', 'rthrhtrth', 'participations/2025/10/21/test.mp3', '2025-10-21 04:33:39.557565', NULL, 1, 'بدون فیدبک', 1, 'approved', 'این تست تنها برای درک چگونگی عملکرد است و هدف از آن، فهمیدن کارکرد صحیح سامانه می‌باشد.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(110, 'work_experience', 'yrj', 'tjtyj', 'participations/2025/10/21/test1.mp3', '2025-10-21 05:24:31.292730', NULL, 15, 'بدون فیدبک', 1, 'approved', 'این تست فقط برای آزمایش است تا بفهمم که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(111, 'work_experience', 'test 2', 'jk,', 'participations/2025/10/21/test2.mp3', '2025-10-21 05:27:05.992270', NULL, 15, 'بدون فیدبک', 1, 'approved', 'این تست، صرفاً برای آزمایش است تا بفهمم آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
INSERT INTO `users_participation` (`id`, `item_type`, `title`, `description`, `attachment`, `created_at`, `file_size`, `user_id`, `feedback`, `is_finalized`, `status`, `text_content`, `factory_id`, `summarized_content`, `orginal_content`, `count_sumerized`, `department_id`, `holding_id`, `subdepartment_id`, `role_name`, `is_committee`, `manager_feedback`, `manager_2_feedback`, `manager_3_feedback`, `department_committee_id`, `factory_committee_id`, `holding_committee_id`, `subdepartment_committee_id`, `manager_status`, `manager_2_status`, `manager_3_status`, `supervisor_status`, `supervisor_feedback`, `return_count`, `is_audio`) VALUES
(112, 'work_experience', 'person', 'ttt', 'participations/2025/10/21/test3.mp3', '2025-10-21 05:44:12.208079', NULL, 9, 'رد کردن تست', 1, 'rejected', 'این تست صرفاً برای آزمایش است تا بفهمم که آیا کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(113, 'performance_file', 'test neeww', 'asa', 'participations/2025/10/21/test4.mp3', '2025-10-21 05:56:00.243596', NULL, 9, 'ریپورت', 0, 'user_review', 'این یک تست است و هدف از آن درک این موضوع است که آیا everything به درستی کار می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(114, 'work_experience', 'مئ ئ', 'م ئکمک', 'participations/2025/10/21/Voice_251005_110759.mp3', '2025-10-21 08:04:41.629992', 883628, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(115, 'work_experience', 'sdfvsv', 'sdvsdvv', 'participations/2025/10/21/Voice_251005_110759Copy.mp3', '2025-10-21 09:04:01.973916', 883628, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(116, 'performance_file', 'gdd', 'ebvebves', '', '2025-10-21 09:31:33.516865', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(117, 'performance_file', 'فقا', 'قفاقفا', '', '2025-10-21 09:31:57.024451', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(118, 'work_experience', 'ehrer', 'thrthrthrth', 'participations/2025/10/21/Voice_251005_110759_FX8W1hB.mp3', '2025-10-21 10:32:37.200445', 883628, 9, 'بدون فیدبک', 0, 'user_review', 'من دیروز به یک پارک رفتم و دیدم یک نفر داشت از درخت بالا می‌رفت. او به دنبال یک گربه رفته بود که مرتباً میو میو می‌کرد. ما به او گفتیم که پایین بیاید و نگهبان پارک را در جریان قرار دادیم. اما او گوش نمی‌داد. ما چوب برداشتیم و به طرف او حمله کردیم تا سرانجام او را از درخت پایین آوردیم.', NULL, 'من دیروز به یک پارک رفتم و دیدم یک نفر داشت از درخت بالا می‌رفت. او به دنبال یک گربه رفته بود که مرتباً میو میو می‌کرد. ما به او گفتیم که پایین بیاید و نگهبان پارک را در جریان قرار دادیم. اما او گوش نمی‌داد. ما چوب برداشتیم و به طرف او حمله کردیم تا سرانجام او را از درخت پایین آوردیم.', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(119, 'work_experience', 'edbvf', 'dfbdfb', 'participations/2025/10/21/test6.mp3', '2025-10-21 11:49:28.175176', NULL, 9, 'بدون فیدبک', 1, 'supervisor_review', 'این تست برای فهمیدن کارکرد صحیح سیستم است و شامل داستان موش و گربه می‌شود.', NULL, 'این تست برای فهمیدن کارکرد صحیح سیستم است و شامل داستان موش و گربه می‌شود.', 'این تست برای فهمیدن کارکرد صحیح سیستم است.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(120, 'work_experience', 'تست', 'شسزشسز', 'participations/2025/10/21/test3_w4lVkmR.mp3', '2025-10-21 11:53:21.348199', 50156, 9, 'بدون فیدبک', 0, 'user_review', 'این تست برای فهمیدن کارکرد صحیح سیستم است. تست دوباره.', NULL, 'داستان موش و گربه یک داستان قدیمی است که در آن موش و گربه با هم دوست می‌شوند، اما در نهایت گربه موش را می‌خورد.', 'این تست برای فهمیدن کارکرد صحیح سیستم است.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(121, 'work_experience', 'سرمست', 'تست', 'participations/2025/10/22/2025_10_06_13_59حاج_اقا_فروش_با_پلیمر_و_حانوم_مقدم_18.mp3', '2025-10-22 04:34:45.114239', NULL, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(122, 'meeting_minutes', 'سرمست آتشنشانی', 'تست', 'participations/2025/10/22/اتش_نشانی-34.mp3', '2025-10-22 04:35:12.380018', NULL, 9, 'بدون فیدبک', 0, 'user_review', 'یک کمیته تصمیم‌گیرنده برای بررسی مسائل مرتبط با آتش‌نشانی تشکیل می‌شود که از مدیران واحدهای مختلف تشکیل شده است. این کمیته مسئول تدوین دستورالعمل‌های حفاظت، ایمنی و آتش‌نشانی است و باید آیین‌نامه و شرح وظایف خود را تدوین کند.\n\nبرای بهبود شرایط ایمنی، نصب سیستم اسپرینکلر دوگانه و طراحی و اجرای تخصصی با همکاری شرکت‌های دارای پروانه طراحی آتش‌نشانی پیشنهاد شده است. زیرساخت‌های آبرسانی اضطراری شامل شبکه توزیع آب و مخازن ذخیره ایجاد می‌شود. واحد سیار اطفاء حریق با ظرفیت مخزن آب و فوم و نصب پمپ فشارقوی ایجاد می‌شود و کمیته باید برآورد هزینه و زمان اجرای این طرح را حداکثر تا دو هفته آینده ارائه کند.', NULL, 'یک کمیته تصمیم‌گیرنده برای بررسی مسائل مرتبط با آتش‌نشانی تشکیل می‌شود که از مدیران واحدهای مختلف تشکیل شده است. این کمیته مسئول تدوین دستورالعمل‌های حفاظت، ایمنی و آتش‌نشانی است و باید آیین‌نامه و شرح وظایف خود را تدوین کند.\n\nبرای بهبود شرایط ایمنی، نصب سیستم اسپرینکلر دوگانه و طراحی و اجرای تخصصی با همکاری شرکت‌های دارای پروانه طراحی آتش‌نشانی پیشنهاد شده است. زیرساخت‌های آبرسانی اضطراری شامل شبکه توزیع آب و مخازن ذخیره ایجاد می‌شود. واحد سیار اطفاء حریق با ظرفیت مخزن آب و فوم و نصب پمپ فشارقوی ایجاد می‌شود و کمیته باید برآورد هزینه و زمان اجرای این طرح را حداکثر تا دو هفته آینده ارائه کند.', 'با توجه به ضرورت پیگیری و اجرایی کردن موضوع، پیشنهاد می‌شود هیئتی تصمیم‌گیرنده برای بررسی مسائل مرتبط با آتش‌نشانی تشکیل گردد. در این راستا، خانم رئیس در جلسه پیشین با عجله به موضوع پرداختند و بنده نیز ضمن بیان عدم اشکال در عدم استفاده از پیشنهاد ایشان، بر اهمیت توجه به جوانب اصلی تأکید نمودم. لازم است میزان حضور ذهن و قابلیت پیگیری موضوع از ابتدا تا انتها مورد ارزیابی قرار گیرد تا فعالیت‌های جانبی مانع از تحقق اهداف اصلی نشود.  \n\nدر جلسه بازدید اخیر از شهرک‌سازی، موارد متعددی یادداشت‌برداری شد که بر اساس ضوابط انجمن حفاظت و کدهای ایمنی موجود تنظیم گردید. با توجه به اینکه کمیته ایمنی فنی در شرکتها به صورت پراکنده فعالیت می‌نمایند، پیشنهاد شد چارچوبی واحد برای هماهنگی کلیه بخش‌ها تعریف شود. در این خصوص، مقرر گردید کمیته‌ای متشکل از مدیران واحدهای مختلف شامل آقای محمدی و خانم رئیسی تشکیل گردد. این تیم که بر اساس معیارهای تعیین‌شده در بازه زمانی مشخص فعالیت خواهد کرد، مسئولیت تدوین دستورالعمل‌های حفاظت، ایمنی و آتش‌نشانی را بر عهده خواهد داشت، در ادامه، ترکیب اعضای این کمیته و شرح وظایف آنان بر اساس گفت‌وگوهای پیشین مورد بررسی و تصویب نهایی قرار خواهد گرفت. در این راستا، ترکیب اعضای تیم می‌تواند به صورت دوره‌ای و متناسب با سطح همکاری افراد مورد بازنگری قرار گیرد. پیشنهاد می‌گردد اسامی افراد واجد شرایط بر اساس اولویت‌های ذیل ارائه شود:  \n\n۱. **ضرورت تخصص در حوزه آتش‌نشانی** به عنوان معیار اصلی  \n۲. **علاقه‌مندی و تعهد فعالانه** در واحد مربوطه  \n\nدر این زمینه، اسامی پیشنهادی شامل آقای خاکی، خانم رئیسی و نمایندگان تخصصی هر واحد می‌باشد. به عنوان مثال:  \n- نماینده بخش پلیمر: آقای قاسمی  \n- نماینده حوزه برق: آقای دوستی (با توجه به سوابق تخصصی در مباحث ایمنی)  \n- نماینده شهرک‌سازی: آقای وزیری (با در نظر گرفتن تجارب در شهرک‌های رازی و عطرسازی)  \n- نماینده واحد چاپ: آقای بختیاری (به عنوان سرپرست بخش)  \n\nلازم به ذکر است انتخاب نهایی اعضا مستلزم بررسی دقیق صلاحیت‌های فنی و انطباق با نیازهای کمیته خواهد بود، در مرحله بعدی، پیشنهادات تکمیلی و نهایی‌سازی ترکیب اعضا بر اساس معیارهای فوق انجام خواهد پذیرفت. در این راستا، پیشنهاد می‌گردد آقای سرمستم به عنوان دبیر کمیته جهت پیگیری مستمر امور معرفی شوند. انتخاب دبیر کمیته مستلزم تعهد و تخصص کافی در حوزه مربوطه بوده و بهتر است از میان افراد علاقه‌مند و فعال صورت پذیرد.  \n\nهمچنین مقرر شد آیین‌نامه و شرح وظایف دقیق این کمیته توسط آقای محمدی جمالی تدوین گردد تا فعالیت‌ها مبتنی بر چارچوبی مشخص پیش رود. این آیین‌نامه باید شامل سازوکار بازدیدهای دوره‌ای از شرکت‌های زیرمجموعه و الزامات نظارتی باشد. فهرست شرکت‌های مشمول به ترتیب اولویت شامل: شرکت گوهر، شرکت فرایند و سایر واحدهای مرتبط خواهد بود که می‌بایست حداقل هر شش ماه یکبار مورد ارزیابی قرار گیرند.  \n\nضمناً لازم است تدابیر امنیتی ویژه برای واحدهای پرخطر نظیر بخش‌های مرتبط با مواد شیمیایی در دستور کار قرار گیرد تا از وقوع هرگونه حادثه پیشگیری شود، کلیه تصمیمات اتخاذشده در این کمیته به صورت مکتوب و با مسئولیت پاسخگویی اعضا به مرحله اجرا خواهد رسید. فهرست واحدهای مشمول بازرسی شامل: شرکت پلیمر شبنم (خیابان ۳)، شرکت مقدم (خیابان ۸ و ۱۱)، شرکت پلیمر خیابانی ۱۱، کارگاه‌های مهدی مقدم، بازارچه توسن ۱ و ۲، شرکت رازی و شرکت ماهان شیمی قم می‌باشد. لازم است الگوهای موفق اجراشده در واحد توسن به سایر بخش‌ها نیز تسری یابد.  \n\nدر مورد صورتجلسات، انتظار می‌رود محتوای آن‌ها به صورت جامع و دقیق‌تر از یادداشت‌های فعلی تنظیم گردد، همچنین، هر یک از اعضای کمیته موظفند اطلاعات مورد نیاز واحد مربوطه را به شرح ذیل ارائه نمایند:  \n\n- ارائه نقشه کامل تأسیسات آتش‌نشانی همراه با مشخصات فنی و متراژ  \n- مستندسازی تجهیزات ایمنی موجود و برنامه‌های ارتقای آن  \n- گزارش دوره‌ای از اقدامات انجام‌شده و چالش‌های پیش‌رو  \n\nاین اطلاعات می‌بایست پیش از برگزاری جلسات آتی در اختیار دبیرخانه کمیته قرار گیرد تا امکان بررسی کارشناسی فراهم گردد.  \n\nلازم است استانداردهای ایمنی متناسب با نوع مواد مصرفی و سطح خطرپذیری هر واحد تدوین شود. به عنوان مثال، واحدهای فعال در حوزه گرانول، حلال‌ها یا چسب‌ها می‌بایست الزامات اختصاصی خود را دارا باشند. جانمایی ماشین‌آلات و تجهیزات نیز باید بر اساس ارزیابی ریسک و دستورالعمل‌های فنی صورت پذیرد.  \n\nهر واحد موظف است پرونده جامعی شامل موارد ذیل تهیه نماید:  \n۱. مشخصات فنی زمین و تراکم دستگاه‌ها  \n۲. نوع و حجم مواد اولیه مصرفی  \n۳. نقشه‌های تأییدشده توسط مراجع ذیصلاح (نظیر سازمان غذا و دارو، اداره صنایع و آتش‌نشانی)  \n۴، مستندات لوله‌کشی‌ها و شبکه‌های تأسیساتی  \n\nپس از تکمیل پرونده‌ها و جمع‌بندی نظرات کارشناسی، اقدامات تکمیلی و اصلاحی در دستور کار قرار خواهد گرفت. در این راستا، لازم است لیست تجهیزات و نیروی انسانی مورد نیاز هر واحد به تفکیک شیفت‌های کاری تدوین گردد. به عنوان نمونه، واحد مقدم با توجه به فعالیت سه شیفته می‌بایست برنامه‌ریزی دقیقی در توزیع پرسنل و سرپرستان هر شیفت داشته باشد.  \n\nاتاق کنترل مرکزی به عنوان هسته نظارتی می‌بایست به صورت ۲۴ ساعته فعال بوده و پرسنل آن از صلاحیت‌های فنی و اشراف کامل بر پروتکل‌های ایمنی برخوردار باشند. کلیه نگهبانان و پرسنل انتظامات نیز تحت پوشش سیستم کنترل یکپارچه قرار گرفته و می‌بایست آموزش‌های لازم را دریافت نمایند. به عنوان مثال، در واحد پلیمر خیابان ۷، هماهنگی کامل بین اتاق کنترل، نگهبانی و تیم‌های عملیاتی برقرار شده است.  \n\nانتخاب سرتیپ‌های هر شیفت و تعیین دقیق وظایف آنان باید در آیین‌نامه داخلی واحدها تصریح گردد، همچنین، نیازمندی‌های کلی و جزئی هر بخش می‌بایست به صورت مکتوب و قابل ارزیابی ثبت شود تا امکان نظارت مستمر فراهم گردد. در این راستا، دستورالعمل‌های تعمیرات ادواری و اساسی تجهیزات می‌بایست به دقت تدوین گردد. به عنوان مثال، برنامه زمان‌بندی شده ماهانه برای بازرسی ماشین‌آلات الزامی است.  \n\nکمیته مذکور مسئولیت تصمیم‌گیری در مورد واگذاری امور تخصصی به پیمانکاران خارجی یا تبادل نیروهای متخصص بین واحدها (نظیر انتقال موقت نیروها از واحد عطرسازی به سایر بخش‌ها) را نیز بر عهده خواهد داشت.  \n\nبا توجه به اولویت بررسی فوری واحد رازی، لازم است سازوکارهای همکاری بین واحدی در شرایط اضطراری به صورت ویژه مورد توجه قرار گیرد. این شامل تعیین دقیق شرح وظایف نمایندگان ایمنی، مسئولین کمیته و امکانات قابل بسیج در هر واحد می‌باشد، دستورالعمل جامع مدیریت بحران می‌بایست حاوی موارد ذیل باشد:  \n- فرآیند اعلام و اطلاع‌رسانی سریع حادثه  \n- فهرست نیروها و تجهیزات قابل اعزام از هر واحد  \n- نقشه راه‌های دسترسی و نقاط تجمیع  \n\nاین دستورالعمل که مستقل از آیین‌نامه اصلی کمیته تنظیم می‌گردد، می‌بایست توسط کلیه اعضا بررسی و پس از تأیید نهایی به مرحله اجرا گذاشته شود.  \n\nضروری است مسئولیت هر اقدام به صورت شفاف به فرد یا واحد مشخصی واگذار گردد و از طریق اخذ امضای ذی‌نفعان، جنبه تعهدآور پیدا نماید. این رویکرد از پراکندگی مسئولیت‌ها و عدم پاسخگویی جلوگیری می‌نماید.  \n\nتدوین چارچوب عملیاتی دقیق شامل شرح وظایف جامع برای هر نقش و آموزش‌های تخصصی متناسب با سناریوهای مختلف اضطراری، از ارکان اساسی موفقیت این سیستم است. به عنوان مثال، پروتکل تماس‌های اضطراری می‌تواند با بهره‌گیری از سیستم‌های هوشمند (نظیر هوش مصنوعی) به صورت خودکار شماره‌های ضروری را در اولویت ارتباطی قرار دهد.  \n\nپیشنهاد می‌گردد با ایجاد پایگاه داده متمرکز و یکپارچه‌سازی اطلاعات، زیرساخت لازم برای بهکارگیری فناوری‌های نوین فراهم شود، این اقدام ضمن افزایش دقت و سرعت عملیات، امکان تحلیل داده‌ها و بهینه‌سازی مستمر فرآیندها را نیز مهیا می‌سازد.  \n\nضروری است تیم‌های عملیاتی از تجهیزات مناسب (مانند جرثقیل به جای نردبان در شرایط خاص) برخوردار باشند تا از وقوع حوادث پیشگیری شود. تأمین به موقع امکانات و خودگردانی واحدها در اجرای پروتکل‌های ایمنی از اولویت‌های مدیریتی است.  \n\nدر واحد عطرسازی، تمرکز اصلی بر اجرای ۷۰ تا ۸۰ درصد استانداردهای رایج در صنعت کشور بوده و ۲۰ درصد باقیمانده به نوآوری‌های اختصاصی اختصاص خواهد یافت. این رویکرد ضمن حفظ ایمنی پایه، امکان برتری رقابتی را نیز فراهم می‌نماید.  \n\nنصب تجهیزات جدید (مانند دستگاه‌های باربری) می‌بایست با محاسبات دقیق فنی و مطابق با ظرفیت‌های واقعی صورت پذیرد. هرگونه اظهارنظر غیرکارشناسی که موجب ایجاد نگرانی بی‌مورد در پرسنل گردد، قابل پذیرش نیست، کلیه اقدامات ایمنی باید مبتنی بر استانداردهای ملی و با مستندات معتبر اجرایی گردد. در این راستا، رعایت الزامات پایه‌ای نظیر منع همراه داشتن تلفن همراه، پوشش لباس و کفش ایمنی، و اجتناب از استفاده از زیورآلات در محیط‌های پرخطر ضروری است. نظارت مستمر و شجاعت تذکر موارد تخلف توسط ناظران ایمنی نیز از ارکان کلیدی محسوب می‌شود.  \n\nبرنامه بهبود ایمنی به صورت مرحله‌ای و با اهداف کوتاه‌مدت (۲ ماهه)، میان‌مدت (۴ ماهه) و بلندمدت تدوین خواهد شد. در کوتاه‌مدت، تمرکز بر رفع نواقص آشکار و اجرای حداقلی استانداردها خواهد بود. در مراحل بعدی، ارتقای ۱۰ درصدی شاخص‌های ایمنی در هر بازه زمانی مدنظر است.  \n\nالگوبرداری از دو منبع زیر پیشنهاد می‌گردد:  \n۱. شرکت‌های داخلی پیشرو در حوزه ایمنی  \n۲. استانداردهای بین‌المللی و دستاوردهای انجمن‌های تخصصی اروپایی  \n\nاین ترکیب امکان بهره‌گیری از تجربیات بومی و هم‌زمان تطابق با معیارهای جهانی را فراهم می‌سازد، مطالعه تطبیقی این الگوها می‌تواند مسیر دستیابی به اهداف را تسریع نماید. در این زمینه، بازدید از واحدهای پیشرو داخلی (نظیر پتروشیمی‌ها و پالایشگاه‌ها) و تحلیل حوادث ثبت‌شده در آن‌ها می‌تواند به عنوان منبع ارزشمندی از تجربیات عملیاتی مورد استفاده قرار گیرد.  \n\nهمچنین بررسی طرح‌های ایمنی اجراشده توسط شرکت‌های اروپایی (نظیر نمونه‌های آلمانی و ایتالیایی) که ضریب ایمنی بالاتری را ارائه نموده‌اند، جهت انتخاب الگوی بهینه پیشنهاد می‌گردد.  \n\nدر مورد مسائل فنی خاص، مانند جانمایی سینی‌های کابل برق، ضروری است محل نصب به گونه‌ای انتخاب گردد که در صورت بروز اتصال کوتاه، خطر سرایت آتش به حداقل برسد. پیشنهاد می‌شود:  \n- انتقال سینی کابل به فاصله حداقل یک متر از دستگاه‌های اصلی  \n- تفکیک مدارهای برق هر بخش به صورت مستقل  \n- نصب محافظ‌های اضافی برای موتورهای حیاتی  \n\nاین اصلاحات ضمن کاهش ریسک، هزینه اجرایی قابل توجهی نیز نخواهد داشت، در صورت نیاز به ارائه جزئیات بیشتر یا هماهنگی‌های فنی، می‌توان با شماره تلفن ۰۹۱۳۱۱۸ (پسر بنده) تماس حاصل نمود.  \n\nدر مورد انتخاب ماشین‌آلات بسته‌بندی، با توجه به تجربه استفاده از نمونه‌های ایتالیایی و تفاوت محسوس کیفیت نسبت به محصولات چینی، پیشنهاد می‌گردد پس از تست نمونه‌ها و اخذ تأییدیه نهایی، نسبت به سفارش نهایی اقدام شود. قیمت‌گذاری نیز بر اساس نرخ روز و پس از تثبیت بازار صورت خواهد پذیرفت.  \n\nدر زمینه سیستم‌های برق‌رسانی، رویکرد فعلی مبتنی بر کابل‌کشی هوایی و استفاده از سینی‌کابل‌های اختصاصی برای هر دستگاه می‌باشد. این روش نسبت به سیستم قدیمی کابل‌کشی زیرزمینی (که مستعد نفوذ رطوبت و جوندگان بود) ارجحیت دارد، هر دستگاه می‌بایست مدار برق مستقل با ظرفیت متناسب با موتورهای خود داشته باشد و امکان توسعه ظرفیت نیز در طراحی پیش‌بینی گردد. در این راستا، استفاده از سیستم لدر (نردبان کابل) به جای سینی کابل به دلایل ذیل ترجیح داده می‌شود:  \n- امکان مشاهده و نظارت آسان بر کابل‌ها  \n- جلوگیری از تجمع مواد زائد و کاهش خطر آتش‌سوزی  \n\nهمچنین، اجرای همزمان سیستم ارت و رینگ زمینی با هزینه حدود یک میلیارد تومان انجام شده است که ضریب ایمنی تخلیه الکتریکی را به صورت قابل توجهی افزایش می‌دهد.  \n\nدر مورد پوشش کف سالن‌ها، با توجه به ریزش مکرر حلال‌ها، پوشش اپوکسی موجود مناسب نبوده و تعویض آن با سنگ گرانیت در محدوده مخازن در دست اجرا می‌باشد. این اقدام ضمن افزایش مقاومت شیمیایی، قابلیت شست‌وشوی بهتری نیز فراهم می‌نماید، فهرست دقیق بخش‌های نیازمند تعویض پوشش می‌بایست تا پایان هفته جاری ارائه گردد.  \n\nدر مورد جداسازی سالن‌ها، پیشنهاد می‌گردد از دیوارهای پیش‌ساخته ساندویچ پنل با هسته بتن مسلح (به جای شیشه) استفاده شود. این نوع دیوارها ضمن مقاومت بالا در برابر ضربه (حتی بیشتر از شیشه‌های ضدسرقت)، قابلیت عایق‌بندی حرارتی و جلوگیری از گسترش آتش را نیز دارا می‌باشند، نقشه اجرایی می‌بایست شامل موارد ذیل باشد:  \n- محدوده دقیق دیوارکشی (۲ متر قبل و بعد از دستگاه‌های خاص)  \n- موقعیت اتاق گاز و جداسازی کامل آن از سایر بخش‌ها  \n- مشخصات فنی پنل‌های مورد استفاده و اتصالات آن‌ها  \n\nاین اقدام ضمن ایجاد امنیت بیشتر، امکان نظارت بصری از طریق پنجره‌های تعبیه‌شده در دیوارها را نیز فراهم می‌نماید.  \n\nهمچنین، نصب دو درب اضطراری در محل‌های زیر پیشنهاد می‌گردد:  \n۱. ضلع جنوبی اتاق اسپری  \n۲. انتهای مخازن الکل  \n\nاین درب‌ها می‌بایست از نوع مقاوم (غیرچوبی) و با قابلیت بازشدن آسان به سمت بیرون طراحی شوند تا در شرایط اضطراری (حتی انفجار) امکان تخلیه سریع پرسنل فراهم گردد، اجرای این طرح با هماهنگی آقای حاجی و با حداقل تغییرات سازه‌ای امکان‌پذیر خواهد بود. در زمینه سیستم روشنایی، رعایت نکات ذیل الزامی است:  \n\n۱. استفاده از چراغ‌های ضد انفجار (ایکس) در محدوده اسپری، مخازن الکل و انبار محصول  \n۲. نصب پریز برق در مجاورت دستگاه‌ها ممنوع می‌باشد  \n۳. تأمین نور غیرمستقیم و یکنواخت در انبارها با ارتفاع نصب حداقل ۱۵ متری  \n\nدمای محیط مخازن الکل می‌بایست در حدود ۲۰ درجه سانتی‌گراد حفظ گردد تا از تجمع بخارات اشتعال‌پذیر جلوگیری شود. با توجه به محدودیت تردد در این بخش‌ها، شدت روشنایی می‌تواند در حداقل ضروری تنظیم گردد، در مرحله نخست، تمرکز بر نصب چراغ‌های ایکس در مناطق پرخطر خواهد بود و در مراحل بعدی، سایر نقاط نیازمند نیز تجهیز خواهند شد.  \n\nبرای کاهش خطرات ناشی از نور خورشید، پیشنهاد می‌گردد:  \n- نصب فیلم‌های شکننده نور (Light Diffusing Films) بر روی پنجره‌های بالایی  \n- استفاده از پرده‌های ضدحریق در بخش‌های دارای پنجره  \n\nدر مورد سیستم فاضلاب اتاق میکس، با توجه به مسدود شدن لوله‌های پلاستیکی موجود، تعویض آن‌ها با لوله‌های چدنی با قطر ۱۱۰ میلیمتر ضروری است. این اقدام ضمن افزایش استحکام، امکان تخلیه سریع آب و کف در شرایط اضطراری را نیز فراهم می‌نماید، همچنین می‌بایست خروجی اضطراری در پایین دیوارها برای تخلیه مایعات پیش‌بینی گردد. در این راستا، سیستم تخلیه مایعات می‌بایست به صورت زیر طراحی شود:  \n\n۱. ایجاد چهار کانال مجزا برای تخلیه مواد با قطر ۲ اینچ  \n۲. نصب مواد ضدعفونی کننده در محل اتصالات  \n۳. ایجاد شیب مناسب (حداقل ۵ درصد) جهت خروج سریع مایعات  \n\nبرای جلوگیری از تجمع ذرات و کاهش خطر آتش‌سوزی، کانال‌ها می‌بایست به صورت دوره‌ای بازرسی و پاکسازی شوند. در بخش اسپری، طراحی شیب کف به گونه‌ای باشد که مایعات مستقیماً به سمت خروجی هدایت گردد، پیشنهاد می‌شود زیر دستگاه‌ها پوشش ضد نشت نصب گردد تا از انتشار مایعات به سایر نقاط جلوگیری شود. در این راستا، سیستم تخلیه اضطراری مایعات می‌بایست بر اساس مشخصات زیر طراحی گردد:  \n\n۱. **مشخصات خروجی‌ها:**  \n   - ایجاد دو دریچه تخلیه به ابعاد ۲۰ × ۶۰ سانتی‌متر در پایین دیوار  \n   - نصب لوله‌های انتقال با زاویه ۴۰ درجه جهت هدایت مایعات به مخزن جمع‌آوری  \n\n۲. **ساختار کانال‌کشی:**  \n   - استفاده از کانال‌های ۴۰×۴۰ سانتی‌متر متصل به مخزن ۵۰۰۰ لیتری  \n   - اتصال سیستم به استخر بازیافت جهت بازچرخانی آب و کف  \n\n۳. **مدیریت پساب:**  \n   - آب حاصل از عملیات فوم‌زنی به صورت سیکل بسته بازیافت شده و مجدداً در فرآیند استفاده می‌گردد، - تخلیه نهایی پساب غیرقابل بازیافت به شبکه فاضلاب مرکزی  \n\nاین سیستم ضمن جلوگیری از تجمع مایعات در محیط، امکان مدیریت بهینه منابع آبی را نیز فراهم می‌نماید. در بخش ایمنی مخازن الکل، اقدامات ذیل پیشنهاد می‌گردد:  \n\n۱. **تقسیم مخازن:**  \n   - کاهش ظرفیت مخازن از ۳۰ هزار لیتر به ۲۰ هزار لیتر جهت مدیریت بهتر ریسک  \n   - نصب دیواره‌های جداکننده بین مخازن برای جلوگیری از سرایت آتش  \n\n۲. **سیستم اطفاء حریق:**  \n   - نصب سیستم آبپاش فشار قوی مستقر در سقف با پوشش کامل مخازن  \n   - طراحی مسیر دسترسی اضطراری برای نیروهای آتش‌نشانی  \n\n۳، **کنترل دما و تهویه:**  \n- نظارت مستمر بر دمای محیط و جلوگیری از تجمع بخارات اشتعال‌پذیر  \n- بهره‌گیری از تجارب شرکت‌های معتبر نظیر زیست فرآورده فیروزه در زمینه ذخیره‌سازی الکل  \n\nاین تمهیدات می‌بایست با هماهنگی کارشناسان آتش‌نشانی و مطابق با استانداردهای روز به مرحله اجرا گذاشته شود.  \n\nدر زمینه سیستم‌های اطفاء حریق، اقدامات ذیل پیشنهاد می‌گردد:  \n۱. **نصب سیستم اسپرینکلر دوگانه:**  \n   - ترکیب آب و فوم با نسبت استاندارد برای پوشش کامل مخازن  \n   - استفاده از سیستم نیتروژن فشارقوی به عنوان مکمل  \n\n۲. **طراحی و اجرای تخصصی:**  \n   - همکاری با شرکت‌های دارای پروانه طراحی آتش‌نشانی (نظیر شرکت آقای مرتضوی)  \n   - محاسبات ظرفیت سیستم با ضریب ایمنی ۱۰۰ درصد بالاتر از حد استاندارد  \n\n۳، **مکان‌یابی تجهیزات:**  \n- استقرار مخازن ذخیره در عمق زمین مطابق توصیه‌های فنی  \n- جداسازی فیزیکی سالن تولید از محل ذخیره‌سازی الکل  \n\nلازم است کلیه طرح‌ها پیش از اجرا توسط مراجع ذیصلاح آتش‌نشانی تأیید و گواهی پایان کار اخذ گردد.  \n\n**ملاحظات اجرایی:**  \n۱. **افزایش ضریب ایمنی:**  \n   - دوبرابرسازی ظرفیت سیستم‌های اطفاء حریق نسبت به استانداردهای حداقلی  \n   - طراحی شیب کف سالن‌ها جهت هدایت آب به استخر بازیافت و جلوگیری از مصرف بی‌رویه  \n\n۲. **زمان‌بندی پروژه:**  \n   - تکمیل لوله‌کشی و نصب پانل‌های ساندویچی ظرف یک ماه آینده  \n   - آماده‌سازی سازه‌های فلزی و چهارچوب‌ها پیش از نصب پانل‌ها  \n\n۳. **مدیریت انبارها:**  \n   - نصب جعبه‌های آتش‌نشانی (فایرباکس) در انبار مواد اولیه و محصول  \n   - جداسازی محل نگهداری الکل از سایر مواد و تجهیزات سیستم آبرسانی  \n\n۴، **ملاحظات بهداشتی:**  \n- استفاده از پارتیشن‌های مقاوم در سرویس‌های بهداشتی  \n- بهره‌گیری از مصالح ضد رطوبت و قابل شست‌وشو  \n\nتمام مراحل اجرایی می‌بایست تحت نظارت مهندس ناظر و با رعایت دقیق مفاد آیین‌نامه ایمنی صورت پذیرد.  \n\n**ملاحظات تکمیلی ایمنی:**  \n۱. **تجهیزات اطفاء حریق:**  \n   - نصب دو دستگاه پتوی نسوز در بخش اسپری  \n   - تأمین ماسک‌های تنفسی و دستگاه‌های امدادی برای شرایط اضطراری  \n\n۲. **زیرساخت‌های آبرسانی:**  \n   - احداث خط لوله آب اختصاصی از سالن اصلی به ساختمان اداری  \n   - پیش‌بینی شیرهای آبگیری اضطراری برای استفاده ماشین‌های آتش‌نشانی  \n\n۳، **هماهنگی‌های اجرایی:**  \n- برگزاری جلسه فنی با حضور کارشناسان ایمنی (آقایان سلیمی و مرتضویان) جهت بررسی نقشه‌های شبکه  \n- تعیین تکلیف نهایی تجهیزات یدکی و انبارسازی آن‌ها  \n\nپروژه می‌بایست ظرف حداکثر یک هفته با ارائه نقشه‌های نهایی و تأیید مراجع مربوطه به مرحله اجرا گذاشته شود.  \n\n**زیرساخت‌های آبرسانی اضطراری:**  \n۱. **شبکه توزیع آب:**  \n   - احداث خط لوله اصلی با قطر ۷۵ میلیمتر به صورت رینگ دور کارخانه  \n   - ایجاد سه انشعاب در نقاط استراتژیک (ابتدای، وسط و انتهای سالن)  \n\n۲. **مخازن ذخیره:**  \n   - نصب مخزن ۶۰۰۰ لیتری هوایی در مجاورت ساختمان اداری  \n   - اتصال مخزن به شبکه رینگ جهت تأمین آب مورد نیاز اطفاء حریق  \n\n۳. **کاربری‌های جانبی:**  \n   - استفاده موقت از آب شبکه برای آبیاری فضای سبز  \n   - اختصاص انشعاب جداگانه برای آزمایشگاه و واحدهای ویژه  \n\nاین سیستم می‌بایست قابلیت تأمین حداقل فشار ۳۲ بار برای خاموش‌کننده‌ها را دارا باشد، اولویت اجرایی با تکمیل زیرساخت‌های اصلی و سپس توسعه شبکه فرعی خواهد بود. در این راستا، تشکیل گروه تخصصی آتش‌نشانی با مسئولیت‌های ذیل پیشنهاد می‌گردد:  \n\n۱. **ساختار گروه:**  \n   - عضویت مدیران و نمایندگان فنی واحدها  \n   - برگزاری جلسات هفتگی در روز ثابت (مثلاً یکشنبه‌ها)  \n\n۲. **وظایف:**  \n   - بررسی مستندات و گزارش‌های ایمنی  \n   - پاسخگویی به الزامات سازمان‌های نظارتی نظیر غذا و دارو  \n\n۳، **پیگیری الزامات:**  \n- تکمیل حداقلی سیستم ایمنی مخازن الکل جهت اخذ مجوزهای لازم  \n- هماهنگی با واحد بازرگانی برای تأمین بودجه تست‌های ایمنی (حدود ۲۰ میلیون تومان)  \n\nهمچنین، لازم است آقای خلیلی (واحد بازرگانی) در جریان کامل هزینه‌ها و الزامات فنی قرار گیرد تا امکان برنامه‌ریزی مالی فراهم گردد.  \n\n**ملاحظات فنی مخازن:**  \n۱. **کنترل کیفیت جوشکاری:**  \n   - انجام تست‌های غیرمخرب (NDT) نظیر پرتونگاری (X-Ray) برای اتصالات بحرانی  \n   - بررسی ضخامت ورق‌ها با روش اولتراسونیک  \n\n۲. **مدیریت ریسک مخازن تحت فشار:**  \n   - نصب شیرهای اطمینان مطابق با ظرفیت طراحی (حداکثر ۲۰ بار)  \n   - اجرای تست هیدرواستاتیک دوره‌ای تحت نظارت مهندس ناظر  \n\n۳، **ملاحظات روانشناختی پرسنل:**  \n- برگزاری جلسات توجیهی برای رفع نگرانی‌های بی‌جا در مورد ایمنی تجهیزات  \n- آموزش پروتکل‌های اضطراری جهت افزایش اعتماد به نفس عملیاتی  \n\n**موارد ویژه:**  \n- بازرسی مخزن گاز آزمایشگاه با توجه به گزارش شکاف سطحی در بدنه  \n- جایگزینی مخازن فرسوده با نمونه‌های استاندارد دارای گواهی TUV  \n\nتمامی اقدامات می‌بایست با مستندسازی دقیق و اطلاع‌رسانی شفاف به کلیه ذی‌نفعان همراه باشد.  \n\n**تشکیل کمیته تخصصی آتش‌نشانی:**  \n۱. **ساختار اولیه:**  \n   - عضویت مدیران کلیدی از واحدهای مختلف (آقایان حمید، خاکی، خسروی)  \n   - مسئولیت هماهنگی با آقای خسروی به عنوان دبیر کمیته  \n\n۲. **وظایف محوری:**  \n   - تبادل اطلاعات ایمنی بین واحدها  \n   - بررسی پیشنهادات تجهیزاتی نظیر تأمین واحد سیار اطفاء حریق  \n\n۳، **پیشنهاد واحد سیار:**  \n- ظرفیت مخزن آب: ۲۰۰۰ لیتر  \n- ظرفیت مخزن فوم: ۶۰۰ لیتر  \n- نصب پمپ فشارقوی و سیستم توزیع هوشمند  \n- قابلیت حرکت در محوطه کارخانه با پایه‌های وانتی  \n\nبرآورد هزینه و زمان اجرای این طرح می‌بایست حداکثر تا دو هفته آینده توسط کمیته ارائه گردد.  \n\n**همکاری‌های بین سازمانی:**  \n- بهره‌گیری از هیدرانت‌های رایگان تأمین‌شده توسط مدیریت شهرک صنعتی  \n- اتصال شبکه هیدرانت به سیستم آبرسانی داخلی کارخانه  \n\nاین اقدامات ضمن کاهش هزینه‌ها، امکان استفاده مشترک از منابع را برای واحدهای همجوار فراهم می‌نماید. لازم است نمایندگان شرکت در جلسات مدیریت شهرک صنعتی حضور یابند تا هماهنگی‌های لازم برای بهینه‌سازی سیستم صورت پذیرد.', 3, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(123, 'performance_file', 'تست امروز', 'یییی', 'participations/2025/10/22/test3.mp3', '2025-10-22 06:28:52.453052', NULL, 1, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(124, 'performance_file', 'یبریبر', 'یبریبریبر', 'participations/2025/10/22/test3_hE2A6pS.mp3', '2025-10-22 10:42:33.120440', 50156, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(125, 'performance_file', 'fg f', 'fgbfb', 'participations/2025/10/22/test1.mp3', '2025-10-22 10:44:53.334034', 14290, 9, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(126, 'work_experience', 'سیرسیر', 'سیرسیر', 'participations/2025/10/29/test1.mp3', '2025-10-29 06:34:42.265223', 14290, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(127, 'work_experience', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'سیرسرس', 'participations/2025/10/29/New_Recording_11.mp3', '2025-10-29 06:42:58.832034', 25292396, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(128, 'meeting_minutes', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'participations/2025/10/29/test3.mp3', '2025-10-29 06:51:48.053234', 50156, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(129, 'work_experience', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'participations/2025/10/29/test1_CmOYzJP.mp3', '2025-10-29 06:52:42.346461', 14290, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(130, 'performance_file', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'participations/2025/10/29/test1_MrAuiyR.mp3', '2025-10-29 06:53:45.188523', 14290, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(131, 'work_experience', 'مشارکت 2 کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'کارمند زیر بخش 1 بخش 1 کارخانه 1 هلدینگ اصفهان مقدم', 'participations/2025/10/29/test2.mp3', '2025-10-29 07:20:13.118718', 14290, 31, 'بدون فیدبک', 0, 'supervisor_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(132, 'work_experience', '11', 'sacvsdv', 'participations/2025/10/29/test3_jHXzWZa.mp3', '2025-10-29 09:32:35.636216', 14290, 31, 'بدون فیدبک', 0, 'pending', 'تست می‌کنم؛ همه اینها برای تست است تا مطمئن شوم که عملکرد صحیح دارد یا خیر.', NULL, NULL, 'تست می‌کنم؛ همه اینها برای تست است تا مطمئن شوم که عملکرد صحیح دارد یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(133, 'performance_file', 'dfb', 'dfbdb', 'participations/2025/10/29/test3_sheEDbG.mp3', '2025-10-29 09:42:38.631820', 50156, 31, 'بدون فیدبک', 0, 'pending', 'تست می‌کنم تا مطمئن شوم همه‌ی آن برای تستی است که بتوانم تشخیص دهم آیا عملکرد صحیح دارد یا خیر.', NULL, NULL, 'تست می‌کنم تا مطمئن شوم همه‌ی آن برای تستی است که بتوانم تشخیص دهم آیا عملکرد صحیح دارد یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(134, 'suggestions', 'sdv', 'sdv', 'participations/2025/10/29/New_Recording_11_bPgR3Vr.mp3', '2025-10-29 09:43:53.673235', 25292396, 31, 'بدون فیدبک', 0, 'pending', 'سؤالی که مطرح می‌شود این است که با توجه به عملکرد دستگاه اجرایی حاضر و قیمت‌گذاری پایین محصولات، چه مکانیزم منطقی برای تعیین قیمت مناسب وجود دارد؟ به‌طور مشخص، زمانی که یک محصول با قیمت ۱۰ هزار تومان در بازار عرضه می‌شود، این رقم به‌نظر ناکافی می‌رسد. منطقی است که مواد اولیه و فرایند تولید را در محاسبات لحاظ کنیم؛ هرچند پیش‌تر محاسبه دقیقی انجام نشده است.  \n\nفرض کنید بدون در نظر گرفتن مقیاس تولید (مانند عدم بزرگ‌نمایی بازار)، قیمت‌گذاری بر اساس ارزش واقعی زمین و مواد اولیه صورت پذیرد. در این صورت، منطق حکم می‌کند که رویکردی متعادل اتخاذ شود. با این حال، در منطقه مورد نظر، سه شرکت حاضر با قیمت‌های ازپیش‌تعیین‌شده فعالیت می‌کنند که این امر الزاماً الگوی مناسبی برای پیروی نیست.  \n\nاگر محصولی یافت شود که ۵ درصد بر هزینه ماشین‌آلات تأثیر بگذارد، مسئله اصلی در مرحله تولید (احتمالاً چاپ) نمایان می‌شود، درصورت موفقیت‌آمیز بودن فرایند چاپ، آیا افزایش قیمت تا ۷۰ هزار تومان توجیه‌پذیر است؟ اگر این رقم به ۲۰ هزار تومان کاهش یابد، با توجه به بسته‌بندی‌های موجود و قیمت پایه سه شرکت کوچک در بازار که محصولات را به‌تدریج و به صورت تک‌جنس می‌فروشند، چگونه باید محاسبات را انجام داد؟  \n\nلازم به تأکید است که استراتژی قیمت‌گذاری لزوماً مبتنی بر کاهش کیفیت (نازک کردن محصول) و انتقال نصف سود به مشتری نیست. این رویکرد می‌تواند پیامدهای نامطلوبی در پی داشته باشد.  \n\nدر این شرایط، کاهش ۱۰ هزار تومانی قیمت برای ما به‌معنای اختصاص ۵ هزار تومان به هزینه‌ها و تنها ۲ هزار تومان سود خالص است که کاهش قابل‌توجهی را نشان می‌دهد. این امر لزوماً ناشی از ضعف دستگاه اجرایی نیست. همان‌گونه که آقای امیرحسین اشاره کردند، ضروری است جنبه‌های مختلف را بررسی نماییم. ایشان خاطرنشان کردند که آقای سجاد همواره پاسخگوی درخواست‌های فروش بوده و مسائل مرتبط را حل‌وفصل نموده است. همچنین آقای بهزاد علیرغم تمایل قبلی، در جلسه حضور نیافت.  \n\nشما در بخش تحقیق و توسعه زیر نظر مدیریت بهره‌برداری فعالیت دارید. همانند سایر همکاران که هر یک مسئولیت‌های فروش خود را پیگیری می‌کنند، ما نیز پاسخگوی سؤالات هستیم. لطفاً سؤالات خود را همانند روال گذشته مطرح نمایید.  \n\nپیشتر نیز تأکید شده است که ایرادی به عملکرد شما وارد نیست؛ صرفاً جهت اطلاع یادآوری می‌شود که شما در واحد تحقیق و توسعه مستقر هستید که زیرمجموعه سازمان بهره‌برداری است. با این حال، تمامی بخش‌ها از جمله تولید، بهره‌برداری و تحقیق و توسعه در راستای پشتیبانی از فروش فعالیت می‌کنند. هدف اصلی ما فروش محصولات با ارزش افزوده مناسب است، نه صرفاً فروش با قیمت بالاتر.  \n\nشاید بتوان با افزایش ۵ درصدی قیمت‌ها به نتیجه مطلوب رسید، اما باید محدودیت‌های مهم را در نظر داشت. اگر این افزایش قیمت منجر به عدم استقبال بازار شود، ممکن است محصول برای مدت طولانی (حتی ۲۰ سال) در انبار باقی بماند، در چنین شرایطی، ارزش اسمی دستگاه را می‌توان با افزایش ۵۰ تا ۱۰۰ درصدی تعدیل نمود تا تعادل در بازار برقرار گردد.  \n\nدر همین راستا، پیشنهاد می‌شود آزمایشی با افزایش ۱۵۰ درصدی قیمت انجام شود. هرچند ممکن است این افزایش موجب اختلال در بازار گردد (اثر ثانویه)، اما با توجه به تغییرات اعمال‌شده در دستگاه و بهبود عملکرد آن، منطقی به‌نظر می‌رسد. لازم به ذکر است که برخی قطعات از جمله پیچ‌ها از چین تأمین می‌شود و تولید داخلی آن‌ها میسر نیست، پیشنهاد می‌شود پیش از نصب اسپرال، لایه خارجی جدیدی به عنوان پوشش اضافه گردد تا عملکرد سیستم بهینه‌تر شود.  \n\nبرای اجرای این طرح، لازم است تجهیزات مناسب از جمله دستگاه دارای PLC (مانند خطوط چسب‌زنی) فراهم گردد. هرچند هزینه این دستگاه حدود ۲۰۰۰ دلار برآورد می‌شود، اما احتمالاً خط آبی موجود نیز پاسخگوی نیازها باشد. شرکت‌های تولیدکننده قالب‌های تزریقی (Injection) می‌توانند در زمینه تزریق چسب و کامپوزیت همکاری نمایند.  \n\nدر خصوص ضخامت لایه، با توجه به تجربیات پیشین در پروژه‌های مشابه، این پارامتر از اهمیت کمتری برخوردار است. پیشنهاد می‌شود مطالعات اولیه با تمرکز بر پیچش دور سیم‌پیچ آغاز گردد.  \n\nگفتنی است این پیشنهاد هنوز در مرحله بررسی است و نیازمند اخذ مجوزهای لازم می‌باشد. اخیراً مکاتباتی از طریق تلگرام با ذینفعان انجام شده و فایل‌های مرتبط ارسال گردیده است. در جریان گفت‌وگوهای دیروز، پیشنهاد ارسال فلش مموری مطرح شد که مورد موافقت قرار نگرفت.  \n\nموضوع افزودن مؤلفه‌های جدید به طرح، مستلزم هماهنگی با مدیریت عالی شرکت (آقای مقدم) است. از منظر سازمانی، این تغییرات نیازمند دسته‌بندی موضوعی و اخذ نظر کارشناسی از دو نفر دیگر می‌باشد. نظرات این کارشناسان در کنار سایر ملاحظات، مبنای تصمیم‌گیری نهایی خواهد بود، لازم به تأکید است که این پیشنهاد به مثابه یک دستورالعمل اجرایی تلقی می‌شود.  \n\nبر این اساس، مصوب گردید اقدامات زیر انجام پذیرد:  \n۱. تهیه لیست قیمت ۱۵ محصول منتخب توسط دو نفر از همکاران.  \n۲. اصلاح قالب دستگاه شماره یک (سیلندر مارپیچ موجود در انبار) با ایجاد سوراخ جهت امکان تزریق چسب.  \n۳. بهره‌گیری از دستگاه تزریق موجود برای تولید نمونه‌های آزمایشی.  \n\nدر جلسه اخیر مطرح شد که دستگاه مذکور فعلاً غیرفعال است. دلایل اصلی شامل عدم دریافت لیست قیمت از واحد فروش، نبود برنامه‌ریزی جدولی و انجام‌نشدن تست‌های ضروری عنوان گردید.  \n\nدرخصوص افزودن مواد جدید به فرایند، موافقت اصولی اعلام شد. به‌عنوان مثال، پیشنهاد تولید محصولات رنگی یا شفاف (Transparent) مطرح گردید که نیازمند بررسی فنی و اقتصادی است.  \n\nهمچنین پیشنهاد گردید با بهینه‌سازی فرایند (مانند استفاده از موتورهای کم‌مصرف)، هزینه‌ها کاهش یابد. لازم است استعلام‌های فنی از طریق بخش مربوطه (احتمالاً واحد تحقیق و توسعه) انجام شود، در پایان، مقرر گردید قیمت‌گذاری محصولات نهایی بر اساس بازه ۳۰ تا ۴۰ هزار تومان برای هر واحد (مشابه سه نوشابه) صورت پذیرد.  \n\nدرخصوص افزودنی‌های خاص، لازم است هر یک به صورت مجدد از طریق منابع معتبر (از جمله بررسی‌های اینترنتی و هوش مصنوعی) مورد ارزیابی قرار گیرد. به‌عنوان مثال، ترکیباتی مانند اسید سیکلیک و استئاریک که در فرایند تولید کاربرد دارند، نیازمند تحقیق دقیق‌تر هستند.  \n\nامروز با ذینفعان جلسه‌ای برگزار شد و مقرر گردید استعلام قطعات مورد نیاز دستگاه تا پیش از ظهر ارائه شود. همچنین درخواست شد لیست خطاهای احتمالی دستگاه همراه با راهکارهای رفع آن از سوی شرکت سازنده تهیه گردد. این امر به ویژه در شیفت‌های شب که امکان دسترسی به پشتیبانی فنی محدود است، ضروری می‌نماید.  \n\nموضوع دیگری که نیازمند پیگیری است، استرس ناشی از فراموشی برخی پرسش‌های کلیدی در جلسات می‌باشد، پیشنهاد می‌شود مکانیزمی برای ثبت سیستماتیک سؤالات پیش از جلسات تعبیه گردد.  \n\nدرخصوص تجهیزات دستی موجود (مانند استرنج دستی با بوبین پلاستیکی ۷ سانتی‌متری)، قیمت‌گذاری مبتنی بر نرخ ارز ۵۰ هزار تومانی موجب افزایش قابل‌توجه هزینه‌ها شده است. این تجهیزات برای پیچیدن سیم‌های کوچک مناسب هستند، اما در عمل با مشکلاتی مانند پرت مواد (تا ۲۰ سانتی‌متر) و گیرکردن بوبین مواجه می‌شویم. راهکار پیشنهادی، طراحی دسته‌ای است که امکان کاهش پرت و سهولت در خارج‌سازی بوبین را فراهم نماید.  \n\nمقرر گردید دو سناریو برای استعلام قیمت ارائه شود:  \n۱. دستگاه مجهز به بوبین  \n۲. دستگاه بدون بوبین  \n\nهمچنین پیرامون ابعاد دستگاه، پرسش‌هایی مطرح شد. خانم احمدی خاطرنشان کردند که اندازه بزرگ دستگاه ممکن است نامناسب باشد، لذا ضروری است استعلام دقیق‌تری از ابعاد کوچک‌تر صورت پذیرد.  \n\nدر پایان، نیازمند تهیه لیست قطعات و برنامه اصلی دستگاه هستیم، هرچند ممکن است تأمین‌کنندگان از ارائه برنامه اصلی خودداری کنند، اما دستیابی به آن برای مدیریت قطع و وصل فرایند تولید ضروری است.  \n\nدر همین راستا، پیشنهاد گردید با توجه به سیستم داده‌های موجود، دسته‌بندی جامعی از محصولات بر اساس معیارهای جهانی و داخلی انجام پذیرد. برای هر محصول، پرسشنامه‌ای طراحی شود تا اطلاعات فنی دقیق‌تری جمع‌آوری گردد.  \n\nدرخصوص موضوع استرس، فایل صوتی ۱۵ دقیقه‌ای به زبان انگلیسی دریافت شد که شامل راهنمای جامع راه‌اندازی دستگاه، خطاهای رایج و روش‌های عیب‌یابی است. ترجمه و بومی‌سازی این محتوا در دست اقدام می‌باشد.  \n\nبحث دیگری پیرامون ضرورت حضور ناظر چینی در خط تولید مطرح شد. هرچند این امر ممکن است موجب آرامش ذهنی مدیریت گردد، اما هزینه‌های آن (حدود ۱۰ میلیون تومان در ماه) قابل‌توجه است. منطقی به‌نظر می‌رسد که با آموزش نیروهای داخلی و تقویت سیستم نظارتی، این هزینه‌ها کاهش یابد.  \n\nآقای مدیر تصریح کردند که در حال حاضر فردی تواناتر از شما برای این مسئولیت وجود ندارد. بنابراین پیشنهاد می‌شود با افزایش اختیارات و اعتماد به نیروی موجود، زمینه ارتقای توانمندی‌های ایشان فراهم گردد، این رویکرد در بلندمدت موجب کاهش وابستگی به نیروهای خارجی خواهد شد.  \n\nدرخصوص اعتماد به نیروی انسانی، آقای برهان (عضو کمیته ماندگاری) خاطرنشان کردند که تغییرات محسوسی در عملکرد پرسنل مشاهده شده است. همان‌گونه که آقای اکبر مقدم اشاره نمودند، باید فرصت پیشرفت پلکانی را برای نیروها فراهم آوریم. این بدان معناست که افراد پس از کسب تجربه در سطوح پایین‌تر، به‌تدریج به مسئولیت‌های بالاتر منصوب شوند.  \n\nهدف اصلی، دستیابی به راهکارهای منطقی بدون ایجاد تنش در فرایند تولید است. به‌عنوان مثال، در پروژه دستگاه استرنج، ضروری است ضمن حفظ آرامش محیط کار، به نتایج مطلوب دست یابیم.  \n\nدر جلسه دیروز، اگرچه پیش‌از شروع، توضیحات کامل ارائه شده بود، اما دو نفر از حضار به دلیل عدم حضور در جلسات قبلی (حتی پنج سال پیش)، با چالش درک مفاهیم مواجه بودند. این موضوع نشان‌دهنده اهمیت مستندسازی و انتقال دانش در طول زمان است.  \n\nدر پایان، یادآوری می‌شود که هر مشکلی در مسیر تولید، فرصتی برای بهبود و تکامل سیستم محسوب می‌گردد.', NULL, NULL, 'سؤالی که مطرح می‌شود این است که با توجه به عملکرد دستگاه اجرایی حاضر و قیمت‌گذاری پایین محصولات، چه مکانیزم منطقی برای تعیین قیمت مناسب وجود دارد؟ به‌طور مشخص، زمانی که یک محصول با قیمت ۱۰ هزار تومان در بازار عرضه می‌شود، این رقم به‌نظر ناکافی می‌رسد. منطقی است که مواد اولیه و فرایند تولید را در محاسبات لحاظ کنیم؛ هرچند پیش‌تر محاسبه دقیقی انجام نشده است.  \n\nفرض کنید بدون در نظر گرفتن مقیاس تولید (مانند عدم بزرگ‌نمایی بازار)، قیمت‌گذاری بر اساس ارزش واقعی زمین و مواد اولیه صورت پذیرد. در این صورت، منطق حکم می‌کند که رویکردی متعادل اتخاذ شود. با این حال، در منطقه مورد نظر، سه شرکت حاضر با قیمت‌های ازپیش‌تعیین‌شده فعالیت می‌کنند که این امر الزاماً الگوی مناسبی برای پیروی نیست.  \n\nاگر محصولی یافت شود که ۵ درصد بر هزینه ماشین‌آلات تأثیر بگذارد، مسئله اصلی در مرحله تولید (احتمالاً چاپ) نمایان می‌شود، درصورت موفقیت‌آمیز بودن فرایند چاپ، آیا افزایش قیمت تا ۷۰ هزار تومان توجیه‌پذیر است؟ اگر این رقم به ۲۰ هزار تومان کاهش یابد، با توجه به بسته‌بندی‌های موجود و قیمت پایه سه شرکت کوچک در بازار که محصولات را به‌تدریج و به صورت تک‌جنس می‌فروشند، چگونه باید محاسبات را انجام داد؟  \n\nلازم به تأکید است که استراتژی قیمت‌گذاری لزوماً مبتنی بر کاهش کیفیت (نازک کردن محصول) و انتقال نصف سود به مشتری نیست. این رویکرد می‌تواند پیامدهای نامطلوبی در پی داشته باشد.  \n\nدر این شرایط، کاهش ۱۰ هزار تومانی قیمت برای ما به‌معنای اختصاص ۵ هزار تومان به هزینه‌ها و تنها ۲ هزار تومان سود خالص است که کاهش قابل‌توجهی را نشان می‌دهد. این امر لزوماً ناشی از ضعف دستگاه اجرایی نیست. همان‌گونه که آقای امیرحسین اشاره کردند، ضروری است جنبه‌های مختلف را بررسی نماییم. ایشان خاطرنشان کردند که آقای سجاد همواره پاسخگوی درخواست‌های فروش بوده و مسائل مرتبط را حل‌وفصل نموده است. همچنین آقای بهزاد علیرغم تمایل قبلی، در جلسه حضور نیافت.  \n\nشما در بخش تحقیق و توسعه زیر نظر مدیریت بهره‌برداری فعالیت دارید. همانند سایر همکاران که هر یک مسئولیت‌های فروش خود را پیگیری می‌کنند، ما نیز پاسخگوی سؤالات هستیم. لطفاً سؤالات خود را همانند روال گذشته مطرح نمایید.  \n\nپیشتر نیز تأکید شده است که ایرادی به عملکرد شما وارد نیست؛ صرفاً جهت اطلاع یادآوری می‌شود که شما در واحد تحقیق و توسعه مستقر هستید که زیرمجموعه سازمان بهره‌برداری است. با این حال، تمامی بخش‌ها از جمله تولید، بهره‌برداری و تحقیق و توسعه در راستای پشتیبانی از فروش فعالیت می‌کنند. هدف اصلی ما فروش محصولات با ارزش افزوده مناسب است، نه صرفاً فروش با قیمت بالاتر.  \n\nشاید بتوان با افزایش ۵ درصدی قیمت‌ها به نتیجه مطلوب رسید، اما باید محدودیت‌های مهم را در نظر داشت. اگر این افزایش قیمت منجر به عدم استقبال بازار شود، ممکن است محصول برای مدت طولانی (حتی ۲۰ سال) در انبار باقی بماند، در چنین شرایطی، ارزش اسمی دستگاه را می‌توان با افزایش ۵۰ تا ۱۰۰ درصدی تعدیل نمود تا تعادل در بازار برقرار گردد.  \n\nدر همین راستا، پیشنهاد می‌شود آزمایشی با افزایش ۱۵۰ درصدی قیمت انجام شود. هرچند ممکن است این افزایش موجب اختلال در بازار گردد (اثر ثانویه)، اما با توجه به تغییرات اعمال‌شده در دستگاه و بهبود عملکرد آن، منطقی به‌نظر می‌رسد. لازم به ذکر است که برخی قطعات از جمله پیچ‌ها از چین تأمین می‌شود و تولید داخلی آن‌ها میسر نیست، پیشنهاد می‌شود پیش از نصب اسپرال، لایه خارجی جدیدی به عنوان پوشش اضافه گردد تا عملکرد سیستم بهینه‌تر شود.  \n\nبرای اجرای این طرح، لازم است تجهیزات مناسب از جمله دستگاه دارای PLC (مانند خطوط چسب‌زنی) فراهم گردد. هرچند هزینه این دستگاه حدود ۲۰۰۰ دلار برآورد می‌شود، اما احتمالاً خط آبی موجود نیز پاسخگوی نیازها باشد. شرکت‌های تولیدکننده قالب‌های تزریقی (Injection) می‌توانند در زمینه تزریق چسب و کامپوزیت همکاری نمایند.  \n\nدر خصوص ضخامت لایه، با توجه به تجربیات پیشین در پروژه‌های مشابه، این پارامتر از اهمیت کمتری برخوردار است. پیشنهاد می‌شود مطالعات اولیه با تمرکز بر پیچش دور سیم‌پیچ آغاز گردد.  \n\nگفتنی است این پیشنهاد هنوز در مرحله بررسی است و نیازمند اخذ مجوزهای لازم می‌باشد. اخیراً مکاتباتی از طریق تلگرام با ذینفعان انجام شده و فایل‌های مرتبط ارسال گردیده است. در جریان گفت‌وگوهای دیروز، پیشنهاد ارسال فلش مموری مطرح شد که مورد موافقت قرار نگرفت.  \n\nموضوع افزودن مؤلفه‌های جدید به طرح، مستلزم هماهنگی با مدیریت عالی شرکت (آقای مقدم) است. از منظر سازمانی، این تغییرات نیازمند دسته‌بندی موضوعی و اخذ نظر کارشناسی از دو نفر دیگر می‌باشد. نظرات این کارشناسان در کنار سایر ملاحظات، مبنای تصمیم‌گیری نهایی خواهد بود، لازم به تأکید است که این پیشنهاد به مثابه یک دستورالعمل اجرایی تلقی می‌شود.  \n\nبر این اساس، مصوب گردید اقدامات زیر انجام پذیرد:  \n۱. تهیه لیست قیمت ۱۵ محصول منتخب توسط دو نفر از همکاران.  \n۲. اصلاح قالب دستگاه شماره یک (سیلندر مارپیچ موجود در انبار) با ایجاد سوراخ جهت امکان تزریق چسب.  \n۳. بهره‌گیری از دستگاه تزریق موجود برای تولید نمونه‌های آزمایشی.  \n\nدر جلسه اخیر مطرح شد که دستگاه مذکور فعلاً غیرفعال است. دلایل اصلی شامل عدم دریافت لیست قیمت از واحد فروش، نبود برنامه‌ریزی جدولی و انجام‌نشدن تست‌های ضروری عنوان گردید.  \n\nدرخصوص افزودن مواد جدید به فرایند، موافقت اصولی اعلام شد. به‌عنوان مثال، پیشنهاد تولید محصولات رنگی یا شفاف (Transparent) مطرح گردید که نیازمند بررسی فنی و اقتصادی است.  \n\nهمچنین پیشنهاد گردید با بهینه‌سازی فرایند (مانند استفاده از موتورهای کم‌مصرف)، هزینه‌ها کاهش یابد. لازم است استعلام‌های فنی از طریق بخش مربوطه (احتمالاً واحد تحقیق و توسعه) انجام شود، در پایان، مقرر گردید قیمت‌گذاری محصولات نهایی بر اساس بازه ۳۰ تا ۴۰ هزار تومان برای هر واحد (مشابه سه نوشابه) صورت پذیرد.  \n\nدرخصوص افزودنی‌های خاص، لازم است هر یک به صورت مجدد از طریق منابع معتبر (از جمله بررسی‌های اینترنتی و هوش مصنوعی) مورد ارزیابی قرار گیرد. به‌عنوان مثال، ترکیباتی مانند اسید سیکلیک و استئاریک که در فرایند تولید کاربرد دارند، نیازمند تحقیق دقیق‌تر هستند.  \n\nامروز با ذینفعان جلسه‌ای برگزار شد و مقرر گردید استعلام قطعات مورد نیاز دستگاه تا پیش از ظهر ارائه شود. همچنین درخواست شد لیست خطاهای احتمالی دستگاه همراه با راهکارهای رفع آن از سوی شرکت سازنده تهیه گردد. این امر به ویژه در شیفت‌های شب که امکان دسترسی به پشتیبانی فنی محدود است، ضروری می‌نماید.  \n\nموضوع دیگری که نیازمند پیگیری است، استرس ناشی از فراموشی برخی پرسش‌های کلیدی در جلسات می‌باشد، پیشنهاد می‌شود مکانیزمی برای ثبت سیستماتیک سؤالات پیش از جلسات تعبیه گردد.  \n\nدرخصوص تجهیزات دستی موجود (مانند استرنج دستی با بوبین پلاستیکی ۷ سانتی‌متری)، قیمت‌گذاری مبتنی بر نرخ ارز ۵۰ هزار تومانی موجب افزایش قابل‌توجه هزینه‌ها شده است. این تجهیزات برای پیچیدن سیم‌های کوچک مناسب هستند، اما در عمل با مشکلاتی مانند پرت مواد (تا ۲۰ سانتی‌متر) و گیرکردن بوبین مواجه می‌شویم. راهکار پیشنهادی، طراحی دسته‌ای است که امکان کاهش پرت و سهولت در خارج‌سازی بوبین را فراهم نماید.  \n\nمقرر گردید دو سناریو برای استعلام قیمت ارائه شود:  \n۱. دستگاه مجهز به بوبین  \n۲. دستگاه بدون بوبین  \n\nهمچنین پیرامون ابعاد دستگاه، پرسش‌هایی مطرح شد. خانم احمدی خاطرنشان کردند که اندازه بزرگ دستگاه ممکن است نامناسب باشد، لذا ضروری است استعلام دقیق‌تری از ابعاد کوچک‌تر صورت پذیرد.  \n\nدر پایان، نیازمند تهیه لیست قطعات و برنامه اصلی دستگاه هستیم، هرچند ممکن است تأمین‌کنندگان از ارائه برنامه اصلی خودداری کنند، اما دستیابی به آن برای مدیریت قطع و وصل فرایند تولید ضروری است.  \n\nدر همین راستا، پیشنهاد گردید با توجه به سیستم داده‌های موجود، دسته‌بندی جامعی از محصولات بر اساس معیارهای جهانی و داخلی انجام پذیرد. برای هر محصول، پرسشنامه‌ای طراحی شود تا اطلاعات فنی دقیق‌تری جمع‌آوری گردد.  \n\nدرخصوص موضوع استرس، فایل صوتی ۱۵ دقیقه‌ای به زبان انگلیسی دریافت شد که شامل راهنمای جامع راه‌اندازی دستگاه، خطاهای رایج و روش‌های عیب‌یابی است. ترجمه و بومی‌سازی این محتوا در دست اقدام می‌باشد.  \n\nبحث دیگری پیرامون ضرورت حضور ناظر چینی در خط تولید مطرح شد. هرچند این امر ممکن است موجب آرامش ذهنی مدیریت گردد، اما هزینه‌های آن (حدود ۱۰ میلیون تومان در ماه) قابل‌توجه است. منطقی به‌نظر می‌رسد که با آموزش نیروهای داخلی و تقویت سیستم نظارتی، این هزینه‌ها کاهش یابد.  \n\nآقای مدیر تصریح کردند که در حال حاضر فردی تواناتر از شما برای این مسئولیت وجود ندارد. بنابراین پیشنهاد می‌شود با افزایش اختیارات و اعتماد به نیروی موجود، زمینه ارتقای توانمندی‌های ایشان فراهم گردد، این رویکرد در بلندمدت موجب کاهش وابستگی به نیروهای خارجی خواهد شد.  \n\nدرخصوص اعتماد به نیروی انسانی، آقای برهان (عضو کمیته ماندگاری) خاطرنشان کردند که تغییرات محسوسی در عملکرد پرسنل مشاهده شده است. همان‌گونه که آقای اکبر مقدم اشاره نمودند، باید فرصت پیشرفت پلکانی را برای نیروها فراهم آوریم. این بدان معناست که افراد پس از کسب تجربه در سطوح پایین‌تر، به‌تدریج به مسئولیت‌های بالاتر منصوب شوند.  \n\nهدف اصلی، دستیابی به راهکارهای منطقی بدون ایجاد تنش در فرایند تولید است. به‌عنوان مثال، در پروژه دستگاه استرنج، ضروری است ضمن حفظ آرامش محیط کار، به نتایج مطلوب دست یابیم.  \n\nدر جلسه دیروز، اگرچه پیش‌از شروع، توضیحات کامل ارائه شده بود، اما دو نفر از حضار به دلیل عدم حضور در جلسات قبلی (حتی پنج سال پیش)، با چالش درک مفاهیم مواجه بودند. این موضوع نشان‌دهنده اهمیت مستندسازی و انتقال دانش در طول زمان است.  \n\nدر پایان، یادآوری می‌شود که هر مشکلی در مسیر تولید، فرصتی برای بهبود و تکامل سیستم محسوب می‌گردد.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(135, 'work_experience', 'sdv', 'sdvsdv', 'participations/2025/10/29/test3_vq6u572.mp3', '2025-10-29 09:44:58.249287', 50156, 31, 'بدون فیدبک', 0, 'pending', 'تست می‌کنم. همه این اقدامات برای این است که بدانم آیا عملکرد سیستم صحیح است یا خیر.', NULL, NULL, 'تست می‌کنم. همه این اقدامات برای این است که بدانم آیا عملکرد سیستم صحیح است یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(136, 'work_experience', 'sdvgv', 'dbfbdfb', 'participations/2025/10/29/test4.mp3', '2025-10-29 09:47:40.613819', 50156, 31, 'بدون فیدبک', 0, 'pending', 'تست می‌کنم. تمامی این اقدامات به‌منظور اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, 'تست می‌کنم. تمامی این اقدامات به‌منظور اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(137, 'performance_file', 'rtyj', 'tyjtyj', 'participations/2025/11/01/test.mp3', '2025-11-01 04:59:55.152651', 14290, 31, 'بدون فیدبک', 0, 'pending', 'آزمون می‌کنم؛ همه‌ی این اقدامات برای آزمون است تا مطمئن شوم عملکرد صحیح دارد یا خیر.', NULL, NULL, 'آزمون می‌کنم؛ همه‌ی این اقدامات برای آزمون است تا مطمئن شوم عملکرد صحیح دارد یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(138, 'work_experience', 'rth', 'rth', 'participations/2025/11/01/test1.mp3', '2025-11-01 05:01:20.176005', 14290, 31, 'بدون فیدبک', 0, 'pending', 'اقدام به تست انجام می‌دهم تا از عملکرد صحیح سیستم اطمینان حاصل کنم و مشخص شود که آیا به درستی عمل می‌کند یا خیر.', NULL, NULL, 'اقدام به تست انجام می‌دهم تا از عملکرد صحیح سیستم اطمینان حاصل کنم و مشخص شود که آیا به درستی عمل می‌کند یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(139, 'performance_file', 'sdv', 'sdv', 'participations/2025/11/01/test1_1lS2UKa.mp3', '2025-11-01 05:03:11.262999', 14290, 31, 'بدون فیدبک', 0, 'pending', 'تست می‌کنم تا بررسی کنم که آیا عملکرد صحیح دارد یا خیر.', NULL, NULL, 'تست می‌کنم تا بررسی کنم که آیا عملکرد صحیح دارد یا خیر.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(140, 'meeting_minutes', 'fh', 'gfhghn', 'participations/2025/11/01/test1_DpAPkKb.mp3', '2025-11-01 05:05:49.978333', 14290, 31, 'بدون فیدبک', 1, 'user_review', 'تست می‌کنم، تمام این کارها را برای تست انجام می‌دهم تا بفهمم که آیا کار می‌کند یا خیر.', NULL, 'این تست برای درک نحوه کار است.', 'تست می‌کنم، تمام این کارها را برای تست انجام می‌دهم تا بفهمم که آیا کار می‌کند یا خیر.', 2, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
INSERT INTO `users_participation` (`id`, `item_type`, `title`, `description`, `attachment`, `created_at`, `file_size`, `user_id`, `feedback`, `is_finalized`, `status`, `text_content`, `factory_id`, `summarized_content`, `orginal_content`, `count_sumerized`, `department_id`, `holding_id`, `subdepartment_id`, `role_name`, `is_committee`, `manager_feedback`, `manager_2_feedback`, `manager_3_feedback`, `department_committee_id`, `factory_committee_id`, `holding_committee_id`, `subdepartment_committee_id`, `manager_status`, `manager_2_status`, `manager_3_status`, `supervisor_status`, `supervisor_feedback`, `return_count`, `is_audio`) VALUES
(141, 'work_experience', 'fgn', 'fgnfgn', 'participations/2025/11/01/test1_b45bd07.mp3', '2025-11-01 05:15:18.080780', 14290, 31, 'بدون فیدبک', 1, 'supervisor_review', 'آزمایش می‌کنم؛ تمامی این اقدامات جهت اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, 'آزمایش می‌کنم؛ تمامی این اقدامات جهت اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(142, 'work_experience', 'wef', 'wefwef', 'participations/2025/11/01/test1_GoCweJp.mp3', '2025-11-01 05:25:09.847796', 14290, 32, 'بدون فیدبک', 1, 'supervisor_review', 'آزمایش می‌کنم؛ تمامی این اقدامات جهت اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, 'آزمایش می‌کنم؛ تمامی این اقدامات جهت اطمینان از عملکرد صحیح سیستم انجام می‌شود.', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(143, 'performance_file', 'rth', 'rthrthr', '', '2025-11-05 06:18:20.983482', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'rthrthr', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(144, 'performance_file', 'تست جدید مدیر کارخانه', 'سیزسیزسز', '', '2025-11-05 06:19:24.358745', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیزسیزسز', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(145, 'performance_file', 'تست 2', 'sds', '', '2025-11-05 06:21:08.414010', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(146, 'performance_file', 'test', 'sdv', '', '2025-11-05 06:40:45.694328', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sdv', 5, NULL, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(147, 'work_experience', 'sdvs', 'sdvsdv', '', '2025-11-05 06:47:40.896636', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sdvsdv', 5, NULL, NULL, NULL, NULL, 3, NULL, 'factory_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(148, 'performance_file', 'مدیر کار خانه', 'سیس', '', '2025-11-05 08:04:12.150111', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیس', 5, NULL, NULL, NULL, NULL, 3, NULL, 'factory_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(149, 'work_experience', 'سرپرست بخش 2', 'سشیس', '', '2025-11-05 08:04:31.481253', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سشیس', 2, NULL, NULL, NULL, 5, 1, 2, 'supervisor', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(150, 'work_experience', 'سرپرست بخش 1', 'سیرسری', '', '2025-11-05 08:04:51.962710', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیرسری', 2, NULL, NULL, NULL, 5, 1, 1, 'supervisor', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(151, 'performance_file', 'مدیر بخش 1', 'سیر', '', '2025-11-05 08:05:16.025017', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیر', 2, NULL, NULL, NULL, 5, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(152, 'work_experience', 'کارگر زیر بخش 1', 'سیرسیر', '', '2025-11-06 06:17:46.653405', NULL, 26, 'ascdsdc', 1, 'rejected', 'سیرسیر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(153, 'performance_file', 'کارگر زیر بخش 2', 'سری', '', '2025-11-06 06:18:01.152260', NULL, 26, 'بدون فیدبک', 1, 'manager_review', 'سری', 2, NULL, NULL, NULL, 5, 1, 2, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(154, 'performance_file', 'مدیر سیستم', 'سیرسر', '', '2025-11-06 06:18:13.467752', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیرسر', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(155, 'meeting_minutes', 'مدیر بخش 1', 'صثب', '', '2025-11-06 06:33:20.878066', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'صثب', 2, NULL, NULL, NULL, 5, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(156, 'work_experience', 'بیذیذ', 'یبذیذ', '', '2025-11-06 07:22:12.457555', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(157, 'performance_file', 'یبذیبذ', 'یبذیبذ', '', '2025-11-06 07:22:17.339598', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیبذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(158, 'performance_file', 'یبذیبذ', 'یبذیذ', '', '2025-11-06 07:22:23.189626', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(159, 'meeting_minutes', 'یبذیذب', 'یبذیبذ', '', '2025-11-06 07:22:28.654510', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیبذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(160, 'meeting_minutes', 'یبذ', 'یبذ', '', '2025-11-06 07:22:35.287165', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(161, 'performance_file', 'یبذیبذ', 'یبذیذ', '', '2025-11-06 07:22:43.453854', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(162, 'meeting_minutes', 'سیر', 'سیر', '', '2025-11-06 07:22:50.154232', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیر', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(163, 'work_experience', 'سیرس', 'سیر', '', '2025-11-06 07:22:58.336184', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'سیر', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(164, 'performance_file', 'کارمند زیر بخش 1', 'صثبصثب', '', '2025-11-09 08:16:16.229754', NULL, 26, 'هخگ-', 1, 'approved', 'صثبصثب', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(165, 'performance_file', 'fgnfn', 'gfnfgnfn', '', '2025-11-09 08:48:11.618169', NULL, 26, 'بدون فیدبک', 1, 'approved', 'gfnfgnfn', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(166, 'work_experience', 'سیزس', 'سیزسیز', '', '2025-11-09 09:05:30.070950', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیزسیز', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(167, 'work_experience', 'new85', 'ergdfb', '', '2025-11-10 06:33:16.795626', NULL, 26, 'برگردانده شده است', 1, 'supervisor_review', 'ergdfb', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(168, 'work_experience', 'یبذی', 'یبذیذ', '', '2025-11-12 09:35:48.736585', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'یبذیذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(169, 'performance_file', 'تست کمیته', 'سیرسیر', '', '2025-11-12 11:41:50.697365', NULL, 26, 'بدون فیدبک', 0, 'pending', NULL, 6, NULL, NULL, NULL, 14, 1, 18, 'employee', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(170, 'work_experience', 'تست کمیته', 'سشیس', '', '2025-11-12 12:03:22.832712', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سشیس', 6, NULL, NULL, NULL, 14, 1, 18, 'employee', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(171, 'performance_file', 'تست کمیته', 'سریبر', '', '2025-11-12 12:38:33.229333', NULL, 26, 'قغففغدفد', 1, 'manager_review', 'سریبر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, NULL, NULL, 0, 0),
(172, 'work_experience', 'sdvs', 'sdvsdv', '', '2025-11-12 12:56:41.731398', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sdvsdv', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(173, 'work_experience', 'تست جدید کمیته', 'ثصقرثقر', '', '2025-11-13 05:31:24.970477', NULL, 26, 'بدون فیدبک', 1, 'manager_review', 'ثصقرثقر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, NULL, NULL, 0, 0),
(174, 'performance_file', 'اصلی', 'سیر', '', '2025-11-13 06:34:55.866601', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیر', 6, NULL, NULL, NULL, 14, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(175, 'performance_file', 'کمیته 2', 'حنخ', '', '2025-11-13 06:36:17.244404', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'حنخ', 6, NULL, NULL, NULL, 14, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(176, 'work_experience', 'تست کمیته', 'سیرسیر', '', '2025-11-13 08:17:34.937217', NULL, 26, 'فغتف', 1, 'manager_review', 'سیرسیر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, 'yikkiukiukiui', NULL, 14, 6, 1, 18, NULL, 'rejected', NULL, NULL, NULL, 0, 0),
(177, 'meeting_minutes', 'تست رد کردن توسط supervisor', 'svdsv', '', '2025-11-13 08:20:39.581256', NULL, 26, 'jljkllk', 1, 'rejected', 'svdsv', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, 'fsdvdfvdfvdfv', '\'pl;\'[,', 14, 6, 1, 18, 'approved', 'rejected', 'rejected', 'rejected', 'توسط سرپرست رد شد.', 0, 0),
(178, 'suggestions', 'تست تایید کردن سرپرست', 'صسرحسثرننرررربر', '', '2025-11-13 08:21:37.508420', NULL, 26, 'بدون فیدبک', 1, 'approved', 'صسرحسثرننرررربر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, 'approved', NULL, 0, 0),
(179, 'meeting_minutes', 'تست کمیته', 'سرضیر', '', '2025-11-13 09:20:28.823494', NULL, 26, 'صثقبصثبص', 1, 'rejected', 'سرضیر', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, 'approved', NULL, 0, 0),
(180, 'meeting_minutes', 'new test', 'rgergeg', '', '2025-11-15 08:50:26.458353', NULL, 26, 'ascascasc', 1, 'rejected', 'rgergeg', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, 'approved', NULL, 0, 0),
(181, 'work_experience', 'new test 2', 'ascasc', '', '2025-11-15 08:58:12.372622', NULL, 26, 'بدون فیدبک', 1, 'approved', 'ascasc', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, 'فیدبک مدیر اول کمیته', 'فیدبک مدیر دوم کمیته', NULL, 14, 6, 1, 18, 'rejected', 'rejected', 'approved', 'rejected', 'rejected by supervisor', 0, 0),
(182, 'work_experience', 'dfbdfb', 'fdbdfbb', '', '2025-11-15 09:34:37.521058', NULL, 26, 'بدون فیدبک', 1, 'manager_review', 'fdbdfbb', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, 'rejected', 'dfbdfb', 0, 0),
(183, 'meeting_minutes', 'بلدبد', 'بلدبد', '', '2025-11-16 09:05:56.634263', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'بلدبد', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(184, 'performance_file', 'مشارکت امروز', 'ییی', '', '2025-11-16 09:21:28.444616', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'ییی', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(185, 'work_experience', 'تست مشارکت سرپرست', 'ثرص', '', '2025-11-16 09:22:32.418749', NULL, 26, 'بدون فیدبک', 1, 'manager_review', 'ثرصaaaaa', 2, NULL, NULL, NULL, 5, 1, 1, 'supervisor', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(186, 'performance_file', 'test 2', 'sdvsdv', '', '2025-11-16 09:29:38.070278', NULL, 26, 'بدون فیدبک', 1, 'approved', 'sdvsdv', 2, NULL, NULL, NULL, 5, 1, 1, 'supervisor', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(187, 'work_experience', 'new test', 'sdvsdv', '', '2025-11-16 09:39:03.740895', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'sdvsdv', 2, NULL, NULL, NULL, 5, 1, 1, 'supervisor', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, NULL, NULL, 0, 0),
(188, 'performance_file', 'تست کمیته', 'sdvsdv', '', '2025-11-16 09:40:41.884209', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'sdvsdv', 2, NULL, NULL, NULL, 5, 1, 1, 'supervisor', 1, NULL, NULL, NULL, 14, 6, 1, 18, NULL, NULL, NULL, NULL, NULL, 0, 0),
(189, 'meeting_minutes', 'sdvsdv', 'sddsv', 'participations/2025/11/17/test1.mp3', '2025-11-17 11:45:25.398233', 14290, 26, 'بدون فیدبک', 0, 'user_review', 'این تست جهت اطمینان از عملکرد صحیح و بررسی اینکه آیا به درستی عمل می‌کند یا خیر، انجام می‌شود.', 2, NULL, 'این تست جهت اطمینان از عملکرد صحیح و بررسی اینکه آیا به درستی عمل می‌کند یا خیر، انجام می‌شود.', NULL, 5, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(190, 'performance_file', 'asca', 'ascasc', 'participations/2025/11/18/test1.mp3', '2025-11-18 13:22:09.958950', 50156, 26, 'بدون فیدبک', 0, 'pending', 'ascasc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(191, 'performance_file', 'as', 'asca', '', '2025-11-18 13:44:23.332556', NULL, 26, 'بدون فیدبک', 1, 'approved', 'asca', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(192, 'work_experience', 'sdsd', 'sdsdssd', '', '2025-11-18 13:45:41.471904', NULL, 26, 'بدون فیدبک', 1, 'approved', 'sdsdssd<>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(193, 'performance_file', 'sdvsdvs', 'sdvsdv', '', '2025-11-18 13:59:16.951702', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sdvsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(194, 'performance_file', 'sdv', 'sdv', '', '2025-11-18 14:10:28.219338', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'sdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(195, 'performance_file', '>س', 'سیرسیر', '', '2025-11-18 14:23:40.097405', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'سیرسیر', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(196, 'work_experience', '>', 'سیز', '', '2025-11-18 14:25:35.166658', NULL, 26, 'بدون فیدبک', 1, 'approved', 'سیز', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(197, 'performance_file', 'rthr', 'rthrth', '', '2025-11-22 09:37:47.444363', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'rthrth', 2, NULL, NULL, NULL, 16, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(198, 'work_experience', 'scsc', 'scsc', 'participations/2025/11/23/requirements.txt', '2025-11-23 08:29:20.378827', 1916, 26, 'بدون فیدبک', 1, 'user_review', 'scsc', NULL, NULL, NULL, NULL, NULL, 1, NULL, 'holding_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(199, 'meeting_minutes', 'ascasc', 'ascsc', '', '2025-11-23 08:32:20.924662', NULL, 26, 'بدون فیدبک', 1, 'approved', 'ascsc', NULL, NULL, NULL, NULL, NULL, 1, NULL, 'holding_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(200, 'work_experience', 'asc', 'asc', 'participations/2025/11/23/requirements_oHHgMxk.txt', '2025-11-23 08:33:10.076350', 1916, 26, 'بدون فیدبک', 1, 'approved', 'asc', NULL, NULL, NULL, NULL, NULL, 1, NULL, 'holding_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(201, 'work_experience', 'qq', 'wqqwwq', '', '2025-11-25 04:33:27.935856', NULL, 26, 'بدون فیدبک', 1, 'approved', 'wqqwwq', 2, NULL, NULL, NULL, 5, 1, 2, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(202, 'work_experience', '9ک', '9ک090ک', '', '2025-11-25 04:56:51.107010', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', '9ک090ک', 2, NULL, NULL, NULL, 6, 1, 3, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(203, 'performance_file', 'up[?', 'uup/uop/', '', '2025-11-25 05:08:49.923810', NULL, 26, 'بدون فیدبک', 1, 'manager_review', 'uup/uop/', 2, NULL, NULL, NULL, 6, 1, 3, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(204, 'suggestions', 'ثقلثلثقلللثقلثقلثقلثقل', 'ص3جنحثلجتسثقفاسقحفن ئذفنذ حوغذ0ص05ذ0ص450ل.ثیبگذ.یگث.قفبذثجذثقذ', '', '2025-11-25 07:02:17.541382', NULL, 26, 'بدون فیدبک', 1, 'approved', 'ص3جنحثلجتسثقفاسقحفن ئذفنذ حوغذ0ص05ذ0ص450ل.ثیبگذ.یگث.قفبذثجذثقذ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(205, 'performance_file', 'این عنوان تست هستش که دارم تستش میکنم', 'اینم هم متن تست هست که با تست و test امتحان شده است', '', '2025-11-25 07:03:20.768126', NULL, 26, 'بدون فیدبک', 1, 'approved', 'اینم هم متن تست هست که با تست و test امتحان شده است', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(206, 'work_experience', 'asca', 'asc', '', '2025-11-25 07:05:56.664310', NULL, 26, 'بدون فیدبک', 1, 'approved', 'asc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(207, 'work_experience', 'dfbdfb', 'fdbdbf', '', '2025-11-26 05:41:19.274619', NULL, 26, 'بدون فیدبک', 1, 'supervisor_review', 'fdbdbf', 2, NULL, NULL, NULL, 5, 1, 2, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(208, 'performance_file', 'return test', 'asc', '', '2025-11-26 05:42:04.504624', NULL, 26, 'kljnl', 1, 'supervisor_review', 'asc', 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0),
(209, 'performance_file', 'ثقبثق', 'ثقب', 'participations/2025/11/26/test1.mp3', '2025-11-26 06:06:44.532590', 50156, 26, 'بدون فیدبک', 1, 'supervisor_review', 'همه آن را برای این تست می‌کنم که بدانم آیا کار می‌کند یا نه.', 2, NULL, 'همه آن را برای این تست می‌کنم که بدانم آیا کار می‌کند یا نه.', NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(210, 'work_experience', 'ghmtyu', 'ykuyk', 'participations/2025/11/26/test1_HVarfrC.mp3', '2025-11-26 06:46:39.570815', 50156, 26, 'بدون فیدبک', 0, 'pending', NULL, 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(211, 'suggestions', 'ghnghnghn', 'ghnghn', 'participations/2025/11/26/test1_D5ZhCYc.mp3', '2025-11-26 06:48:14.093116', 50156, 26, 'بدون فیدبک', 0, 'pending', NULL, 2, NULL, NULL, NULL, 5, 1, 1, 'employee', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(212, 'work_experience', ',;svgew', 'ervevev', 'participations/2025/11/26/6363_qlo4V3T.jpg', '2025-11-26 09:12:39.850407', 55543, 26, 'بدون فیدبک', 0, 'user_review', 'ervevev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(213, 'performance_file', 'sdvsdvsdv', 'sdvsdvsvsdv', '', '2025-12-08 07:45:06.284387', NULL, 26, 'بدون فیدبک', 1, 'approved', 'sdvsdvsvsdv', 2, NULL, NULL, NULL, 5, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(214, 'work_experience', 'حنحنح', 'ناذذن', 'participations/2025/12/09/۱۸_۱۱۲۶۵۶.webm', '2025-12-09 07:57:33.853865', 138434, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(215, 'work_experience', '-ن098ع', 'غفزغذت', 'participations/2025/12/09/11.webm', '2025-12-09 07:58:17.880382', 74678, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(216, 'work_experience', 'tyty', 'tyjtyjtyj', 'participations/2025/12/09/11_k3Mdcec.webm', '2025-12-09 08:01:40.523425', 74678, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(217, 'work_experience', 'sdvsdv', 'sdvsdvsv', 'participations/2025/12/09/11_mi8Z4wD.webm', '2025-12-09 08:01:59.839974', 74678, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(218, 'work_experience', 'ascasc', 'ascacasc', 'participations/2025/12/09/11_Y61j1lJ.webm', '2025-12-09 08:03:01.730454', 74678, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(219, 'performance_file', 'ascasc', 'ascacac', 'participations/2025/12/09/test1.mp3', '2025-12-09 08:03:46.110170', 50156, 26, 'بدون فیدبک', 0, 'user_review', 'این آزمون را انجام می‌دهم تا از صحت عملکرد آن اطمینان حاصل کنم.', NULL, NULL, 'این آزمون را انجام می‌دهم تا از صحت عملکرد آن اطمینان حاصل کنم.', NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(220, 'work_experience', 'قفاقفا', 'قفاقفاقفا', 'participations/2025/12/09/ضبط_صدا_۱۴۰۴-۹-۱۸-_۱۱۳۸۴۵.mp3', '2025-12-09 08:09:00.532953', 128256, 26, 'بدون فیدبک', 0, 'user_review', 'چگونه است؟', NULL, NULL, 'چگونه است؟', NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
(221, 'performance_file', 'fbdfbdb', 'dfbdfbdbd', '', '2025-12-13 06:56:33.161756', NULL, 26, 'بدون فیدبک', 1, 'approved', 'dfbdfbdbd', 2, NULL, NULL, NULL, 16, 1, NULL, 'department_manager', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(222, 'work_experience', 'عیوب دستگاه چاپ', 'خح/خ/ثقلثل', '', '2025-12-13 10:54:30.491983', NULL, 26, 'بدون فیدبک', 0, 'user_review', 'خح/خ/ثقلثل', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),
(223, 'performance_file', 'sss', 'sssss', 'participations/2025/12/27/جلسه_۰۷۵_۱۴۰۴.۱۰.۰۳.mp3', '2025-12-27 07:25:33.116575', 3170732, 26, 'بدون فیدبک', 0, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'super_admin', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_permissionlevel`
--

CREATE TABLE `users_permissionlevel` (
  `id` bigint(20) NOT NULL,
  `can_manage_users` tinyint(1) NOT NULL,
  `can_evaluate` tinyint(1) NOT NULL,
  `can_view_reports` tinyint(1) NOT NULL,
  `can_access_all_departments` tinyint(1) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `can_access_all_factories` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_permissionlevel`
--

INSERT INTO `users_permissionlevel` (`id`, `can_manage_users`, `can_evaluate`, `can_view_reports`, `can_access_all_departments`, `role_id`, `can_access_all_factories`) VALUES
(1, 1, 1, 1, 1, 1, 0),
(2, 1, 1, 1, 0, 2, 0),
(3, 1, 1, 1, 0, 3, 0),
(4, 0, 1, 1, 0, 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_previousinsurer`
--

CREATE TABLE `users_previousinsurer` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_previousinsurer`
--

INSERT INTO `users_previousinsurer` (`code`, `name`) VALUES
(35008, 'بانک مرکزی جمهوری اسلامی ایران'),
(14, 'بیمه آتیه سازان حافظ'),
(15, 'بیمه آرمان'),
(16, 'بیمه آسماری'),
(3, 'بیمه آسیا'),
(34263, 'بیمه امید'),
(5, 'بیمه ایران'),
(1, 'بیمه تجارت نو'),
(17, 'بیمه تعاون'),
(6, 'بیمه توسعه'),
(18, 'بیمه حافظ'),
(7, 'بیمه دانا'),
(19, 'بیمه دی'),
(8, 'بیمه رازی'),
(20, 'بیمه سامان'),
(24, 'بیمه سرمد'),
(9, 'بیمه سینا'),
(25, 'بیمه شهرداری'),
(10, 'بیمه ما'),
(21, 'بیمه معلم'),
(11, 'بیمه ملت'),
(22, 'بیمه میهن'),
(23, 'بیمه نوین'),
(12, 'بیمه پارسیان'),
(26, 'بیمه پاسارگاد'),
(13, 'بیمه کارآفرین'),
(27, 'بیمه کوثر'),
(33627, 'حکمت صبا'),
(33770, 'خیریه امدادگران عاشورا کاشان'),
(33773, 'خیریه ای ال اس'),
(33956, 'دمیس'),
(2, 'سهامی بیمه ایران - معین'),
(34669, 'شرکت تسهیل گری درمان دمیس'),
(34886, 'شرکت معدنی و صنعتی گل گهر'),
(15883, 'شرکت نگین گهر زمین (درمان جهاد نصر)'),
(34671, 'مرکز بهداشت و درمان صدا و سیمای جمهوری اسلامی ایران'),
(33759, 'ملی صنایع مس ایران');

-- --------------------------------------------------------

--
-- Table structure for table `users_referral`
--

CREATE TABLE `users_referral` (
  `id` bigint(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_closed` tinyint(1) NOT NULL,
  `created_by_role_id` bigint(20) NOT NULL,
  `created_by_unit_id` bigint(20) NOT NULL,
  `created_by_user_id` bigint(20) NOT NULL,
  `final_unit_id` bigint(20) NOT NULL,
  `participation_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_referral`
--

INSERT INTO `users_referral` (`id`, `title`, `description`, `created_at`, `is_closed`, `created_by_role_id`, `created_by_unit_id`, `created_by_user_id`, `final_unit_id`, `participation_id`) VALUES
(2, 'سیرسیر', 'سیرسیرسر', '2025-12-10 08:28:53.790228', 0, 1, 8, 26, 7, 205),
(3, 'title', 'descript', '2025-12-10 09:09:26.455689', 0, 2, 11, 26, 7, 213),
(4, 'فغتفغتفغت', 'غفتغفغتفغ', '2025-12-10 12:44:46.720299', 0, 2, 11, 26, 8, 213),
(5, 'تست ارجاغ', 'ششششش', '2025-12-13 08:15:00.236480', 0, 4, 14, 26, 12, 181),
(6, 'test refer', 'test refer', '2025-12-13 08:58:32.530289', 0, 4, 14, 26, 12, 181),
(8, 'ttt', 'ttt', '2025-12-13 09:04:05.508181', 0, 4, 14, 26, 12, 164),
(9, 'aa', 'aa', '2025-12-13 09:11:43.723111', 0, 4, 14, 26, 12, 164),
(10, 'aaa', 'aaa', '2025-12-13 09:12:41.080601', 0, 4, 14, 26, 12, 164),
(11, 'ss', 'ss', '2025-12-13 09:13:11.077702', 0, 3, 14, 26, 12, 186),
(12, 'تست جدید', 'شششش', '2025-12-13 09:22:20.098095', 0, 4, 14, 26, 12, 181),
(13, 'fgnfgn', 'fgnfnfn', '2025-12-13 09:27:23.497344', 0, 4, 14, 26, 12, 165),
(14, 'sadvs', 'sdvsdvsvd', '2025-12-13 09:29:00.751334', 0, 4, 14, 26, 12, 165),
(15, 'همین الان تست میکنم', 'یییی', '2025-12-13 10:04:15.740252', 0, 4, 14, 26, 12, 181),
(16, 'sdssd', 'ssdsdsd', '2025-12-13 10:22:32.063159', 0, 2, 11, 26, 8, 213),
(18, 'یللی', 'بلبلبلبلبل', '2025-12-13 11:37:09.177435', 0, 1, 8, 26, 8, 206),
(20, 'ewwef', 'wwefew', '2025-12-14 05:04:27.249633', 0, 4, 18, 26, 8, 181),
(21, 'تغفغ', 'فغتفغت', '2025-12-14 05:21:48.828549', 0, 4, 18, 26, 8, 178),
(22, 'ققق', 'ققق', '2025-12-14 05:25:49.186846', 0, 4, 18, 26, 14, 165),
(23, 'یه تست جدید', 'سسسس', '2025-12-14 07:01:04.739170', 0, 4, 18, 26, 20, 181),
(24, 'یه تست جدید 2', 'سیسسسس', '2025-12-14 07:02:42.677766', 0, 4, 18, 26, 14, 178),
(25, 'last test', 'last test', '2025-12-14 08:05:54.404298', 0, 4, 18, 26, 12, 181),
(26, 'این تست الانه', 'سیبیبریبر', '2025-12-14 10:37:39.800160', 0, 4, 18, 26, 12, 181);

-- --------------------------------------------------------

--
-- Table structure for table `users_referralstep`
--

CREATE TABLE `users_referralstep` (
  `id` bigint(20) NOT NULL,
  `comment` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_approved` tinyint(1) DEFAULT NULL,
  `order` int(10) UNSIGNED NOT NULL CHECK (`order` >= 0),
  `from_role_id` bigint(20) NOT NULL,
  `from_unit_id` bigint(20) NOT NULL,
  `from_user_id` bigint(20) NOT NULL,
  `referral_id` bigint(20) NOT NULL,
  `to_role_id` bigint(20) NOT NULL,
  `to_unit_id` bigint(20) NOT NULL,
  `to_user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_referralstep`
--

INSERT INTO `users_referralstep` (`id`, `comment`, `created_at`, `is_approved`, `order`, `from_role_id`, `from_unit_id`, `from_user_id`, `referral_id`, `to_role_id`, `to_unit_id`, `to_user_id`) VALUES
(1, 'سیرسیرسر', '2025-12-10 08:28:53.790228', 1, 1, 1, 8, 26, 2, 2, 7, 26),
(2, 'شسسس', '2025-12-10 09:09:26.455689', 1, 1, 2, 11, 26, 3, 2, 7, 26),
(3, 'aaaaa', '2025-12-10 12:44:46.720299', 1, 1, 2, 11, 26, 4, 1, 8, 26),
(4, 'حح', '2025-12-13 07:42:23.581381', 1, 2, 2, 7, 26, 2, 5, 12, 26),
(5, 'بسیبذیبذیذ', '2025-12-13 07:42:49.826817', NULL, 3, 5, 12, 26, 2, 6, 13, 26),
(6, 'ششششش', '2025-12-13 08:15:00.237267', NULL, 1, 4, 14, 26, 5, 5, 12, 26),
(7, 'test refer', '2025-12-13 08:58:32.530289', NULL, 1, 4, 14, 26, 6, 5, 12, 26),
(9, 'ttt', '2025-12-13 09:04:05.508181', NULL, 1, 4, 14, 26, 8, 5, 12, 26),
(10, 'aa', '2025-12-13 09:11:43.725074', NULL, 1, 4, 14, 26, 9, 5, 12, 26),
(11, 'aaa', '2025-12-13 09:12:41.080601', NULL, 1, 4, 14, 26, 10, 5, 12, 26),
(12, 'ss', '2025-12-13 09:13:11.078863', NULL, 1, 3, 14, 26, 11, 5, 12, 26),
(13, 'شششش', '2025-12-13 09:22:20.098095', NULL, 1, 4, 14, 26, 12, 5, 12, 26),
(14, 'fgnfnfn', '2025-12-13 09:27:23.497344', NULL, 1, 4, 14, 26, 13, 5, 12, 26),
(15, 'sdvsdvsvd', '2025-12-13 09:29:00.751334', NULL, 1, 4, 14, 26, 14, 5, 12, 26),
(16, 'یییی', '2025-12-13 10:04:15.740252', NULL, 1, 4, 14, 26, 15, 5, 12, 26),
(17, 'ssdsdsd', '2025-12-13 10:22:32.063159', NULL, 1, 2, 11, 26, 16, 1, 8, 26),
(19, 'بلبلبلبلبل', '2025-12-13 11:37:09.177435', NULL, 1, 1, 8, 26, 18, 1, 8, 26),
(21, 'wwefew', '2025-12-14 05:04:27.266050', NULL, 1, 4, 18, 26, 20, 1, 8, 26),
(23, 'فغتفغت', '2025-12-14 05:21:48.830543', NULL, 1, 4, 18, 26, 21, 1, 8, 26),
(24, 'ققق', '2025-12-14 05:25:49.188841', NULL, 1, 4, 18, 26, 22, 3, 14, 27),
(25, 'سسسس', '2025-12-14 06:55:10.182421', NULL, 2, 3, 14, 26, 22, 5, 12, 26),
(26, 'شششششش', '2025-12-14 06:58:33.424155', NULL, 3, 5, 12, 26, 22, 5, 12, 26),
(27, 'سسسس', '2025-12-14 07:01:04.741164', NULL, 1, 4, 18, 26, 23, 3, 20, 26),
(28, 'سیسسسس', '2025-12-14 07:02:42.679762', NULL, 1, 4, 18, 26, 24, 3, 14, 27),
(29, 'last test', '2025-12-14 08:05:54.407307', NULL, 1, 4, 18, 26, 25, 5, 12, 26),
(30, 'سیبیبریبر', '2025-12-14 10:37:39.800160', NULL, 1, 4, 18, 26, 26, 5, 12, 26);

-- --------------------------------------------------------

--
-- Table structure for table `users_relativetype`
--

CREATE TABLE `users_relativetype` (
  `code` smallint(5) UNSIGNED NOT NULL CHECK (`code` >= 0),
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_relativetype`
--

INSERT INTO `users_relativetype` (`code`, `name`) VALUES
(6, 'برادر'),
(1, 'بیمه شده اصلی'),
(5, 'خواهر'),
(10, 'داماد'),
(8, 'دختر'),
(14, 'دختر متاهل'),
(15, 'سایر'),
(9, 'عروس'),
(4, 'مادر'),
(12, 'نوه دختر'),
(11, 'نوه پسر'),
(2, 'همسر'),
(3, 'پدر'),
(7, 'پسر '),
(13, 'پسر متاهل');

-- --------------------------------------------------------

--
-- Table structure for table `users_role`
--

CREATE TABLE `users_role` (
  `id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`permissions`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_role`
--

INSERT INTO `users_role` (`id`, `name`, `description`, `permissions`) VALUES
(1, 'super_admin', '', '{}'),
(2, 'department_manager', '', '{}'),
(3, 'supervisor', '', '{}'),
(4, 'employee', '', '{}'),
(5, 'holding_manager', '', '{}'),
(6, 'factory_manager', '', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `users_subdepartment`
--

CREATE TABLE `users_subdepartment` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `department_id` bigint(20) NOT NULL,
  `supervisor_id` bigint(20) DEFAULT NULL,
  `is_committee` tinyint(1) NOT NULL,
  `linked_factory_id` bigint(20) DEFAULT NULL,
  `is_restaurant` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_subdepartment`
--

INSERT INTO `users_subdepartment` (`id`, `name`, `created_at`, `department_id`, `supervisor_id`, `is_committee`, `linked_factory_id`, `is_restaurant`) VALUES
(1, 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:55:19.727372', 5, 27, 0, NULL, 0),
(2, 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:55:44.429424', 5, 26, 0, NULL, 0),
(3, 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:55:59.701285', 6, NULL, 0, NULL, 0),
(4, 'زیر بخش 2 بخش 2 کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-10-29 04:56:16.078186', 6, NULL, 0, NULL, 0),
(5, 'زیر بخش 1 بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:56:31.093333', 7, NULL, 0, NULL, 0),
(6, 'زیر بخش 2 بخش 1 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:56:43.333359', 7, NULL, 0, NULL, 0),
(7, 'زیر بخش 1 بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:56:58.005360', 8, NULL, 0, NULL, 0),
(8, 'زیر بخش 2 بخش 2 کارخانه تست 2 هلدینگ اصفهان مقدم', '2025-10-29 04:57:08.884362', 8, NULL, 0, NULL, 0),
(9, 'زیر بخش 1 بخش 1 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:57:28.220870', 9, NULL, 0, NULL, 0),
(10, 'زیر بخش 2 بخش 1 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:57:37.621527', 9, NULL, 0, NULL, 0),
(11, 'زیر بخش 1 بخش 2 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:57:45.830401', 10, NULL, 0, NULL, 0),
(12, 'زیر بخش 2 بخش 2 کارخانه تست 1 هلدینگ تست 2', '2025-10-29 04:57:58.189347', 10, NULL, 0, NULL, 0),
(13, 'زیر بخش 1 بخش 1 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:58:07.109344', 11, NULL, 0, NULL, 0),
(14, 'زیر بخش 2 بخش 1 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:58:13.279837', 11, 27, 0, NULL, 0),
(15, 'زیر بخش 1 بخش 2 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:58:19.837350', 12, NULL, 0, NULL, 0),
(16, 'زیر بخش 2 بخش 2 کارخانه تست 2 هلدینگ تست 2', '2025-10-29 04:58:34.549309', 12, NULL, 0, NULL, 0),
(17, 'تولید پاکت سازی تست', '2025-11-01 09:17:58.792544', 13, 33, 0, NULL, 0),
(18, 'کمیته ورزش کارخانه تست 1 هلدینگ اصفهان مقدم', '2025-11-12 10:43:08.000000', 14, 26, 1, 2, 0),
(19, 'رستوران اول', '2025-11-20 10:27:59.000000', 16, 26, 0, NULL, 1),
(20, 'رستوران دوم', '2025-11-20 10:28:53.000000', 16, 26, 0, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_weeklymenu`
--

CREATE TABLE `users_weeklymenu` (
  `id` bigint(20) NOT NULL,
  `week_start_date` date NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `restaurant_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users_weeklymenu`
--

INSERT INTO `users_weeklymenu` (`id`, `week_start_date`, `created_at`, `is_active`, `restaurant_id`) VALUES
(17, '2025-11-22', '2025-11-27 09:54:01.272526', 1, 19),
(19, '2025-12-06', '2025-11-29 04:41:48.217134', 1, 19),
(20, '2025-11-22', '2025-11-29 04:41:48.250167', 1, 20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `axes_accessattempt`
--
ALTER TABLE `axes_accessattempt`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `axes_accessattempt_username_ip_address_user_agent_8ea22282_uniq` (`username`,`ip_address`,`user_agent`),
  ADD KEY `axes_accessattempt_ip_address_10922d9c` (`ip_address`),
  ADD KEY `axes_accessattempt_user_agent_ad89678b` (`user_agent`),
  ADD KEY `axes_accessattempt_username_3f2d4ca0` (`username`);

--
-- Indexes for table `axes_accessfailurelog`
--
ALTER TABLE `axes_accessfailurelog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `axes_accessfailurelog_user_agent_ea145dda` (`user_agent`),
  ADD KEY `axes_accessfailurelog_ip_address_2e9f5a7f` (`ip_address`),
  ADD KEY `axes_accessfailurelog_username_a8b7e8a4` (`username`);

--
-- Indexes for table `axes_accesslog`
--
ALTER TABLE `axes_accesslog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `axes_accesslog_ip_address_86b417e5` (`ip_address`),
  ADD KEY `axes_accesslog_user_agent_0e659004` (`user_agent`),
  ADD KEY `axes_accesslog_username_df93064b` (`username`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_users_employee_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `evaluations_employeeevaluation`
--
ALTER TABLE `evaluations_employeeevaluation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `evaluations_employee_criteria_id_6681f475_fk_evaluatio` (`criteria_id`),
  ADD KEY `evaluations_employee_employee_id_f52cc56a_fk_users_emp` (`employee_id`),
  ADD KEY `evaluations_employee_evaluator_id_ab3de6b6_fk_users_emp` (`evaluator_id`);

--
-- Indexes for table `evaluations_evaluationcriteria`
--
ALTER TABLE `evaluations_evaluationcriteria`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `evaluations_evaluationscore`
--
ALTER TABLE `evaluations_evaluationscore`
  ADD PRIMARY KEY (`id`),
  ADD KEY `evaluations_evaluati_evaluation_id_b2669d2c_fk_evaluatio` (`evaluation_id`),
  ADD KEY `evaluations_evaluati_scored_by_id_41cfb7ed_fk_users_emp` (`scored_by_id`);

--
-- Indexes for table `users_bankaccount`
--
ALTER TABLE `users_bankaccount`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sheba_number` (`sheba_number`),
  ADD KEY `users_bankaccount_employee_id_9d34739c_fk_users_employee_id` (`employee_id`),
  ADD KEY `users_bankaccount_dependent_id_f65be6e8_fk_users_dependent_id` (`dependent_id`),
  ADD KEY `users_bankaccount_bank_account_type_id_89b978ad_fk_users_ban` (`bank_account_type_id`),
  ADD KEY `users_bankaccount_bank_id_0503602b_fk_users_banks_code` (`bank_id`);

--
-- Indexes for table `users_bankaccounttype`
--
ALTER TABLE `users_bankaccounttype`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_banks`
--
ALTER TABLE `users_banks`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_baseinsurance`
--
ALTER TABLE `users_baseinsurance`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_contactinfo`
--
ALTER TABLE `users_contactinfo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_contactinfo_employee_id_25226f3f_fk_users_employee_id` (`employee_id`),
  ADD KEY `users_contactinfo_dependent_id_49e8c8fb_fk_users_dependent_id` (`dependent_id`);

--
-- Indexes for table `users_country`
--
ALTER TABLE `users_country`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_department`
--
ALTER TABLE `users_department`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_department_factory_id_b68fd2c1_fk_users_factory_id` (`factory_id`),
  ADD KEY `users_department_manager_id_003419d1_fk_users_employee_id` (`manager_id`),
  ADD KEY `users_department_manager_2_id_9fb74ad8_fk_users_employee_id` (`manager_2_id`),
  ADD KEY `users_department_manager_3_id_0b7a530e_fk_users_employee_id` (`manager_3_id`),
  ADD KEY `users_department_linked_factory_id_1dd4617b_fk_users_factory_id` (`linked_factory_id`);

--
-- Indexes for table `users_dependencystatus`
--
ALTER TABLE `users_dependencystatus`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_dependent`
--
ALTER TABLE `users_dependent`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `users_dependent_employee_id_national_id_6b6de84e_uniq` (`employee_id`,`national_id`),
  ADD KEY `users_dependent_country_id_a6054535_fk_users_country_code` (`country_id`),
  ADD KEY `users_dependent_dependency_status_id_f3f87659_fk_users_dep` (`dependency_status_id`),
  ADD KEY `users_dependent_gender_id_3fdbd48a_fk_users_gender_code` (`gender_id`),
  ADD KEY `users_dependent_marital_status_id_8d74136d_fk_users_mar` (`marital_status_id`),
  ADD KEY `users_dependent_relative_type_id_cb99a391_fk_users_rel` (`relative_type_id`);

--
-- Indexes for table `users_employee`
--
ALTER TABLE `users_employee`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD KEY `users_employee_food_receiver_factor_10bef694_fk_users_fac` (`food_receiver_factory_id`),
  ADD KEY `users_employee_food_receiver_holdin_4866b439_fk_users_hol` (`food_receiver_holding_id`),
  ADD KEY `users_employee_dependency_status_id_a6cfb068_fk_users_dep` (`dependency_status_id`),
  ADD KEY `users_employee_gender_id_4dc9eb3a_fk_users_gender_code` (`gender_id`),
  ADD KEY `users_employee_marital_status_id_a7e621bb_fk_users_mar` (`marital_status_id`);

--
-- Indexes for table `users_employee_assigned_subdepartments`
--
ALTER TABLE `users_employee_assigned_subdepartments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_employee_assigned__employee_id_subdepartmen_6ad02a7c_uniq` (`employee_id`,`subdepartment_id`),
  ADD KEY `users_employee_assig_subdepartment_id_248a6372_fk_users_sub` (`subdepartment_id`);

--
-- Indexes for table `users_employee_bimeh`
--
ALTER TABLE `users_employee_bimeh`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_employee_bimeh_country_id_f7f50c86_fk_users_country_code` (`country_id`),
  ADD KEY `users_employee_bimeh_employee_id_8b347bc4_fk_users_employee_id` (`employee_id`),
  ADD KEY `users_employee_bimeh_employment_type_id_8bff8cab_fk_users_emp` (`employment_type_id`),
  ADD KEY `users_employee_bimeh_job_group_id_2c0cf641_fk_users_job` (`job_group_id`),
  ADD KEY `users_employee_bimeh_base_insurance_id_5eef2017_fk_users_bas` (`base_insurance_id`),
  ADD KEY `users_employee_bimeh_previous_insurer_id_99fa74dd_fk_users_pre` (`previous_insurer_id`);

--
-- Indexes for table `users_employee_groups`
--
ALTER TABLE `users_employee_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_employee_groups_employee_id_group_id_6931f772_uniq` (`employee_id`,`group_id`),
  ADD KEY `users_employee_groups_group_id_83a49623_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `users_employee_roles`
--
ALTER TABLE `users_employee_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_employee_roles_employee_id_role_id_ba0767ca_uniq` (`employee_id`,`role_id`),
  ADD KEY `users_employee_roles_role_id_a0922306_fk_users_role_id` (`role_id`);

--
-- Indexes for table `users_employee_user_permissions`
--
ALTER TABLE `users_employee_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_employee_user_perm_employee_id_permission_i_f9447178_uniq` (`employee_id`,`permission_id`),
  ADD KEY `users_employee_user__permission_id_3ae371ef_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `users_employmenttype`
--
ALTER TABLE `users_employmenttype`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_evaluation`
--
ALTER TABLE `users_evaluation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_evaluation_user_id_period_created_at_0a9da186_uniq` (`user_id`,`period`,`created_at`);

--
-- Indexes for table `users_factory`
--
ALTER TABLE `users_factory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_factory_holding_id_2275cf3b_fk_users_holding_id` (`holding_id`),
  ADD KEY `users_factory_manager_id_9d50c50e_fk_users_employee_id` (`manager_id`),
  ADD KEY `users_factory_linked_factory_id_d754ef6b_fk_users_factory_id` (`linked_factory_id`);

--
-- Indexes for table `users_fooditem`
--
ALTER TABLE `users_fooditem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_foodreservation`
--
ALTER TABLE `users_foodreservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_foodreservation_menu_item_id_b2606ab4_fk_users_menuitem_id` (`menu_item_id`),
  ADD KEY `users_foodreservation_reservation_date_4ba7ca07` (`reservation_date`),
  ADD KEY `users_foodreservation_employee_id_c88bcad5` (`employee_id`),
  ADD KEY `users_foodreservatio_related_factory_id_80caf8f2_fk_users_fac` (`related_factory_id`);

--
-- Indexes for table `users_gender`
--
ALTER TABLE `users_gender`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `users_holding`
--
ALTER TABLE `users_holding`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_holding_manager_id_279f236e_fk_users_employee_id` (`manager_id`);

--
-- Indexes for table `users_jobgroup`
--
ALTER TABLE `users_jobgroup`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `title` (`name`);

--
-- Indexes for table `users_maritalstatus`
--
ALTER TABLE `users_maritalstatus`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_menuitem`
--
ALTER TABLE `users_menuitem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_menuitem_weekly_menu_id_food_id_day_persian_edf1d17d_uniq` (`weekly_menu_id`,`food_id`,`day_persian`),
  ADD KEY `users_menuitem_food_id_7246bf88_fk_users_fooditem_id` (`food_id`),
  ADD KEY `users_menuitem_weekly_menu_id_eb07fea2` (`weekly_menu_id`);

--
-- Indexes for table `users_notification`
--
ALTER TABLE `users_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_notification_created_by_id_9c100210_fk_users_employee_id` (`created_by_id`);

--
-- Indexes for table `users_notificationread`
--
ALTER TABLE `users_notificationread`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notificationread_notification_id_employee_id_75795c09_uniq` (`notification_id`,`employee_id`),
  ADD KEY `users_notificationread_employee_id_3e014ed4_fk_users_employee_id` (`employee_id`);

--
-- Indexes for table `users_notification_employee_subdepartments`
--
ALTER TABLE `users_notification_employee_subdepartments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_emplo_notification_id_subdepar_3c6d288a_uniq` (`notification_id`,`subdepartment_id`),
  ADD KEY `users_notification_e_subdepartment_id_0ce9aeea_fk_users_sub` (`subdepartment_id`);

--
-- Indexes for table `users_notification_target_departments`
--
ALTER TABLE `users_notification_target_departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_targe_notification_id_departme_d7fa9d6a_uniq` (`notification_id`,`department_id`),
  ADD KEY `users_notification_t_department_id_40f927b7_fk_users_dep` (`department_id`);

--
-- Indexes for table `users_notification_target_factories`
--
ALTER TABLE `users_notification_target_factories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_targe_notification_id_factory__434d9318_uniq` (`notification_id`,`factory_id`),
  ADD KEY `users_notification_t_factory_id_018f49e7_fk_users_fac` (`factory_id`);

--
-- Indexes for table `users_notification_target_holdings`
--
ALTER TABLE `users_notification_target_holdings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_targe_notification_id_holding__48b287ad_uniq` (`notification_id`,`holding_id`),
  ADD KEY `users_notification_t_holding_id_c6e1c0d9_fk_users_hol` (`holding_id`);

--
-- Indexes for table `users_notification_target_roles`
--
ALTER TABLE `users_notification_target_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_targe_notification_id_role_id_39834be6_uniq` (`notification_id`,`role_id`),
  ADD KEY `users_notification_t_role_id_ad2b9f31_fk_users_rol` (`role_id`);

--
-- Indexes for table `users_notification_target_subdepartments`
--
ALTER TABLE `users_notification_target_subdepartments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_notification_targe_notification_id_subdepar_3397e7b1_uniq` (`notification_id`,`subdepartment_id`),
  ADD KEY `users_notification_t_subdepartment_id_b858519e_fk_users_sub` (`subdepartment_id`);

--
-- Indexes for table `users_orgunit`
--
ALTER TABLE `users_orgunit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `path_key` (`path_key`),
  ADD KEY `users_orgunit_department_id_ea4b1f9a_fk_users_department_id` (`department_id`),
  ADD KEY `users_orgunit_factory_id_14ec0597_fk_users_factory_id` (`factory_id`),
  ADD KEY `users_orgunit_holding_id_c19cc832_fk_users_holding_id` (`holding_id`),
  ADD KEY `users_orgunit_subdepartment_id_d6987fce_fk_users_sub` (`subdepartment_id`);

--
-- Indexes for table `users_participation`
--
ALTER TABLE `users_participation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_participation_user_id_23e72f0b_fk_users_employee_id` (`user_id`),
  ADD KEY `users_participation_factory_id_7e11162d_fk_users_factory_id` (`factory_id`),
  ADD KEY `users_participation_department_id_a2075230_fk_users_dep` (`department_id`),
  ADD KEY `users_participation_holding_id_dcb1f6d8_fk_users_holding_id` (`holding_id`),
  ADD KEY `users_participation_subdepartment_id_bfa404c3_fk_users_sub` (`subdepartment_id`),
  ADD KEY `users_participation_department_committee_9be014c7_fk_users_dep` (`department_committee_id`),
  ADD KEY `users_participation_factory_committee_id_67584fa4_fk_users_fac` (`factory_committee_id`),
  ADD KEY `users_participation_holding_committee_id_30c95d55_fk_users_hol` (`holding_committee_id`),
  ADD KEY `users_participation_subdepartment_commit_09115397_fk_users_sub` (`subdepartment_committee_id`);

--
-- Indexes for table `users_permissionlevel`
--
ALTER TABLE `users_permissionlevel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_id` (`role_id`);

--
-- Indexes for table `users_previousinsurer`
--
ALTER TABLE `users_previousinsurer`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_referral`
--
ALTER TABLE `users_referral`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_referral_created_by_role_id_24c2de2e_fk_users_role_id` (`created_by_role_id`),
  ADD KEY `users_referral_created_by_unit_id_0b030c4d_fk_users_orgunit_id` (`created_by_unit_id`),
  ADD KEY `users_referral_created_by_user_id_cd765870_fk_users_employee_id` (`created_by_user_id`),
  ADD KEY `users_referral_final_unit_id_5678a4e6_fk_users_orgunit_id` (`final_unit_id`),
  ADD KEY `users_referral_participation_id_9189aec7_fk_users_par` (`participation_id`);

--
-- Indexes for table `users_referralstep`
--
ALTER TABLE `users_referralstep`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_referralstep_referral_id_order_82d31db3_uniq` (`referral_id`,`order`),
  ADD KEY `users_referralstep_from_role_id_dae90a4e_fk_users_role_id` (`from_role_id`),
  ADD KEY `users_referralstep_from_unit_id_bcd681bd_fk_users_orgunit_id` (`from_unit_id`),
  ADD KEY `users_referralstep_from_user_id_3b30bf28_fk_users_employee_id` (`from_user_id`),
  ADD KEY `users_referralstep_to_role_id_2e43ea61_fk_users_role_id` (`to_role_id`),
  ADD KEY `users_referralstep_to_unit_id_aece3366_fk_users_orgunit_id` (`to_unit_id`),
  ADD KEY `users_referralstep_to_user_id_5a988790_fk_users_employee_id` (`to_user_id`);

--
-- Indexes for table `users_relativetype`
--
ALTER TABLE `users_relativetype`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_role`
--
ALTER TABLE `users_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users_subdepartment`
--
ALTER TABLE `users_subdepartment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_subdepartment_department_id_48b07284_fk_users_dep` (`department_id`),
  ADD KEY `users_subdepartment_supervisor_id_4568e3b3_fk_users_employee_id` (`supervisor_id`),
  ADD KEY `users_subdepartment_linked_factory_id_d7f4b32e_fk_users_fac` (`linked_factory_id`);

--
-- Indexes for table `users_weeklymenu`
--
ALTER TABLE `users_weeklymenu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_weeklymenu_restaurant_id_week_start_date_30227a19_uniq` (`restaurant_id`,`week_start_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `axes_accessattempt`
--
ALTER TABLE `axes_accessattempt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `axes_accessfailurelog`
--
ALTER TABLE `axes_accessfailurelog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `axes_accesslog`
--
ALTER TABLE `axes_accesslog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=457;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `evaluations_employeeevaluation`
--
ALTER TABLE `evaluations_employeeevaluation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `evaluations_evaluationcriteria`
--
ALTER TABLE `evaluations_evaluationcriteria`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `evaluations_evaluationscore`
--
ALTER TABLE `evaluations_evaluationscore`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_bankaccount`
--
ALTER TABLE `users_bankaccount`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_contactinfo`
--
ALTER TABLE `users_contactinfo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_department`
--
ALTER TABLE `users_department`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users_dependent`
--
ALTER TABLE `users_dependent`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users_employee`
--
ALTER TABLE `users_employee`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `users_employee_assigned_subdepartments`
--
ALTER TABLE `users_employee_assigned_subdepartments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users_employee_bimeh`
--
ALTER TABLE `users_employee_bimeh`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users_employee_groups`
--
ALTER TABLE `users_employee_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_employee_roles`
--
ALTER TABLE `users_employee_roles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `users_employee_user_permissions`
--
ALTER TABLE `users_employee_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_evaluation`
--
ALTER TABLE `users_evaluation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users_factory`
--
ALTER TABLE `users_factory`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users_fooditem`
--
ALTER TABLE `users_fooditem`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users_foodreservation`
--
ALTER TABLE `users_foodreservation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=784;

--
-- AUTO_INCREMENT for table `users_holding`
--
ALTER TABLE `users_holding`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users_menuitem`
--
ALTER TABLE `users_menuitem`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=453;

--
-- AUTO_INCREMENT for table `users_notification`
--
ALTER TABLE `users_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users_notificationread`
--
ALTER TABLE `users_notificationread`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_notification_employee_subdepartments`
--
ALTER TABLE `users_notification_employee_subdepartments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users_notification_target_departments`
--
ALTER TABLE `users_notification_target_departments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users_notification_target_factories`
--
ALTER TABLE `users_notification_target_factories`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users_notification_target_holdings`
--
ALTER TABLE `users_notification_target_holdings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users_notification_target_roles`
--
ALTER TABLE `users_notification_target_roles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_notification_target_subdepartments`
--
ALTER TABLE `users_notification_target_subdepartments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users_orgunit`
--
ALTER TABLE `users_orgunit`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users_participation`
--
ALTER TABLE `users_participation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=224;

--
-- AUTO_INCREMENT for table `users_permissionlevel`
--
ALTER TABLE `users_permissionlevel`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users_referral`
--
ALTER TABLE `users_referral`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users_referralstep`
--
ALTER TABLE `users_referralstep`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users_role`
--
ALTER TABLE `users_role`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users_subdepartment`
--
ALTER TABLE `users_subdepartment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users_weeklymenu`
--
ALTER TABLE `users_weeklymenu`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_employee_id` FOREIGN KEY (`user_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `evaluations_employeeevaluation`
--
ALTER TABLE `evaluations_employeeevaluation`
  ADD CONSTRAINT `evaluations_employee_criteria_id_6681f475_fk_evaluatio` FOREIGN KEY (`criteria_id`) REFERENCES `evaluations_evaluationcriteria` (`id`),
  ADD CONSTRAINT `evaluations_employee_employee_id_f52cc56a_fk_users_emp` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `evaluations_employee_evaluator_id_ab3de6b6_fk_users_emp` FOREIGN KEY (`evaluator_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `evaluations_evaluationscore`
--
ALTER TABLE `evaluations_evaluationscore`
  ADD CONSTRAINT `evaluations_evaluati_evaluation_id_b2669d2c_fk_evaluatio` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations_employeeevaluation` (`id`),
  ADD CONSTRAINT `evaluations_evaluati_scored_by_id_41cfb7ed_fk_users_emp` FOREIGN KEY (`scored_by_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_bankaccount`
--
ALTER TABLE `users_bankaccount`
  ADD CONSTRAINT `users_bankaccount_bank_account_type_id_89b978ad_fk_users_ban` FOREIGN KEY (`bank_account_type_id`) REFERENCES `users_bankaccounttype` (`code`),
  ADD CONSTRAINT `users_bankaccount_bank_id_0503602b_fk_users_banks_code` FOREIGN KEY (`bank_id`) REFERENCES `users_banks` (`code`),
  ADD CONSTRAINT `users_bankaccount_dependent_id_f65be6e8_fk_users_dependent_id` FOREIGN KEY (`dependent_id`) REFERENCES `users_dependent` (`id`),
  ADD CONSTRAINT `users_bankaccount_employee_id_9d34739c_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_contactinfo`
--
ALTER TABLE `users_contactinfo`
  ADD CONSTRAINT `users_contactinfo_dependent_id_49e8c8fb_fk_users_dependent_id` FOREIGN KEY (`dependent_id`) REFERENCES `users_dependent` (`id`),
  ADD CONSTRAINT `users_contactinfo_employee_id_25226f3f_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_department`
--
ALTER TABLE `users_department`
  ADD CONSTRAINT `users_department_factory_id_b68fd2c1_fk_users_factory_id` FOREIGN KEY (`factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_department_linked_factory_id_1dd4617b_fk_users_factory_id` FOREIGN KEY (`linked_factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_department_manager_2_id_9fb74ad8_fk_users_employee_id` FOREIGN KEY (`manager_2_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_department_manager_3_id_0b7a530e_fk_users_employee_id` FOREIGN KEY (`manager_3_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_department_manager_id_003419d1_fk_users_employee_id` FOREIGN KEY (`manager_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_dependent`
--
ALTER TABLE `users_dependent`
  ADD CONSTRAINT `users_dependent_country_id_a6054535_fk_users_country_code` FOREIGN KEY (`country_id`) REFERENCES `users_country` (`code`),
  ADD CONSTRAINT `users_dependent_dependency_status_id_f3f87659_fk_users_dep` FOREIGN KEY (`dependency_status_id`) REFERENCES `users_dependencystatus` (`code`),
  ADD CONSTRAINT `users_dependent_employee_id_913457be_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_dependent_gender_id_3fdbd48a_fk_users_gender_code` FOREIGN KEY (`gender_id`) REFERENCES `users_gender` (`code`),
  ADD CONSTRAINT `users_dependent_marital_status_id_8d74136d_fk_users_mar` FOREIGN KEY (`marital_status_id`) REFERENCES `users_maritalstatus` (`code`),
  ADD CONSTRAINT `users_dependent_relative_type_id_cb99a391_fk_users_rel` FOREIGN KEY (`relative_type_id`) REFERENCES `users_relativetype` (`code`);

--
-- Constraints for table `users_employee`
--
ALTER TABLE `users_employee`
  ADD CONSTRAINT `users_employee_dependency_status_id_a6cfb068_fk_users_dep` FOREIGN KEY (`dependency_status_id`) REFERENCES `users_dependencystatus` (`code`),
  ADD CONSTRAINT `users_employee_food_receiver_factor_10bef694_fk_users_fac` FOREIGN KEY (`food_receiver_factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_employee_food_receiver_holdin_4866b439_fk_users_hol` FOREIGN KEY (`food_receiver_holding_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_employee_gender_id_4dc9eb3a_fk_users_gender_code` FOREIGN KEY (`gender_id`) REFERENCES `users_gender` (`code`),
  ADD CONSTRAINT `users_employee_marital_status_id_a7e621bb_fk_users_mar` FOREIGN KEY (`marital_status_id`) REFERENCES `users_maritalstatus` (`code`);

--
-- Constraints for table `users_employee_assigned_subdepartments`
--
ALTER TABLE `users_employee_assigned_subdepartments`
  ADD CONSTRAINT `users_employee_assig_employee_id_956c1dcd_fk_users_emp` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_employee_assig_subdepartment_id_248a6372_fk_users_sub` FOREIGN KEY (`subdepartment_id`) REFERENCES `users_subdepartment` (`id`);

--
-- Constraints for table `users_employee_bimeh`
--
ALTER TABLE `users_employee_bimeh`
  ADD CONSTRAINT `users_employee_bimeh_base_insurance_id_5eef2017_fk_users_bas` FOREIGN KEY (`base_insurance_id`) REFERENCES `users_baseinsurance` (`code`),
  ADD CONSTRAINT `users_employee_bimeh_country_id_f7f50c86_fk_users_country_code` FOREIGN KEY (`country_id`) REFERENCES `users_country` (`code`),
  ADD CONSTRAINT `users_employee_bimeh_employee_id_8b347bc4_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_employee_bimeh_employment_type_id_8bff8cab_fk_users_emp` FOREIGN KEY (`employment_type_id`) REFERENCES `users_employmenttype` (`code`),
  ADD CONSTRAINT `users_employee_bimeh_job_group_id_2c0cf641_fk_users_job` FOREIGN KEY (`job_group_id`) REFERENCES `users_jobgroup` (`code`),
  ADD CONSTRAINT `users_employee_bimeh_previous_insurer_id_99fa74dd_fk_users_pre` FOREIGN KEY (`previous_insurer_id`) REFERENCES `users_previousinsurer` (`code`);

--
-- Constraints for table `users_employee_groups`
--
ALTER TABLE `users_employee_groups`
  ADD CONSTRAINT `users_employee_groups_employee_id_968fa0a0_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_employee_groups_group_id_83a49623_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `users_employee_roles`
--
ALTER TABLE `users_employee_roles`
  ADD CONSTRAINT `users_employee_roles_employee_id_11352f01_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_employee_roles_role_id_a0922306_fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `users_role` (`id`);

--
-- Constraints for table `users_employee_user_permissions`
--
ALTER TABLE `users_employee_user_permissions`
  ADD CONSTRAINT `users_employee_user__employee_id_0590f38d_fk_users_emp` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_employee_user__permission_id_3ae371ef_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints for table `users_evaluation`
--
ALTER TABLE `users_evaluation`
  ADD CONSTRAINT `users_evaluation_user_id_a75dc854_fk_users_employee_id` FOREIGN KEY (`user_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_factory`
--
ALTER TABLE `users_factory`
  ADD CONSTRAINT `users_factory_holding_id_2275cf3b_fk_users_holding_id` FOREIGN KEY (`holding_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_factory_linked_factory_id_d754ef6b_fk_users_factory_id` FOREIGN KEY (`linked_factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_factory_manager_id_9d50c50e_fk_users_employee_id` FOREIGN KEY (`manager_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_foodreservation`
--
ALTER TABLE `users_foodreservation`
  ADD CONSTRAINT `users_foodreservatio_related_factory_id_80caf8f2_fk_users_fac` FOREIGN KEY (`related_factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_foodreservation_employee_id_c88bcad5_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_foodreservation_menu_item_id_b2606ab4_fk_users_menuitem_id` FOREIGN KEY (`menu_item_id`) REFERENCES `users_menuitem` (`id`);

--
-- Constraints for table `users_holding`
--
ALTER TABLE `users_holding`
  ADD CONSTRAINT `users_holding_manager_id_279f236e_fk_users_employee_id` FOREIGN KEY (`manager_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_menuitem`
--
ALTER TABLE `users_menuitem`
  ADD CONSTRAINT `users_menuitem_food_id_7246bf88_fk_users_fooditem_id` FOREIGN KEY (`food_id`) REFERENCES `users_fooditem` (`id`),
  ADD CONSTRAINT `users_menuitem_weekly_menu_id_eb07fea2_fk_users_weeklymenu_id` FOREIGN KEY (`weekly_menu_id`) REFERENCES `users_weeklymenu` (`id`);

--
-- Constraints for table `users_notification`
--
ALTER TABLE `users_notification`
  ADD CONSTRAINT `users_notification_created_by_id_9c100210_fk_users_employee_id` FOREIGN KEY (`created_by_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_notificationread`
--
ALTER TABLE `users_notificationread`
  ADD CONSTRAINT `users_notificationre_notification_id_b433d88e_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`),
  ADD CONSTRAINT `users_notificationread_employee_id_3e014ed4_fk_users_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_notification_employee_subdepartments`
--
ALTER TABLE `users_notification_employee_subdepartments`
  ADD CONSTRAINT `users_notification_e_notification_id_7d73ab52_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`),
  ADD CONSTRAINT `users_notification_e_subdepartment_id_0ce9aeea_fk_users_sub` FOREIGN KEY (`subdepartment_id`) REFERENCES `users_subdepartment` (`id`);

--
-- Constraints for table `users_notification_target_departments`
--
ALTER TABLE `users_notification_target_departments`
  ADD CONSTRAINT `users_notification_t_department_id_40f927b7_fk_users_dep` FOREIGN KEY (`department_id`) REFERENCES `users_department` (`id`),
  ADD CONSTRAINT `users_notification_t_notification_id_94c4f519_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`);

--
-- Constraints for table `users_notification_target_factories`
--
ALTER TABLE `users_notification_target_factories`
  ADD CONSTRAINT `users_notification_t_factory_id_018f49e7_fk_users_fac` FOREIGN KEY (`factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_notification_t_notification_id_082bd177_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`);

--
-- Constraints for table `users_notification_target_holdings`
--
ALTER TABLE `users_notification_target_holdings`
  ADD CONSTRAINT `users_notification_t_holding_id_c6e1c0d9_fk_users_hol` FOREIGN KEY (`holding_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_notification_t_notification_id_c1fe6b34_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`);

--
-- Constraints for table `users_notification_target_roles`
--
ALTER TABLE `users_notification_target_roles`
  ADD CONSTRAINT `users_notification_t_notification_id_30184e99_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`),
  ADD CONSTRAINT `users_notification_t_role_id_ad2b9f31_fk_users_rol` FOREIGN KEY (`role_id`) REFERENCES `users_role` (`id`);

--
-- Constraints for table `users_notification_target_subdepartments`
--
ALTER TABLE `users_notification_target_subdepartments`
  ADD CONSTRAINT `users_notification_t_notification_id_effae715_fk_users_not` FOREIGN KEY (`notification_id`) REFERENCES `users_notification` (`id`),
  ADD CONSTRAINT `users_notification_t_subdepartment_id_b858519e_fk_users_sub` FOREIGN KEY (`subdepartment_id`) REFERENCES `users_subdepartment` (`id`);

--
-- Constraints for table `users_orgunit`
--
ALTER TABLE `users_orgunit`
  ADD CONSTRAINT `users_orgunit_department_id_ea4b1f9a_fk_users_department_id` FOREIGN KEY (`department_id`) REFERENCES `users_department` (`id`),
  ADD CONSTRAINT `users_orgunit_factory_id_14ec0597_fk_users_factory_id` FOREIGN KEY (`factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_orgunit_holding_id_c19cc832_fk_users_holding_id` FOREIGN KEY (`holding_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_orgunit_subdepartment_id_d6987fce_fk_users_sub` FOREIGN KEY (`subdepartment_id`) REFERENCES `users_subdepartment` (`id`);

--
-- Constraints for table `users_participation`
--
ALTER TABLE `users_participation`
  ADD CONSTRAINT `users_participation_department_committee_9be014c7_fk_users_dep` FOREIGN KEY (`department_committee_id`) REFERENCES `users_department` (`id`),
  ADD CONSTRAINT `users_participation_department_id_a2075230_fk_users_dep` FOREIGN KEY (`department_id`) REFERENCES `users_department` (`id`),
  ADD CONSTRAINT `users_participation_factory_committee_id_67584fa4_fk_users_fac` FOREIGN KEY (`factory_committee_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_participation_factory_id_7e11162d_fk_users_factory_id` FOREIGN KEY (`factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_participation_holding_committee_id_30c95d55_fk_users_hol` FOREIGN KEY (`holding_committee_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_participation_holding_id_dcb1f6d8_fk_users_holding_id` FOREIGN KEY (`holding_id`) REFERENCES `users_holding` (`id`),
  ADD CONSTRAINT `users_participation_subdepartment_commit_09115397_fk_users_sub` FOREIGN KEY (`subdepartment_committee_id`) REFERENCES `users_subdepartment` (`id`),
  ADD CONSTRAINT `users_participation_subdepartment_id_bfa404c3_fk_users_sub` FOREIGN KEY (`subdepartment_id`) REFERENCES `users_subdepartment` (`id`),
  ADD CONSTRAINT `users_participation_user_id_23e72f0b_fk_users_employee_id` FOREIGN KEY (`user_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_permissionlevel`
--
ALTER TABLE `users_permissionlevel`
  ADD CONSTRAINT `users_permissionlevel_role_id_4397a2ed_fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `users_role` (`id`);

--
-- Constraints for table `users_referral`
--
ALTER TABLE `users_referral`
  ADD CONSTRAINT `users_referral_created_by_role_id_24c2de2e_fk_users_role_id` FOREIGN KEY (`created_by_role_id`) REFERENCES `users_role` (`id`),
  ADD CONSTRAINT `users_referral_created_by_unit_id_0b030c4d_fk_users_orgunit_id` FOREIGN KEY (`created_by_unit_id`) REFERENCES `users_orgunit` (`id`),
  ADD CONSTRAINT `users_referral_created_by_user_id_cd765870_fk_users_employee_id` FOREIGN KEY (`created_by_user_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_referral_final_unit_id_5678a4e6_fk_users_orgunit_id` FOREIGN KEY (`final_unit_id`) REFERENCES `users_orgunit` (`id`),
  ADD CONSTRAINT `users_referral_participation_id_9189aec7_fk_users_par` FOREIGN KEY (`participation_id`) REFERENCES `users_participation` (`id`);

--
-- Constraints for table `users_referralstep`
--
ALTER TABLE `users_referralstep`
  ADD CONSTRAINT `users_referralstep_from_role_id_dae90a4e_fk_users_role_id` FOREIGN KEY (`from_role_id`) REFERENCES `users_role` (`id`),
  ADD CONSTRAINT `users_referralstep_from_unit_id_bcd681bd_fk_users_orgunit_id` FOREIGN KEY (`from_unit_id`) REFERENCES `users_orgunit` (`id`),
  ADD CONSTRAINT `users_referralstep_from_user_id_3b30bf28_fk_users_employee_id` FOREIGN KEY (`from_user_id`) REFERENCES `users_employee` (`id`),
  ADD CONSTRAINT `users_referralstep_referral_id_d8096e16_fk_users_referral_id` FOREIGN KEY (`referral_id`) REFERENCES `users_referral` (`id`),
  ADD CONSTRAINT `users_referralstep_to_role_id_2e43ea61_fk_users_role_id` FOREIGN KEY (`to_role_id`) REFERENCES `users_role` (`id`),
  ADD CONSTRAINT `users_referralstep_to_unit_id_aece3366_fk_users_orgunit_id` FOREIGN KEY (`to_unit_id`) REFERENCES `users_orgunit` (`id`),
  ADD CONSTRAINT `users_referralstep_to_user_id_5a988790_fk_users_employee_id` FOREIGN KEY (`to_user_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_subdepartment`
--
ALTER TABLE `users_subdepartment`
  ADD CONSTRAINT `users_subdepartment_department_id_48b07284_fk_users_dep` FOREIGN KEY (`department_id`) REFERENCES `users_department` (`id`),
  ADD CONSTRAINT `users_subdepartment_linked_factory_id_d7f4b32e_fk_users_fac` FOREIGN KEY (`linked_factory_id`) REFERENCES `users_factory` (`id`),
  ADD CONSTRAINT `users_subdepartment_supervisor_id_4568e3b3_fk_users_employee_id` FOREIGN KEY (`supervisor_id`) REFERENCES `users_employee` (`id`);

--
-- Constraints for table `users_weeklymenu`
--
ALTER TABLE `users_weeklymenu`
  ADD CONSTRAINT `users_weeklymenu_restaurant_id_a6995759_fk_users_sub` FOREIGN KEY (`restaurant_id`) REFERENCES `users_subdepartment` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
