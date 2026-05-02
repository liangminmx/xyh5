require "globalvalue"
require "access360"
require "access51"
require "dongwang"
require "accessbaidu"
require "aiwan"
require "accessgemen"
require "accessdouyu"

function httppost(version,serverid, type, num, ...)
	--把值转为table
	datavalue = {}
	local keyvale = ""
	for i, v in ipairs{...} do
		--print(i,v)
		if(i%2 == 0) then
			datavalue[keyvale] = v
			--print(keyvale,v)
		else
			keyvale = v
		end
     end


	versionName = getVersionName(version)
	--print(versionName)


	if versionName == "VERSION_douyu" then
		access_douyu(type, datavalue)
	elseif versionName == "VERSION_gemen" then
		access_gemen(type, datavalue)
	elseif versionName == "VERSION_baidu" then
		access_baidu(type, datavalue)
	elseif versionName == "VERSION_51" then
		access_51(type, datavalue)
	elseif versionName == "VERSION_360" then
		access_360(type, datavalue)
	elseif versionName == "VERSION_TENCENT" then--动网处理方式
		--根据类型获得表名
		excelname = getExcelNameByType(type)
		if (excelname) then
			--获得sql语句
			sqlstr = dongwanggetsql(datavalue,excelname)
			--print(sqlstr)
			--存库
			luaSqlExcute(serverid,sqlstr)
		else
			local script = g_compass_script[type]
			if (script) then
				datavalue["appid"] = g_tencent_app_id
				luaCurlRequest(g_compass_url,script,"http","post",datavalue)
			end
			access_aiwan(type, datavalue)
		end

	elseif versionName == "VERSION_LAN" then--内网处理
		--根据类型获得表名
		excelname = getExcelNameByType(type)
		if (excelname) then
			--获得sql语句
			sqlstr = dongwanggetsql(datavalue,excelname)
			--print(sqlstr)
			--存库
			luaSqlExcute(serverid,sqlstr)
		end
	end

end



--httppost(1,1,1,7,"sid","111","playerId","rtypo","accountName","gg","playerName","ggg",
	--"playerlevel","1","platform","lan","createTime","401231564")
