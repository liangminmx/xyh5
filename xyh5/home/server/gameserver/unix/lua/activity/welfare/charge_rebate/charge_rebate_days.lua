
--  Note：
--      只 用来记录 达成 某一金额的 连充天数，真正的 可/已 领取状态不由这里控制
--      活动掩码中
--          data1：-- 连充 2天 中的的本日 id 已经累计充值天数记录
--          data2：-- 连充 3天 中的的本日 id 已经累计充值天数记录
--          data3：-- 连充 4天 中的的本日 id 已经累计充值天数记录
--          data4：-- 连充 5天 中的的本日 id 已经累计充值天数记录

--          dataStr：存储指定天数下-指定id 的达成连充条件天数 
--              字符串格式 "x,x,x,x|x,x,x,x"
--              "x1,x2,x3,x4" -- 第一个代表 天数 ，第二个开始，代表 id 1的达成天数，类推
--                [x1][x2] = (id 1 的完成天数) 

local nResId = CRESOURCEFLOWACTION.eFT_charge_rebate_days
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家登入（只由 charge_rebate 中的登入调用）
--  @_tAllData 就是 .lua 的数据 (就是 ChargeRebate_Info = _charge_rebate_Info["root"][1]["days"] 这个)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Days_OnLogin(_idCharacter,_nOsTimes,_tAllData)    
    
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity,false)

        local tTmpZero = ChargeRebate_Days_GetAllZero(_tAllData)
        local strInit = ChargeRebate_Days_WriteStr(tTmpZero)
        -- L2C_DebugLog("::ChargeRebate_Days_OnLogin strInit:"..strInit)
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,strInit,false)
    end 
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得记录天数的字段
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Days_GetDaysData(_idCharacter)
    return System_GetTempDataStr(_idCharacter,nLuaIdActivity)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  触发某一档的成功充值
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Days_AchieveOne(_idCharacter,_nDay,_nId)
    
    local tRewardDays = ChargeRebate_Days_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity))
    if  "table" ~= type(tRewardDays[_nDay]) or "number" ~= type(tRewardDays[_nDay][_nId]) then
        L2C_DebugLog("::ChargeRebate_Days_AchieveOne reward days error,_nDay:".._nDay.." ,_nId:".._nId)
        return false
    end

    local bHadAdd,nSign,nPos = ChargeRebate_Days_GetHadtAddData(_idCharacter,_nDay,_nId)
    if  true == bHadAdd then
        return
    end

    nSign = WCBit.SetTrue(nSign,_nId)
    System_SetTempData(_idCharacter,nLuaIdActivity,nPos,nSign,false)

    tRewardDays[_nDay][_nId] = tRewardDays[_nDay][_nId] + 1
    local strNew = ChargeRebate_Days_WriteStr(tRewardDays)
    return System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  触发零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Days_ResetData(_idCharacter,_nPastDay,_nYesterdayRecharge,_tAllData)

    System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)   -- 连充两天 的本日 id 已经累计充值天数记录
    System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)   -- 三天
    System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)   -- 五天
    -- System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)   -- 七天
    --[[ 已经不算断了连续了
    if  1 ~= _nPastDay then
        -- 只要是 不是 只 跨过一天的，都认为断了连续充值了
        local tTmpZero = ChargeRebate_Days_GetAllZero(_tAllData)
        local strZero = ChargeRebate_Days_WriteStr(tTmpZero)
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,strZero,false)

    else        
	]]
            -- 只判断是否要清零，天数 + 1在充值接口处做
            -- local tRewardDays = ChargeRebate_Days_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity))
            -- for k_coutinueDays,v_days in pairs(tRewardDays) do                
                -- for i_id = 1,(#v_days),1 do                    
                    -- local nNeedRecharge = ChargeRebate_GetNeedRecharge(k_coutinueDays,i_id)
                    -- if  nNeedRecharge > _nYesterdayRecharge then
                        -- v_days[i_id] = 0
                    -- end
                -- end
            -- end
            
            -- local strNew = ChargeRebate_Days_WriteStr(tRewardDays)   
            -- System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false)
    -- end
	
end

-- ========================================================================================================
--  特殊处理，用一个 int 表示某与 day-id 的档位今天已经增加过天数了
-- ========================================================================================================
function ChargeRebate_Days_GetHadtAddData(_idCharacter,_nDay,_nId)
    local nSign = 0
    local nPos = 0
    if  2 == _nDay then
        nPos = 1
        nSign = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    elseif  3 == _nDay then
        nPos = 2
        nSign = System_GetTempData(_idCharacter,nLuaIdActivity,2)
    elseif  5 == _nDay then
        nPos = 3
        nSign = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    -- elseif  8 == _nDay then 
        -- nPos = 4
        -- nSign = System_GetTempData(_idCharacter,nLuaIdActivity,4)
    else
        L2C_DebugLog("::ChargeRebate_Days_GetHadtData get error _day:".._nDay)
        return true,nSign,nPos
    end

    return WCBit.GetBit(nSign,_nId),nSign,nPos
end

-- ========================================================================================================
--  返回一个所有的天数都为 0 的table
-- ========================================================================================================
function ChargeRebate_Days_GetAllZero(_tAllData)
    local tTmp = {}
    for k,v_day in pairs(_tAllData) do
        local nCountinueDay = tonumber(v_day["day"])
        tTmp[nCountinueDay] = tTmp[nCountinueDay] or {}
        
        for k2,v_id in pairs(v_day["grade"]) do            
            local nId = tonumber(v_id["id"])     
           
            tTmp[nCountinueDay][nId] = 0
        end
    end
    return tTmp
end

-- ========================================================================================================
--  读取 连充 天数字符串
-- ========================================================================================================
function ChargeRebate_Days_ReadStr(_str)
    
    if  nil == _str or "" == _str then
        L2C_DebugLog("::ChargeRebate_Days_ReadStr get error str")
        return {}
    end

    local tRet = {}
    local tTmp = System_Split(_str,"|") -- 获得"x,x,x,x"
    for k,v in pairs(tTmp) do
        local tDaysValue = System_Split(v,",")
        local nCoutinueDays = tonumber(tDaysValue[1])
        tRet[nCoutinueDays] = tRet[nCoutinueDays] or {}
        for i = 2,(#tDaysValue),1 do
            tRet[nCoutinueDays][i-1] = tonumber(tDaysValue[i])    
        end
    end

    -- for k,v in pairs(tRet) do
    --     L2C_DebugLog("::ChargeRebate_Days_ReadStr days: "..k)
    --     for k2,v2 in pairs(v) do
    --         L2C_DebugLog("      ::ChargeRebate_Days_ReadStr id: "..k2.." ,value: "..v2)
    --     end
    -- end

    return tRet;
end

-- ========================================================================================================
--  写 连充 天数字符串
-- ========================================================================================================
function ChargeRebate_Days_WriteStr(_tData)
    local strNew = ""
    for k_days,v_days in pairs(_tData) do
        local strTmpDays = tostring(k_days)
        for i = 1,(#v_days),1 do
            strTmpDays = strTmpDays .."," .. tostring(v_days[i])  
        end

        if  "" == strNew then
            strNew = strTmpDays
        else
            strNew = strNew .. "|" .. strTmpDays
        end
    end
    return strNew
end
