drop table if exists ty_ods.w_securitiestypecode;
create table if not exists ty_ods.w_securitiestypecode
(
  object_id string comment '对象ID',
  type_code string comment '证券类型代码',
  type string comment '证券类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



