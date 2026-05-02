-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		掩码 datastr 	字段，自己的领奖记录   
--							a,b,b,b,b;a,b,b,b;  a为activeID b为领取的等级
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_OpenAdvanceDay
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tOpenAdvanceDayInfo = _open_advanceday_Info["root"][1]["server"]
local tOpenAdvanceDayOpenServer = {} --开启的是哪个servernum下的活动

local eOADC_Success 	= 0	--//成功
local eOADC_Unknow 		= 1	--//未知错误
local eOADC_LevelLess 	= 2	--//未达到条件
local eOADC_Got			= 3 --//已领取过
local eOADC_BagFull		= 4 --//背包已满

local eEightDayAT_Horse				= 1
local eEightDayAT_LegendaryWeapon 	= 2
local eEightDayAT_Wing				= 3
local eEightDayAT_Poncho			= 4
local eEightDayAT_Matrix			= 5
local eEightDayAT_HeavenWarrier		= 6
local eEightDayAT_HWWeapon			= 7
local eEightDayAT_HWHorse			= 8
local eEightDayAT_HWWing			= 9
local eEightDayAT_PartnerDeploy		= 10

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenAdvanceDay_Login(_idCharacter,_nOsTimes)	
	OpenAdvanceDay_Init(_idCharacter)
	OpenAdvanceDay_Syn(_idCharacter)	
end
table.insert(tOnLoginActivity,OpenAdvanceDay_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenAdvanceDay_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	local code = OpenAdvanceDay_RewardReq(_idCharacter,_nData3,_nData4)
	System_OpenAdvanceDayReward(_idCharacter,code,_nData3,_nData4)
	if code == eOADC_Success then
		local sParam = string.format("%d,%d;%d,%d"
							,ePreparedStatementValueType.TYPE_UI64,_nData3
							,ePreparedStatementValueType.TYPE_STRING,_nData4								
							)
		System_LogCommonOA(_idCharacter,"log_openadvanceday",sParam)
	end
	return code
end
tOnOnAcitveAward[nflowaction] = OpenAdvanceDay_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		0点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenAdvanceDay_ZeroRefresh(_idCharacter,_nOsTimes)	
	local nOpenDay = System_GetOpenServerDay()
	local tConfig = OpenAdvanceDay_GetServerNumConfig()
	if nil == next(tConfig )then
		L2C_DebugLog("::OpenAdvanceDay_ZeroRefresh tConfig Error")
		return
	end
	for k,v in pairs (tConfig.wealth) do
		if v.day == nOpenDay then
			local tActivityid = System_Split(v.activityid,",")
			local sRewardStatus = ""
			for l,w in pairs(tActivityid) do
				sRewardStatus = sRewardStatus .. w .. ";"
			end
			System_SetTempDataStr(_idCharacter,nLuaIdActivity,sRewardStatus)
			break
		end
	end
	OpenAdvanceDay_Syn(_idCharacter)	
end
table.insert(tOnZeroTrigger,OpenAdvanceDay_ZeroRefresh)

-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function OpenAdvanceDay_GetServerNumConfig()
	if next(tOpenAdvanceDayOpenServer) ~= nil then
		return tOpenAdvanceDayOpenServer
	end	
	local nCombined = System_GetCombinedTimes()
	for k,v in pairs(tOpenAdvanceDayInfo) do
		if nCombined == v.servernum then
			tOpenAdvanceDayOpenServer = tOpenAdvanceDayInfo[k]
			return tOpenAdvanceDayOpenServer
		end
		if -1 == v.servernum then
			tOpenAdvanceDayOpenServer = tOpenAdvanceDayInfo[k]
		end
	end
	if next(tOpenAdvanceDayOpenServer) == nil then
		L2C_DebugLog(string.format("::OpenAdvanceDay_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	end
	return tOpenAdvanceDayOpenServer
end
-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function OpenAdvanceDay_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)	
	local nOpenDay = System_GetOpenServerDay()
	local tConfig = OpenAdvanceDay_GetServerNumConfig()
	if nil == next(tConfig )then
		L2C_DebugLog("::OpenAdvanceDay_Init tConfig Error")
		return
	end
	for k,v in pairs (tConfig.wealth) do
		if v.day == nOpenDay then
			local tActivityid = System_Split(v.activityid,",")
			local sRewardStatus = ""
			for l,w in pairs(tActivityid) do
				sRewardStatus = sRewardStatus .. w .. ";"
			end
			System_SetTempDataStr(_idCharacter,nLuaIdActivity,sRewardStatus)
			break
		end
	end
end
-- ================================================================================================================
--		同步活动信息
-- ================================================================================================================
function OpenAdvanceDay_Syn(_idCharacter)
	local sRewardStatus = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local tRewardStatus = System_Split(sRewardStatus,";")
	for k,v in pairs(tRewardStatus) do
		local tActiveReward = System_Split(v,",")
		local nActivityid = tonumber(tActiveReward[1])
		local sRewardLevel = ""
		for i = 2,#tActiveReward do
			sRewardLevel = sRewardLevel .. tActiveReward[i]
			if i ~= #tActiveReward then
				sRewardLevel = sRewardLevel .. ","
			end
		end
		System_OpenAdvanceDaySyn(_idCharacter, nActivityid, sRewardLevel)
	end	
end
-- ================================================================================================================
--		领奖
-- ================================================================================================================
function OpenAdvanceDay_RewardReq(_idCharacter,_nActiveId,_nLevel)
	local tConfig = OpenAdvanceDay_GetServerNumConfig()
	if nil == next(tConfig )then
		return eOADC_Unknow
	end
	
	local tActivityConfig = {}
	for k,v in pairs(tConfig.activity)do
		if _nActiveId == v.activityid then
			tActivityConfig = v
			break
		end
	end
	if nil == next(tActivityConfig )then
		return eOADC_Unknow
	end
	
	local sRewardStatus = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local tRewardStatus = System_Split(sRewardStatus,";")
	local nRewardKey = 0
	for k,v in pairs(tRewardStatus)do
		local tActiveReward = System_Split(v,",")
		if tonumber(tActiveReward[1]) == _nActiveId then
			nRewardKey = k
			break
		end
	end
	
	if nRewardKey == 0 then
		return eOADC_Unknow
	end
	local tRewardLevel = System_Split(tRewardStatus[nRewardKey],",")
	for i = 2,#tRewardLevel do
		if _nLevel == tonumber(tRewardLevel[i]) then
			return eOADC_Got
		end
	end
	
	if false == OpenAdvanceDay_CheckLevel(_idCharacter,_nActiveId,_nLevel)	then
		return eOADC_LevelLess
	end
	
	
	local tItem = {}	
	
	for j,u in pairs(tActivityConfig.advance) do
		if u.level == _nLevel then
			for k,v in pairs(u.reward) do
				if type(v.timemode)  == "number" then
					local time_n = "number" == type(v["expiredtme"]) and v["expiredtme"] or 0
					time_n =System_timeModeTransfer(v.timemode,time_n)	
					table.insert(tItem,{v.item,v.itemnum,0,v.bind,v.timemode,time_n}) 
				else
					table.insert(tItem,{v.item,v.itemnum,0,v.bind}) 
				end
			end
		end
	end
	
	if nil == next(tItem) then
		return eOADC_Unknow
	end
	
	if false == System_CanPushThingsToBagEx(_idCharacter,tItem) then
		return eOADC_BagFull
	end
	
	--	记掩码	-->>>>>>>>>>>>>
	table.insert(tRewardLevel,_nLevel)
	tRewardStatus[nRewardKey] = System_StrCatOnTable(tRewardLevel,",")
	
	sRewardStatus = System_StrCatOnTable(tRewardStatus,";")
	
	System_SetTempDataStr(_idCharacter,nLuaIdActivity,sRewardStatus)
	--	记掩码	--<<<<<<<<<<<<<
	--	发奖	-->>>>>>>>>>>>>
	for k,v in pairs(tItem)do
		System_AwardThingInBag(_idCharacter,nflowaction,v[1],v[2],0,0,0,0,v[5] or 0,v[6] or 0)
	end
	--	发奖	--<<<<<<<<<<<<<
	return eOADC_Success
end

-- ================================================================================================================
--		判断是否满足领取等级
-- ================================================================================================================
function OpenAdvanceDay_CheckLevel(_idCharacter,_nActiveId,_nLevel)	
	if _nActiveId == eEightDayAT_LegendaryWeapon then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_LEGENDARYWEAPON)
	end
	if _nActiveId == eEightDayAT_Horse then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.HORSE_STEPLEV)
	end
	if _nActiveId == eEightDayAT_Wing then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.WING_REALM)
	end
	if _nActiveId == eEightDayAT_PartnerDeploy then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.PARTNERDEPLOY)
	end
	if _nActiveId == eEightDayAT_TrueMean then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.TRUEMEAN)
	end
	if _nActiveId == eEightDayAT_Poncho then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_PONCHO)
	end
	if _nActiveId == eEightDayAT_Matrix then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_MATRIX)
	end
	if _nActiveId == eEightDayAT_HeavenWarrier then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.HEAVENWARRIER)
	end
	if _nActiveId == eEightDayAT_HWWeapon then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.HWWEAPON)
	end
	if _nActiveId == eEightDayAT_HWHorse then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.HWHORSE)
	end
	if _nActiveId == eEightDayAT_HWWing then
		return _nLevel <= System_GetAttrInt(_idCharacter,CHARACTER_INT.HWWING)
	end	
	return false
end