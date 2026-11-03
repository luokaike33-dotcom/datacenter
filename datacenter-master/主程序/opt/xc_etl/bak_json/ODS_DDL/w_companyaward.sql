drop table if exists ty_ods.w_companyaward;
create table if not exists ty_ods.w_companyaward
(
  object_id string comment '对象ID',
  s_info_chineseintroduction string comment '机构简称',
  s_info_compcode string comment '机构公司ID',
  s_info_award_code bigint comment '奖项代码',
  s_info_year string comment '年度',
  s_info_ranking bigint comment '排名',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



