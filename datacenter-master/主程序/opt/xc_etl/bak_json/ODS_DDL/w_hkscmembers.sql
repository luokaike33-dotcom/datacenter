drop table if exists ty_ods.w_hkscmembers;
create table if not exists ty_ods.w_hkscmembers
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  entry_dt string comment '纳入日期',
  remove_dt string comment '剔除日期',
  cur_sign bigint comment '最新标志',
  s_info_compcode string comment '公司id',
  s_info_sector string comment '所属板块代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



