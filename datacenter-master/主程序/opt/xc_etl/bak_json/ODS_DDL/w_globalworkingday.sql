drop table if exists ty_ods.w_globalworkingday;
create table if not exists ty_ods.w_globalworkingday
(
  object_id string comment '对象ID',
  working_date string comment '日期',
  country_code string comment '国家或地区代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



