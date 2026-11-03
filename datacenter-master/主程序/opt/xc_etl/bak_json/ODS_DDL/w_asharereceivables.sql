drop table if exists ty_ods.w_asharereceivables;
create table if not exists ty_ods.w_asharereceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '下游公司名称',
  s_info_comp_sname string comment '下游公司中文简称',
  s_info_compcode1 string comment '下游公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  s_info_discloser string comment '披露公司ID',
  period string comment '拖欠时间',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



