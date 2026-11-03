drop table if exists ty_ods.w_cfundportfoliochanges;
create table if not exists ty_ods.w_cfundportfoliochanges
(
  object_id string comment '对象ID',
  f_info_windcode string comment '基金代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  s_info_windcode string comment '股票代码',
  change_type string comment '变动类型',
  accumulated_amount decimal(20,4) comment '累计金额',
  begin_net_asset_ratio decimal(20,4) comment '占期初基金资产净值比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



