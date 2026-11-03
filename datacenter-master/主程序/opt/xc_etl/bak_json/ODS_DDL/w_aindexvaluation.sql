drop table if exists ty_ods.w_aindexvaluation;
create table if not exists ty_ods.w_aindexvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  trade_dt string comment '交易日期',
  con_num decimal(20,4) comment '成分股数量',
  pe_lyr decimal(20,4) comment '市盈率(PE,LYR)',
  pe_ttm decimal(20,4) comment '市盈率(PE,TTM)',
  pb_lf decimal(20,4) comment '市净率(PB,LF)',
  pcf_lyr decimal(20,4) comment '市现率(PCF,LYR)',
  pcf_ttm decimal(20,4) comment '市现率(PCF,TTM)',
  ps_lyr decimal(20,4) comment '市销率(PS,LYR)',
  ps_ttm decimal(20,4) comment '市销率(PS,TTM)',
  mv_total decimal(24,4) comment '当日总市值合计（元）',
  mv_float decimal(24,4) comment '当日流通市值合计（元）',
  dividend_yield decimal(20,4) comment '股息率',
  peg_his decimal(20,4) comment '历史PEG',
  tot_shr decimal(20,4) comment '总股本合计（股）',
  tot_shr_float decimal(20,4) comment '流通股本合计（股）',
  tot_shr_free decimal(20,4) comment '自由流通股本合计（股）',
  turnover decimal(20,4) comment '换手率',
  turnover_free decimal(20,4) comment '换手率(自由流通)',
  est_net_profit_y1 decimal(20,4) comment '预测净利润(Y1)',
  est_net_profit_y2 decimal(20,4) comment '预测净利润(Y2)',
  est_bus_inc_y1 decimal(20,4) comment '预测营业收入(Y1)',
  est_bus_inc_y2 decimal(20,4) comment '预测营业收入(Y2)',
  est_eps_y1 decimal(20,4) comment '预测每股收益(Y1)',
  est_eps_y2 decimal(20,4) comment '预测每股收益(Y2)',
  est_yoyprofit_y1 decimal(20,4) comment '预测净利润同比增速(Y1)',
  est_yoyprofit_y2 decimal(20,4) comment '预测净利润同比增速(Y2)',
  est_yoygr_y1 decimal(20,4) comment '预测营业收入同比增速(Y1)',
  est_yoygr_y2 decimal(20,4) comment '预测营业收入同比增速(Y2)',
  est_pe_y1 decimal(20,4) comment '预测PE(Y1)',
  est_pe_y2 decimal(20,4) comment '预测PE(Y2)',
  est_peg_y1 decimal(20,4) comment '预测PEG(Y1)',
  est_peg_y2 decimal(20,4) comment '预测PEG(Y2)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



