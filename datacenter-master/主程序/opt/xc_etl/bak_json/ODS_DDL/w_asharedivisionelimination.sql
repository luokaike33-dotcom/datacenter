drop table if exists ty_ods.w_asharedivisionelimination;
create table if not exists ty_ods.w_asharedivisionelimination
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_dq_resumpdate string comment '实施复牌日',
  s_dq_adjfactor decimal(20,4) comment '复权因子',
  s_dq_resump_preclose decimal(20,4) comment '复牌日昨收盘价',
  s_dq_preclose decimal(20,4) comment '昨收盘价(流通股除权)',
  s_dq_factor decimal(20,8) comment '对价因子',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



