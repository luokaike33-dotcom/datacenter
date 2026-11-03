-- 新建表：
create table if not exists w_bankingficlasscbrc(
`object_id` string, 
`s_info_compcode` string, 
`s_info_compname` string, 
`s_info_typecode` string, 
`entry_dt` string, 
`remove_dt` string, 
`cur_sign` string 
)row format delimited fields terminated by '\t' 
stored as orc;
