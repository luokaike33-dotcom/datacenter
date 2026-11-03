drop table if exists ty_ods.w_asharepledgetrade;
create table if not exists ty_ods.w_asharepledgetrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  initial_num decimal(20,4) comment '初始交易数量',
  repurchase_num decimal(20,4) comment '购回交易数量',
  repurchase_allowance decimal(20,4) comment '待购回余量',
  repurchase_allowance1 decimal(20,4) comment '待购回余量(无限售条件)',
  repurchase_allowance2 decimal(20,4) comment '待购回余量(有限售条件)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



