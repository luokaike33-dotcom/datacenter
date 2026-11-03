drop table if exists ty_ods.w_neeqeequitypledge;
create table if not exists ty_ods.w_neeqeequitypledge
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  s_pledge_bgdate string comment '质押起始时间',
  s_pledge_enddate string comment '质押结束时间',
  s_holder_name string comment '股东名称',
  s_pledge_shares decimal(20,4) comment '质押数量(万股)',
  s_pledgor string comment '质押方',
  s_discharge_date string comment '解押日期',
  s_remark string comment '备注',
  is_discharge bigint comment '是否解押',
  s_holder_type_code bigint comment '股东类型代码',
  s_holder_id string comment '股东ID',
  s_pledgor_type_code bigint comment '质押方类型代码',
  s_pledgor_id string comment '质押方ID',
  s_shr_category_code bigint comment '股份性质类别代码',
  s_total_holding_shr decimal(20,4) comment '持股总数',
  s_total_pledge_shr decimal(20,4) comment '累计质押股数',
  s_pledge_shr_ratio decimal(20,4) comment '本次质押股数占公司总股本比例',
  s_total_holding_shr_ratio decimal(20,4) comment '持股总数占公司总股本比例',
  is_equity_pledge_repo bigint comment '是否股权质押回购',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



