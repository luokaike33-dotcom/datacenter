drop table if exists ty_ods.w_asharestockrating;
create table if not exists ty_ods.w_asharestockrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_est_institute string comment '研究机构名称',
  s_est_ratinganalyst string comment '分析师名称',
  s_est_estnewtime_inst string comment '评级日期',
  s_est_scorerating_inst decimal(20,4) comment '本次标准评级',
  s_est_prescorerating_inst decimal(20,4) comment '前次标准评级',
  s_est_lowprice_inst decimal(20,4) comment '本次最低目标价',
  s_est_highprice_inst decimal(20,4) comment '本次最高目标价',
  s_est_prelowprice_inst decimal(20,4) comment '前次最低目标价',
  s_est_prehighprice_inst decimal(20,4) comment '前次最高目标价',
  ann_dt string comment '公告日期(内部)',
  s_est_rating_inst string comment '本次评级',
  s_est_prerating_inst string comment '前次评级',
  s_est_report_title string comment '报告标题',
  s_est_report_type bigint comment '报告类别',
  s_est_ratinganalystid string comment '分析师id',
  s_rating_change bigint comment '评级变动方向',
  s_rating_validenddt string comment '评级有效截止日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



