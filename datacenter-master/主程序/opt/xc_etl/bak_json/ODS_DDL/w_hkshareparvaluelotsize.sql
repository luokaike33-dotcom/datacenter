drop table if exists ty_ods.w_hkshareparvaluelotsize;
create table if not exists ty_ods.w_hkshareparvaluelotsize
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '变动日期',
  s_info_parvalue decimal(24,8) comment '面值',
  s_info_tradeunit decimal(20,4) comment '交易单位',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



