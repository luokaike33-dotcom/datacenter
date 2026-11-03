-- 新建表：
declare cnt number; begin select count(1) into cnt from user_tables a where a.table_name = upper('pty_ins_oneid_rela_info_log');if cnt=0 then execute immediate'create table pty_ins_oneid_rela_info_log(
ins_id varchar2(100 char), 
com_code varchar2(100 char), 
src_com_id varchar2(50 char), 
reg_num_biz varchar2(100 char), 
busi_date int, 
task_rs_id varchar2(100 char), 
dm_created_time timestamp, 
sys_rs_id varchar2(20 char), 
log_update_by varchar2(256 char), 
log_update_at timestamp, 
log_state varchar2(1 char) 
)';
execute immediate 'comment on table pty_ins_oneid_rela_info_log is ''机构oneidlog表'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.INS_ID is ''机构内码'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.COM_CODE is ''公司编号'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.SRC_COM_ID is ''来源机构编号'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.REG_NUM_BIZ is ''统一社会信用代码'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.BUSI_DATE is ''业务日期'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.TASK_RS_ID is ''任务来源标识'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.DM_CREATED_TIME is ''数据中台创建时间'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO_LOG.SYS_RS_ID is ''系统来源标识'''; 
end if; end;
/
