drop table if exists ty_ods.w_ipoinquirydetails;
create table if not exists ty_ods.w_ipoinquirydetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  inquirer string comment '询价对象名称',
  inquirerid string comment '询价对象名称ID',
  inquirer_typecode bigint comment '投资者类别代码',
  issuetarget string comment '配售对象名称',
  dedaredprice decimal(20,4) comment '申报价格(元/股)',
  dedaredshares decimal(20,4) comment '申购数量(万股)',
  is_valid bigint comment '是否有效报价投资者',
  issuetarget1 string comment '公布配售对象名称',
  pct_change_1m decimal(20,4) comment '配售数量',
  issuetargetid string comment '配售对象名称ID',
  reject_dedaredshares decimal(20,4) comment '被剔除申购股数(万股)',
  act_dedaredshares decimal(20,4) comment '实际申购数量(万股)',
  security_account string comment '证券账户',
  quote_type_code bigint comment '报价结果类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'IPO初步询价明细'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



