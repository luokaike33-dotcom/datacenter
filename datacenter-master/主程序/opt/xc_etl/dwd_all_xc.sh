#!/bin/bash

#----------------------------------------------------------------------------------------
# 说明                        : L0层通用执行脚本(应用于L0工作流建设子节点时)
# 执行方式1  跑日期区间sql    ：sh ${pubfilepath}/L0_SH/fin_prd_vou_min.sh ${pubfilepath} ${kbshiveuser} ${kbsfilepath} ${tgrodsdbname} ${tgrdwddbname} ${beg_date} ${end_date} '1' ${is_kbs} 'fin_prd_vou_min'
# 执行方式2  跑无日期传入sql  ：sh ${pubfilepath}/L0_SH/fin_acc_info.sh ${pubfilepath} ${kbshiveuser} ${kbsfilepath} ${tgrodsdbname} ${tgrdwddbname} '0' ${is_kbs} 'fin_acc_info'
#----------------------------------------------------------------------------------------
# 参数1： pubfilepath         : 文件路径(资源中心)      如:/opt/soft/home/test-01/resources/DONE_ETL/YSSGZ45
# 参数2： kbshiveuser         : hive认证用户            如：hive
# 参数3： kbsfilepath         : kbs文件路径             如：/opt/soft/kbs/xunce.keytab
#----------------------------------------------------------------------------------------
# hql中使用的参数
# 参数4： tgrodsdbname        : hql中的ods用户          如：xc_ods_202103
# 参数5： tgrdwddbname        : hql中的dwd用户          如：xc_dwd_202103
# 参数6： beg_date            : 开始时间                如：sysdate - 1  or add_months(sysdate -1,-1)
# 参数7： end_date            : 结束时间                如：sysdate - 1
# 参数8： is_increment        : 是否增量                如：判断是否是跑时间区间的sql脚本(beg_date,end_date),还是跑无日期的sql脚本
#                             ：'1'                     如：跑某段时间,并自动分区写入
#                             : '0'                     如：跑无时间参数传入的脚本
# 参数9： is_kbs              : 是否kerberos认证标识
#                             : 'true'                  如：开启kerberos认证
#                             : 'false'                 如：未开启kerberos认证
# 参数10：tablename           : 目标表名                如：'pty_prd_base_info'
#----------------------------------------------------------------------------------------

pubfilepath=$1
kbshiveuser=$2
kbsfilepath=$3
tgrodsdbname=$4
tgrdwddbname=$5
beg_date=$6
end_date=$7
is_increment=$8
is_kbs=$9
tablename=${10}
sqlfilename=${tablename}.hql
current_date=${end_date}

#程序开始
#判断传参个数
echo $#
if [[ $# != 10 ]];then
   echo "Incorrect number of arguments passed, error exit"
   exit 1
fi


#判断如果is_increment为空(代表使用的是执行方式2)，则把'0'赋值给is_increment，否则则是变量本身
is_increment=`echo ${is_increment:-${beg_date}}`
#判断如果is_increment为空(代表使用的是执行方式2)，则把'end_date'赋值给is_kbs，否则则是变量本身
is_kbs=`echo ${is_kbs:-${end_date}}`

#判断如果is_increment='0'(代表使用的是执行方式2),则置空beg_date end_date，使其在下面不打印
if [ "${is_increment}" == "0" ];then
   unset beg_date
   unset end_date
else
#判断传参日期是否正确(代表使用的是执行方式1)
   beg_date=`date '+%Y%m%d' -d "${beg_date}"`
   if [ $? -ne 0 ];then
      echo "${beg_date} error,exit"
      exit 1
   fi
   end_date=`date '+%Y%m%d' -d "${end_date}"`
   if [ $? -ne 0 ];then
      echo "${end_date} error,exit"
      exit 1
   fi
fi

beg_month=${beg_date:0:6}
end_month=${end_date:0:6}

echo -e "\n\n"
echo '#-------------------------------------------------------'
echo "pubfilepath       : [ ${pubfilepath} ]"
echo "kbshiveuser       : [ ${kbshiveuser} ]"
echo "kbsfilepath       : [ ${kbsfilepath} ]"
echo "tgrodsdbname      : [ ${tgrodsdbname} ]"
echo "tgrdwddbname      : [ ${tgrdwddbname} ]"
echo "beg_date          : [ ${beg_date} ]"
echo "end_date          : [ ${end_date} ]"
echo "is_increment      : [ ${is_increment} ]"
echo "tab_name          : [ ${tablename} ]"
echo "sqlfilename       : [ ${sqlfilename} ]"
echo "is_kbs            : [ ${is_kbs} ]"
echo "beg_month         : [ ${beg_month} ]"
echo "end_month         : [ ${end_month} ]"
echo "current_date      : [ ${current_date}]"
echo '#-------------------------------------------------------'
echo -e "\n\n"

#kbs认证,有时连接超时，重试5次后报错退出
st_int=0
if [ "${is_kbs}" == "true" ];then
  while [ ${st_int} -lt 5 ]
  do
    kinit -kt ${kbsfilepath} ${kbshiveuser}
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
    echo "${kbshiveuser} user KBS authentication successful  "
    echo '#-------------------------------------------------------'
    echo -e "\n\n"
  done
fi

#执行hsql脚本
#export HADOOP_CLASSPATH=`hadoop classpath`
export HADOOP_USER_NAME=etl_ty

if [ "${is_increment}" == "1" ];then
  hive -hiveconf spark.app.name=${tablename} -i /opt/xc_etl/yarn.conf -hivevar ods_db=${tgrodsdbname} -hivevar dwd_db=${tgrdwddbname} -hivevar beg_date=${beg_date} -hivevar end_date=${end_date} -hivevar beg_month=${beg_month} -hivevar end_month=${end_month} -hivevar current_date=${current_date} -f ${pubfilepath}/${sqlfilename}
  if [ $? -ne 0 ];then
    echo "迅策执行 ${sqlfilename} ${beg_date} 至 ${end_date} 异常错误,error,exit"
    exit 1
  fi
    hive -hiveconf spark.app.name=${tablename} -i /opt/xc_etl/yarn.conf -hivevar dwd_db=${tgrdwddbname} -hivevar current_date=${current_date} -hivevar tablename=${tablename} -f /opt/xc_etl/dwd_mark.hql
    if [ $? -ne 0 ];then
      echo "迅策执行 ${tablename} 表标志位异常错误,error,exit"
      exit 1
    fi 
#      sh /opt/xc_etl/run_shell_impala/run_impala_sql.sh ty_dwd.${tablename}
 #     if [ $? -ne 0 ];then
  #      echo "迅策执行 ${tablename} run_impala异常错误,error,exit"
   #     exit 1
    #  fi
   echo "迅策科技全域资管数据一体化平台${tablename}执行成功！"
elif [ "${is_increment}" == "0" ];then
  hive -hiveconf spark.app.name=${tablename} -i /opt/xc_etl/yarn.conf -hivevar ods_db=${tgrodsdbname} -hivevar dwd_db=${tgrdwddbname} -hivevar current_date=${current_date} -f ${pubfilepath}/${sqlfilename}
  if [ $? -ne 0 ];then
    echo "迅策执行 ${sqlfilename}  异常错误,error,exit"
    exit 1
  fi
   hive -hiveconf spark.app.name=${tablename} -i /opt/xc_etl/yarn.conf -hivevar dwd_db=${tgrdwddbname} -hivevar current_date=${current_date} -hivevar tablename=${tablename} -f /opt/xc_etl/dwd_mark.hql
   if [ $? -ne 0 ];then
      echo "迅策执行 ${tablename} 表标志位异常错误,error,exit"
      exit 1
   fi
    # sh /opt/xc_etl/run_shell_impala/run_impala_sql.sh ty_dwd.${tablename}
    # if [ $? -ne 0 ];then
     #  echo "迅策执行 ${tablename} run_impala异常错误,error,exit"
      # exit 1
     #fi
   echo "迅策科技全域资管数据一体化平台${tablename}执行成功！"
else
  echo "The is_increment ${is_increment} passed an error. Please try again"
  exit 1
fi


