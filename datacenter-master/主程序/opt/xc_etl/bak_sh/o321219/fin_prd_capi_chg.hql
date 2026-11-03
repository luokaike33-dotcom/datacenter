------------------------------------------------------------------------
  -- 模块名称：产品资金流信息
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

alter table ${dwd_db}.fin_prd_capi_chg drop if exists partition (sys_rs_id='DYCF') ;


insert into ${dwd_db}.fin_prd_capi_chg partition(sys_rs_id='DYCF')
(
prd_code
,chg_dt
,capi_add
,capi_reduce
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
)
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.CHG_DT AS CHG_DT, --变动日期
       SUM(A.CAPI_ADD) AS CAPI_ADD, --资金流入
       SUM(A.CAPI_REDUCE) AS CAPI_REDUCE, --资金流出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_dpsi_hld_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info
  FROM ${dwd_db}.FIN_PRD_CAPI_CHG_DETAIL A --产品资金流明细信息
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '2'
  WHERE A.sys_rs_id in ('DYCF_HB','DYCF_TA')
   AND A.CHG_DT <= B.valu_cnfm_dt
 GROUP BY A.PRD_CODE,A.CHG_DT