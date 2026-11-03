drop table if exists ty_ods.w_chfundlist;
create table if not exists ty_ods.w_chfundlist
(
  object_id string comment '对象ID',
  f_info_compcode string comment '基金ID',
  f_info_fullname string comment '基金名称',
  f_info_corp_fundmanagementid string comment '管理人公司ID',
  f_info_corp_fundmanagementcomp string comment '基金管理人',
  registration string comment '注册地代码',
  fundtype string comment '类别',
  start_dt string comment '纳入日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



