local mailid = _feeder_Info.feeder[1].mailid[1].mail

local tBranchQuestOpen = {}	--开启条件信息
local tBranchDaily = {}	--需重置的任务

local tBranchInfo = _feeder_Info["feeder"][1]["chapter"]
for k,v in pairs(tBranchInfo) do
	if (tQuestInfo[v.taskid] ~= nil)then
		L2C_DebugLog("Branch_quest_data Error: Wrong Key ["..k.."]")
	end
	tQuestInfo[v.taskid] = {}	
	tQuestInfo[v.taskid]["TaskType"] = v.taskType
	if 1 == v.need then
		tQuestInfo[v.taskid]["OpenCon"] = {TASKTYPE.LevelUp,0,v.needvalue}	
	end
	if 3 == v.need then
		tQuestInfo[v.taskid]["OpenCon"] = {TASKTYPE.ChargeEMoney,0,v.needvalue}	
	end
	-- 如果是剧情任务
	if 6 == v.need or 5 == v.need then
		tQuestInfo[v.taskid]["OpenCon"] = {TASKTYPE.QuestComplete,v.needvalue,0}	
	end
	
	if tQuestInfo[v.taskid]["OpenCon"] ~= nil then
		tBranchQuestOpen[ tQuestInfo[v.taskid]["OpenCon"][1] ] = tBranchQuestOpen[ tQuestInfo[v.taskid]["OpenCon"][1] ] or {}
		table.insert(tBranchQuestOpen[ tQuestInfo[v.taskid]["OpenCon"][1] ],v.taskid)
	end
	
	tQuestInfo[v.taskid]["Condition"] = {"number" == type(v.Typevalue) and v.Typevalue or 0,"number" == type(v.value) and v.value or 0}
	if "table" == type(v.info) then
		tQuestInfo[v.taskid]["AddMoney"] = "number" == type(v.info[1].money) and v.info[1].money or 0
		tQuestInfo[v.taskid]["AddExp"] = "number" == type(v.info[1].exp) and v.info[1].exp or 0
		tQuestInfo[v.taskid]["AddRealmPoint"] = "number" == type(v.info[1].realmpoint) and v.info[1].realmpoint or 0		
	end
	if "table" == type(v.ct) then
		tQuestInfo[v.taskid]["AddItem"] = {}
		for l,w in pairs(v.ct) do
			--这里的东西默认绑定
			if "number" == type(w.itemId) and "number" == type(w.num) then
				tQuestInfo[v.taskid]["AddItem"][l] = {w.itemId,w.num,0}
			end
		end
	end
	tQuestInfo[v.taskid]["Daily"] = ("number" == type(v.daily) and v.daily or 0)
	
	if type(tQuestInfo[v.taskid]["Daily"]) == "number" then
		if 1 == tQuestInfo[v.taskid]["Daily"] then
			table.insert(tBranchDaily,v.taskid)
		end
	end
end

--支线任务检测
function BranchQuest_Check(_idCharacter,_nQuestId,_nTaskType,_nData1,_nData2,_nData3)
	-- L2C_DebugLog("BranchQuest_Check:".._nQuestId.."\t_nTaskType:".._nTaskType.."\t_nData1"..(_nData1 or "NULL"))
	if nil == _nTaskType or nil == tBranchQuestOpen[_nTaskType] then
		return
	end	
	for k,v in pairs(tBranchQuestOpen[_nTaskType]) do
		--任务不存在
		if -1 == Quest_GetQuestFlag(_idCharacter,v) then
			Quest_AddNewQuest(_idCharacter,v,0)			
			--接受任务就同时更新时间
			Quest_SetMask(_idCharacter,v,7,os.time())
		end
		--添加任务信息
		if 0 == Quest_GetQuestFlag(_idCharacter,v) then				
			-- 这个支线无法当天完成 就不接
			if false == Quest_IsCanCompleteToday_Check(_idCharacter,v) then
				return
			end
			--接受任务
			if TASKTYPE.LevelUp == _nTaskType then
				if tQuestInfo[v]["OpenCon"][3] <= _nData2 then
					Quest_AddNewQuest(_idCharacter,v,1)
					Quest_SetMask(_idCharacter,v,7,os.time())
				end	
			elseif TASKTYPE.CharacterRealm == _nTaskType then
				if tQuestInfo[v]["OpenCon"][2] < _nData1 or
					(tQuestInfo[v]["OpenCon"][2] == _nData1 and	tQuestInfo[v]["OpenCon"][3] <= _nData2)
				then
					Quest_AddNewQuest(_idCharacter,v,1)
					Quest_SetMask(_idCharacter,v,7,os.time())
				end	
			elseif TASKTYPE.QuestComplete == _nTaskType then
				if tQuestInfo[v]["OpenCon"][2] == _nQuestId then
					Quest_AddNewQuest(_idCharacter,v,1)
					Quest_SetMask(_idCharacter,v,7,os.time())
				end
			else
				Quest_AddMask(_idCharacter,v,1,_nData2)	
				if tQuestInfo[v]["OpenCon"][3] <= Quest_GetMask(_idCharacter,v,1) then
					local nConData = Quest_GetMask(_idCharacter,v,1)
					Quest_AddNewQuest(_idCharacter,v,1)
					Quest_SetMask(_idCharacter,v,7,os.time())
					--如果开启条件跟完成条件一样  将数据移植
					--L2C_DebugLog("_nTaskType:"..(_nTaskType or "NULL").."\t_nData1:"..(_nData1 or "NULL"))
					--L2C_DebugLog("OpenCon:"..(tQuestInfo[v]["OpenCon"][1] or "NULL").."\t"..(tQuestInfo[v]["OpenCon"][2] or "NULL"))
					if _nTaskType == tQuestInfo[v]["OpenCon"][1] and _nData1 == tQuestInfo[v]["OpenCon"][2] then							
						Quest_SetQuestProgess(_idCharacter,v,nConData)
						Quest_CheckTaskComplete(_idCharacter, v)
					end
				end	
			end
		end	
		--看看这个任务是不是可以直接完成
		if 1 == Quest_GetQuestFlag(_idCharacter,v) then
			C2L_QuestCompleteCheck(_idCharacter,v)
		end
	end
end

--每日任务登录处理
function OnDailyQuestLogin(_idCharacter,_nOsTimes)
	nTime = _nOsTimes or os.time()	
	local nCurDate = tonumber(os.date("%Y%m%d",nTime))
	for k,v in pairs(tBranchDaily)do
		if -1 ~= Quest_GetQuestFlag(_idCharacter,v) then		
			local nRecordDate = tonumber(os.date("%Y%m%d",Quest_GetMask(_idCharacter,v,7))) or 0
			if nCurDate > nRecordDate then
				if 2 == Quest_GetQuestFlag(_idCharacter,v) then
					Quest_DeleteQuest(_idCharacter,v)
					Quest_AddNewQuest(_idCharacter,v,0)
					Quest_SetMask(_idCharacter,v,7,nTime)
					BranchQuest_SendMail(_idCharacter,v)
				else
					Quest_DeleteQuest(_idCharacter,v)
					Quest_AddNewQuest(_idCharacter,v,0)
					Quest_SetMask(_idCharacter,v,7,nTime)
				end
				
			end
		end
	end

	if ("table" == type(tBranchQuestOpen[TASKTYPE.QuestComplete]))then
		for k,v in pairs(tBranchQuestOpen[TASKTYPE.QuestComplete]) do
			--如果是完成的任务的任务 判断一次条件检测
			if Quest_IsQuestComplete(_idCharacter, tQuestInfo[v]["OpenCon"][2]) then
				BranchQuest_Check(_idCharacter,v,tQuestInfo[v]["OpenCon"][2],TASKTYPE.QuestComplete)
			end
			
		end
	end
	if ("table" == type(tBranchQuestOpen[TASKTYPE.LevelUp]))then		
		for k,v in pairs(tBranchQuestOpen[TASKTYPE.LevelUp]) do
			BranchQuest_Check(_idCharacter,v,TASKTYPE.LevelUp,0,System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL))
		end
	end
	
	if ("table" == type(tBranchQuestOpen[TASKTYPE.CharacterRealm]))then
		for k,v in pairs(tBranchQuestOpen[TASKTYPE.CharacterRealm]) do
			BranchQuest_Check(_idCharacter,v,TASKTYPE.CharacterRealm,System_GetAttrInt(_idCharacter,CHARACTER_INT.CHARACTER_REALM))
		end
	end

end
--未领奖的隔天发邮件
function BranchQuest_SendMail(_idCharacter,_nQuestId)
	local nMoney = tQuestInfo[_nQuestId]["AddMoney"]
	--没办法发经验 
	local nExp   = tQuestInfo[_nQuestId]["AddExp"]

	local sItem = System_ItemVec2String(tQuestInfo[_nQuestId]["AddItem"],8)
	System_SendMail(_idCharacter,mailid,sItem,nMoney)
end

function BranchQuest_Login(_idCharacter,_nOstime)

end
table.insert(tOnLoginActivity,BranchQuest_Login)