drop table if exists ty_ods.w_cbondcompanyholdshares;
create table if not exists ty_ods.w_cbondcompanyholdshares
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  enddate string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_capitaloperation_companyid string comment '被参控公司ID',
  s_capitaloperation_comainbus string comment '被参控公司主营业务',
  relations_code string comment '关系代码',
  s_capitaloperation_pct decimal(20,4) comment '直接持股比例',
  voting_rights decimal(20,4) comment '表决权比例',
  s_capitaloperation_amount decimal(20,4) comment '投资金额(万元)',
  operationcrncy_code string comment '货币代码',
  s_capitaloperation_coregcap decimal(20,4) comment '被参股公司注册资本(万元)',
  capitalcrncy_code string comment '注册资本货币代码',
  is_consolidate bigint comment '是否合并报表',
  notconsolidate_reason string comment '未纳入合并报表原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



