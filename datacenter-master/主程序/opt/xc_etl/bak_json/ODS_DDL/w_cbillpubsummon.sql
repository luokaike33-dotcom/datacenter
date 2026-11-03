drop table if exists ty_ods.w_cbillpubsummon;
create table if not exists ty_ods.w_cbillpubsummon
(
  object_id string comment '对象ID',
  ann_dt string comment '公告日期',
  b_info_billno string comment '票号',
  b_info_billtype bigint comment '票据类型代码',
  b_info_facevalue decimal(20,4) comment '票面金额',
  issue_dt string comment '出票日期',
  maturity_dt string comment '到期日',
  b_info_drawer string comment '出票人',
  b_info_acceptbank string comment '付款银行/付款人',
  b_info_summontype string comment '状态类别',
  b_info_applicant string comment '申请人',
  b_info_noticereleaser string comment '发布机构',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



