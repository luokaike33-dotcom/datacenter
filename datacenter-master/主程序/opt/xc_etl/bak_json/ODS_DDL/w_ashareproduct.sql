drop table if exists ty_ods.w_ashareproduct;
create table if not exists ty_ods.w_ashareproduct
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '公司名称',
  s_info_comp_sname string comment '公司中文简称',
  s_enddate string comment '截止日期',
  s_product_name string comment '产品名称',
  s_product_number decimal(20,4) comment '数量',
  number_typecode bigint comment '数量类型代码',
  frequency_code bigint comment '频率代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



