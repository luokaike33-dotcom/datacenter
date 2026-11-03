-- 新建表：
create table if not exists w_cbondcurvememberscnbd(
`object_id` string, 
`trade_dt` string, 
`b_anal_curvenumber` bigint, 
`b_anal_curvename` string, 
`s_info_windcode` string, 
`cnbd_creditrating` string, 
`opdate` date, 
`opmode` string 
)partitioned by (`busi_month` bigint comment'月份') 
row format delimited fields terminated by '\t' 
stored as orc;
