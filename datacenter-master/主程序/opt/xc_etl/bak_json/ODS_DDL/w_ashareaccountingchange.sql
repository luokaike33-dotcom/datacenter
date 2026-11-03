drop table if exists ty_ods.w_ashareaccountingchange;
create table if not exists ty_ods.w_ashareaccountingchange
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  s_change_itemcode bigint comment '变更项目代码',
  s_change_reason string comment '变更的内容和原因',
  s_approval_program string comment '审批程序',
  be_affected_itemcode string comment '受影响的报表项目名称',
  influence_money decimal(20,4) comment '影响金额(元)',
  crncy_code string comment '货币代码',
  ann_date string comment '公告日期',
  be_affected_report_period string comment '受影响的报告期',
  be_affected_report_type bigint comment '受影响的报表类型',
  be_affected_subject string comment '受影响的报表科目名称(容错)',
  processing_result string comment '董事会对责任人采取的问责措施及处理结果',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



