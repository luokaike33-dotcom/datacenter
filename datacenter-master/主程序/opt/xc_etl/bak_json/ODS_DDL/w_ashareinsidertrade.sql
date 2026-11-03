drop table if exists ty_ods.w_ashareinsidertrade;
create table if not exists ty_ods.w_ashareinsidertrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  related_manager_name string comment '相关管理层姓名',
  reported_trader_name string comment '变动人姓名',
  change_volume decimal(20,4) comment '变动数',
  trade_avg_price decimal(20,4) comment '成交均价',
  position_after_trade decimal(20,4) comment '变动后持股',
  trade_dt string comment '变动日期',
  ann_dt string comment '填报日期',
  trade_reason_code bigint comment '变动原因类型代码',
  related_manager_post string comment '相关管理层职务',
  trader_manager_relation string comment '变动人与管理层的关系',
  actual_ann_dt string comment '实际公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



