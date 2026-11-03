drop table if exists ty_ods.w_ashareprofitnotice;
create table if not exists ty_ods.w_ashareprofitnotice
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_profitnotice_date string comment '公告日期',
  s_profitnotice_period string comment '报告期',
  s_profitnotice_style bigint comment '业绩预告类型代码',
  s_profitnotice_signchange string comment '是否变脸',
  s_profitnotice_changemin decimal(20,4) comment '预告净利润变动幅度下限（%）',
  s_profitnotice_changemax decimal(20,4) comment '预告净利润变动幅度上限（%）',
  s_profitnotice_netprofitmin decimal(20,4) comment '预告净利润下限（万元）',
  s_profitnotice_netprofitmax decimal(20,4) comment '预告净利润上限（万元）',
  s_profitnotice_number decimal(15,4) comment '公布次数',
  s_profitnotice_firstanndate string comment '首次公告日',
  s_profitnotice_abstract string comment '业绩预告摘要',
  s_profitnotice_reason string comment '业绩变动原因',
  s_profitnotice_net_parent_firm decimal(20,4) comment '上年同期归母净利润',
  s_info_compcode string comment '公司ID',
  s_profitnotice_changemin_ded decimal(20,4) comment '预告扣非净利润变动幅度下限',
  s_profitnotice_changemax_ded decimal(20,4) comment '预告扣非净利润变动幅度上限',
  s_profitnotice_ni_min_ded decimal(20,8) comment '预告扣非净利润下限',
  s_profitnotice_ni_max_ded decimal(20,8) comment '预告扣非净利润上限',
  s_profitnotice_netprofit_ded decimal(20,8) comment '上年同期扣非净利润',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



