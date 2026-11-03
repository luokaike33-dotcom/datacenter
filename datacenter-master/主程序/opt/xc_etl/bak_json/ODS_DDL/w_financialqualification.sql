drop table if exists ty_ods.w_financialqualification;
create table if not exists ty_ods.w_financialqualification
(
  object_id string comment '对象ID',
  organization_name string comment '机构公布名称',
  financial_type string comment '金融机构资格类型',
  acquisition_date string comment '获得日期',
  revoke_date string comment '撤销日期',
  is_effective bigint comment '是否有效',
  s_info_name string comment '公司简称',
  agency_typcode string comment '机构类型',
  s_info_compcode string comment '公司ID',
  financial_type_num bigint comment '金融机构资格类型代码',
  qualification_code string comment '资格编码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



