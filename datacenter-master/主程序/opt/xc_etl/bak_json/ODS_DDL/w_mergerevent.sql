drop table if exists ty_ods.w_mergerevent;
create table if not exists ty_ods.w_mergerevent
(
  object_id string comment '对象ID',
  event_id string comment '并购事件ID',
  ann_date string comment '首次披露日期',
  update_date string comment '最新披露日期',
  event_title string comment '并购事件标题',
  underlying string comment '交易标的',
  underlying_type_code bigint comment '标的类型代码',
  is_related_party_transac bigint comment '是否为关联交易',
  is_majorassetrestructure bigint comment '是否重大资产重组',
  is_control_change bigint comment '控制权是否变更',
  restructure_way_code bigint comment '重组形式代码',
  restructure_type_code bigint comment '重组类型代码',
  merger_type_code bigint comment '并购类型代码',
  merger_way_code bigint comment '并购方式代码',
  is_be_approval bigint comment '是否已完成审批',
  progress_code bigint comment '交易方案进度代码',
  trade_value decimal(20,4) comment '交易总价值(万元)',
  crncy_code string comment '货币代码',
  pricing_basis_code bigint comment '定价依据代码',
  evalue_method_code bigint comment '评估方法代码',
  evalue_way_code bigint comment '选用评估方法代码',
  payment_way_code bigint comment '支付方式代码',
  cash_payment decimal(20,4) comment '买方支付现金(万元)',
  evalue_value decimal(20,4) comment '评估价值',
  evalue_basis_date_ string comment '资产评估基准日',
  transfer_numbers decimal(20,4) comment '转让股数(万股)',
  transfer_price decimal(20,4) comment '转让单价',
  stockright_proportion decimal(20,4) comment '交易股权占比(%)',
  appreciation_rate decimal(20,4) comment '增值率',
  merger_aim_code bigint comment '并购目的类型代码',
  location_type_code bigint comment '并购地区类型代码',
  ecd string comment '交易预计完成日期',
  completion_date string comment '交易完成日期',
  chronicle string comment '并购大事记',
  relevantintelligence_id string comment '关联情报ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



