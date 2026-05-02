
-- 记录全服玩家最高养成等级的

-- 土豪福利的，主题活动的活动类型
local RichWelfare_Type = {
    RWT_Mounts = 1, -- 坐骑
    RWT_Weapon = 2, -- 神兵
    RWT_Wing = 3,   -- 羽翼
    RWT_Treasure = 4, -- 法宝
    RWT_Cloak = 5, -- 披风
    RWT_Circle = 6, -- 法阵
}
function RichWelfare_Instance_GetTypeData() return RichWelfare_Type end

local tRichWelfare_ToChaInt = {}
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Mounts] = CHARACTER_INT.HORSE_STEPLEV
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Weapon] = CHARACTER_INT.CHARACTER_LEGENDARYWEAPON
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Wing] = CHARACTER_INT.WING_REALM
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Treasure] = CHARACTER_INT.CHARACTER_HEAVEN
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Cloak] = CHARACTER_INT.CHARACTER_PONCHO
tRichWelfare_ToChaInt[RichWelfare_Type.RWT_Circle] = CHARACTER_INT.CHARACTER_MATRIX
function RichWelfare_Instance_GetType_ToChaInt() return tRichWelfare_ToChaInt end

local RichWelfare_TypeKey = {}    -- 用来表示该类型存在的表
for k,v in pairs(RichWelfare_Type) do    
    RichWelfare_TypeKey[v] = 1
end

local nMailId = _richwelfare_Info['root'][1]['mail'][1]['mailid']
local tRichWelfare_Info = _richwelfare_Info['root'][1]['server']

local nResId = CRESOURCEFLOWACTION.eFT_RichWelfare_Instance
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

-- data1    0/1         按照位存储，本日指定主题活动的开启状态 0未开，1开启（对于整个活动，就是0全关，非0开）
-- data2                预留着，要来保存昨天的开启状态（位置用）
-- data3                今天是开服第几天
-- data4                子活动中，开的最久的那一个
-- dataStr  'x,x,x,'    指定主题活动类型的，当前服务器的最高等级

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  任一玩家登入触发的 instance 登入(零点刷新)
--  Note:
--  @_nOsTimes 参数不可靠，从无玩家触发进来的参数是错的
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_Instance_OnLogin(_nOsTimes)
    
    if  false == System_IsExistGlobalData(nLuaIdActivity) then
        System_AddGlobalData(nLuaIdActivity)
        local strInit = ''
        local nTypeNum = RichWelfare_Instance_GetTypeInfo()
        for i = 1,(nTypeNum),1 do
            if  '' == strInit then
                strInit = '1'
            else
                strInit = strInit..','..'1'
            end
        end        
        System_SetGlobalDataStr(nLuaIdActivity,strInit,false)    
    end

    -- 更新每日信息
    RichWelfare_Instance_Reflesh(_nOsTimes)
end
local nDayBeginTime = 0*100+0 -- 每天的0点0分
tTime_HM[nDayBeginTime] = tTime_HM[nDayBeginTime] or {}
table.insert(tTime_HM[nDayBeginTime],RichWelfare_Instance_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家提升任一主题日等级
--  @return true 触发了一次最高等级刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_Instance_Improve(_idCharacter,_nType,_nNewLevel)
    if  nil == _idCharacter or nil == _nType or nil == _nNewLevel then
        L2C_DebugLog('::richWelfare_Instance_Improve error ('..(_idCharacter or 'nil')..'|'..(_nType or 'nil')..'|'..(_nNewLevel or 'nil')..')')
        return false
    end
    
    if  nil == RichWelfare_TypeKey[_nType] then
        L2C_DebugLog('::richWelfare_Instance_Improve a nil type:' .. tostring(_nType))
        return false
    end

    local nStatus = System_GetGlobalData(nLuaIdActivity,1)    
    local bOpen = WCBit.GetBit(nStatus,_nType)
    if  true == bOpen then
        local tMacLevelInfo = RichWelfare_Instance_ReadRecord()
        if  _nNewLevel > tMacLevelInfo[_nType] then
            tMacLevelInfo[_nType] = _nNewLevel
            RichWelfare_Instance_WriteRecord(tMacLevelInfo)
            return true
        end
    end
    return false
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获取本日活动开启状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_Instance_TodayStatus()
    return System_GetGlobalData(nLuaIdActivity,1)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获取所有的类型信息
--  @return num
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_Instance_GetTypeInfo()
    local nNum = 0
    for k,v in pairs(RichWelfare_Type) do
        nNum = nNum + 1
    end
    return nNum
end

-- ===============================================================================================================
--  每日更新数据信息
-- ===============================================================================================================
function RichWelfare_Instance_Reflesh(_nOsTimes)
    
    -- 发生开服天数变化才会更新
    local nOpenServerDay = System_GetOpenServerDay()    
    if  nOpenServerDay ~= System_GetGlobalData(nLuaIdActivity,3) then

        -- 记录本日开服天数
        System_SetGlobalData(nLuaIdActivity,3,nOpenServerDay,false)
        
        -- 判断有没有配置合服数据,直接关闭活动
        local nServerKey = RichWelfare_Instance_GetServerKey()
        if  nil == nServerKey then
            System_SetGlobalData(nLuaIdActivity,1,0,false)  -- 活动不开启
            return
        end
        local tWelfareData = tRichWelfare_Info[nServerKey]['wealth']

        -- 遍历所以的开启的活动，依次判断开启状态,同时获得开的最久的活动（开服第几天）
        local nInit = 0
        local nMaxDay = 0
        for k,v in pairs(tWelfareData) do
            local nType = v['activity']
            local nOpenDay = v['day']
            local nContinueDay = v['continueday']

            -- 该活动正在开启
            if  nOpenDay<= nOpenServerDay and nOpenServerDay < (nOpenDay + nContinueDay) then            
                nInit = WCBit.SetTrue(nInit,nType)

                -- 记录下开启的子活动中进行的最久的时间
                if  (nOpenDay + nContinueDay) > nMaxDay then
                    nMaxDay = nOpenDay + nContinueDay
                end
            end
        end
        
        -- 记录信息
        System_SetGlobalData(nLuaIdActivity,1,nInit,false)  -- 本日活动信息
        System_SetGlobalData(nLuaIdActivity,4,nMaxDay,false)-- 子活动开的最久的天数

        
        -- 触发一次，获取全服最高数据的更新
        for k,v in pairs(tWelfareData) do
            local nActiveType = v['activity']
            local bOpen = WCBit.GetBit(nInit,nActiveType)
            if  true == bOpen then
                local nRankType = RichWelfare_Instance_GetRankType(nActiveType)                
                local nfirstCharacterId = System_GetRankInfo(nRankType,1)   -- 取得第一名的玩家id
                
                if  0 ~= nfirstCharacterId then
                    local nFirstLevel = System_GetAttrInt(nfirstCharacterId,tRichWelfare_ToChaInt[nActiveType])                    
                    RichWelfare_Instance_Improve(nfirstCharacterId,nActiveType,nFirstLevel)
                end        
            end
        end
        
    end
end

-- ===============================================================================================================
--  得到合服key(得到nil就不开活动)
-- ===============================================================================================================
function RichWelfare_Instance_GetServerKey()
    local nDefaultTimes = -1
    local nCombineTimes = System_GetCombinedTimes()

    local nDefaultKey = nil
    for k,v in pairs(tRichWelfare_Info) do
        if  nCombineTimes == v['servernum'] then
            return k
        end 
        if  nDefaultTimes == v['servernum'] then
            nDefaultKey = k
        end
    end
    return nDefaultKey
end

-- ===============================================================================================================
--  得到所有子活动的最后一个结束的
-- ===============================================================================================================
function RichWelfare_Instance_GetLastDay()
    return System_GetGlobalData(nLuaIdActivity,4)
end

-- ===============================================================================================================
--  获取当前服务器最高等级信息
-- ===============================================================================================================
function RichWelfare_Instance_ReadRecord_Str()
    return System_GetGlobalDataStr(nLuaIdActivity)
end

-- ===============================================================================================================
--  根据活动的type，获得排行榜数据接口的类型
-- ===============================================================================================================
function RichWelfare_Instance_GetRankType(_nType)
    if  _nType == RichWelfare_Type.RWT_Mounts then
        return eRankListType.eRLT_Horse
        
    elseif  _nType == RichWelfare_Type.RWT_Weapon then
        return eRankListType.eRLT_LegendaryWeapon

    elseif  _nType == RichWelfare_Type.RWT_Wing then
        return eRankListType.eRLT_Wing

    elseif  _nType == RichWelfare_Type.RWT_Treasure then
        return eRankListType.eRLT_Talisman

    elseif  _nType == RichWelfare_Type.RWT_Cloak then
        return eRankListType.eRLT_Poncho

    elseif  _nType == RichWelfare_Type.RWT_Circle then
        return eRankListType.eRLT_MatrixMethod

    else
        L2C_DebugLog('::RichWelfare_Instance_GetRankType get a error type:'..tostring(_nType))        
    end
    return eRankListType.eRLT_Unkown
end

-- ===============================================================================================================
--  获取当前服务器最高等级信息
-- ===============================================================================================================
function RichWelfare_Instance_ReadRecord()
    local str = System_GetGlobalDataStr(nLuaIdActivity)

    local tRet = System_Split(str,",")
    for k,v in pairs(tRet) do
        tRet[k] = tonumber(v)
    end
    return tRet
end

-- ===============================================================================================================
--  保存当前服务器最高等级信息
-- ===============================================================================================================
function RichWelfare_Instance_WriteRecord(_t)
    local str = ''
    for k,v in ipairs(_t) do
        if  '' == str then
            str = tostring(v)
        else
            str = str..','..tostring(v)
        end
    end
    System_SetGlobalDataStr(nLuaIdActivity,str,false)
end