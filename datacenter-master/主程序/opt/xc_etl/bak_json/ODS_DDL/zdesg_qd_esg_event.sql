drop table if exists ty_ods.zdesg_qd_esg_event;
create table if not exists ty_ods.zdesg_qd_esg_event
(
  object_id string comment '事件唯一ID',
  insert_time timestamp comment '记录创建时间',
  update_time timestamp comment '记录更新时间',
  ticker string comment '上市公司代码',
  bond string comment '债券统计信息',
  short_name string comment '上市公司简称',
  full_name string comment '事件关联公司的中文全称',
  oaid string comment '事件关联公司的oaid',
  shareholding_level bigint comment '股权关联度',
  gics_code string comment 'GICS行业代码',
  national_economic_code string comment '国民经济行业代码',
  source_name string comment '披露方名称',
  source_oaid string comment '披露方oaid',
  source_type string comment '披露来源类型',
  url string comment '披露页面网址',
  publish_date string comment '事件披露日期',
  happen_date string comment '事件发生日期',
  subject_detailed_name string comment '事件发生主体详细名称',
  subject_name string comment '事件发生主体公司名称',
  subject_oaid string comment '事件发生主体公司的oaid',
  country string comment '事件发生地点所在国家或地区3位代码',
  province string comment '事件发生地点所在省份名称',
  district string comment '事件发生地点所在城市名称',
  county string comment '事件发生地点所在区县名称',
  region_code string comment '事件发生地点所在行政区划代码',
  event_type string comment '事件类型',
  sub_type string comment '事件子类型',
  impact_level bigint comment '事件影响程度',
  sentiment bigint comment '事件情绪',
  fine decimal(38,2) comment '事件金额',
  currency string comment '事件金额币种',
  title string comment '事件标题',
  body string comment '事件正文',
  content string comment '事件详细内容',
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



