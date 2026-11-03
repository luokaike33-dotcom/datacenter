drop table if exists ty_ods.esg_xq_esg_alt_cert_cnca_all;
create table if not exists ty_ods.esg_xq_esg_alt_cert_cnca_all
(
  company_id string,
  organization_name string,
  ticker string,
  `exchange` string,
  relatedcompanyname string,
  relationship string,
  certificate_number string,
  certificate_status string,
  certified_date timestamp,
  certificate_expiry_date timestamp,
  certification_program string,
  certification_basis string,
  approved_identification string,
  certified_business_scope string,
  certified_cover_address string,
  country_and_region string,
  cert_covers_people_num string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



