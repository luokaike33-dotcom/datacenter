#--------------------------------------------
# 说明： 方案落地ssh调度脚本    Oozie调度
# 参数landStartDate：落地开始日期（不传默认为系统日期前一天）
# 参数landEndDate：落地结束日期（不传默认为系统日期）
# 参数taskCalsId：任务分类树节点编号，多个任务分类节点编号用英文逗号分隔（不传默认为所有符合条件的任务均进行落地操作）,可以从Filib任务落地配置页面左边任务书的”查看落地接口“功能获取
# 参数taskId：任务编号，多个任务编号用英文逗号分隔，可以从Filib任务落地配置页面”查看落地接口“功能获取（不传默认为所有符合taskCalsId条件的任务均进行落地操作）
#--------------------------------------------

# 落地开始时间
start_date=${1}
start_date=`date +%Y%m%d -d "${start_date}"`
start_date=`date +%Y%m%d -d "${start_date} -7 days"`
# 落地结束时间
end_date=${2}
end_date=`date +%Y%m%d -d "${end_date}"`
end_date=`date +%Y%m%d -d "${end_date} -1 days"`
# 任务分类树节点编号
taskCalsId=${3}
# 任务编号
#taskId=${4}

echo "start_date               : [ ${start_date} ]"
echo "end_date                 : [ ${end_date} ]"
echo "taskCalsId               : [ ${taskCalsId} ]"
#echo "taskId                   : [ ${taskId} ]"



#echo "xq-job-return: {\"currentProcess.start_date\":\""$start_date""\","\"currentProcess.end_date\":\""$end_date""\","\"currentProcess.taskCalsId\":\""$taskCalsId""\"}""


json='{"landStartDate":"'$start_date'", "landEndDate":"'$end_date'", "taskCalsId":"'$taskCalsId'"}'

result=$(curl -k -H 'Content-Type:application/json;charset=utf-8;uid=1' http://10.160.96.181:8906/filibPlan/land/filibPlanLand -X POST -d "$json")
#echo "result                   : [ ${result} ]"
msg=$(echo $result | sed 's/,"/\n/g' | grep "msg" | sed 's/msg"://g' | sed 's/"//g' )

status=$(echo $result | sed 's/,/\n/g' | grep "status" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g')

if [ $status -eq 200 ];
then
echo "迅策指标方案调度任务执行成功：$msg!"
else
echo "迅策指标方案调度任务执行失败：$msg!"
exit 1
fi



