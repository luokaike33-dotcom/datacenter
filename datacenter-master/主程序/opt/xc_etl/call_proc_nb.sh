#!/bin/bash
#echo "执行存储过程"


export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini

end_date=$1

sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF

VARIABLE result VARCHAR2(100)
BEGIN
     select lst_cald_date INTO :result FROM trd_cald_dtl where cald_id=1 and cald_date='${end_date}';
END;
/
print :result;
EOF
