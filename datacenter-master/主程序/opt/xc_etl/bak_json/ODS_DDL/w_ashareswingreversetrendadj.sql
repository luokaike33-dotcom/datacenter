drop table if exists ty_ods.w_ashareswingreversetrendadj;
create table if not exists ty_ods.w_ashareswingreversetrendadj
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  rc_50d bigint comment 'RC变化率指数(50日)',
  mi_a12d bigint comment 'MI动量指标A(12日)',
  mi_mi12d bigint comment 'MI动量指标MI?(12日)',
  micd_dif bigint comment 'MICD异同离差动力指数DIF(3,10,20日)',
  micd_micd bigint comment 'MICD异同离差动力指数MICD(3,10,20,10日)',
  rccd_dif bigint comment 'RCCD异同离差变化率指数DIF(59,21,28日)',
  rccd_rccd bigint comment 'RCCD异同离差变化率指数RCCD(59,21,28日)',
  srmi_9d bigint comment 'SRMI?MI修正指标(9日)',
  atr_tr14d bigint comment 'ATR真实波幅TR(14日)',
  atr_atr14d bigint comment 'ATR真实波幅ATR(14日)',
  mass bigint comment 'MASS梅丝线(9,25日)',
  vhf bigint comment 'VHF纵横指标(28日)',
  cvlt bigint comment 'CVLT佳庆离散指标(10日)',
  adtm_adtm bigint comment 'ADTM动态买卖气指标ADTM(23,8日)',
  adtm_adtmma bigint comment 'ADTM动态买卖气指标ADTMMA(23,8日)',
  bias bigint comment 'BIAS乖离率(12日)',
  kdj_k bigint comment 'KDJ随机指标K(9,3,3日)',
  kdj_d bigint comment 'KDJ随机指标D(9,3,3日)',
  kdj_j bigint comment 'KDJ随机指标J(9,3,3日)',
  rsi bigint comment 'RSI相对强弱指标(6日)',
  cci bigint comment 'CCI顺势指标(14日)',
  dbcd_dbcd bigint comment 'DBCD异同离差乖离率DBCD(5,16,76日)',
  dbcd_mm bigint comment 'DBCD异同离差乖离率MM(5,16,76日)',
  dpo bigint comment 'DPO区间震荡线DPO(20,6日)',
  dpo_madpo bigint comment 'DPO区间震荡线MADPO(20,6日)',
  lwr1 bigint comment 'LWR威廉指标LWR1(9,3,3日)',
  lwr2 bigint comment 'LWR威廉指标LWR2(9,3,3日)',
  roc bigint comment 'ROC变动速率ROC(12,6日)',
  roc_rocma bigint comment 'ROC变动速率ROCMA(12,6日)',
  si bigint comment 'SI摆动指标',
  slowkd_k bigint comment 'SLOWKD慢速K(9,3,3,5日)',
  slowkd_d bigint comment 'SLOWKD慢速D(9,3,3,5日)',
  wr bigint comment 'WR威廉指标(14日)',
  bias36 bigint comment 'B3612三减六日乖离BIAS36',
  bias612 bigint comment 'B3612三减六日乖离BIAS612',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



