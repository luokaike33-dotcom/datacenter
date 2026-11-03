drop table if exists ty_ods.w_hkshareshortsellingturnover;
create table if not exists ty_ods.w_hkshareshortsellingturnover
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_info_datatype bigint comment '数据类型',
  s_ss_volume decimal(20,4) comment '成交股数',
  s_ss_turnover decimal(20,4) comment '成交金额',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



