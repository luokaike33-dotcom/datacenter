drop table if exists ty_ods.w_cbondrepo;
create table if not exists ty_ods.w_cbondrepo
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  b_info_term decimal(20,4) comment '期限(天)',
  b_tender_interestrate decimal(20,4) comment '招标利率(%)',
  b_tender_amount decimal(20,4) comment '招标数量(亿元)',
  b_tender_method bigint comment '招标方式',
  b_info_repo_type bigint comment '操作类型代码',
  b_info_term_words string comment '期限(文字）',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



