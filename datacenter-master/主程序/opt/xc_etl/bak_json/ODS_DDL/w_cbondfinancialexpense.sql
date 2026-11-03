drop table if exists ty_ods.w_cbondfinancialexpense;
create table if not exists ty_ods.w_cbondfinancialexpense
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  s_info_compname string comment '公司名称',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  s_stmnote_intexp decimal(20,4) comment '利息支出',
  s_stmnote_intinc decimal(20,4) comment '减：利息收入',
  s_stmnote_exch decimal(20,4) comment '汇兑损益',
  s_stmnote_fee decimal(20,4) comment '手续费',
  s_stmnote_others decimal(20,4) comment '其他',
  s_stmnote_finexp decimal(20,4) comment '合计',
  s_stmnote_finexp_1 decimal(20,4) comment '利息资本化金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



