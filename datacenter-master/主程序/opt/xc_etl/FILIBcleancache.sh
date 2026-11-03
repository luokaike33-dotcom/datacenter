#!/bin/bash
#sleep 300
#--------------------------------------------
# 说明： FILIB缓存清除ssh调度脚本    Oozie调度 注意替换http接口的IP
# author：
#--------------------------------------------

result=$(curl -k -H 'Content-Type:application/json;charset=utf-8' http://10.160.96.181:8111/job/clearCache?key=* -X GET)

r=$(echo $result | sed 's/,/\n/g' | grep "status" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g')


if [ $r -eq 200 ];
then
echo "FILIB缓存清除任务成功 status:$r"
else
echo "FILIB缓存清除任务失败 status:$r"
fi
sleep 3
# 再执行一次清除缓存接口，确保缓存清除成功
result=$(curl -k -H 'Content-Type:application/json;charset=utf-8' http://10.160.96.181:8111/job/clearCache?key=* -X GET)

echo "清除redis缓存完成"



result=$(curl -k -H 'Content-Type:application/json;charset=utf-8' http://10.160.96.181:8111/job/reinit?mode=2 -X GET)

r=$(echo $result | sed 's/,/\n/g' | grep "status" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g')


if [ $r -eq 200 ];
then
echo "FILIB刷新上下文指标成功 status:$r"
else
echo "FILIB刷新上下文指标失败 status:$r，$result"
fi