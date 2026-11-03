drop table if exists ty_ods.w_cbondguaranteestatistics;
create table if not exists ty_ods.w_cbondguaranteestatistics
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  total_amount_guarantee decimal(20,4) comment '担保发生额合计',
  guarantee_balance_total decimal(20,4) comment '担保余额合计',
  amount_of_guarantee decimal(20,4) comment '担保总额',
  holding_total_amount_guarantee decimal(20,4) comment '对控股子公司担保发生额合计',
  violation_amount_guarantee decimal(20,4) comment '违规担保总额',
  amount_of_guarantee_rate decimal(20,4) comment '担保总额占净资产比例',
  deadline string comment '截止日期',
  ann_date string comment '公告日期',
  currency_code string comment '货币代码',
  holding_total decimal(20,4) comment '对控股子公司担保余额合计',
  controlling_total decimal(20,4) comment '为控股股东及其他关联方提供担保金额',
  total_amount_guarantee1 decimal(20,4) comment '为高负债对象提供担保金额',
  is_more_than_net_assets bigint comment '担保总额是否超过净资产50%',
  net_assets_rate decimal(20,4) comment '担保总额占净资产比例(%)(计算值)',
  more_than_net_assets_amount decimal(20,4) comment '担保总额超过净资产50%部分的金额',
  holding_amount_of_guarantee decimal(20,4) comment '对控股子公司担保额度合计',
  external_guarantee decimal(20,4) comment '对外担保额度合计',
  amount_of_guarantee_total decimal(20,4) comment '担保额度合计',
  net_assets_rate2 decimal(20,4) comment '担保额度占净资产比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



