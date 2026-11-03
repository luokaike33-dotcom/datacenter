drop table if exists ty_ods.w_hkshareequityrelationships;
create table if not exists ty_ods.w_hkshareequityrelationships
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  enddate string comment '截止日期',
  relation_type string comment '公司与披露方关系',
  s_holder_name string comment '股东名称',
  s_holder_code string comment '股东ID',
  s_holder_type bigint comment '股东类型',
  s_holder_pct decimal(20,4) comment '持股比例(%)',
  is_actualcontroller bigint comment '股东是否为实际控制人',
  actualcontroller_type string comment '实际控制人类型',
  actualcontroller_is_ann bigint comment '股东是否为公布实际控制人',
  actualcontroller_intro string comment '实际控制人简介',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



