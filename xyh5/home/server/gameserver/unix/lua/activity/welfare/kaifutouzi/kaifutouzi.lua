-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		掩码 data1 	字段，fundid 已购买基金
--		掩码 data2 	字段，reward 已领取的基金
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_KaiFuTouZi
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tKaiFuTouZiInfo = _kaifutouzi_Info["root"][1]["openday"]
local nKaiFuTouZiFunctionId = _kaifutouzi_Info["root"][1]["functionid"][1]["functionid"]
local tKaiFuTouZiOpenServer = {} --开启的是哪个servernum下的活动

local eKFTZLT_Buy = 1 
local eKFTZLT_Reward = 2

local eKFTZC_Success = 0			--//成功
local eKFTZC_Unknow = 1				--//未知错误
local eKFTZC_NotOpen = 2			--//活动未开启
local eKFTZC_EmoneyNotEnough = 3	--//元宝不足
local eKFTZC_NotBuy = 4				--//未购买基金
local eKFTZC_NotFund = 5			--//已领取完基金
local eKFTZC_BagFull = 6			--//背包空间已满

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function KaiFuTouZi_Login(_idCharacter,_nOsTimes)	
	if false ==  KaiFuTouZi_CheckOpen(_idCharacter) then
		return
	end
	KaiFuTouZi_Init(_idCharacter)
	-- 这个是永久开的  直到领完
	-- KaiFuTouZi_IconStatus(_idCharacter)
	KaiFuTouZi_Syn(_idCharacter)	
end
table.insert(tOnLoginActivity,KaiFuTouZi_Login)
table.insert(tOnLoginActivity_Cross,KaiFuTouZi_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function KaiFuTouZi_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if eKFTZLT_Buy == _nData3 then
		local code = KaiFuTouZi_BuyReq(_idCharacter,_nData4)
		return code
	end
	if eKFTZLT_Reward == _nData3 then
		local code,nFundId,reward = KaiFuTouZi_RewardReq(_idCharacter)
		System_KaiFuTouZiReward(_idCharacter,code,nFundId,reward)
		if code == eKFTZC_Success then
			local sParam = string.format("%d,%d;%d,%d"
							,ePreparedStatementValueType.TYPE_UI64,nFundId
							,ePreparedStatementValueType.TYPE_STRING,reward								
							)
			System_LogCommonOA(_idCharacter,"log_kaifutouzi",sParam)
			return code
		end
	end
end
tOnOnAcitveAward[nflowaction] = KaiFuTouZi_Req
tOnOnAcitveAward_Cross[nflowaction] = KaiFuTouZi_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		0点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function KaiFuTouZi_ZeroRefresh(_idCharacter,_nOsTimes)	
	-- 好像什么事情都不用做
end
-- table.insert(tOnZeroTrigger,KaiFuTouZi_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级处理
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function KaiFuTouZi_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	KaiFuTouZi_Login(_idCharacter,_nOsTimes)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],KaiFuTouZi_LevelUp)
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],KaiFuTouZi_LevelUp)


-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function KaiFuTouZi_GetServerNumConfig(_idCharacter)
	if next(tKaiFuTouZiOpenServer) ~= nil then
		return tKaiFuTouZiOpenServer
	end	
	local nCombined
	if false == System_IsCrossSever() then
		nCombined = System_GetCombinedTimes()
	else
		nCombined = System_GetCombinedTimesByCharacter(_idCharacter)
	end
	
	for k,v in pairs(tKaiFuTouZiInfo) do
		if nCombined == v.servernum then
			tKaiFuTouZiOpenServer = tKaiFuTouZiInfo[k]
			return tKaiFuTouZiOpenServer
		end
		if -1 == v.servernum then
			tKaiFuTouZiOpenServer = tKaiFuTouZiInfo[k]
		end
	end
	if next(tKaiFuTouZiOpenServer) == nil then
		L2C_DebugLog(string.format("::KaiFuTouZi_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	end
	return tKaiFuTouZiOpenServer
end
-- ================================================================================================================
--		活动是否开启
-- ================================================================================================================
function KaiFuTouZi_CheckOpen(_idCharacter)
	-- 这个是永久开的  直到领完
	-- local tConfig = KaiFuTouZi_GetServerNumConfig()
	-- if nil == next(tConfig )then
		-- return false
	-- end
	
	-- local nOpenDay = System_GetOpenServerDay()
	-- if "number" ~= type(tConfig.open[1].openday) or  "number" ~= type(tConfig.open[1].days) or  "number" ~= type(tConfig.open[1].holddays) then
		-- return false
	-- end
	-- if nOpenDay < tConfig.open[1].openday or nOpenDay >= tConfig.open[1].openday + tConfig.open[1].days + tConfig.open[1].holddays then
		-- return false
	-- end
	
	if 0 ~= System_OpenGuideFunction(_idCharacter,nKaiFuTouZiFunctionId) then
		return false
	end	
	return true
end

-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function KaiFuTouZi_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)	
end
-- ================================================================================================================
--		同步活动信息
-- ================================================================================================================
function KaiFuTouZi_Syn(_idCharacter)
	local nFundId = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nReward = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	System_KaiFuTouZiSyn(_idCharacter, nFundId, nReward)
end

-- ================================================================================================================
--		购买基金
-- ================================================================================================================
function KaiFuTouZi_BuyReq(_idCharacter,_nFundId)
	if false == KaiFuTouZi_CheckOpen(_idCharacter) then
		return eKFTZC_NotOpen
	end
	local nFundId = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if nFundId ~= 0 then
		return eKFTZC_Unknow
	end
	local tConfig = KaiFuTouZi_GetServerNumConfig(_idCharacter)
	local nSpendEmoney = tConfig.open[1].money
	if "number" ~= type(nSpendEmoney) 
		or false == System_SpendEmoney(_idCharacter,nSpendEmoney,nflowaction) 
	then
		return eKFTZC_EmoneyNotEnough
	end
	System_SetTempData(_idCharacter,nLuaIdActivity,1,_nFundId)
	local nNotice = tConfig.open[1].notice
	if type(nNotice) == "number" then
		KaiFuTouZi_SendBroadCast(_idCharacter,nNotice)
	end
	return eKFTZC_Success
end

-- ================================================================================================================
--		领取基金
-- ================================================================================================================
function KaiFuTouZi_RewardReq(_idCharacter)
	if false == KaiFuTouZi_CheckOpen(_idCharacter) then		
		return eKFTZC_NotOpen,0,0
	end
	
	local nFundId = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if nFundId == 0 then		
		return eKFTZC_NotBuy,0,0
	end

	local combineTime
	local serverOpenDay
	if false == System_IsCrossSever() then
		serverOpenDay = System_GetOpenServerDay()
		combineTime = System_GetCombinedTimes()
	else
		serverOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
		combineTime = System_GetCombinedTimesByCharacter(_idCharacter)
	end

	local tConfig = KaiFuTouZi_GetServerNumConfig(_idCharacter)
	local nReward = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local nOpenDay = System_GetCharacterCreateDay(_idCharacter)

	if combineTime > 0 and nOpenDay > serverOpenDay then
		nOpenDay = serverOpenDay
	end
	
	
	--今日可以领到哪一档
	local nTodayReward = tConfig["open"][1].openday + nOpenDay - 1
	local tItem = {}
	local nAwardBindEmoney = 0
	local nNotice = nil
	for i,v in pairs(tConfig["open"][1].reward) do
		if v.intoday > nReward and v.intoday <= nTodayReward then
			table.insert(tItem,{v.itemid,v.num})
			nAwardBindEmoney = nAwardBindEmoney + ("number" == type(v.bindemoney) and v.bindemoney or 0 )
			nNotice = v.notice
		end		
	end
	
	if nil == next(tItem) then
		return eKFTZC_NotFund,nFundId,0
	end
	
	if false == System_CanPushThingsToBagEx(_idCharacter,tItem) then
		return eKFTZC_BagFull,nFundId,0
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,2,nTodayReward)
	
	for k,v in pairs(tItem)do
		System_AwardThingInBag(_idCharacter,nflowaction,v[1],v[2])
	end
	System_AwardVouchers(_idCharacter,nAwardBindEmoney,nflowaction)
	
	if type(nNotice) == "number" then
		KaiFuTouZi_SendBroadCast(_idCharacter,nNotice)
	end
	
	return eKFTZC_Success,nFundId,nTodayReward
end
-- ================================================================================================================
--		购买广播
-- ================================================================================================================
function KaiFuTouZi_SendBroadCast(_idCharacter,_nNotice)
	local sParam = string.format("%d,%u;%d,%s;"
								,ePreparedStatementValueType.TYPE_UI64,_idCharacter
								,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)		
								)
	System_SendCommonBroadCastMsg(_nNotice,sParam)
end

-- ================================================================================================================
--		开启活动图标
-- ================================================================================================================
function KaiFuTouZi_IconStatus(_idCharacter)
	local status = 0
	if KaiFuTouZi_CheckOpen(_idCharacter) then
		--判断奖励有没有领完
		local nFundId = System_GetTempData(_idCharacter,nLuaIdActivity,1)
		local nReward = System_GetTempData(_idCharacter,nLuaIdActivity,2)
		
		if nFundId == 0 then 
			status = 1
		else
			local tConfig = KaiFuTouZi_GetServerNumConfig(_idCharacter)
			if nil ~= next(tConfig )then
				for k,v in pairs(tConfig.open[1].reward) do
					if nReward < v.fundid then
						status = 1		
						break
					end
				end		
			end	
		end
	end	
	System_SendActiveStatus(_idCharacter,nflowaction,status,0,0)
end