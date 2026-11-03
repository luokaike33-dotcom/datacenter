drop table if exists ty_ods.w_asharestaff;
create table if not exists ty_ods.w_asharestaff
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司id',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  s_info_totalemployees decimal(20,4) comment '员工人数(人)',
  s_info_totalemployees2 bigint comment '母公司员工人数(人)',
  memo string comment '特殊情况说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



