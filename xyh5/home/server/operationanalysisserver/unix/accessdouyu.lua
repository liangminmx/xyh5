require "globalvalue"
--baidu

function access_douyu(type, datavalue)
	local g_douyu_post_url = "api.douyutv.com/api/ncmhj/level_notify"
	local g_douyu_api_key = "IX76VrPXZa9nflJc"
	local g_douyu_game_id = "21"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_upgradelog" or g_http_post_type[type] == "eHPT_Combat" then		--baiduÍÆËÍ
		local time = datavalue["timestamp"]
		time = string.gsub(time,"-","")
		time = string.gsub(time,":","")
		time = string.gsub(time," ","")
		newtable["game_id"] = g_douyu_game_id
		newtable["ip"] = datavalue["ip"]
		local account = datavalue["accountName"]
		local index = string.find(account,"_")
		if (index) then
			newtable["uid"] = string.sub(account, index + 1)
		else
			newtable["uid"] = account
		end

		if g_http_post_type[type] == "eHPT_upgradelog" then
			newtable["level"] = datavalue["newlevel"]
			newtable["time"] = time
			newtable["type"] = "2"
		else
			newtable["level"] = datavalue["combat"]
			newtable["time"] = time
			newtable["type"] = "5"
		end
		newtable["zid"] = datavalue["sid"]
		newtable["ztime"] = datavalue["openservertime"]

		local str = "game_id=" .. newtable["game_id"]
		str = str .. "&ip=" .. newtable["ip"]
		str = str .. "&uid=" .. newtable["uid"]
		str = str .. "&level=" .. newtable["level"]
		str = str .. "&time=" .. newtable["time"]
		str = str .. "&type=" .. newtable["type"]
		str = str .. "&zid=" .. newtable["zid"]
		str = str .. "&ztime=" .. newtable["ztime"]
		str = str .. "&key=" .. g_douyu_api_key
		newtable["sign"] = luaMD5String(str)
		newtable["sign"] = string.upper(newtable["sign"])
		luaCurlRequest(g_douyu_post_url,"","http","get",newtable)
	end

end

