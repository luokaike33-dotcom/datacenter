drop table if exists ty_ods.w_asharemanagementholdreward;
create table if not exists ty_ods.w_asharemanagementholdreward
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  crny_code string comment '货币代码',
  s_info_manager_name string comment '姓名',
  s_info_manager_post string comment '职务',
  s_manager_return decimal(20,4) comment '报酬',
  s_manager_quantity decimal(20,4) comment '持股数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



