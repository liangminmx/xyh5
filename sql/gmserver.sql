/*
MySQL Data Transfer
Source Host: localhost
Source Database: wyj
Target Host: localhost
Target Database: wyj
Date: 2013/3/31 12:24:17
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for gm_account
-- ----------------------------
DROP TABLE IF EXISTS `gm_account`;
CREATE TABLE `gm_account` (
  `account` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for gm_announceloop
-- ----------------------------
DROP TABLE IF EXISTS `gm_announceloop`;
CREATE TABLE `gm_announceloop` (
  `announceid` int(10) unsigned NOT NULL DEFAULT '0',
  `serverid` int(10) unsigned DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `sendtime` bigint(20) unsigned DEFAULT NULL,
  `endtime` bigint(20) unsigned DEFAULT NULL,
  `interval` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`announceid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for gm_announceregular
-- ----------------------------
DROP TABLE IF EXISTS `gm_announceregular`;
CREATE TABLE `gm_announceregular` (
  `announceid` int(10) unsigned NOT NULL DEFAULT '0',
  `serverid` int(10) unsigned DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `sendtime` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`announceid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dbversion
-- ----------------------------
DROP TABLE IF EXISTS `dbversion`;
CREATE TABLE `dbversion` (
  `version_number` int(11) DEFAULT 0,
`db_key` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`version_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
insert into `dbversion` values(0, NULL);