drop table if exists ty_ods.w_cbondindexperformance;
create table if not exists ty_ods.w_cbondindexperformance
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  pct_chg_recent1m decimal(20,6) comment '最近1月涨跌幅',
  pct_chg_recent3m decimal(20,6) comment '最近3月涨跌幅',
  pct_chg_recent6m decimal(20,6) comment '最近6月涨跌幅',
  pct_chg_recent1y decimal(20,6) comment '最近1年涨跌幅',
  pct_chg_recent2y decimal(20,6) comment '最近2年涨跌幅',
  pct_chg_recent3y decimal(20,6) comment '最近3年涨跌幅',
  pct_chg_recent4y decimal(20,6) comment '最近4年涨跌幅',
  pct_chg_recent5y decimal(20,6) comment '最近5年涨跌幅',
  pct_chg_recent6y decimal(20,6) comment '最近6年涨跌幅',
  pct_chg_thisweek decimal(20,6) comment '本周以来涨跌幅',
  pct_chg_thismonth decimal(20,6) comment '本月以来涨跌幅',
  pct_chg_thisquarter decimal(20,6) comment '本季以来涨跌幅',
  pct_chg_thisyear decimal(20,6) comment '本年以来涨跌幅',
  si_pct_chg decimal(20,6) comment '发布以来涨跌幅',
  annualyeild decimal(20,6) comment '年化收益率',
  std_dev_6m decimal(20,6) comment '6个月标准差',
  std_dev_1y decimal(20,6) comment '1年标准差',
  std_dev_2y decimal(20,6) comment '2年标准差',
  std_dev_3y decimal(20,6) comment '3年标准差',
  sharpratio_6m decimal(20,6) comment '6个月夏普比率',
  sharpratio_1y decimal(20,6) comment '1年夏普比率',
  sharpratio_2y decimal(20,6) comment '2年夏普比率',
  sharpratio_3y decimal(20,6) comment '3年夏普比率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



