drop table if exists ty_ods.w_asharemonthlyreportsofbrokers;
create table if not exists ty_ods.w_asharemonthlyreportsofbrokers
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  acc_sta_code bigint comment '原始报表采用会计准则代码',
  iflisted_data bigint comment '是否上市后数据',
  oper_rev decimal(20,4) comment '营业收入',
  net_profit_incl_min_int_inc decimal(20,4) comment '净利润(含少数股东权益)',
  net_profit_excl_min_int_inc decimal(20,4) comment '净利润(不含少数股东权益)',
  tot_shrhldr_eqy_excl_min_int decimal(20,4) comment '股东权益合计(不含少数股东权益)',
  tot_shrhldr_eqy_incl_min_int decimal(20,4) comment '股东权益合计(含少数股东权益)',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



