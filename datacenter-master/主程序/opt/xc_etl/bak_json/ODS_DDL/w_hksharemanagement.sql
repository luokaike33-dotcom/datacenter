drop table if exists ty_ods.w_hksharemanagement;
create table if not exists ty_ods.w_hksharemanagement
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_enname string comment '英文名',
  s_info_manager_gender string comment '性别',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生年份',
  s_info_manager_typecode bigint comment '管理层类别代码',
  s_info_manager_post string comment '职务',
  s_info_manager_enpost string comment '职务(英文)',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_introduction string comment '个人简历',
  s_info_manager_enintroduction string comment '个人简历(英文)',
  manid string comment '人物ID',
  op_date string comment '操作日期',
  is_in_office bigint comment '是否在任',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



