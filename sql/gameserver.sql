-- MySQL dump 10.13  Distrib 5.6.15, for Win64 (x86_64)
--
-- Host: localhost    Database: xy2
-- ------------------------------------------------------
-- Server version	5.6.15-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `account` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `create_account_time` datetime DEFAULT NULL,
  `gm` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `threehundredrecycle`
--

DROP TABLE IF EXISTS `threehundredrecycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threehundredrecycle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `curwave` int(10) unsigned DEFAULT NULL,
  `time` int(10) unsigned DEFAULT NULL,
  `rewardinfo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `design`
--

DROP TABLE IF EXISTS `design`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `design` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `activedesignid` int(10) unsigned DEFAULT NULL,
  `designinfo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_auction`
--

DROP TABLE IF EXISTS `activity_auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_auction` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `bigid` int(10) unsigned NOT NULL DEFAULT '0',
  `curactivitydayid` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `continueday` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_auction_one`
--

DROP TABLE IF EXISTS `activity_auction_one`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_auction_one` (
  `oneid` int(20) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `auctionthingstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`oneid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_barter`
--

DROP TABLE IF EXISTS `activity_barter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_barter` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `curactivitydayid` int(10) unsigned NOT NULL DEFAULT '0',
  `begintime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `activity_circulamoney`
--

DROP TABLE IF EXISTS `activity_circulamoney`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_circulamoney` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `openrefreshtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `servernum` int(10) unsigned NOT NULL DEFAULT '0',
  `curactivityid` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_consumegift`
--

DROP TABLE IF EXISTS `activity_consumegift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_consumegift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `begintime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_eightday`
--

DROP TABLE IF EXISTS `activity_eightday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_eightday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `servernum` int(10) unsigned NOT NULL DEFAULT '0',
  `curactivityid` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `topcharacterids` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_eightdaygift`
--

DROP TABLE IF EXISTS `activity_eightdaygift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_eightdaygift` (
  `giftid` int(20) unsigned NOT NULL DEFAULT '0',
  `salenum` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`giftid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_freebarter`
--

DROP TABLE IF EXISTS `activity_freebarter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_freebarter` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `curactivitydayid` int(10) unsigned NOT NULL DEFAULT '0',
  `begintime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `activity_luckytoken`
--

DROP TABLE IF EXISTS `activity_luckytoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_luckytoken` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `begintime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `activity_rechargegift`
--

DROP TABLE IF EXISTS `activity_rechargegift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_rechargegift` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `servernum` int(10) unsigned NOT NULL DEFAULT '0',
  `curactivitydayid` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `activity_upday`
--

DROP TABLE IF EXISTS `activity_upday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_upday` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bopen` int(20) unsigned NOT NULL DEFAULT '0',
  `servernum` int(10) unsigned NOT NULL DEFAULT '0',
  `curactivityid` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `activityconfig`
--

DROP TABLE IF EXISTS `activityconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activityconfig` (
  `activityname` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `starttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `endtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `activitystatus` int(10) unsigned NOT NULL DEFAULT '0',
  `groupid` int(10) unsigned NOT NULL DEFAULT '0',
  `params` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`activityname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `antiaddition`
--

DROP TABLE IF EXISTS `antiaddition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `antiaddition` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `onlinetime` int(10) unsigned DEFAULT NULL,
  `offlinetime` int(10) unsigned DEFAULT NULL,
  `birthday` bigint(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arenacharacter`
--

DROP TABLE IF EXISTS `arenacharacter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arenacharacter` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `challengenum` int(10) unsigned DEFAULT NULL,
  `cdtime` bigint(10) unsigned DEFAULT NULL,
  `time_reward_num` int(10) unsigned DEFAULT '0',
  `need_check_cd` int(10) unsigned DEFAULT '0',
  `beat_num` int(10) unsigned DEFAULT '0',
  `can_get_rank_reward` int(10) unsigned DEFAULT '0',
  `reward_rank` int(10) unsigned DEFAULT '0',
  `honor` int(10) unsigned DEFAULT '0',
  `maxrank` int(10) unsigned DEFAULT '0',
  `buychallengenum` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arenahistory`
--

DROP TABLE IF EXISTS `arenahistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arenahistory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `sourcecharacterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `targetcharacterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `winnercharacterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `old_rank` int(10) unsigned DEFAULT NULL,
  `new_rank` int(10) unsigned DEFAULT NULL,
  `target_name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arenaranking`
--

DROP TABLE IF EXISTS `arenaranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arenaranking` (
  `ranking` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned DEFAULT NULL,
  `robotid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ranking`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `bank`
--

DROP TABLE IF EXISTS `bank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bank` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `investmentTime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `monthrewardstatus` int(20) unsigned NOT NULL DEFAULT '0',
  `levelinvestmentstatus` int(20) unsigned NOT NULL DEFAULT '0',
  `levelstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `monthitem` int(20) unsigned NOT NULL DEFAULT '0',
  `levelupitem` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bankpersonal`
--

DROP TABLE IF EXISTS `bankpersonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bankpersonal` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `time` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `processtype` int(10) unsigned NOT NULL DEFAULT '0',
  `banktype` int(10) unsigned NOT NULL DEFAULT '0',
  `num` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bankrecord`
--

DROP TABLE IF EXISTS `bankrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bankrecord` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `processtype` int(10) unsigned NOT NULL DEFAULT '0',
  `banktype` int(10) unsigned NOT NULL DEFAULT '0',
  `num` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barter`
--

DROP TABLE IF EXISTS `barter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `barter` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `barterstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `bloodpool`
--

DROP TABLE IF EXISTS `bloodpool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bloodpool` (
  `characterid` bigint(20) unsigned NOT NULL,
  `blood` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `branchtask`
--

DROP TABLE IF EXISTS `branchtask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branchtask` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openstatus` int(10) unsigned NOT NULL DEFAULT '0',
  `singlebranchtask` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dailybranchtask` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `todayrecharge` int(10) unsigned NOT NULL DEFAULT '0',
  `recordtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `cdkey`
--

DROP TABLE IF EXISTS `cdkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdkey` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `cdkey` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`characterid`,`cdkey`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `character`
--

DROP TABLE IF EXISTS `character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `character` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `experience` bigint(19) unsigned DEFAULT '0',
  `stage` int(10) unsigned DEFAULT NULL,
  `hp` int(10) unsigned DEFAULT '200',
  `anger` int(10) unsigned DEFAULT '0',
  `maxhp` int(10) unsigned DEFAULT '200',
  `max_anger` int(10) unsigned DEFAULT '0',
  `attack` int(10) unsigned DEFAULT '0',
  `defence` int(10) DEFAULT '0',
  `fight_speed` int(10) DEFAULT '0',
  `crit` int(10) DEFAULT '0',
  `crit_damage` int(10) DEFAULT '0',
  `dodge` int(10) DEFAULT '0',
  `series` int(10) DEFAULT '0',
  `damage_add` int(10) DEFAULT '0',
  `damage_dec` int(10) DEFAULT '0',
  `ren_add` int(10) DEFAULT '0',
  `xian_add` int(10) DEFAULT '0',
  `mo_add` int(10) DEFAULT '0',
  `ren_dec` int(10) DEFAULT '0',
  `xian_dec` int(10) DEFAULT '0',
  `mo_dec` int(10) DEFAULT '0',
  `stamina` int(10) DEFAULT '100',
  `max_stamina` int(10) DEFAULT '0',
  `anger_fight` int(10) DEFAULT '0',
  `move_speed_second` int(10) DEFAULT '0',
  `arena_max_hp` int(10) unsigned DEFAULT '1000',
  `stamina_buy_num` int(10) DEFAULT '0',
  `stamina_remain_time` int(10) unsigned DEFAULT '0',
  `sceneid` int(10) unsigned DEFAULT NULL,
  `posx` float DEFAULT NULL,
  `posy` float DEFAULT NULL,
  `offlinetime` datetime DEFAULT NULL,
  `updatetime` datetime DEFAULT NULL,
  `create_character_time` datetime DEFAULT NULL,
  `combat` bigint(20) unsigned DEFAULT NULL,
  `eud_rank_combat` bigint(20) unsigned DEFAULT '0',
  `sex` int(10) unsigned DEFAULT '0',
  `loginIP` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logintime` datetime DEFAULT NULL,
  `roletype` int(10) unsigned DEFAULT NULL,
  `profession` int(10) unsigned DEFAULT NULL,
  `body_avatar` int(10) unsigned DEFAULT NULL,
  `wing_avatar` int(10) unsigned DEFAULT '0',
  `weapon_avatar` int(10) unsigned DEFAULT NULL,
  `stamp_avatar` int(10) unsigned DEFAULT '0',
  `shield_avatar` int(10) unsigned DEFAULT '0',
  `talisman_avatar` int(10) unsigned DEFAULT '0',
  `ride_avatar` int(10) unsigned DEFAULT '0',
  `serverid` int(10) unsigned NOT NULL DEFAULT '0',
  `vice` int(10) unsigned DEFAULT '0',
  `body_balance` int(10) unsigned DEFAULT '0',
  `lv_item_use_num` int(10) unsigned DEFAULT '0',
  `vice_remain_time` int(10) unsigned DEFAULT '0',
  `xuruo_remain_time` int(10) unsigned DEFAULT '0',
  `online` int(10) unsigned DEFAULT '0',
  `itemexpid` int(10) unsigned DEFAULT '0',
  `itemexptime` int(10) unsigned DEFAULT '0',
  `levelupitem` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `leveluptime` bigint(10) unsigned DEFAULT '0',
  `yellow_vip_level` int(10) unsigned DEFAULT NULL,
  `yellow_year_vip_level` int(10) unsigned DEFAULT NULL,
  `yellow_high_vip_level` int(10) unsigned DEFAULT NULL,
  `totalonlinetime` bigint(10) unsigned DEFAULT '0',
  `yestodaycombat` bigint(20) unsigned DEFAULT '0',
  `authority` int(10) unsigned DEFAULT '0',
  `highestcombat` bigint(20) unsigned DEFAULT '0',
  `crosssrvid` int(10) unsigned DEFAULT '0',
  `crosshearttime` int(10) unsigned DEFAULT '0',
  `hostiletime` int(10) unsigned DEFAULT '0',
  `guildname` varchar(32) COLLATE utf8_unicode_ci DEFAULT '',
  `renamecount` int(10) unsigned DEFAULT '0',
  `friendcount` int(10) unsigned DEFAULT '0',
  `money_buy_num` INT(10) UNSIGNED NULL DEFAULT '0',
  `newbie_data` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `skill_seq` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `change_profession_count` int(10) UNSIGNED NULL DEFAULT '0',
  `tx_info` VARCHAR(2048) NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `rank_notify` int(10) UNSIGNED NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `characterid` (`characterid`),
  KEY `combat` (`combat`),
  KEY `level` (`level`),
  KEY `name` (`name`),
  KEY `account_serverid` (`account`,`serverid`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `eudemon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eudemon` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `eudemonId` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `quality` int(10) unsigned DEFAULT NULL,
  `ownerId` bigint(20) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned DEFAULT NULL,
  `stage` int(10) unsigned DEFAULT NULL,
  `experience` bigint(19) unsigned DEFAULT '0',
  `hp` int(10) unsigned DEFAULT '200',
  `maxhp` int(10) unsigned DEFAULT '200',
  `max_anger` int(10) unsigned DEFAULT '0',
  `attack` int(10) unsigned DEFAULT '0',
  `defence` int(10) DEFAULT '0',
  `fight_speed` int(10) DEFAULT '0',
  `crit` int(10) DEFAULT '0',
  `crit_damage` int(10) DEFAULT '0',
  `dodge` int(10) DEFAULT '0',
  `series` int(10) DEFAULT '0',
  `damage_add` int(10) DEFAULT '0',
  `damage_dec` int(10) DEFAULT '0',
  `ren_add` int(10) DEFAULT '0',
  `xian_add` int(10) DEFAULT '0',
  `mo_add` int(10) DEFAULT '0',
  `ren_dec` int(10) DEFAULT '0',
  `xian_dec` int(10) DEFAULT '0',
  `mo_dec` int(10) DEFAULT '0',
  `anger_fight` int(10) DEFAULT '0',
  `combat` bigint(20) unsigned DEFAULT '0',
  `rank_combat` bigint(20) unsigned DEFAULT '0',
  `apt_atk` int(10) unsigned DEFAULT '0',
  `apt_def` int(10) unsigned DEFAULT '0',
  `apt_hp` int(10) unsigned DEFAULT '0',
  `apt_speed` int(10) unsigned DEFAULT '0',
  `apt_skill` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
  `active_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fight_pos` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `eudemonId` (`eudemonId`),
  KEY `ownerId` (`ownerId`),
  KEY `combat` (`combat`),
  KEY `level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



--
-- Table structure for table `characterfashioncombat`
--

DROP TABLE IF EXISTS `characterfashioncombat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characterfashioncombat` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characterfashiondress`
--

DROP TABLE IF EXISTS `characterfashiondress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characterfashiondress` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `dressfashion` int(4) unsigned NOT NULL DEFAULT '0',
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characterskill`
--

DROP TABLE IF EXISTS `characterskill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characterskill` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`skillId` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`skillLev` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `skillId`),
	INDEX `characterid` (`characterid`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characterstatus`
--

DROP TABLE IF EXISTS `characterstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characterstatus` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `statusinfo` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `charge`
--

DROP TABLE IF EXISTS `charge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `charge` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`number` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`charge_info` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`last18_charge_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circulamoney`
--

DROP TABLE IF EXISTS `circulamoney`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circulamoney` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rechargenum` int(10) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `citywartime`
--

DROP TABLE IF EXISTS `citywartime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citywartime` (
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consumegift`
--

DROP TABLE IF EXISTS `consumegift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consumegift` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `costemoney` int(20) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `exchangestatus` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `container_gridcd`
--

DROP TABLE IF EXISTS `container_gridcd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `container_gridcd` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `type` int(4) unsigned NOT NULL DEFAULT '0',
  `cd` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`type`),
  KEY `id_type` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `containercombat`
--

DROP TABLE IF EXISTS `containercombat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `containercombat` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `backpackcombat` bigint(20) unsigned DEFAULT NULL,
  `clothescombat` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corona`
--

DROP TABLE IF EXISTS `corona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `corona` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `exchangestatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`serialnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coronapersonal`
--

DROP TABLE IF EXISTS `coronapersonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coronapersonal` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `time` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lotteryid` int(4) unsigned NOT NULL DEFAULT '0',
  `strenglen` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coronarecord`
--

DROP TABLE IF EXISTS `coronarecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coronarecord` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lotteryId` int(4) unsigned NOT NULL DEFAULT '0',
  `strenglen` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `crossboss`
--

DROP TABLE IF EXISTS `crossboss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crossboss` (
  `auto` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bosslev` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`auto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `money` bigint(20) unsigned NOT NULL DEFAULT '0',
  `emoney` bigint(20) unsigned NOT NULL DEFAULT '0',
  `goldmoney` bigint(20) unsigned NOT NULL DEFAULT '0',
  `chargeemoney` bigint(20) unsigned NOT NULL DEFAULT '0',
  `prestige` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guildcontribution` bigint(20) unsigned NOT NULL DEFAULT '0',
  `boxingmedal` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fightcurrency` bigint(20) unsigned NOT NULL DEFAULT '0',
  `generalmedal` bigint(20) unsigned NOT NULL DEFAULT '0',
  `civilianmerit` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`),
  KEY `money` (`money`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dailyrealmbattle`
--

DROP TABLE IF EXISTS `dailyrealmbattle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dailyrealmbattle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `battletimes` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `dbversion`
--

DROP TABLE IF EXISTS `dbversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbversion` (
  `version_number` int(11) NOT NULL DEFAULT '0',
  `db_key` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`version_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `dbversion` (`version_number`, `db_key`) VALUES (1, '1');


--
-- Table structure for table `eightday`
--

DROP TABLE IF EXISTS `eightday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eightday` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `giftbuystatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `festivalactivity`
--

DROP TABLE IF EXISTS `festivalactivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivalactivity` (
  `festivaltype` int(20) unsigned NOT NULL DEFAULT '0',
  `starttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `endtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `groupid` int(20) unsigned NOT NULL DEFAULT '0',
  `status` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`festivaltype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `festivalactivity_draw`
--

DROP TABLE IF EXISTS `festivalactivity_draw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivalactivity_draw` (
  `starttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `endtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `groupid` int(20) unsigned NOT NULL DEFAULT '0',
  `status` int(20) unsigned NOT NULL DEFAULT '0',
  `serialmax` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `festivalactivity_midautumnmobilization`
--

DROP TABLE IF EXISTS `festivalactivity_midautumnmobilization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivalactivity_midautumnmobilization` (
  `starttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `endtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `groupid` int(20) unsigned NOT NULL DEFAULT '0',
  `status` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `festivaldraw`
--

DROP TABLE IF EXISTS `festivaldraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivaldraw` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `drawpoint` bigint(20) unsigned NOT NULL DEFAULT '0',
  `drawcount` int(20) unsigned NOT NULL DEFAULT '0',
  `consumenum` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `festivaldrawpersonalrecord`
--

DROP TABLE IF EXISTS `festivaldrawpersonalrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivaldrawpersonalrecord` (
  `serialid` int(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `drawtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `itemid` int(20) unsigned NOT NULL DEFAULT '0',
  `num` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `festivaldrawrecord`
--

DROP TABLE IF EXISTS `festivaldrawrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivaldrawrecord` (
  `serialid` int(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `itemid` int(20) unsigned NOT NULL DEFAULT '0',
  `num` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `firstcharge`
--

DROP TABLE IF EXISTS `firstcharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `firstcharge` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `nowtimes` int(10) unsigned DEFAULT NULL,
  `toptimes` int(10) unsigned DEFAULT NULL,
  `recharge` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `forbidtalk`
--

DROP TABLE IF EXISTS `forbidtalk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forbidtalk` (
  `charactername` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`charactername`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `freebarter`
--

DROP TABLE IF EXISTS `freebarter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `freebarter` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `barterstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friend`
--
DROP TABLE IF EXISTS `friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friend` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `characterid_target` bigint(20) unsigned NOT NULL DEFAULT '0',
  `send_stamina_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `receive_stamina_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `already_receive_count` int(10) unsigned NOT NULL DEFAULT '0',
  `isfriend` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`characterid_target`),
  KEY `characterid` (`characterid`),
  KEY `target` (`characterid_target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `friendquerylist`
--
DROP TABLE IF EXISTS `friendquerylist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendquerylist` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `applyer_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`applyer_characterid`),
  KEY `characterid` (`characterid`),
  KEY `target` (`applyer_characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `blackerman`
--
DROP TABLE IF EXISTS `blackerman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blackerman` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `blacker_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`blacker_characterid`),
  KEY `characterid` (`characterid`),
  KEY `target` (`blacker_characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `globaldata`
--

DROP TABLE IF EXISTS `globaldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globaldata` (
  `tempid` int(20) unsigned NOT NULL DEFAULT '0',
  `data1` bigint(20) NOT NULL DEFAULT '0',
  `data2` bigint(20) NOT NULL DEFAULT '0',
  `data3` bigint(20) NOT NULL DEFAULT '0',
  `data4` bigint(20) NOT NULL DEFAULT '0',
  `data5` bigint(20) NOT NULL DEFAULT '0',
  `data6` bigint(20) NOT NULL DEFAULT '0',
  `data7` bigint(20) NOT NULL DEFAULT '0',
  `data8` bigint(20) NOT NULL DEFAULT '0',
  `datastr` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`tempid`),
  KEY `character` (`tempid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;





--
-- Table structure for table `guild`
--
DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild` (
  `id` int(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` int(20) unsigned NOT NULL DEFAULT '0',
  `createtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `declaretime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `announce` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `autoaccept` int(20) unsigned NOT NULL DEFAULT '0',
  `limitcombat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guildmoney`  int(10) unsigned NOT NULL DEFAULT '0',
  `xianghuozhi` int(10) unsigned NOT NULL DEFAULT '0',
  `shout_cd_unixtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `donatemember` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `guildevent`
--

DROP TABLE IF EXISTS `guildevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guildevent` (
  `guildid` int(20) unsigned NOT NULL DEFAULT '0',
  `eventid` int(20) unsigned NOT NULL DEFAULT '0',
  `eventtype` int(20) unsigned NOT NULL DEFAULT '0',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `eventparams` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`eventid`),
  KEY `guild` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `guilddonatelog`
--

DROP TABLE IF EXISTS `guilddonatelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guilddonatelog` (
  `guildid` int(20) unsigned NOT NULL DEFAULT '0',
  `eventid` int(20) unsigned NOT NULL DEFAULT '0',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `charactername` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `donatetype` int(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`eventid`),
  KEY `guild` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `guildmember`
--

DROP TABLE IF EXISTS `guildmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guildmember` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guildid` int(20) unsigned NOT NULL DEFAULT '0',
  `rank` int(20) unsigned NOT NULL DEFAULT '0',
  `jointime` datetime DEFAULT NULL,
  PRIMARY KEY (`characterid`),
  KEY `guild` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `guildapplyjoinlist`
--
DROP TABLE IF EXISTS `guildapplyjoinlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guildapplyjoinlist` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`, `characterid`),
  KEY `guild` (`guildid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `guild_donate_info`
--
DROP TABLE IF EXISTS `guild_donate_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_donate_info` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `donate_receive_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `donate_type` int(10) unsigned NOT NULL DEFAULT '0',
  `bosschallengecount` int(10) unsigned NOT NULL DEFAULT '0',
  `bosschallengetime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `total_guild_contribution` bigint(20) unsigned NOT NULL DEFAULT '0',
  `today_guild_contribution` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `guildskill`
--

DROP TABLE IF EXISTS `guildskill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guildskill` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `skilllevel` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `heaven`
--

DROP TABLE IF EXISTS `heaven`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `heaven` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `activestatus` int(20) unsigned NOT NULL DEFAULT '0',
  `wearheavenid` int(20) unsigned NOT NULL DEFAULT '0',
  `onlinetime` int(20) unsigned NOT NULL DEFAULT '0',
  `logindays` int(20) unsigned NOT NULL DEFAULT '0',
  `specialskillstatus` int(20) unsigned NOT NULL DEFAULT '0',
  `heavenbar` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `perfecttimes` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `heavenimprove`
--

DROP TABLE IF EXISTS `heavenimprove`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `heavenimprove` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `heavenid` int(20) unsigned NOT NULL DEFAULT '0',
  `attributedata` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hasunsave` int(20) unsigned NOT NULL DEFAULT '0',
  `unsaveattribute` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `character` (`characterid`),
  KEY `heavenitem` (`characterid`,`heavenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `herocleantime`
--

DROP TABLE IF EXISTS `herocleantime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `herocleantime` (
  `battleid` int(10) unsigned NOT NULL DEFAULT '0',
  `charactername` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cleantime` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`battleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hook`
--

DROP TABLE IF EXISTS `hook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hook` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `is_closed_sound` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_other_character` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_other_immoratal` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_other_wing` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_other_matrix` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_other_magic` int(4) unsigned NOT NULL DEFAULT '0',
  `is_hide_self_immoratal` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `thingcfgid` int(20) unsigned NOT NULL DEFAULT '0',
  `bind` int(4) unsigned NOT NULL DEFAULT '0',
  `timemode` int(4) NOT NULL DEFAULT '0',
  `expiredTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `overlap` int(4) unsigned NOT NULL DEFAULT '0',
  `cd` int(4) unsigned NOT NULL DEFAULT '0',
  `usecount` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itemusecount`
--

DROP TABLE IF EXISTS `itemusecount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemusecount` (
  `autoid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned NOT NULL,
  `itemid` int(20) unsigned NOT NULL,
  `usecount` int(20) unsigned NOT NULL,
  `lastusetime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itemusecountupdatetime`
--

DROP TABLE IF EXISTS `itemusecountupdatetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemusecountupdatetime` (
  `updatetime` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`updatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jieyudazhanlevel`
--

DROP TABLE IF EXISTS `jieyudazhanlevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jieyudazhanlevel` (
  `level` int(20) unsigned NOT NULL DEFAULT '0',
  `buff_remain_time` int(20) unsigned NOT NULL DEFAULT '0',
  `win_num` int(20) unsigned NOT NULL DEFAULT '0',
  `all_num` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `levelrankactivity`
--

DROP TABLE IF EXISTS `levelrankactivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `levelrankactivity` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`type` INT(20) UNSIGNED NOT NULL DEFAULT '0',
	`ranklevel` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
	`receiveinfo` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `lockaccount`
--

DROP TABLE IF EXISTS `lockaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lockaccount` (
  `account` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `locktime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lockip`
--

DROP TABLE IF EXISTS `lockip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lockip` (
  `ip` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `luckytoken`
--

DROP TABLE IF EXISTS `luckytoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `luckytoken` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rechargenum` int(20) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `maincityguild`
--

DROP TABLE IF EXISTS `maincityguild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maincityguild` (
  `sceneid` int(10) unsigned NOT NULL DEFAULT '0',
  `guildid` int(10) unsigned DEFAULT NULL,
  `occupytime` bigint(10) unsigned DEFAULT NULL,
  `official` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `refreshtime` bigint(10) unsigned DEFAULT NULL,
  `wintimes` int(10) unsigned DEFAULT NULL,
  `npcname` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`sceneid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maincitylordprostrates`
--

DROP TABLE IF EXISTS `maincitylordprostrates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maincitylordprostrates` (
  `lordcharacterid` bigint(20) unsigned NOT NULL,
  `lordname` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `lordguildname` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `totaltimes` bigint(20) NOT NULL,
  PRIMARY KEY (`lordcharacterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maincitylordprostrates_player`
--

DROP TABLE IF EXISTS `maincitylordprostrates_player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maincitylordprostrates_player` (
  `characterid` bigint(20) unsigned NOT NULL,
  `times` int(10) NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maketeam`
--

DROP TABLE IF EXISTS `maketeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maketeam` (
  `characterid` bigint(20) NOT NULL,
  `groupid` int(10) NOT NULL,
  `autoinviteintogroup` smallint(2) NOT NULL DEFAULT '0',
  `autoqueryintogroup` smallint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `midautumnmobilization`
--

DROP TABLE IF EXISTS `midautumnmobilization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `midautumnmobilization` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `clantimes` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modulecombat`
--

DROP TABLE IF EXISTS `modulecombat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modulecombat` (
  `characterid` bigint(20) unsigned NOT NULL,
  `strcombat` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monthsign`
--

DROP TABLE IF EXISTS `monthsign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monthsign` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `dailysignstatus` int(4) unsigned NOT NULL DEFAULT '0',
  `resigntimes` int(4) unsigned NOT NULL DEFAULT '0',
  `totalsignnum` int(4) unsigned NOT NULL DEFAULT '0',
  `roundnum` int(10) unsigned NOT NULL DEFAULT '0',
  `daynum` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `noviceprocess`
--

DROP TABLE IF EXISTS `noviceprocess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `noviceprocess` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `completetask` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `onlinereward`
--

DROP TABLE IF EXISTS `onlinereward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `onlinereward` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `onlinetime` int(4) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `partner`
--

DROP TABLE IF EXISTS `partner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partner`(
	`characterid` bigint(20) unsigned NOT NULL DEFAULT '0',  
	`partnerid` int(10) unsigned NOT NULL DEFAULT '0',
	`awakening` int(10) unsigned NOT NULL DEFAULT '0', 
	`createtime` bigint(20) unsigned NOT NULL DEFAULT '0', 
  `maxhp` int(10) unsigned DEFAULT '200',
  `max_anger` int(10) unsigned DEFAULT '0',
  `attack` int(10) unsigned DEFAULT '0',
  `defence` int(10) DEFAULT '0',
  `fight_speed` int(10) DEFAULT '0',
  `crit` int(10) DEFAULT '0',
  `crit_damage` int(10) DEFAULT '0',
  `dodge` int(10) DEFAULT '0',
  `series` int(10) DEFAULT '0',
  `damage_add` int(10) DEFAULT '0',
  `damage_dec` int(10) DEFAULT '0',
  `ren_add` int(10) DEFAULT '0',
  `xian_add` int(10) DEFAULT '0',
  `mo_add` int(10) DEFAULT '0',
  `ren_dec` int(10) DEFAULT '0',
  `xian_dec` int(10) DEFAULT '0',
  `mo_dec` int(10) DEFAULT '0',
  `anger_fight` int(10) DEFAULT '0',
  `combat` bigint(20) unsigned DEFAULT '0',
  `fight_pos` int(10) unsigned DEFAULT '0',

 	PRIMARY KEY (`characterid`,`partnerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `partnerpersonal`
--

DROP TABLE IF EXISTS `partnerpersonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partnerpersonal` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `isopen` int(10) unsigned NOT NULL DEFAULT '0',
  `fightingpartnerid` int(10) unsigned NOT NULL DEFAULT '0',
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `totalcombat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rankpartnercfgid` int(10) unsigned NOT NULL DEFAULT '0',
  `rankpartnerlevel` int(10) unsigned NOT NULL DEFAULT '0',
  `rankpartnerstarlev` int(10) unsigned NOT NULL DEFAULT '0',
  `rankpartnercombat` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `phoneverify`
--

DROP TABLE IF EXISTS `phoneverify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phoneverify` (
  `characterid` bigint(20) unsigned NOT NULL,
  `verifynumber` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `verifytimes` int(10) unsigned NOT NULL,
  `expiredtime` bigint(10) unsigned NOT NULL,
  `verifycode` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `intervaltime` bigint(10) unsigned NOT NULL,
  `isverify` int(10) unsigned NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `plotbattle`
--

DROP TABLE IF EXISTS `plotbattle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plotbattle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `topbattle` int(4) unsigned NOT NULL DEFAULT '0',
  `battletimes` text COLLATE utf8_unicode_ci,
  `cleantime` text COLLATE utf8_unicode_ci,
  `raidsbattle` int(10) unsigned NOT NULL DEFAULT '0',
  `raidstime` int(4) unsigned NOT NULL DEFAULT '0',
  `curtotalnum` int(10) unsigned NOT NULL DEFAULT '0',
  `curbuynum` int(10) unsigned NOT NULL DEFAULT '0',
  `tarraidsnum` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `precinctwarrank`
--

DROP TABLE IF EXISTS `precinctwarrank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `precinctwarrank` (
  `rank` int(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `score` int(10) unsigned NOT NULL DEFAULT '0',
  `guildname` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `puppet`
--

DROP TABLE IF EXISTS `puppet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `puppet` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `realm` int(4) unsigned NOT NULL DEFAULT '0',
  `stageid` int(4) unsigned NOT NULL DEFAULT '0',
  `star` int(4) unsigned NOT NULL DEFAULT '0',
  `potentialnum` int(4) unsigned NOT NULL DEFAULT '0',
  `illusionnum` int(4) unsigned NOT NULL DEFAULT '0',
  `bless` int(4) unsigned NOT NULL DEFAULT '0',
  `countdown` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `skillslot` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `advancedtimes` int(4) unsigned NOT NULL DEFAULT '0',
  `critsymbolvalue` int(4) unsigned NOT NULL DEFAULT '0',
  `critsymbolendtime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  `leveluptime` bigint(4) unsigned NOT NULL DEFAULT '0',
  `fashionid` int(4) unsigned NOT NULL DEFAULT '0',
  `rebateid` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `puppetfashion`
--

DROP TABLE IF EXISTS `puppetfashion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `puppetfashion` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fashionid` int(4) unsigned NOT NULL DEFAULT '0',
  `bforever` int(4) unsigned NOT NULL DEFAULT '0',
  `expiretime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`fashionid`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `rankactivity`
--

DROP TABLE IF EXISTS `rankactivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rankactivity` (
  `ranktype` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `startday` int(10) unsigned NOT NULL DEFAULT '0',
  `starttime` bigint(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ranktype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `realmbattle`
--

DROP TABLE IF EXISTS `realmbattle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realmbattle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `battletimes` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rechargegift`
--

DROP TABLE IF EXISTS `rechargegift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rechargegift` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rechargenum` int(20) unsigned NOT NULL DEFAULT '0',
  `rewardstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rechargemonster`
--

DROP TABLE IF EXISTS `rechargemonster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rechargemonster` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `getrewardstatus` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `rechargeturn`
--

DROP TABLE IF EXISTS `rechargeturn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rechargeturn` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `countid` int(10) unsigned NOT NULL DEFAULT '0',
  `hadgetturnid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recoupaccount`
--

DROP TABLE IF EXISTS `recoupaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recoupaccount` (
  `account` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `emoney` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `redstonehill`
--

DROP TABLE IF EXISTS `redstonehill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `redstonehill` (
  `characterid` bigint(20) unsigned NOT NULL,
  `score` bigint(20) unsigned NOT NULL,
  `rewardsavvytoday` bigint(20) unsigned NOT NULL,
  `costscoretoday` bigint(20) unsigned NOT NULL,
  `buyinfo` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `sevendays`
--

DROP TABLE IF EXISTS `sevendays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sevendays` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openstatus` int(10) unsigned NOT NULL DEFAULT '0',
  `continueddays` int(4) unsigned NOT NULL DEFAULT '0',
  `refreshcontinueddaytime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rewardstatus` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `sougoulogin`
--

DROP TABLE IF EXISTS `sougoulogin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sougoulogin` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `hallstatus` int(10) unsigned NOT NULL DEFAULT '0',
  `inputstatus` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `starbattlescore`
--

DROP TABLE IF EXISTS `starbattlescore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `starbattlescore` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `score` int(10) unsigned NOT NULL DEFAULT '0',
  `scoretime` bigint(10) unsigned NOT NULL DEFAULT '0',
  `getscoretime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




--
-- Table structure for table `supervip`
--

DROP TABLE IF EXISTS `supervip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supervip` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `chargeemoney` int(10) unsigned NOT NULL DEFAULT '0',
  `resettime` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rewardstatus` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system` (
  `openservertime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `test_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
  `closeservertime` bigint(20) unsigned DEFAULT NULL,
  `combinedtimes` int(20) unsigned DEFAULT '0',
  PRIMARY KEY (`openservertime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `teambattle`
--

DROP TABLE IF EXISTS `teambattle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teambattle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `wingsnake` int(10) unsigned NOT NULL DEFAULT '0',
  `wingsnakeclean` int(10) unsigned NOT NULL DEFAULT '0',
  `guardcloudcity` int(10) unsigned NOT NULL DEFAULT '0',
  `guardcloudcityclean` int(10) unsigned NOT NULL DEFAULT '0',
  `guardvein` int(10) unsigned NOT NULL DEFAULT '0',
  `guardveinclean` int(10) unsigned NOT NULL DEFAULT '0',
  `dragonarray` int(10) unsigned NOT NULL DEFAULT '0',
  `dragonarrayclean` int(10) unsigned NOT NULL DEFAULT '0',
  `godpoint` int(10) unsigned NOT NULL DEFAULT '0',
  `todaypoint` int(10) unsigned NOT NULL DEFAULT '0',
  `impasselinetimes` int(10) unsigned NOT NULL DEFAULT '0',
  `impasserewardtimes` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `turntablepersonal`
--

DROP TABLE IF EXISTS `turntablepersonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turntablepersonal` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `time` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lotteryid` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turntablerecord`
--

DROP TABLE IF EXISTS `turntablerecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turntablerecord` (
  `serialnumber` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lotteryId` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`serialnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;





--
-- Table structure for table `vipbattle`
--

DROP TABLE IF EXISTS `vipbattle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vipbattle` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `battletimes` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `viprebategift`
--

DROP TABLE IF EXISTS `viprebategift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viprebategift` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `buygiftid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vipsystem`
--

DROP TABLE IF EXISTS `vipsystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vipsystem` (
  `resettime` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`resettime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weaponpractice`
--

DROP TABLE IF EXISTS `weaponpractice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weaponpractice` (
  `characterid` bigint(20) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `curpractised` int(10) unsigned NOT NULL DEFAULT '0',
  `totalpractised` int(10) unsigned NOT NULL DEFAULT '0',
  `potentialnum` int(10) unsigned NOT NULL DEFAULT '0',
  `illusionnum` int(10) unsigned NOT NULL DEFAULT '0',
  `combat` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `welfarecommon`
--

DROP TABLE IF EXISTS `welfarecommon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `welfarecommon` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`invite_reward` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`charge_forbid` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `worshipcharacter`
--

DROP TABLE IF EXISTS `worshipcharacter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worshipcharacter` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `target` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worshiptimes`
--

DROP TABLE IF EXISTS `worshiptimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worshiptimes` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `times` int(10) unsigned DEFAULT NULL,
  `worshiptime` bigint(19) unsigned DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xinhuohuanyu_signup`
--

DROP TABLE IF EXISTS `xinhuohuanyu_signup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xinhuohuanyu_signup` (
  `characterid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `yellowdiamond`
--

DROP TABLE IF EXISTS `yellowdiamond`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yellowdiamond` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `dailyfloor` int(10) unsigned NOT NULL DEFAULT '0',
  `dailyisget` int(10) unsigned NOT NULL DEFAULT '0',
  `growstatus` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bnewbie` int(10) unsigned NOT NULL DEFAULT '0',
  `yearisget` int(10) unsigned NOT NULL DEFAULT '0',
  `deluxisget` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `yellowvip`
--

DROP TABLE IF EXISTS `yellowvip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yellowvip` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `discountid` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `status` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`discountid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping routines for database 'xy2'
--
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_BUYAUCTION` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_BUYAUCTION`(IN para_id INT UNSIGNED, IN para_characterid BIGINT UNSIGNED, IN para_buycharacter BIGINT UNSIGNED, IN para_equipid BIGINT UNSIGNED, IN para_itemid BIGINT UNSIGNED, IN para_money BIGINT UNSIGNED, IN para_emoney BIGINT UNSIGNED, IN para_charge BIGINT UNSIGNED
, IN para_container text, IN para_container_type INT UNSIGNED)
begin
	
	update currency set money=para_money,emoney=para_emoney,chargeemoney=para_charge where characterid = para_buycharacter;
	if para_itemid > 0 then
		update item set characterid=para_buycharacter where id=para_itemid;
	end if;
	if para_equipid > 0 then
		update equipment set characterid=para_buycharacter where id=para_equipid;
	end if;
	if para_container<>'' then
		update containers set thing=para_container where characterid=para_buycharacter and type= para_container_type;
	end if;

#	delete from auctiongoods where id = para_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_CHARACTER_RENAME` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_CHARACTER_RENAME`(IN `para_name` char(255), IN `para_id` BIGINT UNSIGNED, IN `para_renamecount` INT UNSIGNED)
begin
#	update auctiongoods set charactername=para_name where characterid=para_id;
#	update auctionincome set charactername=para_name where characterid=para_id;
#	update auctionincome set buyername=para_name where characterid_buyer=para_id;
	update turntablerecord set name=para_name where characterid=para_id;
	update coronarecord set name=para_name where characterid=para_id;
	update bankrecord set name=para_name where characterid=para_id;
	update precinctwarrank set name=para_name where characterid=para_id;
	update `character` set name=para_name, renamecount=para_renamecount where characterid=para_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_CREATE_CHARACTER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_CREATE_CHARACTER`(IN `para_account` char(255), IN `para_serverid` INT UNSIGNED, IN `para_name` char(255), IN `para_sex` INT UNSIGNED, IN `para_body_avatar` INT UNSIGNED, IN `para_weapon_avatar` INT UNSIGNED, IN `para_roletype` INT UNSIGNED, IN `para_profession` INT UNSIGNED, IN `para_sceneid` INT UNSIGNED, IN `para_posx` float, IN `para_posy` float, IN `para_nowtime` DATETIME)
begin

declare  ret    int  DEFAULT 0;

declare character_num int default 0;

declare last_insert_id int unsigned default 0;

declare characterid_temp bigint unsigned default 0;



select count(*) from `character` where account = para_account and serverid = para_serverid into character_num;



if character_num = 0 then

	select count(*) from `character` where `character`.name = para_name into ret;

	if ret = 0 then

  		insert into `character` (account, serverid, name, level, stage, sceneid, posx, posy, sex, roletype, profession, create_character_time, body_avatar, weapon_avatar) values (para_account, para_serverid, para_name, 1, 1, para_sceneid, para_posx, para_posy, para_sex, para_roletype, para_profession, para_nowtime, para_body_avatar, para_weapon_avatar);

		set last_insert_id = LAST_INSERT_ID();

		set characterid_temp = last_insert_id * 1000000000 + para_serverid;

		update `character` set characterid = characterid_temp where id = last_insert_id;

		if para_profession = 1 then
			insert into `characterskill` (`characterid`, `skillId`, `skillLev`) values (characterid_temp, 1001001, 1);
		elseif para_profession = 2 then
			insert into `characterskill` (`characterid`, `skillId`, `skillLev`) values (characterid_temp, 1003001, 1);
		else
			insert into `characterskill` (`characterid`, `skillId`, `skillLev`) values (characterid_temp, 1002001, 1);
		end if;

		insert into `characterstatus` (characterid, statusinfo) values (characterid_temp, "");

	end if;

	select ret, para_name, characterid_temp, para_sex;

end if;



end ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `GS_SP_CREATE_EUDEMON`;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_CREATE_EUDEMON`(IN `para_serverid` INT UNSIGNED, IN `para_type` INT UNSIGNED, IN `para_owner` BIGINT UNSIGNED)
begin

declare last_insert_id int unsigned default 0;

declare eudemonid_temp bigint unsigned default 0;

insert into `eudemon` (type, ownerId, level, stage) values (para_type, para_owner, 1, 1);

set last_insert_id = LAST_INSERT_ID();

set eudemonid_temp = last_insert_id * 1000000000 + 100000000 + para_serverid;

update `eudemon` set eudemonId = eudemonid_temp where id = last_insert_id;

select eudemonid_temp;

end ;;
DELIMITER ;


/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_CREATE_ROBOT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_CREATE_ROBOT`(IN `robotnum` INT UNSIGNED)
begin
	declare nNum int default 0;
	declare idCharacter bigint unsigned default 0;
	declare account CHAR(32) default "";
	declare unLevel int unsigned default 99;
	declare unHp int unsigned default 999999999;
	declare unCombat int unsigned default 0;
	declare datetime1 datetime default date_sub(now(), interval 1 day);
	declare datetime2 datetime default date_add(now(), interval 1 day);
	declare cur_rank int unsigned default 1;

	select max(characterid) into idCharacter from `character`;
	if isnull(idCharacter)  then
		set idCharacter=0;
	end if;

	select max(ranking) into cur_rank from `arenaranking`;
	if isnull(cur_rank)  then
		set  cur_rank=0;
	end if;

	set nNum = 1;
	myloop: LOOP
		if nNum > robotnum then
			LEAVE myloop;
		end if;

		set account = CONCAT('robot', CAST(nNum as char));
		set unLevel = 80;
		set unCombat = 836;
		set idCharacter = idCharacter + 1;
		set cur_rank = cur_rank + 1;

		insert into `character` (characterid, account, name, level, sceneid, posx, posy, combat, profession, offlinetime, logintime, serverid, hp, body_avatar, weapon_avatar, realm, stageid) values (idCharacter, account, account, unLevel, 6006, 38, 41, unCombat, 0, datetime1, datetime2, 1, unHp, 2000000, 2000001, 3, 1);
		insert into `puppet`(characterid,realm,stageid) values(idCharacter, 3, 2);
		insert into `worshiptimes`(characterid,times) values(idCharacter, 100);
		insert into `arenacharacter` (characterid, challengenum)  values  (idCharacter, 0);
		insert into `arenaranking` (ranking, characterid)  values (cur_rank, idCharacter);
		insert into `noviceprocess` (characterid, completetask)  values (idCharacter, 10009);
		insert into `heaven` (characterid,activestatus,wearheavenid) value (idCharacter, 2, 1);

     		set nNum = nNum + 1;
	end  LOOP  myloop;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_INSERT_ARENA_HISTORY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_INSERT_ARENA_HISTORY`(IN `para_characterid` bigint unsigned, IN `para_sourcecharacterid` bigint unsigned, IN `para_targetcharacterid` bigint unsigned, IN `para_winner` bigint unsigned, IN `para_old_rank` int unsigned, IN `para_new_rank` int unsigned, IN `para_target_name` char(255))
begin
	declare history_num int unsigned;
	select count(*) from arenahistory where characterid = para_characterid into history_num;
	if history_num >= 20 then
		delete from arenahistory where characterid=para_characterid order by id limit 1;
	end if;
	insert into `arenahistory` (characterid, sourcecharacterid, targetcharacterid, winnercharacterid, old_rank, new_rank, target_name) values (para_characterid, para_sourcecharacterid, para_targetcharacterid, para_winner, para_old_rank, para_new_rank, para_target_name);
end ;;
DELIMITER ;
#/*!50003 SET sql_mode              = @saved_sql_mode */ ;
#/*!50003 SET character_set_client  = @saved_cs_client */ ;
#/*!50003 SET character_set_results = @saved_cs_results */ ;
#/*!50003 SET collation_connection  = @saved_col_connection */ ;
#/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_LOCKAUCTION` */;
#/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
#/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
#/*!50003 SET @saved_col_connection = @@collation_connection */ ;
#/*!50003 SET character_set_client  = utf8 */ ;
#/*!50003 SET character_set_results = utf8 */ ;
#/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
#/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
#/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
#DELIMITER ;;
#CREATE PROCEDURE `GS_SP_LOCKAUCTION`(IN `para_id` INT UNSIGNED, IN `para_characterid` BIGINT UNSIGNED, IN `para_price` INT UNSIGNED, IN `para_item` INT UNSIGNED, IN `para_equip` INT UNSIGNED)
#begin
#	declare d_lock int unsigned default 0;
#	declare d_price int unsigned default 0;
#	declare d_res int unsigned default 1;
#	select price,buylock from auctiongoods where id=para_id into d_price,d_lock;
#	if d_lock <> 0 then
#		set d_res = 0;
#	elseif d_price <> para_price then
#		set d_res = 0;
#	end if;
#	
#	if d_res = 1 then
#		update auctiongoods set buylock=para_characterid where id=para_id;
#	end if;
#	select a.id,a.characterid,a.charactername,a.goodstype,a.data,a.selltype,a.price,b.thingcfgid,b.overlap,c.thingcfgid,c.strengthen,c.realm,c.stage,c.additional,c.randomfactor,a.buylock,d_res from auctiongoods a LEFT JOIN item b ON a.goodstype=para_item and a.data=b.id LEFT JOIN equipment c ON a.goodstype=para_equip and a.data=c.id  where a.id=para_id;
#end ;;
#DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_MERCHANDISE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_MERCHANDISE`(IN para_id BIGINT UNSIGNED, IN para_things char(255), IN para_container text, IN para_emoney BIGINT UNSIGNED, IN para_charge BIGINT UNSIGNED, IN para_other_id BIGINT UNSIGNED, IN para_other_things char(255), IN para_other_container text, IN para_other_emoney BIGINT UNSIGNED, IN para_other_charge BIGINT UNSIGNED, IN para_container_type INT UNSIGNED)
begin

declare str char(255);
if (length(para_things) > 0) then
	set str = concat('update item set characterid=', para_id, ' where id in(', para_things, ')');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;

	set str = concat('update equipment set characterid=', para_id, ' where id in(', para_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;
end if;

if (length(para_other_things) > 0) then
	set str = concat('update item set characterid=', para_other_id, ' where id in(', para_other_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;

	set str = concat('update equipment set characterid=', para_other_id, ' where id in(', para_other_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;
end if;

update currency set emoney=para_emoney,chargeemoney=para_charge  where characterid=para_id;
update currency set emoney=para_other_emoney,chargeemoney=para_other_charge where characterid=para_other_id;
update containers set thing=para_other_container where characterid=para_other_id and type=para_container_type;
update containers set thing=para_container where characterid=para_id and type= para_container_type;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_REGISTER_ACCOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_REGISTER_ACCOUNT`(IN para_account char(255), IN para_nowtime datetime)
begin

	declare account_num int DEFAULT 0;
	declare gm_local int DEFAULT 0;

	select count(*), gm from `account` where account = para_account into account_num, gm_local;

	if account_num = 0 then
		insert into `account` values (para_account, para_nowtime, 0);
	else
		select account_num, gm_local;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_SEARCHAUCTION` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GS_SP_SEARCHAUCTION`(IN para_mainfilter INT UNSIGNED, IN para_subfilter INT UNSIGNED, IN para_quality INT UNSIGNED, IN para_level INT UNSIGNED)
begin

declare str char(255);
if (length(para_things) > 0) then
	set str = concat('update item set characterid=', para_id, ' where id in(', para_things, ')');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;

	set str = concat('update equipment set characterid=', para_id, ' where id in(', para_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;
end if;

if (length(para_other_things) > 0) then
	set str = concat('update item set characterid=', para_other_id, ' where id in(', para_other_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;

	set str = concat('update equipment set characterid=', para_other_id, ' where id in(', para_other_things, ' )');
	set @sql1 = str;
	prepare stmt_p from @sql1;
	execute stmt_p;
end if;

update currency set emoney=para_emoney  where characterid=para_id;
update currency set emoney=para_other_emoney where characterid=para_other_id;
update containers set thing=para_other_container where characterid=para_other_id and type=para_container_type;
update containers set thing=para_container where characterid=para_id and type= para_container_type;

end ;;
#DELIMITER ;
#/*!50003 SET sql_mode              = @saved_sql_mode */ ;
#/*!50003 SET character_set_client  = @saved_cs_client */ ;
#/*!50003 SET character_set_results = @saved_cs_results */ ;
#/*!50003 SET collation_connection  = @saved_col_connection */ ;
#/*!50003 DROP PROCEDURE IF EXISTS `GS_SP_UPDATEAUCTION` */;
#/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
#/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
#/*!50003 SET @saved_col_connection = @@collation_connection */ ;
#/*!50003 SET character_set_client  = utf8 */ ;
#/*!50003 SET character_set_results = utf8 */ ;
#/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
#/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
#/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
#DELIMITER ;;
#CREATE PROCEDURE `GS_SP_UPDATEAUCTION`(IN para_id INT UNSIGNED, IN para_price INT UNSIGNED)
#begin
#	declare d_lock int unsigned default 0;
#	declare d_res int unsigned default 1;
#	declare d_num int unsigned default 0;
#	select buylock,num from auctiongoods where id=para_id into d_lock,d_num;
#	if d_lock <> 0 then
#		set d_res = 0;
#	end if;
#	
#	if d_res = 1 && d_num > 0 then
#		update auctiongoods set price=para_price,perprice=(para_price/d_num) where id=para_id;
#	end if;
#
#end ;;
DELIMITER ;

-- Dump completed on 2018-04-23 17:12:27
DROP TABLE IF EXISTS `addpoint`;
CREATE TABLE `addpoint` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `currplanid` int(10) unsigned NOT NULL DEFAULT '0',
  `freechangeplan` int(10) unsigned DEFAULT '0',
  `washpointopenstatus` int(10) unsigned DEFAULT '0',
  `iscompletefirstwashpoint` int(10) unsigned DEFAULT '0',
  `washpointcdtime` bigint(20) unsigned DEFAULT '0',
  PRIMARY  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `plan_of_addpoint`;
CREATE TABLE `plan_of_addpoint` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `planid` int(10) unsigned NOT NULL DEFAULT '0',
  `freeattripoint` int(10) unsigned DEFAULT '0',
  `life_point` int(10) unsigned DEFAULT '0',
  `mana_point` int(10) unsigned DEFAULT '0',
  `power_point` int(10) unsigned DEFAULT '0',
  `stamina_point` int(10) unsigned DEFAULT '0',
  `dex_point` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`characterid`,`planid`),
  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `zhenfa`;
CREATE TABLE `zhenfa` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openflag` int(10) unsigned DEFAULT '0',
  `currentzhenfaid` int(10) unsigned DEFAULT '0',
  `level` int(10) unsigned DEFAULT '0',
  `exp` int(10) unsigned DEFAULT '0',
  `idlist` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY  KEY `character` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `mailcfgid` int(10) unsigned NOT NULL DEFAULT '0',
  `status` int(10) unsigned NOT NULL DEFAULT '0',
  `createdatetime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `deletedatetime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `exp` int(10) unsigned NOT NULL DEFAULT '0',
  `currencydata` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `designid` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thingdata` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `define_title` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `define_content` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `partner_zhenfa`;
CREATE TABLE `partner_zhenfa`
(
`characterid` bigint(20) unsigned NOT NULL DEFAULT '0',  
`partner1` int(10)  NOT NULL DEFAULT '0',
`partner2` int(10)  NOT NULL DEFAULT '0',
`partner3` int(10)  NOT NULL DEFAULT '0',
`partner4` int(10)  NOT NULL DEFAULT '0',
`partnerJB1` int(10)  NOT NULL DEFAULT '0',
`partnerJB2` int(10)  NOT NULL DEFAULT '0',
`partnerJB3` int(10)  NOT NULL DEFAULT '0',
`partnerJB4` int(10)  NOT NULL DEFAULT '0',
`partnerJB5` int(10)  NOT NULL DEFAULT '0',
`partnerJB6` int(10)  NOT NULL DEFAULT '0',
`partnerJB7` int(10)  NOT NULL DEFAULT '0',
`partnerJB8` int(10)  NOT NULL DEFAULT '0',
PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `containers`
--

DROP TABLE IF EXISTS `containers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `containers` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `type` int(4) unsigned NOT NULL DEFAULT '0',
  `page` int(4) unsigned NOT NULL DEFAULT '0',
  `name` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(4) unsigned NOT NULL DEFAULT '0',
  `thing` text COLLATE utf8_unicode_ci,
  `auto_resolve` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`type`,`page`),
  KEY `id_type` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `equipment`
--
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `thingcfgid` int(20) unsigned NOT NULL DEFAULT '0',
  `bind` int(4) unsigned NOT NULL DEFAULT '0',
  `timemode` int(4) NOT NULL DEFAULT '0',
  `expiredTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `combatvalue` bigint(20) unsigned NOT NULL DEFAULT '0',
  `overlap` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `itemget`
--
DROP TABLE IF EXISTS `itemuse`;
CREATE TABLE `itemuse` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `itemid` BLOB,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `fight_command`;
CREATE TABLE `fight_command` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `command` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`type`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `newshopdata`;
CREATE TABLE `newshopdata` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `shopid` int(10) unsigned NOT NULL DEFAULT '0',
  `shopgoodslist` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `goodsinfo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smallshop_buyrecord` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`shopid`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `discountshopstatus`;
CREATE TABLE `discountshopstatus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `matchesid` int(10) unsigned NOT NULL DEFAULT '0',
  `time` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `discountshopdata`;
CREATE TABLE `discountshopdata` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `matchesid` int(10) unsigned NOT NULL DEFAULT '0',
  `buygoodsinfo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `partner_equip_train`;
CREATE TABLE `partner_equip_train` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `slotid` int(10) unsigned NOT NULL DEFAULT '0',
  `part_helmet` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_necklace` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_weapon` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_clothes` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_belt` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_shoes` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_magic` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_unknow` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `set_config_type` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`slotid`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for zhuagui
-- ----------------------------
DROP TABLE IF EXISTS `zhuagui`;
CREATE TABLE `zhuagui` (
  `characterid` bigint(20) unsigned NOT NULL,
  `flushtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `currring` int(10) unsigned NOT NULL DEFAULT '0',
 	`ringlev` int(10) unsigned NOT NULL DEFAULT '0', 
 	`buynum` int(10) unsigned NOT NULL DEFAULT '0', 
 	`zhandouid` int(10) unsigned NOT NULL DEFAULT '0', 
 	`finishguild` int(10) unsigned NOT NULL DEFAULT '0', 
 	`status` int(10) unsigned NOT NULL DEFAULT '0', 
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for materialfb
-- ----------------------------
DROP TABLE IF EXISTS `materialfb`;
CREATE TABLE `materialfb` (
  `characterid` bigint(20) unsigned NOT NULL,
  `groupid` int(10) unsigned zerofill NOT NULL,
  `payfinishTimes` int(10) unsigned zerofill NOT NULL,
  `freefinishTimes` int(10) unsigned zerofill NOT NULL,
  PRIMARY KEY (`characterid`,`groupid`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for `develop_system_data`
-- ----------------------------
DROP TABLE IF EXISTS `develop_system_data`;
CREATE TABLE `develop_system_data` (
  `characterid` bigint(20) unsigned NOT NULL,
  `developetype` int(10) unsigned NOT NULL,
  `avatarused` int(10) unsigned NOT NULL,
  `open` int(10) NOT NULL,
  `level` int(10) NOT NULL,
  `exp` int(10) NOT NULL,
  `attriusednum` int(10) NOT NULL DEFAULT '0',
  `lvupgiftflag` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `equipinfo` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `skillinfo` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `skinlist` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `soullv` int(10) NOT NULL DEFAULT '0',
  `soulexp` int(10) NOT NULL DEFAULT '0',
  `combatvalue` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`, `developetype`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `plot_push_map`  
-- star_reward_flag=[starvalue][receiveflag]
-- stage_data=[stageid][changecount][star][firstflag]
-- ----------------------------
DROP TABLE IF EXISTS `plot_push_map`;
CREATE TABLE `plot_push_map` (
  `characterid` bigint(20) unsigned NOT NULL,
  `chapterid` int(10) unsigned NOT NULL,
  `star_reward_flag` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stage_data` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`,`chapterid`),
  KEY `character_id` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `plot_push_rank_data`  
-- ----------------------------
DROP TABLE IF EXISTS `plot_push_rank_data`;
CREATE TABLE `plot_push_rank_data` (
  `characterid` bigint(20) unsigned NOT NULL,
  `total_star_count` int(10) unsigned NOT NULL DEFAULT '0',
  `reward_star_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bot_win_count` int(10) unsigned NOT NULL DEFAULT '0',
  `total_mop_count` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `partner_recruit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partner_recruit` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `normal_recruit_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `super_recruit_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `half_recruit_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `normal_recruit_count` int(10) unsigned NOT NULL DEFAULT '0',
  `super_recruit_count` int(10) unsigned NOT NULL DEFAULT '0',
  `prime_recruit_count` int(10) unsigned NOT NULL DEFAULT '0',
  `recruit_quality_option` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- ----------------------------
-- Table structure for user_firstimpulseday
-- ----------------------------
DROP TABLE IF EXISTS `user_firstimpulseday`;
CREATE TABLE `user_firstimpulseday` (
  `characterid` bigint(20) unsigned NOT NULL,
  `chargenum` int(20) unsigned zerofill NOT NULL,
  `reward_flag` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `matchesid` int(20) unsigned zerofill NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_firstimpulseday
-- ----------------------------
DROP TABLE IF EXISTS `sys_firstimpulseday`;
CREATE TABLE `sys_firstimpulseday` (
  `matchesid` int(10) unsigned NOT NULL DEFAULT '0',
  `openserverday` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`matchesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

  
-- ----------------------------
-- Table structure for `plot_quest`  
-- ----------------------------
DROP TABLE IF EXISTS `plot_quest`;
CREATE TABLE `plot_quest` (
  `characterid` bigint(20) unsigned NOT NULL,
  `plottaskid` int(10) unsigned NOT NULL,
  `plottaskprogress` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `clean_battle_list` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for firstimpulse
-- ----------------------------
DROP TABLE IF EXISTS `firstimpulse`;
CREATE TABLE `firstimpulse` (
  `characterid` bigint(20) unsigned NOT NULL,
  `chargenum` int(10) unsigned NOT NULL,
  `reward_flag` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for danyao
-- ----------------------------
DROP TABLE IF EXISTS `danyao`;
CREATE TABLE `danyao` (
  `characterid` bigint(20) unsigned NOT NULL,
  `danyaoid` int(10) unsigned NOT NULL DEFAULT '0',
  `use_num` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`,`danyaoid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for practice_skill
-- ----------------------------
DROP TABLE IF EXISTS `practice_skill`;
CREATE TABLE `practice_skill` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`skillId` INT(10) UNSIGNED NOT NULL,
	`skillLev` INT(10) UNSIGNED NOT NULL,
	`exp` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`characterid`, `skillId`),
	INDEX `characterid` (`characterid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for touzi_plan
-- ----------------------------
DROP TABLE IF EXISTS `touzi_plan`;
CREATE TABLE `touzi_plan` (
  `characterid` bigint(20) unsigned NOT NULL,
  `logindays` int(10) NOT NULL,
  `status` int(10) NOT NULL,
  `get` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `doubleinfo` int(10) NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for kaifu_fund
-- ----------------------------
DROP TABLE IF EXISTS `kaifu_fund`;
CREATE TABLE `kaifu_fund` (
  `characterid` bigint(20) unsigned NOT NULL,
  `status` int(10) NOT NULL,
  `rewardinfo` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for all_advance
-- ----------------------------
DROP TABLE IF EXISTS `all_advance`;
CREATE TABLE `all_advance` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`type` INT(10) NOT NULL,
	`get` VARCHAR(1024) NOT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`id`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for `advance_day`
-- ----------------------------
DROP TABLE IF EXISTS `advance_day`;
CREATE TABLE `advance_day` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`openserverday` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`get` VARCHAR(1024) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

-- ----------------------------
-- Table structure for `demon_king`
-- ----------------------------
DROP TABLE IF EXISTS `demon_king`;
CREATE TABLE `demon_king` (
	`indexId` INT(10) UNSIGNED NOT NULL,
	`nextRefreshTime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`killrank` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`indexId`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;

-- ----------------------------
-- Table structure for `user_demon_king`
-- ----------------------------
DROP TABLE IF EXISTS `user_demon_king`;
CREATE TABLE `user_demon_king` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`fightnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`nextRefreshTime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`remindInfo` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`totalChallengeCount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) COLLATE='utf8_unicode_ci' ENGINE=InnoDB;



-- ----------------------------
-- Table structure for user_recharge_day
-- ----------------------------
DROP TABLE IF EXISTS `user_recharge_day`;
CREATE TABLE `user_recharge_day` (
  `characterid` bigint(20) unsigned NOT NULL,
  `chargenum` int(20) unsigned NOT NULL DEFAULT '0',
  `reward_flag` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `matchesid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_recharge_day
-- ----------------------------
DROP TABLE IF EXISTS `sys_recharge_day`;
CREATE TABLE `sys_recharge_day` (
  `matchesid` int(10) unsigned NOT NULL DEFAULT '0',
  `openserverday` int(10) unsigned NOT NULL DEFAULT '0',
  `endflagvalue` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`matchesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for sys_groupbuy_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_groupbuy_data`;
CREATE TABLE `sys_groupbuy_data` (
  `begin_unixtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `activityid` int(10) unsigned NOT NULL DEFAULT '0',
  `recharge_count` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`begin_unixtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for user_groupbuy_data
-- ----------------------------
DROP TABLE IF EXISTS `user_groupbuy_data`;
CREATE TABLE `user_groupbuy_data` (
  `characterid` bigint(20) unsigned NOT NULL,
  `chargenum` int(20) unsigned NOT NULL DEFAULT '0',
  `reward_receive_flag` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_breakblockade_ranklist
-- ----------------------------
DROP TABLE IF EXISTS `sys_breakblockade_ranklist`;
CREATE TABLE `sys_breakblockade_ranklist` (
  `characterid` bigint(20) unsigned NOT NULL,
  `diffculty` int(10) unsigned NOT NULL DEFAULT '0',
  `groupid` int(10) unsigned NOT NULL DEFAULT '0',
  `record_unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for user_breakblockade
-- ----------------------------
DROP TABLE IF EXISTS `user_breakblockade`;
CREATE TABLE `user_breakblockade` (
  `characterid` bigint(20) unsigned NOT NULL,
  `diffculty` int(20) unsigned NOT NULL DEFAULT '0',
  `groupid` int(20) unsigned NOT NULL DEFAULT '0',
  `receiveflag` int(20) unsigned NOT NULL DEFAULT '0',
  `challengenum` int(20) unsigned NOT NULL DEFAULT '0',
  `mopblockades` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_history_data` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for user_functionopen_list
-- ----------------------------
DROP TABLE IF EXISTS `user_functionopen_list`;
CREATE TABLE `user_functionopen_list` (
  `characterid` bigint(20) unsigned NOT NULL,
  `functionid` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`, `functionid`),
  INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for world_boss
-- ----------------------------
DROP TABLE IF EXISTS `world_boss`;
CREATE TABLE `world_boss` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`difficulty` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



--
-- Table structure for table `user_advancerank`
--

DROP TABLE IF EXISTS `user_advancerank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_advancerank` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `config_groupid` int(10) unsigned NOT NULL DEFAULT '0',
  `ranklevel` bigint(20) unsigned NOT NULL DEFAULT '0',
  `receive_status` int(10) unsigned NOT NULL DEFAULT '0',
  `record_unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `highestcombat` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`characterid`, `config_groupid`),
  INDEX `character_index` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


-- ----------------------------
-- Table structure for sys_advancerank
-- ----------------------------
DROP TABLE IF EXISTS `sys_advancerank`;
CREATE TABLE `sys_advancerank` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `config_groupid` int(10) unsigned NOT NULL DEFAULT '0',
  `ranklv` bigint(20) unsigned NOT NULL DEFAULT '0',
  `combatvalue` bigint(20) unsigned NOT NULL DEFAULT '0',
  `record_unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`, `config_groupid`),
  INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_advancerank_server_status
-- ----------------------------
DROP TABLE IF EXISTS `sys_advancerank_server_status`;
CREATE TABLE `sys_advancerank_server_status` (
  `server_status` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`server_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for boss_challenge
-- ----------------------------
DROP TABLE IF EXISTS `boss_challenge`;
CREATE TABLE `boss_challenge` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`begintime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`endtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`bossid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for user_boss_challenge
-- ----------------------------
DROP TABLE IF EXISTS `user_boss_challenge`;
CREATE TABLE `user_boss_challenge` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`tollgateid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `user_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_active` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `treasure_lev` int(20) unsigned NOT NULL DEFAULT '0',
  `treasure_exp` int(20) unsigned NOT NULL DEFAULT '0',
  `active_value` int(20) unsigned NOT NULL DEFAULT '0',
  `activestatus1` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activestatus2` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activerewardstatus` int(20) unsigned NOT NULL DEFAULT '0',
  `activeflushtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `vip`
--

DROP TABLE IF EXISTS `vip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vip` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `viplev` int(10) unsigned NOT NULL DEFAULT '0',
  `vipexp` int(10) unsigned NOT NULL DEFAULT '0',
  `giftstatus` int(10) unsigned NOT NULL DEFAULT '0',
  `specialgiftstatus` int(10) unsigned NOT NULL DEFAULT '0',
  `vipgiftlist` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


-- ----------------------------
-- Table structure for sys_red_packet
-- ----------------------------
DROP TABLE IF EXISTS `sys_red_packet`;
CREATE TABLE `sys_red_packet` (
  `total_login_yesterday` int(10) unsigned NOT NULL DEFAULT '0',
  `current_begin_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `refresh_unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`total_login_yesterday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for red_packet_list_data
-- ----------------------------
DROP TABLE IF EXISTS `red_packet_list_data`;
CREATE TABLE `red_packet_list_data` (
  `redpacket_serialid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `config_id` int(10) unsigned NOT NULL DEFAULT '0',
  `character_name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total_receiver_count` int(10) unsigned NOT NULL DEFAULT '0',
  `end_unixtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `receiver_info` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`redpacket_serialid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for user_packet_list_data
-- ----------------------------
DROP TABLE IF EXISTS `user_packet_list_data`;
CREATE TABLE `user_packet_list_data` (
  `characterid` bigint(20) unsigned NOT NULL,
  `receive_redpacket_count` int(20) unsigned NOT NULL DEFAULT '0',
  `refresh_count` int(20) unsigned NOT NULL DEFAULT '0',
  `interval_count` int(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for personal_red_packet_data
-- ----------------------------
DROP TABLE IF EXISTS `personal_red_packet_data`;
CREATE TABLE `personal_red_packet_data` (
  `redpacket_serialid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `currencyvalue` int(10) unsigned NOT NULL DEFAULT '0',
  `receive_unixtime` bigint(20) unsigned NOT NULL DEFAULT '0',
   PRIMARY KEY (`redpacket_serialid`, `characterid`),
   INDEX `characterid` (`characterid`),
   INDEX `redpacket_serialid` (`redpacket_serialid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for user_period_card
-- ----------------------------
DROP TABLE IF EXISTS `user_period_card`;
CREATE TABLE `user_period_card` (
  `characterid` bigint(20) unsigned NOT NULL,
  `config_card` int(10) unsigned NOT NULL DEFAULT '0',
  `buy_count` int(10) unsigned NOT NULL DEFAULT '0',
  `finish_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `last_reward_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`, `config_card`),
  INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sign_reward
-- ----------------------------
DROP TABLE IF EXISTS `sign_reward`;
CREATE TABLE `sign_reward` (
  `characterid` bigint(20) unsigned NOT NULL,
  `openflag` int(10) unsigned NOT NULL DEFAULT '0',
  `total_login_days` int(10) unsigned NOT NULL DEFAULT '0',
  `login_receive_status` int(10) unsigned NOT NULL DEFAULT '0',
  `activity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `recharge_value` int(10) unsigned NOT NULL DEFAULT '0',
  `receiver_info` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for user_earthdemon
-- ----------------------------
DROP TABLE IF EXISTS `user_earthdemon`;
CREATE TABLE `user_earthdemon` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`killnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`robnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`starnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`remindInfo` VARCHAR(1024) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`buffnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`filter_starnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for earthdemon
-- ----------------------------
DROP TABLE IF EXISTS `earthdemon`;
CREATE TABLE `earthdemon` (
	`max_star` INT(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for answer_system
-- ----------------------------
DROP TABLE IF EXISTS `answer_system`;
CREATE TABLE `answer_system` (
  `characterid` bigint(20) unsigned NOT NULL,
  `openflag` int(10) unsigned NOT NULL DEFAULT '0',
  `rank_no` int(10) unsigned NOT NULL DEFAULT '0',
  `rank_score` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_answer_toper
-- ----------------------------
DROP TABLE IF EXISTS `sys_answer_toper`;
CREATE TABLE `sys_answer_toper` (
  `characterid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `guildboss`;
CREATE TABLE `guildboss` (
  `guildid` int(20)  unsigned NOT NULL DEFAULT '0',
  `bossid` int(10) unsigned NOT NULL DEFAULT '0',
  `remainHp` bigint(20) unsigned NOT NULL DEFAULT '0',
  `flushtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `killtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `killer` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`, `bossid`),
  INDEX `guildid` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `dollmachine_record`;
CREATE TABLE `dollmachine_record` (
  `characterid` bigint(20) unsigned NOT NULL,
  `itemid` int(10) unsigned NOT NULL DEFAULT '0',
  `num` int(10) unsigned NOT NULL DEFAULT '0',
  `inserttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  INDEX `guildid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for recharge_dayup_activity
-- ----------------------------
DROP TABLE IF EXISTS `recharge_dayup_activity`;
CREATE TABLE `recharge_dayup_activity` (
  `characterid` bigint(20) unsigned NOT NULL,
  `recharge` int(10) unsigned NOT NULL DEFAULT '0',
  `receivestatus` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_recharge_dayup
-- ----------------------------
DROP TABLE IF EXISTS `sys_recharge_dayup`;
CREATE TABLE `sys_recharge_dayup` (
  `groupid` int(10) signed NOT NULL DEFAULT '0',
  `unixtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for climb_tower
-- ----------------------------
DROP TABLE IF EXISTS `climb_tower`;
CREATE TABLE `climb_tower` (
  `characterid` bigint(20) unsigned NOT NULL,
  `type` int(10) signed NOT NULL DEFAULT '0',
  `layer` int(10) unsigned NOT NULL DEFAULT '0',
  `updatetime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for user_worldexp_add
-- ----------------------------
DROP TABLE IF EXISTS `user_worldexp_add`;
CREATE TABLE `user_worldexp_add` (
  `characterid` bigint(20) unsigned NOT NULL,
  `receiveflag` int(10) signed NOT NULL DEFAULT '0',
  `worldexp_lv` int(10) unsigned NOT NULL DEFAULT '0',
  `function_open_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_worldexp_add
-- ----------------------------
DROP TABLE IF EXISTS `sys_worldexp_add`;
CREATE TABLE `sys_worldexp_add` (
  `average_lv` int(10) unsigned NOT NULL DEFAULT '0',
  `top_ranker` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`average_lv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for user_luckylottery
-- ----------------------------
DROP TABLE IF EXISTS `user_luckylottery`;
CREATE TABLE `user_luckylottery` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`lottery_type` INT(10) UNSIGNED NOT NULL DEFAULT '1',
	`goldmoney_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`emoney_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`score` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`has_emoney_ten` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`lottery1_extra` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`lottery2_extra` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`score_reward` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`lottery1_upper` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`lottery2_upper` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`free_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`lib_info` VARCHAR(1024) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `lottery_type`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- ----------------------------
-- Table structure for fashion
-- ----------------------------
DROP TABLE IF EXISTS `fashion`;
CREATE TABLE `fashion` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `active_fashionid` int(10) unsigned DEFAULT NULL,
  `fashioninfo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for user_teamcopy
-- ----------------------------
DROP TABLE IF EXISTS `user_teamcopy`;
CREATE TABLE `user_teamcopy` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`leftnum` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for poem
-- ----------------------------
DROP TABLE IF EXISTS `poem`;
CREATE TABLE `poem` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`openid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`qid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`status` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
	`updatetime`  BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for sys_area_rank_list
-- ----------------------------
DROP TABLE IF EXISTS `sys_area_rank_list`;
CREATE TABLE `sys_area_rank_list` (
    `rankno` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`rankno`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for user_area_rank
-- ----------------------------
DROP TABLE IF EXISTS `user_area_rank`;
CREATE TABLE `user_area_rank` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`open_flag` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`maxhighrank` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`challengecount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`once_buycount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`remain_challenge_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`all_challenge` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for challenge_area_rank_log
-- ----------------------------
DROP TABLE IF EXISTS `challenge_area_rank_log`;
CREATE TABLE `challenge_area_rank_log` (
    `serialid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`battle_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`win_result` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`challenge_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
	`old_rankno` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`new_rankno` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`battle_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`serialid`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `user_escort_car_list`
-- ----------------------------
DROP TABLE IF EXISTS `user_escort_car_list`;
CREATE TABLE `user_escort_car_list` (
  `autoserialid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_lv` int(10) unsigned NOT NULL DEFAULT '0',
  `character_lv` int(10) unsigned DEFAULT '0',
  `start_escort_sec` int(10) unsigned DEFAULT '0',
  `end_escort_unix_time` bigint(20) unsigned DEFAULT '0',
  `sucess_rob_log_list` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `fail_rob_log_list` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  PRIMARY KEY (`autoserialid`),
  INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `robot_escort_car`
-- ----------------------------
DROP TABLE IF EXISTS `robot_escort_car`;
CREATE TABLE `robot_escort_car` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `car_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_lv` int(10) unsigned NOT NULL DEFAULT '0',
  `escort_character_lv` int(10) unsigned DEFAULT '0',
  `start_escort_sec` int(10) unsigned DEFAULT '0',
  `end_escort_unix_time` bigint(20) unsigned DEFAULT '0',
  `is_robbed` int(10) unsigned DEFAULT '0',
  `fail_robbed_count` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`characterid`, `car_characterid`),
  INDEX `characterid` (`characterid`),
  INDEX `car_characterid` (`car_characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for `escort`
-- ----------------------------
DROP TABLE IF EXISTS `escort`;
CREATE TABLE `escort` (
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `openflag` int(10) unsigned NOT NULL DEFAULT '0',
  `escort_count` int(10) unsigned DEFAULT '0',
  `rob_count` int(10) unsigned DEFAULT '0',
  `carlev` int(10) unsigned DEFAULT '0',
  `lv_reward` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `sucess_rob_log_list` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  `fail_rob_log_list` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `escort_rob_log_list`
-- ----------------------------
DROP TABLE IF EXISTS `escort_rob_log_list`;
CREATE TABLE `escort_rob_log_list` (
  `autoserialid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `robtype` int(10) unsigned DEFAULT '0',
  `robbername` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carlev` int(10) unsigned DEFAULT '0',
  `resultvalue` int(10) unsigned DEFAULT '0',
  `record_unixtime` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`autoserialid`),
  INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `all_luckylottery_info`
-- ----------------------------
DROP TABLE IF EXISTS `all_luckylottery_info`;
CREATE TABLE `all_luckylottery_info` (
	`id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`ownerid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`lottery_type` INT(10) UNSIGNED NOT NULL DEFAULT '1',
	`itemid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `vip_free`
-- ----------------------------
DROP TABLE IF EXISTS `vip_free`;
CREATE TABLE `vip_free` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`total_exp` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`battle_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`upgrade_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `powerdouble`
-- ----------------------------
DROP TABLE IF EXISTS `powerdouble`;
CREATE TABLE `powerdouble` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`function_datetime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`receive_activity_list` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`mail_flag` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `teachtask`
-- ----------------------------
DROP TABLE IF EXISTS `teachtask`;
CREATE TABLE `teachtask` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`guide_task_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`guide_task_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`guide_task_battle_result` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`open_flag` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_total_daily` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`ring_progress` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_battle_result` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `questtypemgr`
-- ----------------------------
DROP TABLE IF EXISTS `questtypemgr`;
CREATE TABLE `questtypemgr` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`task_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `allcharactermail`
-- ----------------------------
DROP TABLE IF EXISTS `allcharactermail`;
CREATE TABLE `allcharactermail` (
  `mailid` bigint(20) unsigned NOT NULL,
  `time` bigint(20) unsigned NOT NULL,
  `textid` int(10) unsigned NOT NULL,
  `content` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `money` bigint(20) unsigned NOT NULL,
  `emoney` bigint(20) unsigned NOT NULL,
  `goldmoney` bigint(20) unsigned NOT NULL,
  `titile` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing0` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing1` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing2` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing3` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing4` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing5` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing6` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing7` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing8` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  `thing9` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`mailid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for `allcharactermailgetrecord`
-- ----------------------------
DROP TABLE IF EXISTS `allcharactermailgetrecord`;
CREATE TABLE `allcharactermailgetrecord` (
  `mailid` bigint(20) unsigned NOT NULL,
  `characterid` bigint(20) NOT NULL,
  PRIMARY KEY (`mailid`,`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `ringtask`
-- ----------------------------
DROP TABLE IF EXISTS `ringtask`;
CREATE TABLE `ringtask` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`is_guide_flag` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`task_battle_result` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_ring_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`buy_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`account_list` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for `server_limitbuy`
-- ----------------------------
DROP TABLE IF EXISTS `server_limitbuy`;
CREATE TABLE `server_limitbuy` (
    `cofiggroupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`starunixtime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`endunixtime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`rewardstatus` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`auto_add_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`auto_add_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`big_reward_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`cofiggroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for `limitbuy`
-- ----------------------------
DROP TABLE IF EXISTS `limitbuy`;
CREATE TABLE `limitbuy` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`buystatus` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for sealmonster
-- ----------------------------
DROP TABLE IF EXISTS `sealmonster`;
CREATE TABLE `sealmonster` (
  `characterid` bigint(20) unsigned NOT NULL,
  `challenge_count` int(10) unsigned zerofill NOT NULL,
  `last_config_lv` int(10) unsigned zerofill NOT NULL,
  `last_monster_no` int(10) unsigned zerofill NOT NULL,
  `current_config_lv` int(10) unsigned zerofill NOT NULL,
  `current_monster_no` int(10) unsigned zerofill NOT NULL,
  `can_mopup_list` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `three_first_impulse`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `three_first_impulse`;
CREATE TABLE `three_first_impulse` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`receivestatus` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`recharge_id_list` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `million_emoney_activity`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `million_emoney_activity`;
CREATE TABLE `million_emoney_activity` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`totalloginday` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_id_list` VARCHAR(1024) COLLATE utf8_unicode_ci NOT NULL,
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `sys_area_rank_top_data`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `sys_area_rank_top_data`;
CREATE TABLE `sys_area_rank_top_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`broadst_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `user_extra_formation`;
CREATE TABLE `user_extra_formation` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`formation_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`eudemon` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`partner_zf` VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`partner_jb` VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `formation_type`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `user_life_death`;
CREATE TABLE `user_life_death` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`atk_round` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`max_atk_round` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`max_atk_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`def_round` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`max_def_round` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`max_def_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `resolve_equip_reward`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `resolve_equip_reward`;
CREATE TABLE `resolve_equip_reward` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`fall_info`  VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`receive_list`  VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `server_preference_day`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `server_preference_day`;
CREATE TABLE `server_preference_day` (
	`current_matches_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`start_unix_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`end_unix_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`current_matches_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `preference_day`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `preference_day`;
CREATE TABLE `preference_day` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`current_matches_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`recharge_id_list` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `fortunecat`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `fortunecat`;
CREATE TABLE `fortunecat` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`recharge`  INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`multiple`  FLOAT(10) UNSIGNED NOT NULL DEFAULT '0',
	`updatetime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `seriesrc_activity`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `seriesrc_activity`;
CREATE TABLE `seriesrc_activity` (
	`activityid` INT(10) UNSIGNED NOT NULL,
	`begintime`  BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`endtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`activityid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `user_seriesrc`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_seriesrc`;
CREATE TABLE `user_seriesrc` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL,
	`activityid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`rechargeday`  VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`cost` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`reward`  VARCHAR(256) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`final_reward` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`today_recharge` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`rechargeflag` INT(10) UNSIGNED NOT NULL DEFAULT '0',	
	`updatetime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `user_competition`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_competition`;
CREATE TABLE `user_competition` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`curScore` INT(10) NOT NULL DEFAULT '0',
	`curWin` INT(10) NOT NULL DEFAULT '0',
	`curFight` INT(10) NOT NULL DEFAULT '0',
	`curWinSeries` INT(10) NOT NULL DEFAULT '0',
	`curFailSeries` INT(10) NOT NULL DEFAULT '0',
	`reward` INT(10) NOT NULL DEFAULT '0',
	`totalScore` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`totalWin` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`totalFight` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `user_arrest_pet`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_arrest_pet`;
CREATE TABLE `user_arrest_pet` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`current_arrest_info` VARCHAR(128) COLLATE utf8_unicode_ci NOT NULL,
	`first_arrest_flag` INT(10) NOT NULL DEFAULT '0',
	`arrest_count` INT(10) NOT NULL DEFAULT '0',
	`last_arrest_unixtime` BIGINT(20) NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `platform_vip`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `platform_vip`;
CREATE TABLE `platform_vip` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`reward_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`reward_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `reward_id`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `pt_vip_gift`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `pt_vip_gift`;
CREATE TABLE `pt_vip_gift` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`reward_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`reward_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `user_officialdom`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_officialdom`;
CREATE TABLE `user_officialdom` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`officer_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`officer_lv` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`officer_star` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_salary_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`meet_daily` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`be_meet_currency_total` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`meet_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`meet_answer_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`be_meet_characterid` BIGINT(10) UNSIGNED NOT NULL DEFAULT '0',
	`meet_character_list` VARCHAR(256) COLLATE utf8_unicode_ci DEFAULT NULL,
	`complete_ring_daily` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`accept_task_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`task_list` VARCHAR(64) COLLATE utf8_unicode_ci DEFAULT NULL,
	`complete_task_list` VARCHAR(64) COLLATE utf8_unicode_ci DEFAULT NULL,
	`fail_task_list` VARCHAR(64) COLLATE utf8_unicode_ci DEFAULT NULL,
	`current_task_data` VARCHAR(128) COLLATE utf8_unicode_ci DEFAULT NULL,
	`config_task_des_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `officer_type`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `treasure_map_quest`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `treasure_map_quest`;
CREATE TABLE `treasure_map_quest` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`current_lucky_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`completed_task_count` INT(10) NOT NULL DEFAULT '0',
	`buy_task_count` INT(10) NOT NULL DEFAULT '0',
	`dig_treasure_count` INT(10) NOT NULL DEFAULT '0',
	`receive_quest_lv` INT(10) NOT NULL DEFAULT '0',
	`config_task_id` INT(10) NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `star_plate_data`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `star_plate_data`;
CREATE TABLE `star_plate_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`plate_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`star_lv_list` VARCHAR(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
	PRIMARY KEY (`characterid`, `plate_type`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `user_picture`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_picture`;
CREATE TABLE `user_picture` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`characterId` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`pictureId` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`lev` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `characterId_pictureId` (`characterId`, `pictureId`),
	INDEX `characterId` (`characterId`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `zero_buy_activity`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `zero_buy_activity`;
CREATE TABLE `zero_buy_activity` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`day_id_list` VARCHAR(256) COLLATE utf8_unicode_ci DEFAULT NULL,
	`receive_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`open_function_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `double_active_activity`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `double_active_activity`;
CREATE TABLE `double_active_activity` (
	`double_active_id_list` VARCHAR(1024) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- --------------------------------------------------------
-- Table structure for `combine_system_data`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `combine_system_data`;
CREATE TABLE `combine_system_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`combind_data_list` VARCHAR(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `user_strongest_vote`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_strongest_vote`;
CREATE TABLE `user_strongest_vote` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`vote_info` VARCHAR(1024) NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`total_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`today_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `characterid` (`characterid`),
	INDEX `groupid` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `strongest_vote_info`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `strongest_vote_info`;
CREATE TABLE `strongest_vote_info` (
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`all_vote_info` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`win_vote_info` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `brings_info`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `brings_info`;
CREATE TABLE `brings_info` (
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`pool_emoney` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `user_brings`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_brings`;
CREATE TABLE `user_brings` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`gift_info` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`lottery_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `characterid` (`characterid`),
	INDEX `groupid` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `big_gift_data`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `big_gift_data`;
CREATE TABLE `big_gift_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`login_unixtime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`receive_gift_list` VARCHAR(1024) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `user_login_gift`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_login_gift`;
CREATE TABLE `user_login_gift` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`loginday` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`recordTime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`status` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `characterid` (`characterid`),
	INDEX `groupid` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `to_be_stronger`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `to_be_stronger`;
CREATE TABLE `to_be_stronger` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`total_score_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_box_list` VARCHAR(64) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
    `complete_way_info` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `single_recharge_activity`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `single_recharge_activity`;
CREATE TABLE `single_recharge_activity` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_day_index` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`recharge_value_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
    `receive_value_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `character_index` (`characterid`),
	INDEX `group_index` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `repeated_discount`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `repeated_discount`;
CREATE TABLE `repeated_discount` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`activity_keep_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
    `zero_reset_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`limit_clear_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `character_index` (`characterid`),
	INDEX `group_index` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `festival_consume_data`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `festival_consume_data`;
CREATE TABLE `festival_consume_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_day_index` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_consume_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `receive_value_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `character_index` (`characterid`),
	INDEX `group_index` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- --------------------------------------------------------
-- Table structure for `festival_recharge_data`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `festival_recharge_data`;
CREATE TABLE `festival_recharge_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_day_index` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_recharge_rmb` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `receive_value_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `character_index` (`characterid`),
	INDEX `group_index` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `user_peach_activity`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_peach_activity`;
CREATE TABLE `user_peach_activity` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`eat_daily_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `sys_peach_activity`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `sys_peach_activity`;
CREATE TABLE `sys_peach_activity` (
    `record_unix_time` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`peach_world_lv` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`record_unix_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `recharge_rebate`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `recharge_rebate`;
CREATE TABLE `recharge_rebate` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`rebate_day_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_day_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_recharge_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `receive_value_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `festival_turntable_data`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `festival_turntable_data`;
CREATE TABLE `festival_turntable_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`current_bring_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_id_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`total_recharge_rmb` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`today_recharge_rmb` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `total_consume_emoney` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`today_consume_emoney` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_online_minutes` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`today_online_minutes` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `character_index` (`characterid`),
	INDEX `group_index` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `activitycommon`
--
DROP TABLE IF EXISTS `activitycommon`;
CREATE TABLE `activitycommon` (
  `characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`gift_sworn_brother_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`gardon_free_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `be_sworn_brother`
--
DROP TABLE IF EXISTS `be_sworn_brother`;
CREATE TABLE `be_sworn_brother` (
   `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `config_type_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
   `config_card_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
   `card_lv_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
   `initmacy_value` INT(10) UNSIGNED NOT NULL DEFAULT '0',
   `receive_reward_lv` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    PRIMARY KEY (`characterid`, `config_type_id`, `config_card_id`),
	INDEX `character_index` (`characterid`),
	INDEX `type_index` (`config_type_id`),
	INDEX `card_index` (`config_card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `apply_to_be_lover`
--
DROP TABLE IF EXISTS `apply_to_be_lover`;
CREATE TABLE `apply_to_be_lover` (
   `confirm_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `apply_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`confirm_characterid`, `apply_characterid`),
	INDEX `confirm_index` (`confirm_characterid`),
	INDEX `apply_index` (`apply_characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `lover_couple_data`
--
DROP TABLE IF EXISTS `lover_couple_data`;
CREATE TABLE `lover_couple_data` (
   `couple_serial_id` bigint(20) unsigned NOT NULL DEFAULT '0',
   `status_flag` int(10) unsigned NOT NULL DEFAULT '0',
   `boy_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `girl_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `love_value` int(10) unsigned NOT NULL DEFAULT '0',
   `couple_task_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `boy_task_progress` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `girl_task_progress` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `album_day` int(10) unsigned NOT NULL DEFAULT '0',
   `album_unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
   `unix_time` bigint(20) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`couple_serial_id`),
	INDEX `boy_index` (`boy_characterid`),
	INDEX `girl_index` (`girl_characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



--
-- Table structure for table `marrage_system_data`
--
DROP TABLE IF EXISTS `marrage_system_data`;
CREATE TABLE `marrage_system_data` (
   `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `status_value` int(10) unsigned NOT NULL DEFAULT '0',
   `target_characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `love_interaction_event` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `develop_level` int(10) unsigned NOT NULL DEFAULT '0',
   `develop_exp` int(10) unsigned NOT NULL DEFAULT '0',
   `marry_interaction_level` int(10) unsigned NOT NULL DEFAULT '0',
   `marry_interaction_exp` int(10) unsigned NOT NULL DEFAULT '0',
   `marry_interaction_event` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `last_divorce_unixtime` int(10) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `marry_notice_event`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `marry_notice_event`;
CREATE TABLE `marry_notice_event` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`target_characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`event_type` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `character_index` (`characterid`),
	INDEX `target_index` (`target_characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `climb_tower_compensate`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `climb_tower_compensate`;
CREATE TABLE `climb_tower_compensate` (
   `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `init_layer` int(10) unsigned NOT NULL DEFAULT '0',
   `init_combat` bigint(20) unsigned NOT NULL DEFAULT '0',
   `receive_flag` int(10) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `limitbuy_loglist`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `limitbuy_loglist`;
CREATE TABLE `limitbuy_loglist` (
   `id` int(10) unsigned NOT NULL DEFAULT '0',
   `big_reward_unixtime` int(10) unsigned NOT NULL DEFAULT '0',
   `character_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
   `item_config_id` int(20) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `limitbuy_characterlist`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `limitbuy_characterlist`;
CREATE TABLE `limitbuy_characterlist` (
   `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `user_smart_pet_copy`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `user_smart_pet_copy`;
CREATE TABLE `user_smart_pet_copy` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`config_groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`success_round` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`user_property_back` VARCHAR(2048) NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
    PRIMARY KEY (`characterid`, `config_groupid`),
	INDEX `character_index` (`characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `mystical_shop_list`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `mystical_shop_list`;
CREATE TABLE `mystical_shop_list` (
   `characterid` bigint(20) unsigned NOT NULL DEFAULT '0',
   `config_groupid`  int(10) unsigned NOT NULL DEFAULT '0',
   `refresh_daily`  int(10) unsigned NOT NULL DEFAULT '0',
   `shop_data_list` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
   `buy_shop_info`  VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
    PRIMARY KEY (`characterid`, `config_groupid`),
	INDEX `character_index` (`characterid`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for festival_luckylottery
-- ----------------------------
DROP TABLE IF EXISTS `festival_luckylottery`;
CREATE TABLE `festival_luckylottery` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`complete_first_emoney_ten` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`score` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`receive_score_list` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`replace_lib_info` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`currency_draw_count` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`currency_drawed_id_list` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`type_free_time` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `groupid`),
	INDEX `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `festival_luckylottery_info`
-- ----------------------------
DROP TABLE IF EXISTS `festival_luckylottery_info`;
CREATE TABLE `festival_luckylottery_info` (
	`id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`groupid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`ownerid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`ownername` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
	`itemid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`record_time` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- ----------------------------
-- Table structure for `vip_fuben_data`
-- ----------------------------
DROP TABLE IF EXISTS `vip_fuben_data`;
CREATE TABLE `vip_fuben_data` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`fuben_challenge_info` VARCHAR(512) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`viplv` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`completed_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_challenge_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




-- ----------------------------
-- Table structure for `user_eudemon_gardon`
-- ----------------------------
DROP TABLE IF EXISTS `user_eudemon_gardon`;
CREATE TABLE `user_eudemon_gardon` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`pos` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`eudemonType` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`jyId` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`endTime` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`nextInterval` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`reward` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`eudemonExp` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `meridians`
-- ----------------------------
DROP TABLE IF EXISTS `meridians`;
CREATE TABLE `meridians` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`meridians_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`meridians_lv` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`meridians_exp` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `function_goal_list`
-- ----------------------------
DROP TABLE IF EXISTS `function_goal_list`;
CREATE TABLE `function_goal_list` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`group_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`received_goalid_list` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`characterid`, `group_id`),
	INDEX `character_index` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- Table structure for `repay_gift_list`
-- --------------------------------------------------------
-- --------------------------------------------------------
DROP TABLE IF EXISTS `repay_gift_list`;
CREATE TABLE `repay_gift_list` (
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`class_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `total_buy_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_receive_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`characterid`, `class_id`),
	INDEX `character_index` (`characterid`),
	INDEX `class_index` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


