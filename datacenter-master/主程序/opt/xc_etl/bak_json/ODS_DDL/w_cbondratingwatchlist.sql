drop table if exists ty_ods.w_cbondratingwatchlist;
create table if not exists ty_ods.w_cbondratingwatchlist
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  b_event_hapdate string comment '发生日期',
  b_event_categorycode bigint comment '事件类型代码',
  b_event_category string comment '事件类型名称',
  b_event_title string comment '事件标题',
  b_ann_abstract string comment '公告摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



