drop table if exists ty_ods.w_neeqreginv;
create table if not exists ty_ods.w_neeqreginv
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  s_info_windcode string comment 'Wind代码',
  sur_institute string comment '调查机构',
  sur_reasons string comment '调查原因',
  str_anndate string comment '开始公告日期',
  end_anndate string comment '结束公告日期',
  str_date string comment '开始日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



