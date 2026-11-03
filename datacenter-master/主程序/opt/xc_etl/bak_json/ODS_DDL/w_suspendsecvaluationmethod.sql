drop table if exists ty_ods.w_suspendsecvaluationmethod;
create table if not exists ty_ods.w_suspendsecvaluationmethod
(
  object_id string comment '对象ID',
  s_info_compcode string comment '基金公司ID',
  s_info_compname string comment '基金公司名称',
  s_info_windcode string comment '停牌证券WIND代码',
  ann_dt string comment '公告日期',
  s_dq_suspenddate string comment '停牌日期',
  price decimal(20,4) comment '停牌价格(元)',
  type_code bigint comment '估值方法代码',
  ind_windcode string comment '跟踪指数WIND代码',
  s_dq_resumpdate string comment '复牌日期',
  val_price decimal(20,4) comment '公布估值价格',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



