CHARACTER_INT = {
	LEVEL = 0,
	HORSE_STEPLEV 				= 1,	--//坐骑等级
	MAID_REALM 					= 2,
	MAID_STAGEID 				= 3,
	PUPPET_REALM 				= 4,
	PUPPET_STAGEID 				= 5,
	WING_REALM 					= 6,	--//羽翼等级
	REFINE_REALM 				= 7,
	REFINE_STAGEID				= 8,
	STAMP_REALM 				= 9,
	STAMP_STAGEID 				= 10,
	TALISMAN_REALM 				= 11,
	TALISMAN_STAGEID 			= 12,
	MUSE_REALM 					= 13,
	MUSE_STAGEID 				= 14,
	GODDESSFIGURE_REALM 		= 15,
	GODDESSFIGURE_STAGEID		= 16,
	CHARACTER_REALM 			= 17,
	CHARACTER_STAGEID 			= 18,
	CHARACTER_BLOOD 			= 19,
	CHARACTER_GUILD_ID 			= 20,
	CHARACTER_LEGENDARYWEAPON 	= 21,	--//神兵等级
	CHARACTER_HEAVEN 			= 22,	--//法宝等级
	CHARACTER_PONCHO 			= 23,	--//披风等级
	CHARACTER_MATRIX 			= 24,	--//法阵等级
	CHARACTER_DOMAIN			= 25,	--//领域  就是活跃度的那个境界啦
	TRIALBATTLEROUND			= 26,	--//登山路最大轮次
	TRIALBATTLECURSECTION		= 27,	--//登山路当前轮次的打到哪一关
	ADVANCEFBTIMES				= 28,	--//进阶副本当前已通过次数 0为所有副本
	MONEYDUNGEONTIMES			= 29,	--//银两副本挑战次数
	PLOTBATTLECURDAYFIGHTNUM	= 30,	--//剧情副本当天已打次数
	EQUIPMENTCURDAYFIGHTNUM		= 31,	--//装备副本当天已打次数
	SECRETSHOUSECURDAYFIGHTNUM	= 32,	--//百战密室当天已经打才的次数
	PARTNERDEPLOY				= 33,	--//伙伴总加成战斗力
	EQUIPMENT					= 34,	--//装备战斗力
	REALM						= 35,	--//人物境界
	TRUEMEAN					= 36,	--//真意战斗力
	HEAVENWARRIER				= 37,	--//战兵等级
	HWWEAPON					= 38,	--//界兵等级
	HWHORSE 					= 39,	--//战骑
	HWWING 						= 40,	--//战羽
}
CURRENCYTYPE = {
	MONEY = 1,
	EMONEY = 2,
	VOUCHERS = 3,
}

ACTIONTYPE = {	
	PLOTQUEST = 2,
	TodayQuest = 3,
	GuildQuest = 4,
	CompleteEntrustTask = 29,
	CompleteAllDailyTask = 47,
	BranchTask = 72,
	EveryDayTask = 174,	
	eFT_Pokedex = 600,              -- 图鉴任务，完成
    eFT_Pokedex_Extra = 601,        -- 图鉴任务，全部完成的奖励
	eFT_GuildQuestCompleteAll = 610,		-- 完成家族任务额外奖励资源流向
	eFT_GuildQuestOneKey = 611,		-- 一键完成家族任务资源流向
}

ThingExpiryMode = {
	eTEM_Unlimit = 0,	-- 无时间限制
	eTEM_AchieveConsume	= 1,	-- 获得道具后计时过期
	eTEM_AchieveOnLineConsume = 2,	-- 获得道具后在线计时过期
	eTEM_AchieveUse = 3,	-- 经过指定时间才能使用
	eTEM_AchieveOnlineUse = 4,	-- 经过指定在线时间才能使用
	eTEM_TimeOut = 5,	-- 到达指定时间过期
	eTEM_DailyConsume = 6,	-- 经过具体天数后过期
}

eWeaponRewardWay = {
	eWRW_Item = 1,      
	eWRW_WeaponPractiseLevel    = 2, 
	eWRW_UseIllusion = 3,
	eWRW_CompletePlotQuest = 4,
	eWRW_SevenLoginReward = 5,
}

ePreparedStatementValueType =
{
	TYPE_BOOL_1 	= 0	,
	TYPE_UI8 		= 1	,
	TYPE_UI16		= 2	,
	TYPE_UI32		= 3	,
	TYPE_UI64		= 4	,
	TYPE_I8			= 5	,
	TYPE_I16		= 6	,
	TYPE_I32		= 7	,
	TYPE_I64		= 8	,
	TYPE_FLOAT		= 9	,
	TYPE_DOUBLE		=10	,		
	TYPE_STRING		=11	,		
	TYPE_NULL       =12	,
};

-- 排行榜枚举
eRankListType = {
		eRLT_Unkown = 0,
		eRLT_Level = 1,     -- 等级
		eRLT_Combat = 2,    
		eRLT_CharacterRealm = 3,
		eRLT_Equipment = 4, 
		eRLT_Partner = 5,
		eRLT_TrueMeaning = 6,
		eRLT_Blood = 7,		
		eRLT_Horse = 8,             -- 坐骑
		eRLT_Wing = 9,              -- 羽翼
		eRLT_LegendaryWeapon = 10,  -- 神兵
		eRLT_Talisman = 11,         -- 法宝
		eRLT_Poncho = 12,           -- 披风
		eRLT_MatrixMethod = 13,		-- 法政
		eRLT_Worship = 14,
		eRLT_SendFlower = 15,
		eRLT_ReciveFlower = 16,		
		eRLT_Count = 17,
}

-- GM 开启活动返回码
eFestivalGMProcessMsgcode = {
	eFestivalGMMC_Unknow = 0,
	eFestivalGMMC_Success = 1,
	eFestivalGMMC_InActivity = 2,           -- 活动中，不能设置开始时间
	eFestivalGMMC_StarttimeNotZero = 3,     -- 开始时间不是0点
	eFestivalGMMC_EndtimeNotZero = 4,       -- 结束时间不是0点
	eFestivalGMMC_StarttimeSameEndtime = 5, -- 开始时间和结束时间相同
	eFestivalGMMC_StartimeLessThanTorZero = 6,  -- 开始时间没有大于第二天0点
	eFestivalGMMC_EndtimeLessThanTorZero = 7,   -- 开始时间和结束时间相同
	eFestivalGMMC_NoCfg = 8,                -- 没有活动配置，无法开启
	eFestivalGMMC_LessOpenDay = 9,          -- 开服天数未达到要求
	eFestivalGMMC_ActivityTypeError = 10,   -- 活动类型错误
	eFestivalGMMC_ConnectWorldServerFailed = 11, -- 连接世界服失败
	eFestivalGMMC_HadEnd = 12,              -- 活动已结束
}

MAXTEMPDATASTRINGLEN = 255

tTime_M = {}    -- 分钟触发 0~59
tTime_HM = {}   -- 时:分 0:0 ~ 24:59（0 ~ 2459）每一分钟触发一次
tQuestInfo = {}
tActivityTime = {}
tOnUserRechargeEmoney = {} --玩家充值总入口
tOnUserRechargeEmoney_Cross = {} --玩家充值总入口 跨服处理
tOnUserSpendEmoney = {} --消费接口 
tOnUserSpendEmoney_Cross = {} --消费接口 
tOnOnAcitveAward = {} -- 领取活动奖励的入口
tOnOnAcitveAward_Cross = {} -- 领取活动奖励的入口 跨服处理
tOnCompleteThings = {}-- 玩家完成某项任务的入口(如完成某个关卡，杀敌100等)
tOnCompleteThings_Cross = {}-- 玩家完成某项任务的入口(如完成某个关卡，杀敌100等)
tOnLoginActivity = {}	-- 玩家登入的时候，去处理和活动相关的登入重置等
tOnLoginActivity_Cross = {}	-- 玩家登入的时候，去处理和活动相关的登入重置等
tOnZeroTrigger = {}	-- 0 点触发的函数
tOnZeroTrigger_Cross = {}	-- 0 点触发的函数
tOnLogoutActivity = {} -- 玩家下线
tOnLogoutActivity_Cross = {} -- 玩家下线
tQuestTrigeer = {}	--任务检测额外触发
tQuestTrigeer_Cross = {}	--任务检测额外触发
tGuideFunctionTrigeer = {} --解锁功能时触发
tGuideFunctionTrigeer_Cross = {} --解锁功能时触发
tOnCharacterDead = {}-- 角色死亡触发
tOnCharacterDead_Cross= {}-- 角色死亡触发
tGlobalDataQueryTrigeer = {}	--  跨服上全局掩码查询返回
tGlobalDataUpdateTrigeer = {}	--	跨服上全局掩码修改返回
