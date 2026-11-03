drop table if exists ty_ods.w_cbondindustrynafmii;
create table if not exists ty_ods.w_cbondindustrynafmii
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_industrycode string comment '一级板块代码',
  s_info_industryname string comment '一级板块名称',
  s_info_industrycode2 string comment '二级板块代码',
  s_info_industryname2 string comment '二级板块名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



