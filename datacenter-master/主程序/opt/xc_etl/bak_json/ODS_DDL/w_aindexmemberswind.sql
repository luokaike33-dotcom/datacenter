drop table if exists ty_ods.w_aindexmemberswind;
create table if not exists ty_ods.w_aindexmemberswind
(
  object_id string comment '对象ID',
  f_info_windcode string comment '指数Wind代码',
  s_con_windcode string comment '成份股Wind代码',
  s_con_indate string comment '纳入日期',
  s_con_outdate string comment '剔除日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



