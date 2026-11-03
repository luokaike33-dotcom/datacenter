drop table if exists ty_ods.w_cmfpreferentialfee;
create table if not exists ty_ods.w_cmfpreferentialfee
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  type_code bigint comment '优惠活动类型代码',
  ann_dt string comment '公告日期',
  start_dt string comment '费率优惠开始日期',
  end_dt string comment '费率优惠截止日期',
  amountdownlimit decimal(20,4) comment '申购金额下限(万元)',
  amountuplimit decimal(20,4) comment '申购金额上限(万元)',
  preferential_rate decimal(20,4) comment '优惠费率(%)',
  way_type bigint comment '优惠活动参与方式代码',
  comp_name string comment '参加优惠活动的代销机构名称',
  comp_id string comment '参加优惠活动的代销机构公司ID',
  memo string comment '备注',
  sequence bigint comment '序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



