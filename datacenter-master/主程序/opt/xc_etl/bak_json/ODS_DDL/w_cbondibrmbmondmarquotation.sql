drop table if exists ty_ods.w_cbondibrmbmondmarquotation;
create table if not exists ty_ods.w_cbondibrmbmondmarquotation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_dq_type string comment '交易品种',
  trade_dt string comment '交易日期',
  b_dq_open decimal(20,8) comment '开盘利率',
  b_dq_high decimal(20,8) comment '最高利率',
  b_dq_low decimal(20,8) comment '最低利率',
  b_dq_originclose decimal(20,8) comment '收盘利率',
  b_dq_waveragerate decimal(20,8) comment '加权平均利率',
  b_dq_bpchange decimal(20,8) comment '升降(基点)',
  b_dq_volume decimal(20,8) comment '成交量(手)',
  b_dq_amount decimal(20,8) comment '成交金额(亿元)',
  b_dq_amountchange decimal(20,8) comment '成交量增减(亿元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



