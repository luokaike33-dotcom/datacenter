drop table if exists ty_ods.w_cfundratesensitive;
create table if not exists ty_ods.w_cfundratesensitive
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  price_fluncuation decimal(20,4) comment '价格变动',
  change_amount decimal(20,4) comment '基金资产净值相对变动额',
  type_code bigint comment '敏感分析价格类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



