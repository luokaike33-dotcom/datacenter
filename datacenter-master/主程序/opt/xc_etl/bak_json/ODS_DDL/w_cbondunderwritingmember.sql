drop table if exists ty_ods.w_cbondunderwritingmember;
create table if not exists ty_ods.w_cbondunderwritingmember
(
  member_name string comment '成员名称',
  underwriting_group_type string comment '承销团类型',
  object_id string comment '对象ID',
  b_year string comment '年度',
  member_id string comment '成员ID',
  member_type string comment '成员类型',
  member_type_num bigint comment '成员类型代码',
  underwriting_group_num bigint comment '承销团类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



