drop table if exists ty_ods.w_chinamutualfundposestimation;
create table if not exists ty_ods.w_chinamutualfundposestimation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  f_est_date string comment '估算日期',
  f_est_largecapweg decimal(20,4) comment '大市值组合权重',
  f_est_midcapweg decimal(20,4) comment '中市值组合权重',
  f_est_smallcapweg decimal(20,4) comment '小市值组合权重',
  f_est_position decimal(20,4) comment '基金仓位',
  f_est_nav decimal(20,4) comment '估算收盘净值(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



