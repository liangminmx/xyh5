<?php 
include_once dirname(__FILE__) . '/../mysql_compat.php';
//================================================
$key='';
//================================================
//error_reporting(0);
ini_set('date.timezone','Asia/Shanghai');
date_default_timezone_set ( 'PRC' );//时区
header("Content-type:text/html;charset=utf-8"); 
session_start();
$_SESSION['gmbt'] ='梦幻H5';
//=========================================
$admin ='admin';  //GM账号javascript:;
$gmcode =array('123456');   //GM密码
$gmadmin =array('梦幻GM');   //GM管理员
//=========================================
$qu  = $_REQUEST['qu'];
//=========================================================
$max = 9999;   //玩家邮件最大数量
$vipfile = 'vip' . $qu . '.json';
$date=date('Y-m-d H:i:s');
$yzfqu=array(
		'1'=>'1区',   //自行修改多区
		// '2'=>'2区' 
	);	
$yzfvip=array(
		'1'=>'VIP1充值',   //自行修改VIP
		'2'=>'VIP2充值邮件',
	);
$gamedb='gameserver'; //游戏角色库  自动识别分区不需要改
//=========================================================	
$YZF_CONFIG = array(
		"db_host" => "127.0.0.1",          //数据库IP
		"db_username" => "root",			//数据库帐号
		"db_password" => "echeverra",		//数据库密码
		"dbport" => 3306,
		"dbgame" =>$gamedb,   
		"charge" => "chargeserver", 
		"appid" =>	 "1101059905",
		"appkey" =>	 "L6uNankRGWjiGMje",
		"gmkey"	=>"d41d8cd98f00b204e9800998ecf8427e",
	);
$con = @mysql_connect($YZF_CONFIG['db_host'],$YZF_CONFIG['db_username'],$YZF_CONFIG['db_password'],$YZF_CONFIG['dbport']);	
$user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
$user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];	
?>