drop table if exists ty_ods.w_ashareisactivity;
create table if not exists ty_ods.w_ashareisactivity
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  s_activitiestype bigint comment '投资者关系活动类别代码',
  s_surveydate string comment '调研日期',
  s_surveytime string comment '调研具体时间',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



