drop table if exists ty_ods.w_asharefreefloatcalendar;
create table if not exists ty_ods.w_asharefreefloatcalendar
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_listdate string comment '限售股上市日期',
  ann_dt string comment '公告日期',
  s_share_lst decimal(20,4) comment '上市股份数量（万股）',
  s_share_nonlst decimal(20,4) comment '未上市股份数量（万股）',
  s_share_unrestricted decimal(20,4) comment '无限售条件股份数量（万股）',
  s_share_lsttypecode bigint comment '上市股份类型代码',
  s_share_lst_is_ann string comment '上市数量是否公布值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



