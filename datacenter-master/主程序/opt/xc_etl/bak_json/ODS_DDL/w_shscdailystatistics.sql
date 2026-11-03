drop table if exists ty_ods.w_shscdailystatistics;
create table if not exists ty_ods.w_shscdailystatistics
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  s_info_exchmarket string comment '交易所英文简称',
  value decimal(20,4) comment '数据',
  item_code bigint comment '项目代码',
  unit string comment '单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



