drop table if exists ty_ods.esg_xq_esg_indicator_detail;
create table if not exists ty_ods.esg_xq_esg_indicator_detail
(
  globalid string,
  company_id string,
  company_name string,
  exchange_mic string,
  ticker string,
  security_name string,
  report_year decimal(32,12),
  report_name string,
  indicator_code string,
  value_type string,
  text_value string,
  num_value decimal(32,12),
  unit string,
  currency string,
  standard_num_value decimal(32,12),
  standard_unit string,
  standard_currency string,
  page_numbers string,
  remark string,
  remark_intensity string,
  publish_date timestamp,
  scope string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



