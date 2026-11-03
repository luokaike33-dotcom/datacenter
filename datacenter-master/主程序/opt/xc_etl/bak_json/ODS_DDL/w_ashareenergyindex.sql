drop table if exists ty_ods.w_ashareenergyindex;
create table if not exists ty_ods.w_ashareenergyindex
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  boll_mid bigint comment 'BOLL布林带MID(26日,2)',
  boll_upper bigint comment 'BOLL布林带UPPER(26日,2)',
  boll_lower bigint comment 'BOLL布林带LOWER(26日,2)',
  bbiboll_bbi bigint comment 'BBIBOLL多空布林线BBI(10日,3)',
  bbiboll_upr bigint comment 'BBIBOLL多空布林线UPR(10日,3)',
  bbiboll_dwn bigint comment 'BBIBOLL多空布林线DWN(10日,3)',
  cdp bigint comment 'CDP逆势操作CDP',
  cdp_ah bigint comment 'CDP逆势操作AH',
  cdp_al bigint comment 'CDP逆势操作AL',
  cdp_nh bigint comment 'CDP逆势操作NH',
  cdp_nl bigint comment 'CDP逆势操作NL',
  env_upper bigint comment 'ENV指标UPPER(14日)',
  env_lower bigint comment 'ENV指标LOWER(14日)',
  mike_wr bigint comment 'MIKE麦克指标WR(12日)',
  mike_mr bigint comment 'MIKE麦克指标MR(12日)',
  mike_sr bigint comment 'MIKE麦克指标SR(12日)',
  mike_ws bigint comment 'MIKE麦克指标WS(12日)',
  mike_ms bigint comment 'MIKE麦克指标MS(12日)',
  mike_ss bigint comment 'MIKE麦克指标SS(12日)',
  mfi bigint comment 'MFI资金流向指标(14日)',
  obv bigint comment 'OBV能量潮OBV',
  obv_obv bigint comment 'OBV能量潮修正OBV',
  pvt bigint comment 'PVT量价趋势指标',
  wvad_wvad bigint comment 'WVAD威廉变异离散量WVAD(24,6日)',
  wvad_mawvad bigint comment 'WVAD威廉变异离散量MAWVAD(24,6日)',
  arbr_ar bigint comment 'ARBR人气意愿指标AR(26日)',
  arbr_br bigint comment 'ARBR人气意愿指标BR(26日)',
  cr bigint comment 'CR能量指标(26日)',
  psy bigint comment 'PSY心理指标PSY(12,6日)',
  psyma bigint comment 'PSY心理指标PSYMA(12,6日)',
  wad bigint comment 'WAD威廉聚散指标WAD(30日)',
  mawad bigint comment 'WAD威廉聚散指标MAWAD(30日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



