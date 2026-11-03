drop table if exists ty_ods.w_asharefundusing;
create table if not exists ty_ods.w_asharefundusing
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  financing_events_type string comment '融资事件类型',
  money_raised_amount decimal(20,4) comment '货币募集金额',
  non_currency_raise_amount decimal(20,4) comment '非货币募集金额',
  issue_cost decimal(20,4) comment '发行费用',
  actual_fundraising_amount decimal(20,4) comment '实际募资金额',
  currency_code string comment '货币代码',
  ann_date string comment '公告日期',
  item_number string comment '项目序号',
  investment_projects string comment '投资项目',
  plan_invest decimal(20,4) comment '项目总计划投入资金',
  issuer_plan_invest decimal(20,4) comment '募资主体计划投入资金',
  issuer_plan_funds_investment decimal(20,4) comment '募资主体计划投入募集资金',
  funds_has_invested decimal(20,4) comment '已投入募集资金',
  is_change bigint comment '是否变更',
  new_ann_date string comment '最新公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



