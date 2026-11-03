drop table if exists ty_ods.w_cfundbankaccount;
create table if not exists ty_ods.w_cfundbankaccount
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  comp_name string comment '公司名称',
  name_bank_account string comment '开户银行名称',
  account_name string comment '账户名称',
  bank_account string comment '银行账号',
  bank_number string comment '开户行编号',
  exchange_number string comment '交换行号',
  line_number string comment '联行行号',
  line_payment_system string comment '人行支付系统行号',
  update1 string comment '更新日期',
  is_effective bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



