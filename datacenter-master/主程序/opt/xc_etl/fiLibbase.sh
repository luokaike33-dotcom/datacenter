#!/bin/bash
#sleep 300
#--------------------------------------------
# 说明： 方案落地ssh调度脚本    Oozie调度
# author：
# 参数landStartDate：落地开始日期（不传默认为系统日期前一天）
# 参数landEndDate：落地结束日期（不传默认为系统日期）
# 参数taskCalsId：任务分类树节点编号（不传默认为所有复合条件的任务均进行落地操作）,可以从Filib任务落地配置页面左边任务书的”查看落地接口“功能获取
# 参数taskId：任务编号，可以从Filib任务落地配置页面”查看落地接口“功能获取
# 参数prdCode：产品代码，可为空，落地特定产品时使用
# 参数basiCode：基准id，可为空，落地特定基准指数对象时使用
#--------------------------------------------

#落地开始时间
start_date=${1}
start_date=`date +%Y%m%d -d "${start_date}"`
start_date=`date +%Y%m%d -d "${start_date} -8 days"`

#落地结束时间
end_date=${2}
end_date=`date +%Y%m%d -d "${end_date}"`
end_date=`date +%Y%m%d -d "${end_date} -0 days"`

#落地任务id【需要替换该参数】，落地多个任务可逗号分隔
taskId=${3}

echo "start_date               : [ ${start_date} ]"
echo "end_date                 : [ ${end_date} ]"
echo "taskId                   : [ ${taskId} ]"


#落地任务对应的基准id【需要替换该参数】，落地多个基准id可分号分隔
basiId=102001;751071;751075;751076;751077;751078;751082;751083;751086;751090;751093;751096;751100;751101;751104;751108;788001;788501;788502;788503;788507;8530503

json='{"landStartDate":"'$start_date'", "landEndDate":"'$end_date'", "taskCalsId":"", "taskId":"'$taskId'", "basiId":"4225009;1855503;102001;751071;751075;751076;751077;751078;751082;751083;751086;751090;751093;751096;751100;751101;751104;751108;788001;788501;788502;788503;788507;890004;890008;890013;890017;890020;890023;8530503;890030;890035;890038;890042;890046;890050;890054;890057;890061;890065;695502;890016;890072;890073;890074;890079;890082;890102;751069"}'

result=$(curl -k -H 'Content-Type:application/json;charset=utf-8;uid=1' http://10.160.96.181:8906/filibPlan/land/filibPlanLand -X POST -d "$json")

r=$(echo $result | sed 's/,/\n/g' | grep "status" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g')

echo $r
#echo "调度落地任务成功 status:$r"
if [ $r -eq 200 ];
then
echo "迅策指标方案调度落地任务成功 status:$r"
else
echo "迅策指标方案调度落地任务失败 status:$r"
exit 1
fi
