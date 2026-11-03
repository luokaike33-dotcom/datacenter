------------------------------------------------------------------------
  -- 模块名称：产品存款条款信息
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

alter table ${dwd_db}.fin_prd_dpsi_pro drop if exists partition (sys_rs_id='DYCF') ;

WITH VPRO_DPSI_INFO AS
(SELECT DISTINCT A.PRD_CODE,A.AST_UNIT_CODE,A.PFL_CODE
FROM ${dwd_db}.PRO_DPSI_INFO A
)
insert into ${dwd_db}.fin_prd_dpsi_pro partition(sys_rs_id)
(
prd_code
,secu_id
,typ_code
,typ_codei
,typ_codeii
,var_secu_id
,fir_tnv_dt
,end_tnv_dt
,curr_code
,dpsi_val
,dpsi_rat
,ref_rat
,adj_rat
,inta_days
,pay_freq
,int_meth
,inta_rule
,intp_mode
,dpsi_bnk_code
,dpsi_bnk_name
,widrl_flag
,avl_ely_widrl_dt
,turn_cal
,dpsi_no
,busi_date
,task_rs_id
,dm_created_time
,var_matu
,dm_src_info
,dpsi_code
,sys_rs_id
)
SELECT B.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.VAR_SECU_ID AS VAR_SECU_ID, --品种代码
       A.FIR_TNV_DT AS FIR_TNV_DT, --首次成交日期
       A.END_TNV_DT AS END_TNV_DT, --到期成交日期
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.DPSI_VAL AS DPSI_VAL, --存款金额
       A.DPSI_RAT AS DPSI_RAT, --存款利率
       A.REF_RAT AS REF_RAT, --基准利率
       A.ADJ_RAT AS ADJ_RAT, --调整利率
       A.INTA_DAYS AS INTA_DAYS, --计息天数
       A.PAY_FREQ AS PAY_FREQ, --付息频率（N次/年）
       A.INT_METH AS INT_METH, --利率类型
       A.INTA_RULE AS INTA_RULE, --计息规则
       A.INTP_MODE AS INTP_MODE, --付息方式
       A.DPSI_BNK_CODE AS DPSI_BNK_CODE, --存款银行代码
       A.DPSI_BNK_NAME AS DPSI_BNK_NAME, --存款银行名称
       A.WIDRL_FLAG AS WIDRL_FLAG, --支取标志
       A.AVL_ELY_WIDRL_DT AS AVL_ELY_WIDRL_DT, --可提前支取日期
       A.TURN_CAL AS TURN_CAL, --倒置算法
       A.DPSI_NO AS DPSI_NO, --存单编号
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_dpsi_pro_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS var_matu, --品种期限
	     'FIN_PRD_DPSI_PRO' AS dm_src_info,
	     NULL AS dpsi_code, --存款代码
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_DPSI_PRO A
  LEFT JOIN VPRO_DPSI_INFO B
    ON A.PRD_CODE = B.PRD_CODE
  WHERE A.sys_rs_id IN ('YSSFA45','yssgz25')
  AND b.AST_UNIT_CODE <> '000575_0005752'