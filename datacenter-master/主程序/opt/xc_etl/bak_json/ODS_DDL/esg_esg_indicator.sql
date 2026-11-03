drop table if exists ty_ods.esg_esg_indicator;
create table if not exists ty_ods.esg_esg_indicator
(
  indicator_code string,
  esg_type string,
  level decimal(32,12),
  level1_code string,
  level1_name string,
  level2_code string,
  level2_name string,
  level3_code string,
  level3_name string,
  level4_code string,
  level4_name string,
  level5_code string,
  level5_name string,
  name_en_us string,
  name_zh_cn string,
  name_zh_hk string,
  polarity string,
  standard_currency string,
  standard_unit string,
  value_type string,
  basis_process string,
  basis_def_value string,
  basis_polarity string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



