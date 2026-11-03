drop table if exists ty_ods.w_asharedirector;
create table if not exists ty_ods.w_asharedirector
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_manager_name string comment '姓名',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_post string comment '职务',
  s_info_manid string comment '人物id',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



