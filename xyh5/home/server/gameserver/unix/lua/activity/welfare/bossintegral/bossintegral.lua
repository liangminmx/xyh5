--// BOSS杀手活动状态
local eBOSSIStatus =
{
	End	= 0,	--// 结束,也不能领取奖励
	Start = 1,	--// 开启状态
	Hold = 2,	--// 结束,但是可以领取奖励
};

local eBOSSIMsgcode =
{
	Null = 0,			--内部错误
	Success = 1,	--成功
	Param = 2,	--消息参数错误
	NotBuy = 3,	--没有购买对应基金
	HadGet = 4,	--已经领取
	NoReward = 5,	--未达到领取条件
	BagFull = 6,	--背包已满
	BagErr = 7,	--添加物品失败
	HadBuy = 8,	--已经购买了指定基金
	End = 9,		--活动已结束
	LevelLow = 10,--等级不足
	NoEMoney = 11,--元宝不足
	NoRank = 12,	--未上榜
};
tBossIntegralData = _bossintegral_Info.root[1]
--取活动数据   type 1活动状态 2怪物积分
function BossIntergral_getActivityStatus(_idCharacter,_nCActionType,_nType,_nMonsterId,_nData5)
	local tData = GetBossIntegralData()
	if "table" ~= type(tData.open[1]) then
		return -1
	end
	if _nType == 1 then

		local openday,days,holddays = tData.open[1].openday,tData.open[1].days,tData.open[1].holddays
		local openServerday = System_GetOpenServerDay()
		if openServerday >= openday and openServerday < openday + days then
			-- 需要开启活动
			return eBOSSIStatus.Start;
		elseif openServerday >= openday + days and openServerday < openday + days + holddays then
			-- 活动结束,但是保持界面
			return eBOSSIStatus.Hold;
		end
		-- 活动结束
		return eBOSSIStatus.End;
	end
	if _nType == 2 then
		if "table" == type(tData.open[1].FB)and "number" == type(_nMonsterId) then
			for k,v in pairs(tData.open[1].FB) do	
				if v.monsterId == _nMonsterId then
					return v.integral or 0
				end
			end
			return 0
		end
	end
	return -1
end
tGetActivityData[CRESOURCEFLOWACTION.eFT_BossIntegral] = BossIntergral_getActivityStatus

--领取奖励  
--enum eBOSSIRewardType
--{
--	eBIRT_SingleCheck = 1,
--	eBIRT_SingleReward = 2,
--	eBIRT_RankCheck = 3,
--	eBIRT_RankReward = 4,
--};
function BossIntergral_processGetReward(_idCharacter,_nCActionType,_nType,_nIntegral,_nRank)
	local tData = GetBossIntegralData()
	--参与奖检测
	if (1 == _nType ) then
		if "table" ~= type(tData.partakereward[1]) then
			return eBOSSIMsgcode.NoReward
		end	
		local t = tData.partakereward[1]
		if _nIntegral < t.integral then
			return eBOSSIMsgcode.NoReward
		end
		--背包空间判断
		local _sItem = ""
		for k,v in ipairs(t.reward) do
			if "number" == type(v.integralreward) and "number" == type(v.num) then
				_sItem = _sItem .. v.integralreward .. [[,]] .. v.num .. [[,]]
			end
		end
		if false == System_CanPushThingsToBagEx(_idCharacter,_sItem) then
			return eBOSSIMsgcode.BagFull
		end
		return eBOSSIMsgcode.Success
	end
	--参与奖领取
	if( 2 == _nType) then
		if "table" ~= type(tData.partakereward[1]) then
			return eBOSSIMsgcode.NoReward
		end	
		local t = tData.partakereward[1]
		for k,v in pairs(t.reward) do
			local nIdItem = v.integralreward
			local nNum = v.num
			if	false == System_AwardThingInBag(_idCharacter,CRESOURCEFLOWACTION.eFT_BossIntegral,nIdItem,nNum) then
				System_AwardThingQuestContainer(_idCharacter,CRESOURCEFLOWACTION.eFT_BossIntegral,nIdItem,nNum)
			end
		end
		System_AwardMoney(_idCharacter,t.money or 0,CRESOURCEFLOWACTION.eFT_BossIntegral)
		System_AwardVouchers(_idCharacter,t.bindemoney or 0,CRESOURCEFLOWACTION.eFT_BossIntegral)			
		return eBOSSIMsgcode.Success
	end
	--排名奖检测
	if ( 3 == _nType) then
		if "table" ~= type(tData.integralreward) then
			return eBOSSIMsgcode.NoReward
		end	
		local t = tData.integralreward[_nRank]
		if "table" ~= type(t) then
			return eBOSSIMsgcode.NoReward
		end		
		--背包空间判断
		local _sItem = ""
		for k,v in ipairs(t.reward) do
			if "number" == type(v.integralreward) and "number" == type(v.num) then
				_sItem = _sItem .. v.integralreward .. [[,]] .. v.num .. [[,]]
			end
		end
		if false == System_CanPushThingsToBagEx(_idCharacter,_sItem) then
			return eBOSSIMsgcode.BagFull
		end
		return eBOSSIMsgcode.Success
	end
	--排名奖领取
	if( 4 == _nType) then
		if "table" ~= type(tData.integralreward) then
			return eBOSSIMsgcode.NoReward
		end	
		local t = tData.integralreward[_nRank]
		if "table" ~= type(t) then
			return eBOSSIMsgcode.NoReward
		end
		for k,v in pairs(t.reward) do
			local nIdItem = v.integralreward
			local nNum = v.num
			if	false == System_AwardThingInBag(_idCharacter,CRESOURCEFLOWACTION.eFT_BossIntegral,nIdItem,nNum) then
				System_AwardThingQuestContainer(_idCharacter,CRESOURCEFLOWACTION.eFT_BossIntegral,nIdItem,nNum)
			end
		end
		System_AwardMoney(_idCharacter,t.money or 0,CRESOURCEFLOWACTION.eFT_BossIntegral)
		System_AwardVouchers(_idCharacter,t.bindemoney or 0,CRESOURCEFLOWACTION.eFT_BossIntegral)			
		return eBOSSIMsgcode.Success
	end
end
tOnOnAcitveAward[CRESOURCEFLOWACTION.eFT_BossIntegral] = BossIntergral_processGetReward

function GetBossIntegralData()
	local nCombined = System_GetCombinedTimes()
	local tRet = {}
	for k,v in pairs(tBossIntegralData.sever) do
		if v.severnum == nCombined then
			tRet = tBossIntegralData.sever[k]
		end
		if v.severnum == -1 then
			if #tRet == 0 then 
				tRet = tBossIntegralData.sever[k]
			end
		end
	end
	return tRet
end