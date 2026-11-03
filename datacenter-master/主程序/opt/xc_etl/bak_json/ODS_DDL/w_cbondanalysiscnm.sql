drop table if exists ty_ods.w_cbondanalysiscnm;
create table if not exists ty_ods.w_cbondanalysiscnm
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  anal_dirty decimal(20,4) comment '估价全价',
  anal_net decimal(20,4) comment '估价净价',
  anal_yield decimal(20,4) comment '估价收益率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



