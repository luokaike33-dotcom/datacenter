------------------------------------------------------------------------
  -- 模块名称：产品回购持仓明细信息
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

alter table ${dwd_db}.fin_prd_repo_hld drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='DYCF') ;

insert into ${dwd_db}.fin_prd_repo_hld partition(p_dt, sys_rs_id)
(
prd_code
,hld_dt
,secu_id
,var_secu_id
,typ_code
,typ_codei
,valuation_dimension
,typ_codeii
,exch_code
,chi_name
,curr_code
,hld_vol
,hld_cost
,hld_mval
,accr_int
,ipmt_pvsn
,ipmt_pvsn_i
,ipmt_pvsn_ii
,ipmt_pvsn_iii
,buy_val
,sell_val
,pos_id
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,p_dt
,sys_rs_id
)
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T0.HLD_DT AS HLD_DT, --持仓日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T1.VAR_SECU_ID AS VAR_SECU_ID, --品种代码
       T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       NULL AS VALUATION_DIMENSION, --估值维度
       T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T2.SECU_SHT AS CHI_NAME, --证券中文名称
       'CNY' AS CURR_CODE, --货币类型
       CASE WHEN T1.POS_ID = 'L' THEN T0.CURR_VOL ELSE  - T0.CURR_VOL END AS HLD_VOL, --持仓数量
       CASE WHEN T1.POS_ID = 'L' THEN T0.CURR_COST ELSE  - T0.CURR_COST END AS HLD_COST, --持仓成本
       CASE WHEN T1.POS_ID = 'L' THEN T0.CURR_VAL  ELSE  - T0.CURR_VAL END AS HLD_MVAL, --持仓市值
       CASE WHEN T1.POS_ID = 'L' THEN T0.ACCR_INTR ELSE  - T0.ACCR_INTR END AS ACCR_INT, --应计利息
       0 AS IPMT_PVSN, --减值准备合计
       0 AS IPMT_PVSN_I, --减值准备一阶段
       0 AS IPMT_PVSN_II, --减值准备二阶段
       0 AS IPMT_PVSN_III, --减值准备三阶段
	   T0.CURR_BUY_VAL AS BUY_VAL, --买入金额
       T0.CURR_SELL_VAL AS SELL_VAL, --卖出金额
       T1.POS_ID as POS_ID, --多空标志
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_repo_hld_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       T0.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.AST_UNIT_SECU_BAL_HIS T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3
   ON T0.AST_UNIT_CODE = T3.PRD_CODE
  LEFT JOIN ${dwd_db}.PRO_REPO_TNV_INFO T1
    ON T0.SECU_ID = T1.SECU_ID
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
    ON T1.VAR_SECU_ID = T2.SECU_ID
 WHERE (T0.SECU_ID LIKE '%REPO%' OR T0.SECU_ID LIKE '%LB%'  OR T0.SECU_ID LIKE '%IB%')
   AND T0.P_DT between ${beg_date} and ${end_date}
   AND T0.p_dt <= T3.valu_cnfm_dt