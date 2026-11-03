drop table if exists ty_ods.w_ashareequfroinfo;
create table if not exists ty_ods.w_ashareequfroinfo
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_date string comment '公告日期',
  s_fro_bgdate string comment '冻结起始时间',
  s_fro_enddate string comment '冻结结束时间',
  s_holder_name string comment '股东名称',
  s_fro_shares decimal(20,4) comment '冻结数量(万股)',
  frozen_institution string comment '执行冻结机构',
  disfrozen_time string comment '解冻日期',
  s_holder_type_code bigint comment '股东类型代码',
  s_holder_id string comment '股东ID',
  shr_category_code bigint comment '股份性质类别代码',
  is_turn_frozen bigint comment '是否轮候冻结',
  is_disfrozen bigint comment '是否解冻',
  s_total_holding_shr decimal(20,4) comment '持股总数（万股）',
  s_fro_shr_ratio decimal(20,4) comment '本次冻结股数占公司总股本比例',
  s_total_holding_shr_ratio decimal(20,4) comment '持股总数占公司总股本比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



