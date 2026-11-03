-- 新建表：
create table if not exists w_cbondanalysiscsi(
`object_id` string, 
`s_info_windcode` string, 
`trade_dt` string, 
`b_info_type` string, 
`b_info_listingmarketnumbers` decimal(20,4), 
`b_anal_dirty_csi` decimal(20,4), 
`b_anal_yield_csi` decimal(20,4), 
`b_anal_modidura_csi` decimal(20,4), 
`b_anal_cnvxty_csi` decimal(20,4), 
`b_anal_net_csi` decimal(20,4), 
`b_anal_accrint_csi` decimal(20,4), 
`b_anal_full_ifexe` decimal(20,4), 
`b_anal_net_ifexe` decimal(20,4), 
`b_anal_ytm_ifexe` decimal(20,4), 
`b_anal_modidura_ifexe` decimal(20,4), 
`b_anal_cnvxty_ifexe` decimal(20,4), 
`recommended` bigint, 
`b_anal_est_couponrate` decimal(20,4) 
)partitioned by (`busi_month` bigint comment'月份') 
row format delimited fields terminated by '\t' 
stored as orc;
