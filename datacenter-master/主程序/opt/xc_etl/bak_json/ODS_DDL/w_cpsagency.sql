drop table if exists ty_ods.w_cpsagency;
create table if not exists ty_ods.w_cpsagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_agency_nameid string comment '中介机构公司ID',
  s_relation_typcode string comment '关系类型代码',
  begindate string comment '起始日期',
  enddate string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



