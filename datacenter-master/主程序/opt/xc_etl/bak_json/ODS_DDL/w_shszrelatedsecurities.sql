drop table if exists ty_ods.w_shszrelatedsecurities;
create table if not exists ty_ods.w_shszrelatedsecurities
(
  object_id string comment '对象ID',
  exchange_a string comment '交易所1',
  securities_type_a string comment '证券类型1',
  s_info_windcode string comment 'WIND代码1',
  exchange_b string comment '交易所2',
  securities_type_b string comment '证券类型2',
  s_info_windcod2 string comment 'WIND代码2',
  s_info_name string comment '证券简称2',
  is_effective bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



