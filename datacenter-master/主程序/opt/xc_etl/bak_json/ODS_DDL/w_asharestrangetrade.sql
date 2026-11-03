drop table if exists ty_ods.w_asharestrangetrade;
create table if not exists ty_ods.w_asharestrangetrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_strange_bgdate string comment '交易起始日',
  s_strange_enddate string comment '交易截止日',
  s_strange_range decimal(20,4) comment '涨跌幅',
  s_strange_volume decimal(20,4) comment '总成交量(万股)',
  s_strange_amount decimal(20,4) comment '总成交金额',
  s_strange_tradername string comment '营业部名称',
  s_strange_traderamount decimal(20,4) comment '营业部买卖金额',
  s_strange_buyamount decimal(20,4) comment '买入金额(元)',
  s_strange_sellamount decimal(20,4) comment '卖出金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



