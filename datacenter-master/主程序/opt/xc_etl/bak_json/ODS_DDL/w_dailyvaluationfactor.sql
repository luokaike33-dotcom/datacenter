drop table if exists ty_ods.w_dailyvaluationfactor;
create table if not exists ty_ods.w_dailyvaluationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_dfa_lnmv decimal(20,4) comment '对数市值（元）',
  s_dfa_lntotassets decimal(20,4) comment '对数总资产（元）',
  s_dfa_floatmv decimal(20,4) comment '自由流通市值（元）',
  s_dfa_lnfloatmv decimal(20,4) comment '对数自由流通市值（元）',
  s_dfa_opps decimal(20,4) comment '每股营业利润(TTM)（元）',
  s_dfa_pettm_deducted decimal(20,4) comment '扣非后市盈率(TTM)',
  s_dfa_mvtoebitda decimal(20,4) comment '总市值/EBITDA(TTM反推法)',
  s_dfa_profittomv decimal(20,4) comment '收益市值比(TTM)（%）',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '对数及其他日估值因子'
row format delimited fields terminated by '\t'
stored as orc;



