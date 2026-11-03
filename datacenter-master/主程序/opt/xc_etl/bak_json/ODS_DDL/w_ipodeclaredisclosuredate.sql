drop table if exists ty_ods.w_ipodeclaredisclosuredate;
create table if not exists ty_ods.w_ipodeclaredisclosuredate
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  per_disclosuredate string comment '纳入日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



