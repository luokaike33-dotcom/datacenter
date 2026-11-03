drop table if exists ty_ods.w_cindexfuturespositions;
create table if not exists ty_ods.w_cindexfuturespositions
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  fs_info_membername string comment '会员简称',
  fs_info_type bigint comment '类型',
  fs_info_positionsnum decimal(20,4) comment '持仓数量',
  fs_info_rank bigint comment '名次',
  s_oi_positionsnumc decimal(20,4) comment '比上交易日增减',
  s_info_compcode string comment '会员ID ',
  sec_id string comment '证券ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



