require "globalvalue"
--baidu

function access_aiwan(type, datavalue)
	local g_aiwan_post_url = "union.tencentlog.com/cgi-bin/Register.cgi"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_UnionRegisterExtra" then		--baiduÍÆËÍ
		newtable["appid"] = g_tencent_app_id
		newtable["userip"] = datavalue["userip"]
		newtable["version"] = datavalue["version"]
		newtable["svrip"] = datavalue["svrip"]
		newtable["time"] = datavalue["time"]
		newtable["worldid"] = datavalue["worldid"]
		newtable["opuid"] = datavalue["opuid"]
		newtable["opopenid"] = datavalue["opopenid"]
		newtable["pf"] = datavalue["pf"]
		newtable["openkey"] = datavalue["openkey"]
		newtable["pfkey"] = datavalue["pfkey"]

		luaCurlRequest(g_aiwan_post_url,"","http","get",newtable)
	end

end

