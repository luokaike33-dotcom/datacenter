drop table if exists ty_ods.w_chinaoptionmemberstatistics;
create table if not exists ty_ods.w_chinaoptionmemberstatistics
(
  object_id string comment '对象ID',
  s_info_code string comment '期权Wind代码',
  s_info_name string comment '期权名称',
  trade_dt string comment '交易日期',
  item_code bigint comment '类型',
  value decimal(20,4) comment '数量',
  rank bigint comment '名次',
  s_info_membername string comment '会员简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



