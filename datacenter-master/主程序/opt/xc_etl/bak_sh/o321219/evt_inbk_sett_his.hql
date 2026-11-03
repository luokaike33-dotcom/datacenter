------------------------------------------------------------------------
  -- 模块名称：银行间交收表
  --实时交收：银行间现券交易证券交收
  --实时交收：银行间现券交易资金交收
  --交收：银行间债券回售资金交收
  --交收：质押式回购\信用拆借\买断式回购资金交收
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

alter table ${dwd_db}.evt_inbk_sett_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;



insert into ${dwd_db}.evt_inbk_sett_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id, occu_dt, occu_time, sett_onum, tnv_onum, tnv_no, tnv_dt,prd_code ,ast_unit_code, pfl_code, sh_code ,seat_code ,inv_typ ,secu_id ,exch_code ,secu_code ,src_secu_id ,src_secu_trd_id ,pos_id ,curr_code ,entr_dir ,busi_typ ,busi_clas,sett_clas ,sett_vol ,sett_val ,actl_sett_val ,cptl_sett_stat ,secu_sett_stat ,oper_no ,busi_date ,task_rs_id ,dm_created_time ,p_dt,sys_rs_id)
--实时交收：银行间现券交易证券交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T4.L_DATE , '_HSO32' , '_' ,
       T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS ODR_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       concat(T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
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
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '43' AS ENTR_DIR, --委托方向
       '010002' AS BUSI_TYP, --业务类别,
       CASE
            WHEN T0.L_BUSIN_FLAG IN ('40901') THEN
             '01000200'
            WHEN T0.L_BUSIN_FLAG IN ('40902') THEN
             '01000201'
       END AS BUSI_CLAS, --业务类型
       '2' AS SETT_CLAS, --交收类型
       T0.L_SETTLE_AMOUNT AS SETT_VOL, --交收数量
       0 AS SETT_VAL, --交收金额
       0 AS ACTL_SETT_VAL, --实际交收金额
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
       NULL AS OPER_NO,--操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_sett_his_1' AS TASK_RS_ID, --任务来源标识
        CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       	T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
   FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据，
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T4 --银行间成交表
    ON T0.VC_ORIGINAL_NO = T4.L_SERIAL_NO
   AND T0.L_TRADE_DATE = T4.L_DATE
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T0.L_BUSIN_FLAG IN ('40901', '40902')
   AND T0.C_STOCKSETTLE_FLAG IN ('2','4') AND NVL(T0.C_SETTLE_FLAG,0) <> '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.C_MARKET_NO IN ('5')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL

--实时交收：银行间现券交易资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T4.L_DATE , '_HSO32' , '_' ,
       T4.L_DAILY_INSTRUCTION_NO , '|0|0' )AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS ODR_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       concat(T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
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
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '43' AS ENTR_DIR, --委托方向
       '010002' AS BUSI_TYP, --业务类别,
       CASE
            WHEN T0.L_BUSIN_FLAG IN ('40901') THEN
             '01000200'
            WHEN T0.L_BUSIN_FLAG IN ('40902') THEN
             '01000200'
       END AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
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
       NULL AS OPER_NO,--操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_sett_his_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
   FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据，
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T4 --银行间成交表
    ON T0.VC_ORIGINAL_NO = T4.L_SERIAL_NO
   AND T0.L_TRADE_DATE = T4.L_DATE
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T0.L_BUSIN_FLAG IN ('40901', '40902')
   AND T0.C_CASHSETTLE_FLAG IN ('2','4') AND NVL(T0.C_SETTLE_FLAG,0) <> '1'
      --40909、40910为债券买入卖出交收
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.C_MARKET_NO IN ('5')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}
   UNION ALL
   --交收：银行间债券回售资金交收
   SELECT '1' AS BUSI_SYS_ID, --业务系统编码
          CASE
            WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
                 T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
             concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
             '|0|0')
            WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
                 T4.L_ENTRUST_SERIAL_NO <> 0 THEN
             concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
            ELSE
             concat('0|0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
          END AS TRD_SRC_ID, --交易源ID
          T0.L_DATE AS OCCU_DT, --发生日期
          NULL AS ODR_TIME, --发生时间
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
          concat(T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
          T4.VC_DEAL_NO AS TNV_NO, --成交编号
          T0.L_TRADE_DATE AS TNV_DT, --成交日期
          T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
          concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
          concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
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
          concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
          'YHJ' AS EXCH_CODE, --交易市场代码
          T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
          T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
          T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
          'L' AS POS_ID, --多空标志
          T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
          '11' AS ENTR_DIR, --委托方向
          '080002' AS BUSI_TYP, --业务类别,
          '08000204' AS BUSI_CLAS, --业务类型
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
            NULL AS OPER_NO,--操作员编码
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_inbk_sett_his_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
            T0.L_DATE,
            'O3' AS SYS_RS_ID --系统来源标识
     FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据，
     LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T4
       ON T0.VC_ORIGINAL_NO = T4.L_SERIAL_NO
      AND T0.L_TRADE_DATE = T4.L_DATE
      AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
     LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
       ON T0.L_FUND_ID = T1.L_FUND_ID
     LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
       ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
     LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
       ON T3.L_ASSET_ID = T2.L_ASSET_ID
     LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
       ON T0.L_DATE = T5.L_DATE
      AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
      AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
    WHERE T0.C_BUSIN_CLASS IN ('2')
      AND T0.L_BUSIN_FLAG IN ('72571')
      AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
      AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
         --72571债回售到账
      AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
      AND T0.C_MARKET_NO IN ('5')
      AND T0.P_DT BETWEEN ${beg_date} and ${end_date}


UNION ALL
--交收：质押式回购\信用拆借\买断式回购资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
       '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       concat(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       T4.L_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       NULL  AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE IN ('I', '8') AND
              T6.L_SERIAL_NO IS NOT NULL THEN
          concat(T6.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' ,
          T5.VC_REPORT_CODE , '.REPO.YHJ') --回购，能找到回购合约信息
         WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE IN ('I', '8') AND
              T6.L_SERIAL_NO IS NULL THEN
          concat('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' ,
          T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ') --回购，找不到合约信息
         WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE = 'z' AND
              T6.L_SERIAL_NO IS NOT NULL THEN
          concat(T6.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' ,
          T5.VC_REPORT_CODE , '.IB.YHJ') --信用拆借
         WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE = 'z' AND
              T6.L_SERIAL_NO IS NULL THEN
          concat('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' ,
          T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ') --信用拆借
       END AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7') THEN
          '2'
         WHEN T0.C_ENTRUST_DIRECTION IN ('6', '8') THEN
          '1'
       END AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       CASE
         WHEN T5.C_STOCK_TYPE IN ('8') THEN
          '020002'
         WHEN T5.C_STOCK_TYPE IN ('I') THEN
          '030002'
         WHEN T5.C_STOCK_TYPE = 'z' THEN
          '240002'
       END AS BUSI_TYP, --业务类别,
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '6') AND
              T5.C_STOCK_TYPE IN ('8') THEN
          '02000200'
         WHEN T0.C_ENTRUST_DIRECTION IN ('7', '8') AND
              T5.C_STOCK_TYPE IN ('8') THEN
          '02000201'
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '6') AND
              T5.C_STOCK_TYPE IN ('I') THEN
          '03000200'
         WHEN T0.C_ENTRUST_DIRECTION IN ('7', '8') AND
              T5.C_STOCK_TYPE IN ('I') THEN
          '03000201'
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '6') AND
              T5.C_STOCK_TYPE IN ('z') THEN
          '24000200'
         WHEN T0.C_ENTRUST_DIRECTION IN ('7', '8') AND
              T5.C_STOCK_TYPE IN ('z') THEN
          '24000201'
       END AS BUSI_CLAS, --业务类型
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
       END AS SECU_SETT_STAT,--证券交收状态
        NULL AS OPER_NO,--操作员编码
         ${end_date} AS BUSI_DATE, --业务日期
         'evt_inbk_sett_his_4' AS TASK_RS_ID, --任务来源标识
         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
         T0.L_DATE,
         'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --代交割表，
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T7
    ON T0.L_TRADE_DATE = T7.dt
    AND 5  = T7.mkt_no
    AND T7.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T4 --获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
    ON T0.VC_ORIGINAL_NO = T4.L_SERIAL_NO
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISPENDSETTLE T6 --当前待交割表和历史待交割表合集，获取在途回购表中的流水号
    ON T4.L_SERIAL_NO = T6.VC_ORIGINAL_NO
   AND T4.L_DATE = T6.L_TRADE_DATE
   AND T6.C_ENTRUST_DIRECTION IN ('5', '6')
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('2', 'Z', 'O') --筛选交易所流水
   AND T0.L_BUSIN_FLAG IN ('41203',
                           '41204',
                           '41201',
                           '41202',
                           '41209',
                           '41210',
                           '41211',
                           '41212')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
   AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
   AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
   AND T0.C_MARKET_NO IN ('5')
   AND (CASE
            WHEN T0.L_BUSIN_FLAG IN ('41203', '41204', '41211', '41212') THEN
             T4.L_SECOND_SETTLE_DATE
            ELSE
             T4.L_DATE
          END) BETWEEN T7.pre_1_dt
          AND T0.L_TRADE_DATE
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

