##程序用于投研的i_ty_result标志位记录，可用于表级别切日监控
#!/bin/bash
if [ $# -ne 5 ];then
    echo "Usage:$0 check the number of input parameters run_date oracle_db_name oracle_table_name target_db execute_type"
    exit -1
fi

declare -l target_db
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

export NLS_LANG="AMERICAN_AMERICA.UTF8"


source /opt/xc_etl/config.ini
## 拼接支持的库,如有则使用

# 声明关联数组,可支持的库
declare -A support_conn
tyicontrol_conn="${tyicontrolusername}/${tyicontrolpassword}@${tyicontrolurl}"
data_mart_conn="${data_martusername}/${data_martpassword}@${data_marturl}"
support_conn[tyicontrol]=$tyicontrol_conn
support_conn[data_mart]=$data_mart_conn
# 大数据处理完成的表也默认写入tyicontrol
support_conn[cdh]=$tyicontrol_conn


# 待处理的库
IFS=',' read -r -a exec_conns <<< "$target_db"

# 更新函数
update_flag(){
   i_ty_update=`sqlplus -S $1 << !
        set heading off
        set feedback off
        set pagesize 0
        set linesize 200
        set verify off
        set echo off
        merge into i_ty_result a
        using (select  $run_date as bus_date, '$oracle_table_name' as name,upper('$2') as target_db,$execute_type as execute_type,SYSDATE as update_time from dual) b
        on (a.name = b.name and a.target_db=b.target_db and a.execute_type=b.execute_type) when matched then update set  a.bus_date=b.bus_date, a.update_time = b.update_time
        when not matched then insert (a.bus_date, a.name,a.target_db,a.execute_type, a.update_time)  values (b.bus_date, b.name, b.target_db,b.execute_type,b.update_time);
        exit
!`

}


for exec in "${exec_conns[@]}";do
    if [[ "$exec" == "tyicontrol" ]] ; then 
      echo "------------------------------------------"
      # 更新tyicontrol
      echo "this connect is ${exec} valid, start update tyicontrol.i_ty_result!"
      i_tyicontrol_flag=$(update_flag $tyicontrol_conn $target_db)
      echo "finish alter tyicontrol.i_ty_result update!"
      echo "------------------------------------------"
      sleep 1s
    elif [[ -n ${support_conn[$exec]} ]] && [[ "$exec" != "tyicontrol" ]] ; then 
      echo "------------------------------------------"
      # 更新tyicontrol
      echo "this connect is ${exec} valid, start update tyicontrol.i_ty_result!"
      i_tyicontrol_flag=$(update_flag $tyicontrol_conn $exec)
      echo "finish alter tyicontrol.i_ty_result update!"
      sleep 1s
      # 更新目标库
      echo "this connect is ${exec} valid, start update ${exec}.i_ty_result!"
      conn_str_ctl="${support_conn[$exec]}"
      i_ty_str_flag=$(update_flag $conn_str_ctl $exec)
      echo "finish alter ${exec}.i_ty_result update!"
      echo "------------------------------------------"
      sleep 1s
    else 
      echo "this connect is ${exec} invalid!"
    fi
done

echo 'finish alter i_ty_result over!'
