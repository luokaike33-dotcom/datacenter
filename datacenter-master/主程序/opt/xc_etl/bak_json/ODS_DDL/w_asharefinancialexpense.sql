drop table if exists ty_ods.w_asharefinancialexpense;
create table if not exists ty_ods.w_asharefinancialexpense
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  s_stmnote_intexp decimal(20,4) comment '利息支出(元)',
  s_stmnote_intinc decimal(20,4) comment '减：利息收入(元)',
  s_stmnote_exch decimal(20,4) comment '汇兑损益(元)',
  s_stmnote_fee decimal(20,4) comment '手续费(元)',
  s_stmnote_others decimal(20,4) comment '其他(元)',
  s_stmnote_finexp decimal(20,4) comment '合计(元)',
  s_stmnote_finexp_1 decimal(20,4) comment '减：利息资本化金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



