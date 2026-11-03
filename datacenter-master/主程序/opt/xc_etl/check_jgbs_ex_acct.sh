#!/bin/bash
if [ $# -ne 2 ];then
    echo "Usage:$0 <bizdate><task_name>"
    exit 1
fi

BIZDATE=$1
TASK_NAME=$2

# 环境配置
export HADOOP_USER_NAME=etl_ty
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini
echo $file_date


# 提取年月日
YEAR=${BIZDATE:0:4}
MONTH=${BIZDATE:4:2}
DAY=${BIZDATE:6:2}

# 计算上个月的最后一个自然日
LAST_DAY=$(date -d "${YEAR}${MONTH}01 -1 day" +%Y%m%d 2>/dev/null)
NEW_TASK_NAME=$(echo $TASK_NAME | sed 's/[[:space:]]//g')

# 执行SQL查询判断表中存在上个月的最后一个自然日的数据
result=$(sqlplus -S $jgusername/$jgpassword@$jgurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

SELECT 
	COUNT(*) as cnt 
FROM invdata.i_fr_status_result 
WHERE sk_date = '$LAST_DAY' and task_ename='${NEW_TASK_NAME}';

EXIT;
EOF
)

cnt=$(echo $result | sed 's/[[:space:]]//g')

# 输出结果
echo '#-------------------------------------------------------'
echo "任务名称  : [ ${TASK_NAME} ]"
echo "业务日期  : [ ${LAST_DAY} ]"
echo "是否已确认  : [ ${cnt} ]"
echo '#-------------------------------------------------------'

# 判断逻辑
if [ "${cnt}" = "1" ]; then
    echo "报表已被确认"
    exit 0
elif [ "${cnt}" = "0" ]; then
    echo "报表未确认"
    exit 1
else
    echo "查询失败或找不到任务信息"
    exit 1
fi
