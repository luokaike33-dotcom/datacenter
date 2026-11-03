drop table if exists ty_ods.w_mergeragency;
create table if not exists ty_ods.w_mergeragency
(
  object_id string comment '对象ID',
  event_id string comment '并购事件ID',
  agency_name string comment '中介机构公司名称',
  s_info_compcode string comment '中介机构公司ID',
  agency_typcode bigint comment '中介机构类型代码',
  object_typcode bigint comment '中介机构服务对象类型代码',
  object_compname string comment '中介机构服务对象（公司）名称',
  s_info_compcode2 string comment '中介机构服务对象（公司）ID',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



