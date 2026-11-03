drop table if exists ty_ods.w_poolinitialstatistics;
create table if not exists ty_ods.w_poolinitialstatistics
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  dt string comment '日期',
  item_code bigint comment '统计项目代码',
  type string comment '统计类别',
  type_code bigint comment '统计指标代码',
  value decimal(24,8) comment '指标数据',
  unit string comment '指标单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



