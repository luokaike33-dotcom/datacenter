drop table if exists ty_ods.w_asharerelatedclaimsdebts;
create table if not exists ty_ods.w_asharerelatedclaimsdebts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  associated_name string comment '关联方名称',
  associated_funding_amount decimal(20,4) comment '向关联方提供资金发生额',
  associated_funding_balance decimal(20,4) comment '向关联方提供资金余额',
  ashare_funding_amount decimal(20,4) comment '关联方向上市公司提供资金发生额',
  ashare_funding_balance decimal(20,4) comment '关联方向上市公司提供资金余额',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  crncy_code string comment '货币代码',
  connection_relation string comment '关联关系',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



