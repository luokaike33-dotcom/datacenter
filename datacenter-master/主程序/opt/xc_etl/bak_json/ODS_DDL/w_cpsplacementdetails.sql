drop table if exists ty_ods.w_cpsplacementdetails;
create table if not exists ty_ods.w_cpsplacementdetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_holder_name string comment '[内部]获配公司名称',
  s_info_compcode string comment '法人投资者ID',
  typeofinvestor string comment '法人投资者类型',
  placement decimal(20,4) comment '获配数量(万股/万张)',
  trade_dt string comment '配售截止日期',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



