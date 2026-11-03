drop table if exists ty_ods.w_ashareinstholderderdata;
create table if not exists ty_ods.w_ashareinstholderderdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_holder_compcode string comment '股东公司id',
  s_holder_name string comment '股东名称',
  s_holder_holdercategory string comment '股东类型',
  s_holder_quantity decimal(20,4) comment '持股数',
  s_holder_pct decimal(20,4) comment '持股比例(计算)',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



