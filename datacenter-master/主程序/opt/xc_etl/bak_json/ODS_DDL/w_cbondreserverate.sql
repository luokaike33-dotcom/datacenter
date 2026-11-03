drop table if exists ty_ods.w_cbondreserverate;
create table if not exists ty_ods.w_cbondreserverate
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  s_info_reserveratetype string comment '准备金率品种',
  b_info_rate decimal(20,4) comment '准备金率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



