drop table if exists ty_ods.w_marketderivativefactor;
create table if not exists ty_ods.w_marketderivativefactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_price1m decimal(20,8) comment '当前股价除以过去1个月股价均值再减1',
  s_tech_price3m decimal(20,8) comment '当前股价除以过去3个月股价均值再减1',
  s_tech_price1y decimal(20,8) comment '当前股价除以过去1年的股价均值再减1',
  s_tech_rvi decimal(20,8) comment '相对离散指数',
  s_tech_moneyflow20 decimal(20,8) comment '20日资金流量',
  s_tech_emv14 decimal(20,8) comment '14日简易波动指标',
  s_tech_emv6 decimal(20,8) comment '6日简易波动指标',
  s_tech_aroon decimal(20,8) comment '阿隆指标',
  s_tech_aroondown decimal(20,8) comment '阿隆向下指标',
  s_tech_aroonup decimal(20,8) comment '阿隆向上指标',
  s_tech_ad6 decimal(20,8) comment '6日收集派发指标',
  s_tech_ad20 decimal(20,8) comment '20日收集派发指标',
  s_tech_ar decimal(20,8) comment 'AR人气指标',
  s_tech_br decimal(20,8) comment 'BR意愿指标',
  s_tech_arbr decimal(20,8) comment 'ARBR人气意愿指标',
  s_tech_cr20 decimal(20,8) comment 'CR能量指标',
  s_tech_bearpower decimal(20,8) comment '空头力道',
  s_tech_bullpower decimal(20,8) comment '多头力道',
  s_tech_dhilo decimal(20,8) comment '波幅中位数',
  s_tech_skewness decimal(20,8) comment '股价偏度',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '行情衍生因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



