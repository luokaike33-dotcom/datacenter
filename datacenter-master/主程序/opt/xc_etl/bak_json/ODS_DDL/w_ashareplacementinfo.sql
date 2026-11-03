drop table if exists ty_ods.w_ashareplacementinfo;
create table if not exists ty_ods.w_ashareplacementinfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '公告日期',
  pct_change_1d bigint comment '投资者类型代码',
  pct_change_1w decimal(20,8) comment '网下中签率',
  pct_change_1m decimal(20,4) comment '配售数量',
  volume_w decimal(20,4) comment '申购数量',
  volume_m decimal(20,4) comment '配售数量占比',
  amount_w decimal(20,4) comment '有效申购数量占比',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



