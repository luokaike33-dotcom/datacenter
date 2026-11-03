drop table if exists ty_ods.w_cbondpricingvaluation;
create table if not exists ty_ods.w_cbondpricingvaluation
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  val_agency string comment '估值机构',
  val_agency_id string comment '估值机构id',
  credit_code bigint comment '信用评级代码',
  term decimal(20,4) comment '期限',
  valuation decimal(20,4) comment '定价估值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



