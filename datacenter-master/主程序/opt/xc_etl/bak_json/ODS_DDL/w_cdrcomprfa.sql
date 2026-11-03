drop table if exists ty_ods.w_cdrcomprfa;
create table if not exists ty_ods.w_cdrcomprfa
(
  object_id string comment '对象ID',
  s_info_companyid string comment '公司ID',
  regaddr string comment '注册地',
  sectors string comment '所属行业',
  sponsor string comment '保荐机构',
  spon_rep string comment '保荐代表人',
  acc_firm string comment '会计师事务所',
  cpa string comment '签字会计师',
  law_firm string comment '律师事务所',
  sol_sig string comment '签字律师',
  app_code bigint comment '申请事项代码',
  sch_code bigint comment '进度类型代码',
  tblisted bigint comment '拟上市板块代码',
  st_date string comment '状态起始日期',
  end_date string comment '状态终止日期',
  est_issueno decimal(20,4) comment '预计发行股数（万股）',
  est_issueshares decimal(20,4) comment '预计发行后总股本（万股）',
  pro_tolalinv decimal(20,4) comment '募投项目投资总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



