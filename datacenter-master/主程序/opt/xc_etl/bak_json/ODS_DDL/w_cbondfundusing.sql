drop table if exists ty_ods.w_cbondfundusing;
create table if not exists ty_ods.w_cbondfundusing
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  start_dt string comment '起始日期',
  end_dt string comment '截止日期',
  cur_sign bigint comment '最新标志',
  funduse string comment '资金用途',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



