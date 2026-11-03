drop table if exists ty_ods.w_asharestibinvestmentiending;
create table if not exists ty_ods.w_asharestibinvestmentiending
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_dt string comment '交易日期',
  s_share_totalrestricted decimal(20,4) comment '限售股(万股)',
  s_share_float decimal(20,4) comment '非限售股(万股)',
  s_share_lending decimal(20,4) comment '可出借股份(万股)',
  s_share_lending_margin decimal(20,4) comment '出借余量(万股)',
  s_share_change decimal(20,4) comment '当日出借变动股份(万股)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



