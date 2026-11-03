drop table if exists ty_ods.w_ashareholdersmeeting;
create table if not exists ty_ods.w_ashareholdersmeeting
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  votingcode bigint comment '投票通道代码',
  smtgrecdate string comment '股东大会股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  is_intnet string comment '是否可以网络投票',
  intnetcode string comment '网络投票代码',
  intnetname string comment '网络投票简称',
  meeting_content string comment '会议内容',
  change_his string comment '变更历史',
  meetevent_id string comment '会议事件ID',
  is_new bigint comment '最新标志',
  intnet_startdate string comment '互联网投票起始日',
  intnet_enddate string comment '互联网投票终止日',
  meeting_time string comment '会议召开时间',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国A股召开股东大会'
row format delimited fields terminated by '\t'
stored as orc;



