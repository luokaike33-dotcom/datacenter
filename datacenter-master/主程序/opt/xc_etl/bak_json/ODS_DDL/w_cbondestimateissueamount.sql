drop table if exists ty_ods.w_cbondestimateissueamount;
create table if not exists ty_ods.w_cbondestimateissueamount
(
  object_id string comment '对象ID',
  issue_firstissue string comment '发行日期',
  bond_type string comment '债券类型',
  issue_amountplan decimal(20,4) comment '发行数量(亿元)',
  term_year decimal(20,4) comment '债券期限(年)',
  interesttype string comment '利率类型',
  interestfrequency string comment '付息频率',
  isser_introduce string comment '发行简介',
  specialbondtype bigint comment '债券品种代码',
  interesttype_code bigint comment '附息利率品种代码',
  reimbursement bigint comment '偿还方式代码',
  s_info_windcode string comment 'Wind代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



