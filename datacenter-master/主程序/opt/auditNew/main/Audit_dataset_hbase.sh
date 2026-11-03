#! /bin/bash
# chcek the number of input parameters

if [ $# -ne 3 ];then
    echo "Usage:$0 <ds_srcsys><srcsys><data_set>"
    exit -1
fi

ds_srcsys=$1
srcsys=$2   
data_set=$3

python /etl/auditNew/main/Audit.py --pi_ds_srcsys=$ds_srcsys --pi_srcsys=$srcsys --pi_data_set=$data_set
