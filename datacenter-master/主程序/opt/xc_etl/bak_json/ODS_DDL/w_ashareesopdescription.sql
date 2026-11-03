drop table if exists ty_ods.w_ashareesopdescription;
create table if not exists ty_ods.w_ashareesopdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  bm_prepro_ann_dt string comment '董事会预案公告日',
  sholder_meeting_ann_dt string comment '股东大会公告日',
  initial_capital decimal(20,4) comment '初始资金规模（万元）',
  capital_resource_code bigint comment '资金来源代码',
  estimated_volumn decimal(20,4) comment '预计股票数量(万)',
  ratio_to_totalshares decimal(20,4) comment '预计占公司总股本比例(%)',
  sholders_no bigint comment '持有人数',
  sholders_proportion decimal(20,4) comment '持有人占公司员工比例',
  duration bigint comment '存续期(月)',
  lockup_period_m bigint comment '锁定期限',
  empl_subs_amt decimal(20,4) comment '员工认购金额(万)',
  empl_subs_proportion decimal(20,4) comment '员工认购比例(%)',
  senmngr_subs_no bigint comment '高管认购人数',
  senmngr_subs_amt decimal(20,4) comment '高管认购金额(万元)',
  senmngr_subs_proportion decimal(20,4) comment '高管认购比例（%）',
  estimated_price decimal(20,4) comment '标的股票预估价格',
  shares_resource_code bigint comment '股票来源代码',
  is_self_manage bigint comment '是否自行管理',
  corr_proname string comment '持股计划对应产品名称',
  ratio_ownfunds decimal(20,4) comment '员工自有资金占比',
  initial_leverage decimal(20,4) comment '初始杠杆',
  sholders_loan decimal(20,4) comment '股东借款金额',
  sholders_loanratio decimal(20,4) comment '股东借款比例',
  act_fundsize decimal(20,4) comment '实际资金规模',
  act_sharesno decimal(20,4) comment '实际股票数量',
  act_sharesprice decimal(20,4) comment '实际股票价格',
  act_cap_ratio decimal(20,4) comment '实际占公司总股本比例',
  sharehold_findt string comment '持股完成日',
  event_id string comment '事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



