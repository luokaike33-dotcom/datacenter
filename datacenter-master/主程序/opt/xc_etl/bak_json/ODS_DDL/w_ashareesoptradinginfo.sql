drop table if exists ty_ods.w_ashareesoptradinginfo;
create table if not exists ty_ods.w_ashareesoptradinginfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  esop_windcode string comment '员工持股计划证券ID',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  trade_avg_price decimal(20,4) comment '成交均价',
  trading_volume decimal(20,4) comment '成交数量',
  ratio_to_totalshares decimal(20,4) comment '占公司总股本比例',
  lockup_period bigint comment '锁定期限',
  event_id string comment '事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



