drop table if exists ty_ods.w_ashareincexecqtypri;
create table if not exists ty_ods.w_ashareincexecqtypri
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_name string comment '姓名',
  s_inc_execqty decimal(20,4) comment '行权数量(万份)',
  s_inc_execpri decimal(20,4) comment '行权价格',
  s_inc_execdate string comment '行权日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



