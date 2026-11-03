drop table if exists ty_ods.w_hkprofitforecast;
create table if not exists ty_ods.w_hkprofitforecast
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  institution string comment '机构',
  analyst string comment '分析师',
  r_report_type string comment '研究报告类型代码',
  startdate string comment '起始日期',
  enddate string comment '截止日期',
  est_date string comment '预测日期',
  est_eps decimal(10,4) comment '预测每股收益',
  est_main_bus decimal(20,4) comment '预测营业收入',
  est_net_profit decimal(20,4) comment '预测净利润',
  memo string comment '[内部]备注',
  acc_sta string comment '会计准则',
  crncy_code string comment '货币代码',
  report_type string comment '定期报告类型代码',
  est_enddate string comment '预测有效截止日',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



