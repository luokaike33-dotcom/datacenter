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

srcorausername=$1
srcorapassword=$(get_config "${2}") || exit 1
srcoradbname=$3
srcoraurl=$4
tgrurl=${5}
tgrusername=${6}
tgrpassword=$(get_config "${7}") || exit 1
dataxPath=${8}
pubfilepath=${9}
beg_date=${10}
end_date=${11}
loadUrl="\"10.64.96.132:8030"\","\"10.64.96.133:8030"\"
selectedDatabase=data_mart
partition_mode=${12}
tablename=${13}
jsonfilename=${tablename}.json

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

echo "srcorausername          : [ ${srcorausername} ]"
# echo "srcorapassword          : [ ${srcorapassword} ]"
echo "srcoradbname            : [ ${srcoradbname} ]"
echo "srcoraurl               : [ ${srcoraurl} ]"
echo "tgrurl                  : [ ${tgrurl} ]"
echo "tgrusername             : [ ${tgrusername} ]"
# echo "tgrpassword             : [ ${tgrpassword} ]"
echo "dataxPath               : [ ${dataxPath} ]"
echo "pubfilepath             : [ ${pubfilepath} ]"
echo "beg_date                : [ ${beg_date} ]"
echo "end_date                : [ ${end_date} ]"
echo "tablename               : [ ${tablename} ]"
echo "jsonfilename            : [ ${jsonfilename} ]"

#if [ "${tgrdbtype}" == "starrocks" ]; then
echo "loadUrl                 : [ ${loadUrl} ]"
echo "selectedDatabase        : [ ${selectedDatabase} ]"
#fi

export HADOOP_USER_NAME=etl_ty

exec_sql=""
if [ "${partition_mode}" == "0" ];then
  python ${dataxPath}/datax.py -p"-Dsrcorausername=${srcorausername} -Dsrcorapassword=${srcorapassword} -Dsrcoradbname=${srcoradbname} -Dsrcoraurl=${srcoraurl} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dbeg_date=${beg_date} -Dend_date=${end_date} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase}" ${pubfilepath}/${jsonfilename}
  if [ $? -ne 0 ] ; then
	echo "exec ${jsonfilename} error,exit"
	exit 1
  fi
elif  [ "${partition_mode}" == "1" ];then
# 按日分区
  for n in `gen_date ${beg_date} ${end_date}`
  do
      echo "tradingday:"$n
      python ${dataxPath}/datax.py -p"-Dsrcorausername=${srcorausername} -Dsrcorapassword=${srcorapassword} -Dsrcoradbname=${srcoradbname} -Dsrcoraurl=${srcoraurl} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dbeg_date=${beg_date} -Dend_date=${end_date} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -Dp_dt=$n" ${pubfilepath}/${jsonfilename}
      if [ $? -ne 0 ] ; then
        echo "exec $n ${jsonfilename} error,exit"
        exit 1
      fi
  done
else
  echo "${srchivedbpath}/${tablename} not exists!"
fi
