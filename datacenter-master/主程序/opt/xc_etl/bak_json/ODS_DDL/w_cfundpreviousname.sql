drop table if exists ty_ods.w_cfundpreviousname;
create table if not exists ty_ods.w_cfundpreviousname
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  begindate string comment '起始日期',
  enddate string comment '截至日期',
  ann_dt string comment '公告日期',
  s_info_name string comment '证券简称',
  changereason bigint comment '变动原因代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国共同基金曾用名'
row format delimited fields terminated by '\t'
stored as orc;



