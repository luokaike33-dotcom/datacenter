drop table if exists ty_ods.w_cfuturescontractmapping;
create table if not exists ty_ods.w_cfuturescontractmapping
(
  object_id string comment '对象ID',
  s_info_windcode string comment '连续(主力)合约Wind代码',
  fs_mapping_windcode string comment '映射月合约Wind代码',
  startdate string comment '起始日期',
  enddate string comment '截止日期',
  contract_id string comment '合约ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



