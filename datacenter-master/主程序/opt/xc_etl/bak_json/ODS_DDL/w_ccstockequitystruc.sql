drop table if exists ty_ods.w_ccstockequitystruc;
create table if not exists ty_ods.w_ccstockequitystruc
(
  object_id string,
  s_info_compcode string,
  ann_date string,
  change_date string,
  issued_shares decimal(20,4),
  mainland_outstd_shr decimal(20,4),
  hk_outstd_shr decimal(20,4),
  overseas_outstd_shr decimal(20,4),
  non_tradable_shr decimal(20,4),
  preferredshare decimal(20,4),
  outstandingshares decimal(20,4),
  changereason_code bigint,
  changereason string,
  overseas_shr_cntrycode string,
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



