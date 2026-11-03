drop table if exists ty_ods.w_commitprofitsummary;
create table if not exists ty_ods.w_commitprofitsummary
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_info_commitann_dt string comment '承诺公告日',
  ann_dt string comment '最新公告日',
  targetcomp string comment '标的公司',
  commitnetprofit decimal(20,4) comment '承诺净利润(元)',
  actualnetprofit decimal(20,4) comment '实际净利润(元)',
  iscommitprofitsupply bigint comment '是否承诺利润补充',
  isneedsupply bigint comment '是否需要补充',
  supplycontent bigint comment '补偿内容代码',
  injectedassetnetprofitest decimal(20,4) comment '注入资产净利润预测(元)',
  earningest decimal(20,4) comment '上市公司盈利预测(元)',
  supplytype bigint comment '盈利补偿方法代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



