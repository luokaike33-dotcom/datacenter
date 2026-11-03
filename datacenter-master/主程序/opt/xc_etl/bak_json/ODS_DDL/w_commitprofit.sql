drop table if exists ty_ods.w_commitprofit;
create table if not exists ty_ods.w_commitprofit
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  targetcomp_code string comment '标的公司ID',
  targetcompname string comment '[内部]标的公司名称',
  s_info_windcode string comment 'Wind代码',
  s_info_commitann_dt string comment '承诺公告日',
  report_period string comment '报告期',
  commitnetprofit decimal(20,4) comment '承诺净利润(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



