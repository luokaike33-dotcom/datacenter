drop table if exists ty_ods.w_ashareintensitytrendadj;
create table if not exists ty_ods.w_ashareintensitytrendadj
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  market bigint comment '大盘同步指标沪深300(7日)',
  strength bigint comment '阶段强势指标沪深300(20日)',
  weakkness bigint comment '阶段弱势指标沪深300(20日)',
  bottoming_b bigint comment '筑底指标B(125,5,20日)',
  bottoming_d bigint comment '筑底指标D(125,5,20日)',
  dmi_pdi bigint comment 'DMI趋向指标PDI(14,6日)',
  dmi_mdi bigint comment 'DMI趋向指标MDI(14,6日)',
  dmi_adx bigint comment 'DMI趋向指标ADX(14,6日)',
  dmi_adxr bigint comment 'DMI趋向指标ADXR(14,6日)',
  expma bigint comment 'EXPMA指数平均数(12日)',
  ma_5d bigint comment 'MA简单移动平均(5日)',
  ma_10d bigint comment 'MA简单移动平均(10日)',
  ma_20d bigint comment 'MA简单移动平均(20日)',
  ma_30d bigint comment 'MA简单移动平均30日)',
  ma_60d bigint comment 'MA简单移动平均(60日)',
  ma_120d bigint comment 'MA简单移动平均(120日)',
  ma_250d bigint comment 'MA简单移动平均(250日)',
  macd_diff bigint comment 'MACD指数平滑异同平均DIFF(26,12,9日)',
  macd_dea bigint comment 'MACD指数平滑异同平均DEA(26,12,9日)',
  macd_macd bigint comment 'MACD指数平滑异同平均MACD(26,12,9日)',
  bbi bigint comment 'BBI多空指数(3,6,12,24日)',
  ddi bigint comment 'DDI方向标准离差指数DDI(13,30,5,10日)',
  ddi_addi bigint comment 'DDI方向标准离差指数ADDI(13,30,5,10日)',
  ddi_ad bigint comment 'DDI方向标准离差指数AD(13,30,5,10日)',
  dma_ddd bigint comment 'DMA平均线差DDD(10,50,10日)',
  dma_ama bigint comment 'DMA平均线差AMA(10,50,10日)',
  mtm bigint comment 'MTM动力指标MTM(6,6日)',
  mtm_mtmma bigint comment 'MTM动力指标MTMMA(6,6日)',
  priceosc bigint comment 'PRICEOSC价格振荡指标(26,12日)',
  trix bigint comment 'TRIX三重指数平滑平均TRIX(12,20日)',
  trma bigint comment 'TRIX三重指数平滑平均TRMA(12,20日)',
  sar bigint comment 'SAR抛物转向(4,2,20日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



