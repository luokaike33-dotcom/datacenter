sh dwd_all_table.sh "/opt/xc_etl/dwd/wind/" "" "" "ty_ods" "ty_dwd" "20230806" "20230811" "1" "false" "tables_dwd_incr.txt"

sh dwd_all_table.sh "/opt/xc_etl/dwd/wind/" "" "" "ty_ods" "ty_dwd" "20230806" "20230811" "0" "false" "tables_dwd_full.txt"

sh dwd_all.sh "/opt/xc_etl/dwd/wind/" "" "" "ty_ods" "ty_dwd" "20230806" "20230811" "0" "false" "var_fund_info"

sh dwd_all.sh "/opt/xc_etl/dwd/wind/" "" "" "ty_ods" "ty_dwd" "20230806" "20230811" "1" "false" "var_idx_elem_wght"

