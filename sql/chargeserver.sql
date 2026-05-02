-- ----------------------------
-- Table structure for charge_ws
-- ----------------------------
DROP TABLE IF EXISTS `charge_ws`;
CREATE TABLE `charge_ws` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`billno` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`billnoapp` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`chargetime` DATETIME NULL DEFAULT NULL,
	`serverid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`characterid` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`account` CHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`productid` INT(10) UNSIGNED NOT NULL,
	`money` DECIMAL(10,2) UNSIGNED NOT NULL,
	`platform` CHAR(16) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`ip` CHAR(16) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	`status` INT(10) UNSIGNED NOT NULL,
	`qq_open_key` VARCHAR(128) NOT NULL DEFAULT '' COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`id`),
	INDEX `character` (`serverid`, `characterid`, `status`),
	INDEX `account` (`serverid`, `account`, `status`),
	INDEX `order` (`billno`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for charge_tencent
-- ----------------------------
DROP TABLE IF EXISTS `charge_tencent`;
CREATE TABLE `charge_tencent` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `billno` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `chargetime` datetime DEFAULT NULL,
  `gameserverid` int(10) unsigned NOT NULL DEFAULT '0',
  `characterid` int(10) unsigned NOT NULL DEFAULT '0',
  `openid` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `goodsid` int(10) unsigned NOT NULL,
  `goodsnum` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL, 
  `valid` int(10) unsigned NOT NULL,
  `amt` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `payamt_coins` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `pubacct_payamt_coins` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
  , KEY `character` (`gameserverid`,`characterid`,`status`,`valid`)
  , KEY `account` (`gameserverid`,`openid`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

-- ----------------------------
-- Procedure structure for WS_SP_EXCHANGE_CDKEY
-- ----------------------------
DROP PROCEDURE IF EXISTS `WS_SP_EXCHANGE_CDKEY`;
DELIMITER ;;
CREATE PROCEDURE `WS_SP_EXCHANGE_CDKEY`(IN `para_cdkey` char(32), IN `para_characterid` bigint)
label_pro : begin
	declare character_time_limit int DEFAULT 0;
	declare server_time_limit int DEFAULT 0;
	declare character_time_current int DEFAULT 0;
	declare server_time_current int DEFAULT 0;
	declare cdkey_auto_id bigint DEFAULT 0;
	declare character_cdkey_typeid int DEFAULT 0;
	declare reward char(255) DEFAULT "";
	declare cdkey_repeat int DEFAULT 0;
	declare character_use_count int DEFAULT 0;

	select k.auto_id, k.typeid, p.time, p.alltime, p.alltime_current, p.item, p.repeat from newcdkey as k left join newcdkey_platform as p on k.typeid = p.typeid where k.cdkey = para_cdkey
		into cdkey_auto_id, character_cdkey_typeid, character_time_limit, server_time_limit, server_time_current, reward, cdkey_repeat;

    select count(*) into character_use_count from newcdkey_character where cdkey_id = cdkey_auto_id and para_characterid=character_id;
	if server_time_limit <> -1 and server_time_current + 1 > server_time_limit then
	    if character_use_count =0 then
		   select 1,  "";
		else
		   select 3,  "";
		end if;
		leave label_pro;
	end if;

	select count(auto_id) from newcdkey_character where character_id = para_characterid and cdkey_typeid =  character_cdkey_typeid into character_time_current;
	if character_time_limit <> -1 and character_time_current +  1 > character_time_limit then
	    if character_use_count =0 then
		   select 2,  "";
		else 
		   select 3,  "";
		end if;
		leave label_pro;
	end if;
	
	if 0 = cdkey_repeat then
		if exists (select 1 from newcdkey_character where cdkey_id = cdkey_auto_id) then
			select 3,  "";
			leave label_pro;
		end if;
	end if;

	insert into newcdkey_character(cdkey_id,cdkey_typeid, character_id) values (cdkey_auto_id, character_cdkey_typeid, para_characterid);
	update newcdkey_platform set alltime_current = alltime_current + 1 where typeid = character_cdkey_typeid;

	select 0,  reward;
end;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for WS_SP_SELECT_CDKEY_CONFIG
-- ----------------------------
DROP PROCEDURE IF EXISTS `WS_SP_SELECT_CDKEY_CONFIG`;
DELIMITER ;;
CREATE PROCEDURE `WS_SP_SELECT_CDKEY_CONFIG`(IN `para_cdkey` char(32))
begin
	select k.cdkey,  p.servernum, p.start, p.end from newcdkey as k, newcdkey_platform as p  where k.cdkey = para_cdkey and  k.typeid = p.typeid;
end;;
DELIMITER ;

-- ----------------------------
-- Table structure for newcdkey
-- ----------------------------
DROP TABLE IF EXISTS `newcdkey`;
CREATE TABLE `newcdkey` (
  `auto_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cdkey` char(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `typeid` int(10) NOT NULL,
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `cdkey` (`cdkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for newcdkey_character
-- ----------------------------
DROP TABLE IF EXISTS `newcdkey_character`;
CREATE TABLE `newcdkey_character` (
  `auto_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cdkey_id` bigint(20) unsigned NOT NULL,
  `cdkey_typeid` int(10) NOT NULL,
  `character_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`auto_id`),
  KEY `character_cdkey` (`cdkey_typeid`,`character_id`),
  KEY `cdkey` (`cdkey_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for newcdkey_platform
-- ----------------------------
DROP TABLE IF EXISTS `newcdkey_platform`;
CREATE TABLE `newcdkey_platform` (
  `typeid` int(10) NOT NULL AUTO_INCREMENT,
  `name` char(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time` int(10) NOT NULL,
  `alltime` int(10) NOT NULL,
  `servernum` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `start` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `end` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `item` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `alltime_current` int(10) unsigned NOT NULL DEFAULT '0',
  `repeat` int(10) NOT NULL,
  PRIMARY KEY (`typeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
set names utf8;

DROP PROCEDURE IF EXISTS `WS_SP_EXCHANGE_CDKEY`;
DELIMITER ;;
CREATE PROCEDURE `WS_SP_EXCHANGE_CDKEY`(IN `para_cdkey` char(32), IN `para_characterid` bigint)
label_pro : begin
	declare character_time_limit int DEFAULT 0;
	declare server_time_limit int DEFAULT 0;
	declare character_time_current int DEFAULT 0;
	declare server_time_current int DEFAULT 0;
	declare cdkey_auto_id bigint DEFAULT 0;
	declare character_cdkey_typeid int DEFAULT 0;
	declare reward char(255) DEFAULT "";
	declare cdkey_repeat int DEFAULT 0;
	declare character_use_count int DEFAULT 0;

	select k.auto_id, k.typeid, p.time, p.alltime, p.alltime_current, p.item, p.repeat from newcdkey as k left join newcdkey_platform as p on k.typeid = p.typeid where k.cdkey = para_cdkey
		into cdkey_auto_id, character_cdkey_typeid, character_time_limit, server_time_limit, server_time_current, reward, cdkey_repeat;

    select count(*) into character_use_count from newcdkey_character where cdkey_id = cdkey_auto_id and para_characterid=character_id;
	if server_time_limit <> -1 and server_time_current + 1 > server_time_limit then
	    if character_use_count =0 then
		   select 1,  "";
		else
		   select 3,  "";
		end if;
		leave label_pro;
	end if;

	select count(auto_id) from newcdkey_character where character_id = para_characterid and cdkey_typeid =  character_cdkey_typeid into character_time_current;
	if character_time_limit <> -1 and character_time_current +  1 > character_time_limit then
	    if character_use_count =0 then
		   select 2,  "";
		else 
		   select 3,  "";
		end if;
		leave label_pro;
	end if;
	
	if 0 = cdkey_repeat then
		if exists (select 1 from newcdkey_character where cdkey_id = cdkey_auto_id) then
			select 3,  "";
			leave label_pro;
		end if;
	end if;

	insert into newcdkey_character(cdkey_id,cdkey_typeid, character_id) values (cdkey_auto_id, character_cdkey_typeid, para_characterid);
	update newcdkey_platform set alltime_current = alltime_current + 1 where typeid = character_cdkey_typeid;

	select 0,  reward;
end;;
DELIMITER ;
