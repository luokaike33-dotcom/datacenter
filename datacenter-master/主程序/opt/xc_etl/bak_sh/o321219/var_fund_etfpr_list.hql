------------------------------------------------------------------------
  -- 模块名称：ETF交易清单参数信息
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

alter table ${dwd_db}.var_fund_etfpr_list drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.var_fund_etfpr_list partition(p_dt,sys_rs_id)
(secu_id,trd_dt,pr_mode,cash_dif,min_praset,esti_cash,casub_lmt,min_pru_unit,prpermit,con_num,pcs_cap,rdpt_cap,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT 
    concat(T0.VC_REPORT_CODE , '.FUND.' , (case when T0.C_MARKET_NO = '1' then 'SH' when T0.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID,
    T0.L_DATE AS TRD_DT,
    T0.C_EXEC_TYPE AS PR_MODE,
    T0.EN_CASH AS CASH_DIF,
    cast(T0.L_REPORT_UNIT as double) * cast(T0.EN_NAV as double) AS MIN_PRASET,
    T0.EN_ESTIMATECASH AS ESTI_CASH,
    T0.EN_MAXCASH_RATIO AS CASUB_LMT,
    T0.L_REPORT_UNIT AS MIN_PRU_UNIT,
    T0.C_CREATIONREDEM_TYPE AS PRPERMIT,
    T0.L_RECORD_NUM AS CON_NUM,
    T0.L_CREATION_LIMIT_PERUSER AS PCS_CAP,
    T0.L_REDEMPTION_LIMIT_PERUSER AS RDPT_CAP,
    T0.L_DATE AS BUSI_DATE,
    'var_fund_etfpr_list_1' AS TASK_RS_ID,
    CURRENT_TIMESTAMP AS DM_CREATED_TIME,
	T0.L_DATE,
    'O3' AS SYS_RS_ID--源数据修改时间
  FROM ${ods_db}.O3_THISETFBASICINFO T0
 WHERE T0.P_DT BETWEEN ${beg_date} and ${end_date}   
 
 union all
 
SELECT 
    concat(T0.VC_REPORT_CODE , '.FUND.' , (case when T0.C_MARKET_NO = '1' then 'SH' when T0.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID,
    T0.L_DATE AS TRD_DT,
    T0.C_EXEC_TYPE AS PR_MODE,
    T0.EN_CASH AS CASH_DIF,
    cast(T0.L_REPORT_UNIT  as double) * cast(T0.EN_NAV as double) AS MIN_PRASET,
    T0.EN_ESTIMATECASH AS ESTI_CASH,
    T0.EN_MAXCASH_RATIO AS CASUB_LMT,
    T0.L_REPORT_UNIT AS MIN_PRU_UNIT,
    T0.C_CREATIONREDEM_TYPE AS PRPERMIT,
    T0.L_RECORD_NUM AS CON_NUM,
    T0.L_CREATION_LIMIT_PERUSER AS PCS_CAP,
    T0.L_REDEMPTION_LIMIT_PERUSER AS RDPT_CAP,
    T0.L_DATE AS BUSI_DATE,
    'var_fund_etfpr_list_2' AS TASK_RS_ID,
    CURRENT_TIMESTAMP AS DM_CREATED_TIME,
	T0.L_DATE,
    'O3' AS SYS_RS_ID--源数据修改时间
  FROM ${ods_db}.O3_TETFBASICINFO T0
;