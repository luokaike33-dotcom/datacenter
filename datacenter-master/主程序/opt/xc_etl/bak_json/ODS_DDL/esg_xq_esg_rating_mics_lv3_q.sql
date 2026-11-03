drop table if exists ty_ods.esg_xq_esg_rating_mics_lv3_q;
create table if not exists ty_ods.esg_xq_esg_rating_mics_lv3_q
(
  globalid string,
  company_id string,
  company_name string,
  ticker string,
  security_name string,
  indicator_code string,
  indicator_name string,
  level1_code string,
  level1_name string,
  level2_code string,
  level2_name string,
  stats_date timestamp,
  ics_level1_id string,
  industry1 string,
  ics_level2_id string,
  industry2 string,
  specific_issues string,
  is_primary_idy string,
  idy_weight decimal(32,12),
  base_value decimal(32,12),
  industry2_rank_pct decimal(32,12),
  level3_score decimal(32,12),
  is_current_flag string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



