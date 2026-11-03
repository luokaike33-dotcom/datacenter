drop table if exists ty_ods.w_cbondagingstructure;
create table if not exists ty_ods.w_cbondagingstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  statement_type_name string comment '报表类型名称',
  memo string comment '备注',
  aging string comment '账龄',
  currency_code string comment '货币代码',
  amount_money decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  bad_debt_preparation decimal(20,4) comment '坏账准备',
  report_period string comment '报告期',
  min_aging decimal(20,4) comment '最小账龄(年)',
  max_aging decimal(20,4) comment '最大账龄(年)',
  classification_criteria string comment '分类标准',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



