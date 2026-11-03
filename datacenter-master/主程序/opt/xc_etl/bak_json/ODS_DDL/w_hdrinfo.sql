drop table if exists ty_ods.w_hdrinfo;
create table if not exists ty_ods.w_hdrinfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  end_date string comment '截止日期',
  issued_shares decimal(20,4) comment '基础证券股份数(万股)',
  share_code string comment '基础证券id',
  hdr_stand_for_shares decimal(20,4) comment 'R:O比率',
  issued_hdrs decimal(20,4) comment '已发行凭证份额数(万份)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



