drop table if exists ty_ods.w_top5byoperatingincome;
create table if not exists ty_ods.w_top5byoperatingincome
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_info_compname string comment '单位名称',
  s_info_compcode2 string comment '单位名称ID',
  salesamount decimal(20,4) comment '金额(元)',
  crncy_code string comment '货币代码',
  pct decimal(20,4) comment '占比(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



