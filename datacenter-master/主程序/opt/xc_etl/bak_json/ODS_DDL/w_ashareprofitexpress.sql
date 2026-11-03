drop table if exists ty_ods.w_ashareprofitexpress;
create table if not exists ty_ods.w_ashareprofitexpress
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  oper_rev decimal(20,4) comment '营业总收入(元)',
  oper_profit decimal(20,4) comment '营业利润(元)',
  tot_profit decimal(20,4) comment '利润总额(元)',
  net_profit_excl_min_int_inc decimal(20,4) comment '净利润(元)',
  tot_assets decimal(20,4) comment '总资产(元)',
  tot_shrhldr_eqy_excl_min_int decimal(20,4) comment '股东权益合计(不含少数股东权益)(元)',
  eps_diluted decimal(20,4) comment '每股收益-基本(元)',
  roe_diluted decimal(20,4) comment '净资产收益率-加权(%)',
  s_isaudit bigint comment '是否审计',
  yoynet_profit_excl_min_int_inc decimal(20,4) comment '去年同期修正后净利润',
  brief_performance string comment '业绩简要说明',
  memo string comment '备注',
  s_fa_bps decimal(20,4) comment '每股净资产',
  s_fa_yoysales decimal(20,4) comment '同比增长率:营业总收入',
  s_fa_yoyop decimal(20,4) comment '同比增长率:营业利润',
  s_fa_yoyebt decimal(20,4) comment '同比增长率:利润总额',
  s_fa_yoynetprofit_deducted decimal(20,4) comment '同比增长率:归属母公司股东的净利润',
  s_fa_yoyeps_basic decimal(20,4) comment '同比增长率:基本每股收益',
  s_fa_roe_yearly decimal(20,4) comment '同比增减:加权平均净资产收益率',
  s_fa_growth_assets decimal(20,4) comment '比年初增长率:总资产',
  s_fa_yoyequity decimal(20,4) comment '比年初增长率:归属母公司的股东权益',
  growth_bps_sh decimal(20,4) comment '比年初增长率:归属于母公司股东的每股净资产',
  last_year_oper_rev decimal(20,4) comment '去年同期营业总收入',
  last_year_oper_profit decimal(20,4) comment '去年同期营业利润',
  last_year_tot_profit decimal(20,4) comment '去年同期利润总额',
  last_year_net_profit_excl_inc decimal(20,4) comment '去年同期净利润',
  last_year_eps_diluted decimal(20,4) comment '去年同期每股收益',
  s_early_net_assets decimal(20,4) comment '期初净资产',
  s_early_bps decimal(20,4) comment '期初每股净资产',
  actual_ann_dt string comment '实际公告日期',
  performexp_npdedtoshareholder decimal(20,4) comment '归属于上市公司股东的扣除非经常性损益的净利润',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国A股业绩快报'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



