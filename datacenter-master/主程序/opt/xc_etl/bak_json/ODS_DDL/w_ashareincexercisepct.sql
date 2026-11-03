drop table if exists ty_ods.w_ashareincexercisepct;
create table if not exists ty_ods.w_ashareincexercisepct
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_execbatch string comment '行权期',
  s_inc_execpct decimal(20,4) comment '行权比例(%)',
  s_inc_intervaltime decimal(20,4) comment '首个授权日至行权期间隔时间(月)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



