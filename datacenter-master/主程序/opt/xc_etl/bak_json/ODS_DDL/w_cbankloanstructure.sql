drop table if exists ty_ods.w_cbankloanstructure;
create table if not exists ty_ods.w_cbankloanstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  crncy_code string comment '货币代码',
  crncy_type_code bigint comment '币种类型代码',
  loan_type_code bigint comment '项目类别代码',
  ann_item string comment '[内部]公布名称',
  loan_item_code bigint comment '贷款项目代码',
  total_loans decimal(20,4) comment '贷款余额',
  ave_loans decimal(20,4) comment '贷款平均余额',
  interest_income decimal(20,4) comment '贷款利息收入',
  average_yield decimal(20,4) comment '贷款平均收益率',
  non_performing_loans decimal(20,4) comment '不良贷款余额',
  non_performing_loans_ratio decimal(20,4) comment '不良贷款率(%)',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



