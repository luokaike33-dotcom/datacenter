drop table if exists ty_ods.w_cbondplacementdetails;
create table if not exists ty_ods.w_cbondplacementdetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  typeofinvestor string comment '法人投资者类型',
  investor_name string comment '法人投资者',
  investor_id string comment '法人投资者ID',
  placement decimal(20,4) comment '获配数量(万股/万张)',
  lockmonth decimal(20,4) comment '冻结期限(月)',
  ann_ordqty decimal(20,4) comment '实际申购数量',
  ann_dt string comment '公告日期',
  trade_dt string comment '配售截止日期',
  refund_payback_amount decimal(20,4) comment '退款或补缴金额',
  share_type string comment '股份类型',
  tradable_dt string comment '可流通日期',
  latest_own_qty decimal(20,4) comment '最新持股数量',
  latest_own_qty_financing decimal(20,4) comment '最新持股数量(配套融资)',
  investor_type_code bigint comment '投资者类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



