drop table if exists ty_ods.w_coptiondescriptionchange;
create table if not exists ty_ods.w_coptiondescriptionchange
(
  object_id string comment '对象ID',
  s_info_windcode string comment '期权月合约代码',
  s_change_date string comment '调整日期',
  s_info_code_old string comment '原交易代码',
  s_info_name_old string comment '原合约简称',
  s_exercise_price_old decimal(20,4) comment '原行权价（元）',
  s_unit_old decimal(20,4) comment '原合约单位（股）',
  s_info_code_new string comment '新交易代码',
  s_info_name_new string comment '新合约简称',
  s_exercise_price_new decimal(20,4) comment '新行权价（元）',
  s_unit_new decimal(20,4) comment '新合约单位（股）',
  s_change_reason string comment '调整原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



