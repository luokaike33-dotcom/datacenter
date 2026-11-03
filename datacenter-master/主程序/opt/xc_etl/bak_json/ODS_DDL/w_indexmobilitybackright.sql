drop table if exists ty_ods.w_indexmobilitybackright;
create table if not exists ty_ods.w_indexmobilitybackright
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  ema_5d decimal(20,8) comment '5日收盘价EMA',
  ema2_5d decimal(20,8) comment '5日收盘价二重EMA',
  ema3_5d decimal(20,8) comment '5日收盘价三重EMA',
  ema_10d decimal(20,8) comment '10日收盘价EMA',
  ema2_10d decimal(20,8) comment '10日收盘价二重EMA',
  ema3_10d decimal(20,8) comment '10日收盘价三重EMA',
  ema_20d decimal(20,8) comment '20日收盘价EMA',
  ema_60d decimal(20,8) comment '60日收盘价EMA',
  ema_120d decimal(20,8) comment '120日收盘价EMA',
  ema_12d decimal(20,8) comment '12日收盘价EMA',
  ema_26d decimal(20,8) comment '26日收盘价EMA',
  ema_13d decimal(20,8) comment '13日收盘价EMA',
  s_pvi decimal(20,8) comment '正成交量指标PVI',
  s_nvi decimal(20,8) comment '负成交量指标NVI',
  s_tr decimal(20,8) comment '均幅指标中间量TR(元)',
  s_atr6 decimal(20,8) comment '6日均幅指标ATR6',
  s_atr14 decimal(20,8) comment '14日均幅指标ATR14',
  s_dbcd decimal(20,8) comment '异同离差乖离率DBCD',
  s_ema3d decimal(20,8) comment '3日收集派发EMA',
  s_ema10d decimal(20,8) comment '10日收集派发EMA',
  s_ahl decimal(20,8) comment '梅斯线中间量AHL',
  s_bhl decimal(20,8) comment '梅斯线中间量BHL',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '指数移动平均型指标(后复权)'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



