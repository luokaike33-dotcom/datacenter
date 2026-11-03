drop table if exists ty_ods.w_asharesalessegment;
create table if not exists ty_ods.w_asharesalessegment
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  crncy_code string comment '货币代码',
  s_segment_itemcode bigint comment '项目类别',
  s_segment_item string comment '主营业务项目',
  s_segment_sales decimal(20,4) comment '主营业务收入(元)',
  s_segment_profit decimal(20,4) comment '主营业务利润(元)',
  s_segment_cost decimal(20,4) comment '主营业务成本(元)',
  is_published_value bigint comment '是否公布值',
  pct_segment_sales decimal(20,4) comment '主营业务收入占比(%)',
  pct_segment_profit decimal(20,4) comment '主营业务利润占比(%)',
  pct_segment_cost decimal(20,4) comment '主营业务成本占比(%)',
  inc_segment_sales decimal(20,4) comment '主营业务收入同比增长率(%)',
  inc_segment_profit decimal(20,4) comment '主营业务利润同比增长率(%)',
  inc_segment_cost decimal(20,4) comment '主营业务成本同比增长率(%)',
  gross_profit_margin decimal(20,4) comment '毛利率(%)',
  inc_profit_margin decimal(20,4) comment '毛利率增长率(%)',
  s_info_compcode string comment '公司ID',
  subject_code string comment '科目ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



