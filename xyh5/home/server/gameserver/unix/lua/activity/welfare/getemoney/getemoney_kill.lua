local nResId_Kill = CRESOURCEFLOWACTION.eFT_GeteMoeny_Boss
local nLuaIdActivity_Kill = LUARESOURCEFLOWACTION[nResId_Kill]
local tGetEmoney_Kill_Info = _getemoney_Info["root"][1]["killgetemoney"][1]

-- Note:
--  该活动的掩码：
--      data1：今天是开服第几天
--      data2：今天的 龙山巡守 次数
--      data3：之前天数的龙山巡守 总次数（data2 + data3 才是总数）
--      data4：今天是否充值了                 
--      data5：奖励的领取状态
--      data6：合服次数
--      data7,data8：openDay 和 overDay 开始和关闭天数(左边闭合右边不闭合 "[)")
--      dataStr:与开服天数对应的，每天可以得到的元宝("0,0|0,0|0,0")(" 可领取元宝数 ， 今天的龙山巡守分数")
--              (有记录多余，字符串是有 从 1 ~ overDay 个记录的)

-- ===============================================================================================================
--	玩家登入(由 getmoney 调用，不主动触发)
-- ===============================================================================================================
function GetEMoney_Kill_OnLogin(_idCharacter,_nOsTimes,_nOpenServerDay)
    GetEMoney_Kill_Create(_idCharacter,_nOpenServerDay)

    GetEMoney_Kill_Reset(_idCharacter,_nOpenServerDay)
end

-- ===============================================================================================================
--  玩家分数增加(调用一次增加一个数量)
-- ===============================================================================================================
function GetEMoney_Kill_AddScore(_idCharacter,_nOpenServerDay)
    if  true == GetEMoney_Kill_InActivity(_idCharacter,_nOpenServerDay) then
        
        -- 根据获得最大元宝，算出的最大可参加次数
        local nLimit = ( tGetEmoney_Kill_Info["maxemoney2"] / tGetEmoney_Kill_Info["getemoney2"] ) * tGetEmoney_Kill_Info["bossreward"]
        local nToday = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,2)
        local nPast = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,3)
        if  (nToday + nPast) >= nLimit then
            return
        end

        nToday = nToday + 1
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,2,nToday,false)

        -- 主动推送 龙山巡守 数据
        GetEMoney_Syn_Type(_idCharacter,eGetEmoney_Action.eGA_Kill)
        -- 推送所有消息
        GetEMoney_Syn(_idCharacter)
    end
end

-- ===============================================================================================================
--  领取奖励
--  @_nIndex 在领奖字符串中的第几项
--  @_nWantDouble 1 玩家申请要领取的是双倍奖励
--  @return 调用该函数后，充值了多少钱
-- ===============================================================================================================
function GetEMoney_Kill_GetReward(_idCharacter,_nIndex,_nWantDouble)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,8)

    -- 判断有效的index，会发不是这个子活动的 index 
    if  not (nOpenday <= _nIndex and _nIndex <= nOverDay) then
        -- L2C_DebugLog("::GetEMoney_Kill_GetReward get error index:".._nIndex)
        return 0
    end

    -- 是否已经领取
    local nGetSign = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,5)
    local bGet = WCBit.GetBit(nGetSign,_nIndex)
    if  true == bGet then
        L2C_DebugLog("::GetEMoney_Kill_GetReward had get")
        return 0
    end
    
    -- 能不能双倍
    local tReward = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Kill),"|" )
    for k,v in pairs(tReward) do
       tReward[k] =  System_Split( v, ",")  -- "可领取元宝数 ， 这一天的龙山巡守次数"
    end
    local nNum = tReward[_nIndex][1] or 0
    nNum = tonumber(nNum)
    local nTodayRechargeSign = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,4)
    if  1 == nTodayRechargeSign and 1 == _nWantDouble then
        nNum = nNum * 2
    end

    -- 设置成已领取，发奖
    nGetSign = WCBit.SetTrue(nGetSign,_nIndex)
    if  true == System_SetTempData(_idCharacter,nLuaIdActivity_Kill,5,nGetSign,false) then
        System_AwardVouchers(_idCharacter,nNum,nResId_Kill)
        return nNum
    else
        L2C_DebugLog("::GetEMoney_Kill_GetReward set mask error")
        return 0
    end 
end

-- ===============================================================================================================
--  设置今天充值了
-- ===============================================================================================================
function GetEMoney_Kill_Recharge(_idCharacter,_nOpenServerDay)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,8)

    -- if  nOpenday <= _nOpenServerDay and _nOpenServerDay <= nOverDay then
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,4,1,false)
    -- end
end

-- ===============================================================================================================
--  玩家当前参与 龙山巡守 的次数能兑换的元宝数目
--  @_nToday 0 只有今天，1 所有的（默认0）
-- ===============================================================================================================
function GetEMoney_Kill_NowEmoney(_idCharacter,_nToday)
    
    _nToday = _nToday or 0
    local nScore = 0
    if  0 == _nToday then
        local nTodayTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,2)
        nScore = (nTodayTimes / tGetEmoney_Kill_Info["bossreward"]) * tGetEmoney_Kill_Info["getemoney2"]
    else
        local nAll = GetEMoney_Kill_NowAllTimes(_idCharacter)
        nScore = (nAll / tGetEmoney_Kill_Info["bossreward"]) * tGetEmoney_Kill_Info["getemoney2"]
    end

    nScore = math.floor(nScore)
    return nScore
end

-- ===============================================================================================================
--  玩家总的龙山巡守的所有的总的次数
-- ===============================================================================================================
function GetEMoney_Kill_NowAllTimes(_idCharacter)
    local nTodayTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,2)
    local nPastTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,3)
    return (nTodayTimes + nPastTimes)
end

-- ===============================================================================================================
--  添加掩码，并设置掩码初始数据
-- ===============================================================================================================
function GetEMoney_Kill_Create(_idCharacter,_nOpenServerDay)
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity_Kill) then

        local nCombineTimes = System_GetCombinedTimes()
        
        System_AddTempData(_idCharacter,nLuaIdActivity_Kill,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,1,_nOpenServerDay,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,6,nCombineTimes,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,7,tGetEmoney_Kill_Info["openday"],false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,8,tGetEmoney_Kill_Info["overday"],false)
        -- 创建一个字符串做数据，key从 1~overday，作为初始数据
        local str = ""
        for i = 1,(tGetEmoney_Kill_Info["overday"]),1 do
            if  i == (tGetEmoney_Kill_Info["overday"]) then
                str = str .. "0,0"
            else
                str = str .. "0,0" .. "|"
            end
        end
        System_SetTempDataStr(_idCharacter,nLuaIdActivity_Kill,str,false)
    end
end

-- ===============================================================================================================
--  重置数据并更新Str数据
-- ===============================================================================================================
function GetEMoney_Kill_Reset(_idCharacter,_nOpenServerDay)
    
    local nCombineTimes = System_GetCombinedTimes()
    if  nCombineTimes ~= System_GetTempData(_idCharacter,nLuaIdActivity_Kill,6) then
        System_DelTempData(_idCharacter,nLuaIdActivity_Kill,false)
        GetEMoney_Kill_Create(_idCharacter,_nOpenServerDay)        
    end
    -- 只在新服开
    if  0 ~= nCombineTimes then 
        return 
    end

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,8)

    -- 开服天数变化，需更新
    if  _nOpenServerDay ~= System_GetTempData(_idCharacter,nLuaIdActivity_Kill,1) then
        -- 活动结束后，领取奖励没有时限，需要一直记录本日是否充值
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,4,0,false)  -- 本日是否充值了

        local nOldDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,1)
        System_SetTempData(_idCharacter,nLuaIdActivity_Kill,1,_nOpenServerDay,false)    -- 天数

        -- 需要更新的时间 nOpenDay ~ (nOverDay + 1)
        if  nOpenDay <= _nOpenServerDay and  _nOpenServerDay <= (nOverDay + 1) then

            local nOldTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,2)    -- 昨天的次数
            local nPastTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,3)
            local tOld = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Kill),"|" )

            nPastTimes = nPastTimes + nOldTimes
            local nScore = (nOldTimes / tGetEmoney_Kill_Info["bossreward"]) * tGetEmoney_Kill_Info["getemoney2"] -- 昨天可领取的元宝数
            nScore = math.floor(nScore)
            tOld[nOldDay] = tostring(nScore) .. "," .. tostring(nOldTimes)
            local strNew = GetEMoney_Reset_Write(tOld)

            -- System_SetTempData(_idCharacter,nLuaIdActivity_Kill,1,_nOpenServerDay,false)    -- 天数
            System_SetTempData(_idCharacter,nLuaIdActivity_Kill,2,0,false)  -- 本日 龙山巡守 次数
            System_SetTempData(_idCharacter,nLuaIdActivity_Kill,3,nPastTimes,false) -- 过去的天数的 龙山巡守 的总共次数
            -- System_SetTempData(_idCharacter,nLuaIdActivity_Kill,4,0,false)  -- 本日是否充值了
            System_SetTempDataStr(_idCharacter,nLuaIdActivity_Kill,strNew,false)
        end
    end
end

-- ===============================================================================================================
--  判断当前是不是在活动开启时间
-- ===============================================================================================================
function GetEMoney_Kill_InActivity(_idCharacter,_nOpenServerDay,_nOsTime)
    _nOsTime = _nOsTime or os.time()

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,7)   -- 开启的天数
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,8)   -- 结束的天虎

    local nOpenTime = tGetEmoney_Kill_Info["opentime"]    -- 开启天的开启时间
    local nOverTime = tGetEmoney_Kill_Info["overtime"]    -- 结束天的结束时间
    
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