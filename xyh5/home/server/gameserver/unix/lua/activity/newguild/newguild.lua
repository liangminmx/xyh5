local tForecastInfo = _functionalforecast_Info.root[1].forecast
function NewGuild_processGetAwardNewGuildReq(_idCharacter,_nCActionType,_nIndex,_nData4,_nData5)
	if _nIndex and "table" == type(tForecastInfo[_nIndex]) then
		local tIdItem = System_Split(tForecastInfo[_nIndex]["realmitem"],",")
		local tNum = System_Split(tForecastInfo[_nIndex]["realmnum"],",")
		for i = 1,#tIdItem do
			if	false == System_AwardThingInBag(_idCharacter,_nCActionType,tIdItem[i],(tNum[i] or 0)) then
				System_AwardThingQuestContainer(_idCharacter,_nCActionType,tIdItem[i],(tNum[i] or 0))
			end
		end
	end
	return 1
end
tOnOnAcitveAward[CRESOURCEFLOWACTION.eFT_NewguildAward] = NewGuild_processGetAwardNewGuildReq