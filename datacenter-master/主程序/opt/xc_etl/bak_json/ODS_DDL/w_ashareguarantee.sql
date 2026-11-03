drop table if exists ty_ods.w_ashareguarantee;
create table if not exists ty_ods.w_ashareguarantee
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  relation string comment '担保方与披露方关系',
  guarantor string comment '担保方公司名称',
  relation2 string comment '被担保方与披露方关系',
  securedparty string comment '被担保方公司名称',
  method string comment '担保方式',
  amount decimal(20,4) comment '担保金额(元)',
  crncy_code string comment '币种',
  term decimal(20,4) comment '担保期限(年)',
  start_dt string comment '担保起始日期',
  end_dt string comment '担保终止日期',
  is_complete bigint comment '是否履行完毕',
  is_related bigint comment '是否关联交易',
  trade_dt string comment '交易日期',
  report_period string comment '报告期',
  is_overdue bigint comment '担保是否逾期',
  overdue_amount decimal(20,4) comment '担保逾期金额(元)',
  is_counterguarantee bigint comment '是否存在反担保',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



