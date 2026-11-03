table:pty_info_ms  


新表注释 | 旧表注释  
---------------- | -------------------  
| 机构基本信息ms  


新表字段 | 旧表字段  
---------------- | -------------------  
|com_id string 机构编号  
|com_name string 机构名称  
|chi_sht string 中文简称  
|eng_name string 英文名称  
|eng_sht string 英文简称  
|natr_biz string 公司企业性质  
|natr_econ string 公司经济性质  
|found_dt bigint 成立日期  
|reg_cptl decimal(20,4) 注册资本  
|lgl_repr string 法人代表  
|reg_addr string 注册地址描述  
|ctry_code string 注册国家代码  
|ctry_name string 注册国家描述  
|reg_prov string 注册省市代码  
|reg_city string 注册城市代码  
|reg_cnty string 注册县代码  
|ofs_addr string 办公地址描述  
|posc string 邮政编码  
|tel string 电话号码  
|fax string 传真号码  
|email string 电子邮箱  
|web_site string 公司网址  
|reg_num_biz string 社会统一编码  
|is_exist string 是否存在  
|canl_dt timestamp 注销时间  
|org_code string 组织机构代码  
|is_inno_com string 是否创新企业  
|biz_sco string 经营范围  
|is_list string 是否上市  
|bk_desc string 背景简介  
|gen_mngr string 总经理字段  
|is_bach_ins string 是否分支机构  
|legp_idty_id string 法人识别码  
|com_corp_scal string 机构企业规模  
|is_high_tegy string 是否高新企业  
|bnk_ins_clas string 银行业机构分类  
|is_vie string 是否vie(协议控制)  
|is_prof string 是否盈利  
|busi_date bigint 业务日期  
|sys_rs_id string 系统来源标识  
|task_rs_id string 任务来源标识  
|dm_created_time timestamp 数据中台创建时间  



新表分区 | 旧表分区  
---------------- | -------------------  
|sys_rs_id


新表索引 | 旧表索引  
---------------- | -------------------  
