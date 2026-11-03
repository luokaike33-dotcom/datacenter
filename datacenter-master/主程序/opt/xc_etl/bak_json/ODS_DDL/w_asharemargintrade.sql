drop table if exists ty_ods.w_asharemargintrade;
create table if not exists ty_ods.w_asharemargintrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_margin_tradingbalance decimal(20,4) comment '融资余额(元)',
  s_margin_purchwithborrowmoney decimal(20,4) comment '融资买入额(元,股)',
  s_margin_repaymenttobroker decimal(20,4) comment '融资偿还额(元,股)',
  s_margin_seclendingbalance decimal(20,4) comment '融券余额(元)',
  s_margin_seclendingbalancevol decimal(20,4) comment '融券余量(股,份,手)',
  s_margin_salesofborrowedsec decimal(20,4) comment '融券卖出量(股,份,手)',
  s_margin_repaymentofborrowsec decimal(20,4) comment '融券偿还量(股,份,手)',
  s_margin_margintradebalance decimal(20,4) comment '融资融券余额(元)',
  s_refin_sl_vol_3d bigint comment '转融券融出数量(3天)',
  s_refin_sl_vol_7d bigint comment '转融券融出数量(7天)',
  s_refin_sl_vol_14d bigint comment '转融券融出数量(14天)',
  s_refin_sl_vol_28d bigint comment '转融券融出数量(28天)',
  s_refin_sl_vol_182d bigint comment '转融券融出数量(182天)',
  s_refin_sb_vol_3d bigint comment '转融券融入数量(3天)',
  s_refin_sb_vol_7d bigint comment '转融券融入数量(7天)',
  s_refin_sb_vol_14d bigint comment '转融券融入数量(14天)',
  s_sb_vol_28d bigint comment '转融券融入数量(28天)',
  s_sb_vol_182d bigint comment '转融券融入数量(182天)',
  s_refin_sl_eod_vol bigint comment '转融券融出日成交量',
  s_refin_sb_eod_vol bigint comment '转融券融入日成交量',
  s_refin_sl_eop_vol bigint comment '转融券期末余量',
  s_refin_sl_eop_bal decimal(20,4) comment '转融券期末余额',
  s_refin_repay_vol bigint comment '转融券偿还量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



