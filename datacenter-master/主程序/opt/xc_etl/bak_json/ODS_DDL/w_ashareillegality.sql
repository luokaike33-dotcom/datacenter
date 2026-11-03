drop table if exists ty_ods.w_ashareillegality;
create table if not exists ty_ods.w_ashareillegality
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  illeg_type string comment '违规类型',
  subject_type bigint comment '主体类别代码',
  subject string comment '违规主体',
  relation_type bigint comment '与上市公司的关系',
  behavior string comment '违规行为',
  disposal_dt string comment '处罚日期',
  disposal_type string comment '处分类型',
  method string comment '处分措施',
  processor string comment '处理人',
  amount decimal(20,4) comment '处罚金额(元)',
  ban_year decimal(20,4) comment '市场禁入期限(年)',
  ref_rule string comment '相关法规',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



