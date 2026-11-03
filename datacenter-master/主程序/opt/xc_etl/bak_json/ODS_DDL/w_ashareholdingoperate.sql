drop table if exists ty_ods.w_ashareholdingoperate;
create table if not exists ty_ods.w_ashareholdingoperate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_tot_assets decimal(24,8) comment '资产规模',
  s_net_profit decimal(24,8) comment '净利润',
  crncy_code string comment '货币代码',
  s_net_assets decimal(24,8) comment '净资产',
  s_tot_liab decimal(24,8) comment '负债总额',
  s_oper_rev decimal(24,8) comment '营业收入',
  s_tot_profit decimal(24,8) comment '利润总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



