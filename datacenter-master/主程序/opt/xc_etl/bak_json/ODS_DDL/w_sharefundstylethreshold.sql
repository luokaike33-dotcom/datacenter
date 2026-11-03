drop table if exists ty_ods.w_sharefundstylethreshold;
create table if not exists ty_ods.w_sharefundstylethreshold
(
  object_id string comment '对象ID',
  s_change_date string comment '变动日期',
  threshold_large_stock decimal(20,4) comment '大盘股门限值(万元)',
  threshold_mid_stock decimal(20,4) comment '中盘股门限值(万元)',
  threshold_growth_stock decimal(20,4) comment '成长型门限值',
  threshold_value_stock decimal(20,4) comment '价值型门限值',
  date_closing_date string comment '引用数据的截止日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



