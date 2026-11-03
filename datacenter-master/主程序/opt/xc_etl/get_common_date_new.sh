#!/bin/bash

# 参数介绍
# 待处理日期  bizDate
# 日期类型： n-自然日  w-工作日(暂不支持)
# 日期间隔： y-年 q-季度 m-月 d-日
# 日期转换方向： 负数代表往前推，正数为往后推，0代表当前间隔下的日期


# 检查传入的参数个数，当前版本为4个
if [ $# -ne 4 ]; then
    echo "请传入4个参数,如 'bizDate','n','d','0' "
    exit 1
fi

bizDate=$1
if ! [[ "$bizDate" =~ ^[0-9]*$ ]]; then
        echo "错误：参数 '$bizDate' 不是纯数字"
        exit 1
fi

bizDate=($([ -z ${bizDate} ]  &&  echo $(date +"%Y%m%d") || echo ${bizDate} ))
echo "bizDate: ${bizDate}"



# 获取当前日期
current_date=$(date -d ${bizDate} +%Y%m%d)
current_year=$(date -d ${current_date} +%Y)
current_month=$(date -d ${current_date} +%m)
current_day=$(date -d ${current_date} +%d)


echo "current_date:"$current_date",current_year:"$current_year",current_month:"$current_month",current_day:"$current_day

dateType=$2
dateInter=$3
dateAdjNum=$4

intervationKeys=''
ABSdateAdjNum=''
datePosition=''


# 各参数检查
case "$dateType" in
    "n")
        echo "按自然日"
        ;;
    "w")
        echo "按工作日"
        ;;
    *)
        exit 1
        ;;
esac

case "$dateInter" in
    "y")
        echo "按年"
        intervationKeys='year'
        ;;
    "q")
        echo "按季度"
        intervationKeys='quarter'
        ;;
    "m")
        echo "按月"
        intervationKeys='month'
        ;;
    "d")
        echo "按日"
        intervationKeys='day'
        ;;
    *)
        echo "暂不支持除y、q、m、d的类型"
        exit 1
        ;;
esac

# 判断是否整数
if ! [[ $dateAdjNum =~ ^[+-]?[0-9]+$ ]]; then
        echo "错误：参数 '$dateAdjNum' 不是整数"
        exit 1
fi

# 取绝对值
if [ $dateAdjNum -lt 0 ]; then
    ABSdateAdjNum=$(( -dateAdjNum ))
    datePosition=' ago '
else
    ABSdateAdjNum=$dateAdjNum
    datePosition=''
fi

beg_date=''
end_date=''

# 转为10进制数字
current_month=$((10#${current_month}))
# 按自然日
if [ 'n' == $dateType ]; then 
    # 季度
    if [ 'quarter' = $intervationKeys ]; then 
        current_quarter=$(( (current_month-1)/3 + 1 ))
        current_quarter_month_num=$(( (current_quarter-1)*3 + 1 ))
        current_quarter_month_str=$(printf "%02d" $current_quarter_month_num)
        current_quarters_start=$(date -d "${current_year}${current_quarter_month_str}01" +%Y%m01)
        quarter_num=$(( $ABSdateAdjNum*3 ))
        target_quarter_month=$(date -d " $quarter_num month $datePosition ${current_quarters_start}" +%Y%m)

        # 计算目标季度第一天
        beg_date=$(date -d "${target_quarter_month}01" +%Y%m01)
        # 计算目标季度最后一天
        end_date_month=$(date -d "3 month $beg_date " +%Y%m01)
        end_date=$(date -d  "1 days ago $end_date_month " +%Y%m%d)

    # 按年year 月month 日day
    elif [ 'quarter' != $intervationKeys ]; then
        target_day_str=$(date -d " $ABSdateAdjNum $intervationKeys $datePosition ${bizDate}" +%Y%m%d)
        target_year=$(date -d ${target_day_str} +%Y)
        target_month=$(date -d ${target_day_str} +%m)
        target_day=$(date -d ${target_day_str} +%d)
        if [ 'year' = $intervationKeys ]; then
            # 计算年第一天，最后一天
            beg_date=$(date -d "${target_year}0101" +%Y%m01)
            end_date=$(date -d "${target_year}1231" +%Y1231)
        elif [ 'month' = $intervationKeys ]; then
            # 计算月第一天，最后一天
            beg_date=$(date -d "${target_year}${target_month}01" +%Y%m01)
            end_date_month=$(date -d "1 month $beg_date " +%Y%m01)
            end_date=$(date -d  "1 days ago $end_date_month " +%Y%m%d)
        elif [ 'day' = $intervationKeys ]; then
            # 计算日第一，最后第一天
            beg_date=$(date -d "${target_year}${target_month}${target_day}" +%Y%m%d)
            end_date=$(date -d "${target_year}${target_month}${target_day}" +%Y%m%d)
        fi
    fi 
# 按工作日
elif [ 'w' == $dateType ]; then
    source /opt/xc_etl/config.ini
    conn_str_ctl="${jqasdb_xyusername}/${jqasdb_xypassword}@${jqasdb_xyurl}"
    # 按日
    if [ 'd' = $dateInter ]; then 
        beg_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
            select 	distinct to_char(sk_date ) as beg_date from icontrol.comm_cldr_custom t where workday_flag ='1' 
                and workday_no in (select workday_no + ${dateAdjNum} from icontrol.comm_cldr_custom t where sk_date = ${bizDate} );
            exit
EOF`
            
        end_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
            select 	distinct to_char(sk_date ) as end_date from icontrol.comm_cldr_custom t where workday_flag ='1' 
                and workday_no in (select workday_no + ${dateAdjNum} from icontrol.comm_cldr_custom t where sk_date = ${bizDate} );
            exit
EOF`
            
    # 按月
    elif [ 'm' = $dateInter ]; then 
        beg_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
            with base_data as (
                select distinct substr(t.sk_date,1,6) as curr_mth from icontrol.comm_cldr_custom t where substr(t.sk_date,1,6) =substr(${bizDate},1,6) 
            )
                select distinct to_char(mth_fst_wkdate ) as beg_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_mth),'yyyyMM'),${dateAdjNum}),'yyyyMM') as find_mth from base_data);
            exit
EOF`
            
        end_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
            with base_data as (
                select distinct substr(t.sk_date,1,6) as curr_mth from icontrol.comm_cldr_custom t where substr(t.sk_date,1,6) =substr(${bizDate},1,6) 
            )
                select distinct to_char(mth_last_wkdate ) as end_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_mth),'yyyyMM'),${dateAdjNum}),'yyyyMM') as find_mth from base_data);
            exit
EOF`
            
    # 按季度
    elif [ 'q' = $dateInter ]; then 
        beg_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
             with base_data as (
                select distinct substr(t.qtr_fst_wkdate,1,6) as curr_qua from icontrol.comm_cldr_custom t where t.sk_date =${bizDate}
            )
                select distinct to_char(qtr_fst_wkdate ) as beg_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_qua),'yyyyMM'),${dateAdjNum}*3),'yyyyMM') as find_qua from base_data);
            exit
EOF`
            
        end_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
             with base_data as (
                select distinct substr(t.qtr_fst_wkdate,1,6) as curr_qua from icontrol.comm_cldr_custom t where t.sk_date =${bizDate}
            )
                select distinct to_char(qtr_last_wkdate ) as end_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_qua),'yyyyMM'),${dateAdjNum}*3),'yyyyMM') as find_qua from base_data);
            exit
EOF`
            
    # 按年
    elif [ 'y' = $dateInter ]; then 
         beg_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
             with base_data as (
                select distinct substr(t.yly_fst_wkdate,1,6) as curr_year from icontrol.comm_cldr_custom t where t.sk_date =${bizDate}
            )
                select distinct to_char(yly_fst_wkdate ) as beg_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_year),'yyyyMM'),${dateAdjNum}*12),'yyyyMM') as find_year from base_data);
            exit
EOF`
            
        end_date=`sqlplus -S ${conn_str_ctl} << EOF
            set heading off
            set feedback off
            set pagesize 0
            set linesize 200
            set verify off
            set echo off
             with base_data as (
                select distinct substr(t.yly_fst_wkdate,1,6) as curr_year from icontrol.comm_cldr_custom t where t.sk_date =${bizDate}
            )
                select distinct to_char(yly_last_wkdate ) as end_date  from icontrol.comm_cldr_custom t 
                where substr(t.sk_date,1,6) in
                (select to_char(add_months(to_date(to_char(base_data.curr_year),'yyyyMM'),${dateAdjNum}*12),'yyyyMM') as find_year from base_data);
            exit
EOF`
            
    fi
fi

echo "beg_date: "$beg_date" , end_date: "$end_date
out_date1=$bizDate
out_date2=$beg_date
out_date3=$end_date
echo "out_date1: "${out_date1}" , out_date2: "${out_date2}" , out_date3: "${out_date3}

if [ '' = $beg_date ] || [ '' = $end_date ]; then
    echo "错误：未获取到完整的日期"
    exit 1
fi

# 输出至调度平台
echo "xq-job-return: {\"currentProcess.bizDate\":\""$bizDate""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\","\"currentProcess.out_date1\":\""$out_date1""\","\"currentProcess.out_date2\":\""$out_date2""\","\"currentProcess.out_date3\":\""$out_date3""\"}""
