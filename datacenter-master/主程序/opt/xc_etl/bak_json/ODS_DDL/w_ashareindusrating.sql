drop table if exists ty_ods.w_ashareindusrating;
create table if not exists ty_ods.w_ashareindusrating
(
  object_id string comment '对象ID',
  wind_ind_code string comment 'Wind行业ID',
  rating_institute string comment '机构',
  rating_institute_id string comment '[内部]机构id',
  rating_analyst string comment '分析师',
  rating_analyst_id string comment '[内部]分析师id',
  report_type_code bigint comment '报告类型代码',
  rating_dt string comment '评级日期',
  end_dt string comment '有效期截止日',
  rating_memo string comment '[内部]摘要',
  score bigint comment '得分',
  rating string comment '新评级',
  report_ind string comment '原始行业',
  collect_dt string comment '[内部]公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



