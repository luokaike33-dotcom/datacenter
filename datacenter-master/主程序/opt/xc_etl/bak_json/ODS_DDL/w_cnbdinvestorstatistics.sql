drop table if exists ty_ods.w_cnbdinvestorstatistics;
create table if not exists ty_ods.w_cnbdinvestorstatistics
(
  object_id string comment '对象ID',
  months string comment '月份',
  investortype string comment '投资者类型',
  trusttype string comment '托管类型',
  num_endmonths decimal(20,4) comment '月末数量',
  num_incyear decimal(20,4) comment '年增数量',
  num_endyear decimal(20,4) comment '上年末数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



