drop table if exists ty_ods.w_aequfropleinforepperend;
create table if not exists ty_ods.w_aequfropleinforepperend
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  price_date string comment '报告期',
  f_nav_unit string comment '公告日期',
  f_nav_accumulated string comment '股东名称',
  f_nav_divaccumulated decimal(20,4) comment '质押或冻结数量(股)',
  f_nav_adjfactor decimal(20,4) comment '持股数量(股)',
  crncy_code decimal(20,4) comment '质押冻结比例(%)',
  f_nav_adjusted string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



