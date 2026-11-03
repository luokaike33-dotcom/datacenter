drop table if exists ty_ods.w_qfiiquotachange;
create table if not exists ty_ods.w_qfiiquotachange
(
  object_id string comment '对象id',
  f_info_compname string comment '公司名称',
  f_info_compcode string comment '公司ID',
  invest_amount decimal(20,4) comment '投资额度(亿)',
  change_dt string comment '变动日期',
  crncy_code string comment '货币代码',
  type bigint comment '类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



