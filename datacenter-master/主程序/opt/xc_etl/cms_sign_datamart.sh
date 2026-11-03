#!/bin/bash
#echo "执行存储过程"


end_date=`date +%Y%m%d -d " -0 days"`


export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini



result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     update ctl_srcdwn_batch set LAST_BUS_DATE_INT=BUS_DATE_INT,BUS_DATE_INT=${end_date}, DM_CREATED_TIME=sysdate;
     commit;

EXIT;
EOF
 )


