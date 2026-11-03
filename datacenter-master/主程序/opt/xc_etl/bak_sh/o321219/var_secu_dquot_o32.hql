------------------------------------------------------------------------
  -- 模块名称：证券日行情
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

alter table ${dwd_db}.var_secu_dquot_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id = 'O3') ;

insert into ${dwd_db}.var_secu_dquot_o32 partition(p_dt,sys_rs_id)
(secu_id,trd_dt,prev_cls_prc,open_prc,high_prc,low_prc,avg_price,cls_prc,clg_prc,flr_prc,tnv_vol,tnv_val,curr_code,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT CASE
            WHEN T0.C_ASSET_CLASS IN ('2') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.STK.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = 'n' THEN 'SHSC'
                             WHEN T0.C_MARKET_NO = 'o' THEN 'SZSC'
                             WHEN T0.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T0.VC_LAYERING,'0') = '2' THEN 'BJ' ELSE 'SB' END
                             WHEN T0.C_MARKET_NO = 'r' THEN 'BJ' END)
            WHEN T0.C_ASSET_CLASS IN ('3') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.BOND.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = '5' THEN 'YHJ' END)
            WHEN T0.C_ASSET_CLASS IN ('4') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.FUND.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = '6' THEN 'NONE' END)
            WHEN T0.C_ASSET_CLASS IN ('9') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.FUT.' ,
                        CASE WHEN T0.C_MARKET_NO = '7' THEN 'CFFEX'
                             WHEN T0.C_MARKET_NO = '3' THEN 'SHFE'
                             WHEN T0.C_MARKET_NO = '4' THEN 'CZCE'
                             WHEN T0.C_MARKET_NO = '9' THEN 'DCE' END)
       END AS SECU_ID, --证券编码
     T0.L_DATE AS TRD_DT, --交易日期
     T0.EN_YESTERDAY_CLOSE_PRICE AS PREV_CLS_PRC, --昨收盘
     T0.EN_OPEN_PRICE AS OPEN_PRC, --今开盘
     T0.EN_MAX_PRICE AS HIGH_PRC, --最高价
     T0.EN_MIN_PRICE AS LOW_PRC, --最低价
     T0.EN_AVG_PRICE AS AVG_PRICE, --均价（VWAP）
     T0.EN_LAST_PRICE AS CLS_PRC, --今收盘
     T0.EN_UPLIMITED_PRICE AS CLG_PRC, --涨停价
     T0.EN_DOWNLIMITED_RATIO AS FLR_PRC, --跌停价
     T0.L_MARKET_DEAL_AMOUNT AS TNV_VOL, --成交量
     T0.EN_MARKET_DEAL_BALANCE AS TNV_VAL, --成交额（元）
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     ${end_date} AS BUSI_DATE, --业务日期
     'var_secu_dquot_o32_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISSTOCKINFO T0
 WHERE T0.C_ASSET_CLASS IN ('2', '3', '4','9') --股票、债券、基金、期货
   AND T0.P_dt BETWEEN ${beg_date} AND ${end_date}
 UNION ALL
SELECT CASE
            WHEN T0.C_ASSET_CLASS IN ('2') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.STK.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = 'n' THEN 'SHSC'
                             WHEN T0.C_MARKET_NO = 'o' THEN 'SZSC'
                             WHEN T0.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T0.VC_LAYERING,'0') = '2' THEN 'BJ' ELSE 'SB' END
                             WHEN T0.C_MARKET_NO = 'r' THEN 'BJ' END)
            WHEN T0.C_ASSET_CLASS IN ('3') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.BOND.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = '5' THEN 'YHJ' END)
            WHEN T0.C_ASSET_CLASS IN ('4') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.FUND.' ,
                        CASE WHEN T0.C_MARKET_NO = '1' THEN 'SH'
                             WHEN T0.C_MARKET_NO = '2' THEN 'SZ'
                             WHEN T0.C_MARKET_NO = '6' THEN 'NONE' END)
            WHEN T0.C_ASSET_CLASS IN ('9') THEN
                 CONCAT(T0.VC_REPORT_CODE , '.FUT.' ,
                        CASE WHEN T0.C_MARKET_NO = '7' THEN 'CFFEX'
                             WHEN T0.C_MARKET_NO = '3' THEN 'SHFE'
                             WHEN T0.C_MARKET_NO = '4' THEN 'CZCE'
                             WHEN T0.C_MARKET_NO = '9' THEN 'DCE' END)
       END AS SECU_ID, --证券编码
     T0.L_DATE AS TRD_DT, --交易日期
     T0.EN_YESTERDAY_CLOSE_PRICE AS PREV_CLS_PRC, --昨收盘
     T0.EN_OPEN_PRICE AS OPEN_PRC, --今开盘
     T0.EN_MAX_PRICE AS HIGH_PRC, --最高价
     T0.EN_MIN_PRICE AS LOW_PRC, --最低价
     T0.EN_AVG_PRICE AS AVG_PRICE, --均价（VWAP）
     T0.EN_LAST_PRICE AS CLS_PRC, --今收盘
     T0.EN_UPLIMITED_PRICE AS CLG_PRC, --涨停价
     T0.EN_DOWNLIMITED_RATIO AS FLR_PRC, --跌停价
     T0.L_MARKET_DEAL_AMOUNT AS TNV_VOL, --成交量
     T0.EN_MARKET_DEAL_BALANCE AS TNV_VAL, --成交额（元）
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     ${current_date} AS BUSI_DATE, --业务日期
     'var_secu_dquot_o32_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TSTOCKINFO T0
 WHERE T0.C_ASSET_CLASS IN ('2', '3', '4','9') --股票、债券、基金、期货
   AND T0.L_DATE = ${current_date}
;