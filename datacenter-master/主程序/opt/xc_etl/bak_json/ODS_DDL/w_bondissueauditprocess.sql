drop table if exists ty_ods.w_bondissueauditprocess;
create table if not exists ty_ods.w_bondissueauditprocess
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称(申请企业)',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  type_code bigint comment '审核类型代码',
  type_name string comment '申请事项',
  s_info_process string comment '说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



