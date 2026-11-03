drop table if exists ty_ods.w_cbondholder;
create table if not exists ty_ods.w_cbondholder
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_info_enddate string comment '截止日期',
  s_fa_latelyrd string comment '报告期',
  b_info_holder string comment '持有人',
  b_info_holdamount decimal(20,4) comment '持有数量(张)',
  b_issuer_sharecategory string comment '持有人类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



