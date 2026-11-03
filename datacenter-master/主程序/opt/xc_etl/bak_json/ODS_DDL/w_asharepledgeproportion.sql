drop table if exists ty_ods.w_asharepledgeproportion;
create table if not exists ty_ods.w_asharepledgeproportion
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_enddate string comment '截止日期',
  s_pledge_num bigint comment '质押笔数',
  s_share_unrestricted_num decimal(20,4) comment '无限售股份质押数量',
  s_share_restricted_num decimal(20,4) comment '有限售股份质押数量',
  s_tot_shr decimal(20,4) comment 'A股总股本',
  s_pledge_ratio decimal(20,4) comment '质押比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



