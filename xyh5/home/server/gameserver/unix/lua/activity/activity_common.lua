-- ===================================================
-- ======== 消费
-- ===================================================
-- idCharacter + idActivity 来表示参加了什么活动吧。。
-- 7,8字段放开始/结束时间 
-- 1字段表示在活动期间消费了多少钱
-- 2字段表示，已经领取了那个阶段的奖励(如已经消费150,领取了消费100的奖励，那么该数据就是100)
function OnActivityUserSpendMoney(_idCharacter,_nEmoney)
	
	if	_idCharacter == nil or _nEmoney == nil then
		L2C_DebugLog("::OnActivityUserSpendMoney Error ("..(_idCharacter or "nil").."|"..(_nEmoney or "nil")..")")
		return
	end
	
	local nTimeDate = tonumber(os.date("%y%m%d",os.time()))
	L2C_DebugLog("::OnActivityUserSpendMoney: nTimeDate is "..nTimeDate)
	
	for	k,v in pairs(tActivitySpeedMoneyInfo) do
		if	tActivityInfo[v] ~= nil then
			if	type(tActivityInfo[v]["time"]) == "table" and type(tActivityInfo[v]["time"][1]) == "number" and type(tActivityInfo[v]["time"][2]) == "number" then
				if	tActivityInfo[v]["time"][1] <= nTimeDate and  nTimeDate <= tActivityInfo[v]["time"][2] then
					if	System_IsExistTempData(_idCharacter,v) == false then
						System_AddTempData(_idCharacter,v)
						System_SetTempData(_idCharacter,v,7,tActivityInfo[v]["time"][1])
						System_SetTempData(_idCharacter,v,8,tActivityInfo[v]["time"][2])
					end

					local nHaveSpeedMoney = System_GetTempData(_idCharacter,v,1)
					nHaveSpeedMoney = nHaveSpeedMoney + _nEmoney
					System_SetTempData(_idCharacter,v,1,nHaveSpeedMoney)
					L2C_DebugLog("::OnActivityUserSpendMoney: now speed money is "..nHaveSpeedMoney)

					local nHaveGetRewardMoneySign = System_GetTempData(_idCharacter,v,2)
					if	type(tActivityInfo[v]["achieve"]) == "number" then
						if	nHaveGetRewardMoneySign == 0 then
							if	nHaveSpeedMoney >= tActivityInfo[v]["achieve"] then
								-- 发放奖励
								L2C_DebugLog("::OnActivityUserSpendMoney: send (".._idCharacter.."|"..v..") achieve "..tActivityInfo[v]["achieve"].."reward")
								System_SetTempData(_idCharacter,v,2,tActivityInfo[v]["achieve"])
							end
						end
					elseif	type(tActivityInfo[v]["achieve"] == "table") then
						for	kAchieve,vAchieve in pairs(tActivityInfo[v]["achieve"]) do
							if	vAchieve > nHaveGetRewardMoneySign then
								L2C_DebugLog("::OnActivityUserSpendMoney: now check Speed Achieve is "..vAchieve)
								if	nHaveSpeedMoney >= vAchieve then
									-- 发放奖励
									L2C_DebugLog("::OnActivityUserSpendMoney: send (".._idCharacter.."|"..v..") achieve "..vAchieve.." reward")
									System_SetTempData(_idCharacter,v,2,vAchieve)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	c++部分获取在 lua 活动中的数据
--	Note:
--		只能返回一个 number 的数据，多个数据就得自己拼接了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function C2L_GetActivityLuaData(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if	nil ~= tGetActivityData then
		if	"function" == type(tGetActivityData[_nCActionType]) then
			local	nRet = tGetActivityData[_nCActionType](_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
			return nRet
		else
			L2C_DebugLog("	====================")
			L2C_DebugLog(" this call in C2L_GetActivityLuaData is error ,error data is ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nData3 or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
			L2C_DebugLog("	====================")
		end	
	end
end