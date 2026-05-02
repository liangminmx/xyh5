local nResId = CRESOURCEFLOWACTION.eFT_FestivalWeb
local nLuaTempid = LUARESOURCEFLOWACTION[nResId]
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local festivalweb_Info = _festivalweb_Info['root'][1]['group']

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 玩家登录
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FestivalWeb_Person_Login(_idCharacter,_nOsTimes)
	_nOSTime = _nOSTime or os.time()
	GM_FestticalWeb_instance_Login(_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaTempid) then
		System_AddTempData(_idCharacter,nLuaTempid,false)
	end
	FestivalWeb_Person_SendActiveStatus(_idCharacter)
end
table.insert(tOnLoginActivity,FestivalWeb_Person_Login)

-- ===============================================================================================================
-- 发放活动状态给客户端
-- =============================================================================================================== 
function FestivalWeb_Person_SendActiveStatus(_idCharacter)	
	local status = System_GetGlobalData(nLuaGlobal,1)
	local status_p = System_GetTempData(_idCharacter,nLuaTempid,1)
	local nBeg = 0
	local nEnd = 0
	if status == 1 then
		nBeg = System_GetGlobalData(nLuaGlobal,2)
		nEnd = System_GetGlobalData(nLuaGlobal,3)		
		System_Festival_Web(_idCharacter,System_GetGlobalData(nLuaGlobal,4))
		System_SetTempData(_idCharacter,nLuaTempid,1,1)		
		System_SendActiveStatus(_idCharacter,nResId,status,nBeg,nEnd)
	end
	
	if status == 0 and status_p == 1 then
		System_SetTempData(_idCharacter,nLuaTempid,1,0)	
		System_SendActiveStatus(_idCharacter,nResId,status,nBeg,nEnd)
	end	
end

