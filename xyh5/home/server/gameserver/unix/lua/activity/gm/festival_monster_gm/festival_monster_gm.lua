local nResId = CRESOURCEFLOWACTION.eFT_FestivalMonster
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local tFestivalMonster_Inof = _shuaguaihuodong_Info['root'][1]['openday'][1]
local nOpenLevel = tFestivalMonster_Inof['lv']
local tMonsterData = {} -- [group-id] - value 的表
for k,v in pairs(tFestivalMonster_Inof['group']) do
    local new_k = v['id']
    tMonsterData[new_k] = v
end

-- Note:
--  data1：本日活动是否开启（不是刷怪开启）
--  data2：GM 设置的开始时间戳
--  data3：GM 设置的结束时间戳
--  data4：GM 设置的进行的 group id

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  由 GM 命令调用进来的设置活动数据
--  @_nOpenId 要开启的group 下的 id
--  @_nBeginTime 开始时间戳
--  @_nEndTime 结束时间戳
--  @_nOsTimes 当前时间戳
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalMonster_instance_SetData(_nOpenId,_nBeginTime,_nEndTime,_nOsTimes)

    -- 没有这个配置数据
    if  'table' ~= type(tMonsterData[_nOpenId]) then
        -- L2C_DebugLog('::GM_FestivalMonster_instance_SetData error group id:'..tostring(_nOpenId))
        return eFestivalGMProcessMsgcode.eFestivalGMMC_NoCfg
    end

    GM_FestivalMonster_instance_CreateDB()
    
    -- 活动正在进行
    if  1 == System_GetGlobalData(nLuaGlobal,1) then
        return eFestivalGMProcessMsgcode.eFestivalGMMC_InActivity
    end

    -- 开始,结束时间必须是 0 点
    if  _nBeginTime ~= System_GetZeroTime(_nBeginTime) or
        _nEndTime ~= System_GetZeroTime(_nEndTime) then
        return eFestivalGMProcessMsgcode.eFestivalGMMC_StarttimeNotZero
    end

    -- 开始结束时间要正确
    if  _nEndTime <= _nBeginTime then
        return eFestivalGMProcessMsgcode.eFestivalGMMC_EndtimeLessThanTorZero
    end
    
    -- 活动开启时间，不能比今天 更早 
    if  _nBeginTime < System_GetZeroTime(_nOsTimes) then     
        return eFestivalGMProcessMsgcode.eFestivalGMMC_StartimeLessThanTorZero
    end


    -- 记录数据
    System_SetGlobalData(nLuaGlobal,1,0,false)
    System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)    -- 开始时间
    System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)      -- 结束时间
    System_SetGlobalData(nLuaGlobal,4,_nOpenId,false)       -- 选择开放的 id

    -- 主动触发一次零点刷新函数
    GM_FestivalMonster_instance_ZeroFresh()

    return eFestivalGMProcessMsgcode.eFestivalGMMC_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  由GM 进来，设置活动结束时间
--  @_nEndTime 结束时间戳
--  @_nOSTime 当前时间戳
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalMonster_instance_SetEndData(_nEndTime,_nOSTime)
    
    -- 活动已经结束
    if  0 == System_GetGlobalData(nLuaGlobal,1) or
        -1 == System_GetGlobalData(nLuaGlobal,1) then
        return eFestivalGMProcessMsgcode.eFestivalGMMC_HadEnd
    end

    -- 结束时间不是 0 点
    if  _nEndTime ~= System_GetZeroTime(_nEndTime) then
        return eFestivalGMProcessMsgcode.eFestivalGMMC_EndtimeNotZero
    end

    -- 结束时间要比现在时间远！
    if  _nEndTime < System_GetZeroTime(_nOSTime) then
         return eFestivalGMProcessMsgcode.eFestivalGMMC_EndtimeLessThanTorZero
    end

    GM_FestivalMonster_instance_CreateDB()
    
    System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)

    -- 主动触发一次零点刷新函数
    GM_FestivalMonster_instance_ZeroFresh()

    return eFestivalGMProcessMsgcode.eFestivalGMMC_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得gm配置的数据
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalMonster_instance_GetData(_nType)
    GM_FestivalMonster_instance_CreateDB()

    -- 活动状态
    if  eFestivalGetActiveInfo.eFGAI_Status == _nType then
        return System_GetGlobalData(nLuaGlobal,1)
    end

    -- 活动开始时间戳
    if  eFestivalGetActiveInfo.eFGAI_StartTime == _nType then
        return System_GetGlobalData(nLuaGlobal,2)
    end

    -- 活动结束时间戳
    if  eFestivalGetActiveInfo.eFGAI_EndTime == _nType then
        return System_GetGlobalData(nLuaGlobal,3)
    end

    -- 选择的数据
    if  eFestivalGetActiveInfo.eFGAI_Cfgid == _nType then
        return System_GetGlobalData(nLuaGlobal,1)
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  c++主动调用一次找lua要数据
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalMonster_instance_GetStatus(_nData1,_nCActionType,_nData3,_nData4,_nData5)
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::GM_FestivalMonster_instance_GetStatus Error Type Get Data From Lua !!!")
		return -1
	end

	-- 服务器开启，判断一次活动状态
    GM_FestivalMonster_instance_ZeroFresh()
        
    return 0
end
tGetActivityData[nResId] = GM_FestivalMonster_instance_GetStatus

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  怪物被击杀时候的接口
--  @_CharacterId   参加打怪的玩家id  
--  @_nCActionType  定义的资源流向    
--  @_nGroupId      进行的活动的id
--  @_nMapId        地图id
--  @_nMonsterId    打死的怪的id
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalMonster_instance_BeKill(_CharacterId,_nCActionType,_nGroupId,_nMapId,_nMonsterId)
    
    if  (nil == _CharacterId) or (nil == _nCActionType) or (nil == _nGroupId) or (nil == _nMapId) or (nil == _nMonsterId) then
        L2C_DebugLog("::GM_FestivalMonster_instance_BeKill error ("..(_CharacterId or "nil").."|"..(_nCActionType or "nil").."|"..(_nGroupId or "nil").."|"..(_nMapId or "nil").."|"..(_nMonsterId or "nil")..")")
        return 1
    end

    GM_FestivalMonster_instance_CreateDB()

    -- 本日没活动
    if  0 == System_GetGlobalData(nLuaGlobal,1) then
        L2C_DebugLog('::GM_FestivalMonster_instance_BeKill today not activity!!!')
        return 1
    end

    -- 校验 groupid
    local nSignId = System_GetGlobalData(nLuaGlobal,4)
    if  _nGroupId ~= nSignId then
        L2C_DebugLog('::GM_FestivalMonster_instance_BeKill id error,get:'..tostring(_nGroupId)..',sign:'..nSignId)
        return 1
    end
    
    -- 校验怪物，玩家当前是否在同一地图
    local nChaInMapId = System_GetCharacterScene(_CharacterId)
    if  nChaInMapId ~= _nMapId then
        -- L2C_DebugLog('::GM_FestivalMonster_instance_BeKill not in same map !!!')        
        return 1
    end

    -- 校验玩家等级是否够了
    local nMyLevel = System_GetAttrInt(_CharacterId,CHARACTER_INT.LEVEL)
    if  nOpenLevel > nMyLevel then
        -- L2C_DebugLog('::GM_FestivalMonster_instance_BeKill level not enough !!!')        
        return 1
    end

    -- 去发放奖励
    GM_FestivalMonster_instance_SendReward(_CharacterId,_nGroupId)
    return 0
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = GM_FestivalMonster_instance_BeKill

-- ===============================================================================================================
--  每日零点刷新
--  判断本日是不是可以开启功能了
-- ===============================================================================================================
function GM_FestivalMonster_instance_ZeroFresh()   
   GM_FestivalMonster_instance_CreateDB()
   local NowTime = os.time()
   
   local nBeginTimes = System_GetGlobalData(nLuaGlobal,2)
   local nEndTimes = System_GetGlobalData(nLuaGlobal,3)

   -- 判断活动本日是否开启
   if  nBeginTimes <= NowTime and NowTime < nEndTimes and 
       nBeginTimes < nEndTimes then            
       System_SetGlobalData(nLuaGlobal,1,1,false)   -- 活动开启
   else       
       System_SetGlobalData(nLuaGlobal,1,0,false)   -- 活动结束
   end
   
   local nStatus = System_GetGlobalData(nLuaGlobal,1)
   local nGroupId = System_GetGlobalData(nLuaGlobal,4)

   -- 发消息给c++刷怪部分
   GM_FestivalMonster_instance_ToC_Open(nStatus,nGroupId,nBeginTimes,nEndTimes)
end
local nDayBeginTime = 0*100+0           -- 每天的0点0分
tTime_HM[nDayBeginTime] = tTime_HM[nDayBeginTime] or {}
table.insert(tTime_HM[nDayBeginTime],GM_FestivalMonster_instance_ZeroFresh)

-- ===============================================================================================================
--  随机取奖励，并发放邮件
-- ===============================================================================================================
function GM_FestivalMonster_instance_SendReward(_idCharacter,_nGroupId)   
    -- 获得备选奖励数据 
    if  'table' ~= type(tMonsterData[_nGroupId]['reward'][1]) then        
        L2C_DebugLog('::GM_FestivalMonster_instance_SendReward error groupid:'..tostring(_nGroupId)..',characterid:'..tostring(_idCharacter))
        return
    end

    -- 获得备选的奖励
    local nMailId = tMonsterData[_nGroupId]['mail']
    local nRewardNum = tMonsterData[_nGroupId]['reward'][1]['random']
    local tRewardData = {}

    -- 只有配置了有效权重才能进入备选奖励库
    for k,v in pairs(tMonsterData[_nGroupId]['reward'][1]['item']) do
        if  'number' == type(v['weight']) and v['weight'] > 0 then
            table.insert(tRewardData,v)
        end
    end
    
    -- 备选奖励数量不够
    if  (#tRewardData) < nRewardNum then        
        L2C_DebugLog('::GM_FestivalMonster_instance_SendReward for random num less !!!,groupid:'..tostring(_nGroupId)..',characterid:'..tostring(_idCharacter))
        return
    end

    -- 进行随机取的奖励
    local tCanGetReward = {}
    for i = 1,nRewardNum,1 do       
        -- 计算权重 
        local nTotalWeight = 0
        for k,v in pairs(tRewardData) do
            nTotalWeight = nTotalWeight + v['weight']
        end

        -- 获得一个随机权重值，已获得的奖励出表，进行下一次取值
        local nRan = math.random(nTotalWeight)
        for k,v in pairs(tRewardData) do
            local nReduceWie = v['weight']
            if  nRan > nReduceWie then
                nRan = nRan - nReduceWie
            else
                table.insert(tCanGetReward,v)
                table.remove(tRewardData,k) -- 已获得物品出备选表
                break
            end
        end
    end

    -- 发送奖励邮件
    local sItem = ''
    local sLog = ''
    for k,v in pairs(tCanGetReward) do
        local nItem = v['item']
        local nNum = v['num']
        if  '' == sItem then
            sItem = tostring(nItem)..','..tostring(nNum)..',0;'
            sLog = tostring(nItem)..','..tostring(nNum)..';'
        else
            sItem = sItem .. tostring(nItem)..','..tostring(nNum)..',0;'
            sLog = sLog..tostring(nItem)..','..tostring(nNum)..';'
        end
    end

    -- 发放邮件，记录经分
    -- L2C_DebugLog('::GM_FestivalMonster_instance_SendReward send mail item:'..sItem..',mailId:'..nMailId)
    System_SendMail(_idCharacter,nMailId,sItem)
    GM_FestivalMonster_instance_WriteLog(_idCharacter,_nGroupId,sLog)
end

-- ===============================================================================================================
--  创建数据库记录 
-- ===============================================================================================================
function GM_FestivalMonster_instance_CreateDB()
    if  false == System_IsExistGlobalData(nLuaGlobal) then
        System_AddGlobalData(nLuaGlobal,false)
    end
end

-- ===============================================================================================================
--  调用c++ 接口开启/结束本日活动
--  @_nOpen     1开启，0 结束
--  @_nGroupId  要开启的活动的id
--  @_nBeginTime GM设置的开始时间戳 
--  @_nEndTime  GM设置的结束时间戳
-- ===============================================================================================================
function GM_FestivalMonster_instance_ToC_Open(_nOpen,_nGroupId,_nBeginTime,_nEndTime)
    
    -- L2C_DebugLog('::GM_FestivalMonster_instance_ToC_Open ('.._nOpen..','.._nGroupId..','.._nBeginTime..','.._nEndTime..')')
    System_Festival_Monster_Gm(_nOpen,_nGroupId,_nBeginTime,_nEndTime)
end

-- ===============================================================================================================
--  写经分数据
--  @_nGroupId 领取的奖励属于的 groupid
--  @_strReward 奖励字符串 'item,num;'
-- ===============================================================================================================
function GM_FestivalMonster_instance_WriteLog(_idCharacter,_nGroupId,_strReward)
        
    local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
    
    -- L2C_DebugLog('::GM_FestivalMonster_instance_WriteLog ('.._idCharacter..','..nLevel..','.._nGroupId..','.._strReward..')')
    System_Festival_Monster_Log(_idCharacter,nLevel,_nGroupId,_strReward)
end
