drop table if exists ty_ods.w_cbondsalessegment;
create table if not exists ty_ods.w_cbondsalessegment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_segment_item string comment '主营业务项目',
  s_segment_cost_ratio bigint comment '主营业务成本比例(%)',
  s_segment_profit_ratio bigint comment '主营业务利润比例(%)',
  s_segment_sales_ratio bigint comment '主营业务收入比例(%)',
  s_report_period string comment '报告期',
  s_crncy_code string comment '货币代码',
  s_segment_sales bigint comment '主营业务收入',
  s_segment_profit bigint comment '主营业务利润',
  s_segment_itemcode string comment '项目类别',
  s_segment_cost bigint comment '主营业务成本',
  s_grossprofitmargin bigint comment '毛利率(%)',
  s_prime_oper_rev_yoy bigint comment '主营业务收入比上年增减(%)',
  s_prime_oper_cost_yoy bigint comment '主营业务成本比上年增减(%)',
  s_gross_profit_margin_yoy bigint comment '毛利率比上年增减(%)',
  s_segment_item_code string comment '容错后主营业务项目',
  s_segment_sales_code bigint comment '主营业务收入项目代码',
  s_accounts_id string comment '科目ID',
  s_is_publishvalue bigint comment '[内部]是否公布值',
  s_gross_profit_yoy bigint comment '毛利同比增长率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



