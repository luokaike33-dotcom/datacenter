drop table if exists ty_ods.w_cdragency;
create table if not exists ty_ods.w_cdragency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_relation_typcode string comment '关系类型代码',
  s_business_typcode bigint comment '业务类型代码',
  s_agency_nameid string comment '机构名称ID',
  begindate string comment '起始日期',
  enddate string comment '截止日期',
  sequence1 string comment '序号',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



