//prepreload();
var sizeMD5JS;
var sizeZlib;
var sizeFileTool;
var sizeSFS2X_API_JS;
var sizeMainJS;
var sizeMainUnCompress;
var sizeMainAnalysis;

var sizeTotal;

var sizeLoaded = 0;

var scripts;
var loadSpeed;
var unCompressSpeed;

var isNewPlayer_FromJs_byYP = false;

/*var ua = window.navigator.userAgent;
if(ua.indexOf('Android') > -1 || ua.indexOf('Adr') > -1)
{
	ua = "Android";
}
else if(ua.indexOf("iPhone") > -1 || ua.indexOf("iPad") > -1)
{
	ua = "IOS";
}
else if(ua.indexOf("Mobile") == -1)
{
	ua = "PC"
}
else
{
	ua = "OtherMobile";
}
var USERAGENT = {'from':ua};*/

///////////////progressBar/////////////

var bar_img;
var barImgLoaded;
var barPercent;
var mainFileStr;

//////////////serverSelect/////////////

var lastLoggedServer;
var serverList;
var serverListNoFull;
var userServer;
var recommandList;
var selectedServer = null;
var selectedUser;
var selectedPage = -1;

///////////////////////////////////////
var evalStartTime;
var enterClicked = false;
var gameInited = false;
///////////////////////////////////////

var lognum = 0;
var divLogEnabled = false;
var wanbaVipLevel = 0;

var serverData;
var recentLoginServerData;
var pageServerData = {};
var arrSrvGroupID = new Array();
var selectedSrvGroupID = -1;

var ipSelf = "";
var isWhiteMan = false;
var isSetCSAddress = false;

var wanbaVipLevel = 0;
var gank_sdk;
var divQrCodeEnabled = false;
var qrcode = null;
var qrcodeRemoveHandler;

var srvListResp = "";

//alert("begin preload");
preload();

//生成从minNum到maxNum的随机数
function randomNum(minNum,maxNum){ 
    switch(arguments.length){ 
        case 1: 
            return parseInt(Math.random()*minNum+1,10); 
        break; 
        case 2: 
            return parseInt(Math.random()*(maxNum-minNum+1)+minNum,10); 
        break; 
            default: 
                return 0; 
            break; 
    } 
}

// Generate four random hex digits. 
function S4() { 
   return (((1+Math.random())*0x10000)|0).toString(16).substring(1); 
}

// Generate a pseudo-GUID by concatenating random hexadecimal. 
function guid() { 
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()); 
}

function uuid() {
  var s = [];
  var hexDigits = "0123456789abcdef";
  for (var i = 0; i < 36; i++) {
    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
  }
  s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
  s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01
  s[8] = s[13] = s[18] = s[23] = "-";
 
  var uuid = s.join("");
  return uuid;
}

function setupWebViewJavascriptBridge(callback) {  
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }  
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }  
    window.WVJBCallbacks = [callback];  
    var WVJBIframe = document.createElement('iframe');  
    WVJBIframe.style.display = 'none';  
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';  
    document.documentElement.appendChild(WVJBIframe);  
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)  
}

function prepreload()
{
	alert("prepreload()");
}

function preload()
{
	//alert("preload");
	if (supportOrientation) {
		window.addEventListener('orientationchange', updateOrientation, false);
	}
	updateOrientation();

	sendLog("login_log", "enter preload.js");

	
	//初始化独角兽SDK
	//gank_sdk = window.GANK_SDK || {};
	/*gank_sdk.config([APPID], function (type) {
    	//分享回调内容
	}, function () {
	    //充值回调内容
	}, function () {
	    //关注回调内容
	}, function (uid, openid, channelid, userinfo) {
		//登录回调处理（userinfo内容同gank_sdk.getUserInfo方法一致）
		if (null == GetQueryString("uid")) {
			deviceId = uid;
		}
	});*/
	
	sizeMD5JS = 9;
	sizeZlib = 18;
	sizeJSZip = 100;
	sizeFileTool = 3;
	sizeCRYPTOJS = 188;
	sizeLONG = 9;
	sizeBYTEBUFFERAB = 40;
	sizePROTOBUF = 50;
	sizeKEY = 27;
	sizeNETPACKET = 10;
	sizeCONNECTION = 6;
	sizeCFGCACHE = 5;
	sizeRAWINFLATE = 6;
	sizeB3CORE = 87;
	sizeMainJS = 802;
	sizeMainUnCompress = 1200;
	sizeMainAnalysis = 300;
	
	sizeTotal = sizeMD5JS + sizeZlib + sizeJSZip + sizeFileTool + sizeCRYPTOJS + sizeLONG + sizeBYTEBUFFERAB + sizePROTOBUF + sizeKEY + sizeNETPACKET 
	+ sizeCONNECTION + sizeCFGCACHE + sizeRAWINFLATE + sizeB3CORE + sizeMainJS + sizeMainUnCompress + sizeMainAnalysis;

	sizeLoaded = 0;
	
	showPreloadView();
	
	addLogDiv();

	updateLoadTxt("加载基础库");
	//updateLoadTxt("正在维护版本，请稍候。");
	//return;
	
	scripts = [];
	scripts.push({path:getCDNRootPath()+"md5.js?v="+version(), size:sizeMD5JS, log:"md5.js loaded"});
	scripts.push({path:getCDNRootPath()+"jszip.min.js?v="+version(), size:sizeJSZip, log:"jszip.js loaded"});
	scripts.push({path:getCDNRootPath()+"zlib.min.js?v="+version(), size:sizeZlib, log:"zlib.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"js/FileTool.min.js?v="+version(), size:sizeFileTool, log:"FileTool.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"js/crypto-js/crypto-js.js?v="+version(), size:sizeCRYPTOJS, log:"crypto-js.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/Long.min.js?v="+version(), size:sizeLONG, log:"Long.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/ByteBufferAB.min.js?v="+version(), size:sizeBYTEBUFFERAB, log:"ByteBufferAB.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/ProtoBuf.min.js?v="+version(), size:sizePROTOBUF, log:"protobuf.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/Key.js?v="+version(), size:sizeKEY, log:"Key.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/NetPacket.js?v="+version(), size:sizeNETPACKET, log:"NetPacket.js loaded"});
	scripts.push({path:getCDNRootPath()+"network/Connection.js?v="+Math.random(), size:sizeCONNECTION, log:"Connection.js loaded"});
	scripts.push({path:getCDNRootPath()+"lylib/CfgCache.js?v="+version(), size:sizeCFGCACHE, log:"CfgCache.js loaded"});
	scripts.push({path:getCDNRootPath()+"lylib/rawinflate.min.js?v="+version(), size:sizeRAWINFLATE, log:"rawinflate.min.js loaded"});
	scripts.push({path:getCDNRootPath()+"lylib/b3core.0.1.0.js?v="+version(), size:sizeB3CORE, log:"b3core.0.1.0.js loaded"});
	scripts.push({path:getCDNRootPath()+"js/qrcode.min.js?v="+version(), size:sizeCRYPTOJS, log:"qrcode.min.js loaded"});
		
	loadNext();	
}

function loadNext()
{
	if(!scripts.length)
	{
		//requestSelfIp();
		doLoadGameZ();
		return;
	}
	
	var toLoad = scripts.shift();
	loadOne(toLoad.path, toLoad.size, toLoad.log, function()
	{
		loadNext();
	});
}

function loadOne(path, size, log, onload)
{
	var st = Date.now();
	var body = document.getElementsByTagName("body")[0];
	script = document.createElement("script");
	script.setAttribute("src", path);
	body.appendChild(script);

	script.onload = function()
	{
		updateProgress(size);
		onload();
	};

	script.onerror = function()
	{
		window.location.reload();
	};
}

function updateProgress(loadedSize)
{
	sizeLoaded += loadedSize;
	setPercent(sizeLoaded / sizeTotal);
}

var progressGoTimer;

function goProgress(tarSize, speed)
{
	var st = Date.now();
	var stSize = sizeLoaded;
	progressGoTimer = window.setInterval(function () 
	{
		var size = speed * (Date.now() - st);
		if(size >= tarSize)
		{
			size = tarSize;
			window.clearInterval(progressGoTimer);
		}
		setPercent((stSize + size) / sizeTotal);
	});
}

function stopGoProgress()
{
	if(progressGoTimer)
		window.clearInterval(progressGoTimer);
}

function doLoadGameZ()
{
	updateLoadTxt("加载客户端");
	goProgress(sizeMainJS, loadSpeed);
	var http = new XMLHttpRequest();
	http.open("get", "Main.max.min.zip?v=201909021814"/* + Math.random()*/, true);
	http.responseType = "arraybuffer";
	var st = Date.now();
	http.onload = function(e) 
	{
		stopGoProgress();
		updateProgress(sizeMainJS);
		updateLoadTxt("解压客户端");
		console.log("doLoadGameZ: costTime: " + (Date.now() - st));
		sendLog("login_log", "Main.max.min.zip loaded", (Date.now() - st));
		var status = http.status !== undefined ? http.status : 200;		
		if (status === 200 || status === 204 || status === 0) {
			_data = http.response || http.responseText;
			if (!_data || _data.length <= 0) {
				window.location.reload();
				return;
			}
			window.setTimeout(function(){
				sendLog("login_log", "Main.max.min.zip uncompressed");
				goProgress(sizeMainUnCompress, unCompressSpeed);
				st = Date.now();
				unZipMain(_data, function(filstr){
					sendLog("login_log", "Main.max.min.zip uncompressd", (Date.now() - st));
					updateLoadTxt("客户端解压完成");
					mainFileStr = filstr;
					stopGoProgress();
					updateProgress(sizeMainUnCompress);
					
					evalStartTime = Date.now();
					log_div("eval start...");
					updateLoadTxt("解析客户端");
					window.eval(mainFileStr);
					
					if(serverSelectEnabled())
					{
						requestSrvList();
					}
					else
					{
						enterClicked = true;	
						checkEnterMain();
					}
				});
			},60);
		}
		else 
		{
			alert("[" + http.status + "]" + http.statusText + ":" + http.responseURL);
			sendLog("login_log", "[" + http.status + "]" + http.statusText + ":" + http.responseURLb);
			updateLoadTxt("加载失败，请刷新游戏(2)");
		}
		
	}
	http.send(null);
}	

function unZipMain(data, onComplete)
{
	JSZip.loadAsync(data).then(function (zip) {
		console.log("asynczipsuccess");
		zip.file("Main.max.min.js").async("text").then(function success(content) {
			console.log("readtxtsuccess");
			onComplete(content);
		},function error(e) {
			// handle the error
			throw e;
		});
	});
}

//游戏通知web页面游戏内界面显示完毕
function onGameInited(val)
{
	console.log("onGameInited " + val);
	gameInited = true;
	sendLog("login_log", "Main.js eval complete", (Date.now() - evalStartTime));
	log_div("eval end(Main) cost: " + (Date.now() - evalStartTime));
	updateLoadTxt("客户端解析完成");
	updateProgress(sizeMainAnalysis);
	hideProgressBar();
	checkEnterMain();

	var bgImg = document.getElementById('img_bg');
	bgImg.style.display = "none";

	console.log("onGameInited isNewPlayer_FromJs_byYP: " + isNewPlayer_FromJs_byYP);
	if (isDisconnectReload() || isNewPlayer_FromJs_byYP) {
		loginClick();
	}
	else {
		var game_msg_new = document.getElementById("game-msg-new");
		game_msg_new.style.display = "block";
		var game_msg = document.getElementById("game-msg");
		game_msg.style.display = "block";
		var btn_login = document.getElementById("btn-login");
		btn_login.style.display = "block";
	}

	//var logo = document.getElementById('logo');
	//logo.style.display = "none";
}

function updateLoadTxt(txt)
{
	var txtLoad = document.getElementById("txtLoad");
	if(txtLoad)
	{
		txtLoad.innerHTML = txt;
	}
}

function getCDNRootPath()
{
	var cdnUrl = "";
	return cdnUrl;
}

function version()
{
	if("undefined" != typeof getGameLoadingVersion)
	{
		return getGameLoadingVersion();
	}
	else
	{
		return 1;
	}
}

function addLogDiv()
{
	if(!divLogEnabled)
	{
		return;
	}
	var code = '' +
		'<div class="log-panel" id="log-panel">\n' +
		'</div>'
		;
	document.body.innerHTML += code;
}

////////////PreloadView/////////////

function showPreloadView()
{
	var style1 = document.createElement('style');
	style1.type="text/css";
    style1.innerHTML = '#bar_bg{background: url(comp/loading/bar_bg.png) no-repeat;}#logo{background: url(comp/loading/logo.png?v=20180813.01) no-repeat;}';
    document.head.appendChild(style1);
	 
	showTopDown();
	 
	var divLoad = document.createElement('div');
	divLoad.id = 'div_load';
	divLoad.style.cssText='width: 750px;height: 1334px;z-index: 3;position: absolute;top: 0';
	document.body.appendChild(divLoad);
	 
	var logo = document.createElement('div');
	logo.id = 'logo';
	logo.style.cssText='position:absolute; width:410px; height:210px; left:310px; top:68px;';
	divLoad.appendChild(logo);
	logo.style.display = "none";
	 
	txtLoad = document.createElement('div');
	txtLoad.id = 'txtLoad';
	txtLoad.style.cssText='left:123; top:964; width:523; height:20; position: absolute; text-align: center; color: #FFFFFF; font-size: 20;';
	divLoad.appendChild(txtLoad);
	 
	var barBg = document.createElement('div');
	barBg.id = 'bar_bg';
	barBg.style.cssText='left:80; top:990; position: absolute;';
	barBg.innerHTML = '<canvas id="bar" width="607" height="34">浏览器不支持</canvas>';
	divLoad.appendChild(barBg);

	var divCustomerService = document.createElement('div');
	divCustomerService.id = 'div_cs';
	divCustomerService.style.cssText='width: 750px;height: 1334px;z-index: 3;position: absolute;top: 0;pointer-events:none;';
	document.body.appendChild(divCustomerService);
	 
	var cv = document.getElementById("bar");
	var ctx= cv.getContext("2d");
	 
	layout();
	//setTransform(top, "matrix(100,0,0,10,0,0)");
	//setTransform(down, "matrix(100,0,0,10,0,0)");
	 
	bar_img = new Image();
	bar_img.src = "comp/loading/bar.png";
	barImgLoaded = false;
	bar_img.onload = function(){
		barImgLoaded=true;
		_setPercent(barPercent);
	}
	
	if(serverSelectEnabled())
	{
		console.log("getServiceDialog");
		divLoad.innerHTML += getServiceDialog();
		//showAnn();
	}

	divCustomerService.innerHTML += '' + 
		'<div class="customerservice" id="customerservice">\n' +
		'	<div class="panel-msk" onclick="onCloseCustomerServiceClick();"></div>' + 
		'	<div class="s-panel-cs">\n' +
		'		<div class="s-panel-cs2">\n' +
		'			<iframe src="" id="iframe_cs" frameborder="0" scrolling="no" style="width:360px;height:590px;"></iframe>' + 
		'		</div>\n' + 
		'		<img class="icon-cs-close" src="comp/loading/close.png" onclick="onCloseCustomerServiceClick();" style="position:absolute;left:590px;top:6px;"/>\n' + 
		'	</div>\n' + 
		'</div>\n';
}

function serverSelectEnabled()
{
	return getPF();
}

function setPercent(percent)
{
	barPercent = percent;
	if(false == barImgLoaded)
	{
		return;
	}
	_setPercent(barPercent);
}

function _setPercent(percent)
{
	if(percent > 1)
	{
		percent = 1;
	}
	var bar = document.getElementById('bar');
	var x = bar.width * percent;
	
	var ctx= bar.getContext("2d");
	ctx.beginPath();
	ctx.clearRect(-10,0,x+607,34)
	ctx.drawImage(bar_img,0,0,x,34,0,0,x,34);
	ctx.closePath();
}

function hidePreloadView()
{
	console.log("hidePreloadView");
	var divLoad = document.getElementById('div_load');
	document.body.removeChild(divLoad);
	//divLoad.style.display = "none";
	var bg = document.getElementById('bg');
	bg.style.zIndex = 0;
}

function isIphoneX()
{
    return /iphone/gi.test(navigator.userAgent) && (screen.height == 812 && screen.width == 375)
}


function showTopDown()
{
	var divTopDown = document.createElement('div');
	divTopDown.id = 'div_topdown';
	document.body.appendChild(divTopDown);

	var top = document.createElement('div');
	top.id = "topEdge";
	divTopDown.appendChild(top);
	
	var down = document.createElement('div');
	down.id = "downEdge";
	divTopDown.appendChild(down);
	
	var left = document.createElement('div');
	left.id = "leftEdge";
	divTopDown.appendChild(left);
	
	var right = document.createElement('div');
	right.id = "rightEdge";
	divTopDown.appendChild(left);
}

function hideProgressBar()
{
	console.log("hideProgressBar");
	var progressBar = document.getElementById('bar_bg');
	progressBar.style.display = "none";
	var txt = document.getElementById('txtLoad');
	txt.style.display = "none";
}

function showProgressBar()
{
	var progressBar = document.getElementById('bar_bg');
	progressBar.style.display = "block";
	var txt = document.getElementById('txtLoad');
	txt.style.display = "block";
}

///////////////////////////////////

function getServiceDialog()
{
	return '' +
		'<div class="sevicer" id="sevicer">\n' +
		'	<div class="panel-msk" onclick="onCloseSevicerClick();"></div>' + 
		'	<div class="s-panel">\n' +
		'		<div class="s-panel-left">\n' + 
		'			<div class="sevice-group-list">\n' + 
		'				<ul id="sevice-group-list-ul">\n' + 
		'				</ul>\n' + 
		'			</div>\n' + 
		'		</div>\n' + 
		'		<div class="s-panel-right">\n' + 
		'			<div class="sevice-list">\n' + 
		'				<ul id="sevice-list-ul">\n' + 
		'				</ul>\n' + 
		'			</div>\n' + 
		'		</div>\n' + 
		'	</div>\n' + 
		'</div>\n' + 

		'<div class="customerservice" id="customerservice">\n' +
		'	<div class="panel-msk" onclick="onCloseCustomerServiceClick();"></div>' + 
		'	<div class="s-panel">\n' +
		'		<iframe src="" id="iframe_cs" style="width:600px;height:1000px;"></iframe>' + 
		'	</div>\n' + 
		'</div>\n' + 

		'<div class="sevicer" id="sevicer-role">\n' +
		'	<div class="panel-msk" onclick="onCloseSevicerRoleClick();"></div>' + 
		'	<div class="s-panel">\n' +
		'		<div class="panel-title">角色选择</div>\n' + 
		'		<div class="s-panel-left">\n' + 
		'			<ul>\n' + 
		'				<li id="page-role-0" onclick="" onMouseOut="onMousePageItem(0,false);" onMouseOver="onMousePageItem(0,true);">我的角色</li>\n' + 
		'			</ul>\n' + 
		'		</div>\n' + 
		'		<div class="s-panel-right">\n' + 
		'			<div class="s-panel-right-top">\n' + 
		'				<div class="s-panel-right-title">所有角色</div>\n' + 
		'				<img src="comp/loading/img_login_decorate.png" class="s-panel-right-top-imgL"/>\n' + 
		'				<img src="comp/loading/img_login_decorate.png" class="s-panel-right-top-imgR"/>\n' + 
		'			</div>\n' + 
		'			<div class="sevice-list">\n' + 
		'				<ul id="sevice-role-list-ul">\n' + 
		'				</ul>\n' + 
		'			</div>\n' + 
		'		</div>\n' + 
		'	</div>\n' + 
		'</div>\n' + 
		
		'<div id="game-roles" class="game-roles" onclick="gameRoleClick()">\n' + 
		'	<img class="game-msg-bg" src="comp/loading/img_login_main.png"/>\n' + 
		'	<div class="game-msg-content">\n' + 
		'		<div id="game-roles-txt-title" class="game-roles-txt-title"><font color="#CCCCCC">当前角色</font></div> \n' + 
		'		<div id="game-roles-txt-lv" class="game-roles-txt-lv"><font color="#FFFFFF">  </font></div> \n' + 
		'		<div id="game-roles-txt-name" class="game-roles-txt-name"><font color="#FFFFFF"> </font></div>\n' + 	
		'		<div id="game-roles-txt-change" class="game-roles-txt-change"><font color="#CCCCCC">></font></div> \n' + 
		'	</div>\n' + 
		'</div>\n' +
		'<div id="game-msg-new" class="game-msg-new">\n' + 
		'	<img class="game-msg-new-bg" src="comp/loading/img_login_main.png"/>\n' + 
		'	<div class="game-msg-new-content">\n' + 
		'		<div id="game-msg-txt-new-state" class="game-msg-txt-new-state"><font color="#FFD21D">最新服</font></div>\n' + 
		'		<div id="game-msg-txt-new-name" class="game-msg-txt-new-name"><font color="#5AFF00"></font></div> \n' + 
		'	</div>\n' + 
		'</div>\n' +
		'<div id="game-msg" class="game-msg">\n' + 
		'	<img class="game-msg-bg" src="comp/loading/img_login_main.png"/>\n' + 
		'	<div class="game-msg-content">\n' + 
		'		<img id="game-msg-icon" class="game-msg-icon" src="comp/loading/server_state.png"/>\n' + 
		'		<div id="game-msg-txt-state" class="game-msg-txt-state"><font color="#FFD21D">服务器名称</font></div>\n' + 
		'		<img id="game-msg-divide" class="game-msg-divide" src="comp/loading/title_fengexian.png"/>\n' + 
		'		<div id="game-msg-txt-name" class="game-msg-txt-name"><font color="#5AFF00"></font></div> \n' + 
		'		<img id="game-msg-click" class="game-msg-click" src="comp/loading/choose_btn.png" onclick="gameMsgClick()"/>\n' + 
		'	</div>\n' + 
		'</div>\n' +
		'<img id="btn-login" class="btn-login" onclick="loginClick()" onMouseDown="loginMouseDown()" onMouseUp="loginMouseUp()" src="comp/loading/btn_gamego.png?v=20180112">\n' + 
		'</img>\n' +
		'<div id="announcement" class="announcement">\n' +
		'<div class="panel-msk" onclick="hideAnn();"></div>' + 
		'	<div class="ann-panel">\n' +
		'		<div class="ann-title">游戏公告</div>\n' +
		'		<div id="ann-content-title" class="ann-content-title"></div>\n' +
		'		<div id="" class="ann-content-parent">\n' +
		'			<div id="ann-content" class="ann-content"></div>\n' +
		'		</div>\n' +
		'	</div>\n' +
		'</div>\n';// +
		//'<img class="icon-announcement" src="comp/chooseserver/gonggao.png" onclick="showAnn();"/>'
		//;
}

function setPageListSelect(index)
{
	if(selectedPage == index){
		return;
	}
	if(selectedPage != -1){
		var pageLeft = document.getElementById("page-" + selectedPage);
		pageLeft.style.background = "url(comp/preloading/tab_login_unselect.png) no-repeat";
	}
	selectedPage = index;
	if(selectedPage != -1){
		var pageLeft = document.getElementById("page-" + selectedPage);
		pageLeft.style.background = "url(comp/preloading/tab_login_select.png) no-repeat";
	}
}

function onMousePageItem(index, mouseOver)
{
	var pageLeft = document.getElementById("page-" + index);
	if(mouseOver){
		pageLeft.style.background = "url(comp/preloading/tab_login_select.png) no-repeat";
	}
	else{
		if(selectedPage == index){
			pageLeft.style.background = "url(comp/preloading/tab_login_select.png) no-repeat";
		}
		else{
			pageLeft.style.background = "url(comp/preloading/tab_login_unselect.png) no-repeat";
		}
	}
}

function onCustomerServiceClick(roleid, rolename)
{
	var customerservice = document.getElementById("customerservice");
	customerservice.style.display = "block";
	customerservice.style.setProperty('pointer-events', 'auto');

	if (!isSetCSAddress) {
		isSetCSAddress = true;
		var iframe_cs = document.getElementById("iframe_cs");
		iframe_cs.src = "http://www.xy.com/kfsys?type=h5&uid=" + getDeviceId() + "&gid=48&sid=" + selectedServer[1] + "&rolename=" + rolename + "&roleid=" + roleid;
		//iframe_cs.contentWindow.document.body.style.scale
		setScale(iframe_cs, 1.7);
	}
}

function onSvrListShow()
{
	hideProgressBar();

	if(userServer && userServer.length)
	{
		showSvrList(0);
	}
	else
	{
		showSvrList(1);
	}
}

function gameMsgClick()
{
	var sevicer = document.getElementById("sevicer");
	sevicer.style.display = "block";
}

function gameRoleClick()
{
	var sevicer_role = document.getElementById("sevicer-role");
	sevicer_role.style.display = "block";
	showRoleList();
}

function showRoleList()
{
	var pageLeft = document.getElementById("page-role-0");
	pageLeft.style.background = "url(comp/preloading/tab_login_select.png) no-repeat";

	var ul = document.getElementById("sevice-role-list-ul");
	var innerContent = "";
	if(userServer)
	{
		for (var i = 0; i < userServer.length; ++i)
		{
			var user = userServer[i];
			
			var serverDt = getServerData(user.serverId);
			if(!serverDt)
			{
				console.log("ERROR！无效的服务器id = " + svrDt.serverId);
				continue;
			}
			innerContent += createRoleLi(user.gameUid, serverDt.name, user.name, user.gameUserLevel);	
		}
	}
	
	ul.innerHTML = innerContent;
}

function getSvrList(type)
{
	switch(type)
	{
		case 0:
			return getHasUserServerList();
			break;
		case 1:
			return recommandList;
			break;
		case 2:
			return serverList;
			break;
		default:
			console.log("无效的type = " + type)
			return [];
	}
}

function getHasUserServerList()
{
	var result = [];
	var len = serverList.length;
	for (var i = 0; i < len; ++i)
	{
		var item = serverList[i];
		if(getUserBySid(item.id))
		{
			result.push(item);
		}		
	}
	return result;
}

function showSvrList(type)
{
	setPageListSelect(type);
	console.log("showSvrList: " + type);
	var ul = document.getElementById("sevice-list-ul");
	var svrList = getSvrList(type);
	var innerContent = "";
	if(svrList)
	{
		for (var i = 0; i < svrList.length; ++i)
		{
			var svrDt = svrList[i];
			innerContent += createSvrLi(svrDt.id, svrDt.name, getState(svrDt));
		}
	}
	
	ul.innerHTML = innerContent;
}

function getOutIcon(state)
{
	var icon;
	/*if(state == 1)
	{
		state = 3;
	}*/
	if(state == 1){
		icon = "comp/loading/server_state_1.png";
	}
	else if(state == 2){
		icon = "comp/loading/server_state_2.png";
	}
	else if(state == 3){
		icon = "comp/loading/server_state_3.png";
	}
	else if(state == 4){
		icon = "comp/loading/server_state_4.png";
	}
	else if(state == 5){
		icon = "comp/loading/server_state_5.png";
	}
	else{
		console.log("getOutIcon(): 无效的state=" + state);
		icon = "comp/loading/server_state_3.png";
	}
	return icon;
}

function getIcon(state)
{
	var icon;
	if(state == 1){
		icon = "comp/loading/server_state1.png";
	}
	else if(state == 2){
		icon = "comp/loading/server_state2.png";
	}
	else if(state == 3){
		icon = "comp/loading/server_state3.png";
	}
	else if(state == 4){
		icon = "comp/loading/server_state4.png";
	}
	else if(state == 5){
		icon = "comp/loading/server_state5.png";
	}
	else{
		console.log("getIcon(): 无效的state=" + state);
		icon = "comp/loading/server_state3.png";
	}
	return icon;
}

function getStateColor(state)
{
	if(state == 1)
	{
		state = 3;
	}

	var color;
	if(state == 1){
		color = "#05d800";
	}
	else if(state == 2){
		color = "#cb8000";
	}
	else if(state == 3){
		color = "#f8272d";
	}
	else if(state == 4){
		color = "#d2d1cf";
	}
	else{
		console.log("getIcon(): 无效的state=" + state);
		color = "#05d800";
	}
	return color;
}

function createSvrGroupLi(id, name)
{	
	return '				<li id="srvgroup-'+id+'" onclick="selectSvrListByGroup(this)" data-id="'+ id +'">\n' +
		'						<div class="serice-group-item-content">\n' +
		'							<div class="serice-group-item-txt-name">' + name + '</div>\n' + 
		'						</div>\n' +
		'					</li>\n';
}

function createSvrLi(objs)
{
	var icon = getIcon(1);
	
	return '				<li onclick="selectSvrByItem(this)" data-id="'+ JSON.stringify(objs).replace(/"/g,"'") +'">\n' +
		'						<div class="serice-item-content">\n' +
		'							<img class="serice-item-icon" src="' + icon + '" />\n' + 
		'							<div class="serice-item-txt-name">' + objs.name + '</div>\n' + 
		'						</div>\n' +
		'					</li>\n';
}

function createRoleLi(gameUid, svrId, roleName, roleLv)
{
	return '				<li onclick="selectRoleByItem(this)" data-id="'+ gameUid +'">\n' +
		'					<div class="role-item-txt-server"><font color="#FFFFFF">S' + svrId + '</font></div>\n' + 
		'					<div class="role-item-txt-name"><font color="#FFFFFF">' + roleName + '</font></div>\n' + 
		'					<div class="role-item-txt-lv"><font color="#FFFFFF">Lv.' + roleLv + '</font></div>\n' + 
		'				</li>\n';
}

function selectSvrListByGroup(item, id = 0)
{
	if (null != item) {
		id = item.attributes["data-id"].value;
		if (selectedSrvGroupID == id) {
			return;
		}
	}

	setSrvGroupSelect(id);
	showSrvListByGroup(id);
}

function setSrvGroupSelect(pageId)
{
	if (selectedSrvGroupID == pageId) {
		return;
	}
	selectedSrvGroupID = pageId;

	for (var id in arrSrvGroupID) {

		var srvGroup = document.getElementById("srvgroup-" + arrSrvGroupID[id]);
		srvGroup.style.background = "url(comp/loading/img_btn_1.png) no-repeat";
	}
	var srvGroup = document.getElementById("srvgroup-" + pageId);
	srvGroup.style.background = "url(comp/loading/img_btn_2.png) no-repeat";
}

function showSrvListByGroup(pageId)
{
	var slul = document.getElementById("sevice-list-ul");
	innerContent = "";
	slul.innerHTML = innerContent;

	if (pageServerData[pageId]) {
		var slul = document.getElementById("sevice-list-ul");
		innerContent = "";
		for (var idxSrv = pageServerData[pageId].length - 1; idxSrv >= 0; --idxSrv)
		{
			if (0 == pageId) {
				for (var idxSrv2 = serverData.serverList.length - 1; idxSrv2 >= 0; --idxSrv2)
				{
					if (parseInt(serverData.serverList[idxSrv2].id) == parseInt(pageServerData[pageId][idxSrv].id)) {
						innerContent += createSvrLi(serverData.serverList[idxSrv2]);
						break;
					}
				}
			}
			else {
				innerContent += createSvrLi(pageServerData[pageId][idxSrv]);
			}
		}
		slul.innerHTML = innerContent;
	}
}

function selectSvrByItem(item)
{
	var objs = JSON.parse(item.attributes["data-id"].value.replace(/'/g,"\""));
	var txt_icon = document.getElementById("game-msg-icon");
	txt_icon.src = getOutIcon(1);
	var txt_name = document.getElementById("game-msg-txt-name");
	txt_name.innerHTML = '<font color="#5AFF00">'+objs.name+'</font>';
	selectedServer = objs;
	onCloseSevicerClick();
}

function getLoginServerName(){
	if (null == selectedServer) return "";
	return selectedServer.name;
}

function getLoginServerIP(){
	if (null == selectedServer) return "";
	return selectedServer.ip;
}

function getLoginServerPort(){
	if (null == selectedServer) return "";
	return parseInt(selectedServer.port);
}

function getLoginServerID(){
	if (null == selectedServer) return "";
	return selectedServer.id;
}

function getServerData(id)
{
	var len = serverList.length;
	for (var i = 0; i < len; ++i)
	{
		var item = serverList[i];
		if(item.id == id)
		{
			return item;
		}
	}
	return null;
}

function requestSrvList()
{
	st = Date.now();
	sendLog("login_log", "RequestServerList");
	var strGetServerListURL;
	/*if (IS_SSL())
	{
		strGetServerListURL = "https://212.64.104.25/houtai_api/server/1/list_1.txt";
	}
	else*/
	{
		//strGetServerListURL = "list_1.txt"
		strGetServerListURL = "http://192.168.188.3:8766/cdn/serverlist.json";
	}
			
	var http = new XMLHttpRequest();
	http.open("get", strGetServerListURL);
	http.onload = function(e) 
	{
		sendLog("login_log", "RequestServerListSuccess", (Date.now() - st));
		
		console.log("responseText:");
		var responseText = http.responseText.replace(/serverlist/g, "serverList");
		srvListResp = responseText;
		console.log(responseText);

		var result;
		try{
			result = JSON.parse(responseText);
			serverData = result;
		}catch(e){
			sendLog("login_log", "ERROR!! serverList Json parse Error: " + http.responseText);			
			alert("很抱歉，服务器列表请求失败，请点击确定重试。" + http.responseText);
			window.location.reload();
			return;
		}

		hideProgressBar();
		
		//var game_msg_new = document.getElementById("game-msg-new");
		//game_msg_new.style.display = "block";
		//var game_msg = document.getElementById("game-msg");
		//game_msg.style.display = "block";
		//var btn_login = document.getElementById("btn-login");
		//btn_login.style.display = "block";

		//isWhiteMan = checkWhiteMan();

		//设置最新服
		if (null != serverData.serverList && serverData.serverList.length > 0) {
			var new_server_name = document.getElementById("game-msg-txt-new-name");
			new_server_name.innerHTML = '<font color="#5AFF00">' + serverData.serverList[serverData.serverList.length - 1].name + '</font>';
		}

		var sglul = document.getElementById("sevice-group-list-ul");
		var innerContent = "";
		innerContent += createSvrGroupLi(0, "最近登录");
		arrSrvGroupID.push(0);

		innerContent += createSvrGroupLi(1, "1服-100服");
		arrSrvGroupID.push(1);

		sglul.innerHTML = innerContent;

		setSrvGroupSelect(0);

		if (null == serverData.userServer || serverData.userServer.length <= 0) {
			if (null != serverData.serverList && serverData.serverList.length > 0) {
				var txt_icon = document.getElementById("game-msg-icon");
				txt_icon.src = getOutIcon(1);
				var txt_name = document.getElementById("game-msg-txt-name");
				txt_name.innerHTML = '<font color="#5AFF00">' + serverData.serverList[serverData.serverList.length - 1].name + '</font>';
				selectedServer = serverData.serverList[serverData.serverList.length - 1];
				isNewPlayer_FromJs_byYP = true;
				console.log("isNewPlayer_FromJs_byYP: " + isNewPlayer_FromJs_byYP);
			}
		}
		else {
			for (var i = 0; i < serverData.userServer.length; ++i)
			{
				var bFlag = false;
				for (var j = 0; j < serverData.serverList.length; ++j)
				{
					console.log(i + " " + j + " " + serverData.userServer[i].GameServerId + " " + serverData.serverList[j].id);
					if (parseInt(serverData.userServer[i].GameServerId) == parseInt(serverData.serverList[j].id))
					{
						serverData.userServer[i].ip = serverData.serverList[j].ip;
						serverData.userServer[i].port = serverData.serverList[j].port;

						var txt_icon = document.getElementById("game-msg-icon");
						txt_icon.src = getOutIcon(1);
						var txt_name = document.getElementById("game-msg-txt-name");
						txt_name.innerHTML = '<font color="#5AFF00">' + serverData.serverList[j].name + '</font>';
						selectedServer = serverData.serverList[j];

						bFlag = true;
						break;
					}
				}

				if (bFlag) break;
			}
			//var txt_icon = document.getElementById("game-msg-icon");
			//txt_icon.src = getOutIcon(1);
			//var txt_name = document.getElementById("game-msg-txt-name");
			//txt_name.innerHTML = '<font color="#5AFF00">' + serverData.userServer[0].name + '</font>';
			//selectedServer = serverData.userServer[0];
		}

		pageServerData[0] = serverData.userServer;
		pageServerData[1] = serverData.serverList;
		selectSvrListByGroup(null, 0);

		reportDJS_Point(0, getDeviceId(), "u0Lv58TTBLvND", 0, 0, 0, 0, "oath", 0);

		//requestRecentLoginSrvList();
	};
	http.send();
}

function requestNotice()
{
	var http = new XMLHttpRequest();
	http.open("get", getNoticeUrl());
	http.onload = function(e) 
	{
		var result = JSON.parse(http.responseText);
		if(result.Status == 0)
		{
			openNotice(result.Message);
		}
		else
		{
			showTips("公告读取失败，请稍后再试(code:" + result.Status + ")", 2);
		}
	};
	http.send();
}

function openNotice(message)
{
	var div = document.getElementById("announcement");
	if(div)
	{
		var title = document.getElementById("ann-content-title");
		title.innerHTML = message["2"];
		var tf = document.getElementById("ann-content");
		tf.innerHTML = message["3"].replace(/\[/g, "<").replace(/\]/g, ">");
		div.style.display = "block";
	}
}

function getState(server)
{
	if(server.open == 2) {
		return 4;
	}
	else{
		return 1;
	}
}

function showAnn()
{
	var div = document.getElementById("customerservice");
	div.style.display = "block";
	return;
	requestNotice();
}

function hideAnn()
{
	var div = document.getElementById("announcement");
	div.style.display = "none";
}

function onCloseSevicerClick()
{
	var sevicer = document.getElementById("sevicer");
	sevicer.style.display = "none";
}

function onCloseCustomerServiceClick()
{
	var customerservice = document.getElementById("customerservice");
	customerservice.style.display = "none";
}

function onCloseSevicerRoleClick()
{
	var sevicer_role = document.getElementById("sevicer-role");
	sevicer_role.style.display = "none";
}

function loginClick()
{
	if(selectedServer && selectedServer.open == 2)
	{
		window.alertMaintenance();
		return;
	}

	if(!gameInited)
	{
		showProgressBar();
	}
	sendLog("login_log", "loginClick");
	/*if(selectedServer && selectedServer.open == 2)
	{
	
		if (isNewPlayer_FromJs_byYP)
		{
			sendLog("NewPlayerClickLogin error");
		}
		showTips("服务器维护中", 2);
		return;
	}	
	
	if (isNewPlayer_FromJs_byYP)
	{
		sendLog("NewPlayerClickLogin");
		window.reportRegister();
	}
	else
	{
		window.reportLogin();
	}*/

	enterClicked = true;	
	checkEnterMain();
}

function loginMouseDown()
{
	var btn = document.getElementById("btn-login");
	valueTo(1, 0.9, 100, function(scale){
		setScale(btn, scale);
	}, null);
}

function loginMouseUp()
{
	var btn = document.getElementById("btn-login");
	valueTo(0.9, 1, 100, function(scale){
			setScale(btn, scale);
	}, null);
}

function valueTo(startV, endV, time, onUpdate, onComplete)
{
	var st = Date.now();
	var iTo = setInterval(function(){
		var tGo = Date.now() - st;
		var v = startV + (endV - startV) * (tGo / time);
		if(endV > startV)
		{
			v = Math.min(endV, v);
		}
		else 
		{
			v = Math.max(endV, v);
		}
		onUpdate(v);
		if(v == endV)
		{
			clearInterval(iTo);
			if(onComplete)
			{
				onComplete();
			}
		}
	}, 1);
}

function setScale(target, scale)
{
	target.style.transform="scale(" + scale + ")";
	target.style["-ms-transform"]="scale(" + scale + ")";/* IE 9 */
	target.style["-moz-transform"]="scale(" + scale + ")";/* Firefox */
	target.style["-webkit-transform"]="scale(" + scale + ")";/* Safari 和 Chrome */
	target.style["-o-transform"]="scale(" + scale + ")";/* Opera */
}

function checkEnterMain()
{
	if (null == selectedServer)
	{
		window.location.reload();		
		alert("很抱歉，选择服务器失败，请点击确定重试。" + srvListResp);
		return;
	}

	if(enterClicked && gameInited)
	{
		console.log("checkEnterMain hidePreloadView");
		hidePreloadView();
		
		if(window.onWebComplete){
			window.onWebComplete(recentLoginServerData);

		}
	}
}

function setAnnContent(text)
{
	var div = document.getElementById("ann-content");
	div.innerHTML = text;
}

function showTips(text, iconMode)
{
	console.log("showTips(): text = " + text);
	if('undefined' != typeof mqq)
	{
		mqq.ui.showTips({text:text, iconMode:iconMode});
	}
}

function log_div(text)
{
	if(!divLogEnabled)
	{
		return;
	}
	var div = document.getElementById("log-panel");
	if(!div)
	{
		return;
	}
	lognum++;
	var content = div.innerHTML;
	content = lognum == 1 ? text : text + "<br>" + content;
	if(lognum > 30)
	{
		var index = content.lastIndexOf("<br>");
		if(index != -1)
		{
			content = content.substring(0, index);
		}
	}
	div.innerHTML = content;
}

function enableDivLog()
{
	if(!divLogEnabled)
	{
		divLogEnabled = true;
		var code = '' +
		'<div class="log-panel" id="log-panel">\n' +
		'</div>'
		;
		document.body.innerHTML += code;
	}
}

function disableDivLog()
{
	if(divLogEnabled)
	{
		divLogEnabled = false;
		var div = document.getElementById("log-panel");
		document.body.removeChild(div);
	}
}

var urlencode = function(str){
    var res = encodeURIComponent(str);

    //0~9 a~z A~Z -_.
    res = res.replace(/[^0-9a-zA-Z\-_\.%]/g, function ($0) {
        //不用考虑一位数了
        return '%' + $0.charCodeAt(0).toString(16).toUpperCase();
    });

    return res;
};

function getWanbaSign(appkey, params)
{
	var queryArray = [];

	for(var key in params){
	    if(key != 'sig'){
	        queryArray.push(key + '=' + params[key]);
	    }
	}

	queryArray.sort(function (val1, val2) {
	    if(val1 > val2){
	        return 1;
	    }
	    if(val1 < val2){
	        return -1;
	    }
	    return 0;
	});

	var busidataArr = ['POST', urlencode('/v3/user/is_login'), urlencode(queryArray.join('&'))];
	var busiDataStr = busidataArr.join('&');

	var sig = CryptoJS.HmacSHA1(busiDataStr, appkey+'&').toString(CryptoJS.enc.Base64); 
	//crypto.createHmac('sha1', appkey+'&').update(busiDataStr).digest().toString('base64');

	return sig;
}

function requestSelfIp()
{
	if(!ipSelf)
	{
		var http = new XMLHttpRequest();
		var strGetClientIPURL;
		/*if (IS_SSL())
		{
			strGetClientIPURL = "https://212.64.104.25/houtai_api/server/1/list_1.txt";
		}
		else*/
		{
			//strGetClientIPURL = "list_1.txt"
			strGetClientIPURL = "https://list-zsxy.8zy.com/kingapi/get_client_ip.php";
		}

		http.open("get", strGetClientIPURL);
		http.onload = function(e) 
		{
			var result;
			try{
				ipSelf = http.responseText;
				console.log("ipSelf: " + ipSelf);
				doLoadGameZ();
			}catch(e){
				sendLog("login_log", "ERROR!! requestSelfIp Error: " + http.responseText);
				window.location.reload();
				return;
			}	
		};
		http.send();
	}else
	{
		doLoadGameZ();
	}
	
}

function checkWhiteMan()
{
	console.log("serverData.whitelist.length: " + serverData.whitelist.length);
	for (var idx = 0; idx < serverData.whitelist.length; ++idx) {
		console.log("serverData.whitelist[idx]: " + serverData.whitelist[idx]);
		if (serverData.whitelist[idx] == ipSelf) {
			return true;
		}
	}
	return false;
}

function getUserIp()
{
	return ipSelf;
}

var urlencode = function(str)
{
    var res = encodeURIComponent(str);

    //0~9 a~z A~Z -_.
    res = res.replace(/[^0-9a-zA-Z\-_\.%]/g, function ($0) {
        //不用考虑一位数了
        return '%' + $0.charCodeAt(0).toString(16).toUpperCase();
    });

    return res;
};

function getWanbaSign(appkey, params, fun, method)
{
	var queryArray = [];

	for(var key in params){
	    if(key != 'sig'){
	        queryArray.push(key + '=' + params[key]);
	    }
	}

	queryArray.sort(function (val1, val2) {
	    if(val1 > val2){
	        return 1;
	    }
	    if(val1 < val2){
	        return -1;
	    }
	    return 0;
	});

	var busidataArr = [method, urlencode(fun), urlencode(queryArray.join('&'))];
	var busiDataStr = busidataArr.join('&');

	console.log(busiDataStr);
	console.log(appkey);
	var sig = CryptoJS.HmacSHA1(busiDataStr, appkey).toString(CryptoJS.enc.Base64); 
	return sig;
}

function isFirstLogin()
{
	console.log("recentLoginServerData:" + recentLoginServerData.servers);
	if (recentLoginServerData && recentLoginServerData.servers && recentLoginServerData.servers.length > 0) {
		return false;
	}

	return true;
}

window.onbeforeunload = function()
{
	if (window.onPageClose){
		window.onPageClose();
	}
}

function enableQrCode()
{
    if(!divQrCodeEnabled)
    {
        divQrCodeEnabled = true;
        var code = '' +
            '<div class="qrcode_inner" id="qrcode_inner" onclick="unableQrCode()">\n' +
            '<div class="qrcode_img"><img  src="comp/share/share_bg.png"/></div><div class="qrcode_css" id="qrcode_a"></div>' +
            '</div>'
        ;

        var div = document.createElement("div");
        div.id = "qrcode_panel";
        div.innerHTML = code;
        document.body.appendChild(div);
        div.style.cssText="position: absolute; z-index: 100001;width:750px;height:1334px;pointer-events:none;"
    }else{
        var div = document.getElementById("qrcode_panel");
        div.style.display = "block";

    }
}
function unableQrCode() {
    if(qrcode){
        qrcode.clear();
    }
    if(divQrCodeEnabled){
        var div = document.getElementById("qrcode_panel");
        // document.removeChild(div);
        div.style.display = "none";
        // divLogEnabled = false;
        if(qrcodeRemoveHandler){
            qrcodeRemoveHandler({retCode:0});
        }
    }

}

function showQrCode(context) {
    if(!divQrCodeEnabled)
    {
        return;
    }
    var div = document.getElementById("qrcode_panel");
    div.style.display = "lock";
    if(qrcode == null){
        qrcode = new QRCode(document.getElementById("qrcode_a"), {
            text: "",
            width:215,
            height:215,
            correctLevel : QRCode.CorrectLevel.H
        });
    }
    qrcode.makeCode(context);

}