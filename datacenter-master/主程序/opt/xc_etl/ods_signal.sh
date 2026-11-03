#!/bin/bash

#执行hsql脚本
export HADOOP_USER_NAME=etl_ty

cnt=`hive -e "select count(1) from ty_dwd.etl_signal"`

msg=$(echo $cnt | sed 's/.* //')


if [ "${msg}" -eq 3 ];
then
echo "迅策hsql脚本执行成功：$msg!"
exit 0
else
echo "迅策hsql脚本执行失败：$msg!"
exit 1
fi

