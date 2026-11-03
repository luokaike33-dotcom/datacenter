drop table if exists ty_ods.w_cbondaccountsreceivable;
create table if not exists ty_ods.w_cbondaccountsreceivable
(
  object_id string comment '对象ID',
  memo string comment '备注',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



