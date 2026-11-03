drop table if exists ty_ods.w_asharestrangetradedetail;
create table if not exists ty_ods.w_asharestrangetradedetail
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code string comment '异动类型',
  start_dt string comment '起始日',
  end_dt string comment '截止日',
  volume decimal(20,4) comment '成交量(万股)',
  amount decimal(20,4) comment '成交金额(元)',
  pctchange decimal(20,4) comment '涨跌幅(%)',
  change_deviation decimal(20,4) comment '涨跌幅偏离值(%)',
  swing decimal(20,4) comment '振幅(%)',
  turn decimal(20,4) comment '换手率(%)',
  change_deviation_3d decimal(20,4) comment '连续三个交易日累计涨跌幅偏离值(%)',
  turn_3d decimal(20,4) comment '连续三个交易日累计换手率(%)',
  turn_3dto5d decimal(20,4) comment '连续三个交易日日均换手率与前五个交易日的日均换手率的比值(倍)',
  margin_pct decimal(20,4) comment '融资买入(融资卖出)成交占比',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



