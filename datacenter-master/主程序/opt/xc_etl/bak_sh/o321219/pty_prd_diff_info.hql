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
----set spark.driver.memory=4G;
----set hive.auto.convert.join=true;

insert overwrite table ${dwd_db}.pty_prd_diff_info 
select t1.c_port_code as prd_code,t1.d_biz as stat_date,nvl(t2.l_date,20991231) as end_date
from (
select min(cast(replace(d_biz,'-','') as bigint)) as d_biz,c_port_code 
from ${ods_db}.fa45_vn_financial_val  t
group by t.c_port_code
) t1
left join (
select t2.vc_fund_code,min(t1.l_date) as l_date
from ${ods_db}.o3_thisfundasset t1
left join ${ods_db}.o3_tfundinfo t2
on t1.l_fund_id = t2.l_fund_id
WHERE T1.EN_FUND_VALUE <> 0
group by t2.vc_fund_code
) t2
on t1.c_port_code = t2.vc_fund_code
where t1.d_biz <> nvl(t2.l_date,20991231)
and length(t1.c_port_code) = 6