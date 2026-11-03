drop table if exists ty_ods.w_hsharesalessegment;
create table if not exists ty_ods.w_hsharesalessegment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '[内部]公告日期',
  begindate string comment '起始日期',
  enddate string comment '截止日期',
  statement_typecode bigint comment '报表类型代码',
  report_typecode bigint comment '报告类型代码',
  crncy_code string comment '货币代码',
  segment_itemcode bigint comment '项目类别代码',
  resourcecode bigint comment '[内部]文件类型代码',
  segment_item string comment '主营业务项目',
  segment_sales decimal(20,4) comment '主营业务收入',
  segment_cost decimal(20,4) comment '主营业务成本',
  grossprofit decimal(20,4) comment '毛利',
  segment_sales_ratio decimal(20,4) comment '主营业务收入比例',
  segment_cost_ratio decimal(20,4) comment '主营业务成本比例',
  grossprofitmargin decimal(20,4) comment '毛利率',
  prime_oper_rev_yoy decimal(20,4) comment '主营业务收入同比增长率',
  prime_oper_cost_yoy decimal(20,4) comment '主营业务成本同比增长率',
  gross_profit_margin_yoy decimal(20,4) comment '毛利率同比增长率',
  gross_profit_yoy decimal(20,4) comment '毛利同比增长率',
  prime_oper_profit_ratio decimal(20,4) comment '主营业务利润比例',
  accounts_id string comment '科目ID',
  ispublishvalue bigint comment '[内部]是否公布值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



