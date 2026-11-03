drop table if exists ty_ods.w_turnovertechnicalfactor;
create table if not exists ty_ods.w_turnovertechnicalfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_tvma6 decimal(20,8) comment '6日成交额均值(万元)',
  s_tech_tvma20 decimal(20,8) comment '20日成交额均值(万元)',
  s_tech_tvma60 decimal(20,8) comment '60日成交额均值(万元)',
  s_tech_tvstd6 decimal(20,8) comment '6日成交额标准差',
  s_tech_tvstd20 decimal(20,8) comment '20日成交额标准差',
  s_tech_vema5 decimal(20,8) comment '5日成交量EMA（手）',
  s_tech_vema10 decimal(20,8) comment '10日成交量EMA（手）',
  s_tech_vema12 decimal(20,8) comment '12日成交量EMA（手）',
  s_tech_vema26 decimal(20,8) comment '26日成交量EMA（手）',
  s_tech_vroc6 decimal(20,8) comment '6日量变动速率指标',
  s_tech_vroc12 decimal(20,8) comment '12日量变动速率指标',
  s_tech_vr decimal(20,8) comment '成交量比率',
  s_tech_turnoverrate5 decimal(20,8) comment '5日平均换手率（%）',
  s_tech_turnoverrate10 decimal(20,8) comment '10日平均换手率（%）',
  s_tech_turnoverrate20 decimal(20,8) comment '20日平均换手率（%）',
  s_tech_turnoverrate60 decimal(20,8) comment '60日平均换手率（%）',
  s_tech_turnoverrate120 decimal(20,8) comment '120日平均换手率（%）',
  s_tech_turnoverrate240 decimal(20,8) comment '240日平均换手率（%）',
  s_tech_turnoverratevol20 decimal(20,8) comment '换手率相对波动率',
  s_tech_mktfaciind decimal(20,8) comment '市场促进指数（万元）',
  s_tech_cyf decimal(20,8) comment '市场能量指标',
  s_tech_volumevolatility decimal(20,8) comment '市场交易量波动率',
  s_tech_volume1m60 decimal(20,8) comment '20日60日成交量比',
  s_tech_volumn1m decimal(20,8) comment '量比收益率',
  s_tech_turn5dturn120 decimal(20,8) comment '5日平均换手率与120日平均换手率之比',
  s_tech_turn10dturn120 decimal(20,8) comment '10日平均换手率与120日平均换手率之比',
  s_tech_turn20dturn120 decimal(20,8) comment '20日平均换手率与120日平均换手率之比',
  s_tech_amount1m60 decimal(20,8) comment '成交额惯性',
  s_tech_cry decimal(20,8) comment '市场强弱指标',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '成交量换手率技术因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



