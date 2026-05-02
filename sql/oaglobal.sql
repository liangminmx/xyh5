/*
MySQL Data Transfer
Source Host: localhost
Source Database: oa_global
Target Host: localhost
Target Database: oa_global
Date: 2015/10/14 18:19:33
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for chargeemoney
-- ----------------------------
DROP TABLE IF EXISTS `chargeemoney`;
CREATE TABLE `chargeemoney` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serverid` int(10) unsigned DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `viplev` int(10) unsigned DEFAULT NULL,
  `ip` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` int(20) unsigned DEFAULT NULL,
  `rmb` float unsigned DEFAULT NULL,
  `channel` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billno` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userName` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`),
  KEY `time` (`time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for consumeemoney
-- ----------------------------
DROP TABLE IF EXISTS `consumeemoney`;
CREATE TABLE `consumeemoney` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serverid` int(10) unsigned DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `viplev` int(10) unsigned DEFAULT NULL,
  `subnum` bigint(10) unsigned DEFAULT NULL,
  `amount` bigint(20) unsigned DEFAULT NULL,
  `auction` int(10) unsigned DEFAULT NULL,
  `targetid` int(10) unsigned DEFAULT NULL,
  `usermb` float unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
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
-- Records 
-- ----------------------------
INSERT INTO `dbversion` VALUES ('0', null);

-- ----------------------------
-- Table structure for user_last_login_info
-- ----------------------------
DROP TABLE IF EXISTS `user_last_login_info`;
CREATE TABLE `user_last_login_info` (
	`account` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`last_login_server` INT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP PROCEDURE IF EXISTS `GS_RECORD_LAST_LOGIN_SERVER`;
DELIMITER ;;

CREATE PROCEDURE `GS_RECORD_LAST_LOGIN_SERVER`(IN para_account char(255), IN para_serverid INT UNSIGNED)
begin
  declare db_num int DEFAULT 0;
  select count(*) from user_last_login_info where account = para_account into db_num;
  
  if db_num = 0 then
	insert into `user_last_login_info` values(para_account, para_serverid);
  else
	update `user_last_login_info` set last_login_server = para_serverid where account = para_account;
  end if;

end;;
DELIMITER ;

-- ----------------------------
-- Table structure for user_cover_info
-- ----------------------------
DROP TABLE IF EXISTS `user_cover_info`;
CREATE TABLE `user_cover_info` (
	`open_id` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`cover_num` INT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`open_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP PROCEDURE IF EXISTS `GS_RECORD_USER_COVER_INFO`;
DELIMITER ;;

CREATE PROCEDURE `GS_RECORD_USER_COVER_INFO`(IN para_openid char(255))
begin
  declare db_num int DEFAULT 0;
  select count(*) from user_cover_info where open_id = para_openid into db_num;
  
  if db_num = 0 then
	insert into `user_cover_info` values(para_openid, 1);
  else
	update `user_cover_info` set cover_num = cover_num + 1 where open_id = para_openid;
  end if;

end;;
DELIMITER ;


-- ----------------------------
-- Table structure for user_invite_info
-- ----------------------------
DROP TABLE IF EXISTS `user_invite_info`;
CREATE TABLE `user_invite_info` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`invitee` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `invitee`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP PROCEDURE IF EXISTS `GS_ADD_INVITE_INFO`;
DELIMITER ;;

CREATE PROCEDURE `GS_ADD_INVITE_INFO`(IN para_inviter bigint unsigned, IN para_invitee char(255))
begin
  declare db_num int DEFAULT 0;
  select count(*) from user_invite_info where characterid = para_inviter and invitee = para_invitee into db_num;
  
  if db_num = 0 then
	insert into `user_invite_info` values(para_inviter, para_invitee);
  end if;

end;;
DELIMITER ;
