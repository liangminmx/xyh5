
--  Note：
--      可领取 / 领取状态,只用来记状态，不需要走每日刷新的地方
--      活动掩码中
--          dataStr：存储指定连充天数的 天数-可领取状态-已领取状
--              字符串格式 "x,x,x|x,x,x"
--              table格式：  [day][1] = (number) 可领取的 id(位存储)
--                          [day][2] = (number) 已领取的 id(位存储)

local nResId = CRESOURCEFLOWACTION.eFT_charge_rebate_sign
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家登入（只由 charge_rebate 中的登入调用）
--  @_tAllData 就是 .lua 的数据 (就是 ChargeRebate_Info = _charge_rebate_Info["root"][1]["days"] 这个)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Sign_OnLogin(_idCharacter,_nOsTimes,_tAllData)    
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity,false)

        local tTmp = {}
        for k,v_day in pairs(_tAllData) do
            local nCountinueDay = tonumber(v_day["day"])
            for k2,v_id in pairs(v_day["grade"]) do
                local nId = tonumber(v_id["id"])
                tTmp[nCountinueDay] = tTmp[nCountinueDay] or {}
                tTmp[nCountinueDay][1] = 0
                tTmp[nCountinueDay][2] = 0
            end
        end
        local strInit = ChargeRebate_Sign_WriteStr(tTmp)
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,strInit,false)
    end     
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获取，设置已领奖 状态的！
--  @_nSetOrGet 0获取/1设置 状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Sign_Get(_idCharacter,_nSetOrGet,_nDay,_nId)  
    local tRewardStatus = ChargeRebate_Sign_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity) )
    if  "table" ~= type(tRewardStatus[_nDay]) or "number" ~= type(tRewardStatus[_nDay][1]) or "number" ~= type(tRewardStatus[_nDay][2]) then        
        L2C_DebugLog("::ChargeRebate_Sign_Get reward status error,_nDay:".._nDay)
        return false
    end

    if  not(_nSetOrGet == 1 or  _nSetOrGet == 0) then
        L2C_DebugLog("::ChargeRebate_Sign_Get error arg _nSetOrGet: ".._nSetOrGet)
        return false
    end
    
    local nSignGet = tRewardStatus[_nDay][2]
    if  1 == _nSetOrGet then    -- 设置某一 day-id 已领取
        tRewardStatus[_nDay][2] = WCBit.SetTrue(nSignGet,_nId)
        local strNew = ChargeRebate_Sign_WriteStr(tRewardStatus)
        return System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false)
    else
        -- 查询是否已经领取
        return WCBit.GetBit(nSignGet,_nId)
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获取，设置 可领奖 状态的！
--  @_nSetOrGet 0获取/1设置 状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Sign_Can(_idCharacter,_nSetOrGet,_nDay,_nId)  
    local tRewardStatus = ChargeRebate_Sign_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity) )
    if  "table" ~= type(tRewardStatus[_nDay]) or "number" ~= type(tRewardStatus[_nDay][1]) or "number" ~= type(tRewardStatus[_nDay][2]) then        
        L2C_DebugLog("::ChargeRebate_Sign_Can reward status error,_nDay:".._nDay)
        return false
    end

    if  not(_nSetOrGet == 1 or  _nSetOrGet == 0) then
        L2C_DebugLog("::ChargeRebate_Sign_Get error arg _nSetOrGet: ".._nSetOrGet)
        return false
    end

    local nSignCan = tRewardStatus[_nDay][1]
    if  1 == _nSetOrGet then    -- 设置某一 day-id 可以领取了
        tRewardStatus[_nDay][1] = WCBit.SetTrue(nSignCan,_nId)
        local strNew = ChargeRebate_Sign_WriteStr(tRewardStatus)
        return System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false)
    else
        -- 查询是否已经可以领取
        return WCBit.GetBit(nSignCan,_nId)
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获取这个存储数据的字符串
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Sign_AllData(_idCharacter)
    return System_GetTempDataStr(_idCharacter,nLuaIdActivity)
end

-- ========================================================================================================
--  读取可领取，已领取的字符串
-- ========================================================================================================
function ChargeRebate_Sign_ReadStr(_str)
   if   nil == _str or "" == _str then
        L2C_DebugLog("::ChargeRebate_Sign_ReadStr get error data!!!")
        return {}
   end
   local tRet = {}
   local tTmp = System_Split(_str,"|")  -- 截成"x,x,x" 
   for  k,v in pairs(tTmp) do
        local tTmpRealData = System_Split(v,",")
        local nDay = tonumber(tTmpRealData[1])
        local nCan = tonumber(tTmpRealData[2])
        local nGet = tonumber(tTmpRealData[3])
		
        tRet[nDay] = tRet[nDay] or {}
        tRet[nDay][1] = nCan
        tRet[nDay][2] = nGet
   end
   return tRet
end

-- ========================================================================================================
--  写可领取，已领取的字符串
-- ========================================================================================================
function ChargeRebate_Sign_WriteStr(_tData)
    local strNew = ""
    for k,v in pairs(_tData) do
        if  "" == strNew then
            strNew = tostring(k)..","..tostring(v[1])..","..tostring(v[2])
        else
            strNew = strNew.."|"..tostring(k)..","..tostring(v[1])..","..tostring(v[2])
        end
    end
	
    return strNew
end