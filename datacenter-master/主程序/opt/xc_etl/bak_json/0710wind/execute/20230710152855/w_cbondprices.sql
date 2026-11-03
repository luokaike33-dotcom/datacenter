-- 新建表：
create table if not exists w_cbondprices(
`object_id` string, 
`s_info_windcode` string, 
`trade_dt` string, 
`b_dq_open` decimal(20,8), 
`b_dq_high` decimal(20,8), 
`b_dq_low` decimal(20,8), 
`b_dq_originclose` decimal(20,8), 
`b_dq_volume` decimal(20,8), 
`b_dq_amount` decimal(20,8), 
`opdate` date, 
`opmode` string 
)partitioned by (`busi_month` bigint comment'月份') 
row format delimited fields terminated by '\t' 
stored as orc;
