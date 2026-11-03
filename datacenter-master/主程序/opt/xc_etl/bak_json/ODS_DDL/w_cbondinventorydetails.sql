drop table if exists ty_ods.w_cbondinventorydetails;
create table if not exists ty_ods.w_cbondinventorydetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  inv_object string comment '项目',
  inv_amt decimal(20,4) comment '金额',
  crncy_code string comment '货币代码',
  provision decimal(20,4) comment '跌价准备',
  statement_type bigint comment '报告类型代码',
  net decimal(20,4) comment '净额',
  subject_name string comment '科目名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



