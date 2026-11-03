drop table if exists ty_ods.w_cmfiopvnav;
create table if not exists ty_ods.w_cmfiopvnav
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  price_date string comment '日期',
  f_iopv_nav decimal(20,8) comment 'IOPV收盘净值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



