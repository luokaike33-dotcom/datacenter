drop table if exists ty_ods.w_ashareissuingdatepredict;
create table if not exists ty_ods.w_ashareissuingdatepredict
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_stm_predict_issuingdate string comment '预计披露日期(最新)',
  s_stm_actual_issuingdate string comment '实际披露日期',
  s_stm_correct_num string comment '更正公告披露次数',
  s_stm_correct_issuingdate string comment '更正公告披露日期',
  ann_dt string comment '预计披露日期公告日(最新)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



