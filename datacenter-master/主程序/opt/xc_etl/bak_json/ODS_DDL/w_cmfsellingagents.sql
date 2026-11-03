drop table if exists ty_ods.w_cmfsellingagents;
create table if not exists ty_ods.w_cmfsellingagents
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'WIND代码',
  f_ann_date string comment '公告日期',
  f_agency_nameid string comment '中介机构公司ID',
  f_agency_name string comment '机构名称',
  f_relation string comment '关系类型',
  f_begin_date string comment '起始日期',
  f_end_date string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



