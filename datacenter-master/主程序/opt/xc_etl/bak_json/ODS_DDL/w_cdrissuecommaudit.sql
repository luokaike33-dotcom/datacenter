drop table if exists ty_ods.w_cdrissuecommaudit;
create table if not exists ty_ods.w_cdrissuecommaudit
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_companyname string comment '公司名称',
  s_ic_year string comment '年度',
  s_ic_sessiontimes string comment '会议届次',
  s_ic_audittype string comment '审核类型',
  s_ic_type bigint comment '发审委类型',
  s_ic_announcementdate string comment '会议公告日期',
  s_ic_date string comment '会议日期',
  s_ic_auditocetype string comment '审核结果类型',
  s_ic_auditannocedate string comment '审核结果公告日期',
  s_info_expectedissueshares decimal(20,4) comment '预计发行股数(万股)',
  s_info_expectedcollection decimal(20,4) comment '预计募集资金(万元)',
  s_info_veto_reason string comment '被否原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



