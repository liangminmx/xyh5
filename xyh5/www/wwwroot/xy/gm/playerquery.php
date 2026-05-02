<?php 
header("Content-type: text/html; charset=utf-8");
ini_set('date.timezone','Asia/Shanghai');
include 'config.php';
if(empty($_SESSION["vip"])){
	echo "<script>alert('非法访问 ');history.go(-1)</script>";
	exit;
}
if($_SESSION["vip"]<0||$_SESSION["vip"]>2){
	echo "<script>alert('VIP权限不足 ');history.go(-1)</script>";
	exit;
}
 if(isset($_SESSION['expiretime'])) {   
    if($_SESSION['expiretime'] < time()) {  
    unset($_SESSION['expiretime']);  
	header('Location: login.php?TIMEOUT'); // 登出  
	exit(0);  
	} else {  
	$_SESSION['expiretime'] = time() + 3600; // 刷新时间戳  
	}   
} 
	if(empty($qu)){
		echo "<script>alert('请选择分区');history.go(-1)</script>";
		exit;
	}
	$name=$_SESSION["name"];	
	mysql_select_db($YZF_CONFIG['dbgame'],$con);
	mysql_query("set names 'utf8'"); //数据库输出编码
	$result = mysql_query("SELECT * FROM `character` WHERE name LIKE '{$name}' or account LIKE '{$name}' limit 1");
	if($result&&mysql_num_rows($result)>0){
	$row = mysql_fetch_array($result);
	}
	$uid    = $row['characterid'];
	$account = $row['account'];
	$serverid=$row['serverid']; 
	$time = strtotime(date('Y-m-d'));	
	$fp = fopen($vipfile, "a+");
	if (filesize($vipfile) > 0) {
		$str = fread($fp, filesize($vipfile));
		fclose($fp);
		$vipjson = json_decode($str, true);
		if ($vipjson == null) {
			$vipjson = array();
		}
	} else {
		$vipjson = array();
	}
	if (!$vipjson[$uid]) {
		echo "<script>alert('你没有VIP权限 ');history.go(-1)</script>";
		exit;
	} elseif ($vipjson[$uid]['pwd'] != $_SESSION["pwd"]) {
		echo "<script>alert('用户密码不匹配 ');history.go(-1)</script>";
		exit;
	}
	if ($vipjson[$uid]['qu'] != $qu) {
		echo "<script>alert('授权用户与当前选择大区不匹配 ');history.go(-1)</script>";
		exit;
	}
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
				$log='log/player_charge_'.date('Y-m-d').'.log';	
				$chargenum = $_POST['chargenum'];
				$payinfo = explode('_', $chargenum);
				$billno='YZF'.date("YmdHis").rand(1000,9999); 
				mysql_query("set names 'utf8'"); //数据库输出编码
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
				$log='log/player_exp_'.date('Y-m-d').'.log';					
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
				$log='log/player_mail_'.date('Y-m-d').'.log';
				$date=date('Y-m-d H:i:s');
				$find=false;
				$file = fopen("playeritem.txt", "r");
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
				if($find==false){
					$return=array(
						'errcode'=>0,
						'info'=>'物品ID不存在',
					);
				exit(json_encode($return));
				}
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
					if($num<1 || $num>$max){
					echo "<script>alert('数量范围：1- $max');history.go(-1)</script>";
					exit;
					}
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
			case 'editpwd':	
				$pwd = $_POST['pwd'];
				if (empty($pwd)) {
						echo "<script>alert('玩家后台的授权密码不能为空 ');history.go(-1)</script>";
						exit;
					}
				$pwd=md5($uid.$pwd.$key);
				$log='log/player_pwd_'.date('Y-m-d').'.log';
				$date=date('Y-m-d H:i:s');
				$fp = fopen($vipfile, "a+");
						if (filesize($vipfile) > 0) {
							$str = fread($fp, filesize($vipfile));
							fclose($fp);
							$vipjson = json_decode($str, true);
							if ($vipjson == null) {
								$vipjson = array();
							}
						} else {
							$vipjson = array();
						}
						if ($vipjson[$uid]) {
							$vipjson[$uid] = array('pwd' => $pwd, 'level' => $vipjson[$uid]['level'], 'qu' => $vipjson[$uid]['qu']);
							file_put_contents($vipfile, json_encode($vipjson, 320));
							file_put_contents($log,$date."\t".$qu."\t".$name."\t".$uid."\t"."密码修改成功\t".$user_IP.PHP_EOL,FILE_APPEND);
							echo "<script>alert('修改成功 ');history.go(-1)</script>";
							exit;
						} else {
							echo "<script>alert('该ID并未授权 ');history.go(-1)</script>";
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