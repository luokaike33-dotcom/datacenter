drop table if exists ty_ods.w_cbondput;
create table if not exists ty_ods.w_cbondput
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_info_repurchasedate string comment '回售资金到帐日',
  b_info_repurchaseprice decimal(20,4) comment '每百元面值回售价格(元)',
  b_info_putannouncementdate string comment '回售公告日',
  b_info_putexdate string comment '回售履行结果公告日',
  b_info_putamount decimal(20,4) comment '回售总面额(亿元)',
  b_info_putoutstanding decimal(20,4) comment '继续托管总面额(亿元)',
  b_info_repurchasestartdate string comment '回售行使开始日',
  b_info_repurchaseenddate string comment '回售行使截止日',
  b_info_fundenddate string comment '回售日 ',
  b_info_repurchasecode string comment '回售代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



