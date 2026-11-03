drop table if exists ty_ods.w_hkshareprosecution;
create table if not exists ty_ods.w_hkshareprosecution
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  title string comment '案件名称',
  accuser string comment '原告方',
  defendant string comment '被告方',
  pro_type string comment '诉讼类型',
  amount decimal(20,4) comment '涉案金额',
  crncy_code string comment '货币代码',
  prosecute_dt string comment '起诉日期',
  court string comment '一审受理法院',
  judge_dt string comment '判决日期',
  result9 string comment '判决内容',
  is_appeal bigint comment '是否上诉',
  appellant string comment '二审上诉方(是否原告)',
  court2 string comment '二审受理法院',
  judge_dt2 string comment '二审判决日期',
  result2 string comment '二审判决内容',
  resultamount decimal(20,4) comment '判决金额',
  briefresult string comment '诉讼结果',
  execution string comment '执行情况',
  introduction string comment '案件描述',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



