require "globalvalue"
--baidu

function access_baidu(type, datavalue)
	local g_baidu_post_url = "wanba.baidu.com/roleAction/gameRolePost.jsp"
	local g_baidu_api_key = "4d0c8f23014d7ac0b15321f15075b764"
	local g_baidu_api_secret = "8a9a52c84d0c8f23014d5075b76421f2"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_upgradelog" or g_http_post_type[type] == "eHPT_Register" then		--baidu推送
		newtable["server_id"] = "s" .. datavalue["sid"]
		newtable["api_key"] = g_baidu_api_key
		local account = datavalue["accountName"]
		local index = string.find(account,"_")
		if (index) then
			newtable["user_id"] = string.sub(account, index + 1)
		else
			newtable["user_id"] = account
		end
		newtable["role_name"] = datavalue["playerName"]
		newtable["role_level"] = datavalue["newlevel"]
		newtable["action"] = datavalue["action"]
		newtable["timestamp"] = datavalue["timestamp"]
		newtable["role_time"] = datavalue["timestamp"]
		newtable["role_time"] = string.gsub(newtable["role_time"],"-","")
		newtable["role_time"] = string.gsub(newtable["role_time"],":","")
		newtable["role_time"] = string.gsub(newtable["role_time"]," ","")
		newtable["role_online_time"] = datavalue["role_online_time"]
		newtable["multi_flag"] = "N"
		newtable["role_count_online_time"] = datavalue["role_count_online_time"]
		table.sort(newtable)
		local test_table = {a=3,b=2,c=4,d=1}
		local key_table = {}
		--取出所有的键
		for key,_ in pairs(newtable) do
			table.insert(key_table,key)
		end
		--对所有键进行排序
		table.sort(key_table)
		local str = g_baidu_api_secret
		for _,key in pairs(key_table) do
			str = str .. key .. newtable[key]
		end
		newtable["sign"] = luaMD5String(str)
		newtable["sign"] = string.upper(newtable["sign"])
		luaCurlRequest(g_baidu_post_url,"","http","post",newtable)
	end

end

