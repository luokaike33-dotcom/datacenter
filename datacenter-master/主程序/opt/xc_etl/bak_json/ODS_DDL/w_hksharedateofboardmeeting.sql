drop table if exists ty_ods.w_hksharedateofboardmeeting;
create table if not exists ty_ods.w_hksharedateofboardmeeting
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  meet_dt string comment '会议日期',
  fst_meet_dt string comment '首次披露会议日期',
  meet_ctnt string comment '事项',
  period string comment '期间说明',
  end_dt string comment '截止日',
  s_months string comment '期间间隔',
  tel_meet string comment '电话会议概要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



