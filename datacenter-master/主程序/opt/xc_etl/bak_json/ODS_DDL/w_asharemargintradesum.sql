drop table if exists ty_ods.w_asharemargintradesum;
create table if not exists ty_ods.w_asharemargintradesum
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  s_marsum_exchmarket string comment '交易所英文简称',
  s_marsum_tradingbalance decimal(20,4) comment '融资余额(元)',
  s_marsum_purchwithborrowmoney decimal(20,4) comment '融资买入额(元)',
  s_marsum_repaymenttobroker decimal(20,4) comment '融资偿还额(元)',
  s_marsum_seclendingbalance decimal(20,4) comment '融券余额(元)',
  s_marsum_salesofborrowedsec decimal(20,4) comment '融券卖出量(股,份,手)',
  s_marsum_margintradebalance decimal(20,4) comment '融资融券余额(元)',
  s_marsum_margin_margin decimal(20,4) comment '融券余量',
  s_marsum_financing_margin decimal(20,4) comment '融资余量股(份/手)',
  s_marsum_securities_sales decimal(20,4) comment '融券卖出额(元)',
  s_marsum_securities_repay decimal(20,4) comment '融券偿还额(元)',
  s_marsum_flow_equity decimal(20,4) comment 'A股流通股本(万股)',
  s_marsum_circulation_value decimal(20,4) comment 'A股流通市值(万元)',
  s_marsum_turnover_amount decimal(20,4) comment 'A股成交金额(万元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



