drop table if exists ty_ods.w_ashareincquantityprice;
create table if not exists ty_ods.w_ashareincquantityprice
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_transferpriper decimal(20,4) comment '每股转让价格(行权价格)',
  s_inc_quantity decimal(20,4) comment '激励数量(万份)',
  s_inc_getfundqty decimal(20,4) comment '提取激励基金数量(元)',
  s_inc_iscompleted bigint comment '股权激励是否全部完成',
  s_inc_grantdate string comment '期权授权日',
  s_inc_dnexec_quantity decimal(20,4) comment '已授权未行权的期权数量(万份)',
  s_inc_enddate string comment '截止日期',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



