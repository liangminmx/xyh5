require "globalvalue"
--360



function access_360(type, datavalue)
	local g_360_post_url = "game.api.1360.com/player"
	local g_360_game_key = "mhj"
	local g_360_login_key = "7bd6a4db41dca399eb58af7a3a4a1bda"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_upgradelog" or g_http_post_type[type] == "eHPT_Register" then		--360อฦหอ
		newtable["server_id"] = "S" .. datavalue["sid"]
		newtable["gkey"] = g_360_game_key
		local account = datavalue["accountName"]
		newtable["qid"] = string.sub(account,string.find(account,"_") + 1)
		newtable["name"] = datavalue["playerName"]
		newtable["level"] = datavalue["newlevel"]
		newtable["sign"] = luaMD5String(newtable["gkey"] .. newtable["level"] .. newtable["name"] .. newtable["qid"] .. newtable["server_id"] .. g_360_login_key)

		luaCurlRequest(g_360_post_url,"","http","post",newtable)
	end

end

