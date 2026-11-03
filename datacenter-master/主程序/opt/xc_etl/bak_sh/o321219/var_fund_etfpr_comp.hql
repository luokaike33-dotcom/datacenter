------------------------------------------------------------------------
  -- 模块名称：ETF交易成份参数信息
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

alter table ${dwd_db}.var_fund_etfpr_comp drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.var_fund_etfpr_comp partition(p_dt,sys_rs_id)
(secu_id,trd_dt,comp_secu_id,pr_mode,stk_num,casub_sign,casub_prem_rat,subs_amt,redmp_amt,casub_amt,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT 
    concat(T0.VC_REPORT_CODE , '.FUND.' , (case when T1.C_MARKET_NO = '1' then 'SH' when T1.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID,--证券编码
    T0.L_DATE AS TRD_DT,--交易日期
	concat(T0.vc_stock_code , case when t2.c_asset_class = '2' then '.STK.' when t2.c_asset_class = '3' then '.BOND.' when t2.c_asset_class = '4' then '.FUND.' when t2.c_asset_class = '9' then '.FUT.' else '' end ,
		  (case when T0.C_MARKET_NO = '1' then 'SH'
                when T0.C_MARKET_NO = '2' then 'SZ'
                when T0.C_MARKET_NO = 'n' then 'SHSC'
                when T0.C_MARKET_NO = 'o' then 'SZSC'
			else ''
			end))
	AS COMP_SECU_ID,--成份股证券编码
    T0.C_EXEC_TYPE AS PR_MODE,--申赎方式
    T0.L_STOCK_AMOUNT AS STK_NUM,--股票数量
    case when UPPER(T0.C_CASH_TYPE) = 'Z' then '9' else T0.C_CASH_TYPE end as CASUB_SIGN,--现金替代标志
    T0.EN_PRICE_RATIO AS CASUB_PREM_RAT,--现金替代溢价比例
    T0.EN_PURCHASE_BALANCE AS SUBS_AMT,--申购替换金额
    T0.EN_REDEEM_BALANCE AS REDMP_AMT,--赎回替代金额
    0 AS CASUB_AMT,--固定替代金额(元)
    T0.L_DATE AS BUSI_DATE,--业务日期
    'var_fund_etfpr_comp_1' AS TASK_RS_ID,--任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	T0.L_DATE,
    'O3' AS SYS_RS_ID--源数据修改时间
  FROM ${ods_db}.O3_THISETFSTOCKLISTINFO  T0
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T1
  ON T0.vc_report_code = T1.VC_REPORT_CODE
  AND T1.c_asset_class = '4'
  and t0.l_date = t1.l_date
  left join ${ods_db}.O3_THISSTOCKINFO T2
  on t0.c_market_no = t2.c_market_no
  and t0.vc_stock_code = t2.VC_REPORT_CODE
  and t0.l_date = t2.l_date
 WHERE T0.P_DT BETWEEN ${beg_date} and ${end_date}

 union all

SELECT
    concat(T0.VC_REPORT_CODE , '.FUND.' , (case when T1.C_MARKET_NO = '1' then 'SH' when T1.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID,--证券编码
    T0.L_DATE AS TRD_DT,--交易日期
	concat(T0.vc_stock_code , case when t2.c_asset_class = '2' then '.STK.' when t2.c_asset_class = '3' then '.BOND.' when t2.c_asset_class = '4' then '.FUND.' when t2.c_asset_class = '9' then '.FUT.' else '' end ,
		  (case when T0.C_MARKET_NO = '1' then 'SH'
                when T0.C_MARKET_NO = '2' then 'SZ'
                when T0.C_MARKET_NO = 'n' then 'SHSC'
                when T0.C_MARKET_NO = 'o' then 'SZSC'
			else ''
			end))
	AS COMP_SECU_ID,--成份股证券编码
    T0.C_EXEC_TYPE AS PR_MODE,--申赎方式
    T0.L_STOCK_AMOUNT AS STK_NUM,--股票数量
    case when UPPER(T0.C_CASH_TYPE) = 'Z' then '9' else T0.C_CASH_TYPE end as CASUB_SIGN,--现金替代标志
    T0.EN_PRICE_RATIO AS CASUB_PREM_RAT,--现金替代溢价比例
    T0.EN_PURCHASE_BALANCE AS SUBS_AMT,--申购替换金额
    T0.EN_REDEEM_BALANCE AS REDMP_AMT,--赎回替代金额
    0 AS CASUB_AMT,--固定替代金额(元)
    T0.L_DATE AS BUSI_DATE,--业务日期
    'var_fund_etfpr_comp_2' AS TASK_RS_ID,--任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	T0.L_DATE,
    'O3' AS SYS_RS_ID--源数据修改时间
  FROM ${ods_db}.O3_TETFSTOCKLISTINFO  T0
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T1
  ON T0.vc_report_code = T1.VC_REPORT_CODE
  and t0.l_date = t1.l_date
  left join ${ods_db}.O3_TSTOCKINFO T2
  on t0.c_market_no = t2.c_market_no
  and t0.vc_stock_code = t2.VC_REPORT_CODE
  and t0.l_date = t2.l_date
  AND T1.c_asset_class = '4'
;