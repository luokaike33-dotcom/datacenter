drop table if exists ty_ods.w_ashareipoamount;
create table if not exists ty_ods.w_ashareipoamount
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_date string comment '变动日',
  ann_date string comment '公告日',
  s_ipo_osdexpoffamount decimal(20,4) comment '发行股份数',
  s_share_totalrestricted decimal(20,4) comment '限售股数',
  s_share_totaltradable decimal(20,4) comment '无限售股份数',
  s_share_be_listed decimal(20,4) comment '其中:待上市流通股数',
  s_share_ntrd_statjur decimal(20,4) comment '非流通股份数',
  s_share_changereason string comment '[内部]股本变动原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



