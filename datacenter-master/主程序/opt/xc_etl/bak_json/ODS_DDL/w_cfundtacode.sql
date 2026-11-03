drop table if exists ty_ods.w_cfundtacode;
create table if not exists ty_ods.w_cfundtacode
(
  object_id string comment '对象ID',
  comp_id string comment '品种ID',
  type_code bigint comment '业务代码类型',
  s_code string comment '业务代码',
  s_sname string comment '业务简称',
  is_common bigint comment '是否通用代码',
  memo string comment '业务说明',
  comp_type_code bigint comment '主体类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



