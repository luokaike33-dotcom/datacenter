drop table if exists ty_ods.w_cpsrating;
create table if not exists ty_ods.w_cpsrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_rate_style string comment '评级类型',
  s_info_creditrating string comment '信用评级',
  s_info_creditratingagency string comment '评级机构代码',
  s_info_creditratingexplain string comment '信用评级说明',
  s_info_precreditrating string comment '前次信用评级',
  s_creditrating_change string comment '评级变动方向',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



