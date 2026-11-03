-- 新建表：
create table if not exists w_ashareintroduction(
`object_id` string, 
`s_info_windcode` string, 
`s_info_province` string, 
`s_info_city` string, 
`s_info_chairman` string, 
`s_info_president` string, 
`s_info_bdsecretary` string, 
`s_info_regcapital` decimal(20,4), 
`s_info_founddate` string, 
`s_info_chineseintroduction` string, 
`s_info_comptype` string, 
`s_info_website` string, 
`s_info_email` string, 
`s_info_office` string, 
`ann_dt` string, 
`s_info_country` string, 
`s_info_businessscope` string, 
`s_info_company_type` string, 
`s_info_totalemployees` bigint, 
`s_info_main_business` string, 
`is_vie` string, 
`is_profit` string, 
`comp_name` string 
)row format delimited fields terminated by '\t' 
stored as orc;
