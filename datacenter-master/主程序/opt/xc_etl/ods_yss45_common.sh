#!/bin/bash
# set -x
#----------------------------------------------------------------------------------------
# 说明                        : ODS层通用执行脚本(应用于ODS_datax工作流建设子节点时)
# 执行方式1  跑日期区间sql    ：sh ${pubfilepath}/shell/common_ods.sh ${srcorausername} ${srcorapassword} ${srcoradbname} ${srcoraurl} ${tgrhdfsurl} ${haveKerberos} ${kbsfilepath} ${kbsprincipal} ${tgrhivedbpath} ${tgrhivedbname} ${dataxPath} ${pubfilepath} ${beg_date} ${end_date} '1' 'fa45_vf_voucherdetail'
# 执行方式2  跑无日期传入sql  ：sh ${pubfilepath}/shell/common_ods.sh ${srcorausername} ${srcorapassword} ${srcoradbname} ${srcoraurl} ${tgrhdfsurl} ${haveKerberos} ${kbsfilepath} ${kbsprincipal} ${tgrhivedbpath} ${tgrhivedbname} ${dataxPath} ${pubfilepath} ${beg_date} ${end_date} '0' 'fa45_vb_port_baseinfo'
#----------------------------------------------------------------------------------------
# json中使用的参数
# 参数1：  srcorausername          : oracle登录用户名                     如:yss45
# 参数2：  srcorapassword          : oracle登录密码                       如:yss45
# 参数3：  srcoradbname            : oracle查询用户名                     如:yss45
# 参数4：  srcoraurl               : oracle库地址 (ip:端口/实例名)        如:192.168.0.243/orcl
# 参数5：  tgrhdfsurl              : hive库地址(ip:端口)                  如:192.168.0.105:8020
# 参数6：  haveKerberos            : 是否开启kbs认证                      如:yss45
#                                  ：'true'                               启用kbs认证
#                                  : 'false'                              不启用kbs认证
# 参数7：  kbsfilepath  : kbs文件路径                          如:/data/dolphinscheduler/home/dolphinscheduler/resources/fa/conf/krb5/xunce.keytab
# 参数8：  kbsprincipal       : kbs用户                              如:hive@XUNCE.COM
# 参数9：  tgrhivedbpath           : hive库udfs路径                       如:/user/hive/warehouse/appraise_ods.db
# 参数10： tgrhivedbname           : hive库用户名                         如:appraise_ods
#-----------------------------------------------------------------------------------------
# shell中使用的参数
# 参数11： dataxPath               : data服务器路径                       如:/data/datax/bin
# 参数12： pubfilepath             : 文件路径(资源中心)                   如:fa/yssgz45/ods_datax/cdh
# 参数13： beg_date                : beg_date                             如:20220101
# 参数14： end_date                : end_date                             如:20220331
# 参数15： partition_mode          : 分区模式                             如:0
#                                  ：'0'                                  不分区
#                                  : '1'                                  按日期分区
# 参数16： tablename               : 目标表名                             如:fa45_vb_port_baseinfo
#----------------------------------------------------------------------------------------
#读取配置文件
source /opt/xc_etl/config.ini
srcorausername=$yss45username
srcorapassword=yss45password
srcoradbname=$yss45dbname
srcoraurl=$yss45url
tgrhdfsurl=$hiveurl
haveKerberos=$1
kbsfilepath=$2
kbsprincipal=$3
tgrhivedbpath=$4
tgrhivedbname=${5}
dataxPath=${6}
pubfilepath=${7}
beg_date=${8}
end_date=${9}
beg_date=`date +%Y%m%d -d "${beg_date}"`
beg_date=`date +%Y%m%d -d "${beg_date} -14 days"`
end_date=`date +%Y%m%d -d "${end_date}"`
end_date=`date +%Y%m%d -d "${end_date} -0 days"`

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

echo "srcorausername         : [ ${srcorausername} ]"
# echo "srcorapassword         : [ ${srcorapassword} ]"
echo "srcoradbname           : [ ${srcoradbname} ]"
echo "srcoraurl              : [ ${srcoraurl} ]"
echo "tgrhdfsurl             : [ ${tgrhdfsurl} ]"
echo "haveKerberos           : [ ${haveKerberos} ]"
echo "kbsfilepath            : [ ${kbsfilepath} ]"
echo "kbsprincipal           : [ ${kbsprincipal} ]"
echo "tgrhivedbpath          : [ ${tgrhivedbpath} ]"
echo "tgrhivedbname          : [ ${tgrhivedbname} ]"
echo "dataxPath              : [ ${dataxPath} ]"
echo "pubfilepath            : [ ${pubfilepath} ]"
echo "beg_date               : [ ${beg_date} ]"
echo "end_date               : [ ${end_date} ]"

#kbs认证,有时连接超时，重试5次后报错退出
st_int=0
if [ "${haveKerberos}" == "true" ];then
  while [ ${st_int} -lt 5 ]
  do
     kinit -kt ${kbsfilepath} ${kbsprincipal}
     if [ $? -ne 0 ];then
       echo "Kinit Error,After sleep 5 seconds, re-execute. ${st_int}"
       sleep 5
       let st_int++
       continue
     fi
     st_int=5
     echo -e "\n\n"
     echo '#-------------------------------------------------------'
     echo "${kbsprincipal} user KBS authentication successful  "
     echo '#-------------------------------------------------------'
     echo -e "\n\n"
  done
fi

export HADOOP_USER_NAME=etl_ty

echo "xq-job-return: {\"currentProcess.srcorausername\":\""$srcorausername""\","\"currentProcess.srcorapassword\":\""$srcorapassword""\","\"currentProcess.srcoradbname\":\""$srcoradbname""\","\"currentProcess.srcoraurl\":\""$srcoraurl""\","\"currentProcess.tgrhdfsurl\":\""$tgrhdfsurl""\","\"currentProcess.haveKerberos\":\""$haveKerberos""\","\"currentProcess.kbsfilepath\":\""$kbsfilepath""\","\"currentProcess.kbsprincipal\":\""$kbsprincipal""\","\"currentProcess.tgrhivedbpath\":\""$tgrhivedbpath""\","\"currentProcess.tgrhivedbname\":\""$tgrhivedbname""\","\"currentProcess.dataxPath\":\""$dataxPath""\","\"currentProcess.pubfilepath\":\""$pubfilepath""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\"}""
