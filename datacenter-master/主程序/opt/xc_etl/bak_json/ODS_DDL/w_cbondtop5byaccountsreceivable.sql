drop table if exists ty_ods.w_cbondtop5byaccountsreceivable;
create table if not exists ty_ods.w_cbondtop5byaccountsreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  s_info_compname string comment '债务人名称',
  amount decimal(20,4) comment '金额',
  crncy_code string comment '货币代码',
  period string comment '拖欠时间',
  reason string comment '拖欠原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



