drop table if exists ty_ods.w_chgfinyearenddt;
create table if not exists ty_ods.w_chgfinyearenddt
(
  object_id string comment '对象ID',
  s_info_compcode string comment '品种ID',
  id_typecode bigint comment '品种类别代码',
  chg_typecode bigint comment '条款属性类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  finyearenddt string comment '条款',
  cur_sign bigint comment '是否最新',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



