drop table if exists ty_ods.w_ashareplaintiff;
create table if not exists ty_ods.w_ashareplaintiff
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '诉讼公司名称',
  s_info_comp_sname string comment '诉讼公司中文简称',
  s_info_compcode1 string comment '诉讼公司ID',
  s_info_case_type string comment '案件类型',
  ann_date string comment '公告日期',
  litigation_events_id string comment '诉讼事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



