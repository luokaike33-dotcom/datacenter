drop table if exists ty_ods.w_relatedevent;
create table if not exists ty_ods.w_relatedevent
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  related_id string comment '关联事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



