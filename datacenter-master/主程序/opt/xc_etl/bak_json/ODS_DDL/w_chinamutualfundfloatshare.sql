drop table if exists ty_ods.w_chinamutualfundfloatshare;
create table if not exists ty_ods.w_chinamutualfundfloatshare
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  f_unit_floatshare decimal(20,4) comment '场内份额(份)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



