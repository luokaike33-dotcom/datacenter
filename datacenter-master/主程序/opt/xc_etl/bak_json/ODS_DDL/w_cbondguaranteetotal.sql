drop table if exists ty_ods.w_cbondguaranteetotal;
create table if not exists ty_ods.w_cbondguaranteetotal
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期',
  ann_date string comment '公告日期',
  guar_balance decimal(20,4) comment '担保余额(亿元)',
  guar_inwards decimal(20,4) comment '对内担保余额(亿元)',
  guar_outwards decimal(20,4) comment '对外担保余额(亿元)',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



