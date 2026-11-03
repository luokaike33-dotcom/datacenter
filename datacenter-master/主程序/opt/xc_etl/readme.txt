sh /opt/xc_etl/run_shell_impala/run_impala_sql.sh ty_dwd.var_fund_mngr_perf_info

export HADOOP_USER_NAME=etl_ty
hive  -hivevar dwd_db=ty_dwd -hivevar current_date='20230908' -hivevar tablename=var_fund_mngr_perf_info -f /opt/xc_etl/dwd_mark.hql

