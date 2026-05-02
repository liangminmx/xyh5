local	eFestivalAT_Null					=  0		--
local	eFestivalAT_RechargeGift 			=  1		--
local	eFestivalAT_Consume		 			=  2		--//消费
local	eFestivalAT_Online 					=  3		--//在线
local	eFestivalAT_Active 					=  4		--//活跃
local	eFestivalAT_Diaoluo		 			=  5		--//掉落
local	eFestivalAT_Duihuan					=  6		--//兑换
local	eFestivalAT_Luckybox				=  7		--//气运宝箱
local	eFestivalAT_Collect					=  8		--//收集活动
local	eFestivalAT_FBMaster 				=  9		--//节日副本达人
local	eFestivalAT_SendFlower				= 10		--//跨服送花榜
local	eFestivalAT_Fashion					= 11		--//节日时装
local	eFestivalAT_Match					= 12		--//比赛活动
local	eFestivalAT_360Privilege			= 13		--//360特权
local	eFestivalAT_OldplayerReturn			= 14		--//老玩家回归
local	eFestivalAT_Draw					= 15		--//节日抽奖
local	eFestivalAT_MallDiscount			= 16		--//节日商城打折
local	eFestivalAT_SpiritStone				= 17		--//节日收集宝石
local	eFestivalAT_Lattice					= 18		--//节日转盘
local	eFestivalAT_DungeonRefresh			= 19		--//节日副本刷新
local	eFestivalAT_ConsumeItem				= 20		--//节日消耗物品
local	eFestivalAT_ReciveFlower			= 21		--//跨服收花榜
local	eFestivalAT_JulySeventh				= 22		--//七夕鹊桥
local	eFestivalAT_MultipleProfit			= 23		--//多倍收益
local	eFestivalAT_Valentineday			= 24		--//情人节转盘
local	eFestivalAT_MidautumnBingo			= 25		--//中秋博饼
local	eFestivalAT_Saipao					= 26		--//玉兔赛跑
local	eFestivalAT_MidAutumnMobilization	= 27		--//中秋总动员
local	eFestivalAT_SpawnMonster			= 28		--//节日刷怪
local	eFestivalAT_ToSkyTower				= 29		--//通天塔
local	eFestivalAT_FirstBlood				= 30		--//国庆首战通天塔
local	eFestivalAT_LuckyTurning			= 31		--//幸运转盘
local	eFestivalAT_CloudBuy				= 32		--//云购活动
local	eFestivalAT_ActiveLuckyDraw			= 33		--// 活跃抽奖
local	eFestivalAT_KaiFuChouJiang			= 34		--// 开服抽奖
local	eFestivalAT_OperateActivity			= 35		--// 运营活动
local	eFestivalAT_Login 					= 37		--//登录活动
local	eFestivalAT_XingYunJingCai 			= 38		--//幸运竞猜活动

eFestivalGetActiveInfo =
	{
		eFGAI_StartTime = 1,
		eFGAI_EndTime = 2,
		eFGAI_Status = 3,
		eFGAI_Cfgid = 4,
	}

local eFestivalActivityStatus =
	{
		eFestivalAS_Null = 0,
		eFestivalAS_Start = 1,
		eFestivalAS_End = 2,
	}
	
--设置活动信息
function C2L_GMActiveControl_SetActive(_nActivityType,_nOSTime,_nBeginTime,_nEndTime,_nCfgId,_sParams)         
	if _nActivityType == eFestivalAT_Consume then
		GM_FestivalConsume_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	end
  
	if _nActivityType == eFestivalAT_KaiFuChouJiang then
		GM_ChouJiang_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	end

    if  _nActivityType == eFestivalAT_SpawnMonster then
        return GM_FestivalMonster_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
    end
	if  _nActivityType == eFestivalAT_OperateActivity then
		GM_FestticalWeb_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	end
	if _nActivityType == eFestivalAT_Login then
		GM_FestticalLogin_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	end
	if _nActivityType == eFestivalAT_XingYunJingCai then
		GM_XingYunJingCai_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	end
    return eFestivalGMProcessMsgcode.eFestivalGMMC_Success
end
--设置活动结束时间
function C2L_GMActiveControl_SetEndTime(_nActivityType,_nOSTime,_nEndTime)      
	if _nActivityType == eFestivalAT_Consume then
		GM_FestivalConsume_instance_SetEndData(_nEndTime,_nOSTime)
	end
	
	if _nActivityType == eFestivalAT_KaiFuChouJiang then
		GM_ChouJiang_instance_SetEndData(_nEndTime,_nOSTime)
	end

    if  _nActivityType == eFestivalAT_SpawnMonster then
        return GM_FestivalMonster_instance_SetEndData(_nEndTime,_nOSTime)
    end
	if  _nActivityType == eFestivalAT_OperateActivity then
		GM_FestticalWeb_instance_SetEndData(_nEndTime,_nOSTime)
	end
	if  _nActivityType == eFestivalAT_Login then
		GM_FestticalLogin_instance_SetEndData(_nEndTime,_nOSTime)
	end
	if  _nActivityType == eFestivalAT_XingYunJingCai then
		GM_XingYunJingCai_instance_SetEndData(_nEndTime,_nOSTime)
	end

    return eFestivalGMProcessMsgcode.eFestivalGMMC_Success
end
--取活动信息   _nType:eFestivalGetActiveInfo
function C2L_GetGMActiveControl_Info(_nActivityType,_nOSTime,_nType)         
	if _nActivityType == eFestivalAT_Consume then
		GM_FestivalConsume_instance_GetData(_nCfgId,_nOSTime,_nType)
	end  
	if _nActivityType == eFestivalAT_SpawnMonster then
		return GM_ChouJiang_instance_GetData(_nType)
	end

    if  _nActivityType == eFestivalAT_FestivalMonster then
        return GM_FestivalMonster_instance_GetData(_nType)
    end
	if  _nActivityType == eFestivalAT_OperateActivity then
		return GM_FestticalWeb_instance_GetData(_nCfgId,_nOSTime,_nType)
	end	
	if  _nActivityType == eFestivalAT_Login then
		return GM_FestticalLogin_instance_GetData(_nCfgId,_nOSTime,_nType)
	end	
	if  _nActivityType == eFestivalAT_XingYunJingCai then
		return GM_XingYunJingCai_instance_GetData(_nCfgId,_nOSTime,_nType)
	end	
end