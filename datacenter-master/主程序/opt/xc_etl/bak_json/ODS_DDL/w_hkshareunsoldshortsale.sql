drop table if exists ty_ods.w_hkshareunsoldshortsale;
create table if not exists ty_ods.w_hkshareunsoldshortsale
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码1',
  trade_dt string comment '日期',
  unflat_short_interest decimal(20,4) comment '未平仓卖空股数',
  unflat_short_selling_amount decimal(20,4) comment '未平仓卖空金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



