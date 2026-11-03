drop table if exists ty_ods.esg_xq_esg_alt_audit_detail;
create table if not exists ty_ods.esg_xq_esg_alt_audit_detail
(
  company_id string,
  companyname string,
  ticker string,
  `exchange` string,
  auditdate timestamp,
  reportdate timestamp,
  audityear decimal(32,12),
  accountingfirmname string,
  cpa string,
  opiniontype string,
  nonstandardexplain string,
  auditpay decimal(32,12),
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



