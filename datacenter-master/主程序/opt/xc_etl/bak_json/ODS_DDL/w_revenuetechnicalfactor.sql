drop table if exists ty_ods.w_revenuetechnicalfactor;
create table if not exists ty_ods.w_revenuetechnicalfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_risk_earning_day decimal(20,8) comment '每日收益',
  s_risk_variance20 decimal(20,8) comment '20日收益方差',
  s_risk_variance30 decimal(20,8) comment '30日收益方差',
  s_risk_variance60 decimal(20,8) comment '60日收益方差',
  s_risk_variance120 decimal(20,8) comment '120日收益方差',
  s_risk_gainvariance20 decimal(20,8) comment '20日正收益方差',
  s_risk_gainvariance60 decimal(20,8) comment '60日正收益方差',
  s_risk_gainvariance120 decimal(20,8) comment '120日正收益方差',
  s_risk_lossvariance20 decimal(20,8) comment '20日损失方差',
  s_risk_lossvariance60 decimal(20,8) comment '60日损失方差',
  s_risk_lossvariance120 decimal(20,8) comment '120日损失方差',
  s_risk_glvarianceratio20 decimal(20,8) comment '20日收益损失方差比',
  s_risk_glvarianceratio60 decimal(20,8) comment '60日收益损失方差比',
  s_risk_glvarianceratio120 decimal(20,8) comment '120日收益损失方差比',
  s_risk_revsvarratio decimal(20,8) comment '30日120日回报方差比率',
  s_risk_kurtosis20 decimal(20,8) comment '个股收益的20日峰度',
  s_risk_kurtosis60 decimal(20,8) comment '个股收益的60日峰度',
  s_risk_kurtosis120 decimal(20,8) comment '个股收益的120日峰度',
  s_risk_beta20 decimal(20,8) comment '个股20日的beta值',
  s_risk_beta60 decimal(20,8) comment '个股60日的beta值',
  s_risk_beta120 decimal(20,8) comment '个股120日的beta值',
  s_risk_treynorratio20 decimal(20,8) comment '20日特诺雷比率',
  s_risk_treynorratio60 decimal(20,8) comment '60日特诺雷比率',
  s_risk_treynorratio120 decimal(20,8) comment '120日特诺雷比率',
  s_tech_revs5 decimal(20,8) comment '过去5日的价格动量',
  s_tech_revs10 decimal(20,8) comment '过去10日的价格动量',
  s_tech_revs20 decimal(20,8) comment '过去1个月的价格动量',
  s_tech_revs60 decimal(20,8) comment '过去3个月的价格动量',
  s_tech_revs120 decimal(20,8) comment '过去6个月的价格动量',
  s_tech_revs250 decimal(20,8) comment '过去1年的价格动量',
  s_tech_revs750 decimal(20,8) comment '过去3年的价格动量',
  s_tech_revs5m20 decimal(20,8) comment '过去5日的价格动量-过去1个月的价格动量',
  s_tech_revs5m60 decimal(20,8) comment '过去5日的价格动量-过去3个月的价格动量',
  s_tech_rank1m decimal(20,8) comment '1-过去一个月收益率排名/股票总数的比值',
  s_tech_revs6m20 decimal(20,8) comment '过去6个月的动量-过去1个月的动量',
  s_tech_revs12m20 decimal(20,8) comment '过去12个月的动量-过去1个月的动量',
  s_tech_revs12m6m decimal(20,8) comment '12M收益率的120D变化率',
  s_tech_revs1mmax decimal(20,8) comment '过去1个月的日收益率的最大值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '收益类技术因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



