------------------------------------------------------------------------
--模块名称：结算类交收
--银行间兑付和面额兑付资金交收
--银行间兑息交收
--存款利息到账（非利息转存）
--场外红利到账
--红利税补缴交收
--离线交收：非投资类业务
--离线交收：强制赎回资金交收
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

alter table ${dwd_db}.evt_sett_excf_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

 WITH VHISUNCOMPLETELOG AS
         (SELECT
              L_TRADE_DATE,
              L_SERIAL_NO,
              VC_STOCKHOLDER_ID,
              VC_SEAT_ID,
              C_INVEST_TYPE,
              L_AMOUNT,
              EN_BANLANCE,
              C_ENTRUST_DIRECTION,
              C_BUSIN_CLASS,
              L_FUND_ID,
              L_ASSET_ID,
              L_BASECOMBI_ID,
              VC_INTER_CODE,
              L_BUSIN_FLAG,
              VC_DEAL_NO,
			  L_COMPLETE_DATE
          FROM ${ods_db}.O3_TUNCOMPLETELOG
          UNION ALL
          SELECT
              L_TRADE_DATE,
              L_SERIAL_NO,
              VC_STOCKHOLDER_ID,
              VC_SEAT_ID,
              C_INVEST_TYPE,
              L_AMOUNT,
              EN_BANLANCE,
              C_ENTRUST_DIRECTION,
              C_BUSIN_CLASS,
              L_FUND_ID,
              L_ASSET_ID,
              L_BASECOMBI_ID,
              VC_INTER_CODE,
              L_BUSIN_FLAG,
              VC_DEAL_NO,
			  L_COMPLETE_DATE
          FROM ${ods_db}.O3_THISUNCOMPLETELOG
         ),
VHISPENDSETTLE AS
         (SELECT L_SERIAL_NO,
                 L_ENTRUST_SERIAL_NO,
                 L_trade_DATE,
                 VC_ORIGINAL_NO,
                 C_ENTRUST_DIRECTION,
                 VC_DEAL_NO,
                 l_Relate_No,
                 VC_INTER_CODE,
                 L_BASECOMBI_ID,
                 L_SETTLE_DATE,
                 L_BUSIN_FLAG,
                 L_FUND_ID,
                 L_DATE,
                 C_STATUS,
                 VC_STOCKHOLDER_ID,
                 VC_BIND_SEAT,
                 VC_CURRENCY_NO,
                 C_INVEST_TYPE,
                 EN_ACT_SETTLE_BALANCE,
                 EN_SETTLE_BALANCE,
                 C_CASHSETTLE_FLAG,
                 C_SETTLE_FLAG,
                 C_STOCKSETTLE_FLAG
          FROM ${ods_db}.O3_THISPENDSETTLE
          WHERE C_STATUS = '1'
          UNION ALL
          SELECT L_SERIAL_NO,
                 L_ENTRUST_SERIAL_NO,
                 L_trade_DATE,
                 VC_ORIGINAL_NO,
                 C_ENTRUST_DIRECTION,
                 VC_DEAL_NO,
                 l_Relate_No,
                 VC_INTER_CODE,
                 L_BASECOMBI_ID,
                 L_SETTLE_DATE,
                 L_BUSIN_FLAG,
                 L_FUND_ID,
                 L_DATE,
                 C_STATUS,
                 VC_STOCKHOLDER_ID,
                 VC_BIND_SEAT,
                 VC_CURRENCY_NO,
                 C_INVEST_TYPE,
                 EN_ACT_SETTLE_BALANCE,
                 EN_SETTLE_BALANCE,
                 C_CASHSETTLE_FLAG,
                 C_SETTLE_FLAG,
                 C_STOCKSETTLE_FLAG
          FROM ${ods_db}.O3_TPENDSETTLE
          WHERE C_STATUS = '1')
insert into ${dwd_db}.evt_sett_excf_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,sett_onum,tnv_onum,tnv_no,tnv_dt,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,sett_clas,sett_vol,sett_val,actl_sett_val,cptl_sett_stat,secu_sett_stat,oper_no,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--银行间兑付和面额兑付资金交收
SELECT T0.L_DATE as OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', T0.L_TRADE_DATE, '_HSO32', '_J', T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE, '_HSO32', '_J', T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE, '.BOND.',
              (CASE
                   WHEN T5.C_MARKET_NO = '1' THEN
                        'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN
                        'SZ'
                   WHEN T5.C_MARKET_NO = '5' THEN
                        'YHJ'
              END)
       ) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               '140002'
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               '150002'
       END AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               '14000201'
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               '15000201'
       END AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STOCKSETTLE_FLAG IN ('2', '4') THEN
               3
           WHEN T0.C_STOCKSETTLE_FLAG IN ('1', '3') THEN
               2
           WHEN T0.C_STOCKSETTLE_FLAG IN ('0') THEN
               1
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0
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
 WHERE T0.L_BUSIN_FLAG IN ('41707', '72573')
   AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
   AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.C_MARKET_NO IN ('5')
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--银行间兑息交收
SELECT T0.L_DATE as OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', T0.L_TRADE_DATE, '_HSO32', '_J', T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE, '_HSO32', '_J', T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE, '.BOND.',
              (CASE
                   WHEN T5.C_MARKET_NO = '1' THEN
                        'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN
                        'SZ'
                   WHEN T5.C_MARKET_NO = '5' THEN
                        'YHJ'
              END)
       ) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '130002' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '13000201' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STOCKSETTLE_FLAG IN ('2', '4') THEN
               3
           WHEN T0.C_STOCKSETTLE_FLAG IN ('1', '3') THEN
               2
           WHEN T0.C_STOCKSETTLE_FLAG IN ('0') THEN
               1
           END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0
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
 WHERE T0.L_BUSIN_FLAG IN ('41708')
   AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
   AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.C_MARKET_NO IN ('5')
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--存款利息到账（非利息转存）
SELECT T0.L_DATE as OCCU_DT, --发生日期
	   NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CONCAT(T0.VC_ORIGINAL_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END) , '.DPSI.NONE') --存款付息取成交时的成交确认号
       AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       CONCAT(T0.VC_ORIGINAL_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END)) --存款付息取成交时的成交确认号
       AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '160003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '16000308' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE
         WHEN T0.C_STOCKSETTLE_FLAG IN ('2', '4') THEN
          3
         WHEN T0.C_STOCKSETTLE_FLAG IN ('1', '3') THEN
          2
         WHEN T0.C_STOCKSETTLE_FLAG IN ('0') THEN
          1
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0
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
  LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
    ON T0.VC_ORIGINAL_NO =
       T7.L_CONFIRM_NO || LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0')
 WHERE T0.L_BUSIN_FLAG IN ('40222')
   AND T0.C_CASHSETTLE_FLAG IN ('2','4') AND NVL(T0.C_SETTLE_FLAG,0) <> '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T7.C_INTEREST_DEPOSIT = '0'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场外红利到账
SELECT T0.L_DATE as OCCU_DT, --'发生日期 '
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_J' , T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       concat(T0.L_TRADE_DATE , '_HSO32' , '_J' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' , (CASE
             WHEN T5.C_MARKET_NO = '1' THEN
                 'SH'
             WHEN T5.C_MARKET_NO = '2' THEN
                 'SZ'
             WHEN T5.C_MARKET_NO = '6' THEN
                 'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '110003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
       '11000301' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE, 0) = 0 THEN T0.EN_SETTLE_BALANCE
            ELSE T0.EN_ACT_SETTLE_BALANCE
           END AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE
           WHEN T0.C_STOCKSETTLE_FLAG IN ('2', '4') THEN
               3
           WHEN T0.C_STOCKSETTLE_FLAG IN ('1', '3') THEN
               2
           WHEN T0.C_STOCKSETTLE_FLAG IN ('0') THEN
               1
           END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISPENDSETTLE T0
LEFT JOIN ${ods_db}.O3_THISCURRENTS T4
    ON   (CASE WHEN T0.L_BUSIN_FLAG = '41703' THEN T0.L_TRADE_DATE
           ELSE T0.L_SETTLE_DATE END) = T4.L_DATE
    AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
    AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
    AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
    AND T4.L_BUSIN_FLAG IN ('41703', '73148')
    AND T4.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_DATE = T5.L_DATE
    AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
    AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
WHERE T0.L_BUSIN_FLAG IN ('41703', '73147')
  AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
  AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
  AND T5.C_MARKET_NO = '6'
  AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
  AND NVL(T0.EN_ACT_SETTLE_BALANCE, 0) + T0.EN_SETTLE_BALANCE <> 0
  AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--红利税补缴交收
SELECT T4.L_DATE as OCCU_DT, --'发生日期 '
	   NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T4.L_DATE , '_HSO32' , '_L' , T4.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '400001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '40000101' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_BANLANCE AS SETT_VAL, --交收金额
       T0.EN_BANLANCE AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       1 AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T4.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISUNCOMPLETELOG T0 --未完成表，当前表和历史表合集
 INNER JOIN ${ods_db}.O3_THISCURRENTS T4
    ON T0.L_COMPLETE_DATE = T4.L_DATE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.C_INVEST_TYPE = T4.C_INVEST_TYPE
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_TRADE_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('72576')
   AND T4.L_BUSIN_FLAG = '72560'
      --72576红利税补缴冻结 72560 红利税补缴流水
      --使用流水表L_DATE查询业务日期

UNION ALL
--离线交收：非投资类业务
SELECT T0.L_SETTLE_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_P' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_P' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'GLF.CASH.NONE'  --管理费
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'TGF.CASH.NONE'  --托管费
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'JSBFJ.CASH.SH'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'JSBFJ.CASH.SZ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'JSBFJ.CASH.SH'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'JSBFJ.CASH.SZ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'ZDBFJ.CASH.SH'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'ZDBFJ.CASH.SZ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'JYBZJ.CASH.SH'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'JYBZJ.CASH.SZ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'YFYJ.CASH.SH'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'YFYJ.CASH.SZ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'JYSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'DPSI101.DPSI.NONE'  --活期存款
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'LXZZS.CASH.NONE'  --利息增值税
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'ZRZZS.CASH.NONE'	    --转让增值税
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'FJS.CASH.NONE'	--附加税
       END AS SECU_ID, --证券编码
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'NONE'
       END AS EXCH_CODE, --交易市场代码
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'GLF'  --管理费
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'TGF'  --托管费
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'ZDBFJ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'ZDBFJ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'JYBZJ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'JYBZJ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'YFYJ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'YFYJ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'JYSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'DPSI101'  --活期存款
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'LXZZS'  --利息增值税
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'ZRZZS'  --转让增值税
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'FJS'  --附加税
       END AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '440003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN '44000301'  --管理费支付交收
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN '44000303'  --托管费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN '44000309'  --非担保备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN '44000309'  --非担保备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN '44000305'  --DVP备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN '44000305'  --DVP备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN '44000307'  --最低备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN '44000307'  --最低备付金利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN '44000335'  --结算保证金利息支付交收
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN '44000335'  --结算保证金利息支付交收
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN '44000311'  --上清所现券结算费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN '44000313'  --上清所回购结算费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN '44000319'  --外汇交易中心现券交易手续费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN '44000321'  --外汇交易中心回购交易手续费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN '44000315'  --中债登现券结算费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN '44000317'  --中债登回购结算费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN '44000323'  --上交所佣金支付交收
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN '44000325'  --深交所佣金支付交收
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN '44000327'  --银行手续费支付交收
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN '44000329'  --活期存款利息收入交收
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN '44000331'  --贷款服务销项税支付交收
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN '44000333'  --转让金融商品销项税支付交收
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN '44000337'	--增值税附加税支付交收
       END AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE, 0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       1 AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_6' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_SETTLE_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --当前和历史的合集
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 WHERE T0.L_BUSIN_FLAG IN ('40108', '40107', '72457', '72458', '72512' ,'72513', '72459', '72460', '72461', '72462', '72480', '72481', '72933', '72454', '72515', '72516', '72446', '72447', '72445', '72456', '73429', '73430', '73431')
 --40108管理费支付 40107托管费支付
 --72457上海结算备付金利息收入 72458深圳结算备付金利息收入
 --72512上海DVP备付金利息收入 72513深圳DVP备付金利息收入
 --72459上海最低备付金利息收入 72460深圳最低备付金利息收入
 --72461上海交易保证金利息收入 72462深圳交易保证金利息收入
 --72480上清所现券结算费支付 72481上清所回购结算费支付 72933外汇交易中心现券费用支付 72454外汇交易中心回购费用支付 72515中央国债现券结算费支付  72516中央国债回购结算费支付
 --72446上海佣金支付 72447深圳佣金支付
 --72445银行手续费支付
 --72456银行间活期利息收入
 --73429贷款服务销项税 73430转让金融商品销项税
  --73431 应交增值税附加税
   AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
   AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯

UNION ALL
--离线交收：强制赎回资金交收
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T4.L_TRADE_DATE , '_HSO32' , '_S' , T4.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       concat(T4.L_TRADE_DATE , '_HSO32' , '_S' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       T4.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T4.VC_BIND_SEAT AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.FUND.' , (CASE
            WHEN T5.C_MARKET_NO = '1' THEN
             'SH'
            WHEN T5.C_MARKET_NO = '2' THEN
             'SZ'
            WHEN T5.C_MARKET_NO = '6' THEN
             'NONE'
          END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '6' THEN
          'NONE'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '450003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '45000301' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T4.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       CASE WHEN NVL(T4.EN_ACT_SETTLE_BALANCE, 0) = 0 THEN T4.EN_SETTLE_BALANCE ELSE T4.EN_ACT_SETTLE_BALANCE END AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE
         WHEN T4.C_STOCKSETTLE_FLAG IN ('2', '4') THEN
          3
         WHEN T4.C_STOCKSETTLE_FLAG IN ('1', '3') THEN
          2
         WHEN T4.C_STOCKSETTLE_FLAG IN ('0') THEN
          1
       END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_excf_his_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
   FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN VHISPENDSETTLE T4 --当前和历史的合集
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.L_BUSIN_NO = T4.VC_ORIGINAL_NO
   AND T4.L_BUSIN_FLAG = '73088'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('73089')
   AND T0.C_STATUS = '1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}