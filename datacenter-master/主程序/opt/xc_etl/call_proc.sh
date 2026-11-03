#!/bin/bash
#echo "执行存储过程"

export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/11.2/client64/bin:$PATH
source /opt/xc_etl/config.ini

sqlplus -S $xcusername/$xcpassword@$xcurl <<EOF
set serveroutput on;
variable p_result varchar2(100);
variable p_outvalue varchar2(100);
BEGIN
  pkg_fa_pub.prc_add_partitions(:p_result, :p_outvalue);
END;
/
print :p_result;
EOF
