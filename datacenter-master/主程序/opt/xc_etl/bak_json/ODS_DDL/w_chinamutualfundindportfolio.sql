drop table if exists ty_ods.w_chinamutualfundindportfolio;
create table if not exists ty_ods.w_chinamutualfundindportfolio
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_prt_enddate string comment '截止日期',
  s_info_csrcinduscode string comment '证监会行业编号',
  f_prt_indusvalue decimal(20,4) comment '持有行业市值(元)',
  f_prt_industonav decimal(20,4) comment '持有行业市值占基金净值比例(%)',
  f_prt_indposvalue decimal(20,4) comment '积极投资持有行业市值(元)',
  f_prt_indpospro decimal(20,4) comment '积极投资持有行业比例(%)',
  f_prt_indpassivevalue decimal(20,4) comment '指数投资持有行业市值(元)',
  f_prt_indpassivepro decimal(20,4) comment '指数投资持有行业比例(%)',
  f_prt_industonavchange decimal(20,4) comment '持有行业市值比例较上期变化(%)',
  s_info_csrcindusname string comment '行业名称',
  f_ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



