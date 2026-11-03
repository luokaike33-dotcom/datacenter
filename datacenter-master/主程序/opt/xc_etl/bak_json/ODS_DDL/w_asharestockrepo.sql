drop table if exists ty_ods.w_asharestockrepo;
create table if not exists ty_ods.w_asharestockrepo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_id string comment '事件ID',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  status bigint comment '进度类型代码',
  exp_dt string comment '过期日期',
  qty decimal(20,4) comment '回购数量',
  amt decimal(20,4) comment '回购金额',
  s_dq_high decimal(20,4) comment '最高价',
  s_dq_low decimal(20,4) comment '最低价',
  crncy_code string comment '货币代码',
  stock_repo_objective_code bigint comment '股份回购目的代码',
  s_share_lsttypecode bigint comment '回购股份类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



