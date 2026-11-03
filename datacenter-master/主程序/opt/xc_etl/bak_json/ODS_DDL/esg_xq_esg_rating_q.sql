drop table if exists ty_ods.esg_xq_esg_rating_q;
create table if not exists ty_ods.esg_xq_esg_rating_q
(
  globalid string,
  company_id string,
  company_name string,
  ticker string,
  security_name string,
  indicator_code string,
  indicator_name string,
  stats_date timestamp,
  level1_score decimal(32,12),
  esg_score decimal(32,12),
  esg_rating string,
  is_current_flag string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



