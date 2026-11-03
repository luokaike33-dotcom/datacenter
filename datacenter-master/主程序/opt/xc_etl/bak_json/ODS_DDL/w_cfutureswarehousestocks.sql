drop table if exists ty_ods.w_cfutureswarehousestocks;
create table if not exists ty_ods.w_cfutureswarehousestocks
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_code string comment '标准合约代码',
  ann_date string comment '日期',
  warehouse_region string comment '地区',
  warehouse_name string comment '仓库简称',
  deliverable_w decimal(20,4) comment '本周库存合计',
  on_warrant_w decimal(20,4) comment '本周库存（注册成仓单）',
  available_warehouse_w decimal(20,4) comment '本周可用库容量',
  quantity_unit string comment '单位',
  warehouse_in decimal(20,4) comment '入仓',
  warehouse_out decimal(20,4) comment '出仓',
  cancelled_warrants decimal(20,4) comment '注销仓单量',
  effective_forecast decimal(20,4) comment '有效预报',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



