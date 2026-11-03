------------------------------------------------------------------------
--模块名称：网下交收表（离线）
--交收：网下新股\新债执行确认交收\退补款交收
--网下新股缴款交收
--跨市场转托管交收（债券）
--实时交收：一级市场债券分销买入资金交收
------------------------------------------------------------------------
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

alter table ${dwd_db}.evt_ofle_sett_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='O3') ;
with VHISOUTCONFIRM AS (
     SELECT l_date
          , l_fund_id
          , l_confirm_date
          , l_confirm_no
          , l_execconfirm_no
          , l_busin_flag
          , en_interest
          , l_settle_date
          , c_exceed_flag
          , en_balance
          , l_daily_instruction_no
          , l_index_daily_modify
          , l_stock_serial_no
          , en_fee_ratio
          , c_settle_type
          , c_busin_pro_type
          , c_deal_status
          , vc_remark
          , en_punish_interest
          , en_profit_ratio
          , l_operator_no
          , l_rival_id
          , l_time
          , vc_inter_code
          , c_restricted_flag
          , l_basecombi_id
          , en_amount
       FROM ${ods_db}.o3_toutconfirm
      WHERE c_status = '1' --正常
      UNION ALL
     SELECT l_date
          , l_fund_id
          , l_confirm_date
          , l_confirm_no
          , l_execconfirm_no
          , l_busin_flag
          , en_interest
          , l_settle_date
          , c_exceed_flag
          , en_balance
          , l_daily_instruction_no
          , l_index_daily_modify
          , l_stock_serial_no
          , en_fee_ratio
          , c_settle_type
          , c_busin_pro_type
          , c_deal_status
          , vc_remark
          , en_punish_interest
          , en_profit_ratio
          , l_operator_no
          , l_rival_id
          , l_time
          , vc_inter_code
          , c_restricted_flag
          , l_basecombi_id
          , en_amount
       FROM ${ods_db}.o3_thisoutconfirm
      WHERE c_status = '1' --正常
)
insert into ${dwd_db}.evt_ofle_sett_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,sett_onum,tnv_onum,tnv_dt,prd_code,ast_unit_code,
 pfl_code,sh_code,seat_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,
 pos_id,curr_code,entr_dir,busi_typ,busi_clas,sett_clas,sett_vol,sett_val,actl_sett_val,
 cptl_sett_stat,secu_sett_stat,oper_no,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--交收：网下新股\新债执行确认交收\退补款交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|', (CASE WHEN T0.L_BUSIN_FLAG = '41501' THEN T4.L_CONFIRM_DATE ELSE T7.L_CONFIRM_DATE END), '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_',  (CASE WHEN T0.L_BUSIN_FLAG = '41501' THEN 'O' ELSE '' END), T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
                   CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE), '.STK.', --股票
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
           WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
                   CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE), '.STK.', --债券
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
           WHEN T6.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE = '50' THEN
                   CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE), '.FUND.', --基金
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
       END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
           WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
                T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
               '12' --网下新股\新债\基金
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
               '150' --网下定增
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
               '12' --网下战略配售
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
               '12' --网下增发
       END AS ENTR_DIR, --委托方向
       CASE
           WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
                T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
               '050101' --网下新股\新债\基金
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
               '050301' --网下定增
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
               '050601' --网下战略配售
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
               '050501' --网下增发
       END AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
                T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
                (CASE
                    WHEN T0.L_BUSIN_FLAG = '41501' THEN
                      '05010105'
                    WHEN T0.L_BUSIN_FLAG = '41507' THEN
                      '05010107'
                    ELSE
                      '05010106'
                END)--网下新股\新债\基金
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
                (CASE
                    WHEN T0.L_BUSIN_FLAG = '41501' THEN
                      '05030103'
                    WHEN T0.L_BUSIN_FLAG = '41507' THEN
                      '05030105'
                    ELSE
                      '05030104'
                END) --网下定增
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
                (CASE
                    WHEN T0.L_BUSIN_FLAG = '41501' THEN
                      '05060103'
                    WHEN T0.L_BUSIN_FLAG = '41507' THEN
                      '05060105'
                    ELSE
                      '05060104'
                END) --网下战略配售
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
                (CASE
                    WHEN T0.L_BUSIN_FLAG = '41501' THEN
                      '05050103'
                    WHEN T0.L_BUSIN_FLAG = '41507' THEN
                      '05050105'
                    ELSE
                      '05050104'
                END) --网下增发
       END AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       CASE
          WHEN T0.C_STATUS IN ('2') THEN
           '5' --已回溯
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) = '1' THEN
           '4' --交收失败
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('2', '4') THEN
           '3' --已交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('1', '3') THEN
           '2' --未交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('0') THEN
           '1' --无需交收
        END AS CPTL_SETT_STAT, --资金交收状态
        CASE
                WHEN T0.C_STATUS IN ('2') THEN
                 '5' --已回溯
                WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) = '1' THEN
                 '4' --交收失败
                WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('2', '4') THEN
                 '3' --已交收
                WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('1', '3') THEN
                 '2' --未交收
                WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('0') THEN
                 '1' --无需交收
        END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_ofle_sett_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.C_ASSET_CLASS IN ('6', '3', '2')
             AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
             AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
              ON T5.L_DATE = T6.L_DATE
             AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
             AND T6.C_ASSET_CLASS IN ('2', '3', '6')
             AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
             AND T6.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN VHISOUTCONFIRM T4
              ON T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
             AND T0.VC_ORIGINAL_NO = T4.L_CONFIRM_NO
             AND T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
             AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
       LEFT JOIN VHISOUTCONFIRM T7 --中签找执行确认记录
              ON T4.L_EXECCONFIRM_NO = T7.L_CONFIRM_NO
             AND T4.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
             AND T4.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
             AND T7.L_BUSIN_FLAG = '41501'
             AND T4.L_BUSIN_FLAG IN ('41507', '41522')
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T11 --证券基本信息表，获取执行确认时证券属性
              ON T7.VC_INTER_CODE = T11.VC_INTER_CODE
             AND T11.C_ASSET_CLASS IN ('2', '3', '6')
             AND T11.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
 WHERE T0.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
   AND T0.L_BUSIN_FLAG IN ('41501', '41507', '41522') --41501执行确认交收,41521中签
   AND T0.C_STATUS IN ('1') --1-正常
   AND NVL(T0.C_CASHSETTLE_FLAG,0) <> '0'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--网下新股缴款交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|', T7.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE), '.STK.', --股票
       (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '12' AS ENTR_DIR, --委托方向
       '050101' AS BUSI_TYP, --业务类别,交易所现券交易
       '05010104' AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_ofle_sett_his_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN VHISOUTCONFIRM T4
              ON T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
             AND T0.VC_ORIGINAL_NO = T4.L_CONFIRM_NO
             AND T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
             AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
       LEFT JOIN VHISOUTCONFIRM T7 --缴款找执行确认记录
              ON T4.L_EXECCONFIRM_NO = T7.L_CONFIRM_NO
             AND T4.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
             AND T4.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
             AND T7.L_BUSIN_FLAG = '73171'
             AND T4.L_BUSIN_FLAG IN ('73174')
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.C_ASSET_CLASS IN ('6', '3', '2')
             AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
             AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
              ON T5.L_DATE = T6.L_DATE
             AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
             AND T6.C_ASSET_CLASS IN ('2', '3', '6')
             AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
             AND T6.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
   AND T0.L_BUSIN_FLAG IN ('73174')
   AND T0.C_STATUS IN ('1') --1-正常
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--跨市场转托管交收（债券）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|', T7.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE, '.BOND.', --债券
       (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END))  AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '43' AS ENTR_DIR, --委托方向
       '210001' AS BUSI_TYP, --业务类别,交易所现券交易
       '21000105' AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       T0.L_SETTLE_AMOUNT AS SETT_VOL, --交收数量
       0 AS SETT_VAL, --交收金额
       0 AS ACTL_SETT_VAL, --实际交收金额
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_ofle_sett_his_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
       LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4
              ON T0.L_TRADE_DATE =T4.L_CONFIRM_DATE
             AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
             AND T4.L_BUSIN_FLAG IN ('72122','72123')
             AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T7 --执行确认信息
              ON T4.L_EXECCONFIRM_NO = T7.L_CONFIRM_NO
             AND T4.L_FUND_ID = T7.L_FUND_ID
             AND T7.L_BUSIN_FLAG IN ('72121')
             AND T7.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('Q')
   AND T0.L_BUSIN_FLAG IN ('72122', '72123')
   AND T5.C_MARKET_NO = '5'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--实时交收：一级市场债券分销买入资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
               NULL --缺少指令序号，直接为空
           ELSE
               CONCAT('0|', T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_', '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CONCAT(T6.VC_REPORT_CODE, '.BOND.', --债券
       (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END))  AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '21' AS ENTR_DIR, --委托方向
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '050401'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '050402'
       END AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '05040103'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '05040203'
       END AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
           WHEN NVL(T0.C_SETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
           WHEN NVL(T0.C_SETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_ofle_sett_his_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据，
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --获取成交执行序号
              ON T0.VC_ORIGINAL_NO = T4.L_CONFIRM_NO
             AND T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
             AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
              ON T5.L_DATE = T6.L_DATE
             AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
             AND T6.C_ASSET_CLASS IN ('2', '3', '6', '4')
             AND T6.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('D')
   AND T0.C_ENTRUST_DIRECTION = ('K')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}
;
