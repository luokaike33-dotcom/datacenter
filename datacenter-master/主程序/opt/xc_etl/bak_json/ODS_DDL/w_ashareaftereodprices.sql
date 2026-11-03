drop table if exists ty_ods.w_ashareaftereodprices;
create table if not exists ty_ods.w_ashareaftereodprices
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  crncy_code string comment '货币代码',
  s_dq_after_price decimal(20,4) comment '盘后固定价格(元)',
  s_dq_volume decimal(20,4) comment '成交量(手)',
  s_dq_amount decimal(20,4) comment '成交金额(千元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



