drop table if exists ty_ods.w_cmmfportfolioptm;
create table if not exists ty_ods.w_cmmfportfolioptm
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  f_ptm_top decimal(20,4) comment '剩余期下限',
  f_ptm_bottom decimal(20,4) comment '剩余期上限',
  ratio_assert_nav decimal(20,4) comment '资产占净值比例(%)',
  ratio_liab_nav decimal(20,4) comment '负债占净值比例(%)',
  typecode string comment '类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



