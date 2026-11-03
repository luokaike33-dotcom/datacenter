drop table if exists ty_ods.w_chfmanagerinformation;
create table if not exists ty_ods.w_chfmanagerinformation
(
  object_id string comment '对象ID',
  f_info_corp_fundmanagementcomp string comment '基金管理人全称(中文)',
  f_info_fundmanagementcomp_e string comment '基金管理人全称(英文)',
  f_info_sequence string comment '登记编号',
  f_info_org_code string comment '组织机构代码',
  f_info_registration_time string comment '登记时间',
  f_info_establish_time string comment '成立时间',
  f_info_address string comment '注册地址',
  f_info_office string comment '办公地址',
  f_info_regcapital decimal(20,4) comment '注册资本',
  f_info_paidcapital decimal(20,4) comment '实缴资本',
  f_info_comp_property string comment '企业性质',
  f_info_ratio decimal(20,4) comment '注册资本实缴比例',
  f_info_managed_fund_type string comment '管理基金主要类别',
  f_info_apply_other_business string comment '申请的其他业务类型',
  f_info_totalemployees bigint comment '员工人数',
  f_info_website string comment '机构网址',
  f_info_disclosurewebsite string comment '协会披露网址',
  f_info_management_scale decimal(20,4) comment '公司管理规模',
  f_info_sincerity string comment '机构诚信信息',
  f_info_reporting_time string comment '机构信息最后报告时间',
  f_special_hint_information string comment '特别提示信息',
  ann_date string comment '公告日期',
  f_info_legal_opinion string comment '法律意见书状态',
  f_info_law_firm string comment '律师事务所名称',
  f_info_sol_sig string comment '律师姓名',
  f_info_companyid string comment '管理人公司ID',
  f_management_scale_interval string comment '管理规模区间',
  is_new bigint comment '是否最新',
  is_member bigint comment '是否为会员',
  f_info_member_type string comment '当前会员类型',
  f_info_time_admission string comment '入会时间',
  f_info_crncy_code string comment '币种',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国私募基金管理人资料'
row format delimited fields terminated by '\t'
stored as orc;



