--处理数据
local tQuestGuildInfo = _task_guild_Info.task_guild[1].guild[1]
local tQuestGuildFuncId = tQuestGuildInfo.functionid

for key,val in pairs(tQuestGuildInfo.taskroom) do
	--处理任务库
	for k,v in pairs(val.task) do
		if nil ~= tQuestInfo[v.taskId] then
			L2C_DebugLog("guild_quest_data DuplicateKey"..v.taskId)
		end
		tQuestInfo[v.taskId] = {}
		tQuestInfo[v.taskId]["TaskRoom"] = val.taskroom
		tQuestInfo[v.taskId]["TaskType"] = 12-- TASKTYPE.KillMonster
		tQuestInfo[v.taskId]["Condition"] = {v.monsterId,v.num}
		if "table" == type(v.item) then
			tQuestInfo[v.taskId]["AddItem"] = {}
			for l,w in pairs(v.item) do
				tQuestInfo[v.taskId]["AddItem"][l] = {w.itemid,w.num}
			end
		end

		if "number" == type(v.exp) and v.exp > 0 then
			tQuestInfo[v.taskId]["AddExp"] = v.exp
		end
		if "number" == type(v.money) and v.money > 0 then
			tQuestInfo[v.taskId]["AddMoney"] = "number" == type(v.money) and v.money or 0
		end
		--这个改为物品给
		--if "number" == type(v.contribution) and v.contribution > 0 then
		--	tQuestInfo[v.taskId]["AddContribution"] = v.contribution
		--end

	end
end
local tGuildLevelRoom = {}
for k,v in pairs(tQuestGuildInfo.player) do
	for i = v.minLev,v.maxLev do
		tGuildLevelRoom[i] = tQuestGuildInfo.player[k]
	end
end


function GuildQuest_Check(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	if 1 ~= Quest_GetQuestFlag(_idCharacter,_nQuestId) then
		return
	end
	local nCurQuest = Quest_GetMask(_idCharacter,_nQuestId,6)
	--如果没有宗族  进行任务判断  
	if false == System_IsHaveGuild(_idCharacter) then				
		-- 如果任务存在删除任务
		if nCurQuest ~= _nQuestId then
			Quest_DeleteQuest(_idCharacter,_nQuestId)
		end
		return
	end

	--怪物ID
	if nil == tQuestInfo[nCurQuest] or nil == tQuestInfo[nCurQuest]["Condition"] or "number" ~= type(tQuestInfo[nCurQuest]["Condition"][1]) 
		or  "number" ~= type(tQuestInfo[nCurQuest]["TaskType"]) or _nTaskType ~= tQuestInfo[nCurQuest]["TaskType"]
	then
		return
	end

	if _nData1 == tQuestInfo[nCurQuest]["Condition"][1] then
		-- L2C_DebugLog("C2L_QuestCheck NPC 怪物：".._nData1.."|".._nData2)
		_nCount = _nData2 or 1
		if _nCount == 0 then _nCount = 1 end	

		
		local nProgess = Quest_GetQuestProgess(_idCharacter,_nQuestId)
		local nRequire =  tQuestInfo[nCurQuest]["Condition"][2]
		
		if nProgess + _nCount < nRequire then
			Quest_AddQuestProgess(_idCharacter, _nQuestId, _nCount)
		else
			Quest_SetQuestProgess(_idCharacter, _nQuestId, nRequire)
			local nFinished = Quest_GetMask(_idCharacter,_nQuestId,1)
			Quest_SetMask(_idCharacter,_nQuestId,1,nFinished + 1)
			Quest_QuestFinishCondition(_idCharacter,_nQuestId)
		end
	end
end

function GuildQuest_Random(_nData1)
	--_nData1   等级
	if nil == _nData1 then 
		return 0
	end
	local nTaskRoom = tGuildLevelRoom[_nData1].taskroom
	
	for i,v in pairs(tQuestGuildInfo.taskroom) do
		if nTaskRoom == v.taskroom then
			local nRan = math.random(1,#v.task)
			return (v.task[nRan].taskId or 0 )
		end
	end
	return 0
end

function GuildQuest_OneKeyReward(_idCharacter,_nQuestId,_nTaskNum)
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	local nVipLevel = System_GetVipLevel(_idCharacter) 
	local nExp,nMoney,nContribution = tGuildLevelRoom[nLevel]["exp"],tGuildLevelRoom[nLevel]["money"],tGuildLevelRoom[nLevel]["contribution"]
	local tItem = tGuildLevelRoom[nLevel]["item"]
	
	local nFinished = Quest_GetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1)
	if tQuestGuildInfo.tasknum <= nFinished then
		return 2 -- eGQMC_NoQuest// 没有接受任务
	end
	
	if "number" == type(tQuestGuildInfo.quickvip) and tQuestGuildInfo.quickvip > nVipLevel then
		return 8 -- eGQMC_Vip // vip等级不足
	end
	
	-- local nQuestNum =  tQuestGuildInfo.tasknum - nFinished	
	local nQuestNum = _nTaskNum or 1
	--不能超过当前可完成数
	if nQuestNum >  tQuestGuildInfo.tasknum - nFinished	 then
		nQuestNum = tQuestGuildInfo.tasknum - nFinished	
	end
	
	if false == System_SpendEmoney(_idCharacter,tQuestGuildInfo.quickcost * nQuestNum ,ACTIONTYPE.eFT_GuildQuestOneKey) then
		return 7 -- eGQMC_EMoney 元宝不足
	end
	--以下重复发奖了  奖励已直接按当前任务给
	-- GuildQuest_OnQuestReward(_idCharacter,_nQuestId,nQuestNum,tQuestGuildInfo.quickco)
	local nQuickCo = tQuestGuildInfo.quickco or 0
	local nFinished = Quest_GetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1)
	Quest_SetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1,nFinished + nQuestNum)
	if "number" == type(nExp) then		
		System_AwardExp(_idCharacter,(nExp + math.floor(nExp * nQuickCo / 10000)) * nQuestNum,ACTIONTYPE.eFT_GuildQuestOneKey )
	end
	if "number" == type(nMoney) then
		System_AwardMoney(_idCharacter,(nMoney + math.floor(nMoney * nQuickCo / 10000)) * nQuestNum ,ACTIONTYPE.eFT_GuildQuestOneKey )
	end
	-- if "number" == type(nContribution) then
		-- System_AwardContribution(_idCharacter,(nContribution + math.floor(nContribution * nQuickCo / 10000))  * nQuestNum  ,ACTIONTYPE.eFT_GuildQuestOneKey )
	-- end	
	
	if "table" == type(tItem) then
		for k,v in pairs(tItem) do
			if nil ~= v.itemid and nil ~= v.num then
				if false == System_AwardThingInBag(_idCharacter,ACTIONTYPE.eFT_GuildQuestOneKey,v.itemid,((math.floor(v.num * nQuickCo / 10000)) + v.num) * nQuestNum) then
					System_AwardThingQuestContainer(_idCharacter,ACTIONTYPE.eFT_GuildQuestOneKey,v.itemid,((math.floor(v.num * nQuickCo / 10000)) + v.num) * nQuestNum)
				end
			end
		end
	end	
	--委托全部任务的话
	if nQuestNum == tQuestGuildInfo.tasknum - nFinished	 then		
		Quest_SetQuestFlag(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,3)			
	else
		Quest_SetQuestProgess(_idCharacter, QUESTIDTYPE.GuildQuest_Begin, 0)
		local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
		Quest_SetMask(_idCharacter, QUESTIDTYPE.GuildQuest_Begin, 4,tGuildLevelRoom[nLevel].taskroom)
		Quest_SetMask(_idCharacter, QUESTIDTYPE.GuildQuest_Begin, 6,GuildQuest_Random(nLevel))
	end
	return 1 -- eGQMC_Success //成功
end

--宗族任务登录处理
function OnGuildQuestLogin(_idCharacter,_nOsTimes)
	nTime = _nOsTimes or os.time()	
	local nCurDate = tonumber(os.date("%Y%m%d",nTime))
	if true == System_IsHaveGuild(_idCharacter) and 0 == System_OpenGuideFunction(_idCharacter,tQuestGuildFuncId) then
		Quest_AcceptGuildQuest(_idCharacter)
	end
end

function GuildQuest_OnQuestReward(_idCharacter,_nQuestId,_nQuestNum,_nQuickCo)
	_nQuestNum = _nQuestNum or 1
	_nQuickCo = _nQuickCo or 0
	local nCurQuest = _nQuestId
	if _nQuestId == QUESTIDTYPE.GuildQuest_Begin then
		nCurQuest = Quest_GetMask(_idCharacter,_nQuestId,6)
	end
	-- L2C_DebugLog(tostring(nCurQuest).."_nQuestId:"..tostring(_nQuestId))
	if nil ~= tQuestInfo[nCurQuest]["AddExp"] then
		local nExp = tQuestInfo[nCurQuest]["AddExp"]
		--L2C_DebugLog("C2L_SpecialAward_Exp:"..nExp)
		System_AwardExp(_idCharacter,(nExp + math.floor(nExp * _nQuickCo / 10000)) * _nQuestNum ,ACTIONTYPE.eFT_GuildQuestOneKey )
	end
	if nil ~= tQuestInfo[nCurQuest]["AddMoney"] then
		local nMoney = tQuestInfo[nCurQuest]["AddMoney"]
		--L2C_DebugLog("C2L_SpecialAward_Money:"..nMoney)
		System_AwardMoney(_idCharacter,(nMoney + math.floor(nMoney * _nQuickCo / 10000)) * _nQuestNum ,ACTIONTYPE.eFT_GuildQuestOneKey )
	end
	-- if nil ~= tQuestInfo[nCurQuest]["AddContribution"] then
		-- local nContribution = tQuestInfo[nCurQuest]["AddContribution"]
		-- L2C_DebugLog("C2L_SpecialAward_Contribution:"..nContribution)
		-- System_AwardContribution(_idCharacter,(nContribution + math.floor(nContribution * _nQuickCo / 10000))  * _nQuestNum ,ACTIONTYPE.eFT_GuildQuestOneKey )
	-- end	
	
	if "table" == type(tQuestInfo[nCurQuest]["AddItem"]) then
		for k,v in pairs(tQuestInfo[nCurQuest]["AddItem"]) do
			if nil ~= v[1] and nil ~= v[2] then
				if false == System_AwardThingInBag(_idCharacter,ACTIONTYPE.PLOTQUEST, v[1], (v[2] + math.floor(v[2] * _nQuickCo / 10000)) * _nQuestNum,v[3] or 0) then
					System_AwardThingQuestContainer(_idCharacter,ACTIONTYPE.PLOTQUEST, v[1],(v[2] + math.floor(v[2] * _nQuickCo / 10000)) * _nQuestNum,v[3] or 0)
				end
			end
		end
	end	
	
	local nFinished = Quest_GetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1)
	--Quest_SetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1,nFinished + _nQuestNum)
	if tQuestGuildInfo.tasknum > nFinished then
		Quest_AcceptGuildQuest(_idCharacter)
	end	
end
--完成所有任务的额外奖励
function GuildQuest_CompleteAll(_idCharacter,_nLevel)		
	local tEX = tQuestGuildInfo.extrareward[1]
	local nTempLevel = tEX.playerlev
	for k,v in pairs(tQuestGuildInfo.extrareward) do
		if nTempLevel <  v.playerlev and _nLevel > v.playerlev then
			tEX = tQuestGuildInfo.extrareward[k]
			nTempLevel = tEX.playerlev
		end
	end	
	--比所有配置都小
	if _nLevel < nTempLevel then
		--1是成功
		return 1
	end
	
	local nExp,nMoney,nContribution = tEX["exp"],tEX["money"],tEX["contribution"]
	if "number" == type(nExp) then		
		System_AwardExp(_idCharacter,nExp,ACTIONTYPE.eFT_GuildQuestCompleteAll )
	end
	if "number" == type(nMoney) then
		System_AwardMoney(_idCharacter,nMoney,ACTIONTYPE.eFT_GuildQuestCompleteAll )
	end
	-- if "number" == type(nContribution) then
		-- System_AwardContribution(_idCharacter,nContribution ,ACTIONTYPE.eFT_GuildQuestCompleteAll )
	-- end	
	if "table" == type(tEX.item) then
		-- 判断背包能不能放得下        
		local strItem = ""   -- item,num;item2,num2;
		for  k,v in pairs(tEX.item) do
			strItem = strItem .. tostring(v["itemid"]) .. ","..tostring(v["itemnum"]) .. ";"   
		end
			
        if  false == System_CanPushThingsToBagEx(_idCharacter,strItem) then
            -- 发邮件            
            local sItem = ""    -- _sItem格式 "item,num,stage;item2,num2,stage2;"
            for k,v in pairs(tEX.item) do
                local nItemId = v["itemid"]
                local nNum = v["itemnum"]
                local nStage = v["stage"] or 0
                sItem = sItem .. tostring(nItemId)..","..tostring(nNum)..","..tostring(nStage)..";"
            end
            local nMailId = tQuestGuildInfo["extramailid"]
            System_SendMail(_idCharacter,nMailId,sItem)
        else
            -- 直接发奖            
            for k,v in pairs(tEX.item) do                
                local nItemId = v["itemid"]
                local nNum = v["itemnum"]
                System_AwardThingInBag(_idCharacter,ACTIONTYPE.eFT_GuildQuestCompleteAll,nItemId,nNum)
            end
        end
	end
	return 1
end
--取当前家族任务的完成数量
function GuildQuest_GetCurQuestFinishNum(_idCharacter)
	--//没有家族
	-- if 0 == System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_GUILD_ID) then
		-- return 0
	-- end
	-- //没有家族任务
	if -1 == Quest_GetQuestFlag(_idCharacter,QUESTIDTYPE.GuildQuest_Begin) then
		return 0
	end
	return Quest_GetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,1)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级处理
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GuildQuest_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	 OnGuildQuestLogin(_idCharacter,_nOsTimes)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],GuildQuest_LevelUp)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		加入家族
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GuildQuest_JoinGuild(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	OnGuildQuestLogin(_idCharacter,_nOsTimes)
end
tQuestTrigeer[TASKTYPE.JoinGuild] = tQuestTrigeer[TASKTYPE.JoinGuild] or {}
table.insert(tQuestTrigeer[TASKTYPE.JoinGuild],GuildQuest_JoinGuild)