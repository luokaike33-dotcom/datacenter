drop table if exists ty_ods.w_cfundadmpermitschedule;
create table if not exists ty_ods.w_cfundadmpermitschedule
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  anndate string comment '公告日期',
  enddate string comment '截止日期',
  type_name string comment '申请事项',
  type_code bigint comment '审核类型代码',
  apply_pickup_date string comment '申请材料接收日',
  notice_correction_date string comment '通知补正日',
  receive_correction_material string comment '接收补正材料日',
  admissibility_date string comment '受理决定日',
  no_admissibility_date string comment '不予受理决定日',
  feedback_date1 string comment '第一次反馈意见日',
  receive_feedback_date1 string comment '接收第一次反馈材料日',
  feedback_date2 string comment '第二次反馈意见日',
  receive_feedback_date2 string comment '接收第二次反馈材料日',
  review_date string comment '审查决定日',
  memo string comment '说明',
  comp_name string comment '[内部]申请人名称',
  progress_code bigint comment '审核进度代码',
  ann_date_ndrc string comment '审结日期',
  audit_event_id string comment '审核事件ID',
  audit_channel_code bigint comment '审核通道代码',
  feedback_date string comment '反馈回复日期',
  other_comp_id string comment '其他公司ID',
  other_comp_type_code bigint comment '其他公司类型代码',
  sec_code string comment '[内部]审批产品证券ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



