drop table if exists ty_ods.w_hksharechangename;
create table if not exists ty_ods.w_hksharechangename
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  ann_dt string comment '公告日期',
  change_dt string comment '变动日期',
  s_info_name string comment '证券名称',
  s_info_name_eng string comment '证券英文名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



