-----------------------------------------------------------------------
-- 模块名称：交易日历偏移日期提前计算 (交易日)（目前取前后3个偏移日）(离线)
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

alter table ${dwd_db}.pub_tradeday_offset_trade drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.pub_tradeday_offset_trade partition (sys_rs_id)
(
    dt, --日期
    mkt_no, --市场代码
    pre_0_dt, --往前偏移0天
    pre_1_dt, --往前偏移1天
    pre_2_dt, --往前偏移2天
    pre_3_dt, --往前偏移3天
    pre_4_dt, --往前偏移4天
    aft_0_dt, --往后偏移0天
    aft_1_dt, --往后偏移1天
    aft_2_dt, --往后偏移2天
    aft_3_dt, --往后偏移3天
    aft_4_dt, --往后偏移4天
    busi_date,-- bigint 业务日期
    task_rs_id,-- varchar2(100) 任务来源标识
    dm_created_time,-- timestamp 数据中台创建时间
    sys_rs_id-- varchar2(50) 系统来源标识
)
--工作日计算
select
    t3.l_date as dt,
    t3.c_market_no as mkt_no,
	l_date as pre_0_dt,
    lag(t3.l_date,1,null) over(partition by t3.c_market_no order by t3.l_date) as pre_1_dt,
    lag(t3.l_date,2,null) over(partition by t3.c_market_no order by t3.l_date) as pre_2_dt,
    lag(t3.l_date,3,null) over(partition by t3.c_market_no order by t3.l_date) as pre_3_dt,
    lag(t3.l_date,4,null) over(partition by t3.c_market_no order by t3.l_date) as pre_4_dt,
	l_date as aft_0_dt,
    lead(t3.l_date,1,null) over(partition by t3.c_market_no order by t3.l_date) as aft_1_dt,
    lead(t3.l_date,2,null) over(partition by t3.c_market_no order by t3.l_date) as aft_2_dt,
    lead(t3.l_date,3,null) over(partition by t3.c_market_no order by t3.l_date) as aft_3_dt,
    lead(t3.l_date,4,null) over(partition by t3.c_market_no order by t3.l_date) as aft_4_dt,
    ${current_date} as BUSI_DATE,
    'pub_tradeday_offset_trade_1' as TASK_RS_ID,
    CURRENT_TIMESTAMP as DM_CREATED_TIME,
    'O3' as SYS_RS_ID
from (
         select
             t.l_date,
             t2.c_market_no
         from ${ods_db}.o3_tmarkettradeday t
                  join ${ods_db}.o3_tmarketinfo t2
                       on t.vc_tradeday_type = t2.vc_tradeday_type
         where t.c_trade_flag in ('1','3')
     ) t3

union all
--周末和节假日计算
select
l_date,
c_market_no,

case when c_trade_flag_pre = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else pre_0_dt end as pre_0_dt,
case when c_trade_flag_pre = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag_pre = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag_pre = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag_pre = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag_aft = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else aft_0_dt end as aft_0_dt,
case when c_trade_flag_aft = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag_aft = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag_aft = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag_aft = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt,
    ${current_date} as BUSI_DATE,
    'pub_tradeday_offset_trade_2' as TASK_RS_ID,
    CURRENT_TIMESTAMP as DM_CREATED_TIME,
    'O3' as SYS_RS_ID
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (
select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (

select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(pre_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(aft_0_dt,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (
select
l_date,
c_market_no,
c_trade_flag,
case when c_trade_flag = 2 then lag(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_pre,
case when c_trade_flag = 2 then lead(c_trade_flag,1,null) over(partition by c_market_no order by l_date) else c_trade_flag end as c_trade_flag_aft,

case when c_trade_flag = 2 then lag(l_date,1,null) over(partition by c_market_no order by l_date) else l_date end as pre_0_dt,
case when c_trade_flag = 2 then lag(pre_1_dt,1,null) over(partition by c_market_no order by l_date) else pre_1_dt end as pre_1_dt,
case when c_trade_flag = 2 then lag(pre_2_dt,1,null) over(partition by c_market_no order by l_date) else pre_2_dt end as pre_2_dt,
case when c_trade_flag = 2 then lag(pre_3_dt,1,null) over(partition by c_market_no order by l_date) else pre_3_dt end as pre_3_dt,
case when c_trade_flag = 2 then lag(pre_4_dt,1,null) over(partition by c_market_no order by l_date) else pre_4_dt end as pre_4_dt,
case when c_trade_flag = 2 then lead(l_date,1,null) over(partition by c_market_no order by l_date) else l_date end as aft_0_dt,
case when c_trade_flag = 2 then lead(aft_1_dt,1,null) over(partition by c_market_no order by l_date) else aft_1_dt end as aft_1_dt,
case when c_trade_flag = 2 then lead(aft_2_dt,1,null) over(partition by c_market_no order by l_date) else aft_2_dt end as aft_2_dt,
case when c_trade_flag = 2 then lead(aft_3_dt,1,null) over(partition by c_market_no order by l_date) else aft_3_dt end as aft_3_dt,
case when c_trade_flag = 2 then lead(aft_4_dt,1,null) over(partition by c_market_no order by l_date) else aft_4_dt end as aft_4_dt
from (
select
    t3.l_date ,
    t3.c_market_no ,c_trade_flag,
        lag(t3.l_date,1,null) over(partition by t3.c_market_no order by t3.l_date) as pre_1_dt,
        lag(t3.l_date,2,null) over(partition by t3.c_market_no order by t3.l_date) as pre_2_dt,
        lag(t3.l_date,3,null) over(partition by t3.c_market_no order by t3.l_date) as pre_3_dt,
        lag(t3.l_date,4,null) over(partition by t3.c_market_no order by t3.l_date) as pre_4_dt,
        lead(t3.l_date,1,null) over(partition by t3.c_market_no order by t3.l_date) as aft_1_dt,
        lead(t3.l_date,2,null) over(partition by t3.c_market_no order by t3.l_date) as aft_2_dt,
        lead(t3.l_date,3,null) over(partition by t3.c_market_no order by t3.l_date) as aft_3_dt,
        lead(t3.l_date,4,null) over(partition by t3.c_market_no order by t3.l_date) as aft_4_dt

from (
         select
             t.l_date,
             t2.c_market_no,c_trade_flag
         from ${ods_db}.o3_tmarkettradeday t
                  join ${ods_db}.o3_tmarketinfo t2
                       on t.vc_tradeday_type = t2.vc_tradeday_type
     ) t3
) t4
) t41
) t42
) t43
) t44
) t45
) t46
) t47
) t48
) t49
) t410
) t411
) t5
where c_trade_flag = 2

     ;