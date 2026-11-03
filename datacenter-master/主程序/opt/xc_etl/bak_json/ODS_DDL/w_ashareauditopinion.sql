drop table if exists ty_ods.w_ashareauditopinion;
create table if not exists ty_ods.w_ashareauditopinion
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  s_stmnote_audit_category bigint comment '审计结果类别代码',
  s_stmnote_audit_agency string comment '会计师事务所',
  s_stmnote_audit_cpa string comment '签字会计师',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



