drop table if exists ty_ods.w_cfundwindindexcomponent;
create table if not exists ty_ods.w_cfundwindindexcomponent
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  s_con_code string comment '成份板块代码',
  s_con_name string comment '成份板块名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



