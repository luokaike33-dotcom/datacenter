drop table if exists ty_ods.w_cfundwindindexmembers;
create table if not exists ty_ods.w_cfundwindindexmembers
(
  object_id string comment '对象ID',
  s_con_code string comment '板块代码',
  s_con_name string comment '板块名称',
  s_info_windcode string comment '成份万得代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



