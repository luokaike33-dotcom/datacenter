drop table if exists ty_ods.w_cbankdepositstructure;
create table if not exists ty_ods.w_cbankdepositstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  crncy_code string comment '货币代码',
  crncy_type_code bigint comment '币种类型代码',
  loan_type_code bigint comment '项目类别代码',
  deposit_item_code bigint comment '存款项目代码',
  ann_item string comment '存款项目公布名称',
  total_deposit decimal(20,4) comment '存款余额',
  ave_deposit decimal(20,4) comment '存款平均余额',
  interest_cost decimal(20,4) comment '存款利息支出',
  average_yield decimal(20,4) comment '存款平均成本率',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



