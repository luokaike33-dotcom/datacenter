drop table if exists ty_ods.w_cbondotheraccountsreceivable;
create table if not exists ty_ods.w_cbondotheraccountsreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '账龄',
  currency_code string comment '货币代码',
  oth_rcv decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例',
  extra_amount decimal(20,4) comment '坏账准备',
  min_aging decimal(20,4) comment '最小账龄',
  max_aging decimal(20,4) comment '最大账龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



