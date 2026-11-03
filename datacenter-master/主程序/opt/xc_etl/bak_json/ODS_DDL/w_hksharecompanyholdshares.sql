drop table if exists ty_ods.w_hksharecompanyholdshares;
create table if not exists ty_ods.w_hksharecompanyholdshares
(
  object_id string comment '对象ID',
  relations_code string comment '关联关系代码',
  s_capitaloperation_comainbus string comment '被参控公司主营业务',
  s_info_compcode string comment '公司ID',
  s_capitaloperation_companyid string comment '被参控公司ID',
  s_capitaloperation_amount decimal(24,8) comment '投资金额(万元)',
  operationcrncy_code string comment '货币代码',
  voting_rights decimal(20,4) comment '表决权比例',
  is_consolidate bigint comment '是否纳入报表合并范围',
  enddate string comment '截止日期',
  s_capitaloperation_coregcap decimal(24,8) comment '被参股公司注册资本(万元)',
  operationcrncy_code2 string comment '货币代码2',
  s_capitaloperation_companyname string comment '被参控公司名称',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



