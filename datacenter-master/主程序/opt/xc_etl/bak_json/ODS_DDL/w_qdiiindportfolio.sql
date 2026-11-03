drop table if exists ty_ods.w_qdiiindportfolio;
create table if not exists ty_ods.w_qdiiindportfolio
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  ind string comment '行业类别',
  value decimal(20,4) comment '持仓市值(元)',
  pct_nav decimal(20,4) comment '占基金资产净值比例(%)',
  gics_code string comment '行业代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



