set hive.vectorized.execution.enabled=false;
set hive.strict.checks.type.safety=false;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.execution.engine=spark;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=10000;
set hive.exec.max.created.files=10000;
set hive.merge.sparkfiles=true;
set hive.optimize.sort.dynamic.partition=true;
set hive.merge.orcfile.stripe.level=false;
set spark.memory.fraction=0.8;
set hive.exec.dynamic.partition=true;
set hive.crud.dynamic.partition=true;
set spark.driver.memory=4G;
set hive.auto.convert.join=true;

insert into ty_dwd.etl_signal VALUES ('WIND',1);
