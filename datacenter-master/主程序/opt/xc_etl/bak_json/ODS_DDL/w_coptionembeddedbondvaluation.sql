drop table if exists ty_ods.w_coptionembeddedbondvaluation;
create table if not exists ty_ods.w_coptionembeddedbondvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  price_type_code bigint comment '价格类型代码',
  price_type string comment '价格类型',
  b_anal_nxoptiondate string comment '最近行权日',
  b_anal_termifexercise decimal(22,4) comment '行权剩余期限',
  b_anal_ytm_ifexe decimal(24,8) comment '行权收益率',
  b_anal_durationifexercise decimal(24,8) comment '行权久期',
  b_anal_modiduration_ifexe decimal(24,8) comment '行权修正久期',
  b_anal_convexity_ifexe decimal(24,8) comment '行权凸性',
  b_anal_basevalue_ifexe decimal(24,8) comment '行权基点价值',
  b_anal_bduration_ifexe decimal(24,8) comment '行权基准久期',
  b_anal_bconvexity_ifexe decimal(24,8) comment '行权基准凸性',
  b_anal_sduration_ifexe decimal(24,8) comment '行权利差久期',
  b_anal_sconvexity_ifexe decimal(24,8) comment '行权利差凸性',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



