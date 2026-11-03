drop table if exists ty_ods.w_asharestockswap;
create table if not exists ty_ods.w_asharestockswap
(
  object_id string comment '对象ID',
  transferer_windcode string comment '换股方万得代码',
  transferer_name string comment '换股方简称',
  progress string comment '方案进度',
  targetcomp_windcode string comment '标的方万得代码',
  targetcomp_name string comment '标的方简称',
  transferer_conversionprice decimal(20,4) comment '换股方换股价',
  targetcomp_conversionprice decimal(20,4) comment '标的方换股价',
  conversionratio decimal(20,8) comment '换股比例',
  is_cashoption bigint comment '是否有现金选择权',
  cashoption decimal(20,4) comment '现金选择权',
  cashoption_reportstartdate string comment '现金选择权申报起始日',
  cashoption_reportenddate string comment '现金选择权申报截止日',
  cashoption_applicationcode string comment '现金选择权申请代码',
  cashoption_sharepurchaser string comment '现金选择权股份购买方',
  cashoption_applicantname string comment '现金选择权适用方简称',
  is_overalllisting bigint comment '是否属于整体上市',
  prelandate string comment '预案公告日',
  mtstartdate string comment '股东大会召开日',
  smtgrecdate string comment '股东大会股权登记日',
  smtganncedate string comment '股东大会公告日',
  iecannouncementdate string comment '证监会发审委公告日',
  anncedate string comment '实施公告日',
  anncelstdate string comment '上市公告日',
  ann_dt string comment '最新公告日',
  traderesumptiondate string comment '预案公布后复牌日',
  lasttradedate string comment '实施前最后交易日',
  equityregistrationdate string comment '换股股权登记日',
  listdate string comment '上市日',
  consolidationbasedate string comment '合并基准日',
  financialadvisor string comment '财务顾问',
  plandescription string comment '方案说明',
  casharrivaldate string comment '现金选择权现金到账日',
  effectivereportedshares decimal(20,4) comment '现金选择权有效申报股数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



