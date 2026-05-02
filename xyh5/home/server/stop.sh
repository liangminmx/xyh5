#!/bin/bash
echo "正在关闭服务端"
echo "正在关闭基础服务"
echo "正在关闭充值服务"
cd chargeserver/unix
./stop_chargeserver.sh
sleep 3
echo "正在关闭GM服务"
cd ../../gmserver/unix
./stop_gmserver.sh
sleep 3
echo "正在关闭世界服务"
cd ../../worldserver/unix
./stop_worldserver.sh
sleep 3

echo "基础服务关闭完成"

echo "正在关闭一区"

echo "正在关闭游戏服务"
cd ../../gameserver/unix
./stop_gameserver.sh
sleep 3
echo "正在关闭数据分析服务"
cd ../../operationanalysisserver/unix
./stop_operationanalysisserver.sh
sleep 3
echo "服务端关闭完成"