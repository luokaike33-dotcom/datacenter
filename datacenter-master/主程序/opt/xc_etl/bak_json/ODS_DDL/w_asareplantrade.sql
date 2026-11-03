drop table if exists ty_ods.w_asareplantrade;
create table if not exists ty_ods.w_asareplantrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '首次披露公告日',
  ann_dt_new string comment '最新公告日',
  is_adjustment bigint comment '方案是否有过调整',
  programme_progress bigint comment '方案进度代码',
  holder_name string comment '持有方名称',
  holder_id string comment '持有方id',
  holder_status string comment '股东身份类别',
  holder_type string comment '股东类型',
  hold_number decimal(20,4) comment '持有证券数量(股/张)',
  hold_proportion decimal(20,4) comment '持股数量占比(%)',
  hold_restricted_stock decimal(20,4) comment '持有限售股数量(股)',
  hold_unlimited_sale_shares decimal(20,4) comment '持有无限售股数量(股)',
  transact_type string comment '变动方向',
  transact_objective string comment '变动目的',
  transact_stock_source string comment '变动股份来源',
  transact_source_funds string comment '变动资金来源',
  transact_period_description string comment '变动期间说明',
  transaction_mode string comment '交易方式',
  plan_transact_max_num decimal(20,4) comment '拟变动数量上限(股/张)',
  plan_transact_max_ratio decimal(20,4) comment '拟变动数量上限占比(%)',
  plan_transact_min_num decimal(20,4) comment '拟变动数量下限(股/张)',
  plan_transact_min_ratio decimal(20,4) comment '拟变动数量下限占比(%)',
  plan_max_hold_ratio decimal(20,4) comment '拟最大变动数量占持有公司股份的比例(%)',
  tot_actual_transact_num decimal(20,4) comment '实际累计变动证券数量(股/张)',
  total_capital_stock decimal(20,4) comment '公司总股本(股)',
  plan_transact_min decimal(20,4) comment '拟变动金额下限(元)',
  plan_transact_max decimal(20,4) comment '拟变动金额上限(元)',
  variable_price_memo string comment '变动价格说明',
  change_start_date string comment '变动起始日期',
  change_end_date string comment '变动截止日期',
  is_change_control bigint comment '是否导致公司控制权变更',
  special_changes_memo string comment '特殊变动说明',
  program_adjustment_memo string comment '方案调整说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



