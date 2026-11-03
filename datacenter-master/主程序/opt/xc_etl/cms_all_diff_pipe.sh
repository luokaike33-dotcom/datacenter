#!/bin/bash
# set -x
#----------------------------------------------------------------------------------------
# 说明                        : L0层通用执行脚本(应用于Hive->应用库工作流建设子节点时)
# 执行方式1  无分区                  ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '0' 'fin_prd_nav'
# 执行方式2  日期分区                ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '1' 'fin_prd_nav'
# 执行方式3  系统来源分区            ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '2' 'fin_prd_nav'
# 执行方式4  日+系统来源分区         ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '3' 'fin_prd_nav'
# 执行方式5  月+系统来源分区         ：sh ${pubfilepath}/common_cms.sh ${srchivedbpath} ${srchdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${kerberosConfFilePath} ${hadoopConfig} ${srcdbtype} ${tgrdbtype} ${tgrurl} ${tgrusername} ${tgrpassword} ${srcjdbcurl} ${srcusername} ${srcpassword} ${dataxPath} ${pubfilepath} ${sysrsid} ${beg_date} ${end_date} '4' 'fin_prd_nav'
#----------------------------------------------------------------------------------------
# json中使用的参数
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

# 20250910 隐藏日志显示密码
get_config() {
    # 获取当前脚本的绝对路径
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    
    # 定义 get_config.sh 的绝对路径
    GET_CONFIG_SCRIPT="${SCRIPT_DIR}/get_config.sh"

    local key_name=$1

    # 调用 get_config.sh 并处理结果
    local value
    value=$(sh $GET_CONFIG_SCRIPT "$key_name" 2>&1) || {
        echo "配置错误：获取 '$key_name' 失败" >&2
        echo "错误详情：$value" >&2
        return 1
    }
    
    echo "$value"
}

srchivedbpath=$1
srchdfsurl=$2
haveKerberos=$3
kerberosKeytabFilePath=$4
kerberosPrincipal=$5
kerberosConfFilePath=$6
hadoopConfig=$7
srcdbtype=$8
tgrdbtype=$9
tgrurl=${10}
tgrusername=${11}
tgrpassword=$(get_config "${12}") || exit 1
srcjdbcurl=${13}
srcusername=${14}
srcpassword=$(get_config "${15}") || exit 1
srcdbname=${16}
dataxPath=${17}
pubfilepath=${18}
sysrsid=${19}
beg_date=${20}
end_date=${21}
partition_mode=${22}
srctablename=${23}
tablename=${24}
jsonfilename=${tablename}.json
curr_date=$(date +"%Y-%m-%d %H:%M:%S")

#loadUrl=${24}
#selectedDatabase=${25}
#if [[ $# != 23 ]];then
  # echo "Incorrect number of arguments passed, error exit"
 #  exit 1
#fi

# starrocks个性化参数 selectedDatabase:数据库名;loadUrl:FE
selectedDatabase=""
loadUrl=""
if [ "${tgrdbtype}" == "starrocks" ]; then
  urls=(${tgrurl//,,/ })
  tgrurl=${urls[0]}
  selectedDatabase=${urls[1]}
  loadUrl=${urls[2]}
fi

gen_date()
{
#如果参数2为空，取前一天；
if [ "${beg_date}" = "" ]; then
 datebeg=`date -d -1day +%Y%m%d`
else
 datebeg=${beg_date}
fi
#如果参数3为空，取当天；
if [ "${end_date}" = "" ]; then
 dateend=`date +"%Y%m%d"`
else
 dateend=${end_date}
fi
beg_s=`date -d "$datebeg" +%s`
if [ "$?" != "0" ]; then exit 1 ; fi
end_s=`date -d "$dateend" +%s`
if [ "$?" != "0" ]; then exit 1 ; fi
while [ "$beg_s" -le "$end_s" ] ;do
    date -d "@$beg_s" +"%Y%m%d"
    beg_s=$((beg_s+86400))
done
}

echo "srchivedbpath           : [ ${srchivedbpath} ]"
echo "srchdfsurl              : [ ${srchdfsurl} ]"
echo "haveKerberos            : [ ${haveKerberos} ]"
echo "kerberosKeytabFilePath  : [ ${kerberosKeytabFilePath} ]"
echo "kerberosPrincipal       : [ ${kerberosPrincipal} ]"
echo "kerberosConfFilePath    : [ ${kerberosConfFilePath} ]"
echo "hadoopConfig            : [ ${hadoopConfig} ]"
echo "srcdbtype               : [ ${srcdbtype} ]"
echo "tgrdbtype               : [ ${tgrdbtype} ]"
echo "tgrurl                  : [ ${tgrurl} ]"
echo "tgrusername             : [ ${tgrusername} ]"
# echo "tgrpassword             : [ ${tgrpassword} ]"
echo "srcjdbcurl              : [ ${srcjdbcurl} ]"
echo "srcusername             : [ ${srcusername} ]"
# echo "srcpassword             : [ ${srcpassword} ]"
echo "srcdbname               : [ ${srcdbname} ]"
echo "dataxPath               : [ ${dataxPath} ]"
echo "pubfilepath             : [ ${pubfilepath} ]"
echo "sysrsid                 : [ ${sysrsid} ]"
echo "beg_date                : [ ${beg_date} ]"
echo "end_date                : [ ${end_date} ]"
echo "partition_mode          : [ ${partition_mode} ]"
echo "tablename               : [ ${tablename} ]"
echo "srctablename            : [ ${srctablename} ]"
echo "jsonfilename            : [ ${jsonfilename} ]"

if [ "${tgrdbtype}" == "starrocks" ]; then
  echo "loadUrl                 : [ ${loadUrl} ]"
  echo "selectedDatabase        : [ ${selectedDatabase} ]"
fi

# 20240412 添加执行实例日志表
# 父Shell脚本名
currentdir=$( cd "$( dirname "$0" )" && pwd )
currentpath=$(basename "$0")
parent_script_name="${currentdir}/${currentpath}"
# 导出为环境变量
export PARENT_SCRIPT_NAME="$parent_script_name"
# 导入执行实例日志表中
source /opt/xc_etl/task_pipelining.sh $PARENT_SCRIPT_NAME &
echo "pipeline task is running"

if [ "${srcdbtype}" == "tdh" ];then
  . /opt/ds-resource/TDH-Client/init.sh
fi
#kbs认证,有时连接超时，重试5次后报错退出
st_int=0
if [ "${haveKerberos}" == "true" ];then
  while [ ${st_int} -lt 5 ]
  do
     kinit -kt ${kerberosKeytabFilePath} ${kerberosPrincipal}
     if [ $? -ne 0 ];then
       echo "Kinit Error,After sleep 5 seconds, re-execute. ${st_int}"
       sleep 5
       let st_int++
       continue
     fi
     st_int=5
     echo -e "\n\n"
     echo '#-------------------------------------------------------'
     echo "${kerberosPrincipal} user KBS authentication successful  "
     echo '#-------------------------------------------------------'
     echo -e "\n\n"
  done
fi

export HADOOP_USER_NAME=etl_ty

exec_sql=""
# tdh分支
if [ "${srcdbtype}" == "tdh" ];then
  #无分区
  if [ "${partition_mode}" == "0" ];then
    exec_sql="insert overwrite table ${srcdbname}.${tablename}_text select * from ${srcdbname}.${tablename};"
  #日期分区
  elif  [ "${partition_mode}" == "1" ];then
    exec_sql="insert overwrite table ${srcdbname}.${tablename}_text select * from ${srcdbname}.${tablename} where p_dt >= ${beg_date} and p_dt <= ${end_date} and busi_month >= ${beg_date:0:6} and busi_month <= ${end_date:0:6};"
  #系统来源分区
  elif  [ "${partition_mode}" == "2" ];then
    array="${sysrsid//,/','}"
    exec_sql="insert overwrite table ${srcdbname}.${tablename}_text select * from ${srcdbname}.${tablename} where sys_rs_id in ('${array}');"
  #日期分区+系统来源分区 或 月分区+系统来源分区
  elif  [ "${partition_mode}" == "3" -o "${partition_mode}" == "4" ];then
    array="${sysrsid//,/','}"
    exec_sql="insert overwrite table ${srcdbname}.${tablename}_text select * from ${srcdbname}.${tablename} where  p_dt >= ${beg_date} and p_dt <= ${end_date} and busi_month >= ${beg_date:0:6} and busi_month <= ${end_date:0:6}"
  fi

 # busi_month=`date -d ${biz_date} +%Y%m`

  #if [ "${haveKerberos}" == "true" ];then
  #  beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname};principal=hive/${kerberosPrincipal}" -e "${exec_sql}"
  #else
  beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "${exec_sql}"
  #fi
  if [ $? -eq 0 ] ; then
     rows=`beeline --showHeader=false --nullemptystring=false --outputformat=csv --silent=flase -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "select count(1) from ${srcdbname}.${srctablename}_text"`
     rows=${rows#*"\""}
     rows=${rows%*"\""}
     if [ ${rows} -gt 0 ] ; then
       array="${sysrsid//,/','}"
       python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dsrcdbtype=${srcdbtype} -Dtgrdbtype=${tgrdbtype} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsrcjdbcurl=${srcjdbcurl} -Dsrcusername=${srcusername} -Dsrcpassword=${srcpassword} -Dsrcdbname=${srcdbname} -DdataxPath=${dataxPath} -Dpubfilepath=${pubfilepath} -Dsysrsid=${sysrsid} -Dbeg_date=${beg_date} -Dend_date=${end_date} -Dpartition_mode=${partition_mode} -Dtablename=${tablename} -Dsrctablename=${srctablename} -Djsonfilename=${jsonfilename} -Dbusi_month=${busi_month} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
       if [ $? -ne 0 ] ; then
         echo "exec ${jsonfilename} error,exit"/
         exit 1
       fi
       #if [ "${haveKerberos}" == "true" ];then
       #  beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname};principal=hive/${kerberosPrincipal}" -e "truncate table ${srcdbname}.${srctablename}_text;"
       #else
       beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "truncate table ${srcdbname}.${srctablename}_text;"
       #fi
     else
       echo "${srchivedbpath}/${srctablename}_text have no data!"
       exit 1
     fi
   else
     echo "exec ${exec_sql} error,exit"
     exit 1
  fi
else
  #无分区
  if [ "${partition_mode}" == "0" ];then
    hadoop fs -test -d ${srchivedbpath}/${srctablename}
    if [ $? -eq 0 ] ; then
      python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dsrcdbtype=${srcdbtype} -Dtgrdbtype=${tgrdbtype} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsrcjdbcurl=${srcjdbcurl} -Dsrcusername=${srcusername} -Dsrcpassword=${srcpassword} -Dsrcdbname=${srcdbname} -DdataxPath=${dataxPath} -Dpubfilepath=${pubfilepath} -Dsysrsid=${sysrsid} -Dbeg_date=${beg_date} -Dend_date=${end_date} -Dpartition_mode=${partition_mode} -Dtablename=${tablename} -Dsrctablename=${srctablename} -Djsonfilename=${jsonfilename} -Dbusi_month=${busi_month} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
      if [ $? -ne 0 ] ; then
        echo "exec ${jsonfilename} error,exit"
        exit 1
      fi
    else
      echo "${srchivedbpath}/${srctablename} not exists!"
      exit 1
    fi

  #日期分区
  elif  [ "${partition_mode}" == "1" ];then
    for n in `gen_date ${beg_date} ${end_date}`
    do
      hadoop fs -test -d ${srchivedbpath}/${srctablename}/p_dt=$n
      if [ $? -eq 0 ] ; then
        python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dsrcdbtype=${srcdbtype} -Dtgrdbtype=${tgrdbtype} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsrcjdbcurl=${srcjdbcurl} -Dsrcusername=${srcusername} -Dsrcpassword=${srcpassword} -Dsrcdbname=${srcdbname} -DdataxPath=${dataxPath} -Dpubfilepath=${pubfilepath} -Dsysrsid=${sysrsid} -Dbeg_date=${beg_date} -Dend_date=${end_date} -Dpartition_mode=${partition_mode} -Dtablename=${tablename} -Dsrctablename=${srctablename} -Djsonfilename=${jsonfilename} -Dbusi_month=${busi_month} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
        if [ $? -ne 0 ] ; then
          echo "exec ${jsonfilename} error,exit"
          exit 1
        fi
      else
        echo "${srchivedbpath}/${tablename}/p_dt=$n not exists!"
        #exit 1
      fi
     done
    

  #系统来源分区
  elif  [ "${partition_mode}" == "2" ];then
    array=(${sysrsid//,/ })
    for sysrs in ${array[@]}
    do
      hadoop fs -test -d ${srchivedbpath}/${srctablename}/sys_rs_id=$sysrs
      if [ $? -eq 0 ] ; then
        python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dsrcdbtype=${srcdbtype} -Dtgrdbtype=${tgrdbtype} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsrcjdbcurl=${srcjdbcurl} -Dsrcusername=${srcusername} -Dsrcpassword=${srcpassword} -Dsrcdbname=${srcdbname} -DdataxPath=${dataxPath} -Dpubfilepath=${pubfilepath} -Dsysrsid=${sysrsid} -Dbeg_date=${beg_date} -Dend_date=${end_date} -Dpartition_mode=${partition_mode} -Dtablename=${tablename} -Dsrctablename=${srctablename} -Djsonfilename=${jsonfilename} -Dbusi_month=${busi_month} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -Dp_dt=$n -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
        if [ $? -ne 0 ] ; then
          echo "exec ${jsonfilename} error,exit"
          exit 1
        fi
      else
        echo "${srchivedbpath}/${srctablename}/sys_rs_id=$sysrs not exists!"
       # exit 1
      fi
    done

  #日期分区+系统来源分区
  elif  [ "${partition_mode}" == "4" ];then
  
   year_beg=`date -d ${beg_date} +%Y`
   year_end=`date -d ${end_date} +%Y`
   year_diff=`expr $year_end - $year_beg`
   year=`expr $year_diff \* 12`
   month_beg=`date -d ${beg_date} +%m`
   month_end=`date -d ${end_date} +%m`
   month_diff=`expr $year + $month_end - $month_beg`
  echo "count:"`expr $month_diff + 1`
  for i in `seq 0 $month_diff` #0 1 2
  do
     #循环中日期处理
     beg_date=`date -d ${beg_date} +%Y%m01`  #解决 +1monthon加当前月天数
     biz_date=`date -d"${beg_date} $i month" +%Y%m%d` #当前批次日期 0
     beg_date_first=`date -d ${biz_date} +%Y%m01` #当前批次日期第一天 作为月分区日期 20220101
     next_month_first=`date -d"${biz_date} 1 month" +%Y%m01`  #当前计算日期的下个月的第一天 20220201
     beg_date_last=`date -d"${next_month_first} last day" +%Y%m%d`  #当前计算日期最后一天 20220131
     busi_month=`date -d ${biz_date} +%Y%m`
     echo "tradingday:"$busi_month
	 
     hadoop fs -test -d ${srchivedbpath}/${srctablename}/busi_month=$busi_month
     if [ $? -eq 0 ] ; then
      python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dsrcdbtype=${srcdbtype} -Dtgrdbtype=${tgrdbtype} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsrcjdbcurl=${srcjdbcurl} -Dsrcusername=${srcusername} -Dsrcpassword=${srcpassword} -Dsrcdbname=${srcdbname} -DdataxPath=${dataxPath} -Dpubfilepath=${pubfilepath} -Dsysrsid=${sysrsid} -Dbeg_date=${beg_date} -Dend_date=${end_date} -Dpartition_mode=${partition_mode} -Dtablename=${tablename} -Dsrctablename=${srctablename} -Djsonfilename=${jsonfilename} -Dbusi_month=${busi_month} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
          if [ $? -ne 0 ] ; then
            echo "exec ${jsonfilename} error,exit"
            exit 1
          fi
        else
          echo "${srchivedbpath}/${srctablename}/busi_month=$busi_month/sys_rs_id=$sysrs not exists!"
          #exit 1
        fi
      done
  fi
fi
