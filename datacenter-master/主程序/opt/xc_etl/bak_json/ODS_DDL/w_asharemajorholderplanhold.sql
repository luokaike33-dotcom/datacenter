drop table if exists ty_ods.w_asharemajorholderplanhold;
create table if not exists ty_ods.w_asharemajorholderplanhold
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_holder_name string comment '股东名称',
  s_ph_startdate string comment '增持计划起始日期',
  s_ph_enddate string comment '增持计划截止日期',
  s_ph_conditionornot bigint comment '是否无条件增持',
  s_ph_triggerprice decimal(20,4) comment '增持触发价格',
  s_ph_continuousdays decimal(20,4) comment '连续天数',
  s_ph_calculatedays decimal(20,4) comment '计算天数',
  s_ph_calculatepricemode string comment '价格计算方式',
  s_ph_sharenumdownlimit decimal(20,4) comment '增持股数下限(万股)',
  s_ph_sharenumuplimit decimal(20,4) comment '增持股数上限(万股)',
  s_ph_intendputmoneydownlimit decimal(20,4) comment '拟投入金额下限(亿元)',
  s_ph_intendputmoneyuplimit decimal(20,4) comment '拟投入金额上限(亿元)',
  s_ph_priceuplimit decimal(20,4) comment '增持价格上限',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



