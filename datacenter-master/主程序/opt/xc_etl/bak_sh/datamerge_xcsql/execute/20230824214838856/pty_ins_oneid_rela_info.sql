-- 新建表：
create table if not exists pty_ins_oneid_rela_info(
`ins_id` string comment'机构内码', 
`com_code` string comment'公司编号', 
`src_com_id` string comment'来源机构编号', 
`reg_num_biz` string comment'统一社会信用代码', 
`busi_date` bigint comment'业务日期', 
`task_rs_id` string comment'任务来源标识', 
`dm_created_time` timestamp comment'数据中台创建时间' 
)comment '机构oneid表' 
partitioned by (`sys_rs_id` string comment'系统来源标识') 
row format delimited fields terminated by '\t' 
stored as orc;
