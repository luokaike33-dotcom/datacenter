drop table if exists ty_ods.w_bondissueregistration;
create table if not exists ty_ods.w_bondissueregistration
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '[内部]公告日期',
  meeting_dt string comment '注册会议日期',
  int_amount decimal(20,4) comment '初始注册金额(亿元)',
  change_amount decimal(20,4) comment '变更后注册金额(亿元)',
  crncy_code string comment '货币代码',
  filelocation string comment '备案场所',
  filenum string comment '文件号',
  end_dt_effective string comment '有效期截止日',
  end_dt_firstissue string comment '首期发行截止日',
  is_install bigint comment '是否可分期发行',
  leadunderwriter string comment '主承销商名称',
  type_code bigint comment '注册债券类型代码',
  abs_managerid string comment 'ABS产品管理人公司ID',
  abs_manager string comment 'ABS产品管理人/SPV',
  abs_name string comment 'ABS产品名称',
  num bigint comment '[内部]序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



