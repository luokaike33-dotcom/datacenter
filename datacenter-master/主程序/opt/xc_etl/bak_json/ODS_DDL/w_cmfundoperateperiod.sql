drop table if exists ty_ods.w_cmfundoperateperiod;
create table if not exists ty_ods.w_cmfundoperateperiod
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  opr_period bigint comment '期数',
  pch_startdt string comment '开放申购起始日',
  pch_enddt string comment '开放申购截止日',
  opr_startdt string comment '运作起始日',
  opr_enddt string comment '运作结束日',
  redm_startdt string comment '开放赎回起始日',
  redm_enddt string comment '开放赎回截止日',
  anticipate_annualyeild decimal(20,4) comment '预期年化收益率',
  annualyeild decimal(20,4) comment '实际年化收益率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



