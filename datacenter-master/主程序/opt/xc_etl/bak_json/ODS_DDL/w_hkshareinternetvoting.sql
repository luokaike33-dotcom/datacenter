drop table if exists ty_ods.w_hkshareinternetvoting;
create table if not exists ty_ods.w_hkshareinternetvoting
(
  object_id string comment '对象ID',
  s_event_id string comment '会议事件ID',
  s_event_num string comment '议案序号',
  s_event_name string comment '议案名称',
  s_info_type string comment '表决方式类型',
  s_info_price decimal(20,4) comment '申报价格',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



