drop table if exists ty_ods.w_aindexconsensusrollingdata;
create table if not exists ty_ods.w_aindexconsensusrollingdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  est_dt string comment '日期',
  rolling_type string comment '类型',
  net_profit decimal(20,4) comment '净利润',
  est_eps decimal(20,4) comment '每股收益',
  est_pe decimal(20,4) comment '市盈率',
  est_peg decimal(20,4) comment 'PEG',
  est_ decimal(20,4) comment '市净率',
  est_roe decimal(20,4) comment '净资产收益率',
  est_oper_revenue decimal(20,4) comment '营业收入',
  est_cfps decimal(20,4) comment '每股现金流',
  est_dps decimal(20,4) comment '每股股利',
  est_bps decimal(20,4) comment '每股净资产',
  est_ebit decimal(20,4) comment '息税前利润',
  est_ebitda decimal(20,4) comment '息税折旧摊销前利润',
  est_total_profit decimal(20,4) comment '利润总额',
  est_oper_profit decimal(20,4) comment '营业利润',
  est_oper_cost decimal(20,4) comment '营业成本及附加',
  benchmark_yr string comment '基准年度',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'Wind一致预测指数滚动指标'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



