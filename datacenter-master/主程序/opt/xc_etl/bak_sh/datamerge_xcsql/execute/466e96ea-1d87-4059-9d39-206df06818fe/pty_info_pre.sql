-- 新建表：
declare cnt number; begin select count(1) into cnt from user_tables a where a.table_name = upper('pty_info_pre');if cnt=0 then execute immediate'create table pty_info_pre(
com_id varchar2(50 char), 
com_name varchar2(200 char), 
chi_sht varchar2(200 char), 
eng_name varchar2(200 char), 
eng_sht varchar2(100 char), 
natr_biz varchar2(20 char), 
natr_econ varchar2(20 char), 
found_dt int, 
reg_cptl number(20,4), 
lgl_repr varchar2(100 char), 
reg_addr varchar2(500 char), 
ctry_code varchar2(20 char), 
ctry_name varchar2(100 char), 
reg_prov varchar2(20 char), 
reg_city varchar2(20 char), 
reg_cnty varchar2(20 char), 
ofs_addr varchar2(500 char), 
posc varchar2(20 char), 
tel varchar2(100 char), 
fax varchar2(100 char), 
email varchar2(200 char), 
web_site varchar2(200 char), 
reg_num_biz varchar2(50 char), 
is_exist varchar2(5 char), 
canl_dt timestamp, 
org_code varchar2(10 char), 
is_inno_com varchar2(5 char), 
biz_sco clob, 
is_list varchar2(10 char), 
bk_desc clob, 
gen_mngr varchar2(50 char), 
is_bach_ins varchar2(10 char), 
legp_idty_id varchar2(50 char), 
com_corp_scal varchar2(10 char), 
is_high_tegy varchar2(10 char), 
bnk_ins_clas varchar2(50 char), 
is_vie varchar2(10 char), 
is_prof varchar2(10 char), 
busi_date int, 
sys_rs_id varchar2(20 char), 
task_rs_id varchar2(100 char), 
dm_created_time timestamp 
)';
execute immediate 'comment on table pty_info_pre is ''机构基本信息'''; 
execute immediate 'comment on column PTY_INFO_PRE.COM_ID is ''机构编号'''; 
execute immediate 'comment on column PTY_INFO_PRE.COM_NAME is ''机构名称'''; 
execute immediate 'comment on column PTY_INFO_PRE.CHI_SHT is ''中文简称'''; 
execute immediate 'comment on column PTY_INFO_PRE.ENG_NAME is ''英文名称'''; 
execute immediate 'comment on column PTY_INFO_PRE.ENG_SHT is ''英文简称'''; 
execute immediate 'comment on column PTY_INFO_PRE.NATR_BIZ is ''公司企业性质'''; 
execute immediate 'comment on column PTY_INFO_PRE.NATR_ECON is ''公司经济性质'''; 
execute immediate 'comment on column PTY_INFO_PRE.FOUND_DT is ''成立日期'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_CPTL is ''注册资本'''; 
execute immediate 'comment on column PTY_INFO_PRE.LGL_REPR is ''法人代表'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_ADDR is ''注册地址描述'''; 
execute immediate 'comment on column PTY_INFO_PRE.CTRY_CODE is ''注册国家代码'''; 
execute immediate 'comment on column PTY_INFO_PRE.CTRY_NAME is ''注册国家描述'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_PROV is ''注册省市代码'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_CITY is ''注册城市代码'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_CNTY is ''注册县代码'''; 
execute immediate 'comment on column PTY_INFO_PRE.OFS_ADDR is ''办公地址描述'''; 
execute immediate 'comment on column PTY_INFO_PRE.POSC is ''邮政编码'''; 
execute immediate 'comment on column PTY_INFO_PRE.TEL is ''电话号码'''; 
execute immediate 'comment on column PTY_INFO_PRE.FAX is ''传真号码'''; 
execute immediate 'comment on column PTY_INFO_PRE.EMAIL is ''电子邮箱'''; 
execute immediate 'comment on column PTY_INFO_PRE.WEB_SITE is ''公司网址'''; 
execute immediate 'comment on column PTY_INFO_PRE.REG_NUM_BIZ is ''社会统一编码'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_EXIST is ''是否存在'''; 
execute immediate 'comment on column PTY_INFO_PRE.CANL_DT is ''注销时间'''; 
execute immediate 'comment on column PTY_INFO_PRE.ORG_CODE is ''组织机构代码'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_INNO_COM is ''是否创新企业'''; 
execute immediate 'comment on column PTY_INFO_PRE.BIZ_SCO is ''经营范围'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_LIST is ''是否上市'''; 
execute immediate 'comment on column PTY_INFO_PRE.BK_DESC is ''背景简介'''; 
execute immediate 'comment on column PTY_INFO_PRE.GEN_MNGR is ''总经理字段'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_BACH_INS is ''是否分支机构'''; 
execute immediate 'comment on column PTY_INFO_PRE.LEGP_IDTY_ID is ''法人识别码'''; 
execute immediate 'comment on column PTY_INFO_PRE.COM_CORP_SCAL is ''机构企业规模'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_HIGH_TEGY is ''是否高新企业'''; 
execute immediate 'comment on column PTY_INFO_PRE.BNK_INS_CLAS is ''银行业机构分类'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_VIE is ''是否vie(协议控制)'''; 
execute immediate 'comment on column PTY_INFO_PRE.IS_PROF is ''是否盈利'''; 
execute immediate 'comment on column PTY_INFO_PRE.BUSI_DATE is ''业务日期'''; 
execute immediate 'comment on column PTY_INFO_PRE.SYS_RS_ID is ''系统来源标识'''; 
execute immediate 'comment on column PTY_INFO_PRE.TASK_RS_ID is ''任务来源标识'''; 
execute immediate 'comment on column PTY_INFO_PRE.DM_CREATED_TIME is ''数据中台创建时间'''; 
end if; end;
/
create index idx_pty_info_pre on pty_info_pre(com_id,natr_biz,natr_econ);
