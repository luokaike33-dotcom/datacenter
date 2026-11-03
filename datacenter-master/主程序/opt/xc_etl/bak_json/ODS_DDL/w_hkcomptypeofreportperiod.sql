drop table if exists ty_ods.w_hkcomptypeofreportperiod;
create table if not exists ty_ods.w_hkcomptypeofreportperiod
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期(报告期)',
  s_info_comptype string comment '公司类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



