drop table if exists ty_ods.w_asharetaxespayable;
create table if not exists ty_ods.w_asharetaxespayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  vat decimal(20,4) comment '增值税',
  business_tax decimal(20,4) comment '营业税',
  corporate_income_tax decimal(20,4) comment '企业所得税',
  urban_maintenance_tax decimal(20,4) comment '城市维护建设税',
  property_tax decimal(20,4) comment '房产税',
  personal_income_tax decimal(20,4) comment '个人所得税',
  sale_tax decimal(20,4) comment '消费税',
  land_holding_tax decimal(20,4) comment '土地使用税',
  stamp_duty decimal(20,4) comment '印花税',
  vehicle_usage_tax decimal(20,4) comment '车船使用税',
  land_value_added_tax decimal(20,4) comment '土地增值税',
  resource_tax decimal(20,4) comment '资源税',
  other decimal(20,4) comment '其他',
  total decimal(20,4) comment '合计',
  memo string comment '备注',
  statement_type string comment '报表类型',
  education_surcharge decimal(20,4) comment '教育费附加',
  flood_control_fund decimal(20,4) comment '防洪基金',
  compensation_mineral_resources decimal(20,4) comment '矿产资源补偿费',
  vehicle_purchase_surcharge decimal(20,4) comment '车辆购置附加费',
  agriculture_forestry_tax decimal(20,4) comment '农林特产税',
  local_education_fee decimal(20,4) comment '地方教育费附加',
  price_control_fund decimal(20,4) comment '价格调控基金',
  statement_type_code bigint comment '报表类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



