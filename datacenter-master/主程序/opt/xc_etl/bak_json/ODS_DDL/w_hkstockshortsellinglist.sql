drop table if exists ty_ods.w_hkstockshortsellinglist;
create table if not exists ty_ods.w_hkstockshortsellinglist
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  begindate string comment '起始日期',
  enddate string comment '终止日期',
  cur_sign string comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



