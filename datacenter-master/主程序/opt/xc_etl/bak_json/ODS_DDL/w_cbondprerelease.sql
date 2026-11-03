drop table if exists ty_ods.w_cbondprerelease;
create table if not exists ty_ods.w_cbondprerelease
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  pre_release_code string comment '预发行代码',
  pre_release_name string comment '预发行简称',
  pre_release_begindate string comment '预发行交易起始日',
  pre_release_enddate string comment '预发行交易截止日',
  s_base_info decimal(24,8) comment '基准价格/收益率',
  b_anal_rduration decimal(24,8) comment '参考久期',
  price_type_code bigint comment '价格类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



