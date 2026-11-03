create table data_mart.o3_thisissuer ( 
  l_issuer_id number(10),
  vc_issuer_name varchar2(100),
  l_mother_issuer_id number(10),
  vc_linkman varchar2(100),
  vc_address varchar2(100),
  vc_phone varchar2(100),
  vc_fax varchar2(100),
  c_outer_appraise varchar2(100),
  vc_appraise_organ varchar2(100),
  c_inside_appraise varchar2(100),
  c_appraise varchar2(100),
  vc_summary varchar2(100),
  vc_full_name varchar2(100),
  vc_issuer_type varchar2(100),
  vc_transactor_name varchar2(100),
  vc_transactor_id_type varchar2(100),
  vc_transactor_id varchar2(100),
  vc_transactor_phone varchar2(100),
  vc_transactor_fax varchar2(100),
  vc_transactor_stamp varchar2(100),
  vc_pre_stamp varchar2(100),
  vc_issuer_code varchar2(100),
  en_issuer_asset number(10),
  vc_asset_currency_no varchar2(100),
  vc_country_no varchar2(100),
  l_transactor_validity number(10),
  en_credit_limit number(10),
  c_guarantor_appraise varchar2(100),
  vc_external_code varchar2(100),
  vc_zx_ip varchar2(100),
  vc_zx_port varchar2(100),
  vc_zx_user varchar2(100),
  vc_zx_pass varchar2(100),
  l_outer_appraise_date number(10),
  l_total_asset_amount number(10),
  en_guarantor_limit number(10),
  vc_pre_stamp2 varchar2(100),
  vc_timestamp varchar2(100),
  c_level_expectation varchar2(100),
  en_last_year_net number(10),
  c_issuer_other_appraise_one varchar2(100),
  c_issuer_other_appraise_two varchar2(100),
  c_outer_appraise1 varchar2(100),
  l_lastquarter_asset number(10),
  vc_provincecode varchar2(100),
  en_asset_liability_ratio number(10),
  en_interest_earned_ratio number(10),
  l_date number(10),
  en_surplus_amount number(10),
  c_org_type varchar2(100),
  vc_sec_credit_code varchar2(100),
  vc_financialorg_code varchar2(100),
  vc_agency_code varchar2(100),
  vc_inter_appraise_name varchar2(100),
  l_inter_appraise_date number(10),
  vc_ca_stamp varchar2(100),
  en_lastyear_asset number(10),
  c_finance_org varchar2(100),
  l_higher_issuer_id number(10),
  bath_dt varchar2(100),
  data_ins_time timestamp,
  task_rs_id varchar2(100)
);
comment on column data_mart.o3_thisissuer.l_issuer_id is '发行人序号';
comment on column data_mart.o3_thisissuer.vc_issuer_name is '发行人名称';
comment on column data_mart.o3_thisissuer.l_mother_issuer_id is '母发行人序号';
comment on column data_mart.o3_thisissuer.vc_linkman is '联系人';
comment on column data_mart.o3_thisissuer.vc_address is '地址';
comment on column data_mart.o3_thisissuer.vc_phone is '联系电话';
comment on column data_mart.o3_thisissuer.vc_fax is '传真';
comment on column data_mart.o3_thisissuer.c_outer_appraise is '外部评级';
comment on column data_mart.o3_thisissuer.vc_appraise_organ is '外部评级机构';
comment on column data_mart.o3_thisissuer.c_inside_appraise is '内部评级';
comment on column data_mart.o3_thisissuer.c_appraise is '综合评级';
comment on column data_mart.o3_thisissuer.vc_summary is '备注';
comment on column data_mart.o3_thisissuer.vc_full_name is '发行人全称';
comment on column data_mart.o3_thisissuer.vc_issuer_type is '分类';
comment on column data_mart.o3_thisissuer.vc_transactor_name is '经办人姓名';
comment on column data_mart.o3_thisissuer.vc_transactor_id_type is '经办人证件类型';
comment on column data_mart.o3_thisissuer.vc_transactor_id is '经办人证件号码';
comment on column data_mart.o3_thisissuer.vc_transactor_phone is '经办人联系电话';
comment on column data_mart.o3_thisissuer.vc_transactor_fax is '经办人传真';
comment on column data_mart.o3_thisissuer.vc_transactor_stamp is '经办人签章文件名';
comment on column data_mart.o3_thisissuer.vc_pre_stamp is '预留签章文件名';
comment on column data_mart.o3_thisissuer.vc_issuer_code is '发行人编号';
comment on column data_mart.o3_thisissuer.en_issuer_asset is '净资产';
comment on column data_mart.o3_thisissuer.vc_asset_currency_no is '净资产币种';
comment on column data_mart.o3_thisissuer.vc_country_no is '国家';
comment on column data_mart.o3_thisissuer.l_transactor_validity is '经办人有效期';
comment on column data_mart.o3_thisissuer.en_credit_limit is '授信额度';
comment on column data_mart.o3_thisissuer.c_guarantor_appraise is '担保人评级';
comment on column data_mart.o3_thisissuer.vc_external_code is '自建ta代码';
comment on column data_mart.o3_thisissuer.vc_zx_ip is '直销服务器地址';
comment on column data_mart.o3_thisissuer.vc_zx_port is '直销服务器端口';
comment on column data_mart.o3_thisissuer.vc_zx_user is '直销用户名';
comment on column data_mart.o3_thisissuer.vc_zx_pass is '直销密码';
comment on column data_mart.o3_thisissuer.l_outer_appraise_date is '外部评级时间';
comment on column data_mart.o3_thisissuer.l_total_asset_amount is '发行人总资产';
comment on column data_mart.o3_thisissuer.en_guarantor_limit is '担保额度';
comment on column data_mart.o3_thisissuer.vc_pre_stamp2 is '预留签章2';
comment on column data_mart.o3_thisissuer.vc_timestamp is '时间戳';
comment on column data_mart.o3_thisissuer.c_level_expectation is '评级展望';
comment on column data_mart.o3_thisissuer.en_last_year_net is '上一年度净利润';
comment on column data_mart.o3_thisissuer.c_issuer_other_appraise_one is '其他评级一';
comment on column data_mart.o3_thisissuer.c_issuer_other_appraise_two is '其他评级二';
comment on column data_mart.o3_thisissuer.c_outer_appraise1 is '外部评级孰低';
comment on column data_mart.o3_thisissuer.l_lastquarter_asset is '最近季度末净资产';
comment on column data_mart.o3_thisissuer.vc_provincecode is '省份';
comment on column data_mart.o3_thisissuer.en_asset_liability_ratio is '资产负债率';
comment on column data_mart.o3_thisissuer.en_interest_earned_ratio is '利息保障倍数';
comment on column data_mart.o3_thisissuer.l_date is '日期';
comment on column data_mart.o3_thisissuer.en_surplus_amount is '剩余额度';
comment on column data_mart.o3_thisissuer.c_org_type is '机构类型';
comment on column data_mart.o3_thisissuer.vc_sec_credit_code is '社会统一信用代码';
comment on column data_mart.o3_thisissuer.vc_financialorg_code is '金融机构编码';
comment on column data_mart.o3_thisissuer.vc_agency_code is '销售商代码';
comment on column data_mart.o3_thisissuer.vc_inter_appraise_name is '内部评级人';
comment on column data_mart.o3_thisissuer.l_inter_appraise_date is '内部评级日期';
comment on column data_mart.o3_thisissuer.vc_ca_stamp is 'ca签章信息';
comment on column data_mart.o3_thisissuer.bath_dt is '日期';
comment on column data_mart.o3_thisissuer.data_ins_time is '数据来源时间';
comment on column data_mart.o3_thisissuer.task_rs_id is '任务来源标识';



