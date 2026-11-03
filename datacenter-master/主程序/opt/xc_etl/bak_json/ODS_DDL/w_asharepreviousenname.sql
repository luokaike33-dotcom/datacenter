drop table if exists ty_ods.w_asharepreviousenname;
create table if not exists ty_ods.w_asharepreviousenname
(
  object_id string comment '对象ID ',
  s_info_windcode string comment 'Wind代码 ',
  sec_id string comment '证券id ',
  change_dt string comment '变动日期 ',
  s_info_ename string comment '英文简称 ',
  cur_sign bigint comment '是否最新 ',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



