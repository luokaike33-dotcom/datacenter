drop table if exists ty_ods.w_cbondissuermanagement;
create table if not exists ty_ods.w_cbondissuermanagement
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id ',
  s_info_compname string comment '公司名称',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别代码',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生日期',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type bigint comment '管理层类别',
  s_info_manager_post string comment '公布职务名称',
  s_info_manager_introduction string comment '个人简历',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



