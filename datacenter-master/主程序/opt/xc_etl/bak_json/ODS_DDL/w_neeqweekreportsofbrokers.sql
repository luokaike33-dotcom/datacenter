drop table if exists ty_ods.w_neeqweekreportsofbrokers;
create table if not exists ty_ods.w_neeqweekreportsofbrokers
(
  object_id string comment '对象ID',
  broker_id string comment '券商ID',
  typecode bigint comment '周报类型',
  start_date string comment '起始日期',
  closing_date string comment '截止日期',
  make_market_num decimal(20,4) comment '做市企业数量',
  listed_companies_num decimal(20,4) comment '累计推荐挂牌企业数量',
  market_making_enterprise_ratio decimal(20,4) comment '当周做市企业数量占比',
  trading_volume decimal(20,4) comment '当周做市成交量',
  trading_volume_ratio decimal(20,4) comment '当周做市成交量市场占比',
  market_turnover decimal(20,4) comment '当周做市成交额',
  market_turnover_ratio decimal(20,4) comment '当周做市成交额市场占比',
  report_period string comment '披露定期报告报告期',
  supervision_company_num bigint comment '持续督导公司家数',
  this_period_disclosure_num bigint comment '本期披露定期报告的公司家数',
  accumulative_disclosure_num bigint comment '累计披露定期报告的公司家数',
  not_yet_disclosure_num bigint comment '尚未披露定期报告的公司家数',
  corrections_num bigint comment '定期报告披露后进行更正的公司家数',
  delayed_disclosure_num bigint comment '延迟披露定期报告的公司家数',
  existing_problems_num bigint comment '定期报告披露督导中存在其他问题的公司家数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



