drop table if exists ty_ods.w_bankloan5lclassification;
create table if not exists ty_ods.w_bankloan5lclassification
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  loan_type string comment '贷款类型',
  total_amount decimal(20,4) comment '合计金额',
  loans_excl_discount decimal(20,4) comment '贷款(不含贴现)',
  discount decimal(20,4) comment '贴现',
  pastdueitems decimal(20,4) comment '逾期拆放同业及金融类公司',
  othercreditasset decimal(20,4) comment '其他信贷资产',
  proportion_of_ta decimal(20,4) comment '贷款占贷款总额比例(%)',
  llimit_of_llr_accrualratio decimal(20,4) comment '贷款损失准备金计提比例下限(%)',
  ulimit_of_llr_accrualratio decimal(20,4) comment '贷款损失准备金计提比例上限(%)',
  proportion_of_sll decimal(20,4) comment '标准贷款损失计提比例(%)',
  migration_rate decimal(20,4) comment '迁徙率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



