drop table if exists ty_ods.w_hkshareagency;
create table if not exists ty_ods.w_hkshareagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券id',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  agencyname string comment '机构名称',
  agencycode string comment '机构公司ID',
  type_code string comment '关系类型代码',
  scp string comment '业务范围',
  start_dt string comment '起使日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  op_date string comment '操作日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



