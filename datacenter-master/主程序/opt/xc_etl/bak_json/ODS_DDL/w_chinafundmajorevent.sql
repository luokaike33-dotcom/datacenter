drop table if exists ty_ods.w_chinafundmajorevent;
create table if not exists ty_ods.w_chinafundmajorevent
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_event_categorycode bigint comment '事件类型代码',
  s_event_anncedate string comment '披露日期',
  s_event_hapdate string comment '发生日期',
  s_event_expdate string comment '失效日期',
  s_event_content string comment '事件说明',
  s_event_templateid bigint comment '模板ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



