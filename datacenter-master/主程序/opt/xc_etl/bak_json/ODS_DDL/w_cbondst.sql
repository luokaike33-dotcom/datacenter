drop table if exists ty_ods.w_cbondst;
create table if not exists ty_ods.w_cbondst
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_type_st string comment '特别处理类型代码',
  entry_dt string comment '实施日期',
  remove_dt string comment '撤消日期',
  reason string comment '实施原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



