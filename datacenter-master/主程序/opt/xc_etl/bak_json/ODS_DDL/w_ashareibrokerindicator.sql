drop table if exists ty_ods.w_ashareibrokerindicator;
create table if not exists ty_ods.w_ashareibrokerindicator
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  iflisted_data bigint comment '是否上市后数据',
  net_capital decimal(20,4) comment '净资本',
  trusted_capital decimal(20,4) comment '受托资金',
  net_gearing_ratio decimal(20,4) comment '净资本负债率(%)',
  prop_equity_ratio decimal(20,4) comment '自营权益类证券比例',
  longterm_invest_ratio decimal(20,4) comment '长期投资比例',
  fixed_capital_ratio decimal(20,4) comment '固定资本比例',
  fee_business_ratio decimal(20,4) comment '营业费用率',
  total_capital_return decimal(20,4) comment '总资产收益率',
  net_capital_yield decimal(20,4) comment '净资本收益率',
  current_ratio decimal(20,4) comment '流动比率',
  asset_liability_ratio decimal(20,4) comment '资产负债率',
  asset_turnover_ratio decimal(20,4) comment '资产周转率',
  net_capital_return decimal(20,4) comment '净资产收益率',
  contingent_liability_ratio decimal(20,4) comment '或有负债(担保）比率',
  prop_securities decimal(20,4) comment '自营证券',
  treasury_bond decimal(20,4) comment '国债',
  investment_funds decimal(20,4) comment '投资基金',
  stocks decimal(20,4) comment '股票',
  convertible_bond decimal(20,4) comment '可转债',
  per_capita_profits decimal(20,4) comment '人均利润',
  net_cap_total_riskprov decimal(20,4) comment '净资本/各项风险准备之和',
  net_cap_net_assets decimal(20,4) comment '净资本/净资产',
  prop_equ_der_netcap decimal(20,4) comment '自营权益类证券及证券衍生品/净资本',
  prop_fixedincome_netcap decimal(20,4) comment '自营固定收益类证券/净资本',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



