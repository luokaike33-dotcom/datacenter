drop table if exists ty_ods.esg_xq_esg_rating_mics_q;
create table if not exists ty_ods.esg_xq_esg_rating_mics_q
(
  globalid string,
  company_id string,
  company_name string,
  ticker string,
  security_name string,
  indicator_code string,
  indicator_name string,
  stats_date timestamp,
  ics_level1_id string,
  industry1 string,
  ics_level2_id string,
  industry2 string,
  specific_issues string,
  is_primary_idy string,
  level1_score decimal(32,12),
  weighted_level1_score decimal(32,12),
  esg_score decimal(32,12),
  weighted_esg_score decimal(32,12),
  is_current_flag string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



