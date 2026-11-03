drop table if exists ty_ods.w_cmfundwindrating;
create table if not exists ty_ods.w_cmfundwindrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  rptdate string comment '日期',
  starlevel decimal(20,4) comment '星级',
  f_info_type string comment '基金类型',
  rating_interval string comment '评级区间',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



