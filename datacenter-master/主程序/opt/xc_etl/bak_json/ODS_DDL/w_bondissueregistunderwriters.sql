drop table if exists ty_ods.w_bondissueregistunderwriters;
create table if not exists ty_ods.w_bondissueregistunderwriters
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  underwriter string comment '承销商名称',
  underwriterid string comment '承销商公司ID',
  b_relation_typcode string comment '关系类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  bondtype_code bigint comment '债券类型代码',
  bondtype string comment '债券类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



