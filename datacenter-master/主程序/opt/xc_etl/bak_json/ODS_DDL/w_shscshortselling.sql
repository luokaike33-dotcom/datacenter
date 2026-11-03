drop table if exists ty_ods.w_shscshortselling;
create table if not exists ty_ods.w_shscshortselling
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  short_sell_stocks_max decimal(20,4) comment '最多可供卖空的股数(股)',
  short_sell_stocks_balance decimal(20,4) comment '可供卖空的股数余额(股)',
  short_sale_num decimal(20,4) comment '卖空成交股数(股)',
  short_sale_amount decimal(20,4) comment '卖空成交金额(元)',
  short_sell_proportion decimal(20,4) comment '当天卖空比例(%)',
  short_sell_proportion_total decimal(20,4) comment '累计十天卖空比例(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



