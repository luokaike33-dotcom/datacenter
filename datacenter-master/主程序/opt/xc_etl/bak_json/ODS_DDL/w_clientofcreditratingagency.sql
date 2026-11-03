drop table if exists ty_ods.w_clientofcreditratingagency;
create table if not exists ty_ods.w_clientofcreditratingagency
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '评级机构ID',
  s_info_creditratingagency string comment '评级机构代码',
  client_compname string comment '公司(客户)名称',
  client_compcode string comment '公司(客户)ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



