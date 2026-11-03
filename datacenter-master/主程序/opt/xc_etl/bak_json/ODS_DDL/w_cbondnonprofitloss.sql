drop table if exists ty_ods.w_cbondnonprofitloss;
create table if not exists ty_ods.w_cbondnonprofitloss
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  non_current_gains_losses decimal(20,4) comment '非流动资产处置损益',
  tax_return decimal(20,4) comment '税收返还减免',
  government_subsidy decimal(20,4) comment '政府补助',
  capital_occupation_fee decimal(20,4) comment '资金占用费',
  consolidated_gains_losses decimal(20,4) comment '企业合并产生的损益',
  non_assets_gains_losses decimal(20,4) comment '非货币性资产交换损益',
  investment_gains_losses decimal(20,4) comment '委托投资损益',
  impairment_assets decimal(20,4) comment '资产减值准备',
  debt_restructuring decimal(20,4) comment '债务重组损益',
  enterprise_restructuring decimal(20,4) comment '企业重组费用',
  trading_price_unfair decimal(20,4) comment '交易价格显失公允产生的损益',
  net_profit_loss_subsidiaries decimal(20,4) comment '同一控制下企业合并产生的子公司净损益',
  expected_liabilities decimal(20,4) comment '预计负债产生的损益',
  onoiae decimal(20,4) comment '其他营业外收支净额',
  other_projects decimal(20,4) comment '其他项目',
  non_recurring_gains_losses decimal(20,4) comment '非经常性损益项目小计',
  income_tax_impact decimal(20,4) comment '所得税影响数',
  profit_loss_shareholders decimal(20,4) comment '少数股东损益影响数',
  non_recurring_gains_losses1 decimal(20,4) comment '非经常性损益项目合计',
  s_fa_deductedprofittoprofit decimal(20,4) comment '扣除非经常损益后的净利润',
  s_fa_deductedprofittoprofit1 decimal(20,4) comment '扣除非经常损益后的归属公司股东的净利润',
  fairvalue_change_gains_losses decimal(20,4) comment '持有(或处置)交易性金融资产和负债产生的公允价值变动损益',
  provision_impairment_reversed decimal(20,4) comment '单独进行监制测试的应收款项减值准备转回',
  proceeds_loan decimal(20,4) comment '对外委托贷款取得的收益',
  changes_real_estate_value decimal(20,4) comment '公允价值法计量的投资性房地产价值变动损益',
  profit_loss_adjustment decimal(20,4) comment '法规要求一次性损益调整影响',
  custody_fee_income decimal(20,4) comment '受托经营取得的托管费收入',
  is_published bigint comment '是否公布',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



