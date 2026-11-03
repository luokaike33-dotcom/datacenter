------------------------------------------------------------------------
  -- 模块名称：产品转融通持仓明细信息
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

alter table ${dwd_db}.fin_prd_refc_hld drop if exists partition (sys_rs_id='DYCF') ;


insert into ${dwd_db}.fin_prd_refc_hld partition(sys_rs_id)
(
prd_code
,secu_id
,typ_code
,typ_codeii
,typ_codei
,chi_name
,exch_code
,var_secu_id
,hld_dt
,curr_code
,hld_cost
,hld_val
,hld_vol
,accr_intr
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,sys_rs_id
)
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T0.SECU_ID AS SECU_ID, --证券编码
       T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       NULL AS CHI_NAME, --证券中文名称
       T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T1.SECU_VAR AS VAR_SECU_ID, --品种代码
       T0.HLD_DT AS HLD_DT, --持仓日期
       'CNY' AS CURR_CODE, --货币类型
       T0.CURR_COST AS HLD_COST, --持仓成本
       T0.CURR_VAL AS HLD_VAL, --持仓市值
       T0.CURR_VOL AS HLD_VOL, --持仓数量
       T0.ACCR_INTR AS ACCR_INTR, --应计利息
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_refc_hld_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
 INNER JOIN ${dwd_db}.FIN_PRD_ZRT_LEND T1  --产品转融通借出信息
    ON T0.SECU_ID = T1.SECU_ID
   AND T0.AST_UNIT_CODE = T1.PRD_CODE
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
   ON T0.AST_UNIT_CODE = T2.PRD_CODE
 WHERE T0.CURR_VOL <> 0
  AND T0.p_dt <= T2.valu_cnfm_dt
