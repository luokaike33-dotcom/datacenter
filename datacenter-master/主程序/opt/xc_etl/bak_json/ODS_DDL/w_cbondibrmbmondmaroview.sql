drop table if exists ty_ods.w_cbondibrmbmondmaroview;
create table if not exists ty_ods.w_cbondibrmbmondmaroview
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  s_info_typecode string comment '交易品种代码',
  b_dq_type string comment '交易品种',
  b_dq_number decimal(20,8) comment '成交笔数',
  b_dq_nochange decimal(20,8) comment '成交笔数增减',
  b_dq_tradingvalue decimal(20,8) comment '成交量(亿元)',
  b_dq_vchange decimal(20,8) comment '成交额增减（亿元）',
  b_dq_wavrate decimal(20,8) comment '加权平均利率(%)',
  b_dq_bpchange decimal(20,8) comment '升降基点',
  b_dq_nomembersinvo decimal(20,8) comment '参与成员家数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



