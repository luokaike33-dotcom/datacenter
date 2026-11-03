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
b=0
c=0
d=0
e=0
f=0
g=0
h=0
i=0
j=0

while getopts ":a:b:c:d:e:f:g:h:i:j:" opt
do
  case $opt in
    a)
      bizDate=$OPTARG;;
    b)
      b=$OPTARG;;
    c)
      c=$OPTARG;;
	d)
      d=$OPTARG;;
    e)
      e=$OPTARG;;
	f)
      f=$OPTARG;;
    g)
      g=$OPTARG;;
    h)
      h=$OPTARG;;
    i)
      i=$OPTARG;;
	j)
      j=$OPTARG;;

	 \?)
       echo "Invilid option : -$OPTARG"	 ;;
  esac
done

echo "bizDate="$bizDate
echo "b="$b
echo "c="$c
echo "d="$d
echo "e="$e
echo "f="$f
echo "g="$g
echo "h="$h
echo "i="$i
echo "j="$j


#源系统
currentdir=$( cd "$( dirname "$0" )" && pwd )
updir=${currentdir%/*}

# cdh source $updir/config.properties

source /opt/xc_etl/config.ini
conn_str_ctl="${jqasdb_xyusername}/${jqasdb_xypassword}@${jqasdb_xyurl}"
# set environment variable of oracle
#export ORACLE_HOME=/home/software/instantclient_11_2
#export TNS_ADMIN=$ORACLE_HOME/network/admin
export NLS_LANG="AMERICAN_AMERICA.UTF8"
#export LD_LIBRARY_PATH=$ORACLE_HOME/lib
#export PATH=$ORACLE_HOME/bin:$PATH

##变量1：b bizdate_s 开始日期为bizdate+b天 bizDate往后增加b个自然日(b可为负数)，且格式为yyyy-mm-dd 用于反洗钱参数 startdate
bizdate_s=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(to_date(sk_date,'yyyy-mm-dd')+${b},'yyyy-mm-dd' ) as bizdate_s FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_s=`echo  ${bizdate_s} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_s=${bizdate_s}"
##变量2：c bizdate_e 结束日期为bizdate+c天 bizDate往后增加c个自然日(c可为负数)，且格式为yyyy-mm-dd 用于反洗钱参数 enddate
bizdate_e=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(to_date(sk_date,'yyyy-mm-dd')+${c},'yyyy-mm-dd' ) as bizdate_e FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_e=`echo  ${bizdate_e} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_e=${bizdate_e}"
##变量3：d startdate_hg bizDate回滚d个工作日 ,如回滚4个工作日,格式为 yyyymmdd；常用于设置开始日期 startdate
startdate_hg=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT sk_date FROM icontrol.comm_cldr_custom t WHERE t.workday_no = (SELECT workday_no - ${d} AS workday_no  FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}') AND t.workday_flag = '1';
exit
!`

startdate_hg=`echo  ${startdate_hg} | awk 'gsub(/^ *| *$/,"")'`
echo "startdate_hg=${startdate_hg}"
##变量4：e enddate_ew bizDate往后增加e个工作日,如增加2个工作日,格式为 yyyymmdd；常用于设置结束日期 enddate
enddate_ew=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT sk_date FROM icontrol.comm_cldr_custom t WHERE t.workday_no = (SELECT workday_no + ${e} AS workday_no  FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}') AND t.workday_flag = '1';
exit
!`

enddate_ew=`echo  ${enddate_ew} | awk 'gsub(/^ *| *$/,"")'`
echo "enddate_ew=${enddate_ew}"
##变量5：startdate_var 遇非工作日则start_date为非工作日第一天,格式为 yyyymmdd；常用于设置开始日期 startdate
startdate_var=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_number(to_char(to_date(last_wkdate,'yyyymmdd')+1,'yyyymmdd'))as startdate_var FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

startdate_var=`echo  ${startdate_var} | awk 'gsub(/^ *| *$/,"")'`
echo "startdate_var=${startdate_var}"
##变量6：f bizdate_sn 开始日期为bizdate+sn天 bizDate往后增加f个自然日(f可为负数)，且格式为yyyymmdd 常用于设置开始日期 startdate
bizdate_sn=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(to_date(sk_date,'yyyy-mm-dd')+${f},'yyyymmdd' ) as bizdate_sn FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_sn=`echo  ${bizdate_sn} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_sn=${bizdate_sn}"

##变量7：g bizdate_en 结束日期为bizdate+g天 bizDate往后增加g个自然日(g可为负数)，且格式为yyyymmdd 常用于设置结束日期 enddate
bizdate_en=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(to_date(sk_date,'yyyy-mm-dd')+${g},'yyyymmdd' ) as bizdate_en FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_en=`echo  ${bizdate_en} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_en=${bizdate_en}"

##变量8：h bizdate_sy 开始日期为bizdate后h个月的第一天(h可为负数)，且格式为yyyymmdd 常用于设置开始日期 startdate
bizdate_sy=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(add_months(trunc(to_date(sk_date,'yyyy-mm-dd'),'mm'),${h}),'yyyymmdd' ) as bizdate_sy FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_sy=`echo  ${bizdate_sy} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_sy=${bizdate_sy}"

##变量9：i bizdate_ey 结束日期为bizdate后i个月的第一天(i可为负数)，且格式为yyyymmdd 常用于设置结束日期 enddate
bizdate_ey=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_char(last_day(add_months(trunc(to_date(sk_date,'yyyy-mm-dd'),'mm'),${i})),'yyyymmdd' ) as bizdate_ey FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

bizdate_ey=`echo  ${bizdate_ey} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_ey=${bizdate_ey}"


##变量10：enddate_var 结束日期为bizdate下一个工作日的前一自然日,格式为 yyyymmdd；如遇周五则取结束日期为周日。常用于设置结束日期 enddate
enddate_var=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT to_number(to_char(to_date(next_wkdate,'yyyymmdd')-1,'yyyymmdd'))as enddate_var FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}';
exit
!`

enddate_var=`echo  ${enddate_var} | awk 'gsub(/^ *| *$/,"")'`
echo "enddate_var=${enddate_var}"

##变量11：j bizdate_eg 结束日期为bizdate后i个月的最后一个工作日，且格式为yyyymmdd 常用于设置结束日期 enddate
bizdate_eg=`sqlplus -S ${conn_str_ctl} << !
set heading off
set feedback off
set pagesize 0
set linesize 200
set verify off
set echo off
SELECT mth_last_wkdate as bizdate_eg FROM icontrol.comm_cldr_custom t WHERE sk_date = (SELECT to_char(add_months(trunc(to_date(sk_date,'yyyy-mm-dd'),'mm'),${j}),'yyyymmdd') FROM icontrol.comm_cldr_custom t WHERE sk_date = '${bizDate}');
exit
!`

bizdate_eg=`echo  ${bizdate_eg} | awk 'gsub(/^ *| *$/,"")'`
echo "bizdate_eg=${bizdate_eg}"
##echo $bizdate_eg


echo "xq-job-return: {\"currentProcess.bizdate_s\":\""$bizdate_s""\","\"currentProcess.bizdate_e\":\""$bizdate_e""\","\"currentProcess.startdate_hg\":\""$startdate_hg""\","\"currentProcess.enddate_ew\":\""$enddate_ew""\","\"currentProcess.startdate_var\":\""$startdate_var""\","\"currentProcess.bizdate_sn\":\""$bizdate_sn""\","\"currentProcess.bizdate_en\":\""$bizdate_en""\","\"currentProcess.bizdate_sy\":\""$bizdate_sy""\","\"currentProcess.bizdate_ey\":\""$bizdate_ey""\","\"currentProcess.enddate_var\":\""$enddate_var""\","\"currentProcess.bizdate_eg\":\""$bizdate_eg""\"}""













