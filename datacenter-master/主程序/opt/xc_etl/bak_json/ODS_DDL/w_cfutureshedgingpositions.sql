drop table if exists ty_ods.w_cfutureshedgingpositions;
create table if not exists ty_ods.w_cfutureshedgingpositions
(
  object_id string comment '对象ID',
  fs_info_sccode string comment '标准合约代码',
  fs_info_date string comment '日期',
  buy_hedging_quota decimal(20,4) comment '买套保额度(元)',
  buy_hedging_hold_amount decimal(20,4) comment '期货买套保持仓量(手)',
  sell_hedging_quota decimal(20,4) comment '卖套保额度(元)',
  sell_hedging_hold_amount decimal(20,4) comment '期货卖套保持仓量(手)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



