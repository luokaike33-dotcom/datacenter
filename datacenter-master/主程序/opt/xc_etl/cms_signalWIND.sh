#!/bin/bash
#echo "执行存储过程"


end_date=`date +%Y%m%d -d " -1 days"`


export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini



result=$(sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

     truncate table cms_signalwind;
     insert into cms_signalwind values('wind','${end_date}','1');
     commit;

EXIT;
EOF
 )


