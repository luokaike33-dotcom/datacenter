drop table if exists ty_ods.w_chinaoptionvaluation;
create table if not exists ty_ods.w_chinaoptionvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  trade_dt string comment '交易日期',
  w_anal_underlyingimpliedvol decimal(24,8) comment '隐含波动率(%)',
  w_anal_delta decimal(24,8) comment 'Delta',
  w_anal_theta decimal(24,8) comment 'Theta',
  w_anal_gamma decimal(24,8) comment 'Gamma',
  w_anal_vega decimal(24,8) comment 'Vega',
  w_anal_rho decimal(24,8) comment 'Rho',
  surged_limit decimal(24,8) comment '涨停价格',
  decline_limit decimal(24,8) comment '跌停价格',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



