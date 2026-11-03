drop table if exists ty_ods.w_cfundfactionalstyle;
create table if not exists ty_ods.w_cfundfactionalstyle
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  sec_ind_code string comment '所属板块代码',
  entry_dt string comment '纳入日期',
  remove_dt string comment '剔除日期',
  memo string comment '[内部]备注',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



