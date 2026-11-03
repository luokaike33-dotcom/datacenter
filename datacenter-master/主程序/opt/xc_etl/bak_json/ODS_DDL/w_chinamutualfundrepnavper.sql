drop table if exists ty_ods.w_chinamutualfundrepnavper;
create table if not exists ty_ods.w_chinamutualfundrepnavper
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  f_info_reportperiod string comment '报告期',
  period_code string comment '期间代码',
  f_nav_return decimal(20,4) comment '净值增长率',
  f_nav_stddevreturn decimal(20,4) comment '净值增长率标准差',
  f_nav_benchreturn decimal(20,4) comment '业绩比较基准收益率',
  f_nav_benchstddev decimal(20,4) comment '业绩比较基准收益率标准差',
  f_nav_benchdevreturn decimal(20,4) comment '净值增长率减基准收益率',
  f_nav_stddevnavbench decimal(20,4) comment '净值增长率标准差减基准收益率标准差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



