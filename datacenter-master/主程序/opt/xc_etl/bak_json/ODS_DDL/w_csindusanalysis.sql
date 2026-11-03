drop table if exists ty_ods.w_csindusanalysis;
create table if not exists ty_ods.w_csindusanalysis
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  industriescode string comment '行业代码',
  marketcode bigint comment '市场代码',
  indust_val_pe decimal(20,4) comment '市盈率-加权平均',
  indust_val_pe_ttm decimal(20,4) comment '市盈率【TTM】-加权平均',
  indust_val_pb decimal(20,4) comment '市净率',
  sample_num decimal(20,4) comment '样本券个数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



