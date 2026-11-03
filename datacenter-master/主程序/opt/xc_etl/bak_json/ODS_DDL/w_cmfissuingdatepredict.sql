drop table if exists ty_ods.w_cmfissuingdatepredict;
create table if not exists ty_ods.w_cmfissuingdatepredict
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '基金ID',
  start_dt string comment '报告起始日',
  end_dt string comment '报告截止日',
  s_stm_actual_issuingdate string comment '实际披露日期',
  s_stm_correct_num string comment '更正公告披露次数',
  s_stm_correct_issuingdate string comment '更正公告披露日期',
  s_operation_review string comment '市场与基金运作回顾',
  s_rate_ratingoutlook string comment '市场展望',
  s_ratingoutlook string comment '市场展望(精简版)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



