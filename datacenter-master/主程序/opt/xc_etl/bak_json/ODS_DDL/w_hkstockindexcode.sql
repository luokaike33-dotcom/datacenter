drop table if exists ty_ods.w_hkstockindexcode;
create table if not exists ty_ods.w_hkstockindexcode
(
  object_id string comment '对象ID',
  s_info_indexwindcode string,
  s_info_name string comment '指数简称',
  s_info_industrycode string comment '板块代码',
  s_info_industryname string comment '板块名称',
  mk string comment '交易所',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



