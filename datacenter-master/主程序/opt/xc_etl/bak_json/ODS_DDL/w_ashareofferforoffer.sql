drop table if exists ty_ods.w_ashareofferforoffer;
create table if not exists ty_ods.w_ashareofferforoffer
(
  object_id string comment '对象ID',
  s_info_compcode string comment '被要约收购公司id',
  acquirer_name string comment '收购人名称',
  is_privatization bigint comment '是否属于私有化',
  start_date string comment '要约起始日期',
  end_date string comment '要约终止日期',
  circulation_stock_num decimal(20,4) comment '预定收购流通股数量(万股)',
  circulation_stock_proportion decimal(20,4) comment '预定收购流通股数量占总股本比例(%)',
  purchasing_price decimal(20,4) comment '流通股每股收购价格',
  conv_code string comment '流通股股东申报代码',
  restricted_stock_num decimal(20,4) comment '预定收购非流通股(限售流通股)数量(万股)',
  restricted_stock_proportion decimal(20,4) comment '预定收购非流通股(限售流通股)数量占总股本比例(%)',
  restricted_purchasing_price decimal(20,4) comment '非流通股(限售流通股)每股收购价格',
  restricted_conv_code string comment '非流通股(限售流通股)股东申报代码',
  total_amount_funds decimal(20,4) comment '预定收购资金总额(万元)',
  payment_method string comment '支付方式',
  circulation_stock_num1 decimal(20,4) comment '实际收购流通股数量(万股)',
  total_amount_funds1 decimal(20,4) comment '实际收购资金总额(万元)',
  offer_for_offer string comment '要约收购目的',
  effective_conditions string comment '要约收购生效条件',
  price_description string comment '要约收购价格说明',
  financialadvisor string comment '财务顾问',
  s_profitnotice_firstanndate string comment '首次公告日',
  s_profitnotice_date string comment '要约收购书公告日',
  s_result_bulletin_day string comment '要约收购结果公告日',
  nann_date string comment '最新公告日期',
  shareholding_ratio decimal(20,4) comment '要约收购书公告日收购人持股比例(%)',
  new_shareholding_ratio decimal(20,4) comment '要约期满收购人持股比例(%)',
  circulation_stock_ratio decimal(20,4) comment '实际收购流通股数量占总股本比例(%)',
  restricted_stock_num1 decimal(20,4) comment '实际收购非流通股(限售流通股)数量(万股)',
  restricted_stock_ratio decimal(20,4) comment '实际收购非流通股(限售流通股)数量占总股本比例(%)',
  capital_description string comment '要约收购资金说明',
  offer_code bigint comment '要约方式代码',
  event_id string comment '并购事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



