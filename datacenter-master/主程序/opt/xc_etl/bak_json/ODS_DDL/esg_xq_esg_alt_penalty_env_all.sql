drop table if exists ty_ods.esg_xq_esg_alt_penalty_env_all;
create table if not exists ty_ods.esg_xq_esg_alt_penalty_env_all
(
  company_id string,
  companyname string,
  ticker string,
  `exchange` string,
  relatedcompanyname string,
  relationship string,
  punishpaper string,
  fineamount decimal(32,12),
  pollutiontype string,
  punishtype string,
  province string,
  city string,
  punishtime timestamp,
  punishreason string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



