drop table if exists ty_ods.w_trendriskfactor;
create table if not exists ty_ods.w_trendriskfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_ma10regresscoeff6 decimal(20,8) comment '12日变化率指数',
  s_tech_ma10regresscoeff12 decimal(20,8) comment '24日变化率指数',
  s_tech_plrc6 decimal(20,8) comment 'Ulcer5',
  s_tech_plrc12 decimal(20,8) comment 'Ulcer10',
  s_tech_ddncr decimal(20,8) comment '下跌相关系数',
  s_tech_ddnsr decimal(20,8) comment '下跌波动',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '趋势风险因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



