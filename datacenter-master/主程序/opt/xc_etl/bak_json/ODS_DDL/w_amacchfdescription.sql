drop table if exists ty_ods.w_amacchfdescription;
create table if not exists ty_ods.w_amacchfdescription
(
  object_id string comment '对象ID',
  f_info_fullname string comment '基金名称',
  f_info_number string comment '基金编号',
  f_establishment_time string comment '成立时间',
  f_record_time string comment '备案时间',
  f_fund_filing_stage string comment '基金备案阶段',
  f_fund_type string comment '基金类型',
  f_currency string comment '币种',
  f_info_fundmanagementcomp string comment '基金管理人名称',
  f_info_firstinvesttype string comment '管理类型',
  f_info_custodianbank string comment '托管人名称',
  f_info_investscope string comment '主要投资领域',
  f_info_status string comment '运作状态',
  f_info_last_reporttime string comment '基金信息最后报告时间',
  f_info_hot_tip string comment '基金协会特别提示',
  f_disclosur_websites string comment '产品信息披露网址',
  ann_date string comment '公告日期',
  f_product_id string comment '产品证券ID',
  f_info_fundmanagementid string comment '管理人公司ID',
  f_info_custodianbankid string comment '托管人公司ID',
  f_contract_period decimal(20,4) comment '合同期限',
  f_initial_scale decimal(22,6) comment '起始规模',
  is_classification string comment '是否分级',
  f_investors_number bigint comment '成立时投资者数量',
  f_product_type string comment '非专户资产管理计划产品类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国私募基金基本资料(基金业协会)'
row format delimited fields terminated by '\t'
stored as orc;



