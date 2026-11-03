------------------------------------------------------------------------
-- 模块名称：产品净值信息
------------------------------------------------------------------------
----set spark.app.name=fin_prd_nav_dycf;
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
------set spark.dynamicAllocation.enabled=false;
------set spark.executor.cores=10;
------set spark.driver.memory=32G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;

--清除指定范围分区的数据
alter table ${dwd_db}.fin_prd_nav drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='DYCF');

WITH V_TNAV AS (
SELECT A.PRD_CODE,
       A.P_DT as HLD_DT,
	   SUM(coalesce(A.HLD_VAL,0) + coalesce(A.ACCR_INTR,0)) AS TNVL --总净值
  FROM ${dwd_db}.FIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取单元层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '2'
 WHERE A.P_DT between ${beg_date} and ${end_date}
GROUP BY A.PRD_CODE,A.P_DT
)

insert into ${dwd_db}.fin_prd_nav partition(p_dt,sys_rs_id)
(prd_code,fofs_code,nav_dt,prd_typ,ttl_navl,ttl_shr,unit_nval,busi_date,task_rs_id,dm_created_time,dm_src_info,p_dt,sys_rs_id)
SELECT
T4.PRD_CODE, --单元代码
T4.PRD_CODEC,  --产品代码
T4.nav_dt, --净值日期
T4.prd_typ, --组合类型
T4.TTL_NAVL, --总净值
T4.TTL_SHR AS TTL_SHR, --份额
T4.UNIT_NVAL AS UNIT_NVAL, --单位净值
date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
'fin_prd_nav_o32' AS TASK_RS_ID, --任务来源标识
CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
'FIN_PRD_HLD_DATA' AS dm_src_info,
T4.nav_dt AS P_DT,
'DYCF' AS sys_rs_id --系统来源标识
FROM 
(
SELECT
T2.PRD_CODE, --单元代码
T2.nav_dt, --净值日期
T2.prd_typ, --组合类型
T2.TTL_NAVL, --总净值
CASE WHEN RN = 1 THEN TTL_SHR + TTL_SHR_ye ELSE TTL_SHR END AS TTL_SHR, --份额
T2.SHR_CHG, --当日份额变动
T2.COVT_RATE, --折算比例
T2.pre_1_dt, --上一交易日
T2.UNIT_NVAL, --单位净值
T2.PRD_CODEC  --产品代码
FROM (
SELECT
T1.PRD_CODE, --单元代码
T1.nav_dt, --净值日期
T1.prd_typ, --组合类型
T1.TTL_NAVL, --总净值
T1.TTL_SHR, --份额
NVL(T3.SHR_ADD,0) - NVL(T3.SHR_REDUCE,0) AS SHR_CHG, --当日份额变动
COALESCE(T4.SPLI_CNV_RAT,1) AS COVT_RATE, --折算比例
T5.pre_1_dt, --上一交易日
T1.UNIT_NVAL, --单位净值
T1.PRD_CODEC,  --产品代码
T1.RN,
T1.TTL_SHRD - SUM(T1.TTL_SHR)OVER(PARTITION BY T2.FOFS_CODE,T1.nav_dt) AS TTL_SHR_ye --份额余额
FROM (
SELECT A.PRD_CODE AS PRD_CODE, --单元代码
       A.HLD_DT AS nav_dt, --净值日期
       '2' AS prd_typ, --组合类型
       A.TNVL AS TTL_NAVL, --总净值
	   C.PRD_CODE AS PRD_CODEC,
	   D.TTL_SHR AS TTL_SHRD,
	   CAST(A.TNVL AS DECIMAL(18,2)) / CAST(D.TTL_NAVL AS DECIMAL(18,2)) * CAST(D.TTL_SHR AS DECIMAL(18,2)) AS TTL_SHR, --份额
	   ROW_NUMBER() OVER(PARTITION BY C.PRD_CODE,A.HLD_DT ORDER BY A.TNVL) AS RN,
	   D.UNIT_NVAL AS UNIT_NVAL --单位净值
  FROM V_TNAV A --净值信息
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C --资产单元基本信息表
    ON A.PRD_CODE = C.AST_UNIT_CODE
  LEFT JOIN ${dwd_db}.FIN_PRD_NAV D --取产品层
    ON C.PRD_CODE = D.PRD_CODE
   AND A.HLD_DT = D.P_DT
   AND D.P_DT between ${beg_date} and ${end_date}
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
AND T2.SYS_RS_ID = 'DYCF'
LEFT JOIN (
SELECT 
SUM(capi_add) AS SHR_ADD,
SUM(capi_reduce) AS SHR_REDUCE,
PRD_CODE,P_DT AS CHG_DT
FROM ${dwd_db}.FIN_PRD_CAPI_CHG_DETAIL T3
WHERE T3.SYS_RS_ID IN ('DYCF_HB','DYCF_TA')
and P_DT between ${beg_date} and ${end_date}
GROUP BY PRD_CODE,P_DT
) T3
ON T1.PRD_CODE = T3.PRD_CODE
AND T1.nav_dt = T3.CHG_DT
LEFT JOIN ${dwd_db}.FIN_PRD_BONS T4
ON T1.PRD_CODE = T4.PRD_CODE
AND T1.nav_dt = T4.ex_rd_dt
AND T4.SYS_RS_ID IN ('DYCF')
LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T5
ON T1.nav_dt = T5.DT
AND T5.MKT_NO = '5'
AND T5.SYS_RS_ID = 'O3'
WHERE T1.nav_dt <= T2.valu_cnfm_dt
) T2
) T4
