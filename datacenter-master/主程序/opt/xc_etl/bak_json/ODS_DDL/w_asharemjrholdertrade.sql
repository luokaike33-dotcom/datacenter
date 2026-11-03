drop table if exists ty_ods.w_asharemjrholdertrade;
create table if not exists ty_ods.w_asharemjrholdertrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  transact_startdate string comment '变动起始日期',
  transact_enddate string comment '变动截至日期',
  holder_name string comment '持有人',
  holder_type string comment '持有人类型',
  transact_type string comment '买卖方向',
  transact_quantity decimal(20,4) comment '变动数量',
  transact_quantity_ratio decimal(20,4) comment '变动数量占流通量比例(%)',
  holder_quantity_new decimal(20,4) comment '最新持有流通数量',
  holder_quantity_new_ratio decimal(20,4) comment '最新持有流通数量占流通量比例(%)',
  avg_price decimal(20,4) comment '平均价格',
  whether_agreed_repur_trans bigint comment '是否约定购回式交易',
  blocktrade_quantity decimal(20,4) comment '通过大宗交易系统的变动数量',
  is_restricted bigint comment '是否为减持限售股份',
  is_reannounced bigint comment '是否重复披露',
  trade_detail string comment '变动说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



