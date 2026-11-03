drop table if exists ty_ods.w_chinamutualfundseattrading;
create table if not exists ty_ods.w_chinamutualfundseattrading
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_reportperiod string comment '报告期',
  s_info_securname string comment '证券公司简称',
  f_trade_stockam decimal(20,4) comment '股票交易金额(元)',
  f_trade_stockpro decimal(20,4) comment '股票交易金额占比(%)',
  f_trade_bondam decimal(20,4) comment '债券交易金额(元)',
  f_trade_bondpro decimal(20,4) comment '债券交易金额占比(%)',
  f_trade_repoam decimal(20,4) comment '回购交易金额(元)',
  f_trade_repopro decimal(20,4) comment '回购交易金额占比(%)',
  f_trade_sbam decimal(20,4) comment '股票债券成交金额(元)',
  f_trade_sbpro decimal(20,4) comment '股票债券交易量占比(%)',
  f_trade_warrantam decimal(20,4) comment '权证交易金额(元)',
  f_trade_warrantpro decimal(20,4) comment '权证交易金额占比(%)',
  f_trade_fundam decimal(20,4) comment '基金交易金额(元)',
  f_trade_fundpro decimal(20,4) comment '基金交易金额占比(%)',
  f_commissionam decimal(20,4) comment '交易佣金(元)',
  f_commissionpro decimal(20,4) comment '交易佣金占比(%)',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



