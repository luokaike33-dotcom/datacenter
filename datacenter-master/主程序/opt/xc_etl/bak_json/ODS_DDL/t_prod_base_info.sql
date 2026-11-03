drop table if exists ty_ods.t_prod_base_info;
create table if not exists ty_ods.t_prod_base_info
(
  bk_product_of_m string,
  prod_inr_id string,
  prod_belg bigint,
  prod_short_name string,
  prod_cname string,
  prod_short_ename string,
  prod_ename string,
  prod_cald bigint,
  prod_introd string,
  prod_risk_level_code bigint,
  bchmk string,
  crrc bigint,
  per_parv decimal(38,2),
  iss_lmt decimal(38,2),
  issue_start_date string,
  issue_end_date string,
  setup_date string,
  share_lock_period bigint,
  share_lock_period_unit bigint,
  listing_date string,
  expe_matu_date string,
  fst_liquidation_date string,
  lst_liquidation_date string,
  lst_liqu_data_prvd_date string,
  lst_liqu_clr_mony_tdw_date string,
  nav_precision bigint,
  aeets_method bigint,
  valu_confirm_days bigint,
  trd_confirm_days bigint,
  l_timelimit bigint,
  vc_procontact string,
  prod_mngr_name string,
  accomanager string,
  ivsm_advr string,
  fund_acc string,
  check_acc string,
  prod_life_pd_status bigint,
  c_clearer_new string,
  pbc_prod_id string,
  asso_rcd_code string,
  asso_rcd_name string,
  effective_date string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



