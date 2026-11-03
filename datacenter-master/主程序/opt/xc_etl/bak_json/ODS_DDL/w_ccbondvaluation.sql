drop table if exists ty_ods.w_ccbondvaluation;
create table if not exists ty_ods.w_ccbondvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  cb_anal_accrueddays decimal(20,4) comment '已计息天数',
  cb_anal_accruedinterest decimal(20,4) comment '应计利息',
  cb_anal_ptm decimal(20,4) comment '剩余期限（年）',
  cb_anal_curyield decimal(20,4) comment '当期收益率',
  cb_anal_ytm decimal(20,4) comment '纯债到期收益率',
  cb_anal_strbvalue decimal(20,4) comment '纯债价值',
  cb_anal_strbpremium decimal(20,4) comment '纯债溢价',
  cb_anal_strbpremiumratio decimal(20,4) comment '纯债溢价率',
  cb_anal_convprice decimal(20,4) comment '转股价',
  cb_anal_convratio decimal(20,6) comment '转股比例',
  cb_anal_convvalue decimal(20,4) comment '转股价值',
  cb_anal_convpremium decimal(20,4) comment '转股溢价',
  cb_anal_convpremiumratio decimal(20,4) comment '转股溢价率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



