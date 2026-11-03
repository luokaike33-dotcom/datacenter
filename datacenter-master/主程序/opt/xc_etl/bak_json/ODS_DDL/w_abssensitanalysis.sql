drop table if exists ty_ods.w_abssensitanalysis;
create table if not exists ty_ods.w_abssensitanalysis
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  anal_type string comment '敏感性分析类型',
  anal_ratio decimal(20,4) comment '早偿率/违约率',
  weigh_avg_term decimal(20,4) comment '加权平均期限',
  est_maturitydate string comment '预期到期日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



