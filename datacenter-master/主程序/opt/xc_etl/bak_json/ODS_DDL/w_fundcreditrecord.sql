drop table if exists ty_ods.w_fundcreditrecord;
create table if not exists ty_ods.w_fundcreditrecord
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  regulators_id string comment '监管机构ID',
  ann_date string comment '公告日期',
  effective_date string comment '生效日期',
  regulatory_object_name string comment '监管对象名称',
  regulatory_object_id string comment '监管对象ID',
  regulatory_object_code bigint comment '监管对象类别代码',
  regulatory_object_type bigint comment '监管对象类型代码',
  measures_disposition string comment '处分措施',
  measures_disposition_code bigint comment '处分措施代码',
  punishment_measures_code bigint comment '处罚措施代码',
  penalty_amount decimal(24,8) comment '处罚金额',
  business_restrictive_measures bigint comment '业务资格限制措施代码',
  punishment_time_code bigint comment '处分期限代码',
  debar_measures_code bigint comment '市场禁入措施代码',
  institution_id string comment '处罚时所在机构ID',
  irregularities string comment '违规事项',
  legal_basis string comment '法律依据',
  detailed_content string comment '详细内容',
  type_code bigint comment '业务类型代码',
  involving_comp_id string comment '涉及公司ID',
  is_effective bigint comment '是否生效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



