drop table if exists ty_ods.w_abstransaction;
create table if not exists ty_ods.w_abstransaction
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '转让日期',
  s_inc_initexecpri decimal(20,4) comment '转让价格',
  transferred decimal(20,4) comment '转让数量(手)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



