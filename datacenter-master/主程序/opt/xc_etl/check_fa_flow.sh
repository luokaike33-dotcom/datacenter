#!/bin/bash
#echo "执行存储过程"

export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
export NLS_LANG='SIMPLIFIED CHINESE_CHINA.AL32UTF8'
source /opt/xc_etl/config.ini

cnt=`sqlplus -S $o32username/$o32password@$o32url <<EOF
set heading off
@/opt/xc_etl/check_fa_flow.sql
quit;
EOF`

if (( $cnt > 0 ))
then 
    exit 0 
else
    exit 1
fi
