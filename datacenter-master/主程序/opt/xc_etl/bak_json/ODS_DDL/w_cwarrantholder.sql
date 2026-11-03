drop table if exists ty_ods.w_cwarrantholder;
create table if not exists ty_ods.w_cwarrantholder
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  end_date string comment '日期',
  holder string comment '持有人',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



