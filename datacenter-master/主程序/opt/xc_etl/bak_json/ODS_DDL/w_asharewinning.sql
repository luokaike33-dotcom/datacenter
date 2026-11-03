drop table if exists ty_ods.w_asharewinning;
create table if not exists ty_ods.w_asharewinning
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  last_digit bigint comment '末尾位数',
  winning_number string comment '中签号码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



