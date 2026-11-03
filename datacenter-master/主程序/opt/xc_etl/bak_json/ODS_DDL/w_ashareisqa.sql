drop table if exists ty_ods.w_ashareisqa;
create table if not exists ty_ods.w_ashareisqa
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  s_askdate string comment '提问日期',
  s_questiontype bigint comment '问题内容分类代码',
  s_questioncontent string comment '问题内容',
  s_answercontent string comment '回答内容',
  originalwebsite string comment '原文地址',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



