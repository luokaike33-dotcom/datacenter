-- 新建表：
declare cnt number; begin select count(1) into cnt from user_tables a where a.table_name = upper('pty_ins_oneid_rela_info');if cnt=0 then execute immediate'create table pty_ins_oneid_rela_info(
ins_id varchar2(100 char), 
com_code varchar2(100 char), 
src_com_id varchar2(50 char), 
reg_num_biz varchar2(100 char), 
busi_date int, 
task_rs_id varchar2(100 char), 
dm_created_time timestamp, 
sys_rs_id varchar2(20 char) 
)';
execute immediate 'comment on table pty_ins_oneid_rela_info is ''机构oneid表'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.INS_ID is ''机构内码'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.COM_CODE is ''公司编号'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.SRC_COM_ID is ''来源机构编号'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.REG_NUM_BIZ is ''统一社会信用代码'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.BUSI_DATE is ''业务日期'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.TASK_RS_ID is ''任务来源标识'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.DM_CREATED_TIME is ''数据中台创建时间'''; 
execute immediate 'comment on column PTY_INS_ONEID_RELA_INFO.SYS_RS_ID is ''系统来源标识'''; 
end if; end;
/
