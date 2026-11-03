------------------------------------------------------------------------
--模块名称：场外交收表(离线)
--场外认购执行确认交收
--场外认购退款交收
--场外申购执行确认交收
--场外申购退款交收
--场外开基赎回到账交收
--离线交收：存款支取资金交收
--离线交收：存款支取交收失败
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

alter table ${dwd_db}.evt_otc_sett_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='O3') ;

insert into ${dwd_db}.evt_otc_sett_his partition(p_dt, sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,ord_time,sett_onum,tnv_onum,tnv_no,tnv_dt,prd_code,ast_unit_code,pfl_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,entr_dir,busi_typ,busi_clas,sett_clas,sett_vol,sett_val,actl_sett_val,cptl_sett_stat,secu_sett_stat,oper_no,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--场外认购执行确认交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '14' AS ENTR_DIR, --委托方向
       '090003' AS BUSI_TYP, --业务类别
       '09000318' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE WHEN T0.C_STOCKSETTLE_FLAG IN ('2','4') THEN 3
        WHEN T0.C_STOCKSETTLE_FLAG IN ('1','3') THEN 2
         WHEN T0.C_STOCKSETTLE_FLAG IN ('0') THEN 1
          END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_sett_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --场外执行确认表
    ON T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
   AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
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
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41545')
   AND T5.C_MARKET_NO NOT IN ('1', '2')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场外认购退款交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T8.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '14' AS ENTR_DIR, --委托方向
       '090003' AS BUSI_TYP, --业务类别
       '09000311' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE WHEN T0.C_STOCKSETTLE_FLAG IN ('2','4') THEN 3
        WHEN T0.C_STOCKSETTLE_FLAG IN ('1','3') THEN 2
         WHEN  T0.C_STOCKSETTLE_FLAG IN ('0') THEN 1
          END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_sett_his_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --场外执行确认表
    ON T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
   AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T8 --获取执行确认日期
    ON T4.L_EXECCONFIRM_NO = T8.L_CONFIRM_NO
   AND T0.L_FUND_ID = T8.L_FUND_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T8.L_DAILY_INSTRUCTION_NO
   AND T8.L_BUSIN_FLAG IN ('41545') --执行确认记录
   AND T8.P_DT BETWEEN ${beg_date} AND ${end_date}
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
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41547')
   AND T5.C_MARKET_NO NOT IN ('1', '2')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场外申购执行确认交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '53' AS ENTR_DIR, --委托方向
       '090003' AS BUSI_TYP, --业务类别
       '09000313' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE WHEN T0.C_STOCKSETTLE_FLAG IN ('2','4') THEN 3
        WHEN T0.C_STOCKSETTLE_FLAG IN ('1','3') THEN 2
         WHEN  T0.C_STOCKSETTLE_FLAG IN ('0') THEN 1
          END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_sett_his_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --场外执行确认表
    ON T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
   AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
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
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41534')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场外申购退款交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T8.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '53' AS ENTR_DIR, --委托方向
       '090003' AS BUSI_TYP, --业务类别
       '09000314' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE WHEN T0.C_STOCKSETTLE_FLAG IN ('2','4') THEN 3
        WHEN T0.C_STOCKSETTLE_FLAG IN ('1','3') THEN 2
         WHEN  T0.C_STOCKSETTLE_FLAG IN ('0') THEN 1
          END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_sett_his_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --场外执行确认表
    ON T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
   AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T8 --获取执行确认日期
    ON T4.L_EXECCONFIRM_NO = T8.L_CONFIRM_NO
   AND T0.L_FUND_ID = T8.L_FUND_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T8.L_DAILY_INSTRUCTION_NO
   AND T8.L_BUSIN_FLAG IN ('41534') --执行确认记录
   AND T8.P_DT BETWEEN ${beg_date} AND ${end_date}
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
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41536')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场外开基赎回到账交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T8.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS ODR_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_TRADE_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '54' AS ENTR_DIR, --委托方向
       '090003' AS BUSI_TYP, --业务类别
       '09000316' AS BUSI_CLAS, --业务类型
       1 AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
       NVL(T0.EN_ACT_SETTLE_BALANCE,T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
       3 AS CPTL_SETT_STAT, --资金交收状态
       CASE WHEN T0.C_STOCKSETTLE_FLAG IN ('2','4') THEN 3
        WHEN T0.C_STOCKSETTLE_FLAG IN ('1','3') THEN 2
         WHEN  T0.C_STOCKSETTLE_FLAG IN ('0') THEN 1
          END AS SECU_SETT_STAT, --证券交收状态
       NULL AS OPER_NO, --操作员编码
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_sett_his_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T4 --场外执行确认表
    ON T0.L_TRADE_DATE = T4.L_CONFIRM_DATE
   AND T0.VC_ORIGINAL_NO =T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISOUTCONFIRM T8 --获取执行确认日期
    ON T4.L_EXECCONFIRM_NO = T8.L_CONFIRM_NO
   AND T0.L_FUND_ID = T8.L_FUND_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T8.L_DAILY_INSTRUCTION_NO
   AND T8.L_BUSIN_FLAG IN ('41541') --执行确认记录
   AND T8.P_DT BETWEEN ${beg_date} AND ${end_date}
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
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41542')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线交收：存款支取资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
               T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_D' , T6.L_BUSIN_NO)
          ELSE
               CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS ODR_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
     T0.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END INV_TYP, --投资类型
     CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' , T1.VC_FUND_CODE , '-' , T7.L_BEGIN_DATE , '-' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_ID, --证券编码
     'NONE' AS EXCH_CODE, --交易市场代码
     CONCAT(CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '46' AS ENTR_DIR, --委托方向
     '160003' AS BUSI_TYP, --业务类别
     '16000308' AS BUSI_CLAS, --业务类型
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
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_otc_sett_his_6' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
       LEFT JOIN ${ods_db}.O3_THISCURRENTS T6 --待交割
         ON T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T6.L_BUSIN_NO = T0.VC_ORIGINAL_NO
                AND T6.L_DATE = T0.L_TRADE_DATE
                AND T6.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
                AND T6.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN (
       SELECT L_CONFIRM_DATE,L_CONFIRM_NO,L_DAILY_INSTRUCTION_NO
         FROM ${ods_db}.O3_THISOUTCONFIRM
        UNION ALL
       SELECT L_CONFIRM_DATE,L_CONFIRM_NO,L_DAILY_INSTRUCTION_NO
         FROM ${ods_db}.O3_TOUTCONFIRM
  ) T4 --场外执行确认,当前表和历史表合集
         ON T6.L_DATE = T4.L_CONFIRM_DATE
                AND T6.L_BUSIN_NO2 = T4.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
         ON CAST(T6.L_BUSIN_NO AS STRING) = CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0'))
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
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T0.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
   AND NVL(T0.C_SETTLE_FLAG, '0') <> '1'
   AND T0.C_CASHSETTLE_FLAG IN ('2', '4')
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线交收：存款支取交收失败
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
               T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_D' , T6.L_BUSIN_NO)
          ELSE
               CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS ODR_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
     T0.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END INV_TYP, --投资类型
     CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' , T1.VC_FUND_CODE , '-' , T7.L_BEGIN_DATE , '-' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_ID, --证券编码
     'NONE' AS EXCH_CODE, --交易市场代码
     CONCAT(CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '46' AS ENTR_DIR, --委托方向
     '160003' AS BUSI_TYP, --业务类别
     '16000308' AS BUSI_CLAS, --业务类型
     3 AS SETT_CLAS, --交收类型
     T0.L_SETTLE_AMOUNT AS SETT_VOL, --交收数量
     T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     4 AS CPTL_SETT_STAT, --资金交收状态
     4 AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, --操作员编码
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_otc_sett_his_7' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T0 --获取代交收数据
       LEFT JOIN ${ods_db}.O3_THISCURRENTS T6 --待交割
         ON T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T6.L_BUSIN_NO = T0.VC_ORIGINAL_NO
                AND T6.L_DATE = T0.L_TRADE_DATE
                AND T6.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
                AND T6.P_DT BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN (
       SELECT L_CONFIRM_DATE,L_CONFIRM_NO,L_DAILY_INSTRUCTION_NO
         FROM ${ods_db}.O3_THISOUTCONFIRM
        UNION ALL
       SELECT L_CONFIRM_DATE,L_CONFIRM_NO,L_DAILY_INSTRUCTION_NO
         FROM ${ods_db}.O3_TOUTCONFIRM
  ) T4 --场外执行确认,当前表和历史表合集
         ON T6.L_DATE = T4.L_CONFIRM_DATE
                AND T6.L_BUSIN_NO2 = T4.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
         ON CAST(T6.L_BUSIN_NO AS STRING) = CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0'))
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
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T0.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
   AND T0.C_SETTLE_FLAG = '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}