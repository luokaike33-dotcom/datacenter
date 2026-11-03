drop table if exists ty_ods.w_asharemarginsubject;
create table if not exists ty_ods.w_asharemarginsubject
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_margin_sharetype bigint comment '融资融券相关证券类型代码',
  s_margin_effectdate string comment '生效日',
  s_margin_elimindate string comment '剔除日',
  s_margin_marginrate decimal(20,4) comment '保证金比例',
  s_margin_conversionrate decimal(20,4) comment '折算率',
  s_margin_rateeffectdate string comment '保证金比例或折算率生效日',
  s_is_new bigint comment '是否最新',
  s_margin_expirationdate string comment '保证金比例或折算率失效日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



