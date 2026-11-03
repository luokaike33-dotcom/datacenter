------------------------------------------------------------------------
  -- 模块名称：产品证券锁定信息
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

alter table ${dwd_db}.pty_prd_secu_lock_info drop if exists partition (sys_rs_id='O3');

insert into ${dwd_db}.pty_prd_secu_lock_info partition(sys_rs_id)
(
    prd_code, --产品代码
    secu_id,  --证券编码
    lock_strt_date, --锁定开始日
    lock_end_date, --锁定结束日
    tot_lock_days, --总锁定天数
    busi_date, --业务日期
    task_rs_id, --任务来源标识
    dm_created_time, --数据中台创建时间
    sys_rs_id --系统来源标识
)
select
    nvl(T1.VC_FUND_CODE,-1)  AS PRD_CODE, --产品代码
    CASE
                       WHEN T2.C_ASSET_CLASS = '2' THEN
                        CONCAT(T2.VC_REPORT_CODE , '.STK.' , (CASE
                          WHEN T2.C_MARKET_NO = '1' THEN
                           'SH'
                          WHEN T2.C_MARKET_NO = '2' THEN
                           'SZ'
                          WHEN T2.C_MARKET_NO = 'n' then
                           'SHSC'
                          WHEN T2.C_MARKET_NO = 'o' THEN
                           'SZSC'
                          when T2.C_MARKET_NO = 'j' then (case when NVL(T2.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
                          when T2.C_MARKET_NO = 'r' then 'BJ'
                          else T2.C_MARKET_NO
                        END)) --股票
                       WHEN T2.C_ASSET_CLASS = '3' THEN
                        CONCAT(T2.VC_REPORT_CODE , '.BOND.' , (CASE
                          WHEN T2.C_MARKET_NO = '1' THEN
                           'SH'
                          WHEN T2.C_MARKET_NO = '2' THEN
                           'SZ'
                           WHEN T2.C_MARKET_NO = '6' then
                           'NONE'
                           WHEN T2.C_MARKET_NO = '5' then
                           'YHJ'
                           else T2.C_MARKET_NO
                        END)) --债券
                       WHEN T2.C_ASSET_CLASS = '4' THEN
                        CONCAT(T2.VC_REPORT_CODE , '.FUND.' , (CASE
                          WHEN T2.C_MARKET_NO = '1' THEN
                           'SH'
                          WHEN T2.C_MARKET_NO = '2' THEN
                           'SZ'
                          WHEN T2.C_MARKET_NO = '6' THEN
                          'NONE'
                          else T2.C_MARKET_NO
                        END)) --基金
                        WHEN T2.C_ASSET_CLASS = '6' THEN
                         CONCAT(T2.VC_REPORT_CODE , '.REPO.' , (CASE
                          WHEN T2.C_MARKET_NO = '5' THEN
                            'YHJ'
                          WHEN T2.C_MARKET_NO = '2' THEN
                            'SZ'
                          WHEN T2.C_MARKET_NO = '1' THEN
                            'SH'
                        END)) --回购
                       WHEN T2.C_ASSET_CLASS = '7' THEN
                        CONCAT(T2.VC_REPORT_CODE , '.WRNT.' , (CASE
                          WHEN T2.C_MARKET_NO = 'n' then
                           'SHSC'
                          WHEN T2.C_MARKET_NO = 'o' THEN
                           'SZSC'
                           else T2.C_MARKET_NO
                        END)) --权证
                       WHEN T2.C_ASSET_CLASS = '9' THEN
                        CONCAT(T2.VC_REPORT_CODE , '.FUT.' , (CASE
                          WHEN T2.C_MARKET_NO = '1' THEN
                           'SH'
                          WHEN T2.C_MARKET_NO = '2' THEN
                           'SZ'
                          WHEN T2.C_MARKET_NO = '7' THEN
                           'CFFEX'
                          else T2.C_MARKET_NO
                        END))
                       else A.VC_INTER_CODE
                     END AS SECU_ID, --证券编码
    A.L_LOCKSTART_DATE as LOCK_STRT_DATE, --锁定开始日
    A.L_LOCKEND_DATE as LOCK_END_DATE, --锁定结束日
    A.L_TOTAL_LOCK_DAYS as TOT_LOCK_DAYS, --总锁定天数
    date_format(current_timestamp,'yyyyMMdd') as BUSI_DATE, --业务日期
    'pty_prd_secu_lock_info_1' as TASK_RS_ID, --任务来源标识
    current_timestamp as DM_CREATED_TIME, --数据中台创建时间
    'O3' as SYS_RS_ID --系统来源标识
FROM  ${ods_db}.o3_TSTOCKLOCKDAYS AS A
LEFT JOIN ${ods_db}.o3_TFUNDINFO T1 ON A.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.o3_TSTOCKINFO T2 ON A.VC_INTER_CODE = T2.VC_INTER_CODE
INNER JOIN ${dwd_db}.VAR_SCR_RELA AS B ON B.SYS_ID = 1 AND B.SRC_SCR_INCD = A.VC_INTER_CODE AND B.SRC_SCR_INCD_SORT = 'O32_BASI'
where T2.C_ASSET_CLASS in ('2','3','4','6','7','9');