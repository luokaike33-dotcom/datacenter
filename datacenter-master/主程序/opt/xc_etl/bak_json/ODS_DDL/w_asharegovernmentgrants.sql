drop table if exists ty_ods.w_asharegovernmentgrants;
create table if not exists ty_ods.w_asharegovernmentgrants
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  item_name string comment '项目',
  amount_current_issue decimal(20,4) comment '本期发生额',
  amount_previous_period decimal(20,4) comment '上期发生额',
  memo string comment '说明',
  currency_code string comment '货币代码',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



