drop table if exists ty_ods.w_interestrateintroduction;
create table if not exists ty_ods.w_interestrateintroduction
(
  object_id string comment '对象ID',
  b_info_windcode string comment '品种ID',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  memo string comment '条款',
  cur_sign bigint comment '是否最新',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



