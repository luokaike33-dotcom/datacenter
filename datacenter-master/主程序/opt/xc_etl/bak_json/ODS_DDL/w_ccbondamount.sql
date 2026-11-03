drop table if exists ty_ods.w_ccbondamount;
create table if not exists ty_ods.w_ccbondamount
(
  object_id string comment '对象ID',
  s_info_changedate string comment '变动日期',
  ann_date string comment '公告日期',
  s_info_windcode string comment 'Wind代码',
  s_info_changereason string comment '变动原因代码',
  b_info_outstandingbalance decimal(15,2) comment '债券份额(万元)',
  turn_into_share decimal(20,4) comment '已转成股份数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



