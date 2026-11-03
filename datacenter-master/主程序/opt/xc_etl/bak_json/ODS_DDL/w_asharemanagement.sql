drop table if exists ty_ods.w_asharemanagement;
create table if not exists ty_ods.w_asharemanagement
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生年份',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type bigint comment '管理层类别',
  s_info_manager_post string comment '职务',
  s_info_manager_introduction string comment '个人简历',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



