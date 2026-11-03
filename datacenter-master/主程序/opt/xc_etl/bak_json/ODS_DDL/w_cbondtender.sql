drop table if exists ty_ods.w_cbondtender;
create table if not exists ty_ods.w_cbondtender
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  b_tender_tenderdate string comment '招投标日期',
  b_tender_method bigint comment '招标方式',
  b_tender_object bigint comment '招标标的',
  b_tender_amountplan decimal(20,4) comment '计划招标总额',
  b_tender_cmptamnt decimal(20,4) comment '竞争性招标总额',
  b_tender_underwriting decimal(20,4) comment '基本承销额度',
  b_tender_additiverights string comment '基本承销额增加权利',
  b_tender_addratio decimal(20,4) comment '基本承销额追加比例(%)',
  b_tender_threshold decimal(20,4) comment '投标价位下限',
  b_tender_ceiling decimal(20,4) comment '投标价位上限',
  b_tender_tenderunit decimal(20,4) comment '基本投标单位',
  b_tender_lowestamnt decimal(20,4) comment '每标位最低投标量',
  b_tender_highestamnt decimal(20,4) comment '每标位最高投标量',
  b_tender_paymentdate string comment '缴款日期',
  b_tender_confirmdate string comment '资金到账确认时间',
  b_tender_transferdate string comment '债券过户时间',
  b_tender_distribbegin string comment '分销起始日期',
  b_tender_distribend string comment '分销截止日期',
  b_tender_underwritingcost decimal(20,4) comment '承揽费率(%)',
  b_tender_spread string comment '标位步长',
  b_tender_concatenationornot bigint comment '是否要求标位连续',
  b_tender_time string comment '招标时间',
  b_tender_payment_enddate string comment '缴款截止日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



