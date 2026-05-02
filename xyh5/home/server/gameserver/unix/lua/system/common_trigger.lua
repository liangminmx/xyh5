--************************玩家成功创建人物后触发主函数入口：（目前功能：初始化任务）
function C2L_OnUserRegistered(_idCharacter)
	--C2L_OnAcceptQuest(_idCharacter,10010)
	--这个接口现在没用
end

--************************玩家上线登陆触发主函数入口：（目前功能：重置每日任务,接新的后续任务）
--**********  （玩家ID，上线时间）
function C2L_LoginTrigger(_idCharacter,_nOsTimes)
	--用于记录每日任务状态
	--if -1 == Quest_GetQuestFlag(_idCharacter,QUESTIDTYPE.BranchQuest_Begin) then
	--	Quest_AddNewQuest(_idCharacter,QUESTIDTYPE.BranchQuest_Begin,0)
	--end

	if false == System_IsCrossSever() then	
		OnDailyQuestLogin(_idCharacter,_nOsTimes)
		OnGuildQuestLogin(_idCharacter,_nOsTimes)
		if	nil ~= tOnLoginActivity then
			for	k,v in pairs(tOnLoginActivity) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	else
		OnGuildQuestLogin(_idCharacter,_nOsTimes)
		if	nil ~= tOnLoginActivity_Cross then
			for	k,v in pairs(tOnLoginActivity_Cross) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	end
end

--************************玩家下线登陆触发主函数入口：
--**********  （玩家ID，下线时间）
function C2L_LogoutTrigger(_idCharacter,_nOsTimes)
	if false == System_IsCrossSever() then	
		if	nil ~= tOnLogoutActivity then
			for	k,v in pairs(tOnLogoutActivity) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	else
		if	nil ~= tOnLogoutActivity_Cross then
			for	k,v in pairs(tOnLogoutActivity_Cross) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	end
end

--************************玩家充值触发主函数入口：（目前功能：重置每日任务,接新的后续任务）
--******** 离线充值是玩家上线时才触发
--11000700001,1000,1574418920

function C2L_OnRecharge(_idCharacter,_nEmoney,_nOsTimes)
	if false == System_IsCrossSever() then	
		if tOnUserRechargeEmoney ~= nil then
			for k,v in pairs(tOnUserRechargeEmoney) do 
				if type(v) == "function" then 
					v(_idCharacter,_nEmoney,_nOsTimes)
				end
			end
		end
	else
		if tOnUserRechargeEmoney_Cross ~= nil then
			for k,v in pairs(tOnUserRechargeEmoney_Cross) do 
				if type(v) == "function" then 
					v(_idCharacter,_nEmoney,_nOsTimes)
				end
			end
		end
	end
	
end

--************************玩家消费触发主函数入口：（目前功能：重置每日任务,接新的后续任务）
function C2L_OnCostEmoney(_idCharacter,_nEmoney)
	if false == System_IsCrossSever() then	
		if tOnUserSpendEmoney ~= nil then
			for k,v in pairs(tOnUserSpendEmoney) do 
				if type(v) == "function" then 
					v(_idCharacter,_nEmoney)
				end
			end
		end
	else
		if tOnUserSpendEmoney_Cross ~= nil then
			for k,v in pairs(tOnUserSpendEmoney_Cross) do 
				if type(v) == "function" then 
					v(_idCharacter,_nEmoney)
				end
			end
		end
	end
	
end

--************************玩家领取活动奖励触发主函数入口
function C2L_OnAcitveAward(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if false == System_IsCrossSever() then	
		-- L2C_DebugLog("::C2L_OnAcitveAward apply reward type is " .. _nCActionType)
		if	"function" == type(tOnOnAcitveAward[_nCActionType]) then
		local	nRet =tOnOnAcitveAward[_nCActionType](_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
		-- L2C_DebugLog("::C2L_OnAcitveAward : ret is :"..nRet)
		return nRet
		end		
	else
		-- L2C_DebugLog("::C2L_OnAcitveAward apply reward type is " .. _nCActionType)
		if	"function" == type(tOnOnAcitveAward_Cross[_nCActionType]) then
		local	nRet =tOnOnAcitveAward_Cross[_nCActionType](_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
		-- L2C_DebugLog("::C2L_OnAcitveAward : ret is :"..nRet)
		return nRet
		end		
	end
end

--************************玩家完成某一项事件触发(如过关哪一个副本，杀敌100等)
function C2L_ActionTrigeer(_idCharacter,_nCActionTriggerType,_nData3,_nData4,_nData5)
	if false == System_IsCrossSever() then	
		if	nil ~= tOnCompleteThings then
			for	k,v in pairs(tOnCompleteThings) do
				if	"function" == type(v) then
					v(_idCharacter,_nCActionTriggerType,_nData3,_nData4,_nData5)
				end
			end
		end
	else
		if	nil ~= tOnCompleteThings_Cross then
			for	k,v in pairs(tOnCompleteThings_Cross) do
				if	"function" == type(v) then
					v(_idCharacter,_nCActionTriggerType,_nData3,_nData4,_nData5)
				end
			end
		end
	end
end

--************************ 0点触发 传个时间 防脚本自己取的时间与触发时间有误差
--*******  即使间隔很多天也只触发一次  请注意
function C2L_OnZeroRefresh(_idCharacter,_nOsTimes)
	if false == System_IsCrossSever() then	
		if	nil ~= tOnZeroTrigger then
			for	k,v in pairs(tOnZeroTrigger) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	else
		if	nil ~= tOnZeroTrigger_Cross then
			for	k,v in pairs(tOnZeroTrigger_Cross) do
				if	"function" == type(v) then
					v(_idCharacter,_nOsTimes)
				end
			end
		end
	end

	--这个需要活动支持 放后面
	OnDailyQuestLogin(_idCharacter)
end

--************************时间触发  每分钟  无玩家ID 
function C2L_OnTimeTrigeer(_nOsTimes)
	if System_IsCrossSever() then	
		return
	end
	nTime = _nOsTimes or os.time()
	local nCurHour = os.date("*t",nTime)["hour"]
	local nCurMin  = os.date("*t",nTime)["min"]
	local nCurSec  = os.date("*t",nTime)["sec"]
	local nCurMon = os.date("%m",nTime)
	local nCurDay = os.date("%d",nTime)
	local nCurYear = os.date("%y",nTime)
	if tTime_M[nCurMin] ~= nil then
		for i,v in pairs (tTime_M[nCurMin]) do
			local isRomve = v(_nOsTimes)
			if isRomve then
				table.remove(tTime_M[nCurMin],i)
			end
		end
	end
		
	if tTime_HM[nCurHour*100 + nCurMin] ~= nil then
		for i,v in pairs (tTime_HM[nCurHour*100 + nCurMin]) do
			local isRomve = v(_nOsTimes)
			if isRomve then
				table.remove(tTime_HM[nCurHour*100 + nCurMin],i)
			end
		end
	end
end

--功能解锁
-- eUMT_MsgOpenBranchTaskModule 30018 解锁支线
function C2L_TryOpenModule(_idCharacter,_nMsgId)
	if System_IsCrossSever() then	
		return
	end
	if _nMsgId == 30018 then
		local nRet = System_OpenGuideFunction(_idCharacter,1090)
		--解锁时检测条件
		if nRet == 0 then
			local nlevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
			BranchQuest_Check(_idCharacter,QUESTIDTYPE.BranchQuest_Begin ,TASKTYPE.LevelUp,
					0,nlevel,0)
			--L2C_DebugLog("C2L_TryOpenModule"..nlevel)
					
			local nRealm = System_GetAttrInt(_idCharacter,CHARACTER_INT.MAID_REALM)
			local nStage = System_GetAttrInt(_idCharacter,CHARACTER_INT.MAID_STAGEID)
			
			--L2C_DebugLog("C2L_TryOpenModule"..nRealm.."|"..nStage)
			BranchQuest_Check(_idCharacter,QUESTIDTYPE.BranchQuest_Begin ,TASKTYPE.CharacterRealm,
					nRealm,nStage,0)
		end
		return nRet
	end
	return -1
end
--同任务检测触发  不过这个没有任务ID
--任务数据更新，条件检测  （_nData1：怪物id、NPCid； _nData2：数量数值 几只或几级 ；_nData3:预留）
function C2L_QuestTrigeer(_idCharacter,_nTaskType,_nData1,_nData2,_nData3)
	if false == System_IsCrossSever() then	
		if tQuestTrigeer ~= nil and tQuestTrigeer[_nTaskType] ~= nil then
			for	k,v in pairs(tQuestTrigeer[_nTaskType]) do
				if	"function" == type(v) then
					v(_idCharacter,_nTaskType,_nData1,_nData2,_nData3)
				end
			end
		end
	else
		if tQuestTrigeer_Cross ~= nil and tQuestTrigeer_Cross[_nTaskType] ~= nil then
			for	k,v in pairs(tQuestTrigeer_Cross[_nTaskType]) do
				if	"function" == type(v) then
					v(_idCharacter,_nTaskType,_nData1,_nData2,_nData3)
				end
			end
		end
	end
end

-- 角色死亡触发
function C2L_CharacterDead(_idCharacter)
	if false == System_IsCrossSever() then	
		if tOnCharacterDead ~= nil then
			for k,v in pairs(tOnCharacterDead) do
				if "function" == type(v) then
					v(_idCharacter)
				end
			end
		end
	else
		if tOnCharacterDead_Cross ~= nil then
			for k,v in pairs(tOnCharacterDead_Cross) do
				if "function" == type(v) then
					v(_idCharacter)
				end
			end
		end
	end
end
-- GlobalData操作
-- 游服返回的查询结果 
function C2L_CrossGlobalDataQuery(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	if false == System_IsCrossSever() then	
		return
	end
	if "function" == type(tGlobalDataQueryTrigeer[_nAction]) then
		tGlobalDataQueryTrigeer[_nAction](_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	end
end
-- 游服返回的修改结果 
function C2L_CrossGlobalDataUpdate(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	if false == System_IsCrossSever() then	
		return
	end
	if "function" == type(tGlobalDataUpdateTrigeer[_nAction]) then
		tGlobalDataUpdateTrigeer[_nAction](_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	end
end
