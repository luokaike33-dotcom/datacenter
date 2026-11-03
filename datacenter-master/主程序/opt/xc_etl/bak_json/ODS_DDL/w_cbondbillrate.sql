drop table if exists ty_ods.w_cbondbillrate;
create table if not exists ty_ods.w_cbondbillrate
(
  object_id string comment '对象ID',
  b_info_ratetype string comment '利率类型',
  trade_dt string comment '交易日期',
  b_info_rate decimal(20,6) comment '利率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



