------------------------------------------------------------------------
  -- 模块名称：证券分析数据_O32
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

alter table ${dwd_db}.var_secu_anys_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id = 'O3') ;

insert into ${dwd_db}.var_secu_anys_o32 partition(p_dt,sys_rs_id)
    (secu_id
     ,occu_dt
     ,o32_tscp
     ,o32_cir_capt
     ,o32_secu_clas
     ,o32_ast_clas
     ,o32_mix_typ
     ,busi_date
     ,task_rs_id
     ,dm_created_time
     ,p_dt
     ,sys_rs_id
       )
SELECT CONCAT(T0.VC_REPORT_CODE , CASE WHEN T0.C_ASSET_CLASS = '2' THEN '.STK.' WHEN T0.C_ASSET_CLASS = '3' THEN '.BOND.' WHEN T0.C_ASSET_CLASS = '4' THEN '.FUND.' END ,
       CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH' WHEN T0.C_MARKET_NO = '2' THEN 'SZ' WHEN T0.C_MARKET_NO = '5' THEN 'YHJ' WHEN T0.C_MARKET_NO =  '6' THEN 'NONE' END)  AS SECU_ID, --证券编码
       T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TOTAL_AMOUNT AS O32_TSCP, --O32_总股本
       T0.L_TURNOVER_AMOUNT  AS O32_CIR_CAPT, --O32_流通股本
       T0.C_STOCK_TYPE  AS O32_SECU_CLAS, --O32_证券类型
       T0.C_ASSET_CLASS  AS O32_AST_CLAS, --O32_资产类型
       T0.VC_MIXED_TYPE  AS O32_MIX_TYP, --O32_杂项分类
       ${current_date} as busi_date, --业务日期
       'var_secu_anys_o32_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS p_dt,-- 分区
       'O3' AS sys_rs_id --系统来源标识
   FROM ${ods_db}.O3_TSTOCKINFO T0
   WHERE T0.C_ASSET_CLASS IN ('2', '3', '4')
    AND T0.L_DATE = ${current_date}

UNION

SELECT CONCAT(T0.VC_REPORT_CODE , CASE WHEN T0.C_ASSET_CLASS = '2' THEN '.STK.' WHEN T0.C_ASSET_CLASS = '3' THEN '.BOND.' WHEN T0.C_ASSET_CLASS = '4' THEN '.FUND.' END ,
       CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH' WHEN T0.C_MARKET_NO = '2' THEN 'SZ' WHEN T0.C_MARKET_NO = '5' THEN 'YHJ' WHEN T0.C_MARKET_NO =  '6' THEN 'NONE' END)  AS SECU_ID, --证券编码
       T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TOTAL_AMOUNT AS O32_TSCP, --O32_总股本
       T0.L_TURNOVER_AMOUNT  AS O32_CIR_CAPT, --O32_流通股本
       T0.C_STOCK_TYPE  AS O32_SECU_CLAS, --O32_证券类型
       T0.C_ASSET_CLASS  AS O32_AST_CLAS, --O32_资产类型
       T0.VC_MIXED_TYPE  AS O32_MIX_TYP, --O32_杂项分类
       ${end_date} as busi_date, --业务日期
       'var_secu_anys_o32_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS p_dt,-- 分区
       'O3' AS sys_rs_id --系统来源标识
   FROM ${ods_db}.O3_THISSTOCKINFO T0
   WHERE T0.C_ASSET_CLASS IN ('2', '3', '4')
     and T0.P_dt BETWEEN ${beg_date} AND ${end_date}
  ;