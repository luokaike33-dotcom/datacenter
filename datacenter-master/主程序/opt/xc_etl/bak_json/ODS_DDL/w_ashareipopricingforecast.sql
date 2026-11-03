drop table if exists ty_ods.w_ashareipopricingforecast;
create table if not exists ty_ods.w_ashareipopricingforecast
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  research_inst_name string comment '机构名称',
  research_inst_id string comment '机构ID',
  research_inst_id2 string comment '机构编码',
  analyst_name string comment '分析师名称',
  analyst_id string comment '作者ID',
  est_dt string comment '预测日期',
  collect_time string comment '[内部]公告日期',
  first_optime timestamp comment '[内部]发布日期',
  price_floor decimal(20,4) comment '定价区间下限',
  price_ceiling decimal(20,4) comment '定价区间上限',
  inquiry_price_floor decimal(20,4) comment '询价建议区间下限',
  inquiry_price_ceiling decimal(20,4) comment '询价建议区间上限',
  est_memo string comment '预测摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



