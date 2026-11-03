drop table if exists ty_ods.w_ashareanninf;
create table if not exists ty_ods.w_ashareanninf
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  n_info_stockid string comment '证券ID',
  n_info_companyid string comment '公司ID',
  ann_dt timestamp comment '公告日期',
  n_info_title string comment '标题',
  n_info_fcode string comment '栏目代码',
  n_info_ftxt string comment '摘要',
  n_info_annlink string comment '公告链接',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



