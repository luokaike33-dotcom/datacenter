#!/bin/bash
##用于根据biz_date设置全局变量
# chcek the number of input parameters
#调用脚本
#sh set_var_all.sh -a 20201024  -b 0 -c 7
#sh set_var_all.sh -a 20201024  -d 4 -e 0
#sh set_var_all.sh -a 20201024  -f 1 -g 1

####################################################################################################
##参数说明
##a 为bizDate 业务日期，必填
##变量1：b bizdate_s 开始日期为bizdate+b天 bizDate往后增加b个自然日(b可为负数)，且格式为yyyy-mm-dd 用于反洗钱参数 startdate
##变量2：c bizdate_e 结束日期为bizdate+c天 bizdate_s bizDate往后增加c个自然日(c可为负数)，且格式为yyyy-mm-dd 用于反洗钱参数 enddate
##变量3：d startdate_hg bizDate回滚d个工作日 ,如回滚4个工作日,格式为 yyyymmdd；常用于设置开始日期 startdate
##变量4：e enddate_ew bizDate往后增加e个工作日,如增加2个工作日,格式为 yyyymmdd；常用于设置结束日期 enddate
##变量5：startdate_var 遇非工作日则start_date为非工作日第一天,格式为 yyyymmdd；常用于设置开始日期 startdate
##变量6：f bizdate_sn 开始日期为bizdate+f天 bizDate往后增加f个自然日(f可为负数)，且格式为yyyymmdd 常用于设置开始日期 startdate
##变量7：g bizdate_en 结束日期为bizdate+e天 bizDate往后增加e个自然日(e可为负数)，且格式为yyyymmdd 常用于设置结束日期 enddate
##变量8：h bizdate_sy 开始日期为bizdate后h个月的月第一天(h可为负数)，且格式为yyyymmdd 常用于设置月度变化的开始日期 startdate
##变量9：i bizdate_ey 结束日期为bizdate后i个月的月最后一天(i可为负数)，且格式为yyyymmdd，常用于设置月度变化的截止日期 enddate
##变量10:enddate_var 结束日期为bizdate下一个工作日的前一自然日,格式为 yyyymmdd；如遇周五则取结束日期为周日。常用于设置结束日期 enddate
##变量11：j bizdate_eg 结束日期为bizdate后i个月的最后一个工作日，且格式为yyyymmdd 常用于设置结束日期 enddate
####################################################################################################

a=""
n=0
beg_date=""
end_date=""
echo original parameters=[$@]

#-o或--options选项后面是可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，
#其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面是可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项后接选项解析错误时提示的脚本名字
ARGS=`getopt -a -o A:B:E:n: -l a:,beg:,end:,n:,help -n $0 -- "$@" `
if [ $? != 0 ]; then
    echo "please input param ..."
    exit 1
fi

echo ARGS=[$ARGS]
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
echo formatted parameters=[$@]

while true
do
    case "$1" in
        -A|--a) 
            bizDate=$2
            shift;;
        -B|--beg)
            beg_date=$2
            shift;;
        -E|--end)
            end_date=$2
            shift;;
        -n)
            n=$2
            shift;;
        --)
            shift
            break
            ;;
        *)  
            echo *
            echo "input param error!"
            exit 1
            ;;
    esac
shift
done


if [ -z "$bizDate" ]; then 
bizDate=`date '+%Y%m%d'`
fi


if [ -z "$end_date" ]; then 
end_date=$bizDate
fi


beg_date=`date +%Y%m%d -d "${end_date} -${n} days"`
end_date=`date +%Y%m%d -d "${end_date} -0 days"`

echo "bizDate="$bizDate
echo "beg_date="$beg_date
echo "end_date="$end_date
echo "n="$n


echo "xq-job-return: {\"currentProcess.bizDate\":\""$bizDate""\","\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\"}""