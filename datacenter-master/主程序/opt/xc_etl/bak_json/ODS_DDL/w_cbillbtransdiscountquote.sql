drop table if exists ty_ods.w_cbillbtransdiscountquote;
create table if not exists ty_ods.w_cbillbtransdiscountquote
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  trade_tm string comment '时间',
  b_info_tradetypcode bigint comment '业务类型代码',
  b_info_tradeside bigint comment '交易方向',
  b_info_amountmn decimal(20,4) comment '报价金额',
  b_info_interest decimal(20,8) comment '利率',
  b_anal_ptm string comment '剩余期限',
  b_info_accepttype bigint comment '承兑行类型代码',
  b_info_billtype bigint comment '票据类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国银行间票据转贴现报价'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



