drop table if exists ty_ods.w_asharestockratingconsus;
create table if not exists ty_ods.w_asharestockratingconsus
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  rating_dt string comment '日期',
  s_wrating_avg decimal(20,4) comment '综合评级',
  s_wrating_instnum decimal(20,4) comment '评级机构数量',
  s_wrating_upgrade decimal(20,4) comment '调高家数（相比一月前）',
  s_wrating_downgrade decimal(20,4) comment '调低家数（相比一月前）',
  s_wrating_maintain decimal(20,4) comment '维持家数（相比一月前）',
  s_wrating_numofbuy decimal(20,4) comment '买入家数',
  s_wrating_numofoutperform decimal(20,4) comment '增持家数',
  s_wrating_numofhold decimal(20,4) comment '中性家数',
  s_wrating_numofunderperform decimal(20,4) comment '减持家数',
  s_wrating_numofsell decimal(20,4) comment '卖出家数',
  s_wrating_cycle string comment '周期',
  s_est_price decimal(20,4) comment '一致预测目标价',
  s_est_priceinstnum decimal(20,4) comment '目标价预测机构数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



