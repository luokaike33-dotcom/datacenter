drop table if exists ty_ods.w_currencycode;
create table if not exists ty_ods.w_currencycode
(
  object_id string comment '对象ID',
  crncy_name string comment '货币名称',
  currency_code string comment '货币代码',
  main_currency_code string comment '主币货币代码',
  pip_value decimal(20,4) comment 'pip value',
  main_currency_ratio bigint comment '主辅币比例',
  latest_logo bigint comment '最新标志',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



