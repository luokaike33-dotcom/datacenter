drop table if exists ty_ods.w_cgbbenchmark;
create table if not exists ty_ods.w_cgbbenchmark
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_dq_close decimal(20,4) comment '利率(%)',
  s_dq_open decimal(20,4) comment '开盘利率(%)',
  s_dq_high decimal(20,4) comment '最高利率(%)',
  s_dq_low decimal(20,4) comment '最低利率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



