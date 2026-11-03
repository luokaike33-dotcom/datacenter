drop table if exists ty_ods.w_cbondcall;
create table if not exists ty_ods.w_cbondcall
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_info_redemptiondate string comment '赎回日',
  b_info_redemptionprice decimal(20,4) comment '每百元面值赎回价格(元)',
  b_info_callannouncementdate string comment '赎回公告日',
  b_info_callexdate string comment '赎回履行结果公告日',
  b_info_callamount decimal(20,4) comment '赎回总面额(亿元)',
  b_info_calloutstanding decimal(20,4) comment '继续托管总面额(亿元)',
  b_redemptiondate string comment '赎回日(公布)',
  b_info_call_reason string comment '赎回原因',
  b_info_call_arrival_day string comment '赎回资金到账日',
  b_info_call_record_day string comment '赎回登记日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



