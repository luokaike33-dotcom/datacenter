drop table if exists ty_ods.w_cmfnavoperationrecord;
create table if not exists ty_ods.w_cmfnavoperationrecord
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  price_date string comment '净值截止日期',
  handle_date string comment '处理日期',
  handle_action string comment '处理动作',
  f_nav_old decimal(11,6) comment '调整前净值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



