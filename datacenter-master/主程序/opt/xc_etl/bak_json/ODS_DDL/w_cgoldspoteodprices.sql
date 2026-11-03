drop table if exists ty_ods.w_cgoldspoteodprices;
create table if not exists ty_ods.w_cgoldspoteodprices
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_dq_open decimal(20,4) comment '开盘价(元)',
  s_dq_high decimal(20,4) comment '最高价(元)',
  s_dq_low decimal(20,4) comment '最低价(元)',
  s_dq_close decimal(20,4) comment '收盘价(元)',
  s_dq_avgprice decimal(20,4) comment '均价(元)',
  s_dq_volume decimal(20,4) comment '成交量(千克)',
  s_dq_amount decimal(20,4) comment '成交金额(元)',
  s_dq_oi decimal(20,4) comment '持仓量(手)',
  del_amt decimal(20,4) comment '交收量(手)',
  s_dq_settle decimal(20,4) comment '结算价(元)
',
  delay_pay_typecode bigint comment '延期补偿费支付方式向类别代码
',
  s_pct_chg decimal(20,4) comment '涨跌幅(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



