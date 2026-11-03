drop table if exists ty_ods.w_scfclause;
create table if not exists ty_ods.w_scfclause
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '条款属性类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '是否最新',
  content string comment '条款',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



