drop table if exists ty_ods.w_industryderivativefactor;
create table if not exists ty_ods.w_industryderivativefactor
(
  object_id string comment '对象ID',
  sw_industry_code string comment '申万一级行业编号',
  trade_dt string comment '日期',
  sw_industry_number bigint comment '行业成份数量',
  s_val_avgpe_sw decimal(20,4) comment '行业PE均值',
  s_val_avgpb_sw decimal(20,4) comment '行业PB均值',
  s_val_avgps_sw decimal(20,4) comment '行业PS均值',
  s_val_avgpcf_sw decimal(20,4) comment '行业PCF均值',
  s_val_avgroe_sw decimal(20,4) comment '行业ROE均值（%）',
  s_val_avgroa_sw decimal(20,4) comment '行业ROA均值（%）',
  s_val_avggp_sw decimal(20,4) comment '行业GP均值（%）',
  s_val_avgbtomv_sw decimal(20,4) comment '行业账面市值比均值',
  s_val_avgpebitda_sw decimal(20,4) comment '行业(股价/息税折旧及摊销前利润)均值',
  s_val_avgpb_mrq_sw decimal(20,4) comment '行业PB(MRQ)均值',
  s_val_avgpbusinc_sw decimal(20,4) comment '行业总市值/营业收入ttm均值',
  s_val_stdpe_sw decimal(20,4) comment '行业PE标准差',
  s_val_stdpb_sw decimal(20,4) comment '行业PB标准差',
  s_val_stdps_sw decimal(20,4) comment '行业PS标准差',
  s_val_stdpcf_sw decimal(20,4) comment '行业PCF标准差',
  s_val_stdroe_sw decimal(20,4) comment '行业ROE标准差',
  s_val_stdroa_sw decimal(20,4) comment '行业ROA标准差',
  s_val_stdgp_sw decimal(20,4) comment '行业GP标准差',
  s_val_stdbtomv_sw decimal(20,4) comment '行业账面市值比标准差',
  s_val_stdpebitda_sw decimal(20,4) comment '行业(股价/息税折旧及摊销前利润)标准差',
  s_val_stdpb_mrq_sw decimal(20,4) comment '行业PB(MRQ)标准差',
  s_val_stdpbusinc_sw decimal(20,4) comment '行业总市值/营业收入ttm标准差',
  s_val_avgrevenue5_sw decimal(20,4) comment '行业收益均值(5日)（%）',
  s_val_avgrevenue20_sw decimal(20,4) comment '行业收益均值(1月)（%）',
  sw_industries_name string comment '行业中文名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '行业日衍生因子'
row format delimited fields terminated by '\t'
stored as orc;



