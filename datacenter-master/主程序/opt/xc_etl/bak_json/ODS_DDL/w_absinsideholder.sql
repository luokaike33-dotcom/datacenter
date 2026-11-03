drop table if exists ty_ods.w_absinsideholder;
create table if not exists ty_ods.w_absinsideholder
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_compname string comment '公司名称',
  ann_dt string comment '公告日期',
  b_holder_enddate string comment '截止日期',
  b_holder_holdercategory string comment '股东类型',
  b_holder_name string comment '股东名称',
  b_holder_quantity decimal(20,4) comment '持股数量',
  b_holder_pct decimal(20,4) comment '持股比例',
  b_holder_sharecategory string comment '持股性质',
  b_holder_aname string comment '股东名称',
  holderid string comment '股东ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



