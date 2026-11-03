table:pty_info_pre  


新表注释 | 旧表注释  
---------------- | -------------------  
| 机构基本信息  


新表字段 | 旧表字段  
---------------- | -------------------  
|com_id varchar2(50) 机构编号  
|com_name varchar2(200) 机构名称  
|chi_sht varchar2(200) 中文简称  
|eng_name varchar2(200) 英文名称  
|eng_sht varchar2(100) 英文简称  
|natr_biz varchar2(20) 公司企业性质  
|natr_econ varchar2(20) 公司经济性质  
|found_dt int 成立日期  
|reg_cptl number(20,4) 注册资本  
|lgl_repr varchar2(100) 法人代表  
|reg_addr varchar2(500) 注册地址描述  
|ctry_code varchar2(20) 注册国家代码  
|ctry_name varchar2(100) 注册国家描述  
|reg_prov varchar2(20) 注册省市代码  
|reg_city varchar2(20) 注册城市代码  
|reg_cnty varchar2(20) 注册县代码  
|ofs_addr varchar2(500) 办公地址描述  
|posc varchar2(20) 邮政编码  
|tel varchar2(100) 电话号码  
|fax varchar2(100) 传真号码  
|email varchar2(200) 电子邮箱  
|web_site varchar2(200) 公司网址  
|reg_num_biz varchar2(50) 社会统一编码  
|is_exist varchar2(5) 是否存在  
|canl_dt timestamp 注销时间  
|org_code varchar2(10) 组织机构代码  
|is_inno_com varchar2(5) 是否创新企业  
|biz_sco clob 经营范围  
|is_list varchar2(10) 是否上市  
|bk_desc clob 背景简介  
|gen_mngr varchar2(50) 总经理字段  
|is_bach_ins varchar2(10) 是否分支机构  
|legp_idty_id varchar2(50) 法人识别码  
|com_corp_scal varchar2(10) 机构企业规模  
|is_high_tegy varchar2(10) 是否高新企业  
|bnk_ins_clas varchar2(50) 银行业机构分类  
|is_vie varchar2(10) 是否vie(协议控制)  
|is_prof varchar2(10) 是否盈利  
|busi_date int 业务日期  
|sys_rs_id varchar2(20) 系统来源标识  
|task_rs_id varchar2(100) 任务来源标识  
|dm_created_time timestamp 数据中台创建时间  



新表分区 | 旧表分区  
---------------- | -------------------  
|


新表索引 | 旧表索引  
---------------- | -------------------  
|idx_pty_info_pre(com_id,natr_biz,natr_econ)  
