drop table if exists ty_ods.w_asharecapitaloperation;
create table if not exists ty_ods.w_asharecapitaloperation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_capitaloperation_enddate string comment '截止日期',
  s_capitaloperation_share decimal(20,4) comment '股票数量',
  s_capitaloperation_amount decimal(20,4) comment '投资金额',
  crncy_code string comment '货币代码',
  s_capitaloperation_companyname string comment '参股公司名称',
  s_capitaloperat_compwindcode string comment '参股公司Wind代码',
  s_end_bal decimal(20,4) comment '期末账面值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



