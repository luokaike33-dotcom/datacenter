------------------------------------------------------------------------
  -- 模块名称：产品转融通借出信息
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

alter table ${dwd_db}.fin_prd_zrt_lend drop if exists partition (sys_rs_id='DYCF') ;

insert into ${dwd_db}.fin_prd_zrt_lend partition(sys_rs_id)
(
prd_code
,secu_id
,typ_code
,typ_codei
,typ_codeii
,secu_var
,exch_code
,subj_secu
,fir_tnv_dt
,end_tnv_dt
,curr_code
,contr_val
,lend_rate
,lend_intr
,inta_days
,actl_days
,inta_days_y
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,orig_tnv_dt
,refc_repy_flag
,res_flag
,refc_cont_clas
,cont_id
,cont_vol
,refc_secu_prc
,trd_chag
,sys_rs_id
)
SELECT A.AST_UNIT_CODE AS PRD_CODE, --产品代码 
       A.SECU_ID AS SECU_ID, --证券编码
       'REFC' AS TYP_CODE, --证券类别代码（大类）
       'REFC102' AS TYP_CODEI, --证券类别代码（中类）
       'REFC10201' AS TYP_CODEII, --证券类别代码（细类）
       CONCAT('ZRT.REFC.' , B.EXCH_CODE)  AS SECU_VAR, --证券品种
       B.EXCH_CODE  AS EXCH_CODE, --交易市场代码
       A.REFC_SECU_ID AS SUBJ_SECU, --标的交易证券
       A.TNV_DT AS FIR_TNV_DT, --首次成交日期
       A.END_DT AS END_TNV_DT, --到期成交日期
       'CNY' AS CURR_CODE, --货币类型
       A.CONT_VAL AS CONTR_VAL, --合同金额
       A.REFC_FEER AS LEND_RATE, --借出利率
       A.REFE_INTR AS LEND_INTR, --借出利息
       A.REFC_CONT_DAYS AS INTA_DAYS, --计息天数
       A.INTA_DAYS AS ACTL_DAYS, --实际占款天数
       360 AS INTA_DAYS_Y, --年计息天数
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_zrt_lend_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'PRO_REFC_INFO' AS dm_src_info,	   
       A.ORIG_TNV_DT AS ORIG_TNV_DT, --原成交日期
       A.REFC_REPY_FLAG AS REFC_REPY_FLAG, --转融通偿还标志	   
       A.RES_FLAG AS RES_FLAG, --限售标识
       A.REFC_CONT_CLAS AS REFC_CONT_CLAS, --转融通合约类型
       A.CONT_ID AS CONT_ID, --合约编码
       A.CONT_VOL AS CONT_VOL, --合约数量
       A.REFC_SECU_PRC AS REFC_SECU_PRC, --转融通证券价格
       A.TRD_CHAG AS TRD_CHAG, --交易手续费
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.PRO_REFC_INFO A --转融通合约表
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO C
   ON A.AST_UNIT_CODE = C.PRD_CODE
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO B --证券基本信息
    ON A.REFC_SECU_ID = B.SECU_ID
  WHERE A.sys_rs_id = 'O3'