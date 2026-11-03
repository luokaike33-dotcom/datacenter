drop table if exists ty_ods.w_cbondcalendar;
create table if not exists ty_ods.w_cbondcalendar
(
  object_id string comment '对象ID',
  trade_days string comment '交易日',
  s_info_exchmarket string comment '交易所英文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



