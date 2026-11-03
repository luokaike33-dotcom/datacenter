drop table if exists ty_ods.w_cmoneymarketdailyfincome;
create table if not exists ty_ods.w_cmoneymarketdailyfincome
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_info_bgndate string comment '起始日期',
  f_info_enddate string comment '截止日期',
  f_info_unityield decimal(20,4) comment '单位净值',
  f_accunitnav decimal(20,4) comment '累计单位净值',
  f_income_per_million decimal(20,5) comment '万份收益',
  f_info_yearlyroe decimal(20,4) comment '七日年化收益率',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



