set hive.vectorized.execution.enabled=false;
set hive.strict.checks.type.safety=false;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.execution.engine=spark;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=10000;
set hive.exec.max.created.files=10000;
set hive.auto.convert.join=true;
set hive.merge.sparkfiles=true;
set hive.optimize.sort.dynamic.partition=true;
set hive.merge.orcfile.stripe.level=false;
set spark.memory.fraction=0.8;
set hive.exec.dynamic.partition=true;
set hive.crud.dynamic.partition=true;
set spark.serializer=org.apache.spark.serializer.KryoSerializer;
set hive.cbo.enable=false;


alter table ${dwd_db}.dwd_updatetime_flag drop if exists partition(table_names='${tablename}');

WITH tmp_mark AS (
select 
'${current_date}' as busi_date ,  
'${tablename}' as  table_name,
'ALL' AS sys_rs_id, 
current_timestamp() as update_time,
'${tablename}' as  table_names
)

insert into table ${dwd_db}.dwd_updatetime_flag partition(table_names)
select * from tmp_mark;

