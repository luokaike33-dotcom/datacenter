drop table if exists ty_ods.w_scfreturndistribution;
create table if not exists ty_ods.w_scfreturndistribution
(
  object_id string comment '对象ID',
  s_info_windcode string comment '母基金Wind代码',
  f_info_feeder_windcode string comment '子基金Wind代码',
  rule_staretdt string comment '收益分配条约起始日期',
  rule_enddt string comment '收益分配条约截止日期',
  pri_benchreturn decimal(20,4) comment '优先份额基准收益率(%)',
  type_code bigint comment '优先份额基准收益率获取方式代码',
  returndist_code bigint comment '子基金收益方式代码',
  exreturn_share decimal(20,4) comment '子基金超额收益分成占比(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



