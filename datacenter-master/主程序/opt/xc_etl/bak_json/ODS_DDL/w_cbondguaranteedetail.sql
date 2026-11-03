drop table if exists ty_ods.w_cbondguaranteedetail;
create table if not exists ty_ods.w_cbondguaranteedetail
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期',
  ann_date string comment '公告日期',
  company_guaranteed string comment '被担保公司名称',
  amountofguarantee bigint comment '担保金额(万元)',
  guaranteecompanytype string comment '担保公司类别',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



