drop table if exists ty_ods.w_ashareinsuranceindicator;
create table if not exists ty_ods.w_ashareinsuranceindicator
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type bigint comment '报表类型',
  cap_adequacy_ratio_life decimal(20,4) comment '寿险：偿付能力充足率',
  cap_adequacy_ratio_property decimal(20,4) comment '产险：偿付能力充足率',
  surrender_rate decimal(20,4) comment '退保率',
  policy_persistency_rate_13m decimal(20,4) comment '保单继续率-13个月',
  policy_persistency_rate_25m decimal(20,4) comment '保单继续率-25个月',
  policy_persistency_rate_14m decimal(20,4) comment '保单继续率-14个月',
  policy_persistency_rate_26m decimal(20,4) comment '保单继续率-26个月',
  net_investment_yield decimal(20,4) comment '净投资收益率',
  total_investment_yield decimal(20,4) comment '总投资收益率',
  risk_discount_rate decimal(20,4) comment '评估利率假设：风险贴现率',
  combined_cost_property decimal(20,4) comment '产险：综合成本率',
  loss_ratio_property decimal(20,4) comment '产险：赔付率',
  fee_ratio_property decimal(20,4) comment '产险：费用率',
  intrinsic_value_life decimal(20,4) comment '寿险：内含价值',
  value_new_business_life decimal(20,4) comment '寿险：新业务价值',
  value_effective_business_life decimal(20,4) comment '寿险：有效业务价值',
  actual_capital_life decimal(20,4) comment '寿险：实际资本',
  minimun_capital_life decimal(20,4) comment '寿险：最低资本',
  actual_capital_property decimal(20,4) comment '产险：实际资本',
  minimun_capital_property decimal(20,4) comment '产险：最低资本',
  actual_capital_group decimal(20,4) comment '集团：实际资本',
  minimun_capital_group decimal(20,4) comment '集团：最低资本',
  capital_adequacy_ratio_group decimal(20,4) comment '集团：偿付能力充足率',
  crncy_code string comment '货币代码',
  report_type bigint comment '报告类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



