drop table if exists ty_ods.w_shsctop10activestocks;
create table if not exists ty_ods.w_shsctop10activestocks
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  market string comment '市场',
  buytradevalue decimal(20,4) comment '买入金额',
  selltradevalue decimal(20,4) comment '卖出金额',
  totaltradevalue decimal(20,4) comment '成交金额',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



