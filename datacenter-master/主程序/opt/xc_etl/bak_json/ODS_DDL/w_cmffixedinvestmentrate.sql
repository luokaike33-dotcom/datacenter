drop table if exists ty_ods.w_cmffixedinvestmentrate;
create table if not exists ty_ods.w_cmffixedinvestmentrate
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  f_type_code string comment '投资类型代码',
  f_type_name string comment '基金投资类型名称',
  f_fixed_investment_cycle string comment '定投周期',
  f_fixed_amount bigint comment '定投金额',
  f_purchase_rate decimal(20,4) comment '申购费率',
  f_dividend_method string comment '分红方式',
  f_avgreturn_thisyear decimal(20,6) comment '近一年定投总收益率',
  f_sfrank_recentyeart string comment '近一年定投同类排名',
  f_annualyeild_thisyear decimal(20,6) comment '近一年定投年化收益率',
  f_recentyeart_thisyear string comment '近一年定投年化收益同类排名',
  f_avgreturn_twoyear decimal(20,6) comment '近二年定投总收益率',
  f_sfrank_recentyeart_twosyear string comment '近二年定投同类排名',
  f_annualyeild_twosyear decimal(20,6) comment '近二年定投年化收益率',
  f_annualyeild_twoyear string comment '近二年定投年化收益同类排名',
  f_avgreturn_threeyear decimal(20,6) comment '近三年定投总收益率',
  f_sfrank_threesyear string comment '近三年定投同类排名',
  f_annualyeild_threesyear decimal(20,6) comment '近三年定投年化收益率',
  f_annualyeild_threeyear string comment '近三年定投年化收益同类排名',
  f_avgreturn_fiveyear decimal(20,6) comment '近五年定投总收益率',
  f_sfrank_recentyeart_fivesyear string comment '近五年定投同类排名',
  f_annualyeild_fivesyear decimal(20,6) comment '近五年定投年化收益率',
  f_annualyeild_fiveyear string comment '近五年定投年化收益同类排名',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



