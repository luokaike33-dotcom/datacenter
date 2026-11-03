drop table if exists ty_ods.w_sindexperformance;
create table if not exists ty_ods.w_sindexperformance
(
  object_id string,
  s_info_windcode string,
  trade_dt string,
  pct_chg_recent1m decimal(20,6),
  pct_chg_recent3m decimal(20,6),
  pct_chg_recent6m decimal(20,6),
  pct_chg_recent1y decimal(20,6),
  pct_chg_recent2y decimal(20,6),
  pct_chg_recent3y decimal(20,6),
  pct_chg_recent4y decimal(20,6),
  pct_chg_recent5y decimal(20,6),
  pct_chg_recent6y decimal(20,6),
  pct_chg_thisweek decimal(20,6),
  pct_chg_thismonth decimal(20,6),
  pct_chg_thisquarter decimal(20,6),
  pct_chg_thisyear decimal(20,6),
  si_pct_chg decimal(20,6),
  annualyeild decimal(20,6),
  std_dev_6m decimal(20,6),
  std_dev_1y decimal(20,6),
  std_dev_2y decimal(20,6),
  std_dev_3y decimal(20,6),
  sharpratio_6m decimal(20,6),
  sharpratio_1y decimal(20,6),
  sharpratio_2y decimal(20,6),
  sharpratio_3y decimal(20,6),
  pct_chg_recent1w decimal(20,6),
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



