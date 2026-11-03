#!/bin/bash

# chcek the number of input parameters
if [ $# -ne 2 ];then
    echo "Usage:$0 check the number of input parameters <beg_date><end_date>"
    exit -1
fi

beg_date=$1
end_date=$2

LANG="en_US.UTF-8"
export LANG

beg_date=`date +%Y%m%d -d "${beg_date}"`
end_date=`date +%Y%m%d -d "${end_date}"`


echo "xq-job-return: {\"currentProcess.beg_date\":\""$beg_date""\","\"currentProcess.end_date\":\""$end_date""\"}""
