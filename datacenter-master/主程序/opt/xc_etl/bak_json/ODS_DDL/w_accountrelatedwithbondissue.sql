drop table if exists ty_ods.w_accountrelatedwithbondissue;
create table if not exists ty_ods.w_accountrelatedwithbondissue
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '发行类型代码',
  account_num string comment '账号',
  account_title string comment '账户名称',
  bank_name string comment '开户行名称',
  bank_num string comment '清算行行号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



