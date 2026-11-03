#!/bin/bash

repor_freq=$1
end_date=$2

#执行hsql脚本
export HADOOP_USER_NAME=etl_ty
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini

result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

    select max(CALD_DATE) INTO :result
    from (select CALD_DATE,
                row_number() over (partition by rn order by CALD_WEEK,CALD_DATE) as rn2
         From (
                  select CALD_DATE,
                         CALD_WEEK,
                         IS_TRD_DT,
                         row_number() over (partition by CALD_WEEK order by CALD_DATE) rn
                  from TRD_CALD_DTL
                  where CALD_ID = '1'
                  and CALD_DATE between  substr(${end_date},1,4)||'0101' and ${end_date}
              ) t
    where IS_TRD_DT = '1'
     )
where rn2 = '1';

EXIT;
EOF
 ) 
date1=$(echo $result | sed 's/,/\n/g')


result2=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

    select max(CALD_DATE) INTO :result
    from (select CALD_DATE,
                row_number() over (partition by rn order by CALD_WEEK,CALD_DATE) as rn2
         From (
                  select CALD_DATE,
                         CALD_WEEK,
                         IS_TRD_DT,
                         row_number() over (partition by CALD_WEEK order by CALD_DATE) rn
                  from TRD_CALD_DTL
                  where CALD_ID = '1'
                  and CALD_DATE between  substr(${end_date},1,4)||'0101' and ${end_date}
              ) t
    where IS_TRD_DT = '1'
     )
where rn2 = '2';

EXIT;
EOF
 ) 
date2=$(echo $result2 | sed 's/,/\n/g')


result3=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select case when substr(CALD_DATE, 5, 8) in (0331,0630,0930,1231) then CALD_DATE else 20991231 end as cald_date
INTO :result
from (select max(CALD_DATE) as CALD_DATE
      from TRD_CALD_DTL
      where CALD_ID = '1'
        and CALD_date between substr(${end_date}, 1, 6) || '01' and ${end_date});

  
EXIT;
EOF
 ) 
date3=$(echo $result3 | sed 's/,/\n/g')

result4=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select case when substr(CALD_DATE, 5, 8) in (0630, 1231) then CALD_DATE else 20991231 end as cald_date
INTO :result
from (select max(CALD_DATE) as CALD_DATE
      from TRD_CALD_DTL
      where CALD_ID = '1'
        and CALD_date between substr(${end_date}, 1, 6) || '01' and ${end_date});


EXIT;
EOF
 ) 
date4=$(echo $result4 | sed 's/,/\n/g')

result5=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select case when substr(CALD_DATE, 5, 8) in (1231) then CALD_DATE else 20991231 end as cald_date
INTO :result
from (select max(CALD_DATE) as CALD_DATE
      from TRD_CALD_DTL
      where CALD_ID = '1'
        and CALD_date between substr(${end_date}, 1, 6) || '01' and ${end_date});


EXIT;
EOF
 ) 
date5=$(echo $result5 | sed 's/,/\n/g')

result6=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select coalesce(max(CALD_DATE), 20991231)
INTO :result
From (select CALD_DATE,
             row_number() over (partition by substr(CALD_DATE, 1, 6) order by CALD_DATE) rn
      from data_mart.TRD_CALD_DTL
      where CALD_ID = '1'
        and IS_TRD_DT = '1'
        and CALD_DATE between substr('${end_date}', 1, 6) || '01' and '${end_date}'
     ) t
where rn = '3';


EXIT;
EOF
 )
date6=$(echo $result6 | sed 's/,/\n/g')

result7=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select coalesce(max(CALD_DATE), 20991231)
INTO :result
From (select CALD_DATE,
             row_number() over (partition by substr(CALD_DATE, 1, 6) order by CALD_DATE) rn
      from data_mart.TRD_CALD_DTL
      where CALD_ID = '1'
        and IS_TRD_DT = '1'
        and CALD_DATE between substr('${end_date}', 1, 6) || '01' and '${end_date}'
     ) t
where rn = '5';


EXIT;
EOF
 )
date7=$(echo $result7 | sed 's/,/\n/g')

result8=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select cald_date
INTO :result
  from data_mart.trd_cald_dtl
 where cald_id = '1'
   and cald_date between to_char(trunc(to_date('${end_date}', 'yyyyMMdd'), 'iw'), 'yyyyMMdd') and to_char(trunc(to_date('${end_date}', 'yyyyMMdd'), 'iw')+6, 'yyyyMMdd')
   and cald_week = '2';


EXIT;
EOF
 )
date8=$(echo $result8 | sed 's/,/\n/g')



result9=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

select coalesce(max(CALD_DATE), 20991231)
INTO :result
From (select CALD_DATE,
             row_number() over (partition by substr(CALD_DATE, 1, 6) order by CALD_DATE) rn
      from data_mart.TRD_CALD_DTL
      where CALD_ID = '1'
        and IS_TRD_DT = '1'
        and CALD_DATE between substr('${end_date}', 1, 6) || '01' and '${end_date}'
     ) t
where rn = '1';


EXIT;
EOF
 )
date9=$(echo $result9 | sed 's/,/\n/g')


echo '#-------------------------------------------------------'
echo "end_date             : [ ${end_date} ]"
echo "date-周T1            : [ ${date1} ]"
echo "date-周T2            : [ ${date2} ]"
echo "date-季报            : [ ${date3} ]"
echo "date-半年报          : [ ${date4} ]"
echo "date-年报            : [ ${date5} ]"
echo "date-月报            : [ ${date6} ]"
echo "date-月报T5          : [ ${date7} ]"
echo "date-周D2            : [ ${date8} ]"
echo "date-月报T1          : [ ${date9} ]"
echo '#-------------------------------------------------------'
echo -e "\n\n"


## 当周第一个交易日
if [ "${repor_freq}" -eq "1" ];then
  if [ "${date1}" -eq "${end_date}" ];then
    echo "当日为当周第一个交易日"
    exit 0
  else 
    echo "当日非当周第一个交易日"
    exit 1
  fi


## 当周第二个交易日
elif [ "${repor_freq}" -eq "2" ];then

  if [ "${date2}" -eq "${end_date}" ];then
    echo "当日为当周第二个交易日"
    exit 0
  else 
    echo "当日非当周第二个交易日"
    exit 1
  fi
  
## 季度
elif [ "${repor_freq}" -eq "3" ];then

  if [ "${date3}" -eq "${end_date}" ];then
    echo "本次需要报送季报"
    exit 0
  else 
    echo "本次不需要报送季报"
    exit 1
  fi

## 半年
elif [ "${repor_freq}" -eq "4" ];then

  if [ "${date4}" -eq "${end_date}" ];then
    echo "本次需要报送半年报"
    exit 0
  else
    echo "本次不需要报送半年报"
    exit 1
  fi

## 年报
elif [ "${repor_freq}" -eq "5" ];then

  if [ "${date5}" -eq "${end_date}" ];then
    echo "本次需要报送年报"
    exit 0
  else 
    echo "本次不需要报送年报"
    exit 1
  fi

## 月报
elif [ "${repor_freq}" -eq "6" ];then

  if [ "${date6}" -eq "${end_date}" ];then
    echo "本次需要报送月报"
    exit 0
  else
    echo "本次不需要报送月报"
    exit 1
  fi

## 月报-月第五个交易日
elif [ "${repor_freq}" -eq "7" ];then

  if [ "${date7}" -eq "${end_date}" ];then
    echo "当日为月第五个交易日，本次需要报送月报"
    exit 0
  else
    echo "当日非月第五个交易日，本次不需要报送月报"
    exit 1
  fi
 
## 当周第二个自然日
elif [ "${repor_freq}" -eq "8" ];then

  if [ "${date8}" -eq "${end_date}" ];then
    echo "当日为周第二个自然日"
    exit 0
  else
    echo "当日非周第二个自然日"
    exit 1
  fi
 
## 月报-月第一个交易日
elif [ "${repor_freq}" -eq "9" ];then

  if [ "${date9}" -eq "${end_date}" ];then
    echo "当日为月第一个交易日，本次需要报送月报"
    exit 0
  else
    echo "当日非月第一个交易日，本次不需要报送月报"
    exit 1
  fi
 
else
  echo "The repor_freq ${repor_freq} passed an error. Please try again"
  exit 1
fi













