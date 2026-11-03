------------------------------------------------------------------------
  -- 模块名称：资产单元净值信息盘后
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

alter table ${dwd_db}.ast_asset_unit_nav drop if exists partition (p_dt = ${current_date},sys_rs_id='O3') ;

with vhisassetday as(
SELECT
T0.L_DATE,
T0.L_ASSET_ID,
T1.VC_CURRENCY_NO,
T0.L_FUND_ID,
SUM((T0.EN_ASSET_VALUE / cast(NVL(T2.L_UNIT_AMOUNT,T3.L_UNIT_AMOUNT) as double) * cast(NVL(T2.EN_MID_PRICE,T3.EN_MID_PRICE) as double))+ nvl(en_bond_interest,0))  AS EN_ASSET_VALUE
FROM ${ods_db}.O3_THISASSETDAY t0
LEFT JOIN ${ods_db}.O3_tfundinfo  T1
  ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.O3_tcurrencyrate T2
  ON T1.VC_CURRENCY_NO = T2.VC_CURRENCY_TARGET
AND T0.L_DATE = T2.L_DATE
AND T0.VC_CURRENCY_NO = T2.VC_CURRENCY_SOURCE
AND T1.L_SET_NO = T2.L_SET_NO
AND T2.VC_CURRENCY_SOURCE NOT IN ('HK1','HK2')
LEFT JOIN ${ods_db}.O3_tcurrencyrate T3
  ON T1.VC_CURRENCY_NO = T3.VC_CURRENCY_TARGET
AND T0.L_DATE = T3.L_DATE
AND T0.VC_CURRENCY_NO = T3.VC_CURRENCY_SOURCE
AND T1.L_GGT_SET_NO = T3.L_SET_NO
AND T3.VC_CURRENCY_SOURCE IN ('HK1','HK2')
WHERE T0.L_DATE = ${current_date}
GROUP BY T0.L_DATE,
T0.L_ASSET_ID,
T1.VC_CURRENCY_NO,
T0.L_FUND_ID
)
insert into ${dwd_db}.ast_asset_unit_nav partition(p_dt,sys_rs_id)
(
occu_dt
,prd_code
,ast_unit_code
,ttl_navl
,busi_date
,task_rs_id
,dm_created_time
,p_dt
,sys_rs_id
)
SELECT T0.L_DATE AS OCCU_DT, --发生日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     T0.EN_ASSET_VALUE AS TTL_NAVL, --总净值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_asset_unit_nav_real_1' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
FROM vhisassetday T0
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
  ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.O3_TASSET T2
  ON T0.L_ASSET_ID = T2.L_ASSET_ID
;