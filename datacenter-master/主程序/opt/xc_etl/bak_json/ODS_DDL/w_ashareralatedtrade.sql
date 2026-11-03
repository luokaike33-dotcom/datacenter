drop table if exists ty_ods.w_ashareralatedtrade;
create table if not exists ty_ods.w_ashareralatedtrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_relatedtrade_name string comment 'B公司名称',
  s_relatedtrade_relationcode string comment '关联关系',
  s_relatedtrade_control bigint comment '是否存在控制关系',
  s_relatedtrade_tradetype string comment '交易类型',
  s_relatedtrade_settletype string comment '结算方式',
  crncy_code string comment '货币代码',
  s_relatedtrade_amount string comment '交易金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



