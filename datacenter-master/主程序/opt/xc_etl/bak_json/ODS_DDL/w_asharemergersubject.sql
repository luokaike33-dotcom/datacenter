drop table if exists ty_ods.w_asharemergersubject;
create table if not exists ty_ods.w_asharemergersubject
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '并购公司名称',
  s_info_comp_sname string comment '并购公司中文简称',
  s_info_compcode1 string comment '并购公司ID',
  s_info_progress string comment '方案进度',
  s_update_date string comment '最新披露日期',
  s_meetevent_id string comment '事件ID',
  s_info_comp_name1 string comment '并购目标公司名称',
  s_info_comp_sname1 string comment '并购目标公司中文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



