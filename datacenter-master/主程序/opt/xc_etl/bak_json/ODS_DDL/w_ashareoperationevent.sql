drop table if exists ty_ods.w_ashareoperationevent;
create table if not exists ty_ods.w_ashareoperationevent
(
  object_id string comment '对象ID',
  comp_id string comment '公司id',
  sec_id string comment '品种ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  event_type bigint comment '事件类型',
  event_name string comment '事件标题',
  cattype_id bigint comment '品种类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



