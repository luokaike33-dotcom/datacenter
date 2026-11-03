drop table if exists ty_ods.w_asharetechindicators;
create table if not exists ty_ods.w_asharetechindicators
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  volume_ratio_5d decimal(20,8) comment '量比(5日)',
  vam_1m decimal(20,8) comment 'VMA量简单移动平均(1月)',
  vam_5m decimal(20,8) comment 'VMA量简单移动平均(5日)',
  vam_22m decimal(20,8) comment 'VMA量简单移动平均(22日)',
  vam_60m decimal(20,8) comment 'VMA量简单移动平均(60日)',
  ama_1w decimal(20,8) comment 'AMA额简单移动平均(1周)',
  ama_1m decimal(20,8) comment 'AMA额简单移动平均(1月)',
  ama_1q decimal(20,8) comment 'AMA额简单移动平均(1季)',
  vmacd decimal(20,8) comment 'VMACD量指数平滑异同平均DIF(12,26,9日)',
  vmacd_dea decimal(20,8) comment 'VMACD量指数平滑异同平均DEA(12,26,9日)',
  vmacd_macd decimal(20,8) comment 'VMACD量指数平滑异同平均MACD(12,26,9日)',
  vosc decimal(20,8) comment 'VOSC成交量震荡(12,26日)',
  tapi_16d decimal(20,8) comment 'TAPI加权指数成交值TAPI(6日)',
  tapi_6d decimal(20,8) comment 'TAPI加权指数成交值TAPIMA(6日)',
  vstd_10d decimal(20,8) comment 'VSTD成交量标准差(10日)',
  vmacd_ema12d decimal(20,8) comment 'VMACD量指数平滑异同平均EMA(成交量,12日)',
  vmacd_ema26d decimal(20,8) comment 'VMACD量指数平滑异同平均EMA(成交量,26日)',
  vrsi_6d decimal(20,8) comment 'VRSI量相对强弱(6日)',
  vroc_12d decimal(20,8) comment 'VROC量变动速率(12日)',
  sobv decimal(20,8) comment 'SOBV能量潮',
  vr_26d decimal(20,8) comment 'VR成交量比率(26日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



