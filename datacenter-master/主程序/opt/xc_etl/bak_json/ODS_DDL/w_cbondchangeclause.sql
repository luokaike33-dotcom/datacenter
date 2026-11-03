drop table if exists ty_ods.w_cbondchangeclause;
create table if not exists ty_ods.w_cbondchangeclause
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  s_info_windcode2 string comment '目标证券ID',
  s_info_execdate string comment '行权日期',
  ann_date string comment '公告日期',
  s_info_repurchasestartdate string comment '申请起始日',
  s_info_repurchaseenddate string comment '申请截止日',
  s_info_min_operation_amount decimal(20,4) comment '最低操作金额',
  s_info_conversion_ratio string comment '调换比例',
  s_info_trusteeship decimal(20,4) comment '原托管面额',
  s_info_postright_trusteeship decimal(20,4) comment '行权后托管面额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



