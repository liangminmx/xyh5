--=====================================================
--=============		数据变量	=======================
--=====================================================
--任务枚举
TASKTYPE = 
{
		None_Type = 0,		--// 无类型 不存在此“任务目标”

		EnterMountainRoad = 1,       --//  进入登山路第几关
		CompleteMountainRoad = 2,    --//  通关登山路第几关X次

		EnterLifeDeathBattle = 3,    --//  进入登山路第几关
		CompleteLifeDeathBattle = 4, --//  通关登山路第几关X次

		EnterSingleCopy = 5,          --//  进入单人副本第几关
		CompleteSingleCopy = 6,      --//  通关单人副本第几关X次

		EnterSecretsHouseBattle = 7, --// =7 通关百战秘室第几关      还没有实现
		CompleteSecretsHouseBattle = 8, --// =8 通关百战秘室第几关X次   还没有实现

		EnterEquipmentCopy = 9,  --// =9  通关装备副本第几关     还没有实现
		CompleteEquipmentCopy = 10, --// =10 通关装备副本第几关X次  还没有实现

		Messager = 11,		--//送信任务
		KillMonster			= 12,		--//杀怪任务
		CollectItem			= 13,		--//收集任务
		LevelUp				= 14,		--//升级任务

		ChargeEMoney = 15,   --// =11 充值元宝
		ConsumeEMoney = 16,  --// =12 消费元宝

		EnterPlotTaskFb = 17, -- // 进入剧情任务副本
		
		BloodUp = 18, -- //血脉提升任务
		
		EnterAdvanceFB			= 19,	--//进入一次进阶副本
		CompleteAdvanceFB		= 20,	--//完成一次进阶副本
		
		FirstRecharge = 21,	--//完成首充的任意充值
		NobleBuy = 22,	--//购买任意一个雪鹰贵族
		EmoneyBackBuy = 23,--//购买任意一个领主特权（月卡）
		
		DailyQuestComplete = 24,	--//完成日常任务
		TujianComplete		= 25,	--//完成图鉴任务
		GuildQuestComplete = 26,	--//完成家族任务

		EquipAdvance		= 27,	--//强化装备
		DomainAdvance		= 28,	--//境界提升 
		HorseAdvance		= 29,	--//坐骑进阶

		CompletePartnerCopy = 30,	--//通关伙伴副本
		EnterPartnerCopy	= 31,	--//进入伙伴副本
		
		JoinGuild				= 32,	--//加入一个家族
		EnterMoneyDungeon		= 33,	--//进入银两副本
		CompleteMoneyDungeon	= 34,	--//通关银两副本
		HorseAdvanceLevel		= 35,	--//坐骑进阶到X阶
		
		StarBattle = 36,--//星辰殿
		SendFlower = 37,--//送花
		EquipStone = 38,--//装备灵石

		--// 将5，6 修改成39， 40
		ShrineBattle = 40,		    --//神宫副本

		
		HeroBattle = 42,		--//摘星府
		GuardBattle = 43,		--//女娲神石
		CharacterRealm = 44,		--//境界任务
		MircoEnd = 45,	--//微端任务
		GuardCloudCity = 46,	--//守护八龙云城
		EquipStrenth = 47,	--//强化任务
		GuardVein = 48,	--//守护灵脉
		DragonArray = 49,	--//冥龙锁天阵
		WingSnake = 50,	--//翼蛇巢穴
		--//境界任务类型
		HorseRealm = 51,	--//坐骑
	
		--脚本自用
		QuestComplete = 1000, --完成某个任务
}
QUESTFLAG = 
{	
	NONE = 0,			--//
	ACCEPT = 1,			--//已接
	ACCOMPLISH = 2,		--//可交还
	COMPLETE = 3,		--//已完成
}
--任务ID对应的任务范围
QUESTIDTYPE =
{
	None_Type = 0,	
	PoltQuest_Begin = 10000000,
	PoltQuest_End = 19999999,
	BranchQuest_Begin = 20000000,
	BranchQuest_End = 29999999,
	DailyQuest_Begin = 30000000,
	DailyQuest_End = 39999999,
	GuildQuest_Begin = 40000000,
	GuildQuest_End = 49999999,
    Pokedex_Begin = 50000000,
    Pokedex_End = 59999999,
	End,
}

local _nEntrustTask_paygold = 10

-- 任务类型映射表
local _tQuestType_to_function = {}

--=====================================================
--=============	数据变量	End =======================
--=====================================================


--=====================================================
--=============	整理任务信息	=======================
--=====================================================

--扫荡相关的副本
local tRaidsBattle = {}
tRaidsBattle[TASKTYPE.EnterMountainRoad] = TASKTYPE.CompleteMountainRoad
tRaidsBattle[TASKTYPE.CompleteMountainRoad] = TASKTYPE.EnterMountainRoad
tRaidsBattle[TASKTYPE.EnterLifeDeathBattle] = TASKTYPE.CompleteLifeDeathBattle
tRaidsBattle[TASKTYPE.CompleteLifeDeathBattle] = TASKTYPE.EnterLifeDeathBattle
tRaidsBattle[TASKTYPE.EnterSingleCopy] = TASKTYPE.CompleteSingleCopy
tRaidsBattle[TASKTYPE.CompleteSingleCopy] = TASKTYPE.EnterSingleCopy
tRaidsBattle[TASKTYPE.EnterSecretsHouseBattle] = TASKTYPE.CompleteSecretsHouseBattle
tRaidsBattle[TASKTYPE.CompleteSecretsHouseBattle] = TASKTYPE.EnterSecretsHouseBattle
tRaidsBattle[TASKTYPE.EnterEquipmentCopy] = TASKTYPE.CompleteEquipmentCopy
tRaidsBattle[TASKTYPE.CompleteEquipmentCopy] = TASKTYPE.EnterEquipmentCopy
tRaidsBattle[TASKTYPE.CompletePartnerCopy] = TASKTYPE.EnterPartnerCopy
tRaidsBattle[TASKTYPE.EnterPartnerCopy] = TASKTYPE.CompletePartnerCopy


--=====================================================
--=============	整理任务信息 End ======================
--=====================================================


--接受任务
function C2L_OnAcceptQuest(_idCharacter,_nQuestId)
	-- L2C_DebugLog("C2L_OnAcceptQuest:" .. _idCharacter .. "|" .. _nQuestId)
	
	if nil == tQuestInfo[_nQuestId] or nil == tQuestInfo[_nQuestId]["TaskType"] then
		L2C_DebugLog("C2L_OnAcceptQuest:" .. _idCharacter .. ";\tA wrong QuestID:" .. _nQuestId)
		return
	end	

	if false == Quest_CheckPreQuest(_idCharacter,_nQuestId) then
		return
	end

	Quest_AddNewQuest(_idCharacter,_nQuestId)
	
	--填满怒气
	if tQuestInfo[_nQuestId]["FullAngry"] == 1 then
		System_FullCharacterAngry(_idCharacter)
	end
	

	-- 任务条件不存在
	if nil == tQuestInfo[_nQuestId]["Condition"] or nil == tQuestInfo[_nQuestId]["Condition"][1] or nil == tQuestInfo[_nQuestId]["Condition"][2] then
		L2C_DebugLog("C2L_OnAcceptQuest:" .. _idCharacter .. ";\tA wrong Quest Condition:" .. _nQuestId)
		return
	end

end

--任务条件检测，看看这个任务是不是能直接完成
function C2L_QuestCompleteCheck(_idCharacter,_nQuestId)
	local nRet = 0
	local nCon1,nCon2 = tQuestInfo[_nQuestId]["Condition"][1],tQuestInfo[_nQuestId]["Condition"][2]
	local nTaskType = tQuestInfo[_nQuestId]["TaskType"]

	if TASKTYPE.Messager == nTaskType then
		Quest_AccomplishQuest(_idCharacter,_nQuestId)
	elseif TASKTYPE.LevelUp == nTaskType then		
		if System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) >= nCon1 then
			Quest_AccomplishQuest(_idCharacter,_nQuestId)			
			Quest_CompleteQuest(_idCharacter,_nQuestId,0)
			nRet = 1
		end
	elseif	TASKTYPE.BloodUp == nTaskType then
		if System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_BLOOD) >= nCon1 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_BLOOD))
		end
	elseif TASKTYPE.DomainAdvance == nTaskType then
		local nDomain = System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_DOMAIN)
		if nDomain >= nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,nDomain)
		end
	elseif	TASKTYPE.EquipAdvance== nTaskType then
		local nStrLev = System_GetEquipPartStrengthLev(_idCharacter,110)--eET_Belt 腰带  按最后一个为准
		if nStrLev >= nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,nStrLev)
		end
	elseif TASKTYPE.GuildQuestComplete == nTaskType then
		local nNum = GuildQuest_GetCurQuestFinishNum(_idCharacter)
		if nNum >= nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,nNum)
		end
	elseif TASKTYPE.TujianComplete == nTaskType then
		local nNum = Pokedex_GetCurQuestFinishNum(_idCharacter)
		if nNum >= nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,nNum)
		end
	elseif TASKTYPE.DailyQuestComplete == nTaskType then
		local nTaskNum = Quest_GetMask(_idCharacter, QUESTIDTYPE.DailyQuest_Begin,2)
		local nEntrustNum = Quest_GetMask(_idCharacter, QUESTIDTYPE.DailyQuest_Begin,5)
		if nTaskNum + nEntrustNum >= nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		else
			Quest_SetQuestProgess(_idCharacter,_nQuestId,nTaskNum + nEntrustNum)
		end
	elseif TASKTYPE.EnterLifeDeathBattle == nTaskType or TASKTYPE.CompleteLifeDeathBattle == nTaskType then
		local nCurBattleId = System_GetCurDayHeroBattleId(_idCharacter)
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then		
			for i,v in pairs(nCon1) do
				if v == 0 and nCurBattleId ~= 0  then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nCurBattleId)
				else
					--不管配置几个 ， 当天次数大于它的话 都加次数
					if nCurBattleId >= v and nCurBattleId ~= 0 then
						Quest_CountConditionComplete(_idCharacter, _nQuestId)
					end
				end				
			end
		end	
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterAdvanceFB == nTaskType or TASKTYPE.CompleteAdvanceFB == nTaskType then		
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then		
			for i,v in pairs(nCon1) do
				local nCurTimes = System_GetAttrInt(_idCharacter,CHARACTER_INT.ADVANCEFBTIMES,v)			--当前轮次
				--这里0的话是全部
				if nCurTimes ~= 0 then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nCurTimes)
				end
			end
		end	
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterMoneyDungeon == nTaskType or TASKTYPE.CompleteMoneyDungeon == nTaskType then
		local nTimes = System_GetAttrInt(_idCharacter,CHARACTER_INT.MONEYDUNGEONTIMES)			--当前次数
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then	
			for i,v in pairs(nCon1) do
				if  v == 0 and nTimes ~= 0 then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nTimes) --通用副本次数才处理
				end
			end
		end
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterSingleCopy == nTaskType or TASKTYPE.CompleteSingleCopy == nTaskType then
		local nTimes = System_GetAttrInt(_idCharacter,CHARACTER_INT.PLOTBATTLECURDAYFIGHTNUM)			--当前次数
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then	
			for i,v in pairs(nCon1) do
				if  v == 0 and nTimes ~= 0 then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nTimes) --通用副本次数才处理
				end
			end
		end
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterEquipmentCopy == nTaskType or TASKTYPE.CompleteEquipmentCopy == nTaskType then
		local nTimes = System_GetAttrInt(_idCharacter,CHARACTER_INT.EQUIPMENTCURDAYFIGHTNUM)			--当前次数
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then	
			for i,v in pairs(nCon1) do
				if  v == 0 and nTimes ~= 0 then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nTimes) --通用副本次数才处理
				end
			end
		end
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterSecretsHouseBattle == nTaskType or TASKTYPE.CompleteSecretsHouseBattle == nTaskType then
		local nTimes = System_GetAttrInt(_idCharacter,CHARACTER_INT.SECRETSHOUSECURDAYFIGHTNUM)			--当前次数
		if "number" == type(nCon1) then
			nCon1 = {nCon1}
		end
		if "table" == type(nCon1) then	
			for i,v in pairs(nCon1) do
				if  v == 0 and nTimes ~= 0 then
					Quest_CountConditionComplete(_idCharacter, _nQuestId,nTimes) --通用副本次数才处理
				end
			end
		end
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.EnterMountainRoad == nTaskType or TASKTYPE.CompleteMountainRoad == nTaskType then
		local nCurRound = System_GetAttrInt(_idCharacter,CHARACTER_INT.TRIALBATTLEROUND)			--当前轮次
		local nCurSection = System_GetAttrInt(_idCharacter,CHARACTER_INT.TRIALBATTLECURSECTION)		--当前关数
		--策划说只要当前轮次（难度）大于0 ，这些任务都完成
		if nCurRound > 1 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
		else
			if "number" == type(nCon1) then
				nCon1 = {nCon1}
			end
			if "table" == type(nCon1) then		
				for i,v in pairs(nCon1) do
					if v == 0 and nCurSection ~= 0 then
						Quest_CountConditionComplete(_idCharacter, _nQuestId,nCurSection)
					else
					--不管配置几个 ， 当天次数大于它的话 都加次数
					if nCurSection >= v and nCurSection ~= 0 then
						Quest_CountConditionComplete(_idCharacter, _nQuestId)
					end
				end				
			end
		end
		end
		if  3 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) or 4 ==  Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			nRet = 1
		end
	elseif TASKTYPE.JoinGuild == nTaskType then
		local nGuildId = System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_GUILD_ID)
		if nGuildId > 0 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		end
	elseif TASKTYPE.HorseAdvanceLevel == nTaskType then
		--这个类型策划没配置~  出问题喷策划先 @杨张海
		local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.HORSE_STEPLEV)
		if nLevel > nCon2 then
			Quest_AutoCompleteQuest(_idCharacter,_nQuestId)
			nRet = 1
		end
	end
	return nRet
end
--任务自动完成  支线改为手动领  所以不自动交
function Quest_AutoCompleteQuest(_idCharacter,_nQuestId,_nNpc)
	Quest_AccomplishQuest(_idCharacter,_nQuestId)
	if _nQuestId < QUESTIDTYPE.BranchQuest_Begin or _nQuestId > QUESTIDTYPE.BranchQuest_End then
		Quest_CompleteQuest(_idCharacter,_nQuestId,_nNpc or 0)
	end
end

--交还任务   校验NPC等...
function C2L_OnRetrocedQuest(_idCharacter,_nQuestId,_nNpc)
	--送信任务置为完成
	if((nil ~= tQuestInfo[_nQuestId]) and (TASKTYPE.Messager == tQuestInfo[_nQuestId]["TaskType"]))then
		if QUESTFLAG.ACCEPT == Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			Quest_AccomplishQuest(_idCharacter,_nQuestId)
		end
	end
	Quest_CompleteQuest(_idCharacter,_nQuestId,_nNpc)
	--这里返回0表示成功
	return 0
end

--完成任务奖励
function C2L_OnQuestReward(_idCharacter,_nQuestId)
	--L2C_DebugLog("C2L_OnQuestReward:" .. _idCharacter .. "|" .. _nQuestId)
	if _nQuestId >= QUESTIDTYPE.GuildQuest_Begin and _nQuestId <= QUESTIDTYPE.GuildQuest_End then
		-- L2C_DebugLog("C2L_OnQuestReward:" .. _idCharacter .. "|" .. _nQuestId.. "Not a RightQUEST!")
		GuildQuest_OnQuestReward(_idCharacter,_nQuestId)
		return
	end
	if nil ~= tQuestInfo[_nQuestId]["AddMoney"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddMoney"]
		if nAwardNum > 0 then
			System_AwardMoney(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end
	--L2C_DebugLog("C2L_OnQuestReward:AddEmoney")
	if nil ~= tQuestInfo[_nQuestId]["AddEmoney"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddEmoney"]
		if nAwardNum > 0 then
			System_AwardEmoney(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end
	--L2C_DebugLog("C2L_OnQuestReward:AddRealmPoint")
	if nil ~= tQuestInfo[_nQuestId]["AddRealmPoint"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddRealmPoint"]
		if nAwardNum > 0 then
			System_AwardRealmPoint(_idCharacter,nAwardNum)
		end
	end
	--L2C_DebugLog("C2L_OnQuestReward:AddExp")
	if nil ~= tQuestInfo[_nQuestId]["AddExp"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddExp"]
		if nAwardNum > 0 then
			System_AwardExp(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end
	--L2C_DebugLog("C2L_OnQuestReward:AddBlood")
	if nil ~= tQuestInfo[_nQuestId]["AddBlood"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddBlood"]
		if nAwardNum > 0 then
			System_AwardBlood(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end
	--L2C_DebugLog("C2L_OnQuestReward:AddTruePage")
	if nil ~= tQuestInfo[_nQuestId]["AddTruePage"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddTruePage"]
		if nAwardNum > 0 then
			System_AwardTruePage(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end
	
	--L2C_DebugLog("C2L_OnQuestReward:AddSavvy")
	if nil ~= tQuestInfo[_nQuestId]["AddSavvy"] then
		local nAwardNum = tQuestInfo[_nQuestId]["AddSavvy"]
		if nAwardNum > 0 then
			System_AddSavvy(_idCharacter,nAwardNum, ACTIONTYPE.PLOTQUEST)
		end
	end

		
	if "table" == type(tQuestInfo[_nQuestId]["AddItem"]) then
		for k,v in pairs(tQuestInfo[_nQuestId]["AddItem"]) do
			if nil ~= v[1] and nil ~= v[2] then
				if false == System_AwardThingInBag(_idCharacter,ACTIONTYPE.PLOTQUEST, v[1], v[2],v[3] or 0) then
					System_AwardThingQuestContainer(_idCharacter,ACTIONTYPE.PLOTQUEST, v[1], v[2],v[3] or 0)
				end
			end
		end
	end	
	
	if "table" == type(tQuestInfo[_nQuestId]["AddSkill"]) then
		local nProfess = System_GetProfession(_idCharacter)
		for k,v in pairs(tQuestInfo[_nQuestId]["AddSkill"]) do
			if nil ~= v[1] and nil ~= v[2] and nil ~= v[3] then
				if nProfess == v[1] then
					System_AddSkill(_idCharacter,v[2],v[3])
					break
				end
			end
		end
	end
	
	if "table" == type(tQuestInfo[_nQuestId]["AddWeapon"]) then
		local nProfess = System_GetProfession(_idCharacter)
		for k,v in pairs(tQuestInfo[_nQuestId]["AddWeapon"]) do
			if nil ~= v[1] and nil ~= v[2] then
				if nProfess == v[1] then
					System_UnlockWeapon(_idCharacter,v[2],4)
					break
				end				
			end
		end		
	end
	
	if "number" == type(tQuestInfo[_nQuestId]["AddPartner"]) then
		if tQuestInfo[_nQuestId]["AddPartner"] > 0 then
		--默认1星1级
			System_AwardPartnerSkin(_idCharacter,tQuestInfo[_nQuestId]["AddPartner"])
			-- System_UnlockPartner(_idCharacter,tQuestInfo[_nQuestId]["AddPartner"],1,1,3)
		end
	end
	
	if "number" == type(tQuestInfo[_nQuestId]["treasure"]) then
		if tQuestInfo[_nQuestId]["treasure"] > 0 then
			System_UnlockTreasure(_idCharacter,tQuestInfo[_nQuestId]["treasure"],ACTIONTYPE.PLOTQUEST)
		end
	end
	
	BranchQuest_Check(_idCharacter,_nQuestId,TASKTYPE.QuestComplete,_nData1,_nData2,_nData3)
	
	if _nQuestId == 10010030 then
		C_DoTestCommond(_idCharacter)		
	end
	if _nQuestId == 10010050 then
		C_SendMessage2Client(_idCharacter,30240) -- 测试副本接口
	end
	
	Quest_GetNextQuest(_idCharacter, _nQuestId)		
	
	--剧情任务的话 这个任务有后续才删除
	if (_nQuestId >= QUESTIDTYPE.PoltQuest_Begin and _nQuestId <= QUESTIDTYPE.PoltQuest_End) then
		if nil ~= tQuestInfo[_nQuestId]["nextID"] and "table" == type(tQuestInfo[_nQuestId]["nextID"]) and tQuestInfo[_nQuestId]["nextID"][1] ~= 0 then
			Quest_DeleteQuest(_idCharacter,_nQuestId)
		end
	else
		if not ((_nQuestId >= QUESTIDTYPE.DailyQuest_Begin and _nQuestId <= QUESTIDTYPE.DailyQuest_End)
				or (_nQuestId >= QUESTIDTYPE.BranchQuest_Begin and _nQuestId <= QUESTIDTYPE.BranchQuest_End)
			) then
			Quest_DeleteQuest(_idCharacter,_nQuestId)
		end
	end		
end

--任务数据更新，条件检测  （_nData1：怪物id、NPCid； _nData2：数量数值 几只或几级 ；_nData3:预留）
function C2L_QuestCheck(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	if not (_idCharacter and _nQuestId and _nTaskType) then
		L2C_DebugLog("C2L_QuestCheck Error:"..(_idCharacter or "NULL").."|"..(_nQuestId or "NULL").."|"..(_nTaskType or "NULL"))
		return
	end
	-- L2C_DebugLog("C2L_QuestCheck:"..(_nTaskType or "NULL").."|"..(_nData1 or "NULL").."|"..(_nData2 or "NULL").."|"..(_nData3 or "NULL"))
	
    -- 检测图鉴任务
    if  _nQuestId == QUESTIDTYPE.Pokedex_Begin then        
        if  _nTaskType == TASKTYPE.KillMonster then
            Pokedex_KillMonster(_idCharacter,_nQuestId,_nData1,_nData2)
            return
        end
    end
	
	--检测委托任务
	if _nQuestId == QUESTIDTYPE.DailyQuest_Begin then
		QuestCheckDailyAndEntrust(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
		return
	end
	--检测支线任务开启
	if _nQuestId == QUESTIDTYPE.BranchQuest_Begin then
		BranchQuest_Check(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	end
	--检测宗族任务
	if QUESTIDTYPE.GuildQuest_Begin == _nQuestId then
		GuildQuest_Check(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
		return
	end
	
	--if QUESTIDTYPE.GuildQuest_Begin <= _nQuestId and QUESTIDTYPE.GuildQuest_End >= _nQuestId  then
	--	GuildQuest_Check(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	--	return
	--end
	

	-- 任务类型不一致
	if nil  == tQuestInfo[_nQuestId] or nil == tQuestInfo[_nQuestId]["TaskType"] then
		-- L2C_DebugLog("任务类型不一致\tQuest:".._nQuestId.."|".._nTaskType)		
		return
	end
	--能扫荡的副本相关	
	if tRaidsBattle[_nTaskType] ~= nil then			
		if _nTaskType == tQuestInfo[_nQuestId]["TaskType"] or tRaidsBattle[_nTaskType] == tQuestInfo[_nQuestId]["TaskType"] then
			if _nData1 <= _nData2 then
				for i = _nData1,_nData2 do
					_tQuestType_to_function[ tQuestInfo[_nQuestId]["TaskType"] ](_idCharacter, _nQuestId,i,0,0)
				end
			end
		end
	end	
	
	if  _nTaskType ~= tQuestInfo[_nQuestId]["TaskType"] then
		return
	end
	
	-- 任务条件不存在
	if nil == tQuestInfo[_nQuestId]["Condition"] or nil == tQuestInfo[_nQuestId]["Condition"][1] or nil == tQuestInfo[_nQuestId]["Condition"][2] then
		L2C_DebugLog("C2L_QuestCheck:" .. _idCharacter .. ";\tA wrong Quest Condition:" .. _nQuestId)
		return
	end

	--任务进行中 否则返回
	if QUESTFLAG.ACCEPT ~= Quest_GetQuestFlag(_idCharacter,_nQuestId) then
		-- L2C_DebugLog("C2L_QuestCheck:Flag~= 1，Flag："..Quest_GetQuestFlag(_idCharacter,_nQuestId) )
		return
	end
	
	-- L2C_DebugLog("C2L_QuestCheck剧情:"..(_idCharacter ).."|"..(_nQuestId).."|"..(_nTaskType))
	if _tQuestType_to_function[_nTaskType] ~= nil then 
		_tQuestType_to_function[_nTaskType](_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	else
		Quest_DefaultCheck(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	end	
end

--进度操作  增加
function Quest_CountConditionComplete(_idCharacter, _nQuestId, _nCount)
	_nCount = _nCount or 1
	if _nCount == 0 then _nCount = 1 end	
	Quest_AddQuestProgess(_idCharacter, _nQuestId, _nCount)
	Quest_CheckTaskComplete(_idCharacter, _nQuestId)
end
--默认进度 + data2
function Quest_DefaultCheck(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)	
	Quest_CountConditionComplete(_idCharacter, _nQuestId,_nData2)
end

function Quest_CheckTaskComplete(_idCharacter,_nQuestId)
	if QUESTIDTYPE.BranchQuest_Begin <= _nQuestId and _nQuestId <= QUESTIDTYPE.BranchQuest_End then
		--支线的话不自动交 只置为完成
		Quest_AccomplishQuest(_idCharacter,_nQuestId)
		return
	end

	local nProgess = Quest_GetQuestProgess(_idCharacter,_nQuestId)
	if nProgess >= tQuestInfo[_nQuestId]["Condition"][2] then
		Quest_QuestFinishCondition(_idCharacter,_nQuestId)
	end
end

--///////////////////////////////////////////////
--任务类型映射表 函数实现	BEGIN
--///////////////////////////////////////////////

_tQuestType_to_function[TASKTYPE.Messager] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)    
	--校验NPC 怪物ID	
	if _nData1 == tQuestInfo[_nQuestId]["Condition"][1] then
		--L2C_DebugLog("C2L_QuestCheck NPC 怪物：".._nData1.."|".._nData2)
		Quest_CountConditionComplete(_idCharacter, _nQuestId,_nData2)
	end
end

_tQuestType_to_function[TASKTYPE.CollectItem] = _tQuestType_to_function[TASKTYPE.Messager]
_tQuestType_to_function[TASKTYPE.KillMonster] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
    _tQuestType_to_function[TASKTYPE.Messager](_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
end

_tQuestType_to_function[TASKTYPE.LevelUp] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	--等级到达直接完成
	--L2C_DebugLog("LevelUp:".._nData1.."|".._nData2)	
	if _nData2 >= tQuestInfo[_nQuestId]["Condition"][1] then
		Quest_AddQuestProgess(_idCharacter,_nQuestId, 1)
		Quest_CheckTaskComplete(_idCharacter, _nQuestId)
	end
end

_tQuestType_to_function[TASKTYPE.BloodUp] = function(_idCharacter, _nQuestId,_nOldLevel,_nNewLevel,_nData3)	
	if _nNewLevel >= tQuestInfo[_nQuestId]["Condition"][1] then		
		Quest_CheckTaskComplete(_idCharacter, _nQuestId)
	else
		Quest_SetQuestProgess(_idCharacter,_nQuestId, _nNewLevel)
	end
end
--境界 
_tQuestType_to_function[TASKTYPE.DomainAdvance] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	if _nData1 >= tQuestInfo[_nQuestId]["Condition"][2] then
		Quest_SetQuestProgess(_idCharacter,_nQuestId, _nData1)
		Quest_CheckTaskComplete(_idCharacter, _nQuestId)
	else
		Quest_SetQuestProgess(_idCharacter,_nQuestId, _nData1)
	end
end
_tQuestType_to_function[TASKTYPE.EquipAdvance] = _tQuestType_to_function[TASKTYPE.DomainAdvance]

_tQuestType_to_function[TASKTYPE.EnterMountainRoad] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	--校验战斗ID 不管战斗胜利失败 次数都是+1
	-- L2C_DebugLog(_nQuestId.."\t\t_nData1:"..(_nData1 or "nil").."\t\t_nData2:"..(_nData2 or "nil"))	
	if "table" == type(tQuestInfo[_nQuestId]["Condition"][1]) then		
		for i,v in pairs(tQuestInfo[_nQuestId]["Condition"][1]) do
			if 0 == v or _nData1 == v then
				Quest_CountConditionComplete(_idCharacter, _nQuestId)
			end
		end
	elseif "number" == type(tQuestInfo[_nQuestId]["Condition"][1]) then		
		if 0 == tQuestInfo[_nQuestId]["Condition"][1] or _nData1 == tQuestInfo[_nQuestId]["Condition"][1] then
			Quest_CountConditionComplete(_idCharacter, _nQuestId)
		end
	end
end

_tQuestType_to_function[TASKTYPE.CompleteMountainRoad] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterLifeDeathBattle] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteLifeDeathBattle] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterSingleCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteSingleCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterSecretsHouseBattle] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteSecretsHouseBattle] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterEquipmentCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteEquipmentCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterPlotTaskFb] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterAdvanceFB] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteAdvanceFB] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompletePartnerCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterPartnerCopy] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.EnterMoneyDungeon] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]
_tQuestType_to_function[TASKTYPE.CompleteMoneyDungeon] = _tQuestType_to_function[TASKTYPE.EnterMountainRoad]


--日常任务 图鉴任务 家族任务
_tQuestType_to_function[TASKTYPE.DailyQuestComplete] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	Quest_CountConditionComplete(_idCharacter,_nQuestId,_nData1)
end
_tQuestType_to_function[TASKTYPE.TujianComplete] = _tQuestType_to_function[TASKTYPE.DailyQuestComplete]
_tQuestType_to_function[TASKTYPE.GuildQuestComplete] = _tQuestType_to_function[TASKTYPE.DailyQuestComplete]
--这个也改成支持多个
--[[
_tQuestType_to_function[TASKTYPE.EnterPlotTaskFb] = function(_idCharacter, _nQuestId,_nData1,_nData2,_nData3)
	--校验战斗ID 不管战斗胜利失败 次数都是+1
	if _nData1 == tQuestInfo[_nQuestId]["Condition"][1] then
		Quest_CountConditionComplete(_idCharacter, _nQuestId)
	end
end
--]]

--///////////////////////////////////////////////
--任务类型映射表 函数实现 END
--///////////////////////////////////////////////


--自动接下一个任务
function Quest_GetNextQuest(_idCharacter,_nQuestId)
	if nil ~= _idCharacter and nil ~= _nQuestId then
		if nil ~= tQuestInfo[_nQuestId]["nextID"] and "table" == type(tQuestInfo[_nQuestId]["nextID"]) then
			for k,v in pairs(tQuestInfo[_nQuestId]["nextID"]) do			
				C2L_OnAcceptQuest(_idCharacter,v)
			end
		end
	end
end

--检测前置任务
function Quest_CheckPreQuest(_idCharacter,_nQuestId)
	if nil ~= _idCharacter and nil ~= _nQuestId then
		if nil ~= tQuestInfo[_nQuestId]["preID"] and "table" == type(tQuestInfo[_nQuestId]["preID"]) then
			for k,v in pairs(tQuestInfo[_nQuestId]["preID"]) do			
				if false == Quest_IsQuestComplete(_idCharacter,k) then
					return false
				end
			end
		end
	end
	return true 
end

--将前置任务置为完成
function C2L_OnSetPreQuestComplete(_idCharacter,_nQuestId)
	if nil ~= _idCharacter and nil ~= _nQuestId then
		local nTempId = _nQuestId
		--检测下是不是数据脏了
		if Quest_IsQuestComplete(_idCharacter,_nQuestId) then
			if nil ~= tQuestInfo[_nQuestId]["nextID"] and "table" == type(tQuestInfo[_nQuestId]["nextID"]) then
				for k,v in pairs (tQuestInfo[_nQuestId]["nextID"] ) do
					if 0 ~= v and false == Quest_IsQuestComplete(_idCharacter,v) and -1 == Quest_GetQuestFlag(_idCharacter,v) then
						C2L_NoPlotQuestProcess(_idCharacter,_nQuestId)
						L2C_DebugLog(string.format("C2L_OnSetPreQuestComplete: This Complete Quest Has No Next Quest ;_idCharacter[%s]_nQuestId[%s]",_idCharacter,_nQuestId))
						break
					end
				end
			end
		end
		--修正下当前任务
		Quest_IsQuestAccomplished(_idCharacter,_nQuestId)
		--玩家这个任务已经完成  删除之
		if 3 == Quest_GetQuestFlag(_idCharacter,_nQuestId) then
			--这个任务有后续才删除
			if nil ~= tQuestInfo[_nQuestId]["nextID"] and "table" == type(tQuestInfo[_nQuestId]["nextID"]) and tQuestInfo[_nQuestId]["nextID"][1] ~= 0 then
				Quest_DeleteQuest(_idCharacter,_nQuestId)
			end
		end
		-- L2C_DebugLog("C2L_OnSetPreQuestComplete:".._nQuestId)
		--这个前置任务未完成
		while ("table" == type(tQuestInfo[nTempId])) and ("number" == type(tQuestInfo[nTempId]["preID"])) do 			
			if Quest_IsQuestComplete(_idCharacter,tQuestInfo[nTempId]["preID"]) and -1 == Quest_GetQuestFlag(_idCharacter,tQuestInfo[nTempId]["preID"]) then
				break
			end			
			Quest_SetQuestComplete(_idCharacter,tQuestInfo[nTempId]["preID"])			
			nTempId = tQuestInfo[nTempId]["preID"]
			BranchQuest_Check(_idCharacter,nTempId,TASKTYPE.QuestComplete)
		end
	end	
end
--是否这个任务已经完成 掩码未确修养
function Quest_IsQuestAccomplished(_idCharacter,_nQuestId)
	if 2 == Quest_GetQuestFlag(_idCharacter,_nQuestId) then
		if "table" == type(tQuestInfo[_nQuestId]) and "table" == type(tQuestInfo[_nQuestId]["Condition"]) then
			if TASKTYPE.Messager ~= tQuestInfo[_nQuestId]["Condition"][1] then
				Quest_CompleteQuest(_idCharacter,_nQuestId,0)
			end
		end
	end
end

-- 无剧情任务处理
function C2L_NoPlotQuestProcess(_idCharacter,_nCurCompelteQuestId)
	--这个玩家的任务数据脏了  需要修复一下
	if  nil ~= _nCurCompelteQuestId and 0 ~= _nCurCompelteQuestId then
		Quest_GetNextQuest(_idCharacter, _nCurCompelteQuestId)	
		return nil
	end
	--新手任务
	if -1 == Quest_GetQuestFlag(_idCharacter,10010010) and false == Quest_IsQuestComplete(_idCharacter,10010010) then
		C2L_OnAcceptQuest(_idCharacter,10010010)
		return 1
	else
		return 0
	end	
	return 0 --返回是否接受了首个任务 0：接受了 1：未接受
end


--返回任务对于的lib
function C2L_QueryQuestLib(_nTask)
	if nil ~= tQuestInfo[_nTask] and nil ~= tQuestInfo[_nTask]["TaskRoom"] then
		return tQuestInfo[_nTask]["TaskRoom"]
	end
	return 0
end


--检测委托任务
function QuestCheckDailyAndEntrust(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	local nCurTaskId = Quest_GetMask(_idCharacter,_nQuestId,1)
	--L2C_DebugLog("QuestCheckCur".._nQuestId.."|"..nCurTaskId.."|".._nData1.."|".._nData2)
	
	if QUESTIDTYPE.DailyQuest_Begin ~= nCurTaskId and 0 ~= nCurTaskId then
		-- 任务类型不一致
		if nil  == tQuestInfo[nCurTaskId] or nil == tQuestInfo[nCurTaskId]["TaskType"] or _nTaskType ~= tQuestInfo[nCurTaskId]["TaskType"] then
			return
		end
		-- 任务条件不存在
		if nil == tQuestInfo[nCurTaskId]["Condition"] or nil == tQuestInfo[nCurTaskId]["Condition"][1] or nil == tQuestInfo[nCurTaskId]["Condition"][2] then
			L2C_DebugLog("QuestCheckDailyAndEntrust:" .. _idCharacter .. ";\tA wrong Quest Condition:" .. nCurTaskId)
			return
		end
		if _nData1 == tQuestInfo[nCurTaskId]["Condition"][1] then
			--L2C_DebugLog("QuestCheckCur".._nData1.."|".._nData2)
			Quest_AddQuestProgess(_idCharacter, _nQuestId, _nData2)
			
			local nCurProgess = Quest_GetQuestProgess(_idCharacter,_nQuestId)
			if nCurProgess >= tQuestInfo[nCurTaskId]["Condition"][2] then				
				--L2C_DebugLog("QuestCheckCur_Complete:"..nCurTaskId)
				--这里不检测任务状态 因为完成的话会删除日常ID
				Quest_QuestFinishCondition(_idCharacter,_nQuestId,nCurTaskId)
			end
		end	
	end
	
	
	local _nEntrustTaskId  = Quest_GetMask(_idCharacter,_nQuestId,3)
	--L2C_DebugLog("QuestCheckEntrust".._nQuestId.."|".._nEntrustTaskId.."|".._nData1.."|".._nData2)
	if 0 ~= _nEntrustTaskId then
		-- 任务类型不一致	
		if nil  == tQuestInfo[_nEntrustTaskId] or nil == tQuestInfo[_nEntrustTaskId]["TaskType"] or _nTaskType ~= tQuestInfo[_nEntrustTaskId]["TaskType"] then			
			return
		end
		-- 任务条件不存在
		if nil == tQuestInfo[_nEntrustTaskId]["Condition"] or nil == tQuestInfo[_nEntrustTaskId]["Condition"][1] or nil == tQuestInfo[_nEntrustTaskId]["Condition"][2] then
			L2C_DebugLog("QuestCheckDailyAndEntrust:" .. _idCharacter .. ";\tA wrong Quest Condition:" .. _nEntrustTaskId)
			return
		end
		if _nData1 == tQuestInfo[_nEntrustTaskId]["Condition"][1] then
			--L2C_DebugLog("QuestCheckEntrust".._nData1.."|".._nData2)
			Quest_AddMask(_idCharacter, _nQuestId, 4,_nData2)
			
			local _nEntrustProgess = Quest_GetMask(_idCharacter,_nQuestId,4)
			if _nEntrustProgess >= tQuestInfo[_nEntrustTaskId]["Condition"][2] then
				--L2C_DebugLog("QQuestCheckEntrust_Complete:".._nEntrustTaskId)
				--这里不检测任务状态 因为完成的话会删除委托ID
				Quest_QuestFinishCondition(_idCharacter,_nQuestId,0,_nEntrustTaskId)
			end
		end
	end
	
end

--服务端给奖励接口
function C2L_SpecialAward(_idCharacter,_nType,_nData1,_nData2,_nData3)
	--L2C_DebugLog("C2L_SpecialAward:".."_nType:"..(_nType or "NULL")..",_nData1:"..(_nData1 or "NULL")..",_nData2:"..(_nData2 or "NULL")..",_nData3:"..(_nData3 or "NULL"))
	if ACTIONTYPE.CompleteAllDailyTask == _nType then		
		--有奖励可领
		if 1 == Quest_GetMask(_idCharacter,QUESTIDTYPE.DailyQuest_Begin,6) then
			if false == System_AwardThingInBag(_idCharacter,_nType, 105001, 20) then
				System_AwardThingQuestContainer(_idCharacter,_nType, 105001, 20)
			end
			--标记为已领
			Quest_SetMask(_idCharacter,QUESTIDTYPE.DailyQuest_Begin,6,0)
			return 1  --// 成功
		else
			L2C_DebugLog("C2L_SpecialAward:CompleteAllDailyTask Error[".._idCharacter.."]")
			return 2 --// 还不能领取
		end
		
	end
	if ACTIONTYPE.TodayQuest == _nType then
		local _nEntrustTaskId = _nData1
		local _nEntrustNum = _nData2 or 1
		local _nEntrustRate = _nData3
		if nil ~= tQuestInfo[_nEntrustTaskId] then
			--L2C_DebugLog("C2L_SpecialAward:CompleteEntrustTask")
			if nil ~= tQuestInfo[_nEntrustTaskId]["AddExp"] then
				local nExp = tQuestInfo[_nEntrustTaskId]["AddExp"]
				--L2C_DebugLog("C2L_SpecialAward_Exp:"..nExp)
				System_AwardExp(_idCharacter,_nEntrustNum * (nExp + math.ceil(_nData3/10000.0*nExp)),_nType)
			end
			if nil ~= tQuestInfo[_nEntrustTaskId]["AddMoney"] then
				local nMoney = tQuestInfo[_nEntrustTaskId]["AddMoney"]
				--L2C_DebugLog("C2L_SpecialAward_Money:"..nMoney)
				System_AwardMoney(_idCharacter,_nEntrustNum * (nMoney + math.ceil(_nData3/10000.0*nMoney)),_nType)
			end
			if nil ~= tQuestInfo[_nEntrustTaskId]["AddEmoney"] then
				local nEmoney = tQuestInfo[_nEntrustTaskId]["AddEmoney"]
				--L2C_DebugLog("C2L_SpecialAward_Emoney:"..nEmoney)
				System_AwardEmoney(_idCharacter,_nEntrustNum * (nEmoney + math.ceil(_nData3/10000.0*nEmoney)),_nType)
			end
		end
	end
	if ACTIONTYPE.CompleteEntrustTask == _nType then
		if nil ~= _nEntrustTask_paygold then
			System_AwardVouchers(_idCharacter,_nEntrustTask_paygold,_nType)
		end		
	end
	--这个需要返回
	--////////////////////
	if ACTIONTYPE.eFT_GuildQuestOneKey == _nType then
		
		return GuildQuest_OneKeyReward(_idCharacter,_nData1,_nData2)
	end
	if ACTIONTYPE.eFT_GuildQuestCompleteAll == _nType then
		return GuildQuest_CompleteAll(_idCharacter,_nData1)
	end
	--////////////////////
end

--有可能无法当天完成的任务
function Quest_IsCanCompleteToday_Check(_idCharacter,_nQuestId)
	if nil ~= tQuestInfo[_nQuestId] and nil~= tQuestInfo[_nQuestId]["Condition"] then
		if TASKTYPE.FirstRecharge == tQuestInfo[_nQuestId]["TaskType"] then
			if true == FirstCharge_IsHasGetAward(_idCharacter) then
				return false
			end
		end
		if TASKTYPE.EmoneyBackBuy ==  tQuestInfo[_nQuestId]["TaskType"]  then
			local nTempid = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackGet]			
			for i = 1,7 do 
				if 2 == System_GetTempData(_idCharacter,nTempid,i) then
					-- L2C_DebugLog(nTempid.."|"..TASKTYPE.EmoneyBackBuy.."false|"..System_GetTempData(_idCharacter,nTempid,i))					
					return false
				end
			end			
		end
	end
	return true
end

--任务每日重置接口
function C2L_OnQuestZeroRefresh(_idCharacter)
	-- 已经移到活动后处理
	--跟登录一样的处理  
	--OnDailyQuestLogin(_idCharacter)	
	-- for k,v in pairs(tBranchDaily) do
		-- if -1 ~= Quest_GetQuestFlag(_idCharacter,v) then
			-- Quest_DeleteQuest(v)			
		-- end
	-- end	
end



function C2L_SetGuildDifficult(_idCharacter,_nQuestId,_nDifficultyLevel)	
	local nNum = tQuestInfo[_nQuestId]["Condition"][2]
	local nRequireCount = math.modf(nNum*(10000 + tDifficultLevel[_nDifficultyLevel][3])/10000)
	
	Quest_SetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,5,nRequireCount)
	Quest_SetMask(_idCharacter,QUESTIDTYPE.GuildQuest_Begin,2,_nDifficultyLevel)	
	--如果降低难度后次数已达到要求
	if nRequireCount <= Quest_GetQuestProgess(_idCharacter,QUESTIDTYPE.GuildQuest_Begin) and QUESTFLAG.ACCEPT == Quest_GetQuestFlag(_idCharacter,QUESTIDTYPE.GuildQuest_Begin) then		
		Quest_QuestFinishCondition(_idCharacter,QUESTIDTYPE.GuildQuest_Begin)
	end
end

function C2L_GetQuestInfo(_idCharacter,_nQuestId,_sType)
	if _sType == "TaskType" then
		if nil ~= tQuestInfo[_nQuestId] and "number" == type(tQuestInfo[_nQuestId]["TaskType"]) then
			return tQuestInfo[_nQuestId]["TaskType"]
		end		
	end
	return -1
end

--这几个触发就不额外写了
function Quest_LevelTrigeer(_idCharacter,_nTaskType,_nData1,_nData2,_nData3)
	SecretMission_LevelUp(_idCharacter,_nData1,_nData2)
    GetEMoney_LevelUp(_idCharacter,_nData1,_nData2)
	DoubleGold_LevelUp(_idCharacter,_nData1,_nData2)
	GuideFunction_Trigeer_Level(_idCharacter,_nData1,_nData2)
    ChouJiang_LevelUp(_idCharacter,_nData1,_nData2)
    GM_ChouJiang_LevelUp(_idCharacter,_nData1,_nData2)
    RichWelfare_LevelUp(_idCharacter,_nData1,_nData2)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],Quest_LevelTrigeer)

function Quest_KillMonsterTrigeer(_idCharacter,_nTaskType,_nData1,_nData2,_nData3)
	Adventure_KillMonster_Process(_idCharacter,_nData1,_nData2)    
end
tQuestTrigeer[TASKTYPE.KillMonster] = tQuestTrigeer[TASKTYPE.KillMonster] or {}
table.insert(tQuestTrigeer[TASKTYPE.KillMonster],Quest_KillMonsterTrigeer)
