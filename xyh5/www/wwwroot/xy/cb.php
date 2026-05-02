<?php
error_reporting(0);
$amount = $_REQUEST['amount'];
$extract_info = $_REQUEST['extract_info'];
$order_id = $_REQUEST['order_id'];
$key = "V05YLW";
$sign = md5("amount=$amount&extract_info=$extract_info&order_id=$order_id&key=$key");
file_put_contents('cb.txt', json_encode($_REQUEST).PHP_EOL, FILE_APPEND);
/**
 * [vipinfo 充值数量对应VIP等级]
 * @param  [type] $money [元宝]
 * @return [type] $viplv [VIP等级]
 */
function vipinfo($money)
{
    if ($money >= 0 && $money < 1000) {
        $viplv = 1;
    } elseif ($money >= 1000 && $money < 2000) {
        $viplv = 2;
    }elseif ($money >= 2000 && $money < 4000) {
        $viplv = 3;
    }elseif ($money >= 4000 && $money < 5000) {
        $viplv = 4;
    }elseif ($money >= 5000 && $money < 10000) {
        $viplv = 5;
    }elseif ($money >= 10000 && $money < 20000) {
        $viplv = 6;
    }elseif ($money >= 20000 && $money < 50000) {
        $viplv = 7;
    }elseif ($money >= 50000 && $money < 100000) {
        $viplv = 8;
    }elseif ($money >= 100000 && $money < 200000) {
        $viplv = 9;
    }elseif ($money >= 500000 && $money < 1000000) {
        $viplv = 10;
    }elseif ($money >= 1000000 && $money < 2000000) {
        $viplv = 11;
    }elseif ($money >= 2000000) {
        $viplv = 12;
    }
    return $viplv;
}
function recharge_gift($type, $rmb)
{
    switch ($type) {
        //首冲
        case 'fristpay':
            if ($rmb >= 12 && $rmb < 26) {
                $num = 1;
            } elseif ($rmb >= 26 && $rmb < 50) {
                $num = 2;
            } elseif ($rmb >= 50 && $rmb < 200) {
                $num = 3;
            } elseif ($rmb >= 200 && $rmb < 500) {
                $num = 4;
            } elseif ($rmb >= 500) {
                $num = 5;
            }
            break;
        //每日首冲
        case 'dayfristpay':
            if ($rmb < 38) {
                $num = 1;
            } elseif ($rmb >= 38 && $rmb < 58) {
                $num = 2;
            } elseif ($rmb >= 58 && $rmb < 88) {
                $num = 3;
            } elseif ($rmb >= 88) {
                $num = 4;
            }
            break;
        //每日累计充值
        case 'leijipay':
            //8个档次，10元 20元 50元 100元 200 500 1000 2000 每一档次充值到了都可以领取
            if ($rmb >= 10 && $rmb < 20) {
                $num = 1;
            } elseif ($rmb >= 20 && $rmb < 50) {
                $num = 2;
            } elseif ($rmb >= 50 && $rmb < 100) {
                $num = 3;
            } elseif ($rmb >= 100 && $rmb < 200) {
                $num = 4;
            } elseif ($rmb >= 200 && $rmb < 500) {
                $num = 5;
            } elseif ($rmb >= 500 && $rmb < 1000) {
                $num = 6;
            } elseif ($rmb >= 1000 && $rmb < 2000) {
                $num = 7;
            } elseif ($rmb >= 2000) {
                $num = 8;
            }
            break;
        //连续充值返利
        case 'lxpay':
            if ($rmb >= 2 && $rmb < 10) {
                $num = 1;
            } elseif ($rmb >= 10 && $rmb < 20) {
                $num = 2;
            } elseif ($rmb >= 20 && $rmb < 50) {
                $num = 3;
            } elseif ($rmb >= 50) {
                $num = 4;
            }
            break;
        default:
            $num = 0;
            break;
    }
    return $num;
}
function fristreawrd($num)
{
    if($num < 0 || $num ==''){
        $reward = '';
    }
    switch ($num) {
        case 1:
            $reward = array(1, 1);
            break;
        case 2:
            $reward = array(2, 1);
            break;
        case 3:
            $reward = array(3, 1);
            break;
        case 4:
            $reward = array(4, 1);
            break;
        case 5:
            $reward = array(5, 1);
            break;
        case 6:
            $reward = array(6, 1);
            break;
        case 7:
            $reward = array(7, 1);
            break;
        case 8:
            $reward = array(8, 1);
            break;
        default:
            $reward = '';
            break;
    }
    return json_encode($reward);
}
function fristpayreward($info)
{
    $type = $info['type'];

    switch ($type) {
        case 1:
            $num  = $info['num'];
            if ($num > 0) {
                for ($i = 1; $i <= $num; $i++) {
                    $reward = str_replace('"','', json_encode(array($i, 1)));
                    return $reward;
                }
            } else {
                return '';
            }
            break;
        case 2:
            $num  = $info['num'];
            $num1  = $info['num1'];
            if ($num > 0) {
                for ($i = $num; $i <= $num1; $i++) {
                    $reward = str_replace('"','', json_encode(array($i, 1)));
                    return $reward;
                }
            } else {
                return '';
            }
            break;
        default:
            return '';
            break;
    }
}
if($_REQUEST['sign'] == $sign){
    $conn = mysqli_connect("127.0.0.1","root","echeverra","xyj_djsxyhf_h700001_700014","3306") or die("数据库连接错误");
    $data = explode("_",$_POST['extract_info']);
    $characterid = $data[1];
	$json_string = file_get_contents('rechargedata.json'); 
	$rechargedata = json_decode($json_string, true)['root']['cfg']['root']['recharge'][$data[2]-1];

	$rmb = $amount/100;
    $money = $rmb * 2000;
    $recharge_id_list = "[" . $data[2] . "," . $rmb . "]";

    $paytime  = time();
    $toptime  = $paytime + 86400;

    $ykstart  = time();
    $day30    = 30 * 86400;
    $day7     = 7 * 86400;
    $yk7stop  = $ykstart + 7 * 86400;
    $yk30stop = $ykstart + 30 * 86400;
	switch ($rechargedata['money']){
        case "sbsc":{
            $threemoney = $rmb * 6000;
            $result     = $conn->query("SELECT * FROM three_first_impulse WHERE characterid = '{$characterid}'");
            $row        = $result->num_rows;
            if ($row > 1) {
                exit('error');
            }
            $conn->query("INSERT INTO three_first_impulse(characterid, receivestatus, recharge_id_list) VALUES ('{$characterid}', 0, '{$recharge_id_list}')");
            $conn->query("UPDATE currency SET emoney = emoney + '{$threemoney}' WHERE characterid = '{$characterid}'");
            $conn->query("UPDATE user_recharge_day SET chargenum = chargenum + '{$rmb}' WHERE characterid = '{$characterid}'");
            if ($conn->query("UPDATE recharge_dayup_activity SET recharge = recharge + '{$rmb}', receivestatus = 1 WHERE characterid = '{$characterid}'")){
                if ($conn->query("UPDATE vip SET vipexp = vipexp + '{$money}', viplev = 1 WHERE characterid = '{$characterid}'")){
                    $result = $conn->query("SELECT * FROM vip WHERE characterid = '{$characterid}'")->fetch_assoc();
                    $vipexp  = $result['vipexp'];
                    $viplev  = vipinfo($vipexp);
                    if ($conn->query("UPDATE vip SET viplev = '{$viplev}' WHERE characterid = '{$characterid}'"))
                        exit("OK");
                    else
                        exit("error");
                }
            }
            break;
        }
        case "yk":{
            $row = $conn->query("SELECT * FROM user_period_card WHERE characterid = '{$characterid}' AND buy_count>0 AND config_card = 1")->num_rows;
            if ($row > 0) {
                if ($conn->query("UPDATE user_period_card SET buy_count = buy_count + 1, finish_time = finish_time +'{$day30}' WHERE characterid = '{$characterid}' AND config_card = 1"))
                    exit('OK');
                else
                    exit("error");
            }else{
                if ($conn->query("UPDATE user_period_card SET buy_count = buy_count + 1, finish_time = '{$yk30stop}', last_reward_time = '{$ykstart}' WHERE characterid = '{$characterid}' AND config_card = 1"))
                    exit('OK');
                else
                    exit("error");
            }
            break;
        }
        case "zk":{
            $row = $conn->query("SELECT * FROM user_period_card WHERE characterid = '{$characterid}' AND buy_count>0 AND config_card = 2")->num_rows;
            if ($row > 0) {
                if ($conn->query("UPDATE user_period_card SET buy_count = buy_count + 1, finish_time = finish_time +'{$day30}' WHERE characterid = '{$characterid}' AND config_card = 2"))
                    exit('OK');
                else
                    exit("error");
            }else{
                if ($conn->query("UPDATE user_period_card SET buy_count = buy_count + 1, finish_time = '{$yk30stop}', last_reward_time = '{$ykstart}' WHERE characterid = '{$characterid}' AND config_card = 2"))
                    exit('OK');
                else
                    exit("error");
            }
            break;
        }
        case "zsk":{
            if ($conn->query("UPDATE user_period_card SET buy_count = buy_count + 1, last_reward_time = '{$ykstart}' WHERE characterid = '{$characterid}' AND config_card = 3"))
                exit('OK');
            else
                exit("error");
        }
        default:{
            if ($conn->query("UPDATE currency SET emoney = emoney + '{$money}' WHERE characterid = '{$characterid}'")){
                $rowCount = $conn->query("SELECT * FROM firstcharge WHERE characterid = '{$characterid}'")->num_rows;
                if ($rowCount < 1) {
                    $conn->query("INSERT INTO firstcharge(characterid, nowtimes, toptimes, recharge) VALUES ('{$characterid}', '{$paytime}', '{$toptime}', '{$money}')");
                }
                $conn->query("UPDATE user_recharge_day SET chargenum = chargenum + '{$rmb}' WHERE characterid = '{$characterid}'");
                if ($conn->query("UPDATE recharge_dayup_activity SET recharge = recharge + '{$rmb}', receivestatus = 1 WHERE characterid = '{$characterid}'")){
                    //新增
                    $conn->query("UPDATE user_seriesrc SET today_recharge = today_recharge + '{$money}' WHERE characterid = '{$characterid}'");
                    //首冲团购
                    //user_groupbuy_data
                    $conn->query("UPDATE user_groupbuy_data SET chargenum = chargenum + '{$money}' WHERE characterid = '{$characterid}'");

                    //=================新增累计充值返利recharge_rebate=================
                    $rowljfl    = $conn->query("SELECT * FROM recharge_rebate WHERE characterid = '{$characterid}'")->fetch_assoc();
                    $daynum     = $rowljfl['rebate_day_count'];
                    $oldtime    = $rowljfl['fanlitime'];
                    $nowtime    = time();
                    $daytime    = strtotime(date('Ymd')) + 86400;
                    $daynums = intval(($nowtime - $oldtime) / 86400);
                    if ($daynum < 1) {
                        $sqllj = "UPDATE recharge_rebate SET current_recharge_count = current_recharge_count + '{$money}',rebate_day_count=1,fanlitime = '{$paytime}' WHERE characterid = '{$characterid}'";
                        $conn->query($sqllj);
                    } else {
                        $sqlljz = "UPDATE recharge_rebate SET current_recharge_count = current_recharge_count + '{$money}', rebate_day_count = rebate_day_count + '{$daynums}' WHERE characterid = '{$characterid}'";
                        $conn->query($sqlljz);
                    }
                    //=================新增累计充值返利结束==============
                    //=================新增首冲 12 26 50 200 500 达到充值金额即可领取奖励=================
                    $resultf = $conn->query("SELECT * FROM firstimpulse WHERE characterid = '{$characterid}'");
                    $row         = $resultf->num_rows;
                    $reward      = '';
                    if ($row < 1) {
                        $rewardnum = recharge_gift('fristpay', $rmb);
                        $data      = array('type' => 1, 'num' => $rewardnum);
                        $postdata  = array('param' => $data);
                        //$reward    = http_post_data($apiurl, $postdata);
                        $reward    = fristpayreward($data);;
                        $conn->query("INSERT INTO firstimpulse(characterid, chargenum, reward_flag) VALUES ('{$characterid}', '{$rmb}', '{$reward}')");
                    } else {
                        $row1   = $resultf->fetch_assoc();
                        $prmb   = $row1['chargenum'];
                        $payrmb = $prmb + $rmb;
                        $reward = $row1['reward_flag'];
                        if ($reward == '') {
                            $rewardnum = recharge_gift('fristpay', $payrmb);
                            $data      = array('type' => 1, 'num' => $rewardnum);
                            $postdata  = array('param' => $data);
                            //$rewards   = http_post_data($apiurl, $postdata);
                            $rewards   = fristpayreward($data);

                        } else {
                            $rewardinfo = explode(',', $reward);
                            $oldnum     = count($rewardinfo);

                            if ($oldnum >= 6) {
                                $rewards = $reward;
                            } else {
                                $newnum = recharge_gift('fristpay', $payrmb);
                                if ($newnum >= $oldnum) {
                                    $data     = array('type' => 2, 'num' => $oldnum, 'num1' => $newnum);
                                    $postdata = array('param' => $data);
                                    $rewardss = fristpayreward($data);
                                    $rewards  = $reward . $rewardss;
                                } else {
                                    $rewards = $reward;
                                }
                            }
                        }
                    }
                    $conn->query("UPDATE firstimpulse SET chargenum = '{$payrmb}',reward_flag = '{$rewards}' WHERE characterid = '{$characterid}'");
                    //=================首冲结束=================
                    //=================连续充值返利 user_seriesrc=================
                    $sqllx       = "SELECT * FROM user_seriesrc WHERE characterid = '{$characterid}'";
                    $resultlx    = $conn->query($sqllx);
                    $rowlx       = $resultlx->fetch_assoc();
                    $lxrmb       = $rowlx['today_recharge'] / 100;
                    $rechargeday = $rowlx['rechargeday'];
                    $newnum      = recharge_gift('lxpay', $lxrmb);
                    if ($lxrmb > 0) {
                        if ($rechargeday == '') {
                            $newnum       = recharge_gift('lxpay', $lxrmb);
                            $data         = array('type' => 1, 'num' => $newnum);
                            $postdata     = array('param' => $data);
                            $rechargedays = fristpayreward($data);
                        } else {
                            $rewardinfo = explode(',', $rechargeday);
                            $oldnum     = count($rewardinfo);
                            if ($oldnum >= 5) {
                                $rechargedays = $rechargeday;
                            } else {
                                $newnum = recharge_gift('lxpay', $lxrmb);
                                if ($newnum >= $oldnum) {
                                    $data         = array('type' => 2, 'num' => $oldnum, 'num1' => $newnum);
                                    $postdata     = array('param' => $data);
                                    $rewardss     = fristpayreward($data);
                                    $rechargedays = $rechargeday . $rewardss;
                                } else {
                                    $rechargedays = $rechargeday;
                                }
                            }
                        }
                    } else {
                        $rechargedays = $rechargeday;
                    }
                    $sqllx = "UPDATE user_seriesrc SET rechargeday = '{$rechargedays}' WHERE characterid = '{$characterid}'";
                    $conn->query($sqllx);
                    //=================连续充值返利结束=================

                    //=================新僧每日首冲 user_firstimpulseday=================
                    $sqlu        = "SELECT * FROM user_firstimpulseday WHERE characterid = '{$characterid}'";
                    $resultu     = $conn->query($sqlu);
                    $rowu        = $resultu->num_rows;
                    $reward_flag = '';
                    if ($rowu < 1) {
                        $rewardnum1  = recharge_gift('dayfristpay', $rmb);
                        $data        = array('type' => 1, 'num' => $rewardnum1);
                        $postdata    = array('param' => $data);
                        $reward_flag = fristpayreward($data);
                        $sql         = "INSERT INTO user_firstimpulseday(characterid, chargenum, reward_flag, matchesid) VALUES ('{$characterid}', '{$rmb}', '{$reward_flag}','1')";
                        $result      = $conn->query($sql);
                    } else {
                        $row1    = $resultu->fetch_assoc();
                        $prmb1   = $row1['chargenum'];
                        $payrmb1 = $prmb1 + $rmb;
                        $reward  = $row1['reward_flag'];
                        if ($reward == '') {
                            $rewardnum1 = recharge_gift('dayfristpay', $payrmb1);
                            $data       = array('type' => 1, 'num' => $rewardnum1);
                            $postdata   = array('param' => $data);
                            $rewards    = fristpayreward($data);
                        } else {
                            $rewardinfo = explode(',', $reward);
                            $oldnum     = count($rewardinfo);
                            if ($oldnum >= 5) {
                                $rewards = $reward;
                            } else {
                                $newnum = recharge_gift('dayfristpay', $payrmb1);
                                if ($newnum >= $oldnum) {
                                    $data     = array('type' => 2, 'num' => $oldnum, 'num1' => $newnum);
                                    $postdata = array('param' => $data);
                                    $rewardss = fristpayreward($data);
                                    $rewards  = $reward . $rewardss;
                                } else {
                                    $rewards = $reward;
                                }
                            }
                        }
                    }
                    $sql    = "UPDATE user_firstimpulseday SET chargenum = '{$payrmb1}',reward_flag = '{$rewards}' WHERE characterid = '{$characterid}'";
                    $result = $conn->query($sql);
                    //=================首冲结束=================

                    //=================新僧每日累冲 user_recharge_day=================
                    $sqlu        = "SELECT * FROM user_recharge_day WHERE characterid = '{$characterid}'";
                    $resultu     = $conn->query($sqlu);
                    $rowu        = $resultu->num_rows;
                    $reward_flag = '';
                    if ($rowu < 1) {
                        $rewardnum1  = recharge_gift('leijipay', $rmb);
                        $data        = array('type' => 1, 'num' => $rewardnum1);
                        $postdata    = array('param' => $data);
                        $reward_flag = fristpayreward($data);
                        $sql         = "INSERT INTO user_recharge_day(characterid, chargenum, reward_flag, matchesid) VALUES ('{$characterid}', '{$rmb}', '{$reward_flag}','1')";
                        $result      = $conn->query($sql);
                    } else {
                        $row1   = $resultu->fetch_assoc();
                        $prmb1  = $row1['chargenum'];
                        $reward = $row1['reward_flag'];
                        if ($reward == '') {
                            $rewardnum1 = recharge_gift('leijipay', $prmb1);
                            $data       = array('type' => 1, 'num' => $rewardnum1);
                            $postdata   = array('param' => $data);
                            $rewards    = fristpayreward($data);
                        } else {
                            $rewardinfo = explode(',', $reward);
                            $oldnum     = count($rewardinfo);
                            if ($oldnum >= 9) {
                                $rewards = $reward;
                            } else {
                                $newnum = recharge_gift('leijipay', $prmb1);
                                if ($newnum >= $oldnum) {
                                    $data     = array('type' => 2, 'num' => $oldnum, 'num1' => $newnum);
                                    $postdata = array('param' => $data);
                                    $rewardss = fristpayreward($data);
                                    $rewards  = $reward . $rewardss;
                                } else {
                                    $rewards = $reward;
                                }
                            }
                        }
                    }
                    $sql    = "UPDATE user_recharge_day SET reward_flag = '{$rewards}' WHERE characterid = '{$characterid}'";
                    $result = $conn->query($sql);
                    //=================新僧每日累冲结束=================


                    if ($conn->query("UPDATE vip SET vipexp = vipexp + '{$money}', viplev = 1 WHERE characterid = '{$characterid}'")){
                        $result = $conn->query("SELECT * FROM vip WHERE characterid = '{$characterid}'")->fetch_assoc();
                        $vipexp  = $result['vipexp'];
                        $viplev  = vipinfo($vipexp);
                        if ($conn->query("UPDATE vip SET viplev = '{$viplev}' WHERE characterid = '{$characterid}'"))
                            exit("OK");
                        else
                            exit("error");
                    }
                }
            }
            break;
        }
    }
	
	
	
}else{
	exit("签名错误！");
}