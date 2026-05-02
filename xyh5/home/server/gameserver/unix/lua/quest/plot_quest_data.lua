--处理数据
local tQuestChapter = _quest_Info.quest[1].chapter

for key,val in pairs(tQuestChapter) do
	--处理各个章节
	for k,v in pairs(val.info) do
		if nil ~= tQuestInfo[v.taskId] then
			L2C_DebugLog("plot_quest_data DuplicateKey"..v.taskId)
		end
		tQuestInfo[v.taskId] = {}
		tQuestInfo[v.taskId]["TaskType"] = v.taskType
		tQuestInfo[v.taskId]["preID"] = v.preTaskIdList
		tQuestInfo[v.taskId]["nextID"] = {v.nextTaskIdList}
		tQuestInfo[v.taskId]["isClose"] = v.isClose
		if v.taskType >= 1 and v.taskType <= 10 or v.taskType == 17 or v.taskType == 19 or v.taskType == 20 or v.taskType == 30 or v.taskType == 31 then
			local tCopyId = System_Split(tostring(v.Typevalue),",")
			for l,w in pairs(tCopyId) do
				tCopyId[l] = tonumber(w)
			end
			tQuestInfo[v.taskId]["Condition"] = {tCopyId,v.value}
		else
			tQuestInfo[v.taskId]["Condition"] = {v.Typevalue,v.value}
		end
		if "table" == type(v.ct) then
			tQuestInfo[v.taskId]["AddItem"] = {}
			for l,w in pairs(v.ct) do
				tQuestInfo[v.taskId]["AddItem"][l] = {w.itemId,w.num,"number" == type(w.stage) and w.stage or 0}
			end
		end
		if "number" == type(v.exp) and v.exp > 0 then
			tQuestInfo[v.taskId]["AddExp"] = v.exp
		end
		if "number" == type(v.money) and v.money > 0 then
			tQuestInfo[v.taskId]["AddMoney"] = v.money
		end
		if "number" == type(v.emoney) and v.emoney > 0 then
			tQuestInfo[v.taskId]["AddEmoney"] = v.emoney
		end
		if "number" == type(v.realmpoint) and v.realmpoint > 0 then
			tQuestInfo[v.taskId]["AddRealmPoint"] = v.realmpoint
		end
		if "number" == type(v.pou) and v.pou > 0 then
			tQuestInfo[v.taskId]["AddSavvy"] = v.pou
		end
		if "number" == type(v.treasure) and v.treasure > 0 then
			tQuestInfo[v.taskId]["treasure"] = v.treasure
		end
		if "number" == type(v.blood) and v.blood > 0 then
			tQuestInfo[v.taskId]["AddBlood"] = v.blood
		end
		if "number" == type(v.turepage) and v.turepage > 0 then
			tQuestInfo[v.taskId]["AddTruePage"] = v.turepage
		end
		if "number" == type(v.partner) and v.partner > 0 then
			tQuestInfo[v.taskId]["AddPartner"] = v.partner
		end
		
		if "number" == type(v.fullangry) and v.fullangry > 0 then
			tQuestInfo[v.taskId]["FullAngry"] = v.fullangry
		end
		
		if "string" == type(v.skill)then		
			tQuestInfo[v.taskId]["AddSkill"] = {}
			local tSkillItem = System_Split(tostring(v.skill),";")
			for l,w in pairs(tSkillItem) do
				local tSkill = System_Split(w,",")
				for m,x in pairs(tSkill) do
					tSkill[m] = tonumber(x)
				end
				tQuestInfo[v.taskId]["AddSkill"][l] = tSkill
			end
		end
		if "string" == type(v.weapon) then
			tQuestInfo[v.taskId]["AddWeapon"] = {}
			local tWeaponItem = System_Split(tostring(v.skill),";")
			for l,w in pairs(tWeaponItem) do
				local tWeapon = System_Split(w,",")
				for m,x in pairs(tWeapon) do
					tWeapon[m] = tonumber(x)
				end
				tQuestInfo[v.taskId]["AddWeapon"][l] = tWeapon
			end
		end	
	end
end


local tPlotBeginID = 0
local tPlotEndID = 0
local tPlotLen = 0

for i,v in pairs(tQuestInfo) do


	if  i >=  QUESTIDTYPE.PoltQuest_Begin and  i <= QUESTIDTYPE.PoltQuest_End then
		if v["preID"] == 0 then
			tPlotBeginID = i
		end
		if "table" == type(v["nextID"]) and 0 == v["nextID"][1] then
			tPlotEndID = i
		end
		tPlotLen = tPlotLen + 1
	end
end

--检查剧情ID是正确
local nBegin = tPlotBeginID
local nEnd = tPlotEndID
for i = 1,tPlotLen-1 do
	if (tQuestInfo[nBegin]["nextID"][1] ~= 0)then
		nBegin = tQuestInfo[nBegin]["nextID"][1]
	end
	if tQuestInfo[nEnd]["preID"] ~= 0 then
		nEnd = tQuestInfo[nEnd]["preID"]	
	end
end
if nBegin ~= tPlotEndID or nEnd ~= tPlotBeginID then
	L2C_DebugLog("PlotLinkCheck:\tExpected value["..tPlotBeginID.."] to ["..tPlotEndID.."]; Error[" .. nEnd .."] to [".. nBegin.."]")
end
