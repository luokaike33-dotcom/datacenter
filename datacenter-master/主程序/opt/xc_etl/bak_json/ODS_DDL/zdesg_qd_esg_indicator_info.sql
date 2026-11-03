drop table if exists ty_ods.zdesg_qd_esg_indicator_info;
create table if not exists ty_ods.zdesg_qd_esg_indicator_info
(
  indicator string comment '指标名称。为方便阅读，显示大小写',
  name string comment '指标中文名称',
  name_en string comment '指标英文名称',
  data_type string comment '指标类型，包括数值/整数/文本/布尔等',
  unit string comment '单位',
  unit_en string comment '英文单位',
  frequency string comment '指标的发布频率，包括年度和月度',
  frequency_en string comment '指标的发布频率英文，包括Yearly和Monthly',
  dimension1 string comment '一级维度',
  dimension1_en string comment '二级维度英文，方便后续计算引用',
  dimension2 string comment '二级维度',
  dimension2_en string comment '二级维度英文，方便后续计算引用',
  rating string comment '是否为评价模型字段',
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



