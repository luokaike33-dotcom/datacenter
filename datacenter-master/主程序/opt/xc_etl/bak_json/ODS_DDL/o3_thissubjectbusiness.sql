drop table if exists ty_ods.o3_thissubjectbusiness;
create table if not exists ty_ods.o3_thissubjectbusiness
(
  l_busin_no bigint,
  l_batch_no bigint,
  l_date bigint,
  l_time bigint,
  vc_busin_opflag string,
  l_fund_id bigint,
  l_asset_id bigint,
  l_subject_no bigint,
  en_occur_balance decimal(16,2),
  c_adjust_asset string,
  l_operator_no bigint,
  vc_memo string,
  l_check_date bigint,
  l_check_time bigint,
  l_check_operator bigint,
  c_check_flag string,
  vc_check_memo string,
  c_deal_flag string,
  d_datetime timestamp,
  l_operate_enable_date bigint,
  c_del_status string,
  l_del_operator bigint,
  l_del_date bigint,
  l_del_time bigint,
  vc_currency_no string,
  l_business_date bigint,
  c_adjust_type string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



