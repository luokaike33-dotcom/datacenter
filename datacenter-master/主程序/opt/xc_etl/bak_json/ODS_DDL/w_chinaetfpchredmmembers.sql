drop table if exists ty_ods.w_chinaetfpchredmmembers;
create table if not exists ty_ods.w_chinaetfpchredmmembers
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  trade_dt string comment '交易日期',
  s_con_windcode string comment '成份股Wind代码',
  s_con_stocknumber decimal(20,4) comment '股票数量',
  f_info_cashsubsign bigint comment '现金替代标志',
  f_info_casubpremra decimal(20,4) comment '现金替代溢价比例(%)',
  f_info_casubamount decimal(20,4) comment '固定替代金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



