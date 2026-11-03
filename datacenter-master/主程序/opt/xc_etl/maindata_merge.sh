#!/bin/bash
# set -x
#----------------------------------------------------------------------------------------
# 说明                        : ODS层通用执行脚本(应用于ODS_datax工作流建设子节点时)
# 执行方式1  跑日期区间sql    ：sh ${pubfilepath}/shell/common_ods.sh ${srcorausername} ${srcorapassword} ${srcoradbname} ${srcoraurl} ${tgrhdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${tgrhivedbpath} ${tgrhivedbname} ${dataxPath} ${pubfilepath} ${beg_date} ${end_date} '1' 'fa45_vf_voucherdetail'
# 执行方式2  跑无日期传入sql  ：sh ${pubfilepath}/shell/common_ods.sh ${srcorausername} ${srcorapassword} ${srcoradbname} ${srcoraurl} ${tgrhdfsurl} ${haveKerberos} ${kerberosKeytabFilePath} ${kerberosPrincipal} ${tgrhivedbpath} ${tgrhivedbname} ${dataxPath} ${pubfilepath} ${beg_date} ${end_date} '0' 'fa45_vb_port_baseinfo'
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
# 参数7：  kerberosKeytabFilePath  : kbs文件路径                          如:/data/dolphinscheduler/home/dolphinscheduler/resources/fa/conf/krb5/xunce.keytab
# 参数8：  kerberosPrincipal       : kbs用户                              如:hive@XUNCE.COM
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

srcdbtype=$1
srcdbip=$2
srcdbport=$3
srcdbusername=$4
srcdbpw=$5
srcdbtbname=$6
srcdbdatabase=$7
haveKerberos=$8
kerberosKeytabFilePath=$9
kerberosPrincipal=${10}
pubfilepath=/opt/xc_etl/ods/yss25_json

echo "srcdbtype                : [ ${srcdbtype} ]"
echo "srcdbip                  : [ ${srcdbip} ]"
echo "srcdbport                : [ ${srcdbport} ]"
echo "srcdbusername            : [ ${srcdbusername} ]"
echo "srcdbpw                  : [ ${srcdbpw} ]"
echo "srcdbtbname              : [ ${srcdbtbname} ]"
echo "srcdbdatabase            : [ ${srcdbdatabase} ]"
echo "haveKerberos             : [ ${haveKerberos} ]"
echo "kerberosKeytabFilePath   : [ ${kerberosKeytabFilePath} ]"
echo "kerberosPrincipal        : [ ${kerberosPrincipal} ]"

# kbs认证,有时连接超时，重试5次后报错退出

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

echo "---------End------------"

python3 /opt/xc_etl/ods/yss25_json/maindata_merge.py ${srcdbtype} ${srcdbip} ${srcdbport} ${srcdbusername} ${srcdbpw} ${srcdbtbname} ${srcdbdatabase} ${pubfilepath}
