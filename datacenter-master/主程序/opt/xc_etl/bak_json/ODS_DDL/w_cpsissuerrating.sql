drop table if exists ty_ods.w_cpsissuerrating;
create table if not exists ty_ods.w_cpsissuerrating
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司中文名称',
  ann_dt string comment '公告日期',
  s_rate_style string comment '评级类型',
  s_info_creditrating string comment '信用评级',
  s_rate_ratingoutlook bigint comment '评级展望',
  s_info_creditratingagency string comment '评级机构代码',
  s_info_compcode string comment '公司id',
  s_info_creditratingexplain string comment '信用评级说明',
  s_info_precreditrating string comment '前次信用评级',
  s_creditrating_change string comment '评级变动方向',
  s_info_issuerratetype bigint comment '评级对象类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



