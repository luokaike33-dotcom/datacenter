drop table if exists ty_ods.w_hkshareauditopinion;
create table if not exists ty_ods.w_hkshareauditopinion
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  begin_dt string comment '起始日期',
  end_dt string comment '截止日期',
  audit_std bigint comment '会计准则类型代码',
  s_stmnote_audit_agency string comment '审计机构名称',
  s_stmnote_audit_category string comment '审计意见类型',
  audit_ctnt string comment '非标审计意见内容',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



