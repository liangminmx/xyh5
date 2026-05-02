<?php 
header("Content-type: text/html; charset=utf-8");
ini_set('date.timezone','Asia/Shanghai');
include 'config.php';
if(empty($_SESSION["gm"])){
	echo "<script>alert('非法访问 ');history.go(-1)</script>";
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
	$name=trim($_POST['name']);
	$pwd=trim($_POST['pwd']);
	$vip=trim($_POST['vip']);
	mysql_query("set names 'utf8'"); //数据库输出编码
	mysql_select_db($YZF_CONFIG['dbgame'],$con);
	$result = mysql_query("SELECT * FROM `character` WHERE name LIKE '{$name}' or account LIKE '{$name}' limit 1");
	if($result&&mysql_num_rows($result)>0){
	$row = mysql_fetch_array($result);
	}
	$uid =$row['characterid'];
	$account = $row['account'];
	$serverid=$row['serverid']; 
	if(empty($uid)){
					echo "<script>alert('数据库无此角色');history.go(-1)</script>";
					exit;
	}
	$pwd=md5($uid.$pwd.$key);	
	$date=date('Y-m-d H:i:s');
if ($_POST){   
        switch ($_POST['sub']){
			case 'addvip':						
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
				$vipjson[$uid] = array('pwd' => $pwd, 'level' => $vip, 'qu' => $qu);
				file_put_contents($vipfile, json_encode($vipjson, 320));
				$log='log/log_addvip_'.date('Y-m-d').'.log';
				file_put_contents($log,$date."\t".$qu."区 GM为:".$_SESSION["gm"]."\t"."管理员添加"."\t"."玩家:".$name."\t"."权限:".$vip."\t"."成功!!"."\t IP:".$user_IP.PHP_EOL,FILE_APPEND);
				echo "<script>alert('加入VIP成功 ');history.go(-1)</script>";
				exit;
			} else {
				echo "<script>alert('该ID已经是VIP了 ');history.go(-1)</script>";
				exit;
			}
			break;
		case 'editpwd':
			if ($pwd == '') {
					echo "<script>alert('玩家后台的授权密码不能为空 ');history.go(-1)</script>";
					exit;
				}	
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
                        $vipjson[$uid] = array('pwd' => $pwd, 'level' => $vipjson[$uid]['level'], 'qu' => $qu);
                        file_put_contents($vipfile, json_encode($vipjson, 320));
						$log='log/log_editpwd_'.date('Y-m-d').'.log';
						file_put_contents($log,$date."\t".$qu."区 GM为:".$_SESSION["gm"]."\t"."管理员修改"."\t"."玩家:".$name."\t"."密码成功!!"."\t IP:".$user_IP.PHP_EOL,FILE_APPEND);
                        echo "<script>alert('修改成功 ');history.go(-1)</script>";
						exit;
                    } else {
                        echo "<script>alert('该ID并未授权 ');history.go(-1)</script>";
						exit;
                    }
			break;
		case 'editvip':
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
                        $vipjson[$uid] = array('pwd' => $vipjson[$uid]['pwd'], 'level' => $vip, 'qu' => $qu);
                        file_put_contents($vipfile, json_encode($vipjson, 320));
						$log='log/log_editvip_'.date('Y-m-d').'.log';
						file_put_contents($log,$date."\t".$qu."区 GM为:".$_SESSION["gm"]."\t"."管理员修改"."\t"."玩家:".$name."\t"."权限:".$vip."\t"."成功!!"."\t IP:".$user_IP.PHP_EOL,FILE_APPEND);
                        echo "<script>alert('修改成功 ');history.go(-1)</script>";
						exit;
                    } else {
                        echo "<script>alert('该ID并未授权 ');history.go(-1)</script>";
						exit;
                    }
			break;
		case 'delvip':			
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
                        unset($vipjson[$uid]);
                        file_put_contents($vipfile, json_encode($vipjson, 320));
						$log='log/log_delvip_'.date('Y-m-d').'.log';
						file_put_contents($log,$date."\t".$qu."区 GM为:".$_SESSION["gm"]."\t"."管理员删除"."\t"."玩家:".$name."\t"."权限成功!!"."\t IP:".$user_IP.PHP_EOL,FILE_APPEND);
                        echo "<script>alert('取消成功 ');history.go(-1)</script>";
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