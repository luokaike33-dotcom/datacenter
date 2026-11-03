drop table if exists ty_ods.w_asharefreefloat;
create table if not exists ty_ods.w_asharefreefloat
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_dt string comment '变动日期(除权日)',
  s_share_freeshares decimal(20,4) comment '自由流通股本(万股)',
  change_dt1 string comment '变动日期(上市日)',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



