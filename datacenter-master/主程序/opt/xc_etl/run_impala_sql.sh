#!/bin/bash
#######################
# 执行impalaSQL
# input: --var p1=v1 --var p2=v2
# output: success(1) failed(0)
# Author: zhangwei1
# Create Date: 20230822
#######################

# get CDH-cluster Info
source /opt/xc_etl/run_shell_impala/config.properties
echo "${haproxy_url}"
echo "${impala_user}"
# echo "${impala_password}"
echo "system param  haproxy_url:${haproxy_url},impala_user:${impala_user},impala_password:********"

# 获取跑批业务参数：若参数个数偶数，则报错
param_count=$#
if ((${param_count} == 0))
then
  echo "params count is 0!"
  exit 0
fi

if ((${param_count} % 2 != 0)) 
then
  echo "business params count: ${param_count}, business values: $@"
else
  echo "params count error! count should not oushu"
  exit 0
fi

table_name=$1


# 参数拼接成imapla-shell
impala_shell_url="impala SQL: impala-shell -f refresh_impala.sql -i ${haproxy_url} -l -u ${impala_user} --auth_creds_ok_in_clear --ldap_password_cmd='echo -n ${impala_password}' --var table_name=${table_name}"
echo "${impala_shell_url}"

impala-shell -f refresh_impala.sql -i ${haproxy_url} -l -u ${impala_user} --auth_creds_ok_in_clear --ldap_password_cmd="echo -n ${impala_password}" --var table_name=${table_name}
