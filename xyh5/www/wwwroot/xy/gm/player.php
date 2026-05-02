<?php
include 'config.php';
if(empty($_SESSION["vip"])){
	echo "<script>alert('非法访问 ');history.go(-1)</script>";
	exit;
}
if($_SESSION["vip"]!=1){
	echo "<script>alert('VIP权限不足 ');history.go(-1)</script>";
	exit;
}
 if(isset($_SESSION['expiretime'])) {   
    if($_SESSION['expiretime'] < time()) {  
    unset($_SESSION['expiretime']);  
	header('Location: index.php?TIMEOUT'); // 登出  
	exit(0);  
	} else {  
	$_SESSION['expiretime'] = time() + 3600; // 刷新时间戳  
	}   
} 
?>
<!DOCTYPE html>
<html>   
<head>
 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <title><?php echo $_SESSION['gmbt'];?>玩家后台</title>
 <link rel="stylesheet" href="lib/css/bootstrap.min.css">
 <link rel="stylesheet" href="lib/layui/css/layui.css" media="all">
 <script src="lib/js/jquery-1.11.0.min.js" type="text/javascript"></script>
 <script type="text/javascript" src="lib/layer/layer.js"></script>
 <script src="lib/js/bootstrap.min.js" type="text/javascript"></script>
 <link rel="stylesheet" href="lib/css/bootstrap-select.min.css">
 <script src="lib/js/bootstrap-select.min.js"></script>
</head>    
<body>
 <div class="container">
   <br>
   <div class="row">
     <div class="container-fluid">
  <div class="modal-dialog">
    <div class="modal-content">
      <ul class="breadcrumb">
				<li>
					 <h4><?php echo $_SESSION['gmbt'];?>玩家后台</h4>
				</li>				
			</ul>
	<div class="modal-body">
			 <div class="form-horizontal" >
				<div class="form-group">
                    <div class="col-sm-10">
					 <div class="alert alert-danger">
                       <strong style="color:red">温馨提示 </strong><br>
						用多少充多少，一次几千万足够用了。<br>
						所有物品需要多少刷多少，乱刷导致爆号不补后台，<br>
						后果自负。
					 </div>
                    </div>
                </div>
				<div class="form-group">
					<div class="col-sm-10">
					<button class="btn btn-success btn-block" onclick="window.location.href='player.php'">玩家后台</button>
					<button class="btn btn-warning btn-block" onclick="window.location.href='playeredit.php'">修改密码</button>
					<button class="btn btn-info btn-block" onclick="window.location.href='exit.php'">退出</button>
					</div>
				</div>
			</div>
		</div>
	</div>
    <div class="modal-content">
<form id="form" name="form" method="post" action="playerquery.php">
      <div class="modal-body">
	     <div class="form-horizontal" >
				<div class="form-group">			
                    <div class="col-sm-10">
						<label >游戏区：</label>
  <!--                      <select id="qu" name="qu"  value="" class="form-control selectpicker" data-size="5"  >
								<?php
							  foreach($yzfqu as $k=>$v){
								  echo '<option value="'.$k.'">'.$v.'</option>';
							  }
							  ?>
                        </select>
-->
                        <input type="text" readOnly="true" id="qu" name="qu" class="form-control" value="<?php echo $_SESSION["qu"]; ?>" >
                    </div>
                </div>
				<div class="form-group">				
                    <div class="col-sm-10">
					<label >玩家账号：</label>
                        <input type="text" readOnly="true" id="name" name="name" class="form-control" value="<?php echo $_SESSION["name"]; ?>" >
                    </div>
                </div>				
				<div class="form-group">
                    <div class="col-sm-10">
						<select class="form-control selectpicker" id="sbscnum" name="sbscnum" value="">					
						<option value="">三倍首充（只能充值一次）</option>
						<option value="22_10">三倍首充10元(需要邮件查收)</option>
						<option value="23_30">三倍首充30元(需要邮件查收)</option>
						<option value="24_100">三倍首充100元(需要邮件查收)</option>
						<option value="25_200">三倍首充200元(需要邮件查收)</option>
					  </select>
                    </div>
                </div>	
                <div class="form-group">
                    <div class=" col-sm-10">	
						<button type="submit" class="btn btn-success btn-block" name="sub" value="sbsc">三倍首充充值</button>					
                    </div>					
                </div>	
			<div class="form-group">
                    <div class="col-sm-10">
						<select class="form-control selectpicker" id="chargenum" name="chargenum" value="">					
						<option value="">选择充值金额</option>
						<option value="3_10">10元100000元宝</option>
						<option value="4_20">20元200000元宝</option>
						<option value="5_30">30元300000元宝</option>
						<option value="6_50">50元500000元宝</option>
						<option value="7_100">100元1000000元宝</option>
						<option value="8_200">200元2000000元宝</option>
						<option value="9_300">300元3000000元宝</option>
						<option value="10_400">400元4000000元宝</option>
						<option value="11_500">500元5000000元宝</option>
						<option value="12_600">600元6000000元宝</option>
						<option value="13_800">800元8000000元宝</option>
						<option value="14_1000">1000元10000000元宝</option>
						<option value="15_1200">1200元12000000元宝</option>
						<option value="16_1500">1500元15000000元宝</option>
						<option value="17_1800">1800元18000000元宝</option>
						<option value="18_2000">2000元20000000元宝</option>
						<option value="19_2500">2500元25000000元宝</option>
						<option value="20_3000">3000元30000000元宝</option>
						<option value="1_26">月卡</option>
						<option value="2_16">周卡</option>
						<option value="26_98">终生卡</option>
						<option value="27_1">每日特惠1元</option>
						<option value="28_3">每日特惠3元</option>
						<option value="29_6">每日特惠6元</option>
						<option value="30_10">每日特惠10元</option>
					  </select>
                    </div>
                </div>	
                <div class="form-group">
                    <div class=" col-sm-10">	
						<button type="submit" class="btn btn-success btn-block" name="sub" value="charge">角色充值</button>					
                    </div>					
                </div>	
                <div class="form-group">
                    <div class="col-sm-10">						
						  <p class="admin_copyright">&copy;</p> 
                    </div>					
                </div>					
            </div>
      </div>
    </div>
  </div>
</div>
</div>
</div>
</form>
</body>
</html>