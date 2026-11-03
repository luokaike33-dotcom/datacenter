drop table if exists ty_ods.w_ashareweeklyyield;
create table if not exists ty_ods.w_ashareweeklyyield
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '截至日期',
  crncy_code string comment '货币代码',
  s_wq_pctchange decimal(20,4) comment '周收益率(%)',
  s_wq_turn decimal(20,4) comment '周换手率(合计)(%)',
  s_wq_avgturn decimal(20,4) comment '周换手率(算术平均)(%)',
  s_wq_amount decimal(20,4) comment '周成交金额(万元)',
  s_risk_betar100 decimal(20,4) comment 'BETA (100周)',
  s_wq_varpctchange100 decimal(20,4) comment '周收益率方差(100周)',
  s_wq_devpctchange100 decimal(20,4) comment '周收益率标准差(100周)',
  s_wq_avgpctchange100 decimal(20,4) comment '周收益率平均值(100周)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



