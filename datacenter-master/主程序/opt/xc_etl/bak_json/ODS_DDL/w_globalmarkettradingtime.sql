drop table if exists ty_ods.w_globalmarkettradingtime;
create table if not exists ty_ods.w_globalmarkettradingtime
(
  object_id string comment '对象ID',
  exchange_sname_eng string comment '交易所英文简称',
  exchange_name string comment '交易所中文名称',
  securities_type string comment '交易品种描述',
  trading_hours_code string comment '交易时段编码',
  trading_hours string comment '交易时段',
  trading_hours_2 string comment '交易时段(新)',
  exchange_eng_name string comment '交易所英文名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



