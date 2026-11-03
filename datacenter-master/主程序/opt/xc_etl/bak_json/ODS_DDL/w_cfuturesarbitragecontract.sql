drop table if exists ty_ods.w_cfuturesarbitragecontract;
create table if not exists ty_ods.w_cfuturesarbitragecontract
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_ralatedcode string comment '关联证券Wind代码',
  s_relation_typcode bigint comment '关系类型代码',
  s_info_effective_dt string comment '生效日期',
  s_info_invalid_dt string comment '失效日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



