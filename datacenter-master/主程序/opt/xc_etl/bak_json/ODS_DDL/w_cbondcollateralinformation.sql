drop table if exists ty_ods.w_cbondcollateralinformation;
create table if not exists ty_ods.w_cbondcollateralinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'wind代码',
  b_agency_grnttypecode bigint comment '担保方式代码',
  b_agency_collateraltypecode bigint comment '担保物类型代码',
  eqy_targetcomp string comment '股权标的',
  b_guaranteeowner string comment '担保物所有方',
  b_guaranteeowner_compcode string comment '担保物所有方公司ID',
  b_info_collateralnumber bigint comment '担保物数量',
  b_info_collateralpunit string comment '担保物单位',
  b_info_collateralvalue bigint comment '担保物价值',
  crncy_code string comment '货币代码',
  b_info_guarintroduction string comment '担保情况',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



