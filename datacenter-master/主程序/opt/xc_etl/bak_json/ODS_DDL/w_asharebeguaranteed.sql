drop table if exists ty_ods.w_asharebeguaranteed;
create table if not exists ty_ods.w_asharebeguaranteed
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '担保公司名称',
  s_info_comp_sname string comment '担保公司中文简称',
  s_info_compcode1 string comment '担保公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



