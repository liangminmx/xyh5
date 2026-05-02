eOpenActivity_onLine = {
	eOpenActivity_onLine_End = 0,			-- 活动结束
	eOpenActivity_onLine_HadGet = 1,	-- 已经领取奖励
	eOpenActivity_onLine_NoEnoughTime = 2,	-- 时间累计不够
	eOpenActivity_onLine_NoEnoughLevel = 3,	-- 等级不够
	eOpenActivity_onLine_Succeed = 4,	-- 时间到了，发放奖励
	eOpenActivity_onLine_Unknown = 5,	-- 未知
}

local nResId = CRESOURCEFLOWACTION.eFT_OpenOnLine
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tOpenactivity_onllineInfo = _openactivity_onlline_Info["root"][1]["openactivity"]

-- Note：
-- 	在掩码中 nData1 是是否已经领取奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	在活动中，创建掩码
--	活动结束了，删除掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_OpenActivity_onLine(_idCharacter,_nOsTimes)
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity)		
    end
end
table.insert(tOnLoginActivity,OnLogin_OpenActivity_onLine)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	检验能不能发放奖励了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Check_OpenActivity_OnLine_Complete(_idCharacter,_nCActionType,_nCurOnlineTime,_nData4,_nData5)

	if	nil == _idCharacter or nil == _nCActionType  or nil == _nCurOnlineTime then
		L2C_DebugLog("::ProcessGetOpenFBRewardReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nCurOnlineTime or "nil")..")")
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end

	if	_nCActionType ~= nResId then
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end
	    
	if	false == GetOpenActivity_OnLineIsOpen() then
		return eOpenActivity_onLine.eOpenActivity_onLine_End
	end
	
	if	true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		if	1 == System_GetTempData(_idCharacter,nLuaIdActivity,1) then
			return eOpenActivity_onLine.eOpenActivity_onLine_HadGet
		end
	else
		-- 活动正在进行中，不可能出现掩码已被删除/没创建的情况
		L2C_DebugLog("::Check_OpenActivity_OnLine_Complete not find TempData !!!")
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end	

    -- 获得serverkey, GetOpenActivity_OnLineIsOpen() 函数中，已经判断本合服次数下是有配置的了
    local nServerKey = GetOpenActivity_GetServerKey()
    local tData = tOpenactivity_onllineInfo[nServerKey]

	-- 判断时间够不够领奖了
	if	"number" == type(tData["onlineplayer"][1]["onlinetime"]) then
		if	_nCurOnlineTime < tData["onlineplayer"][1]["onlinetime"] then
			return eOpenActivity_onLine.eOpenActivity_onLine_NoEnoughTime
		end
	else
		L2C_DebugLog("::Check_OpenActivity_OnLine_Complete onlinetime data error !!")
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end
	
	-- 判断等级够不够领取了
	if	"number" == type(tData["onlineplayer"][1]["playerlv"]) then
		local nNowLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) or 0
		if	nNowLevel < tData["onlineplayer"][1]["playerlv"] then
			return eOpenActivity_onLine.eOpenActivity_onLine_NoEnoughLevel
		end
	else
		L2C_DebugLog("::Check_OpenActivity_OnLine_Complete playerlv data error !!")
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end
	
	if	true == System_SetTempData(_idCharacter,nLuaIdActivity,1,1) then				-- 设置奖励已领取
		-- 发送奖励邮件
		Send_Mail_OpenActivityOnLine_Reward(_idCharacter,nServerKey)
		return eOpenActivity_onLine.eOpenActivity_onLine_Succeed
	else
		L2C_DebugLog("::Check_OpenActivity_OnLine_Complete Mask Error")
		return eOpenActivity_onLine.eOpenActivity_onLine_Unknown
	end
	
	
end
tOnOnAcitveAward[nResId] = Check_OpenActivity_OnLine_Complete

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	c++ 找lua要数据的函数
--	判断活动是否正在开启
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessOpenActivity_onLine_SendToC(_nData1,_nCActionType,_nData3,_nData4,_nData5)
	local bRet = GetOpenActivity_OnLineIsOpen()
	-- L2C_DebugLog("::ProcessOpenActivity_onLine_SendToC activity onLine open status is "..tostring(bRet))
	if	bRet then
		return 1
	else
		return 0
	end
end
tGetActivityData[nResId] = ProcessOpenActivity_onLine_SendToC

-- ================================================================
--	判断活动是否正在开启时间
-- ================================================================
function GetOpenActivity_OnLineIsOpen()
    local nServerKey = GetOpenActivity_GetServerKey()
    if  nil == nServerKey then
        return false
    end	
	local nOpenServerDay = System_GetOpenServerDay()
    local tData = tOpenactivity_onllineInfo[nServerKey]
	
	if	"number" == type(tData["openday"]) and "number" == type(tData["continuday"]) then
		
		local beginDay = tData["openday"]
		local endDay = beginDay + tData["continuday"]
		if	beginDay <= nOpenServerDay and nOpenServerDay < endDay then
			return true
		end
	else
		L2C_DebugLog("::GetOpenActivity_OnLineIsOpen openday and continuday data error !!!")
	end
	return false
end

-- ================================================================
--	发送奖励的邮件
-- ================================================================
function Send_Mail_OpenActivityOnLine_Reward(_idCharacter,_nServerKey)  

    local tData = tOpenactivity_onllineInfo[_nServerKey]
	if	"table" == type(tData["onlineplayer"][1]["reward"]) then
		local strItem = ""
		for	k,v in pairs(tData["onlineplayer"][1]["reward"]) do
			local nItemId = v["item"]
			local nNum = v["itemnum"] 
			local nStage = v["stage"] or 0
			strItem = strItem .. tostring(nItemId) .. ","..tostring(nNum)..","..tostring(nStage)..";"
		end

		System_SendMail(_idCharacter,tData["mailid"],strItem)
	else 
		L2C_DebugLog("::Send_Mail_OpenActivityOnLine_Reward Reward Data Error !!!")
	end
end

-- ================================================================
--	获得合服次数的配置数据
-- ================================================================
function GetOpenActivity_GetServerKey()

    local nCombineTime = System_GetCombinedTimes()
    local nDefaultTime = -1
    local nDefaultKey = nil

    for k,v in pairs(tOpenactivity_onllineInfo) do
        if  nCombineTime == v['servernum'] then
            return k
        end

        if  nDefaultTime == v['servernum'] then
            nDefaultKey = k 
        end
    end

    return nDefaultKey
end