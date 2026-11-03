-------------------------------------------------------------------------
-- 模块名称：投资组合持仓数据大宽表
-------------------------------------------------------------------------
----set hive.vectorized.execution.enabled=false;
----set hive.strict.checks.type.safety=false;
----set hive.exec.dynamic.partition.mode=nonstrict;
----set hive.execution.engine=spark;
----set hive.exec.max.dynamic.partitions.pernode=10000;
----set hive.exec.max.dynamic.partitions=10000;
----set hive.exec.max.created.files=10000;
----set hive.merge.sparkfiles=true;
----set hive.optimize.sort.dynamic.partition=true;
----set hive.merge.orcfile.stripe.level=false;
----set spark.memory.fraction=0.8;
----set hive.exec.dynamic.partition=true;
----set hive.crud.dynamic.partition=true;
----set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;



alter table ${dwd_db}.mid_l2_pfl_hld
    drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id = 'O3');



insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
--普通股票持仓
SELECT T0.HLD_DT                                              AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                            AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                            AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                                       AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                                       AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                                       AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                            AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                            AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                             AS SECU_ID,         --证券编码
       T1.TRD_CODE                                            AS SECU_CODE,       --证券代码
       T1.SECU_SHT                                            AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                            AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                                           AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                                          AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                                           AS EXCH_CODE,       --交易市场代码
       T1.EXCH_NAME                                           AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                            AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                              AS POS_ID,          --多空标志
       'CNY'                                                  AS CURR_CODE,       --货币代码
       cast(T0.CURR_VOL as double)                                            AS HLD_VOL,         --持仓数量
       T0.FRZ_VOL                                             AS FRZ_VOL,         --冻结数量
       cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double)               AS HLD_COST,        --持仓成本（本币）
       cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double)                               AS UNIT_COST,       --单位成本（本币）
       cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double)               AS FULL_COST,       --全价成本（本币）
       cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                                AS NET_PRC,         --净价价格（本币）
       cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                                AS FULL_PRC,        --全价价格（本币）
       cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                AS HLD_VAL,         --持仓市值（本币）
       cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                AS FULL_VAL,        --全价市值（本币）
       0                                                      AS ACCR_INTR,       --应计利息（本币）
       cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double) / cast(T6.TTL_NAVL as double) AS COST_NAV_RAT,    --成本占净值比
       cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) / cast(T6.TTL_NAVL as double)  AS VAL_NAV_RAT,     --市值占净值比
       T0.CURR_DIVD                                           AS CURR_DIVD,       --当日红利
       T0.CURR_PLAC                                           AS CURR_PLAC,       --当日配股
       T0.CURR_BUY_VOL                                        AS CURR_BUY_VOL,    --当日买入数量
       T0.CURR_SELL_VOL                                       AS CURR_SELL_VOL,   --当日卖出数量
       T0.CURR_BUY_VOL - T0.CURR_SELL_VOL                     AS NET_BUY_VOL,     --净买入数量
       T0.CURR_BUY_VAL                                        AS CURR_BUY_VAL,    --当日买入金额（本币）
       T0.curr_sell_val                                       AS net_sell_val,    --当日卖出金额（本币）
       T0.CURR_BUY_VAL - T0.curr_sell_val                     AS NET_BUY_VAL,     --净买入金额（本币）
       T0.CURR_BUY_FEE                                        AS CURR_BUY_FEE,    --当日买入费用（本币）
       T0.CURR_SELL_FEE                                       AS CURR_SELL_FEE,   --当日卖出费用（本币）
       T0.CURR_BUY_FEE + T0.CURR_SELL_FEE                     AS TOT_FEE,         --费用合计（本币）
       NULL                                                   AS CONT_TNV_DT,     --合约成交日期
       NULL                                                   AS CONT_END_DT,     --合约到期日期
       NULL                                                   AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd')             AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_1'                                   AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                                      AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                              as p_dt,            --分区
       'O3'                                                   AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.FIN_PRD_HLD_DATA T2
                   ON T0.PRD_CODE = T2.PRD_CODE
                       AND T0.HLD_DT = T2.HLD_DT
                       AND T0.SECU_ID = T2.SECU_ID
                       AND T2.AST_STAT IN ('L1', 'L5', 'L11') --普通、网上新股、网下新股
                       AND T2.p_dt between ${beg_date} and ${end_date}
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
WHERE T0.HLD_FLAG = '1'
  AND T0.SECU_ID LIKE '%STK%'
  AND T0.p_dt between ${beg_date} and ${end_date}
;


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
--限售股票持仓
SELECT T0.HLD_DT                                  AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                           AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                           AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                           AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                 AS SECU_ID,         --证券编码
       T1.TRD_CODE                                AS SECU_CODE,       --证券代码
       T1.SECU_SHT                                AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                               AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                              AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                               AS EXCH_CODE,       --交易市场代码
       T1.EXCH_NAME                               AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                  AS POS_ID,          --多空标志
       'CNY'                                      AS CURR_CODE,       --货币代码
       cast(T0.CURR_VOL as double)                                AS HLD_VOL,         --持仓数量
       T0.FRZ_VOL                                 AS FRZ_VOL,         --冻结数量
       cast(T0.CURR_COST as double)                               AS HLD_COST,        --持仓成本（本币）
       cast(T0.CURR_COST as double) / cast(T0.CURR_VOL as double)                 AS UNIT_COST,       --单位成本（本币）
       cast(T0.CURR_COST as double)                               AS FULL_COST,       --全价成本（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                  AS NET_PRC,         --净价价格（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                  AS FULL_PRC,        --全价价格（本币）
       cast(T0.CURR_VAL as double)                                AS HLD_VAL,         --持仓市值（本币）
       cast(T0.CURR_VAL as double)                                AS FULL_VAL,        --全价市值（本币）
       0                                          AS ACCR_INTR,       --应计利息（本币）
       cast(T0.CURR_COST as double) / cast(T6.TTL_NAVL as double)                 AS COST_NAV_RAT,    --成本占净值比
       cast(T0.CURR_VAL as double) / cast(T6.TTL_NAVL as double)                  AS VAL_NAV_RAT,     --市值占净值比
       T0.CURR_DIVD                               AS CURR_DIVD,       --当日红利
       T0.CURR_PLAC                               AS CURR_PLAC,       --当日配股
       T0.CURR_BUY_VOL                            AS CURR_BUY_VOL,    --当日买入数量
       T0.CURR_SELL_VOL                           AS CURR_SELL_VOL,   --当日卖出数量
       T0.CURR_BUY_VOL - T0.CURR_SELL_VOL         AS NET_BUY_VOL,     --净买入数量
       T0.CURR_BUY_VAL                            AS CURR_BUY_VAL,    --当日买入金额（本币）
       T0.curr_sell_val                           AS net_sell_val,    --当日卖出金额（本币）
       T0.CURR_BUY_VAL - T0.curr_sell_val         AS NET_BUY_VAL,     --净买入金额（本币）
       T0.CURR_BUY_FEE                            AS CURR_BUY_FEE,    --当日买入费用（本币）
       T0.CURR_SELL_FEE                           AS CURR_SELL_FEE,   --当日卖出费用（本币）
       T0.CURR_BUY_FEE + T0.CURR_SELL_FEE         AS TOT_FEE,         --费用合计（本币）
       NULL                                       AS CONT_TNV_DT,     --合约成交日期
       NULL                                       AS CONT_END_DT,     --合约到期日期
       NULL                                       AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd') AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_2'                       AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                          AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                  as p_dt,            --分区
       'O3'                                       AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
WHERE T0.HLD_FLAG NOT IN ('1')
  AND T0.SECU_ID LIKE '%STK%'
  AND T0.p_dt between ${beg_date} and ${end_date}
;


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)

--债券持仓
SELECT T0.HLD_DT                                                              AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                                            AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                                            AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                                                       AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                                                       AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                                                       AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                                            AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                                            AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                                             AS SECU_ID,         --证券编码
       T1.TRD_CODE                                                            AS SECU_CODE,       --证券代码
       T1.SECU_SHT                                                            AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                                            AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                                                           AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                                                          AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                                                           AS EXCH_CODE,       --交易市场代码
       T1.EXCH_NAME                                                           AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                                            AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                                              AS POS_ID,          --多空标志
       'CNY'                                                                  AS CURR_CODE,       --货币代码
       cast(T0.CURR_VOL as double)                                                            AS HLD_VOL,         --持仓数量
       T0.FRZ_VOL                                                             AS FRZ_VOL,         --冻结数量
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100*cast(T0.CURR_VOL as double) END AS HLD_COST,        --持仓成本（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100 END AS UNIT_COST,       --单位成本（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * ((cast(T2.HLD_COST as double) + nvl(T2.ACCR_INTR,0)) / cast(T2.HLD_VOL as double)) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100 END AS FULL_COST,       --全价成本（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100 END AS NET_PRC,         --净价价格（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN (cast(T2.HLD_VAL as double)+ nvl(T2.ACCR_INTR,0)) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100 END AS FULL_PRC,        --全价价格（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100*cast(T0.CURR_VOL as double) END AS HLD_VAL,         --持仓市值（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * (cast(T2.HLD_VAL as double) + nvl(T2.ACCR_INTR,0)) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100*cast(T0.CURR_VOL as double) END AS FULL_VAL,        --全价市值（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T2.ACCR_INTR as double) * cast(T0.CURR_VOL as double) / cast(T2.HLD_VOL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 0 END AS ACCR_INTR,       --应计利息（本币）
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double) / cast(T6.TTL_NAVL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100*cast(T0.CURR_VOL as double)/cast(T6.TTL_NAVL as double) END AS COST_NAV_RAT,    --成本占净值比
       CASE WHEN T2.SECU_ID IS NOT NULL THEN cast(T0.CURR_VOL as double) * ((cast(T2.HLD_VAL as double) - nvl(T2.ACCR_INTR,0)) / cast(T2.HLD_VOL as double)) / cast(T6.TTL_NAVL as double) WHEN T2.SECU_ID IS NULL AND T7.SECU_ID IS NOT NULL THEN 100*cast(T0.CURR_VOL as double)/cast(T6.TTL_NAVL as double) END AS VAL_NAV_RAT,     --市值占净值比
       T0.CURR_DIVD                                                           AS CURR_DIVD,       --当日红利
       T0.CURR_PLAC                                                           AS CURR_PLAC,       --当日配股
       T0.CURR_BUY_VOL                                                        AS CURR_BUY_VOL,    --当日买入数量
       T0.CURR_SELL_VOL                                                       AS CURR_SELL_VOL,   --当日卖出数量
       T0.CURR_BUY_VOL - T0.CURR_SELL_VOL                                     AS NET_BUY_VOL,     --净买入数量
       T0.CURR_BUY_VAL                                                        AS CURR_BUY_VAL,    --当日买入金额（本币）
       T0.curr_sell_val                                                       AS net_sell_val,    --当日卖出金额（本币）
       T0.CURR_BUY_VAL - T0.curr_sell_val                                     AS NET_BUY_VAL,     --净买入金额（本币）
       T0.CURR_BUY_FEE                                                        AS CURR_BUY_FEE,    --当日买入费用（本币）
       T0.CURR_SELL_FEE                                                       AS CURR_SELL_FEE,   --当日卖出费用（本币）
       T0.CURR_BUY_FEE + T0.CURR_SELL_FEE                                     AS TOT_FEE,         --费用合计（本币）
       NULL                                                                   AS CONT_TNV_DT,     --合约成交日期
       NULL                                                                   AS CONT_END_DT,     --合约到期日期
       NULL                                                                   AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd')                             AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_3'                                                   AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                                                      AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                                              as p_dt,            --分区
       'O3'                                                                   AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.FIN_PRD_HLD_DATA T2
                   ON T0.PRD_CODE = T2.PRD_CODE
                       AND T0.HLD_DT = T2.HLD_DT
                       AND T0.SECU_ID = T2.SECU_ID
                       AND T2.p_dt between ${beg_date} and ${end_date}
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
		 LEFT JOIN (SELECT
		  DISTINCT SECU_ID,P_DT,PRD_CODE
		 FROM ${dwd_db}.evt_ofle_clea_jour_his
		 WHERE p_dt between ${beg_date} and ${end_date}
		 AND BUSI_CLAS IN ('05040101','05040201')
		 ) T7
		           ON T0.SECU_ID = T7.SECU_ID
				  AND T0.P_DT = T7.P_DT
				  AND T0.PRD_CODE = T7.PRD_CODE
WHERE T0.SECU_ID LIKE '%BOND%'
  AND T0.p_dt between ${beg_date} and ${end_date}
;


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)

--基金持仓
SELECT T0.HLD_DT                                              AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                            AS PRD_CODE,        --产品代码
       MAX(T3.PRD_NAME     )                                       AS PRD_NAME,        --产品名称
       MAX(T3.PRD_FULL_NAME)                                       AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                                       AS AST_UNIT_CODE,   --资产单元代码
       MAX(T4.AST_UNIT_NAME)                                       AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                            AS PFL_CODE,        --投组代码
       MAX(T5.PFL_NAME     )                                       AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                             AS SECU_ID,         --证券编码
       MAX(T1.TRD_CODE     )                                       AS SECU_CODE,       --证券代码
       MAX(T1.SECU_SHT     )                                       AS SECU_NAME,       --证券名称
       MAX(T1.TYP_CODE     )                                       AS TYP_CODE,        --证券类别代码（大类）
       MAX(T1.TYP_CODEI    )                                       AS TYP_CODEI,       --证券类别代码（中类）
       MAX(T1.TYP_CODEII   )                                       AS TYP_CODEII,      --证券类别代码（细分）
       MAX(T1.EXCH_CODE    )                                       AS EXCH_CODE,       --交易市场代码
       MAX(T1.EXCH_NAME    )                                       AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                            AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                              AS POS_ID,          --多空标志
       'CNY'                                                  AS CURR_CODE,       --货币代码
       SUM(cast(T0.CURR_VOL as double)     )                                       AS HLD_VOL,         --持仓数量
       SUM(T0.FRZ_VOL                              )               AS FRZ_VOL,         --冻结数量
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double))               AS HLD_COST,        --持仓成本（本币）
       SUM(cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double)                )               AS UNIT_COST,       --单位成本（本币）
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double))               AS FULL_COST,       --全价成本（本币）
       SUM(cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                 )               AS NET_PRC,         --净价价格（本币）
       SUM(cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double)                 )               AS FULL_PRC,        --全价价格（本币）
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) )               AS HLD_VAL,         --持仓市值（本币）
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) )               AS FULL_VAL,        --全价市值（本币）
       0                                                      AS ACCR_INTR,       --应计利息（本币）
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_COST as double) / cast(T2.HLD_VOL as double) / cast(T6.TTL_NAVL as double)) AS COST_NAV_RAT,    --成本占净值比
       SUM(cast(T0.CURR_VOL as double) * cast(T2.HLD_VAL as double) / cast(T2.HLD_VOL as double) / cast(T6.TTL_NAVL as double) ) AS VAL_NAV_RAT,     --市值占净值比
       SUM(T0.CURR_DIVD                                          ) AS CURR_DIVD,       --当日红利
       SUM(T0.CURR_PLAC                                          ) AS CURR_PLAC,       --当日配股
       SUM(T0.CURR_BUY_VOL                                       ) AS CURR_BUY_VOL,    --当日买入数量
       SUM(T0.CURR_SELL_VOL                                      ) AS CURR_SELL_VOL,   --当日卖出数量
       SUM(T0.CURR_BUY_VOL - T0.CURR_SELL_VOL                    ) AS NET_BUY_VOL,     --净买入数量
       SUM(T0.CURR_BUY_VAL                                       ) AS CURR_BUY_VAL,    --当日买入金额（本币）
       SUM(T0.curr_sell_val                                      ) AS net_sell_val,    --当日卖出金额（本币）
       SUM(T0.CURR_BUY_VAL - T0.curr_sell_val                    ) AS NET_BUY_VAL,     --净买入金额（本币）
       SUM(T0.CURR_BUY_FEE                                       ) AS CURR_BUY_FEE,    --当日买入费用（本币）
       SUM(T0.CURR_SELL_FEE                                      ) AS CURR_SELL_FEE,   --当日卖出费用（本币）
       SUM(T0.CURR_BUY_FEE + T0.CURR_SELL_FEE                    ) AS TOT_FEE,         --费用合计（本币）
       NULL                                                   AS CONT_TNV_DT,     --合约成交日期
       NULL                                                   AS CONT_END_DT,     --合约到期日期
       NULL                                                   AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd')             AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_4'                                   AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                                      AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                              as p_dt,            --分区
       'O3'                                                   AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.FIN_PRD_HLD_DATA T2
                   ON T0.prd_code = T2.prd_code
                       AND T0.HLD_DT = T2.HLD_DT
                       AND T0.SECU_ID = T2.SECU_ID
                       AND T2.p_dt between ${beg_date} and ${end_date}
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
WHERE T0.SECU_ID LIKE '%FUND%'
  AND T0.p_dt between ${beg_date} and ${end_date}
GROUP BY T0.HLD_DT,T0.PRD_CODE,T0.AST_UNIT_CODE,T0.PFL_CODE,T0.SECU_ID,T0.HLD_FLAG,T0.POS_ID
;


WITH pro_dpsi_info AS
         (
             SELECT DISTINCT A.PRD_CODE, A.AST_UNIT_CODE, A.PFL_CODE,a.busi_date
             FROM ${dwd_db}.PRO_DPSI_INFO A
         )


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)

--存款持仓
SELECT T1.HLD_DT                                                           AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                                         AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                                         AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                                                    AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                                                    AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                                                    AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                                         AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                                         AS PFL_NAME,        --投资组合名称
       T1.SECU_ID                                                          AS SECU_ID,         --证券编码
       T1.var_secu_id                                                         AS SECU_CODE,       --证券代码
       T1.CHI_NAME                                                         AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                                         AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                                                        AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                                                       AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                                                        AS EXCH_CODE,       --交易市场代码
       '场外市场'                                                        AS EXCH_NAME,       --交易市场名称
       '1'                                                                 AS HLD_FLAG,        --持仓标志
       'L'                                                                 AS POS_ID,          --多空标志
       'CNY'                                                               AS CURR_CODE,       --货币代码
       cast(T1.HLD_VOL as double)                                                          AS HLD_VOL,         --持仓数量
       0                                                                   AS FRZ_VOL,         --冻结数量
       cast(T1.HLD_COST as double)                                                         AS HLD_COST,        --持仓成本（本币）
       cast(T1.HLD_COST as double) / cast(T1.HLD_VOL as double)                                            AS UNIT_COST,       --单位成本（本币）
       cast(T1.HLD_COST as double) + T1.ACCR_INT                                         AS FULL_COST,       --全价成本（本币）
       cast(T1.HLD_MVAL as double)  / cast(T1.HLD_VOL as double)                            AS NET_PRC,         --净价价格（本币）
       (cast(T1.HLD_MVAL as double)+ T1.ACCR_INT) / cast(T1.HLD_VOL as double)                                            AS FULL_PRC,        --全价价格（本币）
       cast(T1.HLD_MVAL as double)                                           AS HLD_VAL,         --持仓市值（本币）
       cast(T1.HLD_MVAL as double)+ T1.ACCR_INT                                                         AS FULL_VAL,        --全价市值（本币）
       T1.ACCR_INT                                                         AS ACCR_INTR,       --应计利息（本币）
       cast(T1.HLD_COST as double) / cast(T6.TTL_NAVL as double)                                           AS COST_NAV_RAT,    --成本占净值比
       cast(T1.HLD_MVAL as double) / cast(T6.TTL_NAVL as double)                                           AS VAL_NAV_RAT,     --市值占净值比
       0                                                                   AS CURR_DIVD,       --当日红利
       0                                                                   AS CURR_PLAC,       --当日配股
       CASE
           WHEN T1.HLD_DT = T2.FIR_TNV_DT THEN cast(T1.HLD_VOL as double)
           ELSE 0 END                                                      AS CURR_BUY_VOL,    --当日买入数量
       0                                                                   AS CURR_SELL_VOL,   --当日卖出数量
       CASE
           WHEN T1.HLD_DT = T2.FIR_TNV_DT THEN cast(T1.HLD_VOL as double)
           ELSE 0 END                                                      AS NET_BUY_VOL,     --净买入数量
       CASE
           WHEN T1.HLD_DT = T2.FIR_TNV_DT THEN cast(T1.HLD_MVAL as double)
           ELSE 0 END                                                      AS CURR_BUY_VAL,    --当日买入金额（本币）
       0                                                                   AS net_sell_val,    --当日卖出金额（本币）
       CASE
           WHEN T1.HLD_DT = T2.FIR_TNV_DT THEN cast(T1.HLD_MVAL as double)
           ELSE 0 END                                                      AS NET_BUY_VAL,     --净买入金额（本币）
       0                                                                   AS CURR_BUY_FEE,    --当日买入费用（本币）
       0                                                                   AS CURR_SELL_FEE,   --当日卖出费用（本币）
       0                                                                   AS TOT_FEE,         --费用合计（本币）
       T2.FIR_TNV_DT                                                       AS CONT_TNV_DT,     --合约成交日期
       T2.END_TNV_DT                                                       AS CONT_END_DT,     --合约到期日期
       datediff(from_unixtime(unix_timestamp(cast(T2.END_TNV_DT as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T1.HLD_DT as string),'yyyyMMdd'),'yyyy-MM-dd')) AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd')                          AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_5'                                                AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                                                   AS DM_CREATED_TIME, --数据中台创建时间
       T1.HLD_DT                                                           as p_dt,            --分区
       'O3'                                                                AS SYS_RS_ID        --系统来源标识
FROM pro_dpsi_info T0
         LEFT JOIN ${dwd_db}.FIN_PRD_DPSI_HLD T1
                   ON T0.PRD_CODE = T1.PRD_CODE
         LEFT JOIN ${dwd_db}.FIN_PRD_DPSI_PRO T2
                   ON T1.PRD_CODE = T2.PRD_CODE
                       AND T1.SECU_ID = T2.SECU_ID
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T1.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
         INNER JOIN ${dwd_db}.pub_tradeday_offset_trade t7
                       ON t1.hld_dt = t7.dt
                     AND t7.dt = t7.aft_1_dt
;


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
--回购持仓
SELECT T0.HLD_DT                                                        AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                                      AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                                      AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                                                 AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                                                 AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                                                 AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                                      AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                                      AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                                       AS SECU_ID,         --证券编码
       T1.TRD_CODE                                                      AS SECU_CODE,       --证券代码
       T1.SECU_SHT                                                      AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                                      AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                                                     AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                                                    AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                                                     AS EXCH_CODE,       --交易市场代码
       T1.EXCH_NAME                                                     AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                                      AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                                        AS POS_ID,          --多空标志
       'CNY'                                                            AS CURR_CODE,       --货币代码
       CASE WHEN T0.POS_ID = 'S' THEN cast(-T0.CURR_VOL as double) ELSE cast(T0.CURR_VOL as double) END               AS HLD_VOL,         --持仓数量
       CASE WHEN T0.POS_ID = 'S' THEN -T0.FRZ_VOL  ELSE  T0.FRZ_VOL END                                                   AS FRZ_VOL,         --冻结数量
       CASE WHEN T0.POS_ID = 'S' THEN cast(-T0.CURR_COST as double) ELSE cast(T0.CURR_COST as double) END                                                   AS HLD_COST,        --持仓成本（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_COST as double) / cast(T0.CURR_VOL as double) ELSE cast(T0.CURR_COST as double) / cast(T0.CURR_VOL as double) END                                       AS UNIT_COST,       --单位成本（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_COST as double) ELSE cast(T0.CURR_COST as double) END                                                   AS FULL_COST,       --全价成本（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                                        AS NET_PRC,         --净价价格（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                                        AS FULL_PRC,        --全价价格（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_VAL as double) ELSE cast(T0.CURR_VAL as double) END                                                     AS HLD_VAL,         --持仓市值（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_VAL as double) ELSE cast(T0.CURR_VAL as double) END                                                     AS FULL_VAL,        --全价市值（本币）
       0                                                                AS ACCR_INTR,       --应计利息（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_COST as double) / cast(T6.TTL_NAVL as double) ELSE cast(T0.CURR_COST as double) / cast(T6.TTL_NAVL as double) END                                      AS COST_NAV_RAT,    --成本占净值比
       CASE WHEN T0.POS_ID = 'S' THEN -cast(T0.CURR_VAL as double) / cast(T6.TTL_NAVL as double) ELSE cast(T0.CURR_VAL as double) / cast(T6.TTL_NAVL as double) END                                      AS VAL_NAV_RAT,     --市值占净值比
       T0.CURR_DIVD                                                     AS CURR_DIVD,       --当日红利
       T0.CURR_PLAC                                                     AS CURR_PLAC,       --当日配股
       CASE WHEN T0.POS_ID = 'S' THEN -T0.CURR_BUY_VOL ELSE T0.CURR_BUY_VOL END                                                  AS CURR_BUY_VOL,    --当日买入数量
       CASE WHEN T0.POS_ID = 'S' THEN -T0.CURR_SELL_VOL ELSE T0.CURR_SELL_VOL END                                                 AS CURR_SELL_VOL,   --当日卖出数量
       CASE WHEN T0.POS_ID = 'S' THEN T0.CURR_SELL_VOL - T0.CURR_BUY_VOL ELSE T0.CURR_BUY_VOL-T0.CURR_SELL_VOL END                              AS NET_BUY_VOL,     --净买入数量
       CASE WHEN T0.POS_ID = 'S' THEN -T0.CURR_BUY_VAL ELSE T0.CURR_BUY_VAL END                                                  AS CURR_BUY_VAL,    --当日买入金额（本币）
       CASE WHEN T0.POS_ID = 'S' THEN -T0.curr_sell_val ELSE T0.curr_sell_val END                                                 AS net_sell_val,    --当日卖出金额（本币）
       CASE WHEN T0.POS_ID = 'S' THEN T0.CURR_SELL_VOL - T0.CURR_BUY_VOL  ELSE T0.CURR_BUY_VOL-T0.CURR_SELL_VOL END                              AS NET_BUY_VAL,     --净买入金额（本币）
       T0.CURR_BUY_FEE                                                  AS CURR_BUY_FEE,    --当日买入费用（本币）
       T0.CURR_SELL_FEE                                                 AS CURR_SELL_FEE,   --当日卖出费用（本币）
       T0.CURR_BUY_FEE + T0.CURR_SELL_FEE                               AS TOT_FEE,         --费用合计（本币）
       T2.TNV_DT                                                        AS CONT_TNV_DT,     --合约成交日期
       T2.BUYB_DT                                                       AS CONT_END_DT,     --合约到期日期
       datediff(from_unixtime(unix_timestamp(cast(T2.BUYB_DT as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.HLD_DT as string),'yyyyMMdd'),'yyyy-MM-dd')) AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd')                       AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_6'                                             AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                                                AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                                        as p_dt,            --分区
       'O3'                                                             AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.PRO_REPO_TNV_INFO T2
                   ON T0.PRD_CODE = T2.PRD_CODE
                       AND T0.SECU_ID = T2.SECU_ID
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
WHERE T0.SECU_ID LIKE '%REPO%'
  AND T0.p_dt between ${beg_date} and ${end_date}
;


insert
into ${dwd_db}.mid_l2_pfl_hld partition (p_dt, sys_rs_id)
(hld_dt, prd_code, prd_name, prd_full_name, ast_unit_code, ast_unit_name, pfl_code, pfl_name, secu_id, secu_code,
 secu_name, typ_code, typ_codei, typ_codeii, exch_code, exch_name, hld_flag, pos_id, curr_code, hld_vol, frz_vol,
 hld_cost, unit_cost, full_cost, net_prc, full_prc, hld_val, full_val, accr_intr, cost_nav_rat, val_nav_rat, curr_divd,
 curr_plac, curr_buy_vol, curr_sell_vol, net_buy_vol, curr_buy_val, curr_sell_val, net_buy_val, curr_buy_fee,
 curr_sell_fee, tot_fee, cont_tnv_dt, cont_end_dt, rema_maty, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
--期货持仓
SELECT T0.HLD_DT                                  AS HLD_DT,          --持仓日期
       T0.PRD_CODE                                AS PRD_CODE,        --产品代码
       T3.PRD_NAME                                AS PRD_NAME,        --产品名称
       T3.PRD_FULL_NAME                           AS PRD_FULL_NAME,   --产品全称
       T0.AST_UNIT_CODE                           AS AST_UNIT_CODE,   --资产单元代码
       T4.AST_UNIT_NAME                           AS AST_UNIT_NAME,   --资产单元名称
       T0.PFL_CODE                                AS PFL_CODE,        --投组代码
       T5.PFL_NAME                                AS PFL_NAME,        --投资组合名称
       T0.SECU_ID                                 AS SECU_ID,         --证券编码
       T1.TRD_CODE                                AS SECU_CODE,       --证券代码
       T1.SECU_SHT                                AS SECU_NAME,       --证券名称
       T1.TYP_CODE                                AS TYP_CODE,        --证券类别代码（大类）
       T1.TYP_CODEI                               AS TYP_CODEI,       --证券类别代码（中类）
       T1.TYP_CODEII                              AS TYP_CODEII,      --证券类别代码（细分）
       T1.EXCH_CODE                               AS EXCH_CODE,       --交易市场代码
       T1.EXCH_NAME                               AS EXCH_NAME,       --交易市场名称
       T0.HLD_FLAG                                AS HLD_FLAG,        --持仓标志
       T0.POS_ID                                  AS POS_ID,          --多空标志
       'CNY'                                      AS CURR_CODE,       --货币代码
       cast(T0.CURR_VOL as double)                                AS HLD_VOL,         --持仓数量
       T0.FRZ_VOL                                 AS FRZ_VOL,         --冻结数量
       cast(T0.CURR_COST as double)                               AS HLD_COST,        --持仓成本（本币）
       cast(T0.CURR_COST as double) / cast(T0.CURR_VOL as double)                 AS UNIT_COST,       --单位成本（本币）
       cast(T0.CURR_COST as double)                               AS FULL_COST,       --全价成本（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                  AS NET_PRC,         --净价价格（本币）
       cast(T0.CURR_VAL as double) / cast(T0.CURR_VOL as double)                  AS FULL_PRC,        --全价价格（本币）
       cast(T0.CURR_VAL as double)                                AS HLD_VAL,         --持仓市值（本币）
       cast(T0.CURR_VAL as double)                                AS FULL_VAL,        --全价市值（本币）
       0                                          AS ACCR_INTR,       --应计利息（本币）
       cast(T0.CURR_COST as double) / cast(T6.TTL_NAVL as double)                 AS COST_NAV_RAT,    --成本占净值比
       cast(T0.CURR_VAL as double) / cast(T6.TTL_NAVL as double)                  AS VAL_NAV_RAT,     --市值占净值比
       T0.CURR_DIVD                               AS CURR_DIVD,       --当日红利
       T0.CURR_PLAC                               AS CURR_PLAC,       --当日配股
       T0.CURR_BUY_VOL                            AS CURR_BUY_VOL,    --当日买入数量
       T0.CURR_SELL_VOL                           AS CURR_SELL_VOL,   --当日卖出数量
       T0.CURR_BUY_VOL - T0.CURR_SELL_VOL         AS NET_BUY_VOL,     --净买入数量
       T0.CURR_BUY_VAL                            AS CURR_BUY_VAL,    --当日买入金额（本币）
       T0.curr_sell_val                           AS net_sell_val,    --当日卖出金额（本币）
       T0.CURR_BUY_VAL - T0.curr_sell_val         AS NET_BUY_VAL,     --净买入金额（本币）
       T0.CURR_BUY_FEE                            AS CURR_BUY_FEE,    --当日买入费用（本币）
       T0.CURR_SELL_FEE                           AS CURR_SELL_FEE,   --当日卖出费用（本币）
       T0.CURR_BUY_FEE + T0.CURR_SELL_FEE         AS TOT_FEE,         --费用合计（本币）
       NULL                                       AS CONT_TNV_DT,     --合约成交日期
       NULL                                       AS CONT_END_DT,     --合约到期日期
       NULL                                       AS REMA_MATY,       --剩余期限
       date_format(current_timestamp, 'yyyyMMdd') AS BUSI_DATE,       --业务日期
       'mid_l2_pfl_hld_7'                       AS TASK_RS_ID,      --任务来源标识
       CURRENT_TIMESTAMP                          AS DM_CREATED_TIME, --数据中台创建时间
       T0.HLD_DT                                  as p_dt,            --分区
       'O3'                                       AS SYS_RS_ID        --系统来源标识
FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
         LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                   ON T0.SECU_ID = T1.SECU_ID
         LEFT JOIN ${dwd_db}.pty_prd_base_info T3
                   ON T0.PRD_CODE = T3.PRD_CODE
         LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T4
                   ON T0.AST_UNIT_CODE = T4.AST_UNIT_CODE
         LEFT JOIN ${dwd_db}.ACC_PFL T5
                   ON T0.PFL_CODE = T5.PFL_CODE
         LEFT JOIN ${dwd_db}.AST_ASSET_UNIT_NAV T6
                   ON T0.HLD_DT = T6.OCCU_DT
                       AND T0.AST_UNIT_CODE = T6.AST_UNIT_CODE
                       AND T6.p_dt between ${beg_date} and ${end_date}
WHERE T0.SECU_ID LIKE '%FUT%'
  AND T0.p_dt between ${beg_date} and ${end_date}
;
