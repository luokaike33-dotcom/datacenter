drop table if exists ty_ods.w_ashareholdernumber;
create table if not exists ty_ods.w_ashareholdernumber
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_holder_enddate string comment '截止日期',
  s_holder_num decimal(20,4) comment 'A股股东户数',
  s_holder_total_num decimal(20,4) comment '股东总户数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



