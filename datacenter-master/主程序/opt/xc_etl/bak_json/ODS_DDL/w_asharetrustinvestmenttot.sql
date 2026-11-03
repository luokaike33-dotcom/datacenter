drop table if exists ty_ods.w_asharetrustinvestmenttot;
create table if not exists ty_ods.w_asharetrustinvestmenttot
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_date string comment '公告日期',
  rp_sale_product decimal(20,4) comment '向关联方销售产品金额合计(万元)',
  contro_party_capital_amount decimal(20,4) comment '向控股方提供资金发生额合计(万元)',
  contro_party_capital_balance decimal(20,4) comment '向控股方提供资金余额合计(万元)',
  rp_amount decimal(20,4) comment '向关联方提供资金发生额合计(万元)',
  rp_balance decimal(20,4) comment '向关联方提供资金余额合计(万元)',
  amount_funds_available decimal(20,4) comment '关联方向上市公司提供资金发生额合计(万元)',
  funding_balance decimal(20,4) comment '关联方向上市公司提供资金余额合计(万元)',
  fp_amount_tot decimal(20,4) comment '委托理财累计金额(万元)',
  fp_balance decimal(20,4) comment '委托理财余额(万元)',
  fp_overdue_amount decimal(20,4) comment '委托理财逾期未收回的本金和收益累计金额(万元)',
  fp_addup_profit decimal(20,4) comment '委托理财收益累计金额(万元)',
  rp_sale_product_ratio decimal(20,4) comment '向关联方销售产品金额占比(%)',
  rp_purchase_amount decimal(20,4) comment '向关联方采购产品金额合计(万元)',
  rp_purchase_ratio decimal(20,4) comment '向关联方采购产品金额占比(%)',
  rp_sale_product_est decimal(20,4) comment '向关联方销售产品预计金额合计(万元)',
  rp_labour_services_est decimal(20,4) comment '向关联方提供劳务预计金额合计(万元)',
  rp_purchase_amount_est decimal(20,4) comment '向关联方采购产品预计金额合计(万元)',
  rp_accept_service_est decimal(20,4) comment '向关联方接受劳务预计金额合计(万元)',
  rp_other_transactions decimal(20,4) comment '向关联方其他交易预计金额合计(万元)',
  pricing_principle string comment '定价原则',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



