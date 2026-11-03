drop table if exists ty_ods.w_cbondfthirdpartyvaluation;
create table if not exists ty_ods.w_cbondfthirdpartyvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  dls_windcode string comment 'Wind代码',
  pricetype_code bigint comment '价格类型代码',
  trade_dt string comment '日期',
  dl_interest decimal(24,8) comment '交割利息',
  intervalinterest decimal(24,8) comment '区间利息',
  dl_cost decimal(20,4) comment '交割成本',
  fs_spread decimal(20,4) comment '期现价差',
  irr decimal(20,4) comment 'IRR',
  rt_spread decimal(20,4) comment '基差',
  rec_trans_marks decimal(20,4) comment '近期成交标识',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



