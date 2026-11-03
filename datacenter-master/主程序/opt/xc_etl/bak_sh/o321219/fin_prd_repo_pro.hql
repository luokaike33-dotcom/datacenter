------------------------------------------------------------------------
  -- 模块名称：产品回购条款信息
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

alter table ${dwd_db}.fin_prd_repo_pro drop if exists partition (sys_rs_id='DYCF') ;

insert into ${dwd_db}.fin_prd_repo_pro partition(sys_rs_id)
(
prd_code
,secu_id
,chi_name
,typ_code
,typ_codei
,typ_codeii
,repo_trd_typ
,var_secu_id
,secu_var
,exch_code
,repo_days
,clr_sped
,inta_days
,inta_days_y
,fir_tnv_dt
,end_tnv_dt
,fir_deli_dt
,end_deli_dt
,pos_id
,tnv_vol
,repo_rat
,curr_code
,tnv_val
,buyb_val
,repo_intr
,repo_fee
,cutp_code
,cutp_name
,tnv_no
,sett_meth_sq
,sett_meth_dq
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,sys_rs_id
)
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T0.SECU_ID AS SECU_ID, --证券编码
       T2.SECU_SHT AS CHI_NAME, --证券中文名称
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T0.REPO_TRD_MODE AS REPO_TRD_TYP, --回购交易方式
       T0.VAR_SECU_ID AS VAR_SECU_ID, --品种代码
       NULL AS SECU_VAR, --证券品种
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.REPO_DAYS AS REPO_DAYS, --回购天数
       T0.CLR_SPED AS CLR_SPED, --清算速度
       T0.INTA_DAYS AS INTA_DAYS, --计息天数
       365 AS INTA_DAYS_Y, --年计息天数
       T0.TNV_DT AS FIR_TNV_DT, --首次成交日期
       T0.BUYB_DT AS END_TNV_DT, --到期成交日期
       T0.FIR_DELI_DT AS FIR_DELI_DT, --首次交割日期
       T0.END_DELI_DT AS END_DELI_DT, --到期交割日期
       T0.POS_ID AS POS_ID, --多空标志
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.REPO_RAT AS REPO_RAT, --回购利率
       'CNY' AS CURR_CODE, --货币类型
       CASE WHEN T0.POS_ID = 'L' THEN T0.TNV_VAL ELSE -T0.TNV_VAL END AS TNV_VAL, --成交金额
       CASE WHEN T0.POS_ID = 'L' THEN T0.BUYB_VAL ELSE -T0.BUYB_VAL END AS BUYB_VAL, --购回金额
       CASE WHEN T0.POS_ID = 'L' THEN T0.REPO_INTR ELSE -T0.REPO_INTR END AS REPO_INTR, --回购利息
       CASE WHEN T0.POS_ID = 'L' THEN T0.REPO_FEE ELSE -T0.REPO_FEE END AS REPO_FEE, --回购费用
       T0.TRD_CNTP_ID AS CUTP_CODE, --对手方代码
       T1.CNTP_SHT AS CUTP_NAME, --对手方名称
       T0.TNV_NO AS TNV_NO, --成交编号
       '3' AS SETT_METH_SQ, --首期结算方式
       '3' AS SETT_METH_DQ, --到期结算方式
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_repo_pro_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'PRO_REPO_TNV_INFO' AS dm_src_info,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.PRO_REPO_TNV_INFO T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3
   ON T0.AST_UNIT_CODE = T3.PRD_CODE
  LEFT JOIN ${dwd_db}.PTY_CUTP_INFO T1
    ON T0.TRD_CNTP_ID = T1.CUTP_ID
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
    ON T0.VAR_SECU_ID = T2.SECU_ID
  WHERE T0.sys_rs_id = 'O3'