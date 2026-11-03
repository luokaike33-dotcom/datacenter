drop table if exists ty_ods.w_crmwdescription;
create table if not exists ty_ods.w_crmwdescription
(
  object_id string comment '对象ID',
  b_info_windcode string comment 'Wind代码',
  b_create_fullname string comment '凭证全称',
  b_create_name string comment '创设机构名称',
  b_create_nameid string comment '创设机构ID',
  filenum string comment '创设批准文件编号',
  b_create_ann_date string comment '创设公告日',
  b_create_object bigint comment '发行对象代码',
  b_create_price decimal(20,4) comment '凭证创设价格',
  b_create_amountplan decimal(20,6) comment '计划创设总额',
  b_create_amountact decimal(20,6) comment '实际创设总额',
  b_create_firstissue string comment '簿记建档日',
  b_registration_date string comment '凭证登记日',
  b_create_start_day string comment '凭证起始日',
  b_create_end_day string comment '凭证到期日',
  b_create_term_day decimal(20,4) comment '凭证期限',
  b_create_payment_code bigint comment '付费方式代码',
  b_cgross_principal_amount decimal(20,6) comment '名义本金总额',
  is_guarantee bigint comment '是否担保',
  b_cgross_settlement_code bigint comment '结算方式代码',
  b_voucher_code bigint comment '凭证类别代码',
  b_security_code bigint comment '履约保障机制代码',
  b_unit_nominal_capital decimal(20,4) comment '单位名义本金',
  b_create_cancellation_day string comment '凭证注销日',
  b_info_compcode string comment '参考实体公司id',
  b_create_debt_type string comment '债务种类',
  b_create_debt_features string comment '债务特征',
  b_info_code string comment '可交付债务证券id',
  b_info_listdate string comment '上市日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



