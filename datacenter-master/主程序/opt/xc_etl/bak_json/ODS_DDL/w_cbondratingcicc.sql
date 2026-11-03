drop table if exists ty_ods.w_cbondratingcicc;
create table if not exists ty_ods.w_cbondratingcicc
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '评级日期',
  analyst string comment '分析师',
  b_info_rating string comment '公布评级',
  s_info_name string comment '公布证券简称',
  b_info_ratingagency string comment '机构',
  starlevel bigint comment '星级',
  memo string comment '评级内容摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



