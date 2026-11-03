drop table if exists ty_ods.w_suspendsecvaluation;
create table if not exists ty_ods.w_suspendsecvaluation
(
  object_id string comment '对象ID',
  type_code bigint comment '估值方法代码',
  s_info_windcode string comment '停牌证券ID',
  val_dt string comment '估值日期',
  val_price decimal(20,4) comment '估值价格(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



