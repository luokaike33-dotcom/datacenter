drop table if exists ty_ods.w_asharerdexpenditure;
create table if not exists ty_ods.w_asharerdexpenditure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



