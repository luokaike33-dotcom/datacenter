drop table if exists ty_ods.w_asharepevcinvestment;
create table if not exists ty_ods.w_asharepevcinvestment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '股东公司名称',
  s_info_comp_sname string comment '股东公司中文简称',
  s_info_compcode1 string comment '股东公司ID',
  s_holder_date string comment '融资时间',
  s_holder_pct decimal(12,4) comment '股权比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



