local tTaskDailyInfo = _task_Info.root[1].taskroom 

local tDailyQuestRoom = {}	--章节信息
local tDailyQuestRoomInfo = {}

for k,v in pairs(tTaskDailyInfo) do	
	for l,w in pairs(v.task)do
		local taskId = w.taskId
		tQuestInfo[taskId] = {}
		tQuestInfo[taskId]["TaskRoom"] = v.taskroom
		tQuestInfo[taskId]["TaskType"] = 12
		tQuestInfo[taskId]["Condition"] = {w.monsterId,w.num}
		tQuestInfo[taskId]["AddExp"] = w.exp
		tQuestInfo[taskId]["AddMoney"] = "number" == type(w.money) and w.money or 0
		
		
		tDailyQuestRoom[v.taskroom] = tDailyQuestRoom[v.taskroom] or {}
		table.insert(tDailyQuestRoom[v.taskroom],taskId)

	end
end

local nIndex = 1
for i,v in pairs(tDailyQuestRoom) do
	tDailyQuestRoomInfo[nIndex] = i
	nIndex = nIndex + 1
end



--任务 随机一个任务 返回任务ID
function C2L_OnRandomQuest(_nQuestIdBegin,_nData1)	
	math.random(1,2)
	if QUESTIDTYPE.DailyQuest_Begin == _nQuestIdBegin then	
		local nRan = math.random(1,#tDailyQuestRoom[_nData1]) 
		return tDailyQuestRoom[_nData1][nRan] or 0
	end
	if QUESTIDTYPE.GuildQuest_Begin == _nQuestIdBegin then	
		return GuildQuest_Random(_nData1)
	end
end

--返回lib 总信息 0为个数   1起 每个库的lib
function C2L_QueryDailyQuestLibInfo(_nIndex)
	if 0 == _nIndex then
		return #tDailyQuestRoomInfo	
	end	
	if nil == _nIndex then
		return 0
	end
	return tDailyQuestRoomInfo[_nIndex] or 0
end