drop table if exists ty_ods.w_hkshareholdersmeeting;
create table if not exists ty_ods.w_hkshareholdersmeeting
(
  object_id string comment '对象ID',
  s_info_compcode string comment '品种ID',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  votingcode bigint comment '投票通道代码',
  smtgrecdate string comment 'A股股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  is_intnet bigint comment '是否可以网络投票',
  meetevent_id string comment '会议事件ID',
  is_new bigint comment '最新标志',
  meeting_name string comment '会议名称',
  voting_type string comment '投票类型',
  is_notarization bigint comment '是否经公证',
  start_date string comment '过户起始日',
  end_date string comment '过户截止日',
  hshare_recorddate string comment 'H股股权登记日',
  meeting_place string comment '会议召开地点',
  meeting_content string comment '会议内容',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



