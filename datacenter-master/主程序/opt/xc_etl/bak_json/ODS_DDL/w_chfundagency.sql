drop table if exists ty_ods.w_chfundagency;
create table if not exists ty_ods.w_chfundagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_relation_typcode string comment '关系类型代码',
  s_agency_nameid string comment '机构名称ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



