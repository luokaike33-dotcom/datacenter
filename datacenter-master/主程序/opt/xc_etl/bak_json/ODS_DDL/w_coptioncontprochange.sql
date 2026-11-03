drop table if exists ty_ods.w_coptioncontprochange;
create table if not exists ty_ods.w_coptioncontprochange
(
  object_id string comment '对象ID',
  contract_id string comment '合约代码',
  item string comment '变更字段名称',
  change_dt string comment '变更日期',
  s_info_old string comment '变更前',
  s_info_new string comment '变更后',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



