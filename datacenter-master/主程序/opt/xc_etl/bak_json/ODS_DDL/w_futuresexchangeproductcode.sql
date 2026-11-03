drop table if exists ty_ods.w_futuresexchangeproductcode;
create table if not exists ty_ods.w_futuresexchangeproductcode
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  business_type_code bigint comment '业务代码类型',
  business_code string comment '业务代码',
  business_abbreviation string comment '业务简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



