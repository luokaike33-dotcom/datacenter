drop table if exists ty_ods.w_cmfholdingratioanomaly;
create table if not exists ty_ods.w_cmfholdingratioanomaly
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  f_unit_rpstartdate string comment '报告期开始日期',
  f_unit_rpenddate string comment '报告期截止日期',
  trade_dt string comment '公告日期',
  f_inquirer_type string comment '投资者类别',
  f_inquirer_type_num bigint comment '投资者序号',
  f_holding_time string comment '持有时间区间',
  f_start_num_holder decimal(20,4) comment '期初持有份额',
  f_unit_pch decimal(20,4) comment '申购份额',
  f_unit_redm decimal(20,4) comment '赎回份额',
  f_end_num_holder decimal(20,4) comment '期末持有份额',
  f_end_num_holder_proportion decimal(20,4) comment '期末持有份额占基金份额比例',
  is_merge bigint comment '是否为合并数据',
  f_inquirer_typecode string comment '投资者类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



