drop table if exists ty_ods.w_mergerintelligence;
create table if not exists ty_ods.w_mergerintelligence
(
  object_id string comment '对象ID',
  intelligence_id string comment '情报ID',
  title string comment '标题',
  ann_date string comment '发布日期',
  involved_amount string comment '涉及金额',
  subject_typecode bigint comment '主题分类代码',
  wind_ind_code string comment '所属Wind行业代码',
  level_code bigint comment '情报等级代码',
  key_words string comment '情报关键字',
  data_source string comment '来源名称',
  involved_equity string comment '涉及股权',
  content string comment '正文内容',
  event_id string comment '交易事件ID',
  progress_code bigint comment '事件进度代码',
  receipt_date timestamp comment '收录时间',
  is_important bigint comment '是否重要',
  effective_date string comment '生效日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



