drop table if exists ty_ods.w_asharereportperiodindex;
create table if not exists ty_ods.w_asharereportperiodindex
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  s_ft_bps decimal(20,4) comment '净资产',
  s_bps_change_reason string comment '净资产变动原因',
  s_cap_rsrv decimal(20,4) comment '资本公积金',
  s_cap_rsrv_change_reason string comment '资本公积金变动原因',
  s_undistributedps decimal(20,4) comment '未分配利润',
  s_change_reason string comment '未分配利润变动原因',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



