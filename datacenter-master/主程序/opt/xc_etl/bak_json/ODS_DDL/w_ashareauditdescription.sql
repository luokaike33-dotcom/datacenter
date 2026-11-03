drop table if exists ty_ods.w_ashareauditdescription;
create table if not exists ty_ods.w_ashareauditdescription
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  audit_project_type bigint comment '审计项目类型代码',
  audit_matters_type string comment '关键审计事项类型',
  audit_matters_num bigint comment '关键审计事项序号',
  matter_description string comment '事项描述',
  audit_response string comment '审计应对',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



