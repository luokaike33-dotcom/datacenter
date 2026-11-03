drop table if exists ty_ods.w_bondkeytermduration;
create table if not exists ty_ods.w_bondkeytermduration
(
  object_id string comment '对象ID',
  s_info_windcode string comment '债券Wind代码',
  trade_dt string comment '交易日期',
  dura1m decimal(20,8) comment '1月久期',
  dura3m decimal(20,8) comment '3月久期',
  dura6m decimal(20,8) comment '6月久期',
  dura1y decimal(20,8) comment '1年久期',
  dura2y decimal(20,8) comment '2年久期',
  dura3y decimal(20,8) comment '3年久期',
  dura4y decimal(20,8) comment '4年久期',
  dura5y decimal(20,8) comment '5年久期',
  dura7y decimal(20,8) comment '7年久期',
  dura9y decimal(20,8) comment '9年久期',
  dura10y decimal(20,8) comment '10年久期',
  dura15y decimal(20,8) comment '15年久期',
  dura20y decimal(20,8) comment '20年久期',
  dura30y decimal(20,8) comment '30年久期',
  durast decimal(20,8) comment '短边久期',
  duralg decimal(20,8) comment '长边久期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



