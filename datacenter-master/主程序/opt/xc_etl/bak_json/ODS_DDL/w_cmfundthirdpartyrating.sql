drop table if exists ty_ods.w_cmfundthirdpartyrating;
create table if not exists ty_ods.w_cmfundthirdpartyrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  rptdate string comment '日期（月份）',
  starlevel decimal(20,4) comment '星级',
  f_info_type string comment '基金类型',
  rating_interval string comment '评级区间',
  rating_gagency string comment '评级机构',
  rating_type string comment '评级类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



