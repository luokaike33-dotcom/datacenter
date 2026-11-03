drop table if exists ty_ods.w_cfundeventdateinformation;
create table if not exists ty_ods.w_cfundeventdateinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_type bigint comment '事件类型编号',
  occurrence_date string comment '发生日期',
  disclosure_date string comment '披露日期',
  memo string comment '内容说明',
  date_created string comment '创建日期',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券简称',
  type_code string comment '证券类型代码',
  language1 string comment '语言',
  eqy_record_dt string comment '权益登记日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



