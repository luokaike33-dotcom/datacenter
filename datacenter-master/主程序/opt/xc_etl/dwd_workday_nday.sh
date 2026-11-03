#!/bin/bash

# 输入参数：日期，格式为yyyyMMdd
end_date=$1

# 环境配置
export HADOOP_USER_NAME=etl_ty
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini

# 执行SQL查询，判断昨天是否工作日
result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM data_mart.dim_date 
            WHERE sk_date = TO_CHAR(TO_DATE('${end_date}', 'YYYYMMDD') - 1, 'YYYYMMDD')
              AND WORKDAY_FLAG = '1'
        ) THEN '1'
        ELSE '0'
    END AS is_prev_workday
FROM DUAL;

EXIT;
EOF
)

is_prev_workday=$(echo $result | sed 's/[[:space:]]//g')

# 计算昨天日期
prev_date_result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SELECT TO_CHAR(TO_DATE('${end_date}', 'YYYYMMDD') - 1, 'YYYYMMDD') FROM DUAL;
EXIT;
EOF
)
prev_date=$(echo $prev_date_result | sed 's/[[:space:]]//g')

# 输出结果
echo '#-------------------------------------------------------'
echo "查询日期             : [ ${end_date} ]"
echo "前一天              : [ ${prev_date} ]"
echo "前一天是否工作日    : [ ${is_prev_workday} ]"
echo '#-------------------------------------------------------'

# 判断逻辑
if [ "${is_prev_workday}" = "1" ]; then
    echo "今天是工作日的下一日"
    exit 0
elif [ "${is_prev_workday}" = "0" ]; then
    echo "今天不是工作日的下一日"
    exit 1
else
    echo "查询失败或找不到日期信息"
    exit 1
fi
