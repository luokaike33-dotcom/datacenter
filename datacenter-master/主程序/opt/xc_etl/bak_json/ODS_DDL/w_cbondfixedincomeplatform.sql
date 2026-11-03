drop table if exists ty_ods.w_cbondfixedincomeplatform;
create table if not exists ty_ods.w_cbondfixedincomeplatform
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_info_name string comment '证券中文简称',
  bid_trade_time string comment '买入报价时间',
  bid_quotingparty string comment '买入报价方',
  bid_clean_price decimal(20,4) comment '买入价(净价)',
  bid_num decimal(20,4) comment '买入数量',
  bid_price decimal(20,4) comment '买入价(全价)',
  bid_yield_to_maturity decimal(20,4) comment '买入到期收益率(%)',
  ask_trade_time string comment '卖出报价时间',
  ask_quotingparty string comment '卖出报价方',
  ask_clean_price decimal(20,4) comment '卖出价(净价)',
  ask_num decimal(20,4) comment '卖出数量',
  ask_price decimal(20,4) comment '卖出价(全价)',
  ask_yield_to_maturity decimal(20,4) comment '卖出到期收益率(%)',
  rate decimal(20,4) comment '应计利息',
  bid_order_number string comment '买入订单编号',
  ask_order_number string comment '卖出订单编号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



