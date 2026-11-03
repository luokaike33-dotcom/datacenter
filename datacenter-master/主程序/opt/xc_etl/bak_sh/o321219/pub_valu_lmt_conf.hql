------------------------------------------------------------------------
  -- 模块名称：估值受限配置表
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


alter table ${dwd_db}.PUB_VALU_LMT_CONF drop if exists partition (sys_rs_id='O3');

insert into ${dwd_db}.PUB_VALU_LMT_CONF partition(sys_rs_id)
(
    valu_lmt_onum,--估值受限序号
    valu_clas,--估值类型
    lmt_maty,--受限期限
    lmt_rati,--受限比例
    busi_date,--业务日期
    task_rs_id,--任务来源标识
    dm_created_time,--数据中台创建时间
    sys_rs_id--系统来源标识
)
SELECT
    A.L_RESTRICTED_NO as VALU_LMT_ONUM,--估值受限序号
    A.C_VALUATION_TYPE as VALU_CLAS,--估值类型
    A.C_RESTRICTED_DATELIMIT as LMT_MATY,--受限期限
    A.EN_RESTRICTED_RATIO as LMT_RATI,--受限比例
    date_format(current_timestamp,'yyyyMMdd') as BUSI_DATE,--业务日期
    'pub_valu_lmt_conf_1' as TASK_RS_ID,--任务来源标识
    current_timestamp as DM_CREATED_TIME,--数据中台创建时间
    'O3' as SYS_RS_ID--系统来源标识
FROM ${ods_db}.o3_TRESTRICTEDTYPE A
;