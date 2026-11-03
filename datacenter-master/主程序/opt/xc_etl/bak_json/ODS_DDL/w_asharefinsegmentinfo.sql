drop table if exists ty_ods.w_asharefinsegmentinfo;
create table if not exists ty_ods.w_asharefinsegmentinfo
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  class_code bigint comment '分部类别代码',
  subject_code bigint comment '科目代码',
  item_amount decimal(20,4) comment '金额',
  unit string comment '单位',
  crncy_code string comment '货币代码',
  subject_name_ann string comment '[内部]公布科目名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



