drop table if exists ty_ods.w_aindexalternativemembers;
create table if not exists ty_ods.w_aindexalternativemembers
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_con_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  sequence bigint comment '序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



