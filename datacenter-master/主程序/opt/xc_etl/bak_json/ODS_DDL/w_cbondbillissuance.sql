drop table if exists ty_ods.w_cbondbillissuance;
create table if not exists ty_ods.w_cbondbillissuance
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  bill_name string comment '票据名称',
  issue_ann_date string comment '发行公告日期',
  list_ann_date string comment '上市公告日期',
  issue_date string comment '发行日期',
  list_date string comment '上市日期',
  ptotal_num_issues decimal(20,4) comment '计划发行总量(万元)',
  total_num_issues decimal(20,4) comment '实际发行总量(万元)',
  issue_type string comment '发行方式',
  s_info_par decimal(20,4) comment '面额',
  term decimal(20,4) comment '期限(月)',
  paymentdate string comment '缴款日',
  carry_date string comment '起息日',
  maturity_date string comment '到期日',
  tender_method string comment '招标方式',
  issue_price decimal(20,4) comment '发行价格',
  tendrst_referyield decimal(20,4) comment '利率/参考收益率（%）',
  issue_gobject string comment '发行对象',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



