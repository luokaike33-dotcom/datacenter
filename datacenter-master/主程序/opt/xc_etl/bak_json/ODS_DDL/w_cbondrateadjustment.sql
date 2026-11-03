drop table if exists ty_ods.w_cbondrateadjustment;
create table if not exists ty_ods.w_cbondrateadjustment
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_info_carrydate string comment '起始日期',
  b_info_enddate string comment '截止日期',
  b_info_provisiontype string comment '条款类型',
  b_info_couponrate decimal(22,6) comment '当期票面利率',
  b_info_couponadj_min decimal(20,4) comment '调整下限',
  b_info_couponadj_max decimal(20,4) comment '调整上限',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



