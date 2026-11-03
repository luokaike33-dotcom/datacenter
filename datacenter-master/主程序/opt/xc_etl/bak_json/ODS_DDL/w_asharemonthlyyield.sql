drop table if exists ty_ods.w_asharemonthlyyield;
create table if not exists ty_ods.w_asharemonthlyyield
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '截至日期',
  crncy_code string comment '货币代码',
  s_mq_pctchange decimal(20,4) comment '月收益率(%)',
  s_mq_turn decimal(20,4) comment '月换手率(合计)(%)',
  s_mq_avgturn decimal(20,4) comment '月换手率(算术平均)(%)',
  s_mq_amount decimal(20,4) comment '月成交金额(万元)',
  s_risk_betar24 decimal(20,4) comment 'BETA(24月)',
  s_risk_betar60 decimal(20,4) comment 'BETA (60月)',
  s_mq_varpctchange24 decimal(20,4) comment '月收益率方差(24月)',
  s_mq_devpctchange24 decimal(20,4) comment '月收益率标准差(24月)',
  s_mq_avgpctchange24 decimal(20,4) comment '月收益率平均值(24月)',
  s_mq_varpctchange60 decimal(20,4) comment '月收益率方差(60月)',
  s_mq_devpctchange60 decimal(20,4) comment '月收益率标准差(60月)',
  s_mq_avgpctchange60 decimal(20,4) comment '月收益率平均值(60月)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



