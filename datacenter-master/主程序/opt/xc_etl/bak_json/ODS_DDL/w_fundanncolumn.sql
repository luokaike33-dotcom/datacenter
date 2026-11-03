drop table if exists ty_ods.w_fundanncolumn;
create table if not exists ty_ods.w_fundanncolumn
(
  object_id string comment '对象ID',
  n_info_code string comment 'Wind栏目代码',
  n_info_pcode string comment '父节点栏目代码',
  n_info_fcode string comment '本节栏目代码',
  n_info_name string comment '栏目名称',
  n_info_isvalid bigint comment '是否有效',
  n_info_levelnum bigint comment '栏目级别',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



