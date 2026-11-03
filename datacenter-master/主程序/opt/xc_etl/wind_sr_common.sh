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
# 参数5：  kerberosPrincipal         : kbs用户                                  如TDH:hive@XUNCE.COM,,prdtdhnode03@TDH
#                                                                             如CDH:hive@XUNCE.COM
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
#读取配置文件
source /opt/xc_etl/config.ini

srchivedbpath=$1
srchdfsurl=$hiveurl
haveKerberos=$2
kerberosKeytabFilePath=$3
kerberosPrincipal=$4
kerberosConfFilePath=$5
hadoopConfig=$6
srcdbtype=$7
tgrdbtype=$8
tgrurl=$xcurl
tgrusername=$xcusername
tgrpassword=xcpassword
srcjdbcurl=$hivejdbc
srcusername=$hiveusername
srcpassword=hivepassword
srcdbname=${9}
dataxPath=${10}
pubfilepath=${11}
sysrsid=${12}
beg_date=${13}
end_date=${14}
partition_mode=${22}
tablename=${23}
jsonfilename=${tablename}.json

if [[ $# != 23 ]];then
   echo "Incorrect number of arguments passed, error exit"
   exit 1
fi

# starrocks个性化参数 selectedDatabase:数据库名;loadUrl:FE
selectedDatabase=""
loadUrl=""
if [ "${tgrdbtype}" == "starrocks" ]; then
  urls=(${tgrurl//,,/ })
  tgrurl=${urls[0]}
  selectedDatabase=${urls[1]}
  loadUrl=${urls[2]}
fi

tdhPrincipal=""
if [ "${haveKerberos}" == "true" -a "${srcdbtype}" == "tdh" ]; then
  tdhPrincipal=(${kerberosPrincipal//,,/ })
  kerberosPrincipal=${tdhPrincipal[0]}
  tdhPrincipal=${tdhPrincipal[1]}
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


gen_month()
{
#如果参数2为空，取前一天；
if [ "${beg_date}" = "" ]; then
 datebeg=`date -d -1day +%Y%m%d`
else
 datebeg=${beg_date}
fi
#如果参数3为空，取当天；
if [ "${end_date}" = "" ]; then
 dateend=`date +"%Y%m"`
else
 dateend=${end_date}
fi
while [[ "$datebeg" -le "$dateend" ]] ;
do
   stat_date_month=`date -d "$datebeg" +%Y%m`
   echo $stat_date_month
   datebeg=$(date -d "$datebeg +1months" +%Y%m%d)
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
echo "jsonfilename            : [ ${jsonfilename} ]"

if [ "${tgrdbtype}" == "starrocks" ]; then
  echo "loadUrl                 : [ ${loadUrl} ]"
  echo "selectedDatabase        : [ ${selectedDatabase} ]"
fi

if [ "${haveKerberos}" == "true" -a "${srcdbtype}" == "tdh" ]; then
  echo "tdhPrincipal            : [ ${tdhPrincipal} ]"
fi

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
       if [ ${st_int} -eq 4 ];then
         echo "Kinit Error,exit"
         exit 1
       else
         echo "Kinit Error,After sleep 5 seconds, re-execute. ${st_int}"
         sleep 5
         let st_int++
         continue
       fi
     fi
     st_int=5
     echo -e "\n\n"
     echo '#-------------------------------------------------------'
     echo "${kerberosPrincipal} user KBS authentication successful  "
     echo '#-------------------------------------------------------'
     echo -e "\n\n"
  done
fi

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
    exec_sql="insert overwrite table ${srcdbname}.${tablename}_text select * from ${srcdbname}.${tablename} where sys_rs_id in ('${array}') and p_dt >= ${beg_date} and p_dt <= ${end_date} and busi_month >= ${beg_date:0:6} and busi_month <= ${end_date:0:6}"
  fi
  if [ "${haveKerberos}" == "true" -a "${tdhPrincipal}" != "" ];then
        beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname};principal=hive/${tdhPrincipal}" -e "${exec_sql}"
  else
        beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "${exec_sql}"
  fi
  if [ $? -eq 0 ] ; then
     rows=''
     if [ "${haveKerberos}" == "true" -a "${tdhPrincipal}" != ""  ];then
        rows=`beeline --showHeader=false --nullemptystring=false --outputformat=csv --silent=flase -u "jdbc:hive2://${srcjdbcurl}/${srcdbname};principal=hive/${tdhPrincipal}" -e "select count(1) from ${srcdbname}.${tablename}_text"`
     else
        rows=`beeline --showHeader=false --nullemptystring=false --outputformat=csv --silent=flase -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "select count(1) from ${srcdbname}.${tablename}_text"`
     fi
     rows=${rows#*"\""}
     rows=${rows%*"\""}
     if [ ${rows} -gt 0 ] ; then
       array="${sysrsid//,/','}"
       python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath} -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dbeg_date=${beg_date} -Dend_date=${end_date} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}' -Dsys_rs_id=\"${array}\"" ${pubfilepath}/${jsonfilename}
       if [ $? -ne 0 ] ; then
         echo "exec ${jsonfilename} error,exit"
         exit 1
       fi
       if [ "${haveKerberos}" == "true" -a "${tdhPrincipal}" != ""  ];then
             beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname};principal=hive/${tdhPrincipal}" -e "truncate table ${srcdbname}.${tablename}_text;"
       else
             beeline -u "jdbc:hive2://${srcjdbcurl}/${srcdbname}" -n ${srcusername} -p ${srcpassword} -e "truncate table ${srcdbname}.${tablename}_text;"
       fi
     else
       echo "${srchivedbpath}/${tablename}_text have no data!"
     fi
   else
     echo "exec ${exec_sql} error,exit"
     exit 1
  fi
else
#CDH分支
  #无分区
  if [ "${partition_mode}" == "0" ];then
    hadoop fs -test -d ${srchivedbpath}/${tablename}
    if [ $? -eq 0 ] ; then
      python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath}  -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dbeg_date=${beg_date} -Dend_date=${end_date} -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
      if [ $? -ne 0 ] ; then
        echo "exec ${jsonfilename} error,exit"
        exit 1
      fi
    else
      echo "${srchivedbpath}/${tablename} not exists!"
    fi

  #日期分区
  elif  [ "${partition_mode}" == "1" ];then
    for n in `gen_date ${beg_date} ${end_date}`
    do
      hadoop fs -test -d ${srchivedbpath}/${tablename}/p_dt=$n
      if [ $? -eq 0 ] ; then
        python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath}  -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dp_dt=$n -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
        if [ $? -ne 0 ] ; then
          echo "exec ${jsonfilename} error,exit"
          exit 1
        fi
      else
        echo "${srchivedbpath}/${tablename}/p_dt=$n not exists!"
      fi
    done

  #系统来源分区
  elif  [ "${partition_mode}" == "2" ];then
    array=(${sysrsid//,/ })
    for sysrs in ${array[@]}
    do
      hadoop fs -test -d ${srchivedbpath}/${tablename}/sys_rs_id=$sysrs
      if [ $? -eq 0 ] ; then
        python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath}  -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dsys_rs_id=$sysrs -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
        if [ $? -ne 0 ] ; then
          echo "exec ${jsonfilename} error,exit"
          exit 1
        fi
      else
        echo "${srchivedbpath}/${tablename}/sys_rs_id=$sysrs not exists!"
      fi
    done

  #日期分区+系统来源分区
  elif  [ "${partition_mode}" == "3" ];then
    array=(${sysrsid//,/ })
    for n in `gen_date ${beg_date} ${end_date}`
    do
      for sysrs in ${array[@]}
      do
        hadoop fs -test -d ${srchivedbpath}/${tablename}/p_dt=$n/sys_rs_id=$sysrs
        if [ $? -eq 0 ] ; then
          echo "tradingday:"$n
          python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath}  -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dp_dt=$n -Dsys_rs_id=$sysrs -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${jsonfilename}
          if [ $? -ne 0 ] ; then
            echo "exec ${jsonfilename} error,exit"
            exit 1
          fi
        else
          echo "${srchivedbpath}/${tablename}/p_dt=$n/sys_rs_id=$sysrs not exists!"
        fi
      done
    done


    elif  [ "${partition_mode}" == "4" ];then
      array=(${sysrsid//,/ })
      for n in `gen_month ${beg_date} ${end_date}`
      do
        for sysrs in ${array[@]}
        do
          hadoop fs -test -d ${srchivedbpath}/${tablename}/busi_month=$n/sys_rs_id=$sysrs
          if [ $? -eq 0 ] ; then
            echo "tradingday:"$n
            python ${dataxPath}/datax.py -p"-Dsrchivedbpath=${srchivedbpath} -Dsrchdfsurl=${srchdfsurl} -DhaveKerberos=${haveKerberos} -DkerberosKeytabFilePath=${kerberosKeytabFilePath} -DkerberosPrincipal=${kerberosPrincipal} -DkerberosConfFilePath=${kerberosConfFilePath}  -Dtgrurl=${tgrurl} -Dtgrusername=${tgrusername} -Dtgrpassword=${tgrpassword} -Dbusi_month=$n -Dsys_rs_id=$sysrs -DloadUrl='${loadUrl}' -DselectedDatabase=${selectedDatabase} -DhadoopConfig='${hadoopConfig}'" ${pubfilepath}/${srcdbtype}/${tgrdbtype}/${jsonfilename}
            if [ $? -ne 0 ] ; then
              echo "exec ${jsonfilename} error,exit"
              exit 1
            fi
              else
                echo "${srchivedbpath}/${tablename}/busi_month=$n/sys_rs_id=$sysrs not exists!"
          fi
        done
      done
  fi
fi


export HADOOP_USER_NAME=etl_ty

echo "xq-job-return: {\"currentProcess.srchivedbpath\":\""$srchivedbpath""\","\"currentProcess.srchdfsurl\":\""$srchdfsurl""\","\"currentProcess.haveKerberos\":\""$haveKerberos""\","\"currentProcess.kerberosKeytabFilePath\":\""$kerberosKeytabFilePath""\","\"currentProcess.kerberosPrincipal\":\""$kerberosPrincipal""\","\"currentProcess.kerberosConfFilePath\":\""$kerberosConfFilePath""\","\"currentProcess.hadoopConfig\":\""$hadoopConfig""\","\"currentProcess.srcdbtype\":\""$srcdbtype""\","\"currentProcess.tgrdbtype\":\""$tgrdbtype""\","\"currentProcess.tgrurl\":\""$tgrurl""\","\"currentProcess.tgrusername\":\""$tgrusername""\","\"currentProcess.tgrpassword\":\""$tgrpassword""\","\"currentProcess.srcjdbcurl\":\""$srcjdbcurl""\","\"currentProcess.srcusername\":\""$srcusername""\","\"currentProcess.srcpassword\":\""$srcpassword""\","\"currentProcess.srcdbname\":\""$srcdbname""\","\"currentProcess.dataxPath\":\""$dataxPath""\","\"currentProcess.pubfilepath\":\""$pubfilepath""\","\"currentProcess.sysrsid\":\""$sysrsid""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\"}""
