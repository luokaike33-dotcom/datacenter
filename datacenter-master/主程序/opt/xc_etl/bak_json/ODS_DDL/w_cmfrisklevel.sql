drop table if exists ty_ods.w_cmfrisklevel;
create table if not exists ty_ods.w_cmfrisklevel
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  risk_level string comment '基金风险等级',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



