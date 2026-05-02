
-----------------------------------------------------------------------
                        ---- 图鉴任务 -----
-----------------------------------------------------------------------
local nFunctionId   = _task_tujian_Info['task_tujian'][1]['functionid'][1]['functionid']
local tPokedexDaily = _task_tujian_Info['task_tujian'][1]['daily'][1]           -- 任务的信息
local tPokedexExtra = _task_tujian_Info['task_tujian'][1]['emoney2reward'][1]   -- 完成任务的额外奖励
local tPokedexChapter = _task_tujian_Info['task_tujian'][1]['chapter']          -- 供选择的任务库

local nResId = ACTIONTYPE.eFT_Pokedex
local nQuestId_Pokedex = QUESTIDTYPE.Pokedex_Begin

local tTaskflag = {
    NoOpen  = 0,    -- 该任务未开启
    Doing   = 1,    -- 已经接取
    Complete = 2,   -- 任务完成（奖励未领取）
    HadReward = 3,  -- 任务完成，奖励已经领取了（每日次数到了，就保留在这个状态）
}

-- ////////////////////////// 一键完成任务的返回码
 local ePokedex_RetCode = {
	ePoke_Success = 0,		-- 成功
	ePoke_Null = 1,			-- 未知错误
    ePoke_NoOpen = 2,       -- 该功能未开启
	ePoke_NoVip = 3,        -- vip等级不够
	ePoke_LessTime = 4,     -- 次数不够了
	ePoke_LessMoney = 5,    -- 钱不够
}
local ePokedexToLua = {
	ePok_Info = 1,		-- 申请任务信息
	ePok_Complete = 2,	-- 一键完成任务
}
--
--  只会在 Pokedex_Reflesh（） 刷新函数和Pokedex_SetNewQuest（）领取任务函数Pokedex_OneKeyComplete（）一键完成任务数据直接大的修改
--  当 taskFlag = 0 的时候，其他的掩码数据（出来日期）均不做正确的保证

--  Note:
--      taskflag    任务的状态
--      progress    是杀怪的个数
--      data1       本日已完成的任务的个数
--      data2       当前接取的任务库id
--      data3       当前接取的子任务id
--		data4		当前接取的子任务要打的怪的id
--		data5 		当前任务要杀的怪的数量
--      data8       本日的时间记录

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  图鉴任务，玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Pokedex_OnLogin(_idCharacter,_nOsTimes)
    
    -- 取不到任务信息，就是还没有创建改任务数据库记录
    if  -1 == Quest_GetQuestFlag(_idCharacter,nQuestId_Pokedex) then
        Quest_AddNewQuest(_idCharacter,nQuestId_Pokedex,0)
    end

    -- 图鉴任务刷新
    Pokedex_Reflesh(_idCharacter,_nOsTimes,nQuestId_Pokedex)

    -- 上线同步包
    Pokedex_Syn_All(_idCharacter)
end
table.insert(tOnLoginActivity,Pokedex_OnLogin)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  图鉴任务，零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Pokedex_ZeroRefresh(_idCharacter,_nOsTimes)
    Pokedex_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,Pokedex_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  客户端发的包的总接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Pokedex_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
    if  (nil == _idCharacter) or (nResId ~= _nCActionType) or (nil == _nData3) or (nil == _nData4) or (nil == _nData5) then
        L2C_DebugLog("::GM_ChouJiang_Req error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nData3 or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
        return eGMChouJiang_RetCode.eGMCJ_Null
    end
    
    -- 申请图鉴任务的包
    if  _nData3 == ePokedexToLua.ePok_Info then        
        if  0 == System_OpenGuideFunction(_idCharacter,nFunctionId) and
            tTaskflag.NoOpen == Quest_GetQuestFlag(_idCharacter,nQuestId_Pokedex) then           
            -- 发现任务可以开了，接取一个新的任务
            Pokedex_SetNewQuest(_idCharacter)
        end
        Pokedex_Syn_All(_idCharacter)
        return 0
    end

    -- 申请一键完成的包
    if  _nData3 == ePokedexToLua.ePok_Complete then
        local code,nNowChapterId = Pokedex_OneKeyComplete(_idCharacter,_nData4)
        nNowChapterId = nNowChapterId or 0
        if  ePokedex_RetCode.ePoke_Success == code  then
            -- 记录经分
            Pokedex_Log_Data(_idCharacter,2,_nData4)

            -- 完成图鉴任务事件
            System_QuestCheck(_idCharacter,TASKTYPE.TujianComplete,_nData4)
        end
        -- 发送结果包
        Pokedex_Syn_Complete(_idCharacter,code,_nData4,nNowChapterId)
        -- 发一个同步包给客户端
        Pokedex_Syn_All(_idCharacter)
        return code
    end

end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = Pokedex_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  图鉴任务，杀怪接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Pokedex_KillMonster(_idCharacter,_nQuestId,_nMonsterId,_nNum)
    

    if  nQuestId_Pokedex ~= _nQuestId then
        return
    end

    -- L2C_DebugLog("::Pokedex_KillMonster (".._idCharacter..",".._nMonsterId..",".._nNum..")")

    -- 不再执行任务中
    if  tTaskflag.Doing ~=  Quest_GetQuestFlag(_idCharacter,nQuestId_Pokedex) then
        return 
    end
    
    -- 本日次数到上限后，nMonsterId = 0
    local nMonsterId = Quest_GetMask(_idCharacter,nQuestId_Pokedex,4)
    if  _nMonsterId == nMonsterId then
        -- 增加杀怪进度
        Quest_AddQuestProgess(_idCharacter,nQuestId_Pokedex,_nNum)

        local nProgess = Quest_GetQuestProgess(_idCharacter,nQuestId_Pokedex)
        local nWantProgess = Quest_GetMask(_idCharacter,nQuestId_Pokedex,5)

        if  nProgess >= nWantProgess then
            -- 任务完成！
            Pokedex_CompleteQuest(_idCharacter)

            -- 完成图鉴任务事件
            System_QuestCheck(_idCharacter,TASKTYPE.TujianComplete,1)
        else
            -- 发同步包
            Pokedex_Syn_All(_idCharacter)
        end
    end
end

-- ===============================================================================================================
--  图鉴任务，一键完成任务的包
--  @_nCount 要完成的任务数量
--  @return code,nNowChapterId
-- ===============================================================================================================
function Pokedex_OneKeyComplete(_idCharacter,_nCount)
    
    -- 检验任务状态，不能是未开启的
    if  tTaskflag.NoOpen == Quest_GetQuestFlag(_idCharacter,nQuestId_Pokedex) then
        return ePokedex_RetCode.ePoke_NoOpen
    end

    -- 检验vip等级要求
    local nVip = System_GetVipLevel(_idCharacter)
    local nNeedVip = tPokedexDaily['needvip']
    if  nNeedVip > nVip then
        return ePokedex_RetCode.ePoke_NoVip
    end

    -- 检验次数够不够
    local nTotalTimes = tPokedexDaily['tasknum']        
    local nHadDoneTimes = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
    local nTimes = nTotalTimes - nHadDoneTimes 
    if  _nCount > nTimes then
        return ePokedex_RetCode.ePoke_LessTime
    end

    -- 检验钱够不够
    local nNeedMoney = tPokedexDaily['paygold'] * _nCount
    if  false == System_SpendEmoney(_idCharacter,nNeedMoney,nResId) then
        return ePokedex_RetCode.ePoke_LessMoney
    end

    -- 条件满足，钱也扣了，设置数据库数据，并接取一个新的任务
    -- 完成任务数量
    local nCompleteNum = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
    nCompleteNum = nCompleteNum + _nCount
    Quest_SetMask(_idCharacter,nQuestId_Pokedex,1,nCompleteNum)

    -- 发放次数的奖励
    local nNowChapterId = Quest_GetMask(_idCharacter,nQuestId_Pokedex,2)
    for i = 1,_nCount,1 do
        Pokedex_SendReward(_idCharacter,nNowChapterId)
    end
   
    -- 判断需要发放完成了所有任务奖励
    if  nCompleteNum == nTotalTimes then
        Pokedex_All_SendReward(_idCharacter)
    end

    --  接取一个新的任务
    Pokedex_SetNewQuest(_idCharacter)

    return ePokedex_RetCode.ePoke_Success,nNowChapterId
end

-- ===============================================================================================================
--  图鉴任务，完成任务，刷一个新的任务
--  只在怪物检测完成的地方调用！
-- ===============================================================================================================
function Pokedex_CompleteQuest(_idCharacter)
    
    -- 设置当前任务已经完成（为领奖）
    Quest_SetQuestFlag(_idCharacter,nQuestId_Pokedex,tTaskflag.Complete)

    -- 增加完成任务次数
    local nCompleTimes = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
    nCompleTimes = nCompleTimes + 1
    Quest_SetMask(_idCharacter,nQuestId_Pokedex,1,nCompleTimes)

    -- 发送一个同步包给客户端
    Pokedex_Syn_All(_idCharacter)

    -- 设置奖励已经领取，发放奖励
    Quest_SetQuestFlag(_idCharacter,nQuestId_Pokedex,tTaskflag.HadReward)
    local nNowChapterId = Quest_GetMask(_idCharacter,nQuestId_Pokedex,2)
    Pokedex_SendReward(_idCharacter,nNowChapterId)

    -- 发放奖励结束，记录经分
    Pokedex_Log_Data(_idCharacter,1,1)

    -- 判断是不是可以领取全部完成的奖励
    if  nCompleTimes == tPokedexDaily['tasknum'] then
        Pokedex_All_SendReward(_idCharacter)
    end

    -- 发一个同步报给客户端
    Pokedex_Syn_All(_idCharacter)

    -- 再领取一个新的任务
    Pokedex_SetNewQuest(_idCharacter)

    -- 发一个同步报给客户端（接了新任务或是结束任务了）
    Pokedex_Syn_All(_idCharacter)
end

-- ===============================================================================================================
--  图鉴任务，每日刷新（上线、零点）
-- ===============================================================================================================
function Pokedex_Reflesh(_idCharacter,_nOsTimes,_nQuestId)    
    if  false == Pokedex_CheckQuestId(_nQuestId) then
        L2C_DebugLog("::Pokedex_AddQuest get a error quest id:"..tostring(_nQuestId))
        return
    end

    -- 活动未开启
    if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then        
        Quest_SetQuestFlag(_idCharacter,_nQuestId,tTaskflag.NoOpen)
        return            
    end
        
    local nToday = tonumber( os.date("%y%m%d",_nOsTimes) )
    local nSignDay = Quest_GetMask(_idCharacter,_nQuestId,8)
    if  nToday ~= nSignDay then
        -- 接受一个新的任务，刷掉昨天的数据
        -- 随机一个新的任务
        local nChapterId,nNewQuestId,nMonsterId,nKillNum = Pokedex_GetQuest(_idCharacter)
        if  nil == nChapterId or nil == nNewQuestId or nil == nMonsterId then
            L2C_DebugLog("::Pokedex_SetNewQuest error ("..(nChapterId or "nil").."|"..(nNewQuestId or "nil").."|"..(nMonsterId or "nil").."|"..(nKillNum or "nil")..")")
            Quest_SetQuestFlag(_idCharacter,_nQuestId,tTaskflag.NoOpen)
            return
        end

        -- 接受一个新的任务
        Quest_SetQuestFlag(_idCharacter,_nQuestId,tTaskflag.Doing)  --本日任务的状态
        Quest_SetQuestProgess(_idCharacter,_nQuestId,0)     -- 任务进度
        Quest_SetMask(_idCharacter,_nQuestId,1,0)           -- 本日已完成的任务个数
        Quest_SetMask(_idCharacter,_nQuestId,2,nChapterId)  -- 任务库id
        Quest_SetMask(_idCharacter,_nQuestId,3,nNewQuestId) -- 任务id
        Quest_SetMask(_idCharacter,_nQuestId,4,nMonsterId)  -- 任务要杀的怪的id
        Quest_SetMask(_idCharacter,_nQuestId,5,nKillNum)    -- 任务要杀的怪的数量
        Quest_SetMask(_idCharacter,_nQuestId,8,nToday)      -- 本日日期  
    end
end

-- ===============================================================================================================
--  获得一个新的图鉴任务，并设置数据库数据
--      1、默认任务功能已经开启(Foundid 开了)
--      2、会刷掉原有的任务
--  @return true/false
-- ===============================================================================================================
function Pokedex_SetNewQuest(_idCharacter,_nOsTimes)
    _nOsTimes = _nOsTimes or os.time()
    local nToday = tonumber( os.date("%y%m%d",_nOsTimes) )

    -- 随机一个新的任务
    local nChapterId,nNewQuestId,nMonsterId,nKillNum = Pokedex_GetQuest(_idCharacter)
    if  nil == nChapterId or nil == nNewQuestId or nil == nMonsterId then
        L2C_DebugLog("::Pokedex_SetNewQuest error ("..(nChapterId or "nil").."|"..(nNewQuestId or "nil").."|"..(nMonsterId or "nil").."|"..(nKillNum or "nil")..")")
        Quest_SetQuestFlag(_idCharacter,nQuestId_Pokedex,tTaskflag.NoOpen)
        return false
    end
    
    local nTodayDo = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
    local nTotalTimes = tPokedexDaily['tasknum']
    if  nTodayDo >= nTotalTimes then
        
        -- 本日任务次数到上限了！
        Quest_SetQuestFlag(_idCharacter,nQuestId_Pokedex,tTaskflag.HadReward)  --本日任务的状态
        Quest_SetQuestProgess(_idCharacter,nQuestId_Pokedex,0) -- 任务进度
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,2,0)       -- 任务库id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,3,0)       -- 任务id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,4,0)       -- 任务要杀的怪的id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,5,0)       -- 任务要杀的怪的数量
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,8,nToday)  -- 本日日期  
        return false
    else
        -- 接受一个新的任务
        Quest_SetQuestFlag(_idCharacter,nQuestId_Pokedex,tTaskflag.Doing)  --本日任务的状态
        Quest_SetQuestProgess(_idCharacter,nQuestId_Pokedex,0)     -- 任务进度        
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,2,nChapterId)  -- 任务库id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,3,nNewQuestId) -- 任务id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,4,nMonsterId)  -- 任务要杀的怪的id
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,5,nKillNum)    -- 任务要杀的怪的数量
        Quest_SetMask(_idCharacter,nQuestId_Pokedex,8,nToday)      -- 本日日期  
        return true
    end
end

-- ===============================================================================================================
--  根据玩家等级，随机出玩家选择的任务（返回空就是出错啦！）
--  @return 任务库id，子任务id，怪物id,数量
-- ===============================================================================================================
function Pokedex_GetQuest(_idCharacter)
    local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)

    for k,v in pairs(tPokedexChapter) do
        local nUpTaskLev = v['upTaskLev']
        local nDownTaskLev = v['downTaskLev']
        if  nUpTaskLev <= nLevel and nLevel <= nDownTaskLev then
            
            -- 随机一个任务库下的任务            
            local nMonsterKey = math.random( (#v['moster']))

            local nQuestId = tPokedexChapter[k]['id']               -- 任务库id
            local nKillNum = tPokedexChapter[k]['killnum']          -- 要杀的怪的数量
            local nSonQuestId = v['moster'][nMonsterKey]['id']     -- 子任务id
            local nMonsterId = v['moster'][nMonsterKey]['monster'] -- 怪物id

            -- L2C_DebugLog("::test ("..nQuestId..","..nSonQuestId..","..nMonsterId..","..nKillNum..")")
            return  nQuestId,nSonQuestId,nMonsterId,nKillNum
        end
    end
end

-- ===============================================================================================================
--  校验任务 id 是否在图鉴任务区域内
-- ===============================================================================================================
function Pokedex_CheckQuestId(_nQuestId)
    if  QUESTIDTYPE.Pokedex_Begin <= _nQuestId and _nQuestId <= QUESTIDTYPE.Pokedex_End then
        return true
    else
        return false
    end
end

-- ===============================================================================================================
--  发放普通任务完成奖励
--  @_nChapterId 任务库id
-- ===============================================================================================================
function Pokedex_SendReward(_idCharacter,_nChapterId)    
    local tRewardData = nil
    for k,v in pairs(tPokedexChapter) do
        if  v['id'] == _nChapterId then
            tRewardData = v
        end
    end
    if  nil == tRewardData then
        L2C_DebugLog("::Pokedex_SendReward nil data! :".._nChapterId)
        return
    end 
    
    local nMoney = tRewardData['money'] or 0
    local nEMoney = tRewardData['emoney2'] or 0
    local nExp = tRewardData['exp'] or 0
    
    local nResId_Simple = ACTIONTYPE.eFT_Pokedex   -- 正常完成任务的流向id

    System_AwardMoney(_idCharacter,nMoney,nResId_Simple)
    System_AwardVouchers(_idCharacter,nEMoney,nResId_Simple)
    System_AwardExp(_idCharacter,nExp,nResId_Simple)

    if  "table" == type(tRewardData['reward']) then
        for k,v in pairs(tRewardData['reward']) do
            local nItemId = v['item']
            local nNum = v['num']
            if 	false == System_AwardThingInBag(_idCharacter,nResId_Simple,nItemId,nNum) then
			    System_AwardThingQuestContainer(_idCharacter,nResId_Simple,nItemId,nNum)
		    end
        end 
    end
end
-- ===============================================================================================================
--  发放全部任务完成奖励
-- ===============================================================================================================
function Pokedex_All_SendReward(_idCharacter)    
    local nResId_Extra = ACTIONTYPE.eFT_Pokedex_Extra   -- 完成全部任务的流向id

    local nEMoney = tPokedexExtra['emoney2']
    System_AwardVouchers(_idCharacter,nEMoney,nResId_Extra)

    if  "table" == type(tPokedexExtra['itemreward']) then
        for k,v in pairs(tPokedexExtra['itemreward']) do
            local nItemId = v['item']
            local nNum = v['num']
            if 	false == System_AwardThingInBag(_idCharacter,nResId_Extra,nItemId,nNum) then
			    System_AwardThingQuestContainer(_idCharacter,nResId_Extra,nItemId,nNum)
		    end
        end
    end
end

-- ===============================================================================================================
--  发放图鉴任务的同步包
-- ===============================================================================================================
function Pokedex_Syn_All(_idCharacter)

    local nFlag = Quest_GetQuestFlag(_idCharacter,nQuestId_Pokedex)
    local nToDayDo = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
    local nChapterId = Quest_GetMask(_idCharacter,nQuestId_Pokedex,2)       -- 当前接取的任务库id
    local nMonsterId = Quest_GetMask(_idCharacter,nQuestId_Pokedex,3)       -- 接取的子任务id
    local nProgess = Quest_GetQuestProgess(_idCharacter,nQuestId_Pokedex)   -- 已经杀怪数量
    local nCompleteAll = 0  -- 本日任务次数是否全部完成了
    if  nToDayDo >= tPokedexDaily['tasknum'] then
        nCompleteAll = 1
    end

    -- L2C_DebugLog("::Pokedex_Syn_All ("..nFlag..","..nToDayDo..","..nChapterId..","..nMonsterId..","..nProgess..","..nCompleteAll..")")    
    System_Pokedex_Syn_All(_idCharacter,nFlag,nToDayDo,nChapterId,nMonsterId,nProgess,nCompleteAll)
end

-- ==============================================================================================================
--  一键完成任务回包
-- ===============================================================================================================
function Pokedex_Syn_Complete(_idCharacter,_nCode,_nCount,_nChapterId)
    -- L2C_DebugLog("::Pokedex_Syn_Complete (".._nCode..",".._nCount..",".._nChapterId..")")
    local nCount = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)   -- 最新的完成环数信息
    System_Pokedex_Syn_Complete(_idCharacter,_nCode,_nCount,_nChapterId,nCount)
end

-- ===============================================================================================================
--  图鉴的经分数据
--  @_nCompleteType 完成任务的方式 1 正常/ 2 一键完成
--  @_nCompleteCount 完成任务的数量
-- ===============================================================================================================
function Pokedex_Log_Data(_idCharacter,_nCompleteType,_nCompleteCount)
    _nCompleteCount = _nCompleteCount or 1
    local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
    local nCount = Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)   -- 当前完成任务的次数
       
    -- L2C_DebugLog("::Pokedex_Log_Data (".._idCharacter..","..nLevel..","..nCount..",".._nCompleteType..")")
    System_Pokedex_Log(_idCharacter,nLevel,nCount,_nCompleteType,_nCompleteCount)
end

-- ==============================================================================================================
--  取当前任务完成数量
-- ===============================================================================================================
function Pokedex_GetCurQuestFinishNum(_idCharacter)
	return Quest_GetMask(_idCharacter,nQuestId_Pokedex,1)
end
