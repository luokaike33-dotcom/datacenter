drop table if exists ty_ods.w_ashareprovisionbaddebts;
create table if not exists ty_ods.w_ashareprovisionbaddebts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '帐龄',
  extraction_ratio decimal(20,4) comment '提取比例',
  min_aging decimal(20,4) comment '最小帐龄',
  max_aging decimal(20,4) comment '最大帐龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



