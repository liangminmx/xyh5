<?php 
header("Content-type: text/html; charset=utf-8");
ini_set('date.timezone','Asia/Shanghai');
include 'config.php';
session_start();
if(empty($_SESSION["gm"])){
	echo "<script>alert('非法访问 ');history.go(-1)</script>";
	exit;
}
 if(isset($_SESSION['expiretime'])) {   
    if($_SESSION['expiretime'] < time()) {  
    unset($_SESSION['expiretime']);  
	header('Location: gm.php?TIMEOUT'); // 登出  
	exit(0);  
	} else {  
	$_SESSION['expiretime'] = time() + 3600; // 刷新时间戳  
	}   
} 
	if(empty($qu)){
		echo "<script>alert('请选择分区');history.go(-1)</script>";
		exit;
	}
	$name=trim($_POST['name']);
	mysql_select_db($YZF_CONFIG['dbgame'],$con);
	mysql_query("set names 'utf8'"); //数据库输出编码
	$result = mysql_query("SELECT * FROM `character` WHERE name LIKE '{$name}' or account LIKE '{$name}' limit 1");
	if($result&&mysql_num_rows($result)>0){
	$row = mysql_fetch_array($result);
	}
	$uid    = $row['characterid'];
	$account = $row['account'];
	$serverid=$row['serverid']; 
if ($_POST){   
        switch ($_POST['sub']){
			case 'sbsc':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}				
				$log='log/sbsc_'.date('Y-m-d').'.log';	
				$sbscfile='sbsc.json';
				$fp = fopen($sbscfile,"a+");
				if(filesize($sbscfile)>0){
					$str = fread($fp,filesize($sbscfile));
					fclose($fp);
					$vipjson=json_decode($str);
					if($vipjson==null){
						$vipjson=array();
					}
				}else{
					$vipjson=array();
				}
				if(!in_array($uid,$vipjson)){
					array_push($vipjson,$uid);
					file_put_contents($sbscfile,json_encode($vipjson));
				}else{
					echo "<script>alert('三倍首充已使用');history.go(-1)</script>";
					exit;
				}
				$sbscnum = $_POST['sbscnum'];
				$payinfo = explode('_', $sbscnum);
				$billno='YZF'.date("YmdHis").rand(1000,9999); 
				mysql_select_db($YZF_CONFIG['charge'],$con);
				$query = mysql_query("INSERT INTO `charge_ws`( `billno`, `billnoapp`, `chargetime`, `serverid`, `characterid`, `account`, `productid`, `money`, `platform`, `ip`, `status`, `qq_open_key`) VALUES ('{$billno}', '{$YZF_CONFIG['appid']}', NOW(), '{$serverid}', '{$uid }', '{$account}', '{$payinfo[0]}', '{$payinfo[1]}', '7', '{$user_IP}', 0, '{$YZF_CONFIG['appkey']}')");
			   if ($query){
				mysql_select_db($YZF_CONFIG['dbgame'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
				$id = date("His").rand(10,99).'700014';
				$endtime = strtotime("+3day",time());			
				$money=$payinfo[1]*30000;
				$items = "[2,".$money."]";
				$result = mysql_query("INSERT INTO `mail`(`id`, `characterid`, `mailcfgid`, `status`, `createdatetime`, `deletedatetime`, `exp`, `currencydata`, `content`, `designid`, `thingdata`, `source_flag`) VALUES ('{$id}', '{$uid}', '1001', '1', NOW(), '{$endtime}', 0, '{$items}', '', '', '', 0)");
				file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$money."\t"."充值成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('充值成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$money."\t"."充值失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('充值失败！！');history.go(-1)</script>" ;
				exit;
			   }	
				 break;
			case 'charge':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}				
				$log='log/charge_'.date('Y-m-d').'.log';	
				$chargenum = $_POST['chargenum'];
				$payinfo = explode('_', $chargenum);
				$billno='YZF'.date("YmdHis").rand(1000,9999); 
				mysql_select_db($YZF_CONFIG['charge'],$con);
				$query = mysql_query("INSERT INTO `charge_ws`( `billno`, `billnoapp`, `chargetime`, `serverid`, `characterid`, `account`, `productid`, `money`, `platform`, `ip`, `status`, `qq_open_key`) VALUES ('{$billno}', '{$YZF_CONFIG['appid']}', NOW(), '{$serverid}', '{$uid }', '{$account}', '{$payinfo[0]}', '{$payinfo[1]}', '7', '{$user_IP}', 0, '{$YZF_CONFIG['appkey']}')");
			   if ($query){
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$chargenum."\t"."充值成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('充值成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$chargenum."\t"."充值失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('充值失败！！');history.go(-1)</script>" ;
				exit;
			   }	
				 break;	
			case 'exp':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}
				$num = $_POST['mailnum'];
				if(empty($num)){
					echo "<script>alert('数量不可为空');history.go(-1)</script>";
					exit;
				}
				$log='log/exp_'.date('Y-m-d').'.log';					
				mysql_select_db($YZF_CONFIG['dbgame'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
				$id = date("His").rand(10,99).'700014';
				$endtime = strtotime("+3day",time());
			   $query = mysql_query("INSERT INTO `mail`(`id`, `characterid`, `mailcfgid`, `status`, `createdatetime`, `deletedatetime`, `exp`, `currencydata`, `content`, `designid`, `thingdata`, `source_flag`) VALUES ('{$id}', '{$uid}', '1001', '1', NOW(), '{$endtime}', '{$num}', '', '', '', '', 0)");
			   if ($query){
				file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$num."\t"."发送成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				echo "<script>alert('邮件经验发送成功!');history.go(-1)</script>" ;
				  mysql_close($con);					
			   } else {
				file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$num."\t"."发送失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo  "<script>alert('邮件经验发送失败');history.go(-1)</script>" ;
			   }
				break;
			case 'mail':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}
				$num = $_POST['mailnum'];
				if(empty($num)){
					echo "<script>alert('数量不可为空');history.go(-1)</script>";
					exit;
				}
				$item =trim($_POST['mailid']);
				$log='log/mail_'.date('Y-m-d').'.log';					
				mysql_select_db($YZF_CONFIG['dbgame'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
				$id = date("His").rand(10,99).'700014';
				$endtime = strtotime("+3day",time());				
				//======判断=======
				$find=false;
				$file = fopen("yzf.txt", "r");
					while(!feof($file))
					{
						$line=fgets($file);
						$txts=explode(';',$line);
						if($txts[0]==$item){
							$find=true;
							break;
						}
					}
					fclose($file);
				if($find==true){
					$items = "[".$item.",".$num."]";
					$query = mysql_query("INSERT INTO `mail`(`id`, `characterid`, `mailcfgid`, `status`, `createdatetime`, `deletedatetime`, `exp`, `currencydata`, `content`, `designid`, `thingdata`, `source_flag`) VALUES ('{$id}', '{$uid}', '1001', '1', NOW(), '{$endtime}', 0, '{$items}', '', '', '', 0)");
				}else{
					$items = "[".$item.",".$num.",1,0,0]";
					$query = mysql_query("INSERT INTO `mail`(`id`, `characterid`, `mailcfgid`, `status`, `createdatetime`, `deletedatetime`, `exp`, `currencydata`, `content`, `designid`, `thingdata`, `source_flag`) VALUES ('{$id}', '{$uid}', '1001', '1', NOW(), '{$endtime}', 0, '', '', '', '{$items}', 0)");
				}	
				//===															   
			   if ($query){
				file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$item."\t".$num."\t"."发送成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				echo "<script>alert('邮件发送成功!');history.go(-1)</script>" ;
				  mysql_close($con);					
			   } else {
				file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t".$item."\t".$num."\t"."发送失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo  "<script>alert('邮件发送失败');history.go(-1)</script>" ;
			   }
				break;	
			case 'fh':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}				
				$log='log/system_'.date('Y-m-d').'.log';	
				mysql_select_db($YZF_CONFIG['dbmail'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
			   $query = mysql_query("INSERT INTO `command` (serverindex, operindex, strcom, nstate,username,logdate,reser1) VALUES ('{$serverid}','10004','{$uid}','1','','{$date}',1)");			
			   // SUCCESS
			   if ($query){
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."封号成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('封号成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."封号失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('封号失败！！');history.go(-1)</script>" ;
				exit;
			   }				
				break;
			case 'jf':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}
				$log='log/system_'.date('Y-m-d').'.log';		
				mysql_select_db($YZF_CONFIG['dbmail'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
			   $query = mysql_query("INSERT INTO `command` (serverindex, operindex, strcom, nstate,username,logdate,reser1) VALUES ('{$serverid}','10089','{$uid}','1','','{$date}',1)");				
			   // SUCCESS
			   if ($query){
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."解封成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('解封成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."解封失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('解封失败！！');history.go(-1)</script>" ;
				exit;
			   }				
				break;
			case 'jy':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}	
				$log='log/system_'.date('Y-m-d').'.log';				
				mysql_select_db($YZF_CONFIG['dbmail'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
			   $query = mysql_query("INSERT INTO `command` (serverindex, operindex, strcom, nstate,username,logdate,reser1) VALUES ('{$serverid}','10087','{$uid}|1605318966','1','','{$date}',1)");				
			   // SUCCESS
			   if ($query){
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."禁言成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('禁言成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."禁言失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('禁言失败！！');history.go(-1)</script>" ;
				exit;
			   }				
				break;
			case 'jj':
				if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
				}		
				$log='log/system_'.date('Y-m-d').'.log';				
				mysql_select_db($YZF_CONFIG['dbmail'],$con);
				mysql_query("set names 'utf8'"); //数据库输出编码
			   $query = mysql_query("INSERT INTO `command` (serverindex, operindex, strcom, nstate,username,logdate,reser1) VALUES ('{$serverid}','10088','{$uid}','1','','{$date}',1)");	
			   // SUCCESS
			   if ($query){
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."解禁成功\t".$user_IP.PHP_EOL,FILE_APPEND);
				mysql_close($con);	
				echo "<script>alert('解禁成功');history.go(-1)</script>" ;
				exit;
			   } else {
				   file_put_contents($log,$date."\t".$qu."\t GM:".$_SESSION["gm"]."\t"."管理员为玩家".$name."\t".$uid."\t"."解禁失败\t".$user_IP.PHP_EOL,FILE_APPEND);
				   mysql_close($con);	
				echo   "<script>alert('解禁失败！！');history.go(-1)</script>" ;
				exit;
			   }				
				break;
            default:
                echo "<script>alert('未知操作');history.go(-1)</script>";
                break;
				exit;
        }
}
	
?>