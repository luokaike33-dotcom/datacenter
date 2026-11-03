------------------------------------------------------------------------
  -- 模块名称：产品存款持仓明细信息
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

alter table ${dwd_db}.fin_prd_dpsi_hld drop if exists partition (sys_rs_id='DYCF') ;

WITH VPRO_DPSI_INFO AS
(SELECT DISTINCT A.PRD_CODE,A.AST_UNIT_CODE,A.PFL_CODE
FROM ${dwd_db}.PRO_DPSI_INFO A)

insert into ${dwd_db}.fin_prd_dpsi_hld partition(sys_rs_id)
(
prd_code
,hld_dt
,secu_id
,typ_code
,typ_codei
,typ_codeii
,var_secu_id
,exch_code
,chi_name
,curr_code
,hld_vol
,hld_cost
,hld_mval
,prin_crse_code
,recv_intr_crse_code
,intr_incm_crse
,accr_int
,end_t_intr
,ipmt_pvsn
,ipmt_pvsn_i
,ipmt_pvsn_ii
,ipmt_pvsn_iii
,busi_date
,task_rs_id
,dm_created_time
,valuation_dimension
,dm_src_info
,sys_rs_id
)
SELECT
       B.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.VAR_SECU_ID AS VAR_SECU_ID, --品种代码
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.HLD_VOL AS HLD_VOL, --持仓数量
       A.HLD_COST AS HLD_COST, --持仓成本
       A.HLD_MVAL AS HLD_MVAL, --持仓市值
	   A.PRIN_CRSE_CODE AS PRIN_CRSE_CODE, --本金科目代码
       A.RECV_INTR_CRSE_CODE AS RECV_INTR_CRSE_CODE, --应收利息科目代码
       A.INTR_INCM_CRSE AS INTR_INCM_CRSE, --利息收入科目
       A.ACCR_INT AS ACCR_INT, --应计利息
       A.END_T_INTR AS END_T_INTR, --截止到今天利息
       A.IPMT_PVSN AS IPMT_PVSN, --减值准备合计
       A.IPMT_PVSN_I AS IPMT_PVSN_I, --减值准备一阶段
       A.IPMT_PVSN_II AS IPMT_PVSN_II, --减值准备二阶段
       A.IPMT_PVSN_III AS IPMT_PVSN_III, --减值准备三阶段
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_dpsi_hld_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       A.VALUATION_DIMENSION AS VALUATION_DIMENSION, --估值维度
	   'FIN_PRD_DPSI_HLD' AS dm_src_info,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_DPSI_HLD A
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO C  --产品基本信息，获取产品
    ON A.PRD_CODE = C.PRD_CODE
   AND C.PRD_TYP = '1'  --组合
  LEFT JOIN VPRO_DPSI_INFO B
    ON A.PRD_CODE = B.PRD_CODE
  WHERE A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND A.HLD_DT <= C.valu_cnfm_dt
   AND B.AST_UNIT_CODE <> '000575_0005752'


