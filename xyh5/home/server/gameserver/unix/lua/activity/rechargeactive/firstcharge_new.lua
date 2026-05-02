-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1-7 字段，今日是否已充值 1-7是不同的累充类型
--				 data8 字段，充值数量
--				 datastr 当天充值的档次记录 7,3,7,2,7,1   普通1，特殊1，普通2，特殊2 
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	local ChargeActiveCode = {
		eCAC_Unkown		= 0,	--//未知错误
		eCAC_Succ		= 1,	--//操作成功
		eCAC_NoReward	= 2,	--//没有奖励可领取
		eCAC_NoStart	= 3,	--// 活动没有开启
		eCAC_NoFoundDeploy = 4,	--//没有找到配置信息
		eCAC_ExchangeError = 5,	--//兑换错误
		eCAC_HaveGetReward = 6,	--//奖励已领取
		eCAC_LessSpace	= 7,	--//背包空间不足
		eCAC_LessLevel = 8,		--//条件不满足
		eCAC_LessRecharge = 9,	--//充值数不满足
	};
local nflowaction = CRESOURCEFLOWACTION.eFT_FirstCharge
local nLuaIdActivity_New = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_FirstCharge_New] -- 首次充值旧的数据
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]
local tRechargeInfoMain = _recharge_Info["root"][1]["server"]
local nRechargeFunctionid = _recharge_Info["root"][1]["functionid"][1]["functionid"]
local tRechargeNotice =  tRechargeInfoMain[1].rechargenotice

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入时候，检查掩码是否存在，并创建
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FirstCharge_OnLogin_new(_idCharacter,_nOsTimes)
	local key = FirstCharge_GetServerKey_new(_idCharacter)
	if -9999 == key then
		return
	end	
	local tAward = tRechargeInfoMain[key]
	local tAwardRecharge = tAward.recharge[1]
	
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity_New) then
		System_AddTempData(_idCharacter,nLuaIdActivity_New)
		--旧数据处理
		if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
			local nStrData = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
			local tStrData = System_Split(nStrData,",")
			local nOpenDay = System_GetCharacterCreateDay(_idCharacter)
			if nOpenDay > tAwardRecharge.maxcount then
				nOpenDay = tAwardRecharge.maxcount
			end
			local tStatusData = {}
			for i = 1,8 do
				tStatusData[i] = System_GetTempData(_idCharacter,nLuaIdActivity,i)
			end
			--处理今天的领取状态
			for i = 1,#tStrData / 2 do
				if tStatusData[i] == 1 then
					if tStrData[2*i - 1] == tStrData[2*i] then
						tStatusData[i] = 2
					else
						tStatusData[i] = 1
					end
				end
			end			
			
			for i = 1,#tStrData do
				if i % 2 == 1 then
					tStrData[i] = nOpenDay
				end
				if i % 2 == 0 then
					for k,v in pairs(tAward.buychange)do
						if i == v.type * 2 then
							local nNew = 0
							for l,w in pairs(v.buychangeinfo)do		
								--未领今日的刷新为明天 领过的还是今天	
								if tStatusData[v.type] == 2 then
									if tonumber(w.buynum) == tonumber(tStrData[i]) then
										nNew = w.buynum
										break
									end
								else
									if tonumber(w.buynum) == tonumber(tStrData[i])+ 1 then
										nNew = w.buynum
										break
									end
								end
							end
							tStrData[i] = nNew
						end
					end
				end
			end
			local sStrData_new = System_StrCatOnTable(tStrData,",")
			
			System_SetAllTempData(_idCharacter,nLuaIdActivity_New,
									tStatusData[1] or 0,
									tStatusData[2] or 0,
									tStatusData[3] or 0,
									tStatusData[4] or 0,
									tStatusData[5] or 0,
									tStatusData[6] or 0,
									tStatusData[7] or 0,
									tStatusData[8] or 0,
									sStrData_new)	
		else

			--处理一下奖励表 
			local tRechargeinfo = {}
			for i,v in pairs(tAwardRecharge.rechargeinfo) do
				tRechargeinfo[v.type] = tRechargeinfo[v.type] or {}
				if nil == tRechargeinfo[v.type][v.count] then		
					tRechargeinfo[v.type][v.count] = v
				else
					L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
				end
			end
			
			local strData = ""
			local nOpenDay = System_GetCharacterCreateDay(_idCharacter)
			if nOpenDay > tAwardRecharge.maxcount then
				nOpenDay = tAwardRecharge.maxcount
			end
			--特殊奖励的初值  有可能是0
			local nSpecialInit = {}
			for k,v in pairs(tAward.buychange)do
				nSpecialInit[v.type] = 0
				for j,w in pairs (v.buychangeinfo) do
					if w.buynum == 1 then
						nSpecialInit[v.type] = 1
					end
				end
			end
			for k,v in pairs(tRechargeinfo) do
				if v[nOpenDay] ~= nil then
					strData = strData.. nOpenDay .. "," .. (nSpecialInit[k] or 0)
				else
					--	如果是循环 取最大的
					local nMax = 0
					if tAwardRecharge.hold == 1 then						
						for j,w in pairs(v) do
							if nMax < j then
								nMax = j
							end
						end						
					end
					strData = strData.. nMax .. "," .. (nSpecialInit[k] or 0)
				end
				
				if k ~= #tRechargeinfo then
					strData = strData .. ","
				end
			end
			System_SetTempDataStr(_idCharacter,nLuaIdActivity_New,strData)
		end
	else
		--修正错误的数据
		local sStrData = System_GetTempDataStr(_idCharacter,nLuaIdActivity_New)
		local tStrData = System_Split(sStrData,",")
		for k,v in ipairs(tStrData) do
			if k % 2 == 1 then
				--普通奖励每天刷新
				local nOpenDay = System_GetCharacterCreateDay(_idCharacter)
				if nOpenDay < tAwardRecharge.maxcount then
					tStrData[k] = nOpenDay
				else
					tStrData[k] = tAwardRecharge.maxcount
				end
			else
				--特殊奖励万一改数据  修正下
				local bIsFind = false
				for l,w in pairs(tAward.buychange)do
					if k == tonumber(w.type) * 2 then
						for m,x in pairs(w.buychangeinfo) do
							if tonumber(v) == tonumber(x.buynum) then								
								bIsFind = true
								break
							end
						end
					end
				end
				--不存在就置为0
				if false == bIsFind then
					tStrData[k] = 0
				end
			end
		end
		System_SetTempDataStr(_idCharacter,nLuaIdActivity_New,System_StrCatOnTable(tStrData,","))
	end
end
table.insert(tOnLoginActivity,FirstCharge_OnLogin_new)
table.insert(tOnLoginActivity_Cross,FirstCharge_OnLogin_new)

-- /////////////////////////////////////////////////////////////////////////////////
--	领取奖励入口
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_processReceiveFirstReward_new(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	if 0 ~= System_OpenGuideFunction(_idCharacter,nRechargeFunctionid) then
		return ChargeActiveCode.eCAC_LessLevel
	end
	
	local code =FirstCharge_ReceiveAccumulateReward_new(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	return code
end
tOnOnAcitveAward[nflowaction] = FirstCharge_processReceiveFirstReward_new
tOnOnAcitveAward_Cross[nflowaction] = FirstCharge_processReceiveFirstReward_new
-- =================================================================================
--	领取奖励
-- =================================================================================
function FirstCharge_ReceiveAccumulateReward_new(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity_New)
	if false == bRet then
		return ChargeActiveCode.eCAC_Unkown
	end
	--取奖励次数
	local IsRecharge,sAwardStatus,rechargeCount = tTemp[_nType],tTemp["str"],tTemp[8]
	local tAwardStatus = System_Split(sAwardStatus,",")
	local normal,special = tonumber(tAwardStatus[2*_nType - 1]),tonumber(tAwardStatus[2*_nType])
	
	if 1 ~= IsRecharge then
		return ChargeActiveCode.eCAC_HaveGetReward
	end
	
	local key = FirstCharge_GetServerKey_new(_idCharacter)
	if -9999 == key then
		return ChargeActiveCode.eCAC_NoReward
	end
	
	local tAward = tRechargeInfoMain[key]
	if tAward.isopen ~= 1 then
		return ChargeActiveCode.eCAC_NoStart
	end
	
	local tAwardRecharge = tAward.recharge[1]
	
	--处理一下普通奖励表 
	local tRechargeinfo = {}
	for i,v in pairs(tAwardRecharge.rechargeinfo) do
		if _nType == v.type then
			if nil == tRechargeinfo[v.count] then		
				tRechargeinfo[v.count] = v
			else
				L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
			end
		end
	end
	--处理一下特殊奖励表 
	local tSpecialRechargeinfo = {}
	for i,v in pairs(tAward.buychange) do
		if _nType == v.type then
			tSpecialRechargeinfo = v
		end
	end	
	
	--今日可以领才判断是不是充值额足够
	for k,v in pairs(tSpecialRechargeinfo.buychangeinfo) do
		if v.buynum == _nType then
			if IsRecharge == 1 and rechargeCount < v.needrecharge then
				return ChargeActiveCode.eCAC_LessRecharge
			end
		end
	end
	
	--记为已领奖
	tTemp[_nType] = 2
	--tTemp.Update()
	
    -- 通知团购首充玩家完成的消息,只有首次领取才通知
	if  1 == _nType then
		Teamrecharge_AchieveToday(_idCharacter,os.time())
	end
    

	if	"table" == type(tRechargeinfo[normal].reward) then
		for	k,v in pairs(tRechargeinfo[normal].reward) do
			local nIdItem = "number" == type(v["itemid"]) and v["itemid"] or 0
			local nNum = "number" == type(v["itemnum"]) and v["itemnum"] or 0
			local timeMode = "number" == type(v["timemode"]) and v["timemode"] or 0
			local time_n = "number" == type(v["time"]) and v["time"] or 0

			time_n =System_timeModeTransfer(timeMode,time_n)			
			if nIdItem ~= 0 then
				if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n) then
					System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n)
				end
			end
		end
	end
	
	if "table" == type(tSpecialRechargeinfo.buychangeinfo) then
		for k,v in pairs(tSpecialRechargeinfo.buychangeinfo)do
			if v.buynum == special then
				local nIdItem = "number" == type(v["item"]) and v["item"] or 0
				local nNum = "number" == type(v["num"]) and v["num"] or 0
				local timeMode = "number" == type(v["timemode"]) and v["timemode"] or 0
				local time_n = "number" == type(v["time"]) and v["time"] or 0

				time_n =System_timeModeTransfer(timeMode,time_n)	
				
				if nIdItem ~= 0 then
					if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n) then
						System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n)
					end
					--特殊奖励的都要广播
					FirstCharge_SendBroadCast_new(_idCharacter,_nType,nIdItem,nNum)
				end
			end
		end
	end
	return ChargeActiveCode.eCAC_Succ
end


-- /////////////////////////////////////////////////////////////////////////////////
--	0点刷新充值
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_ZeroRefresh_new(_idCharacter,_nOsTimes)	
		--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity_New)
	if false == bRet then return end
	local sStrData = tTemp["str"]
	local old_strdata = sStrData
	local tStrData = System_Split(sStrData,",")
	
	local key = FirstCharge_GetServerKey_new(_idCharacter)
	if -9999 == key then
		return 
	end
	
	local tAward = tRechargeInfoMain[key]
	if tAward.isopen ~= 1 then
		return 
	end
	
	local tAwardRecharge = tAward.recharge[1]
	local tAwardBuychange = tAward.buychange
	
	
	for k,v in ipairs(tStrData) do
		if k % 2 == 1 then
			--普通奖励每天刷新
			local nOpenDay = System_GetCharacterCreateDay(_idCharacter)
			if nOpenDay < tAwardRecharge.maxcount then
				tStrData[k] = nOpenDay
			else
				tStrData[k] = tAwardRecharge.maxcount
			end
		else
			--特殊奖励 昨天有领奖就增加
			if (tTemp[k / 2] == 2 or tTemp[k / 2] == 1 )and tonumber(v) ~= 0 then
				local nNew = 0
				for j,w in pairs(tAwardBuychange) do
					if k / 2 == w.type then
						for jjj,www in pairs(w.buychangeinfo) do
							--如果有下一档
							if v + 1 == www.buynum then
								nNew = www.buynum
							end
						end
					end
				end
				tStrData[k] = nNew
			end
		end		
	end
	
	local _tOld = System_Split(old_strdata,",") 
	for i = 1,7 do
		if tTemp[i] == 1 then
			tTemp[i] = 0

            -- 通知团购首充玩家完成的消息
            --Teamrecharge_AchieveToday(_idCharacter,os.time()) --0点不处理首充团购的内容
			--超过最大值给最大的奖励
			if (tonumber(_tOld[2*i-1]) > tAwardRecharge.maxcount) then
				_tOld[2*i-1] = tAwardRecharge.maxcount
			end
			FirstCharge_SendAwardMail(_idCharacter,i,_tOld[2*i-1],_tOld[2*i])
		else
			tTemp[i] = 0
		end
		
	end
	tTemp[8] = 0
	tTemp["str"] = System_StrCatOnTable(tStrData,",")
	tTemp.Update()
end
table.insert(tOnZeroTrigger,FirstCharge_ZeroRefresh_new)
table.insert(tOnZeroTrigger_Cross,FirstCharge_ZeroRefresh_new)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家充值接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FirstCharge_OnRecharge_new(_idCharacter,_nEmoney,_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity_New) then
		return
	end
		--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity_New)
	if false == bRet then return end
	
	local key = FirstCharge_GetServerKey_new(_idCharacter)
	if -9999 == key then
		return 
	end
	
	local tAward = tRechargeInfoMain[key]
	local tAwardRecharge = tAward.recharge[1]
	local tAwardBuychange = tAward.buychange
	
	local sStrData = tTemp["str"]
	local tStrData = System_Split(sStrData,",")
	
	
	tTemp[8] = tTemp[8] + _nEmoney

	for i,v in pairs (tAwardBuychange) do
		if tTemp[i] == 0 then
			local special = tonumber(tStrData[2*i])
			for l,w in pairs(v.buychangeinfo)do
				if w.buynum == special and  tTemp[8] >= w.needrecharge then
					tTemp[i] = 9
					break
				end
			end
		end
	end
	--更新一遍 给记录经分	
	tTemp.Update()
	for i,v in pairs (tAwardBuychange) do
		if tTemp[i] == 9 then
			tTemp[i] = 1
		end
	end
	tTemp.Update()

end
table.insert(tOnUserRechargeEmoney,FirstCharge_OnRecharge_new)
table.insert(tOnUserRechargeEmoney_Cross,FirstCharge_OnRecharge_new)

-- /////////////////////////////////////////////////////////////////////////////////
--	取对应的活动KEY
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_GetServerKey_new(_idCharacter)
	local combindtimes
	if false == System_IsCrossSever() then
		combindtimes = System_GetCombinedTimes()
	else
		combindtimes = System_GetCombinedTimesByCharacter(_idCharacter)
	end
	
	local key = -9999
	for k,v in pairs(tRechargeInfoMain) do
		if -1 == v.servernum and -9999 == key then
			key = k
		end
		if combindtimes == v.servernum then
			key = k
			break
		end		
	end
	return key
end

function FirstCharge_SendBroadCast_new(_idCharacter,_nType,_nItem,_nNum)
	for i,v in pairs(tRechargeNotice) do
		if "number" == type(v["type"]) and _nType == v["type"] then
			if "number" == type( v["noticeid"]) then
				local sParam = string.format("%d,%u;%d,%s;%d,%d;%d,%d;%d,%d"
								,ePreparedStatementValueType.TYPE_UI64,_idCharacter
								,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
								,ePreparedStatementValueType.TYPE_UI32,_nItem						
								,ePreparedStatementValueType.TYPE_UI32,_nNum						
								,ePreparedStatementValueType.TYPE_UI32,1
								)
				System_SendCommonBroadCastMsg(v["noticeid"],sParam)
			end
		end
	end
end

-- =================================================================================
--	通过邮件发放奖励
-- =================================================================================
function FirstCharge_SendAwardMail(_idCharacter,_nType,_nNormal,_nSpecial)
	_nNormal = tonumber(_nNormal) or 0
	_nSpecial = tonumber(_nSpecial) or 0
	local key = FirstCharge_GetServerKey_new(_idCharacter)
	if -9999 == key then
			return
	end	
	local tAward = tRechargeInfoMain[key]
	--给普通奖励
	local tAwardRecharge = tAward.recharge[1]
	local tItem = {}
	for k,v in pairs(tAwardRecharge.rechargeinfo) do
		if _nNormal ~= 0 and v.type == _nType and v.count == _nNormal then
			for l,w in pairs (v.reward) do
				if type(w.timemode)  == "number" then
					local time_n = "number" == type(w["time"]) and w["time"] or 0
					time_n =System_timeModeTransfer(w.timemode,time_n)	
					table.insert(tItem,{w.itemid,w.itemnum,0,w.bind,w.timemode,time_n}) 
				else
					table.insert(tItem,{w.itemid,w.itemnum,0,w.bind}) 
				end
			end
		end
	end
	--给特殊奖励
	local tAwardBuychange = tAward.buychange
	for k,v in pairs(tAwardBuychange) do
		if _nSpecial ~= 0 and  v.type == _nType then
			for l,w in pairs(v.buychangeinfo)do
				if w.buynum == _nSpecial then
					if type(w.timemode)  == "number" then
						local time_n = "number" == type(w["time"]) and w["time"] or 0
						time_n =System_timeModeTransfer(w.timemode,time_n)	
						table.insert(tItem,{w.item,w.num,0,w.bind,w.timemode,time_n}) 
					else
						table.insert(tItem,{w.item,w.num,0,w.bind}) 
					end
				end
			end
		end
	end
	System_SendMail(_idCharacter,tAwardRecharge.mailid,tItem)
end

-- /////////////////////////////////////////////////////////////////////////////////
--	今天是否领过首充奖励
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_IsHasGetAward(_idCharacter)
	if System_IsExistTempData(_idCharacter,nLuaIdActivity_New) then
		local str = System_GetTempDataStr(_idCharacter,nLuaIdActivity_New)
		local tStrData = System_Split(str,",")
		for i = 1,#tStrData / 2 do
			--不判断领过  判断没充过
			if 0 ~= System_GetTempData(_idCharacter,nLuaIdActivity_New,i) then
				return true
			end
		end
	end
	return false
end