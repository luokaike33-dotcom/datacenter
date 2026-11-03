#!/bin/bash
# set -x
#----------------------------------------------------------------------------------------
# 说明                              : 读取任务执行流水，记入运行实例中
# 执行方式1  无分区                  ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '0' 'fin_prd_nav'
# 执行方式2  日期分区                ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '1' 'fin_prd_nav'
# 执行方式3  系统来源分区            ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '2' 'fin_prd_nav'
# 执行方式4  日+系统来源分区         ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '3' 'fin_prd_nav'
# 执行方式5  月+系统来源分区         ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '4' 'fin_prd_nav'
#----------------------------------------------------------------------------------------
# shell使用关键的参数
# 参数1：  called_start_script       : 该shell的启动脚本                        如:/opt/xc_etl/cms_data_mart_common_15.sh
# 参数1：  called_start_script_type  : 该shell的启动脚本类型                     如load和push
# 参数1：  srchivedbpath             : hive库hdfs路径                           如:/user/hive/warehouse/appraise_l0.db
# 参数2：  srchdfsurl                : hive库地址(ip:端口)                      如:192.168.0.105:8020
# 参数3：  haveKerberos              : 是否开启kbs认证                          如:yss45
#                                    ：'true'                                   启用kbs认证
#                                    : 'false'                                  不启用kbs认证
# 参数4：  kerberosKeytabFilePath    : kbs文件路径                              如:/data/dolphinscheduler/home/dolphinscheduler/resources/fa/conf/krb5/xunce.keytab
# 参数5：  kerberosPrincipal         : kbs用户                                  如:hive@XUNCE.COM
# 参数6：  kerberosConfFilePath      : kbs配置文件地址                          如:/etc/krb5.conf
# 参数7:   hadoopConfig              : Hadoop高级参数,如HA配置                  如:'"dfs.ha.namenodes.nameservice1":"namenode162,namenode187","dfs.namenode.rpc-address.nameservice1.namenode162":"pone-cdh-mgr01:8020","dfs.nameservices":"nameservice1","dfs.client.failover.proxy.provider.nameservice1":"org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider","dfs.namenode.rpc-address.nameservice1.namenode187":"pone-cdh-mgr02:8020"'
# 参数8:   srcdbtype                 :源库类型(cdh,tdh)                         如:cdh
# 参数9:   tgrdbtype                 : 目标库类型(oracle,mysql,gp,starrocks)    如:oracle
#                                      根据目标库类型选择对应路径下datax的json文件
# 参数10：  tgrurl                   : 目标库地址(ip:端口/实例名)               如:192.168.0.243:1521/orcl
#                                    : oracle (ip:端口/实例名)                  如:192.168.0.243:1521/orcl
#                                    : mysql  (ip:端口/实例名)                  如:192.168.20.132:3306/data_mart
#                                    : gp     (ip:端口/实例名)                  如:192.168.20.125:2345/ponedb
#                                    : starrocks('ip:端口,,数据库名,,FE')       如:'192.168.0.171:9030,,starrocks_ods,,"192.168.0.171:8030","192.168.0.172:8030"'
# 参数11：  tgrusername              : 目标库登录用户名                         如:xcl0etl
# 参数12：  tgrpassword              : 目标库登录密码                           如:xcl0etl
#-----------------------------------------------------------------------------------------
# shell中使用的参数
# 参数13:  srcjdbcurl                : hive库jdbc地址(ip:端口)                  如:10.150.5.30:10000
# 参数14:  srcusername               : hive库登录用户名                         如:hive
# 参数15:  srcpassword               : hive库密码                               如:hive
# 参数16:  srcdbname                 : hive库名                               如:xc_dwd
# 参数17： dataxPath                 : data服务器路径                           如:/opt/ds-resource/datax/bin
# 参数18： pubfilepath               : 文件路径(资源中心)                       如:/opt/ds-resource/dolphinscheduler/resources/fa/CMS_DATAX
# 参数19： sysrsid                   : 系统来源(多个来源用逗号分隔)             如:YSSFA45
# 参数19： biz_date                  : 运行日期                                 如:20240408
# 参数20： beg_date                  : beg_date                                 如:20220101
# 参数21： end_date                  : end_date                                 如:20220331
# 参数22： partition_mode            : 分区模式                                 如:0
#                                    ：'0'                                      不分区
#                                    : '1'                                      按日期分区
#                                    : '2'                                      按系统来源分区
#                                    : '3'                                      按日+系统来源分区
#                                    : '4'                                      按月+系统来源分区
# 参数23： tablename                 : 目标表名                                 如:fin_prd_nav
#----------------------------------------------------------------------------------------
#读取配置文件


# 该脚本所在目录
currentdir=$( cd "$( dirname "$0" )" && pwd )
currentpath=$(basename "$0")

source /opt/xc_etl/config.ini
tyicontrol_conn_str=${tyicontrolusername}"/"${tyicontrolpassword}"@"${tyicontrolurl}
# echo $tyicontrol_conn_str

# 抽取参数处理-ods_all
function push_solve_ods_all(){
called_start_script=$PARENT_SCRIPT_NAME
# 使用basename获取文件后缀
called_start_script_type="${called_start_script##*.}"
src_dbtype="oracle"
src_url=$srcoraurl
src_dbname=$srcoradbname
src_username=$srcorausername
src_password="******"
trg_dbtype="hive"
trg_dburl=$tgrhdfsurl
trg_dbname=$tgrhivedbname
trg_username=$tgrusername
trg_password="******"
have_kerberos=$haveKerberos
kerberos_keytabfile_path=$kerberosKeytabFilePath
kerberos_principal=$kerberosPrincipal
kerberos_conf_path=$kerberosConfFilePath
datax_path=$dataxPath
datax_exec_file_path=$pubfilepath
datax_exec_json_file=$jsonfilename
biz_date=$biz_date
beg_date=$beg_date
end_date=$end_date
partition_mode=$partition_mode
src_table_name=$tablename
target_table_name=$tablename
hadoop_config=$hadoopConfig
sysrsid=$sysrsid
now_time=`date "+%Y-%m-%d %H:%M:%S"`
row_key_md5_desc="md5sum(src_url+src_dbname+src_username+src_table_name+trg_dburl+trg_dbname+trg_username+target_table_name+datax_exec_file_path+datax_exec_json_file+partition_mode)"

# md5生成
MD5source="${src_url}+${src_dbname}+${src_username}+${src_table_name}+${trg_dburl}+${trg_dbname}+${trg_username}+${target_table_name}+${datax_exec_file_path}+${datax_exec_json_file}+${partition_mode}"
# echo ${MD5source}
row_key_md5=`echo -n ${MD5source}|md5sum|cut -d ' ' -f1`

}

# 推送参数处理-cms_all
function push_solve_cms_all(){
called_start_script=$PARENT_SCRIPT_NAME
# 使用basename获取文件后缀
called_start_script_type="${called_start_script##*.}"
src_dbtype=$srcdbtype
src_url=$srcjdbcurl
src_dbname=$srcdbname
src_username=$srcusername
src_password="******"
trg_dbtype=$tgrdbtype
trg_dburl=$tgrurl
# 截取第一个/后的所有字符
trg_dbname=${trg_dburl##*/}
trg_username=$tgrusername
trg_password="******"
have_kerberos=$haveKerberos
kerberos_keytabfile_path=$kerberosKeytabFilePath
kerberos_principal=$kerberosPrincipal
kerberos_conf_path=$kerberosConfFilePath
datax_path=$dataxPath
datax_exec_file_path=$pubfilepath
datax_exec_json_file=$jsonfilename
biz_date=$biz_date
beg_date=$beg_date
end_date=$end_date
partition_mode=$partition_mode
src_table_name=$([ -z "${srctablename}" ] && echo ${tablename} || echo ${srctablename})
target_table_name=$tablename
hadoop_config=$hadoopConfig
sysrsid=$sysrsid
now_time=`date "+%Y-%m-%d %H:%M:%S"`
row_key_md5_desc="md5sum(src_url+src_dbname+src_username+src_table_name+trg_dburl+trg_dbname+trg_username+target_table_name+datax_exec_file_path+datax_exec_json_file+partition_mode)"

# md5生成
MD5source="${src_url}+${src_dbname}+${src_username}+${src_table_name}+${trg_dburl}+${trg_dbname}+${trg_username}+${target_table_name}+${datax_exec_file_path}+${datax_exec_json_file}+${partition_mode}"
# echo ${MD5source}
row_key_md5=`echo -n ${MD5source}|md5sum|cut -d ' ' -f1`

};

# 推送参数处理-cms_sr_all
function push_solve_cms_sr_all(){
called_start_script=$PARENT_SCRIPT_NAME
# 使用basename获取文件后缀
called_start_script_type="${called_start_script##*.}"
src_dbtype=$srcdbtype
src_url=$srcjdbcurl
src_dbname=$srcdbname
src_username=$srcusername
src_password="******"
trg_dbtype=$tgrdbtype
trg_dburl=$tgrurl
# 截取第一个/后的所有字符
trg_dbname=$selectedDatabase
trg_username=$tgrusername
trg_password="******"
have_kerberos=$haveKerberos
kerberos_keytabfile_path=$kerberosKeytabFilePath
kerberos_principal=$kerberosPrincipal
kerberos_conf_path=$kerberosConfFilePath
datax_path=$dataxPath
datax_exec_file_path=$pubfilepath
datax_exec_json_file=$jsonfilename
biz_date=$biz_date
beg_date=$beg_date
end_date=$end_date
partition_mode=$partition_mode
src_table_name=$([ -z "${srctablename}" ] && echo ${tablename} || echo ${srctablename})
target_table_name=$tablename
hadoop_config=$hadoopConfig
sysrsid=$sysrsid
now_time=`date "+%Y-%m-%d %H:%M:%S"`
row_key_md5_desc="md5sum(src_url+src_dbname+src_username+src_table_name+trg_dburl+trg_dbname+trg_username+target_table_name+datax_exec_file_path+datax_exec_json_file+partition_mode)"

# md5生成
MD5source="${src_url}+${src_dbname}+${src_username}+${src_table_name}+${trg_dburl}+${trg_dbname}+${trg_username}+${target_table_name}+${datax_exec_file_path}+${datax_exec_json_file}+${partition_mode}"
# echo ${MD5source}
row_key_md5=`echo -n ${MD5source}|md5sum|cut -d ' ' -f1`


};

# 更新抽数表
function update_task_record_of_load(){
update_str_command=`sqlplus -S ${tyicontrol_conn_str} << !

set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off

merge into tyicontrol.datax_load_task_record t using (
select 
    '${find_maxid_next}' as pre_id,
    '${called_start_script}' as called_start_script,
    '${called_start_script_type}' as called_start_script_type,
    '${src_dbtype}' as src_dbtype,
    '${src_url}' as src_url,
    '${src_dbname}' as src_dbname,
    '${src_username}' as src_username,
    '${src_password}' as src_password,
    '${trg_dbtype}' as trg_dbtype,
    '${trg_dburl}' as trg_dburl,
    '${trg_dbname}' as trg_dbname,
    '${trg_username}' as trg_username,
    '${trg_password}' as trg_password,
    '${have_kerberos}' as have_kerberos,
    '${kerberos_keytabfile_path}' as kerberos_keytabfile_path,
    '${kerberos_principal}' as kerberos_principal,
    '${kerberos_conf_path}' as kerberos_conf_path,
    '${datax_path}' as datax_path,
    '${datax_exec_file_path}' as datax_exec_file_path,
    '${datax_exec_json_file}' as datax_exec_json_file,
    '${biz_date}' as biz_date,
    '${beg_date}' as beg_date,
    '${end_date}' as end_date,
    '${partition_mode}' as partition_mode,
    '${src_table_name}' as src_table_name,
    '${target_table_name}' as target_table_name,
    '${hadoop_config}' as hadoop_config,
    '${sysrsid}' as sysrsid,
    '${now_time}' as now_time,
    '${row_key_md5_desc}' as row_key_md5_desc,
    '${row_key_md5}' as row_key_md5
    from dual
) t1 on (t.row_key_md5 = t1.row_key_md5)
when matched then 
   update set
      t.called_start_script = t1.called_start_script,
      t.called_start_script_type = t1.called_start_script_type,
      t.src_dbtype = t1.src_dbtype,
      t.src_url = t1.src_url,
      t.src_dbname = t1.src_dbname,
      t.src_username = t1.src_username,
      t.src_password = t1.src_password,
      t.trg_dbtype = t1.trg_dbtype,
      t.trg_dburl = t1.trg_dburl,
      t.trg_dbname = t1.trg_dbname,
      t.trg_username = t1.trg_username,
      t.trg_password = t1.trg_password,
      t.have_kerberos = t1.have_kerberos,
      t.kerberos_keytabfile_path = t1.kerberos_keytabfile_path,
      t.kerberos_principal = t1.kerberos_principal,
      t.kerberos_conf_path = t1.kerberos_conf_path,
      t.datax_path = t1.datax_path,
      t.datax_exec_file_path = t1.datax_exec_file_path,
      t.datax_exec_json_file = t1.datax_exec_json_file,
      t.biz_date = t1.biz_date,
      t.beg_date = t1.beg_date,
      t.end_date = t1.end_date,
      t.partition_mode = t1.partition_mode,
      t.src_table_name = t1.src_table_name,
      t.target_table_name = t1.target_table_name,
      t.hadoop_config = t1.hadoop_config,
      t.sysrsid = t1.sysrsid,
      t.update_time = t1.now_time,
      t.row_key_md5_desc = t1.row_key_md5_desc
when not matched then 
    insert (
        t.id,
        t.called_start_script,
        t.called_start_script_type,
        t.src_dbtype,
        t.src_url,
        t.src_dbname,
        t.src_username,
        t.src_password,
        t.trg_dbtype,
        t.trg_dburl,
        t.trg_dbname,
        t.trg_username,
        t.trg_password,
        t.have_kerberos,
        t.kerberos_keytabfile_path,
        t.kerberos_principal,
        t.kerberos_conf_path,
        t.datax_path,
        t.datax_exec_file_path,
        t.datax_exec_json_file,
        t.biz_date,
        t.beg_date,
        t.end_date,
        t.partition_mode,
        t.src_table_name,
        t.target_table_name,
        t.hadoop_config,
        t.sysrsid,
        t.insert_time,
        t.update_time,
        t.row_key_md5_desc,
        t.row_key_md5
    )
    values(
        t1.pre_id,
        t1.called_start_script,
        t1.called_start_script_type,
        t1.src_dbtype,
        t1.src_url,
        t1.src_dbname,
        t1.src_username,
        t1.src_password,
        t1.trg_dbtype,
        t1.trg_dburl,
        t1.trg_dbname,
        t1.trg_username,
        t1.trg_password,
        t1.have_kerberos,
        t1.kerberos_keytabfile_path,
        t1.kerberos_principal,
        t1.kerberos_conf_path,
        t1.datax_path,
        t1.datax_exec_file_path,
        t1.datax_exec_json_file,
        t1.biz_date,
        t1.beg_date,
        t1.end_date,
        t1.partition_mode,
        t1.src_table_name,
        t1.target_table_name,
        t1.hadoop_config,
        t1.sysrsid,
        t1.now_time,
        t1.now_time,
        t1.row_key_md5_desc,
        t1.row_key_md5
    ) ;
exit
!`

}


# 更新推数表
function update_task_record_of_push(){
update_str_command=`sqlplus -S ${tyicontrol_conn_str} << !

set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off

merge into tyicontrol.datax_push_task_record t using (
select 
    '${find_maxid_next}' as pre_id,
    '${called_start_script}' as called_start_script,
    '${called_start_script_type}' as called_start_script_type,
    '${src_dbtype}' as src_dbtype,
    '${src_url}' as src_url,
    '${src_dbname}' as src_dbname,
    '${src_username}' as src_username,
    '${src_password}' as src_password,
    '${trg_dbtype}' as trg_dbtype,
    '${trg_dburl}' as trg_dburl,
    '${trg_dbname}' as trg_dbname,
    '${trg_username}' as trg_username,
    '${trg_password}' as trg_password,
    '${have_kerberos}' as have_kerberos,
    '${kerberos_keytabfile_path}' as kerberos_keytabfile_path,
    '${kerberos_principal}' as kerberos_principal,
    '${kerberos_conf_path}' as kerberos_conf_path,
    '${datax_path}' as datax_path,
    '${datax_exec_file_path}' as datax_exec_file_path,
    '${datax_exec_json_file}' as datax_exec_json_file,
    '${biz_date}' as biz_date,
    '${beg_date}' as beg_date,
    '${end_date}' as end_date,
    '${partition_mode}' as partition_mode,
    '${src_table_name}' as src_table_name,
    '${target_table_name}' as target_table_name,
    '${hadoop_config}' as hadoop_config,
    '${sysrsid}' as sysrsid,
    '${now_time}' as now_time,
    '${row_key_md5_desc}' as row_key_md5_desc,
    '${row_key_md5}' as row_key_md5
    from dual
) t1 on (t.row_key_md5 = t1.row_key_md5)
when matched then 
   update set
      t.called_start_script = t1.called_start_script,
      t.called_start_script_type = t1.called_start_script_type,
      t.src_dbtype = t1.src_dbtype,
      t.src_url = t1.src_url,
      t.src_dbname = t1.src_dbname,
      t.src_username = t1.src_username,
      t.src_password = t1.src_password,
      t.trg_dbtype = t1.trg_dbtype,
      t.trg_dburl = t1.trg_dburl,
      t.trg_dbname = t1.trg_dbname,
      t.trg_username = t1.trg_username,
      t.trg_password = t1.trg_password,
      t.have_kerberos = t1.have_kerberos,
      t.kerberos_keytabfile_path = t1.kerberos_keytabfile_path,
      t.kerberos_principal = t1.kerberos_principal,
      t.kerberos_conf_path = t1.kerberos_conf_path,
      t.datax_path = t1.datax_path,
      t.datax_exec_file_path = t1.datax_exec_file_path,
      t.datax_exec_json_file = t1.datax_exec_json_file,
      t.biz_date = t1.biz_date,
      t.beg_date = t1.beg_date,
      t.end_date = t1.end_date,
      t.partition_mode = t1.partition_mode,
      t.src_table_name = t1.src_table_name,
      t.target_table_name = t1.target_table_name,
      t.hadoop_config = t1.hadoop_config,
      t.sysrsid = t1.sysrsid,
      t.update_time = t1.now_time,
      t.row_key_md5_desc = t1.row_key_md5_desc
when not matched then 
    insert (
        t.id,
        t.called_start_script,
        t.called_start_script_type,
        t.src_dbtype,
        t.src_url,
        t.src_dbname,
        t.src_username,
        t.src_password,
        t.trg_dbtype,
        t.trg_dburl,
        t.trg_dbname,
        t.trg_username,
        t.trg_password,
        t.have_kerberos,
        t.kerberos_keytabfile_path,
        t.kerberos_principal,
        t.kerberos_conf_path,
        t.datax_path,
        t.datax_exec_file_path,
        t.datax_exec_json_file,
        t.biz_date,
        t.beg_date,
        t.end_date,
        t.partition_mode,
        t.src_table_name,
        t.target_table_name,
        t.hadoop_config,
        t.sysrsid,
        t.insert_time,
        t.update_time,
        t.row_key_md5_desc,
        t.row_key_md5
    )
    values(
        t1.pre_id,
        t1.called_start_script,
        t1.called_start_script_type,
        t1.src_dbtype,
        t1.src_url,
        t1.src_dbname,
        t1.src_username,
        t1.src_password,
        t1.trg_dbtype,
        t1.trg_dburl,
        t1.trg_dbname,
        t1.trg_username,
        t1.trg_password,
        t1.have_kerberos,
        t1.kerberos_keytabfile_path,
        t1.kerberos_principal,
        t1.kerberos_conf_path,
        t1.datax_path,
        t1.datax_exec_file_path,
        t1.datax_exec_json_file,
        t1.biz_date,
        t1.beg_date,
        t1.end_date,
        t1.partition_mode,
        t1.src_table_name,
        t1.target_table_name,
        t1.hadoop_config,
        t1.sysrsid,
        t1.now_time,
        t1.now_time,
        t1.row_key_md5_desc,
        t1.row_key_md5
    ) ;
exit
!`

}



# 推送-cms_sr_all
if [[ $currentpath == *cms_sr_all* ]]; then
    # 参数处理
  push_solve_cms_sr_all
# 获取最大id
find_maxid=`sqlplus -S ${tyicontrol_conn_str} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
select nvl(max(id),0) as max_id from tyicontrol.datax_push_task_record t;
exit
!`

find_maxid_next=`echo $[++find_maxid]`
  # echo ${find_maxid_next}
  
  update_task_record_of_push
  echo 'push record update is over! '
# 推送-cms_all
elif [[ $currentpath == *cms_all* ]]; then
  # 参数处理
  push_solve_cms_all
# 获取最大id
find_maxid=`sqlplus -S ${tyicontrol_conn_str} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
select nvl(max(id),0) as max_id from tyicontrol.datax_push_task_record t;
exit
!`

find_maxid_next=`echo $[++find_maxid]`
  # echo ${find_maxid_next}
  
  update_task_record_of_push
  echo 'push record update is over! '
# 抽取-ods_all
elif [[ $currentpath == *ods_all* ]]; then
    # 参数处理
  push_solve_ods_all
# 获取最大id
find_maxid_load=`sqlplus -S ${tyicontrol_conn_str} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
select nvl(max(id),0) as max_id from tyicontrol.datax_load_task_record t;
exit
!`

find_maxid_next=`echo $[++find_maxid_load]`
  # echo ${find_maxid_next}
  
  update_task_record_of_load
  echo 'load record update is over! '
else
  echo 'no such types,only support load and push'
fi

# echo `ps -ef | grep ${currentpath}`
exit 0 # 成功的退出



