drop table if exists ty_ods.w_asharecocapitaloperation;
create table if not exists ty_ods.w_asharecocapitaloperation
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_event_id string comment '事件ID',
  s_event_categorycode bigint comment '事件类型代码',
  ann_date string comment '公告日期',
  s_financing_amount decimal(20,4) comment '融资金额(人民币)',
  s_valuation_amount decimal(20,4) comment '估值金额(人民币)',
  s_pe decimal(20,4) comment '市盈率(PE)',
  s_pb decimal(20,4) comment '市净率(PB)',
  s_ps decimal(20,4) comment '市销率(PS)',
  s_financing_rate decimal(20,4) comment '融资费率',
  s_financing_rt decimal(20,4) comment '融资利率',
  s_financing_amount_us decimal(20,4) comment '融资金额(美元)',
  s_valuation_amount_us decimal(20,4) comment '估值金额(美元)',
  s_event_description string comment '事件说明',
  s_financing_process bigint comment '融资进程',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



