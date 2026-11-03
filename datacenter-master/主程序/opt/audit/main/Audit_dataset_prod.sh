#! /bin/bash
# chcek the number of input parameters
if [ $# -ne 7 ];then
    echo "Usage:$0 <startdate><enddate><batchno><srcsys><tano><data_set><bk_product>"
    exit -1
fi

startdate=$(($1))
enddate=$2
batchno=$3
srcsys=$4
tano=$5
data_set=$6
bk_product=$7

python /etl/audit/main/Audit.py --pi_startdate=$startdate --pi_enddate=$enddate --pi_batchno=$batchno --pi_srcsys=$srcsys --pi_tano=$tano  --pi_data_set=$data_set --pi_bk_product=$bk_product
