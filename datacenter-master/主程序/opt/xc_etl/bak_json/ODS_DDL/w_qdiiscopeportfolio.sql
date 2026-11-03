drop table if exists ty_ods.w_qdiiscopeportfolio;
create table if not exists ty_ods.w_qdiiscopeportfolio
(
  object_id string comment '对象id',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  enddate string comment '截止日期',
  scope string comment '国家（地区)代码',
  value decimal(20,4) comment '市值(元)',
  posstktonav decimal(20,4) comment '占净资产的比例(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



