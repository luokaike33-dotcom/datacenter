drop table if exists ty_ods.w_chinamutualfundpchredm;
create table if not exists ty_ods.w_chinamutualfundpchredm
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_unit_rpstartdate string comment '报告期开始日期',
  f_unit_rpenddate string comment '报告期结束日期',
  f_unit_startshares decimal(20,4) comment '期初基金总份额(份)',
  f_unit_purchase decimal(20,4) comment '本期基金总申购份额(份)',
  f_unit_redemption decimal(20,4) comment '本期基金总赎回份额(份)',
  f_unit_endshares decimal(20,4) comment '期末基金总份额(份)',
  trade_dt string comment '公告日期',
  f_unit_startshares_total decimal(20,4) comment '期初基金总份额-合计',
  f_unit_endshares_total decimal(20,4) comment '期末基金总份额-合计',
  f_unit_purchase_total decimal(20,4) comment '本期基金总申购份额-合计',
  f_unit_redemption_total decimal(20,4) comment '本期基金总赎回份额-合计',
  is_merge_data bigint comment '是否为合并数据',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



