drop table if exists ty_ods.w_companylineofcredit;
create table if not exists ty_ods.w_companylineofcredit
(
  object_id string comment '对象ID',
  comp_id string comment '公司id',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  credit_no decimal(24,8) comment '授信额度(亿元)',
  credit_used decimal(24,8) comment '已使用授信额度(亿元)',
  credit_unused decimal(24,8) comment '未使用授信额度(亿元)',
  credit_compname string comment '授信机构名称',
  credit_compid string comment '授信机构公司ID（废弃）',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



