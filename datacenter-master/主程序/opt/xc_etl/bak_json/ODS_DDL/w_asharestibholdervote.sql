drop table if exists ty_ods.w_asharestibholdervote;
create table if not exists ty_ods.w_asharestibholdervote
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_date string comment '公告日期',
  deadline string comment '截止日期',
  s_holder_holdercategory string comment '股东类型',
  s_holder_name string comment '股东名称',
  s_holder_code string comment '股东ID',
  s_holder_quantity decimal(20,4) comment '持股数量(股)',
  s_holder_voting_number decimal(20,4) comment '表决权数量(票)',
  s_holder_lsttypecode bigint comment '股份类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



