drop table if exists ty_ods.w_cbondfvaluation;
create table if not exists ty_ods.w_cbondfvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  dls_windcode string comment '可交割券Wind代码',
  trade_dt string comment '日期',
  dl_interest decimal(20,8) comment '交割利息',
  intervalinterest decimal(20,8) comment '区间利息',
  dl_cost decimal(20,4) comment '交割成本',
  fs_spread decimal(20,4) comment '期现价差',
  irr decimal(20,4) comment 'IRR',
  rt_spread decimal(20,4) comment '基差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



