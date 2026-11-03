drop table if exists ty_ods.w_asharestylecoefficient;
create table if not exists ty_ods.w_asharestylecoefficient
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_change_date string comment '变动日期',
  date_closing_date string comment '引用数据的截止日期',
  style_coefficient decimal(20,4) comment '风格系数',
  growth_z decimal(20,4) comment '成长性Z分值',
  value_z decimal(20,4) comment '价值因子Z分值(ZVP)',
  avg_market_value decimal(20,4) comment '1年日均市值(万元)',
  gross_oper_rev decimal(20,4) comment '营业收入增长率(%)',
  gross_oper_netprofit decimal(20,4) comment '净利润增长率(%)',
  value_coefficient decimal(20,4) comment '调整市值系数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



