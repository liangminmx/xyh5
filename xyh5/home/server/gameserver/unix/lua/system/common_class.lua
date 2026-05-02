local __WCBit = {}
WCBit = {}
--设置为只读
local mt = {
      __index = function(t,k) return __WCBit[k] end ;
      __newindex = function(t, k, v)
       end
     }
setmetatable(WCBit, mt) 

__WCBit.SetTrue = function(_nData,_nIndex)	
	local value = 2 ^(_nIndex - 1)
	return _nData|value
end

__WCBit.SetFalse = function(_nData,_nIndex)
	local value = 2 ^(_nIndex - 1)	
	return  _nData&(~value)
end

__WCBit.GetBit = function(_nData,_nIndex)	
	if type(_nIndex) ~= "number" or _nIndex <= 0 then 
		L2C_DebugLog([[Error：WCBit.GetBit  _nIndex no a Right Data【]].. (_nIndex or "Nil")..[[】]])
		return false
	end
	local value = 2 ^(_nIndex - 1)	
	if 0 ~= _nData&value then
		return true
	else
		return false
	end
end

local _tWCTempData = {}
WCTempData = {}
local MtTempData ={
	__index = function(t,k)
		if ("number" == type(k) and k >= 1 and k <=8) then
			return System_GetTempData(t["Character"],t["Temp"],k)
		end
		if ("str" == k) or ("STR" == k) or ("Str" == k)then
			return System_GetTempDataStr(t["Character"],t["Temp"])
		end
		return -1
	end,
	__newindex = function(t,k,v)
		if ("number" == type(k) and k >= 1 and k <=8) then
			System_SetTempData(t["Character"],t["Temp"],k,v,false)
		end
		if ("str" == k) or ("STR" == k) or ("Str" == k)then
			return System_SetTempDataStr(t["Character"],t["Temp"],v,false)
		end
	end
}
--
function WCTempData:Get(_idCharacter,_nTempId)
	--非正确的活动掩码
	if "number" ~= type(_nTempId) then
		L2C_DebugLog([[No a Right TempData!!  _nTempId:]].. _nTempId)
		return false,{}
	end
	
	_tWCTempData[_nTempId] = _tWCTempData[_nTempId] or {}	
	_tWCTempData[_nTempId][_idCharacter] = _tWCTempData[_nTempId][_idCharacter] or {}
	_tWCTempData[_nTempId][_idCharacter]["Character"] = _idCharacter
	_tWCTempData[_nTempId][_idCharacter]["Temp"] = _nTempId
	
	--添加   
	--如果没有掩码 直接赋值也会添加掩码
	_tWCTempData[_nTempId][_idCharacter]["Add"] = function(_IsSend)
		return System_AddTempData(_idCharacter,_nTempId,_IsSend)
	end
	_tWCTempData[_nTempId][_idCharacter]["add"] = _tWCTempData[_nTempId][_idCharacter]["Add"]
	_tWCTempData[_nTempId][_idCharacter]["ADD"] = _tWCTempData[_nTempId][_idCharacter]["Add"]
	--更新 将数据发给其他模块和客户端
	_tWCTempData[_nTempId][_idCharacter]["Update"] = function(_nAciton)		
		_nAciton = _nAciton or 4
		return System_SendTempData2Other(_idCharacter,_nTempId,_nAciton)
	end
	_tWCTempData[_nTempId][_idCharacter]["update"] = _tWCTempData[_nTempId][_idCharacter]["Update"]
	_tWCTempData[_nTempId][_idCharacter]["UPDATE"] = _tWCTempData[_nTempId][_idCharacter]["Update"]
	--删除
	_tWCTempData[_nTempId][_idCharacter]["Del"] = function(_IsSend)
		return System_DelTempData(_idCharacter,_nTempId,_IsSend)
	end
	_tWCTempData[_nTempId][_idCharacter]["del"] = _tWCTempData[_nTempId][_idCharacter]["Del"]
	_tWCTempData[_nTempId][_idCharacter]["DEL"] = _tWCTempData[_nTempId][_idCharacter]["Del"]
	
	setmetatable(_tWCTempData[_nTempId][_idCharacter],MtTempData) 
	return true,_tWCTempData[_nTempId][_idCharacter]
end

