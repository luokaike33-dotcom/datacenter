drop table if exists ty_ods.w_aindexhs300weight;
create table if not exists ty_ods.w_aindexhs300weight
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  s_con_windcode string comment '成份股Wind代码',
  trade_dt string comment '交易日期',
  i_weight decimal(20,4) comment '权重',
  s_in_index decimal(20,2) comment '计算用股本(股)',
  i_weight_11 decimal(20,2) comment '总股本(股)',
  i_weight_12 decimal(20,4) comment '自由流通比例(%)(归档后)',
  i_weight_14 decimal(20,8) comment '权重因子',
  i_weight_15 decimal(20,4) comment '收盘',
  i_weight_16 decimal(20,4) comment '调整后开盘参考价',
  i_weight_17 decimal(20,2) comment '总市值',
  i_weight_18 decimal(20,2) comment '计算用市值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



