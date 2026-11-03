drop table if exists ty_ods.w_cbondmonetaryfunds;
create table if not exists ty_ods.w_cbondmonetaryfunds
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_date string comment '公告日期',
  s_rmb decimal(20,4) comment '人民币',
  s_us decimal(20,4) comment '美元(折算人民币)',
  s_jpy decimal(20,4) comment '日元(折算人民币)',
  s_eur decimal(20,4) comment '欧元(折算人民币)',
  s_hkd decimal(20,4) comment '港币(折算人民币)',
  s_gbp decimal(20,4) comment '英镑(折算人民币)',
  s_other decimal(20,4) comment '其他货币(折算人民币)',
  capital_tot decimal(20,4) comment '货币资金合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



