local tGuideFunctionInfo = _guidefunction_Info["root"][1]["function"]

--等级解锁触发
function GuideFunction_Trigeer_Level(_idCharacter,_nOld,_nNew)
	for k,v in pairs(tGuideFunctionTrigeer) do
		for l,w in pairs(tGuideFunctionInfo) do
			if w.functionid == k then			
				if "number" == type(w.lev)and _nOld < w.lev and _nNew >= w.lev then
					v(_idCharacter,_nOld,_nNew)
				end
			end
		end
	end	
end

