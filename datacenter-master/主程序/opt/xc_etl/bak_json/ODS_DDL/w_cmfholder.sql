drop table if exists ty_ods.w_cmfholder;
create table if not exists ty_ods.w_cmfholder
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  ann_dt string comment '公告日期',
  s_fa_latelyrd string comment '报告期',
  s_info_enddate string comment '截止日期',
  b_info_holder string comment '持有人',
  b_info_holdamount decimal(20,4) comment '数量(股\张\份)',
  b_issuer_sharecategory string comment '[内部]股东类型： 1 个人；2 公司',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



