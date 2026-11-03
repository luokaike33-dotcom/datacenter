drop table if exists ty_ods.w_cbondfundstop5companies;
create table if not exists ty_ods.w_cbondfundstop5companies
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_info_compname string comment '单位名称',
  s_info_compcode2 string comment '单位名称ID',
  typecode bigint comment '往来资金类别代码',
  conditioncode bigint comment '往来资金条件代码',
  start_dt string comment '起始日',
  end_dt string comment '终止日',
  amount1 decimal(20,4) comment '金额',
  amount2 decimal(20,4) comment '原币金额',
  crncy_code string comment '货币代码',
  rate string comment '利率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



