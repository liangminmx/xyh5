<?php
include 'config.php';
include 'name.php';
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
		
?>
<!DOCTYPE html>
<html>   
<head>
 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <title><?php echo $_SESSION['gmbt'];?>后台</title>
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
   <div class="row">
     <div class="container-fluid">
  <div class="modal-dialog">
    <div class="modal-content">
      <ul class="breadcrumb">
				<li>
					 <h4><?php echo $_SESSION['gmbt'];?>管理授权后台</h4>				
				</li>				
			</ul>
		<div class="modal-body">
			 <div class="form-horizontal" >
				<div class="form-group">
					<div class="col-sm-10">
					<button class="btn btn-primary btn-block" onclick="window.location.href='admin.php?qu=1'">授权系统</button>
					<button class="btn btn-info btn-block" onclick="window.location.href='gmht.php?qu=1'">后台系统</button>
					<button class="btn btn-success btn-block" onclick="window.location.href='gmlog.php?qu=1'">日志记录</button>
					<button class="btn btn-warning btn-block" onclick="window.location.href='gm.php'">退出</button>
					</div>
				</div>
			</div>
		</div>
	</div>
    <div class="modal-content">
<form id="form" name="form" method="post" action="adminquery.php">
      <div class="modal-body">
	     <div class="form-horizontal" >
				<div class="form-group">
                    <div class="col-sm-10">
                       <select class="form-control selectpicker"  onchange="self.location.href=options[selectedIndex].value" id="qu" name="qu" value="">
								<?php
								if(!empty($qu)){ echo '<option value="'.$qu.'">'.$qu.'区</option>'; } else { echo '<option style=" color:#F00; value="" >请选择分区</option>'; }
								foreach($yzfqu as $k=>$v){
								  echo '<option value="admin.php?qu='.$k.'">'.$v.'</option>';
							  }
							  ?>区
                        </select>
                    </div>
                </div>
				<div class="form-group">
                    <div class="col-sm-10">
						 <select id="name" name="name" value="" class="selectpicker show-tick form-control" data-live-search="true" data-size="5" title="选择玩家账号">
                        <?php
								while($rs=mysql_fetch_array($result)){
								?>
								<option value="<?php echo $rs['name'];?>"><?php echo $rs['name'];?></option>
								<?php
							} ?>					
                        </select>
                    </div>
                </div>	
					<div class="form-group">
                    <div class="col-sm-10">
                        <input type="text" id="pwd" name="pwd" class="form-control" value="" placeholder="请输入后台密码" >
                    </div>
                </div>	
				<div class="form-group">
                    <div class="col-sm-10">
                        <select id="vip" name="vip"  value="" class="form-control selectpicker" data-size="5"  >
								<?php
							  foreach($yzfvip as $k=>$v){
								  echo '<option value="'.$k.'">'.$v.'</option>';
							  }
							  ?>
                        </select>
                    </div>
                </div>
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-primary btn-block" name="sub" value="addvip">添加权限</button>							
                    </div>					
                </div>
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-info btn-block" name="sub" value="editvip">修改VIP权限</button>							
                    </div>					
                </div>	
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-success btn-block" name="sub" value="editpwd">修改玩家密码</button>							
                    </div>					
                </div>	
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-danger btn-block" name="sub" value="delvip">删除玩家权限</button>							
                    </div>					
                </div>		
                <div class="form-group">
                    <div class="col-sm-10">						
						  <p class="admin_copyright">&copy; </p> 
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