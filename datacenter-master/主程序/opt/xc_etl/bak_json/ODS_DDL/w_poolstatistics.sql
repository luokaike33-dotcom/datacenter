drop table if exists ty_ods.w_poolstatistics;
create table if not exists ty_ods.w_poolstatistics
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  ann_dt string comment '公告日期',
  start_dt string comment '收款期间起始日',
  end_dr string comment '收款期间截止日',
  laon_balance decimal(24,8) comment '贷款余额(万元)',
  laon_num decimal(24,4) comment '贷款笔数',
  wa_loanrate decimal(24,4) comment '加权平均贷款利率',
  wa_remtm decimal(24,4) comment '加权平均贷款剩余期限（年）',
  credit_num decimal(24,4) comment '信用贷款笔数',
  guarantee_num decimal(24,4) comment '保证担保贷款笔数',
  credit_pct decimal(24,4) comment '信用贷款金额占比',
  guarantee_pct decimal(24,4) comment '保证担保贷款金额占比',
  defaut_value decimal(24,8) comment '累计违约金额（万元）',
  default_backvalue decimal(24,8) comment '累计回收违约本金（万元）',
  default_rate decimal(24,4) comment '累计违约率',
  arrears_rate decimal(24,4) comment '严重拖欠率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



