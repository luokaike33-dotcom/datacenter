drop table if exists ty_ods.w_asharemarketoverallindex;
create table if not exists ty_ods.w_asharemarketoverallindex
(
  object_id string comment '对象ID',
  month1 string comment '月份',
  `exchange` string comment '交易所',
  listed_company_num decimal(15,4) comment '上市公司总数',
  listed_securities_num decimal(15,4) comment '上市证券总数',
  listed_stock_num decimal(15,4) comment '上市股票总数',
  listed_ashare_num decimal(15,4) comment '上市A股总数',
  listed_bshare_num decimal(15,4) comment '上市B股总数',
  stock_total_capital decimal(15,4) comment '股票-总股本(亿元)',
  stock_total_market_value decimal(15,4) comment '股票-总市值(亿元)',
  stock_flow_equity decimal(15,4) comment '股票-流通股本(亿股)',
  stock_flow_market_value decimal(15,4) comment '股票-流通市值(亿元)',
  open_accounts_num decimal(15,4) comment '投资者开户总数(万户)',
  average_pe decimal(15,4) comment '平均市盈率',
  ashare_average_pe decimal(15,4) comment 'A股平均市盈率',
  bshare_average_pe decimal(15,4) comment 'B股平均市盈率',
  stock_fund_transaction_amount decimal(15,4) comment '股票、基金成交金额:当年累计(亿元)',
  ashare_transaction_amount decimal(15,4) comment 'A股成交金额:当年累计(亿元)',
  bshare_transaction_amount decimal(15,4) comment 'B股成交金额:当年累计(亿元)',
  fund_transaction_amount decimal(15,4) comment '基金成交金额:当年累计(亿元)',
  bond_transaction_amount decimal(15,4) comment '债券成交金额:当年累计(亿元)',
  ashare_stamp_duty decimal(15,4) comment '代扣A股交易印花税(亿元)',
  bshare_stamp_duty decimal(15,4) comment '代扣B股交易印花税(亿美元/港币)',
  stock_repurchase_amount decimal(20,4) comment '股票回购金额:当年累计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



