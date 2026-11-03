drop table if exists ty_ods.w_cbondnegativecreditevent;
create table if not exists ty_ods.w_cbondnegativecreditevent
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'wind代码',
  acu_date string comment '[内部]发生日期',
  event_type bigint comment '事件类型',
  s_info_compcode string comment '公司ID',
  subject_type bigint comment '主体类型代码',
  event_title string comment '事件标题 ',
  event_memo string comment '事件摘要 ',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



