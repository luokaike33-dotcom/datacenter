drop table if exists ty_ods.w_cbondloandetails;
create table if not exists ty_ods.w_cbondloandetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  loan_type string comment '贷款类型',
  loan_cny decimal(20,4) comment '人民币贷款',
  loan_usd decimal(20,4) comment '美元贷款(折算人民币)',
  loan_jpy decimal(20,4) comment '日元贷款(折算人民币)',
  loan_eur decimal(20,4) comment '欧元贷款(折算人民币)',
  loan_hkd decimal(20,4) comment '港币贷款(折算人民币)',
  loan_gbp decimal(20,4) comment '英镑贷款(折算人民币)',
  loan_other decimal(20,4) comment '其他货币贷款(折算人民币)',
  loan_tot decimal(20,4) comment '贷款合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



