drop table if exists ty_ods.w_cbondapprovalinformation;
create table if not exists ty_ods.w_cbondapprovalinformation
(
  object_id string comment '对象ID',
  ann_date string comment '更新日期',
  b_info_fullname string comment '债券名称',
  bondtype bigint comment '债券类型',
  amount decimal(24,8) comment '计划发行金额(亿元)',
  s_info_compname string comment '原始权益人名称',
  s_info_compcode string comment '发行人公司ID',
  leadunderwriter string comment '主承销商/管理人',
  s_info_exchmarket string comment '交易所代码',
  filenum string comment '交易所确认文件文号',
  progress_code bigint comment '项目状态',
  project_typecode bigint comment '项目类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



