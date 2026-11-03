drop table if exists ty_ods.w_ashareincdescription;
create table if not exists ty_ods.w_ashareincdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_subject bigint comment '激励标的',
  s_inc_type bigint comment '激励方式',
  s_inc_quantity decimal(20,4) comment '激励总数(万股/万份)',
  s_inc_firstinc string comment '起始日',
  s_inc_endinc string comment '到期日',
  s_inc_initexecpri decimal(20,4) comment '期权初始行权价格(股票转让价格)',
  s_inc_expirydate decimal(20,4) comment '有效期',
  ann_dt string comment '公告日期',
  s_inc_programdescript string comment '方案说明',
  s_inc_incentsharesaledescript string comment '激励股票出售说明',
  s_inc_incentcondition string comment '激励授予条件',
  s_inc_optexespecialcondition string comment '期权行权特别条件',
  progress string comment '方案进度',
  price_description string comment '价格说明',
  inc_numbers_rate decimal(20,4) comment '激励数量占当前总股本比例(%)',
  preplan_ann_date string comment '预案公告日',
  gm_date string comment '股东大会公告日',
  implement_date string comment '首次实施公告日',
  inc_fund_description string comment '激励基金说明',
  interval_months decimal(20,4) comment '授权日与首次可行权日间隔时间(月)',
  eqinc_plan_event_id string comment '股权激励事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



