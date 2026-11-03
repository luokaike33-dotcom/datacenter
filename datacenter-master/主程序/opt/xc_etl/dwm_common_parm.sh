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

#读取配置文件,公共参数
source /opt/xc_etl/config.ini
pubfilepath=$1
kbshiveuser=$2
kbsfilepath=$3
tgrodsdbname=$4
tgrdwddbname=$5
beg_date=$6
end_date=$7
haveKerberos=$8
srcdbname_ora=jgdata
dataxPath=/opt/datax/bin


beg_date=`date +%Y%m%d -d "${beg_date}"`
beg_date=`date +%Y%m%d -d "${beg_date} -14 days"`

##ora2hive
srcorausername_jg=$jgusername
srcorapassword_jg=jgpassword
srcoradbname_jg=$jgdbname
srcoraurl_jg=$jgurl
tgrhdfsurl=$hiveurl
tgrhivedbpath_dwm=/user/hive/warehouse/ty_dwm.db
tgrhivedbname_dwm=ty_dwm
pubfilepath_R0=/opt/xc_etl/dwm/R0-Ora2Hive/

##hive2ora
srchivedbpath_dwm=/user/hive/warehouse/ty_dwm.db
srchdfsurl=$hiveurl
srcjdbcurl_hive=$hivejdbc
srcusername_hive=$hiveusername
srcpassword_hive=hivepassword
srcdbtype_cdh=cdh
tgrdbtype_ora=oracle
tgrurl_jg=$jgurl
tgrusername_jg=$jgusername
tgrpassword_jg=jgpassword
pubfilepath_R3=/opt/xc_etl/dwm/R3-Hive2Ora/
pubfilepath_R0_2=/opt/xc_etl/dwm/R0-Hive2Ora/


end_date=`date +%Y%m%d -d "${end_date}"`


export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini


result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select lst_cald_date INTO :result FROM trd_cald_dtl where cald_id=1 and cald_date='${end_date}';

EXIT;
EOF
 )
date1=$(echo $result | sed 's/,/\n/g')


result2=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select lst_cald_date INTO :result FROM trd_cald_dtl where cald_id=1 and cald_date='${date1}';

EXIT;
EOF
 )
date2=$(echo $result2 | sed 's/,/\n/g')


result3=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select lst_cald_date INTO :result FROM trd_cald_dtl where cald_id=1 and cald_date='${date2}';

EXIT;
EOF
 )
date3=$(echo $result3 | sed 's/,/\n/g')

export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini

result4=$(sqlplus -S $jgusername/$jgpassword@$jgurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select pd_strt_date INTO :result FROM idr_pboc_pd_info where pd_id='${date3}';

EXIT;
EOF
 )
date4=$(echo $result4 | sed 's/,/\n/g')


result5=$(sqlplus -S $jgusername/$jgpassword@$jgurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select to_char(last_day(add_months(to_date('${end_date}','YYYYMMDD') ,-1) ) ,'YYYYMMDD')  INTO :result from dual ;

EXIT;
EOF
 )
date5=$(echo $result5 | sed 's/,/\n/g')

echo $result5



result6=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select next_cald_date INTO :result FROM trd_cald_dtl where cald_id=1 and cald_date='${end_date}';

EXIT;
EOF
 )
date6=$(echo $result6 | sed 's/,/\n/g')

##上周第一个交易日
result7=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

    select MIN(CALD_DATE) INTO :result
    from TRD_CALD_DTL
    where CALD_ID = '1' 
    AND IS_TRD_DT ='1'
     AND CALD_DATE between  to_char(trunc(to_date('${end_date}','YYYYMMDD'),'iw') -7,'yyyymmdd')
    and to_char(trunc(to_date('${end_date}','YYYYMMDD'),'iw') -1,'yyyymmdd');

EXIT;
EOF
 )
date7=$(echo $result7 | sed 's/,/\n/g')

##上周最后一个交易日
result8=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

    select MAX(CALD_DATE) INTO :result
    from TRD_CALD_DTL
    where CALD_ID = '1' 
    AND IS_TRD_DT ='1'
     AND CALD_DATE between  to_char(trunc(to_date('${end_date}','YYYYMMDD'),'iw') -7,'yyyymmdd')
     and to_char(trunc(to_date('${end_date}','YYYYMMDD'),'iw') -1,'yyyymmdd');

EXIT;
EOF
 )
date8=$(echo $result8 | sed 's/,/\n/g')

##去年年末
result9=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select  substr(to_char(add_months(to_date('${end_date}','YYYYMMDD'),-12),'YYYYMMDD' ),1,4)||'1231'  INTO :result  from dual;

EXIT;
EOF
 )
date9=$(echo $result9 | sed 's/,/\n/g')

 ##今年年初
result10=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

      select  substr(to_char(to_date('${end_date}','YYYYMMDD'),'YYYYMMDD' ),1,4)||'0101'   INTO :result  from dual;

EXIT;
EOF
 )
date10=$(echo $result10 | sed 's/,/\n/g')


##今年年末
result11=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     select  substr(to_char(to_date('${end_date}','YYYYMMDD'),'YYYYMMDD' ),1,4)||'1231'   INTO :result  from dual;

EXIT;
EOF
 )
date11=$(echo $result11 | sed 's/,/\n/g')

##每半年末
result12=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

    select 
      CASE WHEN TO_CHAR(to_date('${end_date}','YYYYMMDD'),'Q') IN ('1','2') 
           THEN substr(to_char(add_months(to_date('${end_date}','YYYYMMDD'),-12),'YYYYMMDD' ),1,4)||'1231'
           ELSE substr('${end_date}',1,4)||'0630' END
           INTO :result
    FROM dual;

EXIT;
EOF
 )
date12=$(echo $result12 | sed 's/,/\n/g')


beg_date=`date +%Y%m%d -d "${end_date} -14 days"`

end_date=$end_date

beg_date1=$date1

end_date1=$date1

beg_date2=$date2

end_date2=$date2

beg_date3=$date3

end_date3=$date3

beg_dateX=$date4

end_dateX=$date3

beg_dateM=`date +%Y%m%d -d "${beg_date} -30 days"`

end_dateM=`date +%Y%m%d -d "${end_date} -1 days"`

beg_dateEM=$date5

end_dateEM=$date5

beg_dateND=$date6

end_dateND=$date6

beg_dateW=$date7

end_dateW=$date8

beg_dateY=$date9

end_dateY=$date9

beg_dateTY=$date10

end_dateTY=$date11

beg_dateHY=$date12

end_dateHY=$date12




#tablename=${10}
#sqlfilename=${tablename}.hql

#程序开始
#判断传参个数
#if [[ $# != 10 && $# != 8 ]];then
  # echo "Incorrect number of arguments passed, error exit"
 #  exit 1
#fi


##判断如果is_increment为空(代表使用的是执行方式2)，则把'0'赋值给is_increment，否则则是变量本身
#is_increment=`echo ${is_increment:-${beg_date}}`
##判断如果is_increment为空(代表使用的是执行方式2)，则把'end_date'赋值给is_kbs，否则则是变量本身
#is_kbs=`echo ${is_kbs:-${end_date}}`
#
##判断如果is_increment='0'(代表使用的是执行方式2),则置空beg_date end_date，使其在下面不打印
#if [ "${is_increment}" == "0" ];then
#   unset beg_date
#   unset end_date
#else
##判断传参日期是否正确(代表使用的是执行方式1)
#   beg_date=`date '+%Y%m%d' -d "${beg_date}"`
#   if [ $? -ne 0 ];then
#      echo "${beg_date} error,exit"
#      exit 1
#   fi
#   end_date=`date '+%Y%m%d' -d "${end_date}"`
#   if [ $? -ne 0 ];then
#      echo "${end_date} error,exit"
#      exit 1
#   fi
#fi

echo -e "\n\n"
echo '#-------------------------------------------------------'
echo "pubfilepath       : [ ${pubfilepath} ]"
echo "kbshiveuser       : [ ${kbshiveuser} ]"
echo "kbsfilepath       : [ ${kbsfilepath} ]"
echo "tgrodsdbname      : [ ${tgrodsdbname} ]"
echo "tgrdwddbname      : [ ${tgrdwddbname} ]"
echo "beg_date          : [ ${beg_date} ]"
echo "end_date          : [ ${end_date} ]"
#echo "is_increment      : [ ${is_increment} ]"
#echo "tab_name          : [ ${tablename} ]"
echo "haveKerberos      : [ ${haveKerberos} ]"
echo "beg_date1         : [ ${beg_date1} ]"
echo "end_date1         : [ ${end_date1} ]"
echo "beg_date2         : [ ${beg_date2} ]"
echo "end_date2         : [ ${end_date2} ]"
echo "beg_date3         : [ ${beg_date3} ]"
echo "end_date3         : [ ${end_date3} ]"
echo "beg_dateW         : [ ${beg_dateW} ]"
echo "end_dateW         : [ ${end_dateW} ]"
echo "beg_dateX         : [ ${beg_dateX} ]"
echo "end_dateX         : [ ${end_dateX} ]"
echo "beg_dateM         : [ ${beg_dateM} ]"
echo "end_dateM         : [ ${end_dateM} ]"
echo "beg_dateEM        : [ ${beg_dateEM} ]"
echo "end_dateEM        : [ ${end_dateEM} ]"
echo "beg_dateND        : [ ${beg_dateND} ]"
echo "end_dateND        : [ ${end_dateND} ]"
echo "beg_dateY         : [ ${beg_dateY} ]"
echo "end_dateY         : [ ${end_dateY} ]"
echo "beg_dateTY         : [ ${beg_dateTY} ]"
echo "end_dateTY         : [ ${end_dateTY} ]"
echo "beg_dateHY         : [ ${beg_dateHY} ]"
echo "end_dateHY         : [ ${end_dateHY} ]"
echo "tgrhivedbpath_dwm : [ ${tgrhivedbpath_dwm} ]"
echo "pubfilepath_R0    : [ ${pubfilepath_R0} ]"
echo "srchivedbpath_dwm : [ ${srchivedbpath_dwm} ]"
echo "pubfilepath_R3    : [ ${pubfilepath_R3} ]"
echo "pubfilepath_R0_2    : [ ${pubfilepath_R0_2} ]"
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

#if [ "${is_increment}" == "1" ];then
#        hive -hivevar ods_db=${tgrodsdbname} -hivevar dwd_db=${tgrdwddbname} -hivevar beg_date=${beg_date} -hivevar end_date=${end_date} -f ${pubfilepath}/cdh/${sqlfilename}
#        if [ $? -ne 0 ];then
#            echo "exec ${sqlfilename} ${beg_date} and ${end_date} error,exit"
#            exit 1
#        fi 
#        echo "${sqlfilename} ${beg_date} and ${end_date} runs successfully "
#elif [ "${is_increment}" == "0" ];then
#        hive -hivevar ods_db=${tgrodsdbname} -hivevar dwd_db=${tgrdwddbname} -f ${pubfilepath}/cdh/${sqlfilename}
#        if [ $? -ne 0 ];then
#            echo "exec ${sqlfilename} error,exit"
#            exit 1
#        fi 
#        echo "${sqlfilename} runs successfully "
#else
#     echo "The is_increment ${is_increment} passed an error. Please try again"
#     exit 1
#fi



#echo "xq-job-return: {\"currentProcess.pubfilepath\":\""$pubfilepath""\","\"currentProcess.kbshiveuser\":\""$kbshiveuser""\","\"currentProcess.kbsfilepath\":\""$kbsfilepath""\","\"currentProcess.tgrodsdbname\":\""$tgrodsdbname""\","\"currentProcess.tgrdwddbname\":\""$tgrdwddbname""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\","\"currentProcess.is_kbs\":\""$is_kbs""\","\"currentProcess.beg_date1\":\""$beg_date1""\","\"currentProcess.end_date1\":\""$end_date1""\","\"currentProcess.beg_date2\":\""$beg_date2""\","\"currentProcess.end_date2\":\""$end_date2""\","\"currentProcess.beg_date3\":\""$beg_date3""\","\"currentProcess.end_date3\":\""$end_date3""\","\"currentProcess.beg_dateX\":\""$beg_dateX""\","\"currentProcess.end_dateX\":\""$end_dateX""\","\"currentProcess.beg_dateM\":\""$beg_dateM""\","\"currentProcess.end_dateM\":\""$end_dateM""\","\"currentProcess.srcdbname_ora\":\""$srcdbname_ora""\","\"currentProcess.dataxPath\":\""$dataxPath""\","\"currentProcess.srcorausername_jg\":\""$srcorausername_jg""\","\"currentProcess.srcorapassword_jg\":\""$srcorapassword_jg""\","\"currentProcess.srcoradbname_jg\":\""$srcoradbname_jg""\","\"currentProcess.srcoraurl_jg\":\""$srcoraurl_jg""\","\"currentProcess.tgrhdfsurl\":\""$tgrhdfsurl""\","\"currentProcess.tgrhivedbpath_dwm\":\""$tgrhivedbpath_dwm""\","\"currentProcess.tgrhivedbname_dwm\":\""$tgrhivedbname_dwm""\","\"currentProcess.pubfilepath_R0\":\""$pubfilepath_R0""\","\"currentProcess.srchivedbpath_dwm\":\""$srchivedbpath_dwm""\","\"currentProcess.srchdfsurl\":\""$srchdfsurl""\","\"currentProcess.srcjdbcurl_hive\":\""$srcjdbcurl_hive""\","\"currentProcess.srcusername_hive\":\""$srcusername_hive""\","\"currentProcess.srcpassword_hive\":\""$srcpassword_hive""\","\"currentProcess.srcdbtype_cdh\":\""$srcdbtype_cdh""\","\"currentProcess.tgrdbtype_ora\":\""$tgrdbtype_ora""\","\"currentProcess.tgrurl_jg\":\""$tgrurl_jg""\","\"currentProcess.tgrusername_jg\":\""$tgrusername_jg""\","\"currentProcess.tgrpassword_jg\":\""$tgrpassword_jg""\","\"currentProcess.pubfilepath_R3\":\""$pubfilepath_R3""\","\"currentProcess.haveKerberos\":\""$haveKerberos""\","\"currentProcess.pubfilepath_R0_2\":\""$pubfilepath_R0_2""\","\"currentProcess.beg_dateEM\":\""$beg_dateEM""\","\"currentProcess.end_dateEM\":\""$end_dateEM""\","\"currentProcess.beg_dateND\":\""$beg_dateND""\","\"currentProcess.end_dateND\":\""$end_dateND""\","\"currentProcess.beg_dateY\":\""$beg_dateY""\","\"currentProcess.end_dateEM\":\""$end_dateY""\","\"currentProcess.beg_dateW\":\""$beg_dateW""\","\"currentProcess.end_dateW\":\""$end_dateW""\"}""

echo "xq-job-return: {\"currentProcess.pubfilepath\":\""$pubfilepath""\","\"currentProcess.kbshiveuser\":\""$kbshiveuser""\","\"currentProcess.kbsfilepath\":\""$kbsfilepath""\","\"currentProcess.tgrodsdbname\":\""$tgrodsdbname""\","\"currentProcess.tgrdwddbname\":\""$tgrdwddbname""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\","\"currentProcess.is_kbs\":\""$is_kbs""\","\"currentProcess.beg_date1\":\""$beg_date1""\","\"currentProcess.end_date1\":\""$end_date1""\","\"currentProcess.beg_date2\":\""$beg_date2""\","\"currentProcess.end_date2\":\""$end_date2""\","\"currentProcess.beg_date3\":\""$beg_date3""\","\"currentProcess.end_date3\":\""$end_date3""\","\"currentProcess.beg_dateX\":\""$beg_dateX""\","\"currentProcess.end_dateX\":\""$end_dateX""\","\"currentProcess.beg_dateM\":\""$beg_dateM""\","\"currentProcess.end_dateM\":\""$end_dateM""\","\"currentProcess.srcdbname_ora\":\""$srcdbname_ora""\","\"currentProcess.dataxPath\":\""$dataxPath""\","\"currentProcess.srcorausername_jg\":\""$srcorausername_jg""\","\"currentProcess.srcorapassword_jg\":\""$srcorapassword_jg""\","\"currentProcess.srcoradbname_jg\":\""$srcoradbname_jg""\","\"currentProcess.srcoraurl_jg\":\""$srcoraurl_jg""\","\"currentProcess.tgrhdfsurl\":\""$tgrhdfsurl""\","\"currentProcess.tgrhivedbpath_dwm\":\""$tgrhivedbpath_dwm""\","\"currentProcess.tgrhivedbname_dwm\":\""$tgrhivedbname_dwm""\","\"currentProcess.pubfilepath_R0\":\""$pubfilepath_R0""\","\"currentProcess.srchivedbpath_dwm\":\""$srchivedbpath_dwm""\","\"currentProcess.srchdfsurl\":\""$srchdfsurl""\","\"currentProcess.srcjdbcurl_hive\":\""$srcjdbcurl_hive""\","\"currentProcess.srcusername_hive\":\""$srcusername_hive""\","\"currentProcess.srcpassword_hive\":\""$srcpassword_hive""\","\"currentProcess.srcdbtype_cdh\":\""$srcdbtype_cdh""\","\"currentProcess.tgrdbtype_ora\":\""$tgrdbtype_ora""\","\"currentProcess.tgrurl_jg\":\""$tgrurl_jg""\","\"currentProcess.tgrusername_jg\":\""$tgrusername_jg""\","\"currentProcess.tgrpassword_jg\":\""$tgrpassword_jg""\","\"currentProcess.pubfilepath_R3\":\""$pubfilepath_R3""\","\"currentProcess.haveKerberos\":\""$haveKerberos""\","\"currentProcess.pubfilepath_R0_2\":\""$pubfilepath_R0_2""\","\"currentProcess.beg_dateEM\":\""$beg_dateEM""\","\"currentProcess.end_dateEM\":\""$end_dateEM""\","\"currentProcess.beg_dateND\":\""$beg_dateND""\","\"currentProcess.end_dateND\":\""$end_dateND""\","\"currentProcess.beg_dateY\":\""$beg_dateY""\","\"currentProcess.end_dateY\":\""$end_dateY""\","\"currentProcess.beg_dateTY\":\""$beg_dateTY""\","\"currentProcess.end_dateTY\":\""$end_dateTY""\","\"currentProcess.beg_dateW\":\""$beg_dateW""\","\"currentProcess.end_dateW\":\""$end_dateW""\","\"currentProcess.beg_dateHY\":\""$beg_dateHY""\","\"currentProcess.end_dateHY\":\""$end_dateHY""\"}""
