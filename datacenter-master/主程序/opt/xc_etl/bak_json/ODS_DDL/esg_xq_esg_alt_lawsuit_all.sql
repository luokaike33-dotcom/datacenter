drop table if exists ty_ods.esg_xq_esg_alt_lawsuit_all;
create table if not exists ty_ods.esg_xq_esg_alt_lawsuit_all
(
  company_id string,
  companyname string,
  ticker string,
  `exchange` string,
  relatedcompanyname string,
  relationship string,
  lawsuit_company_name string,
  lawsuit_role string,
  lawsuit_other_roles string,
  source_url string,
  lawsuit_court string,
  lawsuit_doc_type string,
  title string,
  publish_date timestamp,
  sentence_date timestamp,
  lawsuit_doc_no string,
  lawsuit_procedure string,
  dispute_type string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



