drop table if exists ty_ods.w_ashareotherreceivables;
create table if not exists ty_ods.w_ashareotherreceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



