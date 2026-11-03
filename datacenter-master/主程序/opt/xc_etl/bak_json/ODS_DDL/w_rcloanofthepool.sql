drop table if exists ty_ods.w_rcloanofthepool;
create table if not exists ty_ods.w_rcloanofthepool
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  ann_dt string comment '公告日期',
  start_dt string comment '收款期间起始日',
  end_dr string comment '收款期间截止日',
  rcloan_num decimal(24,4) comment '回收贷款笔数(笔)',
  rc decimal(24,8) comment '收入回收款(万元)',
  rcprincipal decimal(24,8) comment '本金回收款(万元)',
  rcinterest decimal(24,8) comment '利息回收款(万元)',
  rcpenalty decimal(24,8) comment '违约金回收款(万元)',
  rcother decimal(24,8) comment '其他回收款(万元)',
  payip_num decimal(24,4) comment '计划内还款笔数',
  payip decimal(24,8) comment '计划内还款本金(万元)',
  prepay_num decimal(24,4) comment '提前还款笔数',
  prepay decimal(24,8) comment '提前还款本金(万元)',
  arrears_rcnum decimal(24,4) comment '拖欠回收笔数',
  arrears_rc decimal(24,8) comment '拖欠回收本金(万元)',
  default_rcnum decimal(24,4) comment '违约回收笔数',
  default_rc decimal(24,8) comment '违约回收本金(万元)',
  taxes decimal(24,8) comment '税费支出(万元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



