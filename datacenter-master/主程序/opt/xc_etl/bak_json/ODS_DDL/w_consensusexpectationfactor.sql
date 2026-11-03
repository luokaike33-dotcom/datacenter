drop table if exists ty_ods.w_consensusexpectationfactor;
create table if not exists ty_ods.w_consensusexpectationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '日期',
  s_west_netprofit_ftm_chg_1m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_1M',
  s_west_netprofit_ftm_chg_3m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_3M',
  s_west_netprofit_ftm_chg_6m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_6M',
  s_west_eps_ftm_chg_1m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_1M',
  s_west_eps_ftm_chg_3m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_3M',
  s_west_eps_ftm_chg_6m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_6M',
  s_west_sales_ftm_chg_1m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_1M',
  s_west_sales_ftm_chg_3m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_3M',
  s_west_sales_ftm_chg_6m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_6M',
  s_west_netprofit_fy1_chg_1m decimal(20,6) comment '一致预测净利润（FY1）的变化_1M',
  s_west_netprofit_fy1_chg_3m decimal(20,6) comment '一致预测净利润（FY1）的变化_3M',
  s_west_netprofit_fy1_chg_6m decimal(20,6) comment '一致预测净利润（FY1）的变化_6M',
  s_west_eps_fy1_chg_1m decimal(20,6) comment '一致预测每股收益（FY1）的变化_1M',
  s_west_eps_fy1_chg_3m decimal(20,6) comment '一致预测每股收益（FY1）的变化_3M',
  s_west_eps_fy1_chg_6m decimal(20,6) comment '一致预测每股收益（FY1）的变化_6M',
  s_west_sales_fy1_chg_1m decimal(20,6) comment '一致预测营业收入(FY1）的变化_1M',
  s_west_sales_fy1_chg_3m decimal(20,6) comment '一致预测营业收入(FY1）的变化_3M',
  s_west_sales_fy1_chg_6m decimal(20,6) comment '一致预测营业收入(FY1）的变化_6M',
  s_west_netprofit_ftm_1m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_1M',
  s_west_netprofit_ftm_3m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_3M',
  s_west_netprofit_ftm_6m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_6M',
  s_west_eps_ftm_1m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_1M',
  s_west_eps_ftm_3m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_3M',
  s_west_eps_ftm_6m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_6M',
  s_west_sales_ftm_1m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_1M',
  s_west_sales_ftm_3m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_3M',
  s_west_sales_ftm_6m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_6M',
  s_west_netprofit_fy1_1m decimal(20,6) comment '一致预测净利润（FY1）变化率_1M',
  s_west_netprofit_fy1_3m decimal(20,6) comment '一致预测净利润（FY1）变化率_3M',
  s_west_netprofit_fy1_6m decimal(20,6) comment '一致预测净利润（FY1）变化率_6M',
  s_west_eps_fy1_1m decimal(20,6) comment '一致预测每股收益（FY1）变化率_1M',
  s_west_eps_fy1_3m decimal(20,6) comment '一致预测每股收益（FY1）变化率_3M',
  s_west_eps_fy1_6m decimal(20,6) comment '一致预测每股收益（FY1）变化率_6M',
  s_west_sales_fy1_1m decimal(20,6) comment '一致预测营业收入(FY1）变化率_1M',
  s_west_sales_fy1_3m decimal(20,6) comment '一致预测营业收入(FY1）变化率_3M',
  s_west_sales_fy1_6m decimal(20,6) comment '一致预测营业收入(FY1）变化率_6M',
  s_west_eps_fygrowth decimal(20,6) comment '一致预测每股收益（FY2)与一致预测每股收益(FY1)的变化率',
  s_west_netprofitmaxmin_fy1 decimal(20,6) comment '一致预测净利润（FY1）最大与一致预测净利润（FY1）最小值的变化率',
  s_west_epsmaxmin_fy1 decimal(20,6) comment '一致预测每股收益（FY1）最大与一致预测每股收益（FY1）最小值的变化率',
  s_west_salesmaxmin_fy1 decimal(20,6) comment '一致预测营业收入（FY1）最大与一致预测营业收入（FY1）最小值的变化率',
  s_west_stdnetprofit_fy1 decimal(20,6) comment '一致预测净利润（FY1）标准差',
  s_west_stdeps_fy1 decimal(20,6) comment '一致预测每股收益（FY1）标准差',
  s_west_stdsales_fy1 decimal(20,6) comment '一致预测营业收入（FY1）标准差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '一致预期因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



