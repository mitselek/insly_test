# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 146.148.112.232 (MySQL 5.7.11-google-log)
# Database: ww
# Generation Time: 2016-09-11 19:00:26 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table insly_contact
# ------------------------------------------------------------

DROP TABLE IF EXISTS `insly_contact`;

CREATE TABLE `insly_contact` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto increment',
  `type` varchar(50) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Email/phone/address. Consult if enum or even fk would be more appropriate.',
  `value` varchar(255) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Value of email/phone/address.',
  `fk_person` int(11) unsigned NOT NULL COMMENT 'Related person ID',
  `_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `_fk_created_by` int(11) unsigned NOT NULL,
  `_fk_changed_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_person` (`fk_person`),
  KEY `created_by` (`_fk_created_by`),
  KEY `changed_by` (`_fk_changed_by`),
  CONSTRAINT `contact_changed_by` FOREIGN KEY (`_fk_changed_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `contact_created_by` FOREIGN KEY (`_fk_created_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `contact_person` FOREIGN KEY (`fk_person`) REFERENCES `insly_crew` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci;



# Dump of table insly_crew
# ------------------------------------------------------------

DROP TABLE IF EXISTS `insly_crew`;

CREATE TABLE `insly_crew` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'auto increment',
  `pid` int(11) unsigned NOT NULL COMMENT 'Person ID',
  `name` varchar(255) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Everybody has a name. Mandatory',
  `birth_date` date NOT NULL COMMENT 'Extracted from person ID',
  `is_active` int(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Freshly created persons are inactive.',
  `_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `_fk_created_by` int(11) unsigned NOT NULL,
  `_fk_changed_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `crew_changed_by` (`_fk_changed_by`),
  KEY `crew_created_by` (`_fk_created_by`),
  CONSTRAINT `crew_changed_by` FOREIGN KEY (`_fk_changed_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `crew_created_by` FOREIGN KEY (`_fk_created_by`) REFERENCES `insly_crew` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci;



# Dump of table insly_cv
# ------------------------------------------------------------

DROP TABLE IF EXISTS `insly_cv`;

CREATE TABLE `insly_cv` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'auto increment',
  `fk_language` char(3) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'Kande keel',
  `fk_person` int(11) unsigned NOT NULL COMMENT 'Isik, kellel CV kandega on tegu',
  `intro` varchar(255) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Tutvustus',
  `experience` varchar(255) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Töökogemus',
  `education` varchar(255) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Haridus',
  `_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `_fk_created_by` int(11) unsigned NOT NULL,
  `_fk_changed_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_person` (`fk_person`),
  KEY `created_by` (`_fk_created_by`),
  KEY `changed_by` (`_fk_changed_by`),
  KEY `cv_language` (`fk_language`),
  CONSTRAINT `cv_changed_by` FOREIGN KEY (`_fk_changed_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `cv_created_by` FOREIGN KEY (`_fk_created_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `cv_language` FOREIGN KEY (`fk_language`) REFERENCES `insly_language` (`code`),
  CONSTRAINT `cv_person` FOREIGN KEY (`fk_person`) REFERENCES `insly_crew` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci;



# Dump of table insly_language
# ------------------------------------------------------------

DROP TABLE IF EXISTS `insly_language`;

CREATE TABLE `insly_language` (
  `code` char(3) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'Language code.',
  `language` varchar(50) COLLATE utf8_estonian_ci NOT NULL DEFAULT '' COMMENT 'Language name.',
  `_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `_fk_created_by` int(11) unsigned NOT NULL,
  `_fk_changed_by` int(11) unsigned NOT NULL,
  PRIMARY KEY (`code`),
  KEY `created_by` (`_fk_created_by`),
  KEY `changed_by` (`_fk_changed_by`),
  CONSTRAINT `language_changed_by` FOREIGN KEY (`_fk_changed_by`) REFERENCES `insly_crew` (`id`),
  CONSTRAINT `language_created_by` FOREIGN KEY (`_fk_created_by`) REFERENCES `insly_crew` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
