drop table if exists ty_ods.w_forexoptiondelta;
create table if not exists ty_ods.w_forexoptiondelta
(
  object_id string comment '对象ID',
  crncy_code string comment '外汇品种代码',
  trade_dt string comment '交易日期',
  anal_curveterm string comment '标准期限',
  maturitydate string comment '到期日',
  maturity_day bigint comment '到期天数',
  spot_price_type_code bigint comment '即期价格类型代码',
  spot_price decimal(20,4) comment '即期价格',
  rmb_rate_type_code bigint comment '人民币利率类型代码',
  interest_rate decimal(20,4) comment '本币利率',
  volatility_type_code bigint comment '波动率类型代码',
  foreign_currency_rate decimal(20,4) comment '外币利率',
  implied_volatility decimal(20,4) comment '隐含波动率',
  foreign_swap_point decimal(20,4) comment '外汇掉期点',
  executive_price decimal(20,4) comment '执行价格',
  call_option_delta decimal(20,4) comment '看涨期权delta',
  put_option_delta decimal(20,4) comment '看跌期权delta',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



