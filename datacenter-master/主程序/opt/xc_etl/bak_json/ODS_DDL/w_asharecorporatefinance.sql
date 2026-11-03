drop table if exists ty_ods.w_asharecorporatefinance;
create table if not exists ty_ods.w_asharecorporatefinance
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  buy_company_name string comment '实际购买公司名称',
  s_relation_typcode bigint comment '实际购买公司和上市公司关系类型代码',
  s_issuer_name string comment '产品发行方公布名称',
  s_issuer_id string comment '产品发行方ID',
  s_fullname string comment '理财产品名称',
  s_info_code string comment '[内部]理财产品ID',
  s_underlying bigint comment '理财类型代码',
  s_subscription_date string comment '认购日期',
  s_subscription_amount decimal(20,4) comment '认购金额',
  s_crncy_code string comment '货币代码',
  s_incomestartdate string comment '产品起息日期',
  s_incomeenddate string comment '产品到期日期',
  s_commission string comment '产品期限',
  s_expyidld_min decimal(20,4) comment '预计最低收益率',
  s_expyield_max decimal(20,4) comment '预计最高收益率',
  s_sources_funds_code bigint comment '资金来源类型代码',
  is_connection_relation bigint comment '买方与卖方是否有关联关系',
  s_net_assets_ratio decimal(20,4) comment '本次出资占公司最近一期审计净资产比例',
  s_summary string comment '理财产品摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



