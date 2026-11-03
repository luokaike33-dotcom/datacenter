drop table if exists ty_ods.w_fundbondportfolio;
create table if not exists ty_ods.w_fundbondportfolio
(
  object_id string comment '对象ID',
  s_info_code string comment '基金代码',
  deadline string comment '截止日期',
  b_info_creditrating bigint comment '债券评级代码',
  rating_value_type bigint comment '评级取值类型',
  market_value decimal(20,4) comment '市值',
  net_assets_ratio decimal(20,4) comment '占净资产比例',
  currency_code string comment '市值货币代码',
  position_type_code bigint comment '持仓类型代码',
  ann_date string comment '公告日期',
  announce_rating_code string comment '公布评级代码',
  comp_id string comment '公司ID',
  rating_type_code bigint comment '评级品种类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



