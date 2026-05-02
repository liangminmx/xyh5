/*
MySQL Data Transfer
Source Host: localhost
Source Database: oa_dev
Target Host: localhost
Target Database: oa_dev
Date: 2015/10/14 18:17:51
*/

SET FOREIGN_KEY_CHECKS=0;


-- ----------------------------
-- Table structure for advancedward
-- ----------------------------
DROP TABLE IF EXISTS `advancedward`;
CREATE TABLE `advancedward` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `advancedwardID` int(10) unsigned DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `realm` int(10) unsigned DEFAULT NULL,
  `stage` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for advancedwardget
-- ----------------------------
DROP TABLE IF EXISTS `advancedwardget`;
CREATE TABLE `advancedwardget` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `advancedwardID` int(10) unsigned DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `realm` int(10) unsigned DEFAULT NULL,
  `stage` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

 
-- ----------------------------
-- Table structure for changename
-- ----------------------------
DROP TABLE IF EXISTS `changename`;
CREATE TABLE `changename` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `beforename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `newname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for clientloading
-- ----------------------------
DROP TABLE IF EXISTS `clientloading`;
CREATE TABLE `clientloading` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `int_mark` int(10) unsigned DEFAULT NULL,
  `str_mark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`),
  KEY `int_mark` (`int_mark`),
  KEY `str_mark` (`str_mark`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for contribute
-- ----------------------------
DROP TABLE IF EXISTS `contribute`;
CREATE TABLE `contribute` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `guildid` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for createcharacter
-- ----------------------------
DROP TABLE IF EXISTS `createcharacter`;
CREATE TABLE `createcharacter` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `mediaactivityid` varchar(255) COLLATE utf8_unicode_ci DEFAULT '0',
  `submediaactivityid` varchar(255) COLLATE utf8_unicode_ci DEFAULT '0',
  `loginsrc` text COLLATE utf8_unicode_ci,
  `pf` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_emoney
-- ----------------------------
DROP TABLE IF EXISTS `log_emoney`;
CREATE TABLE `log_emoney` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  `chargenum` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for emoney2
-- ----------------------------
DROP TABLE IF EXISTS `emoney2`;
CREATE TABLE `emoney2` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_stamina
-- ----------------------------
DROP TABLE IF EXISTS `log_stamina`;
CREATE TABLE `log_stamina` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` int(10) unsigned DEFAULT NULL,
  `amount2` int(10) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for exp
-- ----------------------------
DROP TABLE IF EXISTS `exp`;
CREATE TABLE `exp` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `levbefore` int(20) unsigned DEFAULT NULL,
  `levafter` int(20) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for festival_consume_reward
-- ----------------------------
DROP TABLE IF EXISTS `festival_consume_reward`;
CREATE TABLE `festival_consume_reward` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `festivalid` int(10) unsigned DEFAULT NULL,
  `rewardid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for fightrewardget
-- ----------------------------
DROP TABLE IF EXISTS `fightrewardget`;
CREATE TABLE `fightrewardget` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for guild_create
-- ----------------------------
DROP TABLE IF EXISTS `guild_create`;
CREATE TABLE `guild_create` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guildid` int(10) unsigned DEFAULT NULL,
  `typeid` int(10) unsigned DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for guild_destroy
-- ----------------------------
DROP TABLE IF EXISTS `guild_destroy`;
CREATE TABLE `guild_destroy` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guildid` int(10) unsigned DEFAULT NULL,
  `typeid` int(10) unsigned DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for guild_rename
-- ----------------------------
DROP TABLE IF EXISTS `guild_rename`;
CREATE TABLE `guild_rename` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `guilid` int(10) unsigned DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL,
  `item_before` int(10) unsigned DEFAULT NULL,
  `item_after` int(10) unsigned DEFAULT NULL,
  `name_before` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_after` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for guildmoney
-- ----------------------------
DROP TABLE IF EXISTS `guildmoney`;
CREATE TABLE `guildmoney` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `guildid` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for honor
-- ----------------------------
DROP TABLE IF EXISTS `honor`;
CREATE TABLE `honor` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for item
-- ----------------------------
DROP TABLE IF EXISTS `log_item`;
CREATE TABLE `log_item` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` bigint(10) NOT NULL COMMENT 'time',
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item` int(10) unsigned DEFAULT NULL,
  `useorget` int(10) unsigned DEFAULT NULL,
  `action` int(10) unsigned DEFAULT NULL,
  `num_before` int(10) unsigned DEFAULT NULL,
  `num_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for land
-- ----------------------------
DROP TABLE IF EXISTS `log_qiday`;
CREATE TABLE `log_qiday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `continuenum` int(10) unsigned DEFAULT NULL,
  `getitem` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for landscape_enter
-- ----------------------------
DROP TABLE IF EXISTS `landscape_enter`;
CREATE TABLE `landscape_enter` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for landscape_reward
-- ----------------------------
DROP TABLE IF EXISTS `landscape_reward`;
CREATE TABLE `landscape_reward` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for mail
-- ----------------------------
DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `mailid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_money
-- ----------------------------
DROP TABLE IF EXISTS `log_money`;
CREATE TABLE `log_money` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- ----------------------------
-- Table structure for pay
-- ----------------------------
DROP TABLE IF EXISTS `pay`;
CREATE TABLE `pay` (
	`autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`time` DATETIME NULL DEFAULT NULL COMMENT '时间',
	`account` VARCHAR(64) NULL DEFAULT NULL COMMENT '账号' COLLATE 'utf8_unicode_ci',
	`characterid` BIGINT(20) UNSIGNED NULL DEFAULT NULL COMMENT '角色ID',
	`userLev` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '等级',
	`combatAbility` BIGINT(20) UNSIGNED NULL DEFAULT NULL COMMENT '战斗力',
	`vipLev` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'vip等级',
	`productNo` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '档次ID',
	`num` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '总共获得的元宝',
	`type` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '0:普通充值.1:GM充值',
	`billNo` VARCHAR(255) NULL DEFAULT NULL COMMENT '订单号' COLLATE 'utf8_unicode_ci',
	`userName` VARCHAR(255) NULL DEFAULT NULL COMMENT '玩家名字' COLLATE 'utf8_unicode_ci',
	`pf` VARCHAR(64) NULL DEFAULT NULL COMMENT '平台' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`autoid`),
	INDEX `ACCOUNT` (`account`),
	INDEX `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- ----------------------------
-- Table structure for log_register
-- ----------------------------
DROP TABLE IF EXISTS `log_register`;
CREATE TABLE `log_register` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL COMMENT 'uid',
  `loginname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time` bigint(10) NOT NULL COMMENT 'time',
  `pid` int(10) NOT NULL COMMENT '平台id',
  `sid` int(10) NOT NULL COMMENT '区服ID',
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client` int(10) NOT NULL COMMENT '客户端 0-web 1-ios 2-android',
  PRIMARY KEY (`autoid`),
  KEY `loginname` (`loginname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for recharge_turn
-- ----------------------------
DROP TABLE IF EXISTS `recharge_turn`;
CREATE TABLE `recharge_turn` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `gettype` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_soloserver_arena_cleantime
-- ----------------------------
DROP TABLE IF EXISTS `log_soloserver_arena_cleantime`;
CREATE TABLE `log_soloserver_arena_cleantime` (
  `autoid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `user_lev` int(10) unsigned DEFAULT NULL,
  `user_fighting` int(10) unsigned DEFAULT NULL,
  `time_before` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_soloserver_arena_fight
-- ----------------------------
DROP TABLE IF EXISTS `log_soloserver_arena_fight`;
CREATE TABLE `log_soloserver_arena_fight` (
  `autoid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `user_lev` int(10) unsigned DEFAULT NULL,
  `user_fighting` int(10) unsigned DEFAULT NULL,
  `target_type` int(10) unsigned DEFAULT NULL,
  `target_id` int(10) unsigned DEFAULT NULL,
  `target_lev` int(10) unsigned DEFAULT NULL,
  `target_fighting` int(10) unsigned DEFAULT NULL,
  `iswin` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_soloserver_arena_reward
-- ----------------------------
DROP TABLE IF EXISTS `log_soloserver_arena_reward`;
CREATE TABLE `log_soloserver_arena_reward` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `user_lev` int(10) unsigned DEFAULT NULL,
  `user_fighting` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for statistics_status
-- ----------------------------
DROP TABLE IF EXISTS `statistics_status`;
CREATE TABLE `statistics_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `onlinenum` int(10) unsigned DEFAULT NULL,
  `ip_count` int(10) unsigned DEFAULT NULL,
  `serverid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for supervip
-- ----------------------------
DROP TABLE IF EXISTS `supervip`;
CREATE TABLE `supervip` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `emoney` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for t_login
-- ----------------------------
DROP TABLE IF EXISTS `t_login`;
CREATE TABLE `t_login` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerlevel` int(10) unsigned DEFAULT NULL,
  `siteUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adFrom` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_moneylog
-- ----------------------------
DROP TABLE IF EXISTS `t_moneylog`;
CREATE TABLE `t_moneylog` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rootId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typeId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oldValue` int(10) unsigned DEFAULT NULL,
  `newValue` int(10) unsigned DEFAULT NULL,
  `gold` int(10) unsigned DEFAULT NULL,
  `goldTicke` int(10) unsigned DEFAULT NULL,
  `goodsId` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_moneylogconfig
-- ----------------------------
DROP TABLE IF EXISTS `t_moneylogconfig`;
CREATE TABLE `t_moneylogconfig` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rootid` int(10) unsigned DEFAULT NULL,
  `rootname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typeid` int(10) unsigned DEFAULT NULL,
  `typename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_newtask
-- ----------------------------
DROP TABLE IF EXISTS `t_newtask`;
CREATE TABLE `t_newtask` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taskId` int(10) unsigned DEFAULT NULL,
  `status` int(10) unsigned DEFAULT NULL,
  `quality` int(10) unsigned DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_newtaskconfig
-- ----------------------------
DROP TABLE IF EXISTS `t_newtaskconfig`;
CREATE TABLE `t_newtaskconfig` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskid` int(10) unsigned DEFAULT NULL,
  `taskname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taskOrder` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_offline
-- ----------------------------
DROP TABLE IF EXISTS `t_offline`;
CREATE TABLE `t_offline` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerlevel` int(10) unsigned DEFAULT NULL,
  `siteUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adFrom` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `onlineTime` int(10) unsigned DEFAULT NULL,
  `historyOnline` int(10) unsigned DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_online
-- ----------------------------
DROP TABLE IF EXISTS `t_online`;
CREATE TABLE `t_online` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `allcount` bigint(10) unsigned DEFAULT NULL,
  `cashcount` bigint(10) unsigned DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ServerId` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_player
-- ----------------------------
DROP TABLE IF EXISTS `t_player`;
CREATE TABLE `t_player` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerlevel` int(10) unsigned DEFAULT NULL,
  `via` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subactivityid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `loginsrc` text COLLATE utf8_unicode_ci,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createTime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_recharge
-- ----------------------------
DROP TABLE IF EXISTS `t_recharge`;
CREATE TABLE `t_recharge` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerlevel` int(10) unsigned DEFAULT NULL,
  `transactionId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inpourType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payamt_coins` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pubacct_payamt_coins` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `addcoin` int(10) unsigned DEFAULT NULL,
  `money` float unsigned NOT NULL,
  `gold` int(10) unsigned DEFAULT NULL,
  `exchangeType` int(10) unsigned DEFAULT NULL,
  `depay` float unsigned DEFAULT NULL,
  `gDepay` float unsigned DEFAULT NULL,
  `state` int(10) unsigned DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  `loginsrc` text COLLATE utf8_unicode_ci,
  `pf` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subactivity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_upgradelog
-- ----------------------------
DROP TABLE IF EXISTS `t_upgradelog`;
CREATE TABLE `t_upgradelog` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oldlevel` int(10) unsigned DEFAULT NULL,
  `newlevel` int(10) unsigned DEFAULT NULL,
  `sucess` int(10) unsigned DEFAULT NULL,
  `upgradeType` int(10) unsigned DEFAULT NULL,
  `params` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDate` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `playerlevel` int(10) unsigned DEFAULT NULL,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createTime` int(10) unsigned DEFAULT NULL,
  `via` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subactivityid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `loginsrc` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for thunder_weixin
-- ----------------------------
DROP TABLE IF EXISTS `thunder_weixin`;
CREATE TABLE `thunder_weixin` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_vip
-- ----------------------------
DROP TABLE IF EXISTS `log_vip`;
CREATE TABLE `log_vip` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `VIP` int(10) unsigned DEFAULT NULL,
  `vipIncreaseType` int(10) unsigned DEFAULT NULL,
	`exp` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for vipfbenter
-- ----------------------------
DROP TABLE IF EXISTS `vipfbenter`;
CREATE TABLE `vipfbenter` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `fb_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for vipfbfinish
-- ----------------------------
DROP TABLE IF EXISTS `vipfbfinish`;
CREATE TABLE `vipfbfinish` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `fb_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for world_contend
-- ----------------------------
DROP TABLE IF EXISTS `world_contend`;
CREATE TABLE `world_contend` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `campid` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  `score` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_world_contend_server
-- ----------------------------
DROP TABLE IF EXISTS `log_world_contend_server`;
CREATE TABLE `log_world_contend_server` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `winserver` int(10) unsigned DEFAULT NULL,
  `againstserver` int(10) unsigned DEFAULT NULL,
  `win_campid` int(10) unsigned DEFAULT NULL,
  `lose_campid` int(10) unsigned DEFAULT NULL,
  `lv` int(10) unsigned DEFAULT NULL,
  `loselv` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `dbversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbversion` (
  `version_number` int(11) NOT NULL DEFAULT '0',
  `db_key` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`version_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `dbversion` VALUES ('0', null);


-- ----------------------------
-- Table structure for log_zazen
-- ----------------------------
DROP TABLE IF EXISTS `log_zazen`;
CREATE TABLE `log_zazen` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `cumulative` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_soloserver_arena_rankup
-- ----------------------------
DROP TABLE IF EXISTS `log_soloserver_arena_rankup`;
CREATE TABLE `log_soloserver_arena_rankup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `user_lev` int(10) unsigned DEFAULT NULL,
  `user_fighting` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_strength
-- ----------------------------
DROP TABLE IF EXISTS `log_strength`;
CREATE TABLE `log_strength` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_bloodpool_success
-- ----------------------------
DROP TABLE IF EXISTS `log_bloodpool_success`;
CREATE TABLE `log_bloodpool_success` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `Item` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  `blood` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_upskill
-- ----------------------------
DROP TABLE IF EXISTS `log_upskill`;
CREATE TABLE `log_upskill` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `skillid` int(10) unsigned DEFAULT NULL,
  `skilllevbef` int(10) unsigned DEFAULT NULL,
  `skilllevafter` int(10) unsigned DEFAULT NULL,
  `skillexpbef` int(10) unsigned DEFAULT NULL,
  `skillexpafter` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_cdkey_success
-- ----------------------------
DROP TABLE IF EXISTS `log_cdkey_success`;
CREATE TABLE `log_cdkey_success` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `jihuoma` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_combatreduce
-- --------------------------
DROP TABLE IF EXISTS `log_combatreduce`;
CREATE TABLE `log_combatreduce` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `combattype` BIGINT(20) unsigned DEFAULT NULL,
  `lastcombat` BIGINT(20) unsigned DEFAULT NULL,
  `curcombat` BIGINT(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_yellowDiamond_dailyGift
-- --------------------------
DROP TABLE IF EXISTS `log_yellowDiamond_dailyGift`;
CREATE TABLE `log_yellowDiamond_dailyGift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `yellowdiamondlev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_yellowDiamond_yearGift
-- --------------------------
DROP TABLE IF EXISTS `log_yellowDiamond_yearGift`;
CREATE TABLE `log_yellowDiamond_yearGift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `yellowdiamondlev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_yellowDiamond_growGift
-- --------------------------
DROP TABLE IF EXISTS `log_yellowDiamond_growGift`;
CREATE TABLE `log_yellowDiamond_growGift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `yellowdiamondlev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_yellowDiamond_newbie
-- --------------------------
DROP TABLE IF EXISTS `log_yellowDiamond_newbie`;
CREATE TABLE `log_yellowDiamond_newbie` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `yellowdiamondlev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for  log_yellowDiamond_deluxGift
-- ----------------------------
DROP TABLE IF EXISTS `log_yellowDiamond_deluxGift`;
CREATE TABLE `log_yellowDiamond_deluxGift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) DEFAULT NULL,
  `viplev` int(10) DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_moneychange
-- ----------------------------
DROP TABLE IF EXISTS `log_moneychange`;
CREATE TABLE `log_moneychange` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `emoney` bigint(20) unsigned DEFAULT NULL,
  `goldmoney` bigint(20) unsigned DEFAULT NULL,
  `money` bigint(20) unsigned DEFAULT NULL,
  `newemoney` bigint(20) unsigned DEFAULT NULL,
  `newgoldmoney` bigint(20) unsigned DEFAULT NULL,
  `newmoney` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_mail
-- ----------------------------
DROP TABLE IF EXISTS `log_mail`;
CREATE TABLE `log_mail` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `mailid` int(10) unsigned DEFAULT NULL,
  `sendtime` bigint(20) unsigned DEFAULT NULL,
  `mailnum` int(10) unsigned DEFAULT NULL,
  `maillast` int(10) unsigned DEFAULT NULL,
  `lasttime` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_mailgain
-- ----------------------------
DROP TABLE IF EXISTS `log_mailgain`;
CREATE TABLE `log_mailgain` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `mailid` int(10) unsigned DEFAULT NULL,
  `lasttime` bigint(20) unsigned DEFAULT NULL,
  `gettime` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_shop
-- ----------------------------
DROP TABLE IF EXISTS `log_shop`;
CREATE TABLE `log_shop` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `shopid` int(10) unsigned DEFAULT NULL,
  `counterid` int(10) unsigned DEFAULT NULL,
  `goodsid` int(10) unsigned DEFAULT NULL,
  `buy_num` int(10) unsigned DEFAULT NULL,
  `all_cost` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_shuaxin
-- ----------------------------
DROP TABLE IF EXISTS `log_shuaxin`;
CREATE TABLE `log_shuaxin` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `shopid` int(10) unsigned DEFAULT NULL,
  `emoney` bigint(20) unsigned DEFAULT NULL,
  `emoneynew` bigint(20) unsigned DEFAULT NULL,
  `hunpo` bigint(20) unsigned DEFAULT NULL,
  `hunponew` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_task
-- ----------------------------
DROP TABLE IF EXISTS `log_task`;
CREATE TABLE `log_task` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `taskid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_create_role
-- ----------------------------
DROP TABLE IF EXISTS `log_create_role`;
CREATE TABLE `log_create_role` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` bigint(10) NOT NULL COMMENT 'time',
  `client` int(10) NOT NULL COMMENT '客户端 0-web 1-ios 2-android',
  `pid` int(10) NOT NULL COMMENT '平台id',
  `qudao` int(10) DEFAULT '0',
  `uid` bigint(20) NOT NULL COMMENT 'uid',
  `loginname` varchar(255) NOT NULL COMMENT '账号名',
  `rolename` varchar(50) NOT NULL COMMENT '角色名',
  `sex` int(10) NOT NULL COMMENT '性别 1男2女',
  `ip` varchar(100) NOT NULL COMMENT 'ip',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for log_role_level
-- ----------------------------
DROP TABLE IF EXISTS `log_role_level`;
CREATE TABLE `log_role_level` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` bigint(10) NOT NULL COMMENT 'time',
  `client` int(10) NOT NULL COMMENT '客户端 0-web 1-ios 2-android',
  `pid` int(10) NOT NULL COMMENT '平台id',
  `qudao` int(10) DEFAULT '0',
  `uid` bigint(20) NOT NULL COMMENT 'uid',
  `loginname` varchar(255) NOT NULL COMMENT '账号名',
  `rolename` varchar(50) NOT NULL COMMENT '角色名',
  `oldlevel` int(10) NOT NULL COMMENT '旧等级',
  `newlevel` int(10) NOT NULL COMMENT '新等级',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for log_login
-- ----------------------------
DROP TABLE IF EXISTS `log_login`;
CREATE TABLE `log_login` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` bigint(10) NOT NULL COMMENT 'time',
  `client` int(10) NOT NULL COMMENT '客户端 0-web 1-ios 2-android',
  `pid` int(10) NOT NULL COMMENT '平台id',
  `qudao` int(10) DEFAULT '0',
  `uid` bigint(20) NOT NULL COMMENT 'uid',
  `loginname` varchar(255) NOT NULL COMMENT '账号名',
  `rolename` varchar(50) NOT NULL COMMENT '角色名',
  `ip` varchar(100) NOT NULL COMMENT 'ip',
  `rolelevel` int(10) NOT NULL COMMENT '角色等级',
  `actionId` int(10) NOT NULL COMMENT '行为ID',
  `onlinetime` bigint(20) NOT NULL COMMENT '本次在线时长',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for log_max_online
-- ----------------------------
DROP TABLE IF EXISTS `log_max_online`;
CREATE TABLE `log_max_online` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` bigint(10) NOT NULL COMMENT 'time',
  `pid` int(10) NOT NULL COMMENT '平台id',
  `qudao` int(10) NOT NULL COMMENT '渠道',
  `num` int(10) NOT NULL COMMENT '在线人数',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for log_recharge
-- ----------------------------
DROP TABLE IF EXISTS `log_recharge`;
CREATE TABLE `log_recharge` (
	`autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
	`time` bigint(10) NOT NULL COMMENT 'time',
	`client` INT(10) NOT NULL COMMENT '客户端 0-web 1-ios 2-android',
	`pid` INT(10) NOT NULL COMMENT '平台id',
	`qudao` INT(10) NULL DEFAULT '0',
	`uid` BIGINT(20) NOT NULL COMMENT 'uid',
	`loginname` VARCHAR(255) NOT NULL COMMENT '账号名',
	`rolename` VARCHAR(50) NOT NULL COMMENT '角色名',
	`level` INT(10) NOT NULL COMMENT '角色等级',
	`ordersn` VARCHAR(255) NOT NULL COMMENT '平台订单号',
	`type` INT(10) NOT NULL COMMENT '用户类型 1新用户 2老用户',
	`rmb` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT '花费人民币数量',
	`yuanbao` INT(10) NOT NULL COMMENT '充值元宝数量',
	`bindyuanbao` INT(10) NOT NULL COMMENT '充值绑元数量',
	`serverId` INT(10) NOT NULL COMMENT '服务器ID',
	`productId` INT(10) NOT NULL COMMENT '充值项',
	`totalyuanbao` BIGINT(20) NOT NULL COMMENT '充值后元宝',
	PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS `log_zhenrong`;
CREATE TABLE `log_zhenrong` (
  `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id` int(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zhenrongbefore` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zhenrongafter` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `log_orderup`;
CREATE TABLE `log_orderup` (
  `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partner` int(10) NOT NULL DEFAULT '0',
  `orderbefore` int(10) NOT NULL DEFAULT '0',
  `orderafter` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `log_restore`;
CREATE TABLE `log_restore` (
  `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partner` int(10) NOT NULL DEFAULT '0',
  `restorebefore` int(10) NOT NULL DEFAULT '0',
  `restoreafter` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `log_danyao`;
CREATE TABLE `log_danyao` (
  `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
  `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `danyaoid` int(10) NOT NULL DEFAULT '0',
  `itemid` int(10) NOT NULL DEFAULT '0',
  `num` int(10) NOT NULL DEFAULT '0',
	`numnew` int(10) NOT NULL DEFAULT '0',
	`cishu` int(10) NOT NULL DEFAULT '0',
	`cishunew` int(10) NOT NULL DEFAULT '0',
	PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `log_climbingtower`;
CREATE TABLE `log_climbingtower` (
   `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
   `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `totalchallenge` int(10) NOT NULL DEFAULT '0', 
  PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `log_poem`;
CREATE TABLE `log_poem` (
  `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
   `account` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_bot
-- ----------------------------
DROP TABLE IF EXISTS `log_bot`;
CREATE TABLE `log_bot` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `exp` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `money`bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `downline` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_zhuogui
-- ----------------------------
DROP TABLE IF EXISTS `log_zhuogui`;
CREATE TABLE `log_zhuogui` (
 	`autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `money` bigint(20) unsigned DEFAULT NULL,
  `moneynew`bigint(20) unsigned DEFAULT NULL,
  `ring`int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_zhuoguibuynum
-- ----------------------------
DROP TABLE IF EXISTS `log_zhuoguibuynum`;
CREATE TABLE `log_zhuoguibuynum` (
 	`autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `moneytype` int(10) unsigned DEFAULT NULL,
  `num`int(10) unsigned DEFAULT NULL,
  `buynum`int(10) unsigned DEFAULT NULL,
  `buynumnew`int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_powerdoubling
-- ----------------------------
DROP TABLE IF EXISTS `log_powerdoubling`;
CREATE TABLE `log_powerdoubling` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `VIP` int(10) unsigned DEFAULT NULL,
  `activityid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_instance
-- ----------------------------
DROP TABLE IF EXISTS `log_instance`;
CREATE TABLE `log_instance` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `totalchapter` int(10) unsigned DEFAULT NULL,
  `totalstage` int(10) unsigned DEFAULT NULL,
  `firstpass` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_active
-- ----------------------------
DROP TABLE IF EXISTS `log_active`;
CREATE TABLE `log_active` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `levelnew` int(10) unsigned DEFAULT NULL,
  `exp` int(10) unsigned DEFAULT NULL,
  `expnew` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_zhaohui
-- ----------------------------
DROP TABLE IF EXISTS `log_zhaohui`;
CREATE TABLE `log_zhaohui` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `exp` int(10) unsigned DEFAULT NULL,
  `expnew` int(10) unsigned DEFAULT NULL,
  `groupid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cishu` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `emoney` int(10) unsigned DEFAULT NULL,
  `emoneynew` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_taskring
-- ----------------------------
DROP TABLE IF EXISTS `log_taskring`;
CREATE TABLE `log_taskring` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `taskid` int(10) unsigned DEFAULT NULL,
  `ring` int(10) unsigned DEFAULT NULL,
  `behavior` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_taskteach
-- ----------------------------
DROP TABLE IF EXISTS `log_taskteach`;
CREATE TABLE `log_taskteach` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `taskid` int(10) unsigned DEFAULT NULL,
  `ring` int(10) unsigned DEFAULT NULL,
  `behavior` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_buying
-- ----------------------------
DROP TABLE IF EXISTS `log_buying`;
CREATE TABLE `log_buying` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `people_before` int(10) unsigned DEFAULT NULL,
  `people_after` int(10) unsigned DEFAULT NULL,
  `cishu` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_bigaward
-- ----------------------------
DROP TABLE IF EXISTS `log_bigaward`;
CREATE TABLE `log_bigaward` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_dollmachine
-- ----------------------------
DROP TABLE IF EXISTS `log_dollmachine`;
CREATE TABLE `log_dollmachine` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL,
  `cost` int(10) unsigned DEFAULT NULL,
  `score` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_firstimpulse
-- ----------------------------
DROP TABLE IF EXISTS `log_firstimpulse`;
CREATE TABLE `log_firstimpulse` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `money` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_firstimpulseday
-- ----------------------------
DROP TABLE IF EXISTS `log_firstimpulseday`;
CREATE TABLE `log_firstimpulseday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `money` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_gift
-- ----------------------------
DROP TABLE IF EXISTS `log_gift`;
CREATE TABLE `log_gift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_upgangskill
-- ----------------------------
DROP TABLE IF EXISTS `log_upgangskill`;
CREATE TABLE `log_upgangskill` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `oldnum` bigint(20) unsigned DEFAULT NULL,
  `newNum` bigint(20) unsigned DEFAULT NULL,
  `skillid` int(10) unsigned DEFAULT NULL,
  `oldlevel` int(10) unsigned DEFAULT NULL,
  `newlevel` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_specialoffer
-- ----------------------------
DROP TABLE IF EXISTS `log_specialoffer`;
CREATE TABLE `log_specialoffer` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_whole_level
-- ----------------------------
DROP TABLE IF EXISTS `log_whole_level`;
CREATE TABLE `log_whole_level` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `targetData` int(10) unsigned DEFAULT NULL,
  `extranum` int(10) unsigned DEFAULT NULL,
  `isExtraReward` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_touzicost
-- ----------------------------
DROP TABLE IF EXISTS `log_touzicost`;
CREATE TABLE `log_touzicost` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `oldemoney` bigint(20) unsigned DEFAULT NULL,
  `newemoney` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_touzi
-- ----------------------------
DROP TABLE IF EXISTS `log_touzi`;
CREATE TABLE `log_touzi` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_buycailiaonum
-- ----------------------------
DROP TABLE IF EXISTS `log_buycailiaonum`;
CREATE TABLE `log_buycailiaonum` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupId` int(10) unsigned DEFAULT NULL,
  `oldemoney` bigint(20) unsigned DEFAULT NULL,
  `newemoney` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_growupcost
-- ----------------------------
DROP TABLE IF EXISTS `log_growupcost`;
CREATE TABLE `log_growupcost` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `oldemoney` bigint(20) unsigned DEFAULT NULL,
  `newemoney` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_growup
-- ----------------------------
DROP TABLE IF EXISTS `log_growup`;
CREATE TABLE `log_growup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `oldemoney` bigint(20) unsigned DEFAULT NULL,
  `newemoney` bigint(20) unsigned DEFAULT NULL,
  `oldGlodMoney` bigint(20) unsigned DEFAULT NULL,
  `newGlodMoney` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_discountshop
-- ----------------------------
DROP TABLE IF EXISTS `log_discountshop`;
CREATE TABLE `log_discountshop` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `matchid` int(10) unsigned DEFAULT NULL,
  `thingId` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  `currencyType` int(10) unsigned DEFAULT NULL,
  `oldValue` bigint(20) unsigned DEFAULT NULL,
  `newValue` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_redbag
-- ----------------------------
DROP TABLE IF EXISTS `log_redbag`;
CREATE TABLE `log_redbag` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `redbagid` int(10) unsigned DEFAULT NULL,
  `num` int(10) unsigned DEFAULT NULL,
  `bagnum_before` int(10) unsigned DEFAULT NULL,
  `bagnum_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_hsdroiyan
-- ----------------------------
DROP TABLE IF EXISTS `log_hsdroiyan`;
CREATE TABLE `log_hsdroiyan` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rankbefore` int(10) unsigned DEFAULT NULL,
  `rankafter` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_recycle
-- ----------------------------
DROP TABLE IF EXISTS `log_recycle`;
CREATE TABLE `log_recycle` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `wave` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_question
-- ----------------------------
DROP TABLE IF EXISTS `log_question`;
CREATE TABLE `log_question` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  `point` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_teamcopy
-- ----------------------------
DROP TABLE IF EXISTS `log_teamcopy`;
CREATE TABLE `log_teamcopy` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlevel` int(10) unsigned DEFAULT NULL,
  `copylevel` int(10) unsigned DEFAULT NULL,
  `rewardNum` int(10) unsigned DEFAULT NULL COMMENT '已经收益的次数',
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_boss_challenge
-- ----------------------------
DROP TABLE IF EXISTS `log_boss_challenge`;
CREATE TABLE `log_boss_challenge` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlevel` int(10) unsigned DEFAULT NULL,
  `tollgateId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_eduitem
-- ----------------------------
DROP TABLE IF EXISTS `log_eduitem`;
CREATE TABLE `log_eduitem` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `item` int(10) unsigned DEFAULT NULL,
  `itemnum` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_eduup
-- ----------------------------
DROP TABLE IF EXISTS `log_eduup`;
CREATE TABLE `log_eduup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `class_before` int(10) unsigned DEFAULT NULL,
  `class_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_eduskill
-- ----------------------------
DROP TABLE IF EXISTS `log_eduskill`;
CREATE TABLE `log_eduskill` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `edu_type` int(10) unsigned DEFAULT NULL,
  `skillid` int(10) unsigned DEFAULT NULL,
  `lv` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_equipmentset
-- ----------------------------
DROP TABLE IF EXISTS `log_equipmentset`;
CREATE TABLE `log_equipmentset` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `slot_type` int(10) unsigned DEFAULT NULL,
  `set_id_before` int(10) unsigned DEFAULT NULL,
  `set_id_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_firstimpulsethree
-- ----------------------------
DROP TABLE IF EXISTS `log_firstimpulsethree`;
CREATE TABLE `log_firstimpulsethree` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `money` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_millions
-- ----------------------------
DROP TABLE IF EXISTS `log_millions`;
CREATE TABLE `log_millions` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `totaldays` int(10) unsigned DEFAULT NULL,
  `receiveid` int(10) unsigned DEFAULT NULL,
  `bmoney` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `CHARACTERID` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_prestige
-- ----------------------------
DROP TABLE IF EXISTS `log_prestige`;
CREATE TABLE `log_prestige` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_guildcontribution
-- ----------------------------
DROP TABLE IF EXISTS `log_guildcontribution`;
CREATE TABLE `log_guildcontribution` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_boxingmedal
-- ----------------------------
DROP TABLE IF EXISTS `log_boxingmedal`;
CREATE TABLE `log_boxingmedal` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_fightcurrency
-- ----------------------------
DROP TABLE IF EXISTS `log_fightcurrency`;
CREATE TABLE `log_fightcurrency` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_generalmedal
-- ----------------------------
DROP TABLE IF EXISTS `log_generalmedal`;
CREATE TABLE `log_generalmedal` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_civilianmerit
-- ----------------------------
DROP TABLE IF EXISTS `log_civilianmerit`;
CREATE TABLE `log_civilianmerit` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `amount1` bigint(20) unsigned DEFAULT NULL,
  `amount2` bigint(20) unsigned DEFAULT NULL,
  `useORget` int(10) unsigned DEFAULT NULL,
  `actionType` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_lifeanddeath
-- ----------------------------
DROP TABLE IF EXISTS `log_lifeanddeath`;
CREATE TABLE `log_lifeanddeath` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `vipLev` int(10) unsigned DEFAULT NULL,
  `roundOrg` int(10) unsigned DEFAULT NULL,
  `roundCur` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_worldboss
-- ----------------------------
DROP TABLE IF EXISTS `log_worldboss`;
CREATE TABLE `log_worldboss` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `diffculty` int(10) unsigned DEFAULT NULL,
  `hurt_total` bigint(20) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_trial
-- ----------------------------
DROP TABLE IF EXISTS `log_trial`;
CREATE TABLE `log_trial` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userLev` int(10) unsigned DEFAULT NULL,
  `hurt_total` bigint(20) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_strengh
-- ----------------------------
DROP TABLE IF EXISTS `log_strengh`;
CREATE TABLE `log_strengh` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `id` int(10) unsigned DEFAULT NULL,
  `strenghbefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `strenghafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_refine
-- ----------------------------
DROP TABLE IF EXISTS `log_refine`;
CREATE TABLE `log_refine` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `id` int(10) unsigned DEFAULT NULL,
  `refinebefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `refineafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_forge
-- ----------------------------
DROP TABLE IF EXISTS `log_forge`;
CREATE TABLE `log_forge` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `id` int(10) unsigned DEFAULT NULL,
  `forgebefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `forgeafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_set
-- ----------------------------
DROP TABLE IF EXISTS `log_set`;
CREATE TABLE `log_set` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `id` int(10) unsigned DEFAULT NULL,
  `setbefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `setafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_preferenceday
-- ----------------------------
DROP TABLE IF EXISTS `log_preferenceday`;
CREATE TABLE `log_preferenceday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `matchesid` int(10) unsigned DEFAULT NULL,
  `typeid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_luckytable
-- ----------------------------
DROP TABLE IF EXISTS `log_luckytable`;
CREATE TABLE `log_luckytable` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `beishu` int(10) unsigned DEFAULT NULL,
  `Emoneybefore` bigint(20) unsigned DEFAULT NULL,
  `Emoneynew` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_jinjierank
-- ----------------------------
DROP TABLE IF EXISTS `log_jinjierank`;
CREATE TABLE `log_jinjierank` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_jinjielimit
-- ----------------------------
DROP TABLE IF EXISTS `log_jinjielimit`;
CREATE TABLE `log_jinjielimit` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_competitionVictory
-- ----------------------------
DROP TABLE IF EXISTS `log_competitionVictory`;
CREATE TABLE `log_competitionVictory` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `curScore` int(10) unsigned DEFAULT NULL,
  `curWin` int(10) unsigned DEFAULT NULL,
  `curFight` int(10) unsigned DEFAULT NULL,
  `totalScore` int(10) unsigned DEFAULT NULL,
  `totalWin` int(10) unsigned DEFAULT NULL,
  `totalFight` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_arrest
-- ----------------------------
DROP TABLE IF EXISTS `log_arrest`;
CREATE TABLE `log_arrest` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `arresttime` int(10) unsigned DEFAULT NULL,
  `bankid` int(10) unsigned DEFAULT NULL,
  `zhandouid` int(10) unsigned DEFAULT NULL,
  `success` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- ----------------------------
-- Table structure for log_deletemail
-- ----------------------------
DROP TABLE IF EXISTS `log_deletemail`;
CREATE TABLE `log_deletemail` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `mailconfigid` int(10) unsigned DEFAULT NULL,
  `createtime` bigint(20) unsigned DEFAULT NULL,
  `mailstatus` int(10) unsigned DEFAULT NULL,
  `thingtopick` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_partner
-- ----------------------------
DROP TABLE IF EXISTS `log_partner`;
CREATE TABLE `log_partner` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` bigint(20) unsigned DEFAULT NULL,
  `activateid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_ptvipgift
-- ----------------------------
DROP TABLE IF EXISTS `log_ptvipgift`;
CREATE TABLE `log_ptvipgift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` bigint(20) unsigned DEFAULT NULL,
  `rewardid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_ptvip
-- ----------------------------
DROP TABLE IF EXISTS `log_ptvip`;
CREATE TABLE `log_ptvip` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` bigint(20) unsigned DEFAULT NULL,
  `rewardid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_sign_in_add
-- ----------------------------
DROP TABLE IF EXISTS `log_sign_in_add`;
CREATE TABLE `log_sign_in_add` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `days` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_sign_in
-- ----------------------------
DROP TABLE IF EXISTS `log_sign_in`;
CREATE TABLE `log_sign_in` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `activity` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_groupbuy_first
-- ----------------------------
DROP TABLE IF EXISTS `log_groupbuy_first`;
CREATE TABLE `log_groupbuy_first` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `activity` int(10) unsigned DEFAULT NULL,
  `grouptype` int(10) unsigned DEFAULT NULL,
  `rechargetype` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_monthcard
-- ----------------------------
DROP TABLE IF EXISTS `log_monthcard`;
CREATE TABLE `log_monthcard` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `day_before` int(10) unsigned DEFAULT NULL,
  `day_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_sealmonster
-- ----------------------------
DROP TABLE IF EXISTS `log_sealmonster`;
CREATE TABLE `log_sealmonster` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `config_lv` int(10) unsigned DEFAULT NULL,
  `config_monster_no` int(10) unsigned DEFAULT NULL,
  `battle_count_before` int(10) unsigned DEFAULT NULL,
  `battle_count_after` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_dayup
-- ----------------------------
DROP TABLE IF EXISTS `log_dayup`;
CREATE TABLE `log_dayup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `itemid` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_menpai
-- ----------------------------
DROP TABLE IF EXISTS `log_menpai`;
CREATE TABLE `log_menpai` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `diffculty` int(10) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `ring` int(10) unsigned DEFAULT NULL,
  `ringnew` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_rechargeday
-- ----------------------------
DROP TABLE IF EXISTS `log_rechargeday`;
CREATE TABLE `log_rechargeday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `configtypeid` int(10) unsigned DEFAULT NULL,
  `emoney` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_skin
-- ----------------------------
DROP TABLE IF EXISTS `log_skin`;
CREATE TABLE `log_skin` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `cost` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_equip
-- ----------------------------
DROP TABLE IF EXISTS `log_equip`;
CREATE TABLE `log_equip` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `id` int(10) unsigned DEFAULT NULL,
  `equipbefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `equipafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_petactive
-- ----------------------------
DROP TABLE IF EXISTS `log_petactive`;
CREATE TABLE `log_petactive` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `petid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_petlvup
-- ----------------------------
DROP TABLE IF EXISTS `log_petlvup`;
CREATE TABLE `log_petlvup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `petid` int(10) unsigned DEFAULT NULL,
  `levorg` int(10) unsigned DEFAULT NULL,
  `levcur` int(10) unsigned DEFAULT NULL,
  `exporg` bigint(20) unsigned DEFAULT NULL,
  `expcur` bigint(20) unsigned DEFAULT NULL,
  `action` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_petclear
-- ----------------------------
DROP TABLE IF EXISTS `log_petclear`;
CREATE TABLE `log_petclear` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `petid` int(10) unsigned DEFAULT NULL,
  `clearbefore` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `clearafter` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_petstudy
-- ----------------------------
DROP TABLE IF EXISTS `log_petstudy`;
CREATE TABLE `log_petstudy` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `petid` int(10) unsigned DEFAULT NULL,
  `studybefore` int(10) unsigned DEFAULT NULL,
  `studybafter` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_roleorderup
-- ----------------------------
DROP TABLE IF EXISTS `log_roleorderup`;
CREATE TABLE `log_roleorderup` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `uesrorder1` int(10) unsigned DEFAULT NULL,
  `userorder2` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_whole_advance
-- ----------------------------
DROP TABLE IF EXISTS `log_whole_advance`;
CREATE TABLE `log_whole_advance` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `realpeople` int(10) unsigned DEFAULT NULL,
  `myself` int(10) unsigned DEFAULT NULL,
  `isdouble` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_earthly
-- ----------------------------
DROP TABLE IF EXISTS `log_earthly`;
CREATE TABLE `log_earthly` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `star` int(10) unsigned DEFAULT NULL,
  `zhandouid` int(10) unsigned DEFAULT NULL,
  `killbefore` int(10) unsigned DEFAULT NULL,
  `killafter` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_earthlyhudun
-- ----------------------------
DROP TABLE IF EXISTS `log_earthlyhudun`;
CREATE TABLE `log_earthlyhudun` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `hitcharacterid` bigint(20) unsigned DEFAULT NULL,
  `hudunhp` bigint(20) unsigned DEFAULT NULL,
  `hudunhpnew` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_jinjie
-- ----------------------------
DROP TABLE IF EXISTS `log_jinjie`;
CREATE TABLE `log_jinjie` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `ranklev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_eliminatemonster
-- ----------------------------
DROP TABLE IF EXISTS `log_eliminatemonster`;
CREATE TABLE `log_eliminatemonster` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `bossIndex` int(10) unsigned DEFAULT NULL,
  `hurt` bigint(20) unsigned DEFAULT NULL,
  `rank` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_fenglu
-- ----------------------------
DROP TABLE IF EXISTS `log_fenglu`;
CREATE TABLE `log_fenglu` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `officertype` int(10) unsigned DEFAULT NULL,
  `officerlev` int(20) unsigned DEFAULT NULL,
  `costnum` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_officertask
-- ----------------------------
DROP TABLE IF EXISTS `log_officertask`;
CREATE TABLE `log_officertask` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `officertype` int(10) unsigned DEFAULT NULL,
  `tasktype` int(20) unsigned DEFAULT NULL,
  `daring` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_yishi
-- ----------------------------
DROP TABLE IF EXISTS `log_yishi`;
CREATE TABLE `log_yishi` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `officertype` int(10) unsigned DEFAULT NULL,
  `officerlev` int(20) unsigned DEFAULT NULL,
  `meettype` int(20) unsigned DEFAULT NULL,
  `type` int(20) unsigned DEFAULT NULL,
  `meetcharacterid` bigint(20) unsigned DEFAULT NULL,
  `meetofficerlev` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_tasktreasure
-- ----------------------------
DROP TABLE IF EXISTS `log_tasktreasure`;
CREATE TABLE `log_tasktreasure` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `taskid` int(20) unsigned DEFAULT NULL,
  `behavior` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_dig
-- ----------------------------
DROP TABLE IF EXISTS `log_dig`;
CREATE TABLE `log_dig` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `digtime` int(10) unsigned DEFAULT NULL,
  `lucky_before` int(20) unsigned DEFAULT NULL,
  `lucky_after` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_edunote
-- ----------------------------
DROP TABLE IF EXISTS `log_edunote`;
CREATE TABLE `log_edunote` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `edutype` int(10) unsigned DEFAULT NULL,
  `notetype` int(20) unsigned DEFAULT NULL,
  `levelbeforesoul` int(20) unsigned DEFAULT NULL,
  `levelaftersoul` int(20) unsigned DEFAULT NULL,
  `expbeforesoul` int(20) unsigned DEFAULT NULL,
  `expaftersoul` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_picture
-- ----------------------------
DROP TABLE IF EXISTS `log_picture`;
CREATE TABLE `log_picture` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `pictureid` int(10) unsigned DEFAULT NULL,
  `picturelv_before` int(20) unsigned DEFAULT NULL,
  `picturelv_after` int(20) unsigned DEFAULT NULL,
  `actiontype` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_zerobuy
-- ----------------------------
DROP TABLE IF EXISTS `log_zerobuy`;
CREATE TABLE `log_zerobuy` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `actid` int(10) unsigned DEFAULT NULL,
  `buyday` int(20) unsigned DEFAULT NULL,
  `getday` int(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_strongestVote
-- ----------------------------
DROP TABLE IF EXISTS `log_strongestVote`;
CREATE TABLE `log_strongestVote` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupId` int(10) unsigned DEFAULT NULL,
  `lottery` int(10) unsigned DEFAULT NULL,
  `selfTotalNum` int(10) unsigned DEFAULT NULL,
  `selfTodayNum` int(10) unsigned DEFAULT NULL,
  `selfLotteryNum` int(10) unsigned DEFAULT NULL,
  `lotteryTotalNum` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_brings
-- ----------------------------
DROP TABLE IF EXISTS `log_brings`;
CREATE TABLE `log_brings` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupId` int(10) unsigned DEFAULT NULL,
  `kuid` int(10) unsigned DEFAULT NULL,
  `cishu` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_landingCeremony
-- ----------------------------
DROP TABLE IF EXISTS `log_landingCeremony`;
CREATE TABLE `log_landingCeremony` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupId` int(10) unsigned DEFAULT NULL,
  `daynum` int(10) unsigned DEFAULT NULL,
  `isdouble` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_chat
-- ----------------------------
DROP TABLE IF EXISTS `log_chat`;
CREATE TABLE `log_chat` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `rid` bigint(20) NOT NULL COMMENT 'rid',
  `loginname` varchar(255) NOT NULL COMMENT '账号名',
  `rolename` varchar(50) NOT NULL COMMENT '角色名',
  `type` int(11) NOT NULL COMMENT '聊天类型',
  `pid` int(11) NOT NULL COMMENT '平台id',
  `sid` int(11) NOT NULL COMMENT '区服id',
  `client` int(11) NOT NULL COMMENT '客户端',
  `content` varchar(255) NOT NULL COMMENT '内容',
  `time` int(11) NOT NULL COMMENT 'time',
  `torid` bigint(20) NOT NULL COMMENT '目标id',
  `tologinname` varchar(255) DEFAULT NULL COMMENT '目标账号名',
  `torolename` varchar(50) DEFAULT NULL COMMENT '目标角色名',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_singlerecharge
-- ----------------------------
DROP TABLE IF EXISTS `log_singlerecharge`;
CREATE TABLE `log_singlerecharge` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `group` int(10) unsigned DEFAULT NULL,
  `daynum` int(10) unsigned DEFAULT NULL,
  `recharge_rmb` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_zsz
-- ----------------------------
DROP TABLE IF EXISTS `log_zsz`;
CREATE TABLE `log_zsz` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `groupid` int(10) unsigned DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL COMMENT '商品id',
  `buybefore` varchar(255) DEFAULT NULL COMMENT '购买前商品剩余数量',
  `buyafter` varchar(255) DEFAULT NULL COMMENT '购买后商品剩余数量',
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for log_holidayconsumption
-- ----------------------------
DROP TABLE IF EXISTS `log_holidayconsumption`;
CREATE TABLE `log_holidayconsumption` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `group` int(10) unsigned DEFAULT NULL,
  `daynum` varchar(255) DEFAULT NULL COMMENT '商品id',
  `cumulativeconsumption` varchar(255) DEFAULT NULL COMMENT '已累计消费的元宝个数',
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_festivereplenishment
-- ----------------------------
DROP TABLE IF EXISTS `log_festivereplenishment`;
CREATE TABLE `log_festivereplenishment` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `group` int(10) unsigned DEFAULT NULL,
  `daynum` varchar(255) DEFAULT NULL COMMENT '商品id',
  `accumulatedrecharge` varchar(255) DEFAULT NULL COMMENT '已累计充值的RMB',
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_replenishingrebate
-- ----------------------------
DROP TABLE IF EXISTS `log_replenishingrebate`;
CREATE TABLE `log_replenishingrebate` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `totalday` int(10) unsigned DEFAULT NULL,
  `receiveid` int(10) unsigned DEFAULT NULL,
  `emoney` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_jieyi
-- ----------------------------
DROP TABLE IF EXISTS `log_jieyi`;
CREATE TABLE `log_jieyi` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `cardid` bigint(20) unsigned DEFAULT NULL,
  `intimacybefore` int(10) unsigned DEFAULT NULL,
  `intimacyafter` int(10) unsigned DEFAULT NULL,
  `levelbefore` int(10) unsigned DEFAULT NULL,
  `levelafter` int(10) unsigned DEFAULT NULL,
  `limit` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_marrydevelop
-- ----------------------------
DROP TABLE IF EXISTS `log_marrydevelop`;
CREATE TABLE `log_marrydevelop` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `beforeupgrading` int(10) unsigned DEFAULT NULL,
  `afterupgrading` int(10) unsigned DEFAULT NULL,
  `beforeexp` int(10) unsigned DEFAULT NULL,
  `afterexp` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_marryinteractive
-- ----------------------------
DROP TABLE IF EXISTS `log_marryinteractive`;
CREATE TABLE `log_marryinteractive` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `userlev` int(10) unsigned DEFAULT NULL,
  `beforeupgrading` int(10) unsigned DEFAULT NULL,
  `afterupgrading` int(10) unsigned DEFAULT NULL,
  `beforeexp` int(10) unsigned DEFAULT NULL,
  `afterexp` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_buchang
-- ----------------------------
DROP TABLE IF EXISTS `log_buchang`;
CREATE TABLE `log_buchang` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `fight` int(10) unsigned DEFAULT NULL,
  `cengshu` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_flytoheaven
-- ----------------------------
DROP TABLE IF EXISTS `log_flytoheaven`;
CREATE TABLE `log_flytoheaven` (
   `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `time` datetime DEFAULT NULL,
   `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `totalchallenge` int(10) NOT NULL DEFAULT '0', 
  PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_vipfuben
-- ----------------------------
DROP TABLE IF EXISTS `log_vipfuben`;
CREATE TABLE `log_vipfuben` (
   `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
   `time` datetime DEFAULT NULL,
   `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
   `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
   `vip` int(10) NOT NULL DEFAULT '0', 
   PRIMARY KEY (`autoid`),
 	KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_petkursaal
-- ----------------------------
DROP TABLE IF EXISTS `log_petkursaal`;
CREATE TABLE `log_petkursaal` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `account` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `place` int(10) unsigned DEFAULT NULL,
  `eudemonType` int(10) unsigned DEFAULT NULL,
  `jyid` int(10) unsigned DEFAULT NULL,
  `endTime` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoid`),
  KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for log_bright
-- ----------------------------
DROP TABLE IF EXISTS `log_bright`;
CREATE TABLE `log_bright` (
   `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
   `time` datetime DEFAULT NULL,
   `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
   `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
   `groupid` int(10) NOT NULL DEFAULT '0', 
   `attr` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
   `totalchallenge` int(10) NOT NULL DEFAULT '0', 
   PRIMARY KEY (`autoid`),
   KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for log_fold
-- ----------------------------
DROP TABLE IF EXISTS `log_fold`;
CREATE TABLE `log_fold` (
   `autoid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
   `time` datetime DEFAULT NULL,
   `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
   `characterid` bigint(20) COLLATE utf8_unicode_ci DEFAULT NULL,
   `classid` int(10) NOT NULL DEFAULT '0',
   `itemid` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
   `itemnum` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
   PRIMARY KEY (`autoid`),
   KEY `ACCOUNT` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

