drop table if exists ty_ods.w_cfuturesinstock;
create table if not exists ty_ods.w_cfuturesinstock
(
  object_id string comment '对象ID',
  fs_info_scname string comment '标准合约名称',
  ann_date string comment '日期',
  in_stock_total decimal(20,4) comment '库存合计',
  in_stock decimal(20,4) comment '库存（注册成仓单）',
  available_in_stock decimal(20,4) comment '可用库容量',
  unit string comment '单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



