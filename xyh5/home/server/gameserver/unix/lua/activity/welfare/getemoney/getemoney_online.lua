local nResId_OnLine = CRESOURCEFLOWACTION.eFT_GeteMoeny_OnLine
local nLuaIdActivity_OnLine = LUARESOURCEFLOWACTION[nResId_OnLine]
local tGetEmoney_OnLine_Info = _getemoney_Info["root"][1]["onlinegetemoney"][1]

-- Note:
--  该活动的掩码：
--      data1：今天是开服第几天
--      data2：今天的在线时长 用 秒做单位
--      data3：前几天的有效在线时长（总时长 data2 + data3）
--      data4：本日是否充值
--      data5：奖励领取状态
--      data6：合服次数
--      data7,data8：openDay 和 overDay 开始和关闭天数(左边闭合右边不闭合 "[)")
--      dataStr:与开服天数对应的，每天可以得到的元宝("0,0|0,0|0,0")(" 这一天的可领取元宝数，这一天的在线时长")
--              (有记录多余，字符串是有 从 1 ~ overDay 个记录的)

-- ===============================================================================================================
--	玩家登入(由 getmoney 调用，不主动触发)
-- ===============================================================================================================
function GetEMoney_OnLine_OnLogin(_idCharacter,_nOsTimes,_nOpenServerDay)
    GetEMoney_OnLine_Create(_idCharacter,_nOpenServerDay)
    GetEMoney_OnLine_Reset(_idCharacter,_nOpenServerDay)
end

-- ===============================================================================================================
--  玩家在线时长增加
--  @_nAddTime 是触发的间隔时间 
-- ===============================================================================================================
function GetEMoney_OnLine_AddScore(_idCharacter,_nOpenServerDay,_nOsNowTime,_nAddTime)
    if  true == GetEMoney_OnLine_InActivity(_idCharacter,_nOpenServerDay,_nOsNowTime) then
        local nTodayTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,2)
        local nPastTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,3)

        -- 算出来的最大可领奖在线时间
        local nLimit = ( tGetEmoney_OnLine_Info["maxemoney2"] / tGetEmoney_OnLine_Info["getemoney2"] ) * tGetEmoney_OnLine_Info["online"] 
        nLimit = nLimit * 60    -- 转换成秒
        if  (nTodayTime + nPastTime) >= nLimit then
            return  -- 时间到最大，不再增加
        end

        nTodayTime = nTodayTime + _nAddTime 
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,2,nTodayTime,false)
    end
end

-- ===============================================================================================================
--  领取奖励
--  @_nIndex 在领奖字符串中的第几项
--  @_nWantDouble 1 玩家申请要领取的是双倍奖励
--  @return 调用该函数后，充值了多少钱
-- ===============================================================================================================
function GetEMoney_OnLine_GetReward(_idCharacter,_nIndex,_nWantDouble)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,8)

    -- 判断有效的index，会发不是这个子活动的 index 
    if  not (nOpenday <= _nIndex and _nIndex <= nOverDay) then
        -- L2C_DebugLog("::GetEMoney_OnLine_GetReward get error index:".._nIndex)
        return 0
    end

    -- 判断是否已领取
    local nGetSign = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,5)
    local bGet = WCBit.GetBit(nGetSign,_nIndex)
    if  true == bGet then
        L2C_DebugLog("::GetEMoney_OnLine_GetReward had get")
        return 0
    end
    
    -- 能不能双倍
    local tReward = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_OnLine),"|" )
    for k,v in pairs(tReward) do
        tReward[k] = System_Split( v,",")   -- "这天的可领取元宝，这天的在线时长"
    end
    local nNum = tReward[_nIndex][1] or 0
    nNum = tonumber(nNum)
    local nTodayRechargeSign = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,4)
    if  1 == nTodayRechargeSign and 1 == _nWantDouble then
        nNum = nNum * 2
    end

    -- 设置成领取，发奖
    nGetSign = WCBit.SetTrue(nGetSign,_nIndex)
    if  true == System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,5,nGetSign,false) then    
        System_AwardVouchers(_idCharacter,nNum,nResId_OnLine)
        return nNum
    else
        L2C_DebugLog("::GetEMoney_Active_GetReward set mask error")
        return 0
    end      
end

-- ===============================================================================================================
--  设置今天充值了
-- ===============================================================================================================
function GetEMoney_OnLine_Recharge(_idCharacter,_nOpenServerDay)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,8)

    -- if  nOpenday <= _nOpenServerDay and _nOpenServerDay <= nOverDay then
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,4,1,false)
    -- end
end

-- ===============================================================================================================
--  计算玩家 今天 在线时长可以兑换的元宝数目
--  @_nToday 0 只有今天，1 所有的（默认0）
-- ===============================================================================================================
function GetEMoney_OnLine_NowEmoney(_idCharacter,_nToday)
    _nToday = _nToday or 0

    local nScore = 0
    if  0 == _nToday then   -- 只算今天
        local nTodayTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,2)    
        nScore = GetEMoney_OnLine_CanGet(nTodayTime)
    else    -- 算所有
        local nAll = GetEMoney_OnLine_NowAllTime(_idCharacter)                
        nScore = GetEMoney_OnLine_CanGet(nAll)
    end
    return nScore
end

-- ===============================================================================================================
--  玩家总的在线时长
-- ===============================================================================================================
function GetEMoney_OnLine_NowAllTime(_idCharacter)
    local nTodayTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,2)
    local nPastTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,3)
    return (nTodayTime + nPastTime)
end

-- ===============================================================================================================
--  添加掩码，并设置掩码初始数据
-- ===============================================================================================================
function GetEMoney_OnLine_Create(_idCharacter,_nOpenServerDay)

    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity_OnLine) then
        
        local nCombineTimes = System_GetCombinedTimes()

        System_AddTempData(_idCharacter,nLuaIdActivity_OnLine,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,1,_nOpenServerDay,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,6,nCombineTimes,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,7,tGetEmoney_OnLine_Info["openday"],false)
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,8,tGetEmoney_OnLine_Info["overday"],false)
        -- 创建一个字符串做数据，key从 1~overday，作为初始数据
        local str = ""
        for i = 1,(tGetEmoney_OnLine_Info["overday"]),1 do
            if  i == (tGetEmoney_OnLine_Info["overday"]) then
                str = str .. "0,0"
            else
                str = str .. "0,0" .. "|"
            end
        end
        System_SetTempDataStr(_idCharacter,nLuaIdActivity_OnLine,str,false)
    end
end

-- ===============================================================================================================
--  重置数据并更新Str数据
-- ===============================================================================================================
function GetEMoney_OnLine_Reset(_idCharacter,_nOpenServerDay)
    
    local nCombineTimes = System_GetCombinedTimes()
    if  nCombineTimes ~= System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,6) then
        System_DelTempData(_idCharacter,nLuaIdActivity_OnLine,false)
        GetEMoney_OnLine_Create(_idCharacter,_nOpenServerDay)        
    end
    -- 只在新服开
    if  0 ~= nCombineTimes then 
        return 
    end

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,8)

    if  _nOpenServerDay ~= System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,1) then
        -- 活动结束后，领取奖励没有时限，需要一直记录本日是否充值
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,4,0,false)    -- 本日是否充值

        local nOldDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,1)
        System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,1,_nOpenServerDay,false)  -- 开服天数

        -- 需要更新的时间 nOpenDay ~ (nOverDay + 1)
        if  nOpenDay <= _nOpenServerDay and  _nOpenServerDay <= (nOverDay + 1) then
            
            local nOldTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,2)   -- 昨天的在线时长
            local nPastTime = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,3)
            local tOld = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_OnLine),"|" )

            nPastTime = nPastTime + nOldTime
            local nScore = GetEMoney_OnLine_CanGet(nOldTime)-- 昨天能领取的奖励
            tOld[nOldDay] = tostring(nScore) .. "," .. tostring(nOldTime)
            local strNew = GetEMoney_Reset_Write(tOld)
            
            -- System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,1,_nOpenServerDay,false)  -- 开服天数
            System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,2,0,false)    -- 本日有效在线时长
            System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,3,nPastTime,false)    -- 过去天，总在线时长
            -- System_SetTempData(_idCharacter,nLuaIdActivity_OnLine,4,0,false)    -- 本日是否充值
            System_SetTempDataStr(_idCharacter,nLuaIdActivity_OnLine,strNew,false)  -- 新的 天数-元宝字符串
        end
    end
end

-- ===============================================================================================================
--  判断当前是不是在活动开启时间
-- ===============================================================================================================
function GetEMoney_OnLine_InActivity(_idCharacter,_nOpenServerDay,_nOsTime)
    _nOsTime = _nOsTime or os.time()

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,7)   -- 开启的天数
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,8)   -- 结束的天虎

    local nOpenTime = tGetEmoney_OnLine_Info["opentime"]    -- 开启天的开启时间
    local nOverTime = tGetEmoney_OnLine_Info["overtime"]    -- 结束天的结束时间
    
    local tTime = System_Split( ( os.date("%X",_nOsTime) ),":")
    local nNowTime = tonumber(tTime[1]) * 3600 + tonumber(tTime[2]) * 60 + tonumber(tTime[3])

    if  _nOpenServerDay == nOpenDay then
        if  nNowTime >= nOpenTime then
            return true
        else
            return false
        end
    elseif  _nOpenServerDay == nOverTime then        
        if  nNowTime <= nOverTime then
            return true
        else
            return false
        end 
    elseif  (nOpenDay < _nOpenServerDay and _nOpenServerDay < nOverDay) then
        return true
    else
       return false 
    end
end

-- ===============================================================================================================
-- 计算给的时间能获得多少元宝，单位为秒
-- ===============================================================================================================
function GetEMoney_OnLine_CanGet(_nTime)
    _nTime = _nTime / 60 -- 换成分钟
    
    _nTime = _nTime / tGetEmoney_OnLine_Info["online"]
    _nTime = math.floor(_nTime) -- 向下取整，不够10分钟的时间不给奖励了


    local nScore = _nTime * tGetEmoney_OnLine_Info["getemoney2"]
    return nScore
end