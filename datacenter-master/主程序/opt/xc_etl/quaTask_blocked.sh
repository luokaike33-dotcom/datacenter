#!/bin/bash
#--------------------------------------------
# 说明： 兴全基金调度稽核任务
# author：Tyler 2023-05-29
#--------------------------------------------

# 稽核任务ID
scheduleId=$1

json='{"scheduleId":"'$scheduleId'"}'

result=$(curl -k -H 'Content-Type:application/json;charset=utf-8' http://10.160.96.181:8903/quaTaskSchedule/executeDolphin -X POST -d "$json")
echo $result

code=$(echo $result | sed 's/,"/\n/g' | grep "code"| sed 's/"//g' | sed 's/{//g' | sed 's/code//g' | sed 's/://g' )

msg=$(echo $result | sed 's/,"/\n/g' | grep "msg" | sed 's/msg"://g' | sed 's/"//g' )

if [ $code -eq 0 ];
  then
  echo "迅策数据质量稽核调度任务执行成功：$msg!"
else
  echo "迅策数据质量稽核调度任务执行失败：$msg!"
exit 1
fi

