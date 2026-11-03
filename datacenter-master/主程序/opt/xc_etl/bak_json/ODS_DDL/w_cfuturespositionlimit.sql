drop table if exists ty_ods.w_cfuturespositionlimit;
create table if not exists ty_ods.w_cfuturespositionlimit
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  position_limit_type bigint comment '限仓对象类型代码',
  change_dt string comment '变动日期',
  position_limit bigint comment '持仓限定数量',
  position_limit_ratio decimal(20,4) comment '持仓限定比例',
  change_reason string comment '变动原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



