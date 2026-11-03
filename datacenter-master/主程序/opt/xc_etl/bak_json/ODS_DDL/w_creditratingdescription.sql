drop table if exists ty_ods.w_creditratingdescription;
create table if not exists ty_ods.w_creditratingdescription
(
  object_id string comment '对象ID',
  b_est_rating_inst string comment '信用等级',
  b_est_institute string comment '评估机构代码',
  b_typcode string comment '评级类型',
  invest_grade string comment '投资等级',
  grade_definition string comment '含义',
  grade_num decimal(20,4) comment '等级序号',
  common_grade bigint comment '通用等级',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



