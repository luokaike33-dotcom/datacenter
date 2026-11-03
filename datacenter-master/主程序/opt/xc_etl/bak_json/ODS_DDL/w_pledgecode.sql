drop table if exists ty_ods.w_pledgecode;
create table if not exists ty_ods.w_pledgecode
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '业务类型代码',
  pledge_code string comment '质押券代码',
  pledge_name string comment '质押券名称',
  is_valid bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



