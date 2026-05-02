local nResId_Active = CRESOURCEFLOWACTION.eFT_GeteMoeny_Active
local nLuaIdActivity_Active = LUARESOURCEFLOWACTION[nResId_Active]
local tGetEmoney_Active_Info = _getemoney_Info["root"][1]["activegetemoney"][1]

--  Note:
--      data1：今天是开服第几天
--      data2：今天的活跃度
--      data3：之前天的总共的活跃度（真正的总数是 data2 + data3）
--      data4：今天是否充值了
--      data5：按照位置存储的，奖励是否领取标志
--      data6：合服次数
--      data7,data8：openDay 和 overDay 开始和关闭天数
--      dataStr:与开服天数对应的，每天可以得到的元宝("0,0|0,0|0,0")( "可领取元宝数，这一天的活跃度分数")
--              (字符串是有 从 1 ~ overDay 个记录的)
-- ===============================================================================================================
--	玩家登入(由 getmoney 调用，不主动触发)
-- ===============================================================================================================
function GetEMoney_Active_OnLogin(_idCharacter,_nOsTimes,_nOpenServerDay)
    GetEMoney_Active_Create(_idCharacter,_nOpenServerDay)
    GetEMoney_Active_Reset(_idCharacter,_nOpenServerDay)
end

-- ===============================================================================================================
--  玩家分数增加
-- ===============================================================================================================
function GetEMoney_Active_AddScore(_idCharacter,_nOpenServerDay,_nAddScore)
    if  true == GetEMoney_Active_InActivity(_idCharacter,_nOpenServerDay) then
        
        local nPastScore = System_GetTempData(_idCharacter,nLuaIdActivity_Active,3)
        local nOldScore = System_GetTempData(_idCharacter,nLuaIdActivity_Active,2)

        -- 算出来的最大的分数
        local nTotalLimit = ( tGetEmoney_Active_Info["maxemoney2"] / tGetEmoney_Active_Info["getemoney2"] ) * tGetEmoney_Active_Info["active"]
        if  (nPastScore + nOldScore) >= (nTotalLimit) then   -- 已经大于最大的就不再加了
            return
        end
        
        nOldScore = nOldScore + _nAddScore
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,2,nOldScore,false)

        -- 主动推送 活跃度数据
        GetEMoney_Syn_Type(_idCharacter,eGetEmoney_Action.eGA_Active)
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
function GetEMoney_Active_GetReward(_idCharacter,_nIndex,_nWantDouble)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_Active,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,8)

    -- 判断有效的index，会发不是这个子活动的 index 
    if  not (nOpenday <= _nIndex and _nIndex <= nOverDay) then
        -- L2C_DebugLog("::GetEMoney_Active_GetReward get error index:".._nIndex)
        return 0
    end

    -- 是否已经领取
    local nGetSign = System_GetTempData(_idCharacter,nLuaIdActivity_Active,5)
    local bGet = WCBit.GetBit(nGetSign,_nIndex)
    if  true == bGet then
        L2C_DebugLog("::GetEMoney_Active_GetReward had get")
        return 0
    end

    -- 能不能双倍
    local tReward = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Active),"|" )
    for k,v in pairs(tReward) do
        tReward[k] = System_Split(v,",")    -- "可领取元宝,这一天的活跃度分数"
    end
    local nNum = tReward[_nIndex][1] or 0
    nNum = tonumber(nNum)
    local nTodayRechargeSign = System_GetTempData(_idCharacter,nLuaIdActivity_Active,4)
    if  1 == nTodayRechargeSign and 1 == _nWantDouble then
        nNum = nNum * 2
    end

    -- 设置成已领取，发奖   
    nGetSign = WCBit.SetTrue(nGetSign,_nIndex)   
    if  true == System_SetTempData(_idCharacter,nLuaIdActivity_Active,5,nGetSign,false) then
        -- L2C_DebugLog("::GetEMoney_Active_GetReward send reward :"..nNum)		
        System_AwardVouchers(_idCharacter,nNum,nResId_Active)    
        return nNum
    else
        L2C_DebugLog("::GetEMoney_Active_GetReward set mask error")
        return 0
    end    
end

-- ===============================================================================================================
--  设置今天充值了
-- ===============================================================================================================
function GetEMoney_Active_Recharge(_idCharacter,_nOpenServerDay)
    local nOpenday = System_GetTempData(_idCharacter,nLuaIdActivity_Active,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,8)

    -- if  nOpenday <= _nOpenServerDay and _nOpenServerDay <= nOverDay then
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,4,1,false)
    -- end
end

-- ===============================================================================================================
--  玩家当前分数兑换的元宝数目
--  @_nToday 0 只有今天，1 所有的（默认0）
-- ===============================================================================================================
function GetEMoney_Active_NowEMoney(_idCharacter,_nToday)
    
    _nToday = _nToday or 0

    local nScore = 0
    if  0 == _nToday then   -- 只有今天
        nScore = System_GetTempData(_idCharacter,nLuaIdActivity_Active,2)
    else    -- 所有的活跃度分数
        nScore = GetEMoney_Active_NowAllScore(_idCharacter)
    end

    nScore = (nScore / tGetEmoney_Active_Info["active"]) * tGetEmoney_Active_Info["getemoney2"]
    nScore = math.floor(nScore)
    return nScore
end

-- ===============================================================================================================
--  玩家到今天当前的总分数
-- ===============================================================================================================
function GetEMoney_Active_NowAllScore(_idCharacter)
    local nToday = System_GetTempData(_idCharacter,nLuaIdActivity_Active,2)
    local nPast = System_GetTempData(_idCharacter,nLuaIdActivity_Active,3)
    return (nToday + nPast)
end

-- ===============================================================================================================
--  添加掩码，并设置掩码初始数据
-- ===============================================================================================================
function GetEMoney_Active_Create(_idCharacter,_nOpenServerDay)
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity_Active) then
        
        local nCombineTimes = System_GetCombinedTimes()

        System_AddTempData(_idCharacter,nLuaIdActivity_Active,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,1,_nOpenServerDay,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,6,nCombineTimes,false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,7,tGetEmoney_Active_Info["openday"],false)
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,8,tGetEmoney_Active_Info["overday"],false)
        -- 创建一个字符串做数据，key从 1~overday，作为初始数据
        local str = ""
        for i = 1,(tGetEmoney_Active_Info["overday"]),1 do
            if  i == (tGetEmoney_Active_Info["overday"]) then
                str = str .. "0,0"
            else
                str = str .. "0,0" .. "|"
            end
        end
        System_SetTempDataStr(_idCharacter,nLuaIdActivity_Active,str,false)
    end
end

-- ===============================================================================================================
--  重置数据并更新Str数据
-- ===============================================================================================================
function GetEMoney_Active_Reset(_idCharacter,_nOpenServerDay)
    
    local nCombineTimes = System_GetCombinedTimes() 
    if  nCombineTimes ~= System_GetTempData(_idCharacter,nLuaIdActivity_Active,6) then
        System_DelTempData(_idCharacter,nLuaIdActivity_Active,false)
        GetEMoney_Active_Create(_idCharacter,_nOpenServerDay)        
    end
    -- 只在新服开
    if  0 ~= nCombineTimes then 
        return 
    end

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,8)

    -- 开服天数变化，需更新
    if  _nOpenServerDay ~= System_GetTempData(_idCharacter,nLuaIdActivity_Active,1) then        
        -- 活动结束后，领取奖励没有时限，需要一直记录本日是否充值
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,4,0,false)    -- 本日是否充值

        local nOldDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,1)
        System_SetTempData(_idCharacter,nLuaIdActivity_Active,1,_nOpenServerDay,false)  -- 天数

        -- 需要更新的时间 nOpenDay ~ (nOverDay + 1)
        if  nOpenDay <= _nOpenServerDay and  _nOpenServerDay <= (nOverDay + 1) then  
            local nOldScore = System_GetTempData(_idCharacter,nLuaIdActivity_Active,2)  -- 昨天的活跃度
            local nTotalScore = System_GetTempData(_idCharacter,nLuaIdActivity_Active,3)
            local tOld = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Active),"|" )

            nTotalScore = nTotalScore + nOldScore       -- 过去天数总分
            local nScore = (nOldScore / tGetEmoney_Active_Info["active"]) * tGetEmoney_Active_Info["getemoney2"] -- 昨天的元宝
            nScore = math.floor(nScore)                 -- 最终元宝数目向下取整咯
            tOld[nOldDay] = tostring(nScore) .. "," .. tostring(nOldScore)
            local strNew = GetEMoney_Reset_Write(tOld)  -- 每天可领取元宝str            

            -- System_SetTempData(_idCharacter,nLuaIdActivity_Active,1,_nOpenServerDay,false)  -- 天数
            System_SetTempData(_idCharacter,nLuaIdActivity_Active,2,0,false)                -- 本日分数
            System_SetTempData(_idCharacter,nLuaIdActivity_Active,3,nTotalScore,false)      -- 之前天数的总分
            -- System_SetTempData(_idCharacter,nLuaIdActivity_Active,4,0,false)                -- 本日是否充值
            System_SetTempDataStr(_idCharacter,nLuaIdActivity_Active,strNew,false)
        end
    end
end

-- ===============================================================================================================
--  判断当前是不是在活动开启时间
-- ===============================================================================================================
function GetEMoney_Active_InActivity(_idCharacter,_nOpenServerDay,_nOsTime)
    _nOsTime = _nOsTime or os.time()

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,7)   -- 开启的天数
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity_Active,8)   -- 结束的天虎

    local nOpenTime = tGetEmoney_Active_Info["opentime"]    -- 开启天的开启时间
    local nOverTime = tGetEmoney_Active_Info["overtime"]    -- 结束天的结束时间
    
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