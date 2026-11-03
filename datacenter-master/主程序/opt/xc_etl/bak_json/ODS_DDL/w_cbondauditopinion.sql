drop table if exists ty_ods.w_cbondauditopinion;
create table if not exists ty_ods.w_cbondauditopinion
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  s_stmnote_audit_category bigint comment '审计结果类别代码',
  s_stmnote_audit_agency string comment '会计师事务所',
  s_stmnote_audit_cpa string comment '签字会计师',
  audit_agency string comment '审计机构类别',
  audit_agency_code bigint comment '审计机构类别代码',
  s_in_control_audit_opinion bigint comment '内控审计意见类别代码',
  ann_dt1 string comment '内控审计报告公告日期',
  s_in_control_accounting_firm string comment '内控会计师事务所ID',
  s_in_control_accountant string comment '内控签字会计师',
  s_audit_fee_memo string comment '审计费用说明',
  s_audit_result_memo string comment '审计结果说明',
  s_in_control_audit string comment '内控审计结果说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



