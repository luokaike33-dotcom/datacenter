drop table if exists ty_ods.w_cdrstaffstructure;
create table if not exists ty_ods.w_cdrstaffstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '交易代码',
  staff_type_code bigint comment '人数类别代码',
  end_dt string comment '截止日期',
  report_type_code bigint comment '报告类型代码',
  item_type_code bigint comment '项目分类代码',
  item_name string comment '项目',
  item_code bigint comment '项目代码',
  staff_number bigint comment '人数',
  proportion decimal(20,4) comment '所占比例',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



