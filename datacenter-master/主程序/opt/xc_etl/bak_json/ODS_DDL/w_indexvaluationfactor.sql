drop table if exists ty_ods.w_indexvaluationfactor;
create table if not exists ty_ods.w_indexvaluationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  index_number decimal(20,4) comment '成份股个数',
  i_tech_uppct decimal(20,4) comment '上涨的股票占指数成份股的比例',
  i_tech_downpct decimal(20,4) comment '下跌的股票占指数成份股的比例',
  i_tech_limituppct decimal(20,4) comment '涨停的股票占指数成份股的比例',
  i_tech_limitdownpct decimal(20,4) comment '跌停的股票占指数成份股的比例',
  i_val_pe2 decimal(20,4) comment '算术平均滚动市盈率',
  i_val_pb2 decimal(20,4) comment '算术平均滚动市净率',
  i_val_pe1 decimal(20,4) comment '加权市盈率',
  i_val_pb1 decimal(20,4) comment '加权市净率',
  i_val_pe3 decimal(20,4) comment 'PE(中位数)',
  i_val_pb3 decimal(20,4) comment 'PB(中位数)',
  i_val_pe_ttm_ex_nv decimal(20,4) comment 'PE(TTM,剔除负值整体法)',
  i_div_effect decimal(20,4) comment '分红影响',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '指数估值因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



