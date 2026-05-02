/*
MySQL Data Transfer
Source Host: localhost
Source Database: ws_dev
Target Host: localhost
Target Database: ws_dev
Date: 2015/10/14 18:19:44
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for cdkey
-- ----------------------------
DROP TABLE IF EXISTS `cdkey`;
CREATE TABLE `cdkey` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cdkey` char(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `beginTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `reward` int(10) unsigned NOT NULL DEFAULT '0',
  `account` char(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activeTime` datetime DEFAULT NULL,
  `gameserverid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `account` (`account`),
  KEY `cdkey` (`cdkey`),
  KEY `type` (`type`),
  KEY `reward` (`reward`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dbversion
-- ----------------------------
DROP TABLE IF EXISTS `dbversion`;
CREATE TABLE `dbversion` (
  `version_number` int(11) NOT NULL DEFAULT '0',
  `db_key` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`version_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for informtask
-- ----------------------------
DROP TABLE IF EXISTS `informtask`;
CREATE TABLE `informtask` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `openid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `contractid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `status` int(10) unsigned NOT NULL,
  `time` datetime DEFAULT NULL,
  `step` int(10) unsigned NOT NULL,
  `custom` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `character` (`openid`,`status`),
  KEY `contract` (`openid`,`contractid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for informtask_reward
-- ----------------------------
DROP TABLE IF EXISTS `informtask_reward`;
CREATE TABLE `informtask_reward` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `billno` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `gameserverid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `contractid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reward` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `rewardtime` datetime DEFAULT NULL,
  `step` int(10) unsigned NOT NULL,
  `custom` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `character` (`gameserverid`,`characterid`,`status`),
  KEY `contract` (`openid`,`contractid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for yellowvipgift
-- ----------------------------
DROP TABLE IF EXISTS `yellowvipgift`;
CREATE TABLE `yellowvipgift` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `billno` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `discountid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `gameserverid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openid` char(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reward` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `chargetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `character` (`gameserverid`,`characterid`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `dbversion` VALUES ('0', null);


-- ----------------------------
-- Table structure for antiaddition
-- ----------------------------
DROP TABLE IF EXISTS `antiaddition`;
CREATE TABLE `antiaddition` (
  `account` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `onlinetime` int(10) unsigned DEFAULT NULL,
  `offlinetime` int(10) unsigned DEFAULT NULL,
  `birthday` bigint(10) unsigned DEFAULT NULL,
  `lastofflinetime` bigint(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `crossarena_time`
-- ----------------------------
DROP TABLE IF EXISTS `crossarena_time`;
CREATE TABLE `crossarena_time` (
	`seasonbegintime` DATETIME NULL DEFAULT '0000-00-00 00:00:00',
	`seasionindex` INT(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
