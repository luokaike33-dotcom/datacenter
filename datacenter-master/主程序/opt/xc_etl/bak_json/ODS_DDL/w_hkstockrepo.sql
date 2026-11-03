drop table if exists ty_ods.w_hkstockrepo;
create table if not exists ty_ods.w_hkstockrepo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_dq_high decimal(20,4) comment '最高价(元)',
  s_dq_low decimal(20,4) comment '最低价(元)',
  repo_volume decimal(20,4) comment '回购数量(股)',
  repo_amount decimal(20,4) comment '回购金额(元)',
  crncy_code string comment '货币代码',
  repo_typecode bigint comment '回购方式类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



