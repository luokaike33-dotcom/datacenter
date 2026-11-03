drop table if exists ty_ods.w_hkanalystrating;
create table if not exists ty_ods.w_hkanalystrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  institution string comment '机构',
  analyst string comment '分析师',
  est_date string comment '评级日期',
  expirydate string comment '有效期截止日',
  low_trgt_prc decimal(10,4) comment '最低目标价位',
  high_trgt_prc decimal(10,4) comment '最高目标价位',
  score bigint comment '得分',
  rating string comment '新评级',
  reportid string comment '报告ID',
  r_report_type string comment '研究报告类型代码',
  ann_date string comment '[内部]公告日期',
  prerating string comment '前次评级',
  prescore bigint comment '前次标准评级',
  chg_drctn_code bigint comment '评级变动方向代码',
  pre_low_trgt_prc decimal(20,4) comment '前次最低目标价位',
  pre_high_trgt_prc decimal(20,4) comment '前次最高目标价位',
  crncy_code string comment '目标价货币代码',
  changerate decimal(20,4) comment '目标价变动比率',
  description string comment '目标价估值说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



