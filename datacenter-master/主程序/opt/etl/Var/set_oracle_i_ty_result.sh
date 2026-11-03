##程序用于投研的i_ty_result标志位记录，可用于表级别切日监控
#!/bin/bash
if [ $# -ne 5 ];then
    echo "Usage:$0 check the number of input parameters run_date oracle_db_name oracle_table_name target_db execute_type" 
    exit -1
fi

run_date=$1
oracle_db_name=$2
oracle_table_name=$3
target_db=$4
execute_type=$5

echo $run_date
echo $oracle_db_name
echo $oracle_table_name
echo $target_db
echo $execute_type


#export ORACLE_HOME=/home/software/instantclient_11_2
#export PATH=$ORACLE_HOME/bin:$PATH
#export TNS_ADMIN=$ORACLE_HOME/network/admin
export NLS_LANG="AMERICAN_AMERICA.UTF8"


source /opt/etl/Var/cutoff_config.properties


i_ty_str_flag=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
merge into i_ty_result a
using (select  $run_date as bus_date, '$oracle_table_name' as name,'$target_db' as target_db,$execute_type as execute_type,SYSDATE as update_time from dual) b
on (a.name = b.name and a.target_db=b.target_db and a.execute_type=b.execute_type) when matched then update set  a.bus_date=b.bus_date, a.update_time = b.update_time
when not matched then insert (a.bus_date, a.name,a.target_db,a.execute_type, a.update_time)  values (b.bus_date, b.name, b.target_db,b.execute_type,b.update_time); 
exit
!`

echo $i_ty_str_flag
echo 'finish alter i_ty_result'
