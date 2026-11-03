drop table if exists ty_ods.w_scfconvert;
create table if not exists ty_ods.w_scfconvert
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  convert_reason bigint comment '折算原因代码',
  period decimal(20,4) comment '折算周期(年)',
  convert_dt string comment '折算基准日',
  nav_typecode bigint comment '基金净值类型代码',
  nav_min decimal(20,4) comment '基金净值下限(元)',
  nav_max decimal(20,4) comment '基金净值上限(元)',
  convert_typecode bigint comment '折算方式代码',
  convert_fund_typecode bigint comment '折算母基金份额的方式代码',
  convert_feeder_typecode bigint comment '折算子基金份额的方式代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



