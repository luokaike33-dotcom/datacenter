drop table if exists ty_ods.w_cmfcodeandsname;
create table if not exists ty_ods.w_cmfcodeandsname
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '业务类型代码',
  s_code string comment '业务代码',
  s_sname string comment '业务简称',
  is_common bigint comment '是否通用代码',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



