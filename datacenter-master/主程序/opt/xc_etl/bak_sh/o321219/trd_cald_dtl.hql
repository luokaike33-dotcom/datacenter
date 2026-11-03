-----------------------------------------------------------------------
-- 模块名称：交易日历明细表
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

ALTER TABLE ${dwd_db}.trd_cald_dtl
     DROP IF EXISTS PARTITION (sys_rs_id = 'O3');

INSERT INTO ${dwd_db}.trd_cald_dtl PARTITION (sys_rs_id)
(cald_id,
 cald_year,
 cald_date,
 cald_week,
 is_trd_dt,
 lst_cald_date,
 next_cald_date,
 is_set_dt,
 busi_date,
 task_rs_id,
 dm_created_time,
 sys_rs_id)
SELECT (CASE
             WHEN t3.vc_market_char = 'SS' THEN
                  '1'
             WHEN t3.vc_market_char = 'SZ' THEN
                  '2'
             WHEN t3.vc_market_char = 'GG' THEN
                  '8'
             WHEN t3.vc_market_char = 'SG' THEN
                  '6'
             WHEN t3.vc_market_char = 'YH' THEN
                  '3'
        END) AS cald_id,
       SUBSTR(t3.l_date, 0, 4) AS cald_year,
       t3.l_date AS cald_date,
       t3.l_week AS cald_week,
       (CASE
             WHEN t3.c_trade_flag IN ('1', '3') THEN
                  '1'
             ELSE
                  '0'
        END) AS is_trd_dt,
       null AS lst_cald_date,
       null AS next_cald_date,
       --LAG(t3.l_date, 1, NULL) OVER (PARTITION BY t3.vc_market_char ORDER BY t3.l_date) AS lst_cald_date,
       --LEAD(t3.l_date, 1, NULL) OVER (PARTITION BY t3.vc_market_char ORDER BY t3.l_date) AS next_cald_date,
       (CASE
             WHEN t3.c_trade_flag = '1' THEN
                  '1'
             ELSE
                  '0'
        END) AS is_set_dt,
       ${current_date} AS busi_date,
       'trd_cald_dtl_1' AS task_rs_id,
       CURRENT_TIMESTAMP AS dm_created_time,
       'O3' AS sys_rs_id
  FROM (SELECT t1.l_date,
               t1.l_week,
               t2.vc_market_char,
               t1.c_trade_flag
          FROM ${ods_db}.o3_tmarkettradeday t1
               JOIN ${ods_db}.o3_tmarketinfo t2
                      ON t1.vc_tradeday_type = t2.vc_tradeday_type
         WHERE t2.vc_market_char IN ('SS', 'SZ', 'GG', 'SG', 'YH')
           AND t1.c_trade_flag IN ('1', '2', '3')
       -- trade_flag 1交易日&交收日, 2双非自然日, 3仅交易日
       -- 'SS'上交所, 'SZ'深交所, 'GG'港股通（沪）, 'SG'港股通（深）, 'YH'银行间
  ) t3