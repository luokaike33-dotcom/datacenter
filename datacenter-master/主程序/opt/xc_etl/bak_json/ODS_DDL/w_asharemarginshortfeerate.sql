drop table if exists ty_ods.w_asharemarginshortfeerate;
create table if not exists ty_ods.w_asharemarginshortfeerate
(
  object_id string comment '对象ID',
  publisher_id string comment '发布方ID',
  item_code bigint comment '项目类别代码',
  effective_date string comment '生效日',
  fee_rate decimal(20,4) comment '项目数据',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



