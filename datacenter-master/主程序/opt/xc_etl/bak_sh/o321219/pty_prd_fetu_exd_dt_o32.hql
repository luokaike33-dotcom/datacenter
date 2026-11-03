------------------------------------------------------------------------
  -- 模块名称：产品特征时间序列扩展信息
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

truncate  table  ${dwd_db}.pty_prd_fetu_exd_dt_o32;

insert into ${dwd_db}.pty_prd_fetu_exd_dt_o32
(	prd_code, -- 产品代码
           dim_code, -- 属性代码
           dim_value, -- 属性值
           bgn_dt, -- 生效时间
           invl_dt -- 失效时间
)
 SELECT T0.VC_FUND_CODE AS PRD_CODE, --产品代码
             '1' AS DIM_CODE, -- 属性代码,产品类型
             T0.C_FUND_TYPE AS DIM_VALUE, -- 属性值
             19010101 AS BGN_DT, -- 生效时间
             20991231 AS INVL_DT -- 失效时间
        FROM ${ods_db}.O3_TFUNDINFO T0;