-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		data1 字段，已接到的missionid
--		data2 字段，领到任务的时间
--		data3 字段，当前任务状态
--		data4 字段，是否已完成所有任务
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local nflowaction = CRESOURCEFLOWACTION.eFT_SecretMission
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]
local tSecretMissionInfo = _secret_mission_Info.root[1]

--领取
function SecretMission_ProcessRecieveMission(_idCharacter,_nCActionType,_nMissionId,_nData4,_nData5)
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if nLevel >= tSecretMissionInfo.gettitle[_nMissionId].getlv then
		local nGetTaskTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
		if os.date("%y%m%d",nGetTaskTime) == os.date("%y%m%d",os.time()) then
			return 2
		end	
		if nil ~= tSecretMissionInfo.gettitle[_nMissionId + 1] then
			if 1 == tSecretMissionInfo.gettitle[_nMissionId + 1].tomorrowget then
				System_SetTempData(_idCharacter,nLuaIdActivity,2,os.time(),false)
				System_SetTempData(_idCharacter,nLuaIdActivity,3,2,false)
			else
				System_SetTempData(_idCharacter,nLuaIdActivity,3,1,false)
			end
			--这里都不发  成功时服务端发
			System_SetTempData(_idCharacter,nLuaIdActivity,1,_nMissionId + 1,false)					

		else
			System_SetTempData(_idCharacter,nLuaIdActivity,4,1,false)			
		end
		
		local tGetTitle = tSecretMissionInfo.gettitle[_nMissionId]
		local title,mode,times = tGetTitle.gettitle,tonumber(tGetTitle.titletimetype) or 0,tonumber(tGetTitle.itemtime) or 0
		eActiveDesignT_SecretMission = 4
		System_AddActiveDesign(_idCharacter,title,eActiveDesignT_SecretMission,mode,times)
		return 0		
	end
	return 1
end
--屏蔽神秘任务
-- tOnOnAcitveAward[nflowaction] = SecretMission_ProcessRecieveMission

function SecretMission_LevelUp(_idCharacter,_old,_new)
	for k,v in pairs(tSecretMissionInfo.secretmission) do
		if nil ~= tonumber(v.showlv) then
			if tonumber(_new) >= tonumber(v.showlv) and  tonumber(_old) < tonumber(v.showlv)  then
				System_SetTempData(_idCharacter,nLuaIdActivity,1,k,false)
				System_SetTempData(_idCharacter,nLuaIdActivity,3,1)
			end
		end
	end
end
-- /////////////////////////////////////////////////////////////////////////////////
--   玩家登录
-- /////////////////////////////////////////////////////////////////////////////////
function SecretMission_OnLogin(_idCharacter,_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		--增加任务时检验是否已超过这个等级
		System_AddTempData(_idCharacter,nLuaIdActivity,false)
		SecretMission_LevelUp(_idCharacter,1,System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL))
	end
	local nGetTaskTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	if os.date("%y%m%d",nGetTaskTime) == os.date("%y%m%d",_nOsTimes) then	
		System_SetTempData(_idCharacter,nLuaIdActivity,3,2)
	else
		System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,3,0)
	end
end
--屏蔽神秘任务
-- table.insert(tOnLoginActivity,SecretMission_OnLogin)

-- /////////////////////////////////////////////////////////////////////////////////
--	0点刷新充值
-- /////////////////////////////////////////////////////////////////////////////////
function SecretMission_ZeroRefresh(_idCharacter,_nOsTimes)	
	SecretMission_OnLogin(_idCharacter,_nOsTimes)
end
--屏蔽神秘任务
-- table.insert(tOnZeroTrigger,SecretMission_ZeroRefresh)

-- /////////////////////////////////////////////////////////////////////////////////
--	取mission对应的title
-- /////////////////////////////////////////////////////////////////////////////////
function SecretMission_getTitleID(_idCharacter,_nCActionType,_nMissionId,_nData4,_nData5)
	if nil ~= tSecretMissionInfo.gettitle[_nMissionId] then
		return tSecretMissionInfo.gettitle[_nMissionId].gettitle or 0
	end
	return 0
end
tGetActivityData[CRESOURCEFLOWACTION.eFT_SecretMission] = SecretMission_getTitleID