drop table if exists ty_ods.w_ashareblocktrade;
create table if not exists ty_ods.w_ashareblocktrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_block_price decimal(20,4) comment '成交价（元）',
  s_block_volume decimal(20,4) comment '成交量（万股）',
  s_block_amount decimal(20,4) comment '成交金额（万元）',
  crncy_code string comment '货币代码',
  s_block_buyername string comment '买方营业部名称',
  s_block_sellername string comment '卖方营业部名称',
  s_block_frequency decimal(20,4) comment '笔数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



