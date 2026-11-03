drop table if exists ty_ods.w_asharetaxrate;
create table if not exists ty_ods.w_asharetaxrate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  tax_rate decimal(20,4) comment '税率(%)',
  begin_mon bigint comment '起始月份',
  end_mon bigint comment '终止月份',
  discount_reason string comment '税项优惠原因',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



