drop table if exists ty_ods.w_cgoldspotdescription;
create table if not exists ty_ods.w_cgoldspotdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券中文简称',
  s_info_exchmarket string comment '交易所',
  s_info_punit string comment '交易单位',
  s_info_margin string comment '交易保证金',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



