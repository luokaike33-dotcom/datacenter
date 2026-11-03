drop table if exists ty_ods.w_chfundfee;
create table if not exists ty_ods.w_chfundfee
(
  object_id string comment '对象ID',
  f_info_compcode string comment '基金ID',
  f_info_fullname string comment '基金名称',
  s_info_windcode string comment '子基金Wind代码',
  sec_id string comment '子基金ID',
  feetypecode string comment '费率类型',
  change_dt string comment '变动日期',
  feeratio decimal(20,4) comment '费率(%)',
  supplementary string comment '费率补充说明',
  used bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



