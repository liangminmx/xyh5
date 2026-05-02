-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////// 以下是 c++ 部分过来的 资源流type
-- ////////////// 在发放奖励的时候会用到
-- /////////////////////////////////////////////////////////////////////////////////
CRESOURCEFLOWACTION = {
	eFT_OfflineExp_Exp = 30,				-- 离线经验
	eFT_FirstCharge = 46 ,			--首次充值
	eFT_EMoneyBackBuy = 57,			-- 月卡购买
	eFT_EMoneyBackGet = 58,			-- 月卡领取
	eFT_FestivalLogin = 60,			-- 节日登录活动	
	eFT_CloudBuyOpenServer = 68,	-- 开服云购
	eFT_NewguildGift = 69,			 	-- 等级新手礼包
	eFT_CombineseActivity = 77,		-- 合服活动，首任领主
	eFT_EightDayActivity = 80,			-- 8天冲榜
	eFT_OpenAdvanceDay = 80,			-- 开服进阶返利 沿用8天冲榜
	eFT_ActivityVipNum = 83,			-- 全民反馈（vipNum 数量反馈）
	eFT_JSXFGetKing = 99,				-- 记氏西府，城主奖励(首任领主)
	eFT_JSXFGetMem = 100,				-- 记氏西府，成员奖励(首任领主)
	eFI_LevelActivityLevelReward = 102,	-- 开服活动，冲级比赛
	eFT_OpenOnLine = 103,				-- 开服活动 在线就送
	eFT_openFBMaster = 107,				-- 开服活动 副本达人	
	eFT_FestivalConsume = 125,			-- 节日消费
	eFT_BossIntegral = 126,			--BOSS杀手
	eFT_NewguildAward = 130,		--功能预告  境界领奖
	eFT_OnlineReward = 154,				-- 在线奖励
	eFT_MonthSign = 155,					--每日签到
	eFT_SecretMission = 404,		--神秘任务
	eFT_DoubleGold = 407,			--元宝翻倍
	eFT_AdventureMap  = 410,		--寻宝奇遇	
    eFT_GeteMoeny_OnLine = 415,     -- 元宝免费送，在线免费获得元宝
    eFT_GeteMoeny_Active = 416,     -- 元宝免费送，活跃度获得元宝
    eFT_GeteMoeny_Boss = 417,       -- 元宝免费送，击杀boss获得元宝    
    eFT_jjGift_Mounts = 426,        -- 进阶豪礼 - 坐骑
    eFT_jjGift_Wing = 427,          -- 进阶豪礼 - 羽翼       
    eFT_jjGift_Treasure = 428,      -- 进阶豪礼 - 法宝
	eFT_jjGift_Weapon = 432,        -- 进阶豪礼 - 神兵
    eFT_charge_rebate = 433,        -- 连充返利
    eFT_jjGift_Cloak = 444,         -- 进阶豪礼 - 披风
    eFT_jjGift_Circle = 449,        -- 进阶豪礼 - 法阵
	eFT_AdventureMap_DirctGet = 500,-- 寻宝奇遇	直接领奖
    eFT_KaiFuChouJiang_GetTimes = 507, -- 开服抽奖，充值获得次数
    eFT_KaiFuChouJiang_GetReward = 508,-- 开服抽奖，获得物品流向
    eFT_KaiFuChouJiang_Exchange = 509, -- 开服抽奖，兑换
    eFT_KaiFuChouJiang_Single = 510,-- 开服抽奖，单次抽奖消耗
    eFT_KaiFuChouJiang_Ten =    511,-- 开服抽奖，十次抽奖消耗
    eFT_Pokedex = 600,              -- 图鉴任务，完成
    eFT_Pokedex_Extra = 601,        -- 图鉴任务，全部完成的奖励
	eFT_XianShiTeHui = 644,			-- 限时特惠
	eFT_XingYunJingCai_Buy 	 = 645,	--幸运竞猜  购买
	eFT_XingYunJingCai_Award = 646,	--幸运竞猜	奖励
	eFT_ChongJiBiPin = 649,			--冲级比拼
	eFT_ZhengDuoXiaDu = 650,		--争夺夏都
	eFT_PaiMai_Item = 700,			--每日拍卖会 获得道具
	eFT_PaiMai_Emoney = 701,		--每日拍卖会 消费元宝
    eFT_RichWelfare = 930,          -- 土豪福利
	eFT_Kaifujijin = 932,           -- 开服基金 新
	eFT_OpenServiceFund = 1003,		-- 开服基金	
	eFT_KaiFuTouZi	= 1004,			-- 开服投资
	eFT_SevenLogin = 1026,				-- 7日登录
	eFT_ChargeAward = 1031,			-- 充值送好礼
	eFT_Teamrecharge = 1050,			-- 首充团购
	eFT_EMoneyBackBuyAll = 1149,	--购买所有月卡  
	
	-- id 从1万开始，为脚本自己使用的ID
	eFT_ConsumeDiscount = 10001,	-- 消费折扣
    eFT_GeteMoeny = 10002,          -- 元宝免费C+++调用脚本流向id
    eFT_jjGift = 10003,             -- 进阶送豪礼C+++调用脚本流向id
    eFT_charge_rebate_sign = 10004, -- 连充返利的奖励记录
    eFT_charge_rebate_days = 10005, -- 连充返利的充值达成天数的记录

    eFt_KaiFuChouJiang_Play = 10006,    -- 开服抽奖，配置的活动
    eFt_KaiFuChouJiang_Gm = 10007,      -- 开服抽奖，GM开启的活动
    eFt_KaiFuChouJiang_Play_Sign = 10008,-- 开服抽奖，配置的活动,配合记录
    eFt_KaiFuChouJiang_Gm_Sign = 10009,-- 开服抽奖，GM 配置的活动,配合记录

    eFT_RichWelfare_Instance = 10010,   -- 土豪福利的全服 全局掩码id
	eFT_FirstCharge_New = 10011,		-- 首次充值新的数据
	eFT_AdventureMap_Time = 10012,		-- 处理完成次数相关
	eFT_EMoneyBackBuyTimes = 10013,		-- 月卡购买次数
	eFT_MarrayActive	 = 10014,		-- 结婚活动
    eFT_FestivalMonster	 = 10015,		-- GM 的刷怪活动
	eFT_FestivalWeb	 = 10016,			-- 节日运营活动


}

-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////// 以下是 活动 在 Lua 中使用掩码存储时候的，活动id
-- ////////////// 即是_idActivity
-- ////////////// 活动的 id 从 100000（十万）开始
-- /////////////////////////////////////////////////////////////////////////////////
LUARESOURCEFLOWACTION = {}

LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_OfflineExp_Exp]	= 100030 		-- 离线经验
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FirstCharge]	= 100046 			-- 首次充值
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackBuy]	= 100057 		-- 月卡购买
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackGet]	= 100058 		-- 月卡领取
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FestivalLogin]	=  100060 		-- 节日登录活动
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_CloudBuyOpenServer]	= 100068 	-- 等级新手礼包
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_NewguildGift]	= 100069 			-- 等级新手礼包
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_JSXFGetKing]	= 100099 	-- 合服活动，首任领主
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EightDayActivity]	= 100080 		-- 8天冲榜
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_OpenAdvanceDay]	= 100080 		-- 开服进阶返利 沿用8天冲榜
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_ActivityVipNum] = 100083			-- 全民反馈（vipNum 数量反馈）
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFI_LevelActivityLevelReward]  = 100102	-- 开服活动，冲级比赛	
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_OpenOnLine]  = 100103				-- 开服活动 在线就送
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_openFBMaster] = 100107		-- 节日副本达人
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FestivalConsume] = 100125		-- 节日消费
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_BossIntegral]  = 100126				--BOSS杀手
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_OnlineReward]	= 100154 			-- 在线奖励
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_MonthSign]  = 100155				-- 每日签到
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_SecretMission] = 100404			--神秘任务
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_DoubleGold] = 100407			--元宝翻倍
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_AdventureMap] = 100410			--寻宝奇遇
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_GeteMoeny_OnLine] = 100415	    --元宝免费送，在线免费获得元宝
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_GeteMoeny_Active] = 100416		--元宝免费送，活跃度获得元宝
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_GeteMoeny_Boss] = 100417			--元宝免费送，击杀boss获得元宝
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Mounts] = 100426		-- 进阶豪礼 - 坐骑
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Wing] = 100427		    -- 进阶豪礼 - 羽翼
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Treasure] = 100428		-- 进阶豪礼 - 法宝
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Weapon] = 100432		-- 进阶豪礼 - 神兵
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_charge_rebate] = 100433		-- 连充返利
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Cloak] = 100444		-- 进阶豪礼 - 披风
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift_Circle] = 100449		-- 进阶豪礼 - 法阵
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_AdventureMap_DirctGet] = 100500	-- 寻宝奇遇	直接领奖
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_XingYunJingCai_Buy] = 100645	-- 幸运竞猜 发奖
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_XianShiTeHui]	= 100644		-- 限时特惠
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_ChongJiBiPin]	= 100649		-- 冲级比拼
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_ZhengDuoXiaDu] = 100650		-- 争夺夏都
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_PaiMai_Item]	= 100700		--每日拍卖会 获得道具
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_PaiMai_Emoney]	= 100701		--每日拍卖会 消费元宝
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_RichWelfare] = 100930	-- 土豪福利
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_Kaifujijin] = 100932	-- 开服基金 新
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_OpenServiceFund] = 101003		-- 开服基金
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_KaiFuTouZi] = 101004		-- 开服投资	
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_SevenLogin]  = 101026				-- 7日登录
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_ChargeAward]  = 101031			-- 充值送好礼
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_Teamrecharge]  = 101050			-- 首充团购
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_ConsumeDiscount]  = 1010001	-- 消费折扣
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_GeteMoeny]  = 1010002	        -- 元宝免费C+++调用脚本流向id
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_jjGift]  = 1010003	        -- 进阶送豪礼C+++调用脚本流向id
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_charge_rebate_sign]  = 1010004-- 连充返利的奖励记录
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_charge_rebate_days]  = 1010005-- 连充返利的充值达成天数的记录
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play]  =		 1010006   -- 开服抽奖，配置的活动
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Gm]  =			 1010007     -- 开服抽奖，GM开启的活动
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play_Sign]  =	 1010008  -- 开服抽奖，配置的活动,配合记录
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Gm_Sign]  = 	 1010009  -- GM 抽奖，配置的活动,配合记录
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_RichWelfare_Instance]  =  	 1010010 -- 土豪福利的全服 全局掩码id
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FirstCharge_New]			= 	 1010011 -- 首次充值新的数据
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_AdventureMap_Time]		= 	 1010012 -- 处理完成次数相关
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackBuyTimes]		= 	 1010013 -- 月卡购买次数
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FestivalMonster]		    = 	 1010015 -- GM 的刷怪活动
LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FestivalWeb]		  		= 	 1010016 -- 节日运营活动



-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////// 以下是 給c++部分，看到在lua中对应的LuaIdActivity的
-- /////////////////////////////////////////////////////////////////////////////////
function C2L_OnGetAcitveTempId(_nCActionType)
	return LUARESOURCEFLOWACTION[_nCActionType] or 0
end

-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////// 以下是事件触发器
-- /////////////////////////////////////////////////////////////////////////////////
eActionTriggerType = {
	-- 开服活动 副本达人 活动 == 开始
	eFBT_LifeOrDeath = 1,		-- 已经通过一次		超凡生死战
	eFBT_ClimbRoad = 2,		-- 已经通过一次		登山路
	eFBT_Single = 3,				-- 已经通过一次		单人副本
	eFBT_Equipment = 4,		-- 已经通过一次		装备副本
	eFBT_SecretHouse = 5,	-- 已经通过一次		百战密室
    -- 开服活动 副本达人 活动 == 结束

	eATT_GetEmoney = 6,     -- 元宝免费送
    
    eATT_Horse_Steplev		=  7,	-- 坐骑升级 data3:oldlevel,data4:newlevel
	eATT_Wing_Realm			=  8,	-- 羽翼升级
	eATT_LegendaryWeapon	=  9,	-- 神兵升级
	eATT_Heaven_Level		= 10,	-- 法宝升级
	eATT_Poncho_Level		= 11,	-- 披风升级
	eATT_Matrix_Level		= 12,	-- 法阵升级
        
}
-- /////////////////////////////////////////////////////////////////////////////////
-- //////////////  跨服GlobalData操作类型
-- /////////////////////////////////////////////////////////////////////////////////
eCrossGlobbalActionType = {
	ChouJiBiPin_Syn = 1,		--冲级比拼同步信息	
	ChouJiBiPin_GetReward = 2,	--冲级比拼领取查询	
	ChouJiBiPin_Record = 3,		--冲级比拼领取领取后记录
	__PaiMai_SynInfo = 4,		--每日拍卖
	__PaiMai_Offer = 5,			--拍卖出价
	__PaiMai_EndInfo = 6,		--拍卖结算信息
	__PaiMai_Windows = 16,		--拍卖弹窗
	Teamrecharge_GetServerTotalNumToAll = 7,	--首充团购::某一玩家达成团购条件，发送全服团购人数给所有玩家
	Teamrecharge_GetServerTotalNumToOne = 8,	--首充团购::发送某一玩家信息给客戶端
	Teamrecharge_GetReward = 9,				--首充团购::领取奖励
	Teamrecharge_Restart = 10,		--首充团购::重置数据
	Teamrecharge_GetInfo = 11,		--首充团购::获得全服人数信息
	ChouJiang_Refresh = 12,			--开服抽奖::刷新个人活动信息
	ChouJiang_IconShow = 13,		--开服抽奖::同步图标信息
	GM_ChouJiang_Refresh = 14,			--开服抽奖GM::刷新个人活动信息
	GM_ChouJiang_IconShow = 15,		--开服抽奖GM::同步图标信息
}

