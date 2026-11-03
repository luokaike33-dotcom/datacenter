drop table if exists ty_ods.w_ashareincquantitydetails;
create table if not exists ty_ods.w_ashareincquantitydetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_name string comment '姓名',
  s_inc_post string comment '职位',
  s_inc_quantity decimal(20,4) comment '数量(万股/万份)',
  s_inc_totalqtypct decimal(20,4) comment '占本次授予总数量比例(%)',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



