drop table if exists ty_ods.w_shscchannelholdings;
create table if not exists ty_ods.w_shscchannelholdings
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码',
  trade_dt string comment '持股日期',
  s_info_exchmarketname string comment '交易所英文简称',
  s_quantity decimal(20,4) comment '中央结算系统持股量',
  s_ratio decimal(20,4) comment '[内部]中央结算系统持股量占比',
  s_info_code string comment '[内部]股份代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



