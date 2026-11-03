drop table if exists ty_ods.w_asharel2indicators;
create table if not exists ty_ods.w_asharel2indicators
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_li_initiativebuyrate decimal(20,4) comment '主买比率',
  s_li_initiativebuymoney decimal(20,4) comment '主买总额',
  s_li_initiativebuyamount decimal(20,4) comment '主买总量',
  s_li_initiativesellrate decimal(20,4) comment '主卖比率',
  s_li_initiativesellmoney decimal(20,4) comment '主卖总额',
  s_li_initiativesellamount decimal(20,4) comment '主卖总量',
  s_li_largebuyrate decimal(20,4) comment '大买比率',
  s_li_largebuymoney decimal(20,4) comment '大买总额',
  s_li_largebuyamount decimal(20,4) comment '大买总量',
  s_li_largesellrate decimal(20,4) comment '大卖比率',
  s_li_largesellmoney decimal(20,4) comment '大卖总额',
  s_li_largesellamount decimal(20,4) comment '大卖总量',
  s_li_entrustrate decimal(20,4) comment '总委比',
  s_li_entrudifferamount decimal(20,4) comment '总委差量',
  s_li_entrudifferamoney decimal(20,4) comment '总委差额',
  s_li_entrustbuymoney decimal(20,4) comment '总委买额',
  s_li_entrustsellmoney decimal(20,4) comment '总委卖额',
  s_li_entrustbuyamount decimal(20,4) comment '总委买量',
  s_li_entrustsellamount decimal(20,4) comment '总委卖量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



