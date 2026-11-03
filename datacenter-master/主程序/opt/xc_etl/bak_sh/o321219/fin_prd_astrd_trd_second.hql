------------------------------------------------------------------------
-- 模块名称：产品交易信息--交易部分
------------------------------------------------------------------------
set hive.vectorized.execution.enabled=false;
set hive.strict.checks.type.safety=false;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.execution.engine=spark;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=10000;
set hive.exec.max.created.files=10000;
set hive.merge.sparkfiles=true;
set hive.optimize.sort.dynamic.partition=true;
set hive.merge.orcfile.stripe.level=false;
set spark.memory.fraction=0.8;
set hive.exec.dynamic.partition=true;
set hive.crud.dynamic.partition=true;
set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
set hive.auto.convert.join=true;

WITH TMP_TNV AS (
--交易所成交
select
'1' as BELT_INTF,--所属接口
(CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
	  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
END) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
CASE WHEN T0.busi_clas in ('20000100') OR (T0.busi_clas in ('06000101') AND T0.EXCH_CODE = 'SH') THEN W1.AFT_1_DT ELSE T0.OCCU_DT END AS TRD_DT,--交易日期
CASE WHEN T0.busi_clas in ('23000105','23000107') THEN T8.refc_secu_id ELSE T0.SECU_ID END AS SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CASE WHEN T0.busi_clas in ('05000105','06000102','42000106','42000107') THEN CONCAT(T0.TNV_ONUM,'_1') ELSE T0.TNV_ONUM END AS TNV_NO,--成交编号
CASE WHEN T0.busi_clas in ('05000104','01000100','01000102','05000102','05020102','05080102','06000101','06000102','20000101','21000109','22000100','22000104','23000107','26000101','42000104','42000115','42000116','42000110') THEN '1' ELSE '-1' END AS CPTL_DIR,--资金方向
CASE WHEN T0.busi_clas in ('05000104','01000100','01000102','05000102','05020102','05080102','06000101','06000102','20000101','21000109','22000100','22000104','23000107','26000101','42000104','42000115','42000116','42000110') THEN '1' ELSE '-1' END AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('05000102','05000104') AND (T0.SECU_ID LIKE '%BOND%' OR T0.SECU_ID LIKE '%FUND%') THEN 'L1'
	 WHEN T0.busi_clas in ('05000104','05000102','05000105','05020102','05080102') THEN 'L5'
     WHEN T0.busi_clas in ('01000100','01000101') AND T0.RES_FLAG = '1' THEN 'L14'
     WHEN T0.busi_clas in ('01000100','01000101') AND T0.RES_FLAG = '0' THEN 'L1'
     WHEN T0.busi_clas in ('23000105','23000107') AND T0.RES_FLAG = '1' THEN 'L13'
     WHEN T0.busi_clas in ('23000105','23000107') AND T0.RES_FLAG = '0' THEN 'L1'
ELSE 'L1' END AS VAR_STAT,--资产状态
CASE WHEN T0.busi_clas in ('05000104','05000102','05000105','05020102','05080102') THEN '0'
     WHEN T0.busi_clas in ('01000100','01000101') AND T0.RES_FLAG = '1' THEN '0'
     WHEN T0.busi_clas in ('01000100','01000101') AND T0.RES_FLAG = '0' THEN '1'
ELSE '1' END AS CIR_ID,--流通标识
CASE WHEN T0.busi_clas in ('01000101','05000105','20000100','21000108','22000101','22000104','23000105','23000107','26000100','42000103','42000107','42000108','42000109','42000111','42000113') THEN '2' ELSE '1' END AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('01000100','01000102','42000104','42000106','42000115','42000116','42000110') THEN '1'
     WHEN T0.busi_clas in ('01000101','42000103','42000107','42000108','42000109','42000111') THEN '2'
     WHEN T0.busi_clas in ('06000101','06000102') THEN '3'
     WHEN T0.busi_clas in ('08000102') THEN '4'
     WHEN T0.busi_clas in ('05000104','05000102','05020102','05080102') THEN '5'
     WHEN T0.busi_clas in ('26000100','26000101') THEN '6'
     WHEN T0.busi_clas in ('22000100','22000103') THEN '13'
     WHEN T0.busi_clas in ('22000101','22000104') THEN '14'
     WHEN T0.busi_clas in ('20000100','20000101','21000108','21000109') THEN '19'
     WHEN T0.busi_clas in ('23000105') THEN '24'
     WHEN T0.busi_clas in ('23000107','42000113') THEN '27'
     WHEN T0.busi_clas in ('05000105') THEN '29'
END AS trd_typ,--交易类型
CASE WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT = 0 THEN nvl( T0.TNV_VOL ,0)
     WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT <> 0 THEN CAST(nvl( T0.TNV_VOL ,0) AS double)*CAST((T4.l_current_amount-T4.L_RESTRICTED_AMOUNT) AS double)/CAST(T4.l_current_amount AS double)
	 WHEN T0.busi_clas in ('06000102') THEN -1
	 WHEN T0.busi_clas in ('23000105') THEN 0
ELSE nvl( T0.TNV_VOL ,0)
END AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('01000100','42000110') AND T5.C_NET_PRICE = 0 THEN T0.TNV_PRC
     WHEN T0.busi_clas in ('01000100','42000110') AND T5.C_NET_PRICE = 1 THEN CAST(T0.OCCU_VAL - (CASE WHEN T0.FULL_TFEE <> 0 THEN T0.FULL_TFEE+T0.STMP+T0.HAND_FEE+T0.SFEE+T0.CLEA_CHAG+T0.CLEA_RPTL+T0.OTH_FEE+T0.CMS
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('01000101','42000111') AND T5.C_NET_PRICE = 0 THEN T0.TNV_PRC
     WHEN T0.busi_clas in ('01000101','42000111') AND T5.C_NET_PRICE = 1 THEN CAST(T0.OCCU_VAL + (CASE WHEN T0.FULL_TFEE <> 0 THEN T0.FULL_TFEE+T0.STMP+T0.HAND_FEE+T0.SFEE+T0.CLEA_CHAG+T0.CLEA_RPTL+T0.OTH_FEE+T0.CMS
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('01000102') THEN CAST(nvl( T0.OCCU_VAL ,0) - (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('05000105') THEN t9.en_open_price
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double)
     WHEN T0.busi_clas in ('42000107','42000108','42000115','42000109','42000116') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('05000104','05000102','05020102','05080102','06000101','06000102','08000102','20000100','20000101','21000108','21000109','22000100','22000101','22000103','22000104','23000105','23000107','26000100','26000101','42000103','42000104','42000113') THEN nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('01000100','01000101','42000110','42000111') THEN T0.TNV_PRC
END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('01000100','01000101','42000110','42000111') AND T5.C_NET_PRICE = 1 THEN nvl( T0.TNV_PRC ,0)
     WHEN T0.busi_clas in ('01000100','01000101','42000110','42000111') AND T5.C_NET_PRICE = 0 THEN nvl( T0.TNV_PRC ,0) - T5.en_bond_interest
     WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('05000105') THEN t9.en_open_price
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double)
     WHEN T0.busi_clas in ('42000107','42000108','42000115','42000109','42000116') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('05000104','01000102','05000102','05020102','05080102','06000101','06000102','08000102','20000100','20000101','21000108','21000109','22000100','22000101','22000103','22000104','23000105','23000107','26000100','26000101','42000103','42000104','42000113') THEN nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('01000100','01000101','42000110','42000111') THEN T0.TNV_PRC
END AS TRD_NET_PRC,--成交净价
CASE WHEN T0.busi_clas in ('01000100','42000110') AND T5.C_NET_PRICE = 0 THEN T5.en_bond_interest
     WHEN T0.busi_clas in ('01000100','42000110') AND T5.C_NET_PRICE = 1 THEN CAST(nvl( T0.OCCU_VAL ,0) - (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double) - nvl( T0.TNV_PRC ,0)
     WHEN T0.busi_clas in ('01000101','42000111') AND T5.C_NET_PRICE = 0 THEN T5.en_bond_interest
     WHEN T0.busi_clas in ('01000101','42000111') AND T5.C_NET_PRICE = 1 THEN CAST(nvl( T0.OCCU_VAL ,0) + (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double) - nvl( T0.TNV_PRC ,0)
     WHEN T0.busi_clas in ('01000102') THEN CAST(nvl( T0.OCCU_VAL ,0) - (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double) - nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('05000104','05000102','05000105','05020102','05080102','06000101','06000102','08000102','20000100','20000101','21000108','21000109','22000100','22000101','22000103','22000104','23000105','23000107','26000100','26000101','42000103','42000104','42000106','42000107','42000108','42000115','42000109','42000116','42000113') THEN 0
	 ELSE 0
END AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT = 0 THEN T0.TNV_VAL
     WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT <> 0 THEN CAST(T0.TNV_VAL AS double)*CAST((T4.l_current_amount-T4.L_RESTRICTED_AMOUNT) AS double)/CAST(T4.l_current_amount AS double)
	 WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('05000105') THEN cast(t9.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('42000107','42000108','42000115','42000109','42000116') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('01000101','42000111') THEN CAST(nvl( T0.OCCU_VAL ,0) + (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double)
     WHEN T0.busi_clas in ('01000100','01000102','42000110') THEN CAST(nvl( T0.OCCU_VAL ,0) - (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END) AS double)
ELSE nvl(T0.TNV_VAL ,0)
END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT = 0 THEN nvl( T0.OCCU_VAL ,0)
     WHEN T0.busi_clas in ('06000102') AND T4.L_RESTRICTED_AMOUNT <> 0 THEN CAST(nvl( T0.OCCU_VAL ,0) AS double)*CAST((T4.l_current_amount-T4.L_RESTRICTED_AMOUNT) AS double)/CAST(T4.l_current_amount AS double)
	 WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('05000105') THEN cast(t9.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('42000107','42000108','42000115','42000109','42000116') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('22000100','22000101','22000103','22000104') THEN T0.TNV_VAL
ELSE nvl( T0.OCCU_VAL ,0)
END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS t0 --交易所清算流水表
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
ON T0.PRD_CODE = T1.VC_FUND_CODE
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
ON REPLACE(REPLACE(T0.AST_UNIT_CODE,T0.PRD_CODE,''),'_','') = T2.VC_ASSET_NO
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
ON REPLACE(REPLACE(T0.PFL_CODE,T0.AST_UNIT_CODE,''),'_','') = T3.VC_COMBI_NO
LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
ON T0.P_DT = T4.P_DT
AND T1.L_FUND_ID = T4.L_FUND_ID
AND T3.L_COMBI_ID = T4.L_BASECOMBI_ID
AND T0.SH_CODE = T4.vc_stockholder_id
AND T0.SEAT_CODE = T4.vc_bind_seat
AND T0.SRC_SECU_ID = T4.VC_INTER_CODE
AND T2.l_asset_id = T4.l_asset_id
AND T4.l_current_amount - T4.l_frozen_amount > 0
AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T5
ON T0.SRC_SECU_ID = T5.VC_INTER_CODE
LEFT JOIN ${dwd_db}.fin_prd_hld_data T6
ON T0.PRD_CODE = T6.PRD_CODE
AND T0.P_DT = T6.P_DT
AND T0.SECU_ID = T6.SECU_ID
AND T6.POS_ID = 'L'
AND T6.AST_STAT = 'L1'
AND CASE WHEN NVL(T0.RES_FLAG,'0') = '0' THEN '1'  WHEN T0.RES_FLAG = '1' THEN '0' END = T6.CIR_ID
AND T6.P_DT between ${beg_date} and ${end_date}
AND T6.SYS_RS_ID IN ('YSSFA45','yssgz25')
LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
ON T0.P_DT = W1.dt
AND T0.EXCH_CODE = CASE WHEN W1.mkt_no = '1' THEN 'SH'
                 WHEN W1.mkt_no = '2' THEN 'SZ'
				 WHEN W1.mkt_no = '5' THEN 'YHJ'
				 WHEN W1.mkt_no = '6' THEN 'NONE'
                 WHEN W1.mkt_no = 'n' THEN 'SHSC'
                 WHEN W1.mkt_no = 'o' THEN 'SZSC'
                 WHEN W1.mkt_no = 'j' THEN 'SB'
                 WHEN W1.mkt_no = 'r' THEN 'BJ'
       END
AND W1.SYS_RS_ID = 'O3'
LEFT JOIN ${dwd_db}.fin_prd_hld_data T7
ON T0.PRD_CODE = T7.PRD_CODE
AND T7.P_DT = W1.pre_1_dt
AND T0.SECU_ID = T7.SECU_ID
AND CASE WHEN NVL(T0.RES_FLAG,'0') = '0' THEN '1'  WHEN T0.RES_FLAG = '1' THEN '0' END = T7.CIR_ID
AND T7.POS_ID = 'L'
AND T7.AST_STAT = 'L1'
AND T7.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') AND ${end_date}
AND T7.SYS_RS_ID IN ('YSSFA45','yssgz25')
LEFT JOIN ${dwd_db}.pro_refc_info T8
ON T0.SECU_ID = T8.SECU_ID
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T9
ON T0.SRC_SECU_ID = T9.VC_INTER_CODE
AND T0.P_DT = T9.P_DT
where t0.p_dt between ${beg_date} and ${end_date}
and (T0.busi_clas in ('05000104','01000100','01000101','01000102','05020102','05080102','06000102','08000102','20000100','20000101','21000108','21000109','22000100','22000101','22000103','22000104','23000105','23000107','26000100','26000101','42000103','42000104','42000108','42000115','42000109','42000116','42000110','42000111','42000113')
OR (busi_clas = '05000105' AND T0.SECU_ID NOT LIKE '%BOND%' AND T0.SECU_ID NOT LIKE '%FUND%' )
OR (busi_clas = '42000106' AND T0.POS_ID = 'L')
OR (busi_clas = '42000107' AND T0.POS_ID = 'S')
OR (busi_clas = '06000101' AND T0.SECU_ID LIKE '%BOND%')
)
--01000100	交易所现券买入
--01000101	交易所现券卖出
--01000102	交易所现券分销认购
--05000102	网上新股中签
--05000102	网上新股交收
--05000105	网上新股上市（第一笔）
--05020102	网上增发申购中签
--05080102	网上新股（北交所）申购中签
--06000101	配股认购确认
--06000102	配股除权
--08000102	债回售到账（交易所）
--20000100	场内转托管转出，日期要往后偏移1天
--20000101	场内转托管转入
--21000108	跨市场转托管转出成交（基金）
--21000109	跨市场转托管转入成交（基金）
--22000100	期货买入开仓
--22000101	期货卖出平仓
--22000103	期货卖出开仓
--22000104	期货买入平仓
--23000105	转融券资金权益除权
--23000107	转融券证券权益除权
--26000100	债转股（债券转出）
--26000101	债转股（股票转入）
--42000103	融券卖出
--42000104	买券还券(买券)
--42000106	直接还券(第一笔) POS_ID = 'L'
--42000107	余券返还(第一笔) POS_ID = 'S'
--42000108	担保品交存（转出股东）
--42000115	担保品交存（转入股东）
--42000109	担保品提取（转出股东）
--42000116	担保品提取（转入股东）
--42000110	担保品买入
--42000111	担保品卖出
--42000113	融券红股除权
union all
select
'1' as BELT_INTF,--所属接口
(CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
	  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
END) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_2') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('06000102') AND T8.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
	 WHEN T0.busi_clas in ('06000102') AND T8.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
	 WHEN T0.busi_clas in ('06000102') AND T8.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
	 WHEN T0.busi_clas in ('06000102') AND T8.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
     WHEN T0.busi_clas in ('05000105','42000106','42000107') THEN 'L1'
END AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('05000105') THEN '29'
     WHEN T0.busi_clas in ('06000102') THEN '3'
     WHEN T0.busi_clas in ('42000106','42000107') THEN '1'
END AS trd_typ,--交易类型
CASE WHEN T0.busi_clas in ('06000102') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * CAST(T8.L_RESTRICTED_AMOUNT AS double) / CAST(T4.l_current_amount AS double)
ELSE nvl( T0.TNV_VOL ,0)
END AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05000105') THEN t9.en_open_price
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double)
     WHEN T0.busi_clas in ('42000107') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('06000102') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05000105') THEN t9.en_open_price     
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double)
     WHEN T0.busi_clas in ('42000107') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('06000102') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('06000102') THEN CAST(T0.TNV_VAL AS double) * CAST(T8.L_RESTRICTED_AMOUNT AS double) / CAST(T4.l_current_amount AS double)
     WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05000105') THEN cast(t9.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('42000107') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('06000102') THEN CAST(nvl( T0.OCCU_VAL ,0) AS double) * CAST(T8.L_RESTRICTED_AMOUNT AS double) / CAST(T4.l_current_amount AS double)
     WHEN T0.busi_clas in ('05000105') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_COST AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('05000105') THEN cast(t9.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('42000106') AND T7.AST_STAT = 'L1' THEN CAST(T7.HLD_VAL AS double) / CAST(T7.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('42000107') AND T6.AST_STAT = 'L1' THEN CAST(T6.HLD_VAL AS double) / CAST(T6.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS t0 --交易所清算流水表
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
ON T0.PRD_CODE = T1.VC_FUND_CODE
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
ON REPLACE(REPLACE(T0.AST_UNIT_CODE,T0.PRD_CODE,''),'_','') = T2.VC_ASSET_NO
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
ON REPLACE(REPLACE(T0.PFL_CODE,T0.AST_UNIT_CODE,''),'_','') = T3.VC_COMBI_NO
LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
ON T0.P_DT = T4.P_DT
AND T1.L_FUND_ID = T4.L_FUND_ID
AND T3.L_COMBI_ID = T4.L_BASECOMBI_ID
AND T0.SH_CODE = T4.vc_stockholder_id
AND T0.SEAT_CODE = T4.vc_bind_seat
AND T0.SRC_SECU_ID = T4.VC_INTER_CODE
AND T2.l_asset_id = T4.l_asset_id
AND T4.l_frozen_amount <> 0
AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T5
ON T0.SRC_SECU_ID = T5.VC_INTER_CODE
LEFT JOIN ${dwd_db}.fin_prd_hld_data T6
ON T0.PRD_CODE = T6.PRD_CODE
AND T0.P_DT = T6.P_DT
AND T0.SECU_ID = T6.SECU_ID
AND T6.POS_ID = 'L'
AND T6.P_DT between ${beg_date} and ${end_date}
AND T6.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T6.AST_STAT = 'L1'
LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
ON T0.P_DT = W1.dt
AND T0.EXCH_CODE = CASE WHEN W1.mkt_no = '1' THEN 'SH'
                 WHEN W1.mkt_no = '2' THEN 'SZ'
				 WHEN W1.mkt_no = '5' THEN 'YHJ'
				 WHEN W1.mkt_no = '6' THEN 'NONE'
                 WHEN W1.mkt_no = 'n' THEN 'SHSC'
                 WHEN W1.mkt_no = 'o' THEN 'SZSC'
                 WHEN W1.mkt_no = 'j' THEN 'SB'
                 WHEN W1.mkt_no = 'r' THEN 'BJ'
       END
LEFT JOIN ${dwd_db}.fin_prd_hld_data T7
ON T0.PRD_CODE = T7.PRD_CODE
AND T0.P_DT = W1.pre_1_dt
AND T0.SECU_ID = T7.SECU_ID
AND T7.POS_ID = 'L'
AND T7.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') AND ${end_date}
AND T7.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T7.AST_STAT = 'L1'
LEFT JOIN ${ods_db}.O3_THISRESTRICTEDSTOCK T8
ON T4.p_dt = T8.p_dt
AND T4.L_UNIT_ID = T8.L_UNIT_ID
AND T8.p_dt between ${beg_date} and ${end_date}
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T9
ON T0.SRC_SECU_ID = T9.VC_INTER_CODE
AND T0.P_DT = T9.P_DT
where t0.p_dt between ${beg_date} and ${end_date}
and (T0.busi_clas in ('06000102')
OR (busi_clas = '05000105' AND T0.SECU_ID NOT LIKE '%BOND%' AND T0.SECU_ID NOT LIKE '%FUND%')
OR (busi_clas = '42000106' AND T0.POS_ID = 'L')
OR (busi_clas = '42000107' AND T0.POS_ID = 'S')
)
--05000105	网上新股上市（第二笔）
--06000102	配股除权(第二笔)
--42000106	直接还券(第二笔) POS_ID = 'S'
--42000107	余券返还(第二笔) POS_ID = 'L'
union all
select
'1' as BELT_INTF,--所属接口
(CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
	  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
END) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_3') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
'3' AS trd_typ,--交易类型
nvl( T0.TNV_VOL ,0) AS TNV_VOL,--成交数量
nvl( T0.TNV_PRC ,0) AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
T0.TNV_VAL AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS t0 --交易所清算流水表
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('06000102')
--06000102	配股除权(第三笔)
union all
select
'1' as BELT_INTF,--所属接口
SUM(CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
	  WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
END) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T1.VAR_SECU_ID AS SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
MAX(T0.TNV_ONUM) AS TNV_NO,--成交编号
MAX(CASE WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'S' THEN '-1'
     WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'L' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'L' THEN '-1'
END) AS CPTL_DIR,--资金方向
MAX(CASE WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'S' THEN '-1'
     WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'L' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'L' THEN '-1'
END) AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
MAX(CASE WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'S' THEN '2'
END) AS TRD_DIR,--交易方向
MAX(CASE WHEN T0.busi_clas in ('02000100') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000101') AND T0.POS_ID = 'S' THEN '2'
END) AS trd_typ,--交易类型
SUM(nvl( T0.TNV_VOL ,0)) AS TNV_VOL,--成交数量
100 AS TRD_PRC,--交易价格（单价）
100 AS TRD_NET_PRC,--成交净价
SUM(CASE WHEN T0.busi_clas in ('02000100') THEN 0
     WHEN T0.busi_clas in ('02000101') THEN nvl( T0.OCCU_VAL ,0) - 100 * nvl( T0.TNV_VOL ,0)
END) AS ACCR_INT,--应计利息
SUM(CASE WHEN T0.busi_clas in ('02000100') THEN nvl( T0.OCCU_VAL ,0) + (CASE WHEN nvl( T0.FULL_TFEE ,0) <> 0 THEN nvl( T0.FULL_TFEE ,0)+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
																					     WHEN nvl( T0.FULL_TFEE ,0) = 0 THEN T0.TFEE+nvl( T0.STMP ,0)+nvl( T0.HAND_FEE ,0)+nvl( T0.SFEE ,0)+nvl( T0.CLEA_CHAG ,0)+nvl( T0.CLEA_RPTL ,0)+nvl( T0.OTH_FEE ,0)+nvl( T0.CMS ,0)
													END)
     WHEN T0.busi_clas in ('02000101') THEN T0.TNV_VAL
END) AS TNV_VAL,--成交金额（不包含费用）
SUM(nvl( T0.OCCU_VAL ,0)) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS t0 --交易所清算流水表
LEFT JOIN ${dwd_db}.pro_repo_tnv_info T1 --回购成交合约表
ON T0.SECU_ID = T1.SECU_ID
AND T1.SYS_RS_ID = 'O3'
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('02000100','02000101')
GROUP BY T1.VAR_SECU_ID,T0.AST_UNIT_CODE,T0.OCCU_DT,T0.INV_TYP,T0.POS_ID,T0.BUSI_CLAS
--02000100	交易所质押式回购首期
--02000101	交易所质押式回购到期

union all
--银行间成交
select
'2' as BELT_INTF,--所属接口
nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
T0.TNV_ONUM AS TNV_NO,--成交编号
CASE WHEN T0.busi_clas in ('01000200') THEN '1'
ELSE '-1' END AS CPTL_DIR,--资金方向
CASE WHEN T0.busi_clas in ('01000200') THEN '1'
ELSE '-1' END AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
CASE WHEN T0.busi_clas in ('01000201') THEN '2'
ELSE '1' END AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('01000200') THEN '1'
     WHEN T0.busi_clas in ('01000201') THEN '2'
ELSE '4' END AS trd_typ,--交易类型
nvl( T0.TNV_VOL ,0) AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('01000200') THEN CAST(nvl( T0.OCCU_VAL ,0) - (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0)) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('01000201') THEN CAST(nvl( T0.OCCU_VAL ,0) + (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0)) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
ELSE nvl( T0.TNV_PRC ,0) END AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
CASE WHEN T0.busi_clas in ('01000200') THEN CAST(nvl( T0.OCCU_VAL ,0) - (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0)) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double) - nvl( T0.TNV_PRC ,0)
     WHEN T0.busi_clas in ('01000201') THEN CAST(nvl( T0.OCCU_VAL ,0) + (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0)) AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double) - nvl( T0.TNV_PRC ,0)
ELSE 0 END AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('01000200') THEN nvl( T0.OCCU_VAL ,0) - (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0))
     WHEN T0.busi_clas in ('01000201') THEN nvl( T0.OCCU_VAL ,0) + (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0))
ELSE T0.TNV_VAL END AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_INBK_CLEA_JOUR_HIS t0 --银行间清算流水表
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('01000200','01000201','08000203')
--01000200	银行间现券买入
--01000201	银行间现券卖出
--08000203	债回售到账（银行间）
union all
select
'2' as BELT_INTF,--所属接口
SUM(nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0)) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T1.VAR_SECU_ID AS SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
MAX(T0.TNV_ONUM) AS TNV_NO,--成交编号
MAX(CASE WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'S' THEN '-1'
     WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'L' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'L' THEN '-1'
END) AS CPTL_DIR,--资金方向
MAX(CASE WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'S' THEN '-1'
     WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'L' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'L' THEN '-1'
END) AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
MAX(CASE WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'S' THEN '2'
END) AS TRD_DIR,--交易方向
MAX(CASE WHEN T0.busi_clas in ('02000200','03000200') AND T0.POS_ID = 'S' THEN '1'
     WHEN T0.busi_clas in ('02000201','03000201') AND T0.POS_ID = 'S' THEN '2'
END) AS trd_typ,--交易类型
SUM(nvl( T0.TNV_VOL ,0)) AS TNV_VOL,--成交数量
100 AS TRD_PRC,--交易价格（单价）
100 AS TRD_NET_PRC,--成交净价
SUM(CASE WHEN T0.busi_clas in ('02000200','03000200') THEN 0
     WHEN T0.busi_clas in ('02000201','03000201') THEN nvl( T0.OCCU_VAL ,0) - 100 * nvl( T0.TNV_VOL ,0)
END) AS ACCR_INT,--应计利息
SUM(CASE WHEN T0.busi_clas in ('02000200','03000200') THEN nvl( T0.OCCU_VAL ,0) + (nvl( T0.TRD_CHAG ,0) + nvl( T0.CLEA_SERV_CHAG ,0) + nvl( T0.OTH_FEE ,0))
         WHEN T0.busi_clas in ('02000201','03000201') THEN T0.TNV_VAL
END) AS TNV_VAL,--成交金额（不包含费用）
SUM(nvl( T0.OCCU_VAL ,0)) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_INBK_CLEA_JOUR_HIS t0 --银行间清算流水表
LEFT JOIN ${dwd_db}.pro_repo_tnv_info T1 --回购成交合约表
ON T0.SECU_ID = T1.SECU_ID
AND T1.SYS_RS_ID = 'O3'
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('02000200','02000201','03000200','03000201')
GROUP BY T1.VAR_SECU_ID,T0.AST_UNIT_CODE,T0.OCCU_DT,T0.INV_TYP,T0.POS_ID,T0.BUSI_CLAS
--02000200	银行间质押式回购首期
--02000201	银行间质押式回购到期
--03000200	银行间买断式首期
--03000201	银行间买断式到期

union all
--网下成交
select
'3' as BELT_INTF,--所属接口
nvl( T0.TRD_CHAG ,0) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CASE WHEN T0.busi_clas in ('05010108','05090102','05010103') THEN CONCAT(T0.TNV_ONUM,'_1') ELSE T0.TNV_ONUM END AS TNV_ONUM,--成交编号
CASE WHEN T0.busi_clas in ('05010108','21000113') THEN '-1'
ELSE '1' END AS CPTL_DIR,--资金方向
CASE WHEN T0.busi_clas in ('05010108','21000113') THEN '-1'
ELSE '1' END AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('05010102') THEN 'L1'
	 WHEN T0.busi_clas in ('05040101','05040201','21000113','21000114') THEN 'L1'
     WHEN T0.busi_clas in ('05030102') THEN 'L2'
	 WHEN T0.busi_clas in ('05010108','05050102','05090102','05100103','05010103') THEN 'L5'
	 WHEN T0.busi_clas in ('05060102') THEN 'L13'
END AS VAR_STAT,--资产状态
CASE WHEN T0.busi_clas in ('05040101','05040201','21000113','21000114') THEN '1'
ELSE '0' END AS CIR_ID,--流通标识
CASE WHEN T0.busi_clas in ('05010108','21000113') THEN '2'
ELSE '1' END AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('21000113','21000114') THEN '19'
ELSE '5' END AS trd_typ,--交易类型
nvl( T0.TNV_VOL ,0) AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('05010108') AND T4.AST_STAT = 'L1' THEN CAST(T4.HLD_COST AS double) / CAST(T4.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05010108') THEN t5.en_open_price
     WHEN T0.busi_clas in ('21000113','21000114') AND T3.AST_STAT = 'L1' THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
ELSE nvl( T0.TNV_PRC ,0) END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('05010108') AND T4.AST_STAT = 'L1' THEN CAST(T4.HLD_COST AS double) / CAST(T4.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05010108') THEN t5.en_open_price
     WHEN T0.busi_clas in ('21000113','21000114') AND T3.AST_STAT = 'L1' THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
ELSE nvl( T0.TNV_PRC ,0) END AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('05010108') AND T4.AST_STAT = 'L1' THEN CAST(T4.HLD_COST AS double) / CAST(T4.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05010108') THEN cast(t5.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('21000113','21000114') AND T3.AST_STAT = 'L1' THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
ELSE T0.TNV_VAL END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('05010108') AND T4.AST_STAT = 'L1' THEN CAST(T4.HLD_COST AS double) / CAST(T4.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05010108') THEN cast(t5.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
     WHEN T0.busi_clas in ('21000113','21000114') AND T3.AST_STAT = 'L1' THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
ELSE nvl( T0.OCCU_VAL ,0) END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_OFLE_CLEA_JOUR_HIS t0 --网下清算流水表
LEFT JOIN ${dwd_db}.evt_ofle_clea_jour_his T1 --网下清算流水表找转入
ON T0.P_DT= T1.P_DT
AND T0.EXCF_ONUM = T1.EXCF_ONUM
AND T1.busi_clas in ('21000114')
AND T1.P_DT BETWEEN ${beg_date} AND ${end_date}
AND T1.SYS_RS_ID = 'O3'
LEFT JOIN ${dwd_db}.fin_prd_hld_data T3
ON T1.PRD_CODE = T3.PRD_CODE
AND T1.P_DT = T3.P_DT
AND T1.SECU_ID = T3.SECU_ID
AND T3.P_DT between ${beg_date} and ${end_date}
AND T3.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T3.AST_STAT = 'L1'
LEFT JOIN ${dwd_db}.fin_prd_hld_data T4
ON T0.PRD_CODE = T4.PRD_CODE
AND T0.P_DT = T4.P_DT
AND T0.SECU_ID = T4.SECU_ID
AND T4.P_DT between ${beg_date} and ${end_date}
AND T4.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T4.AST_STAT = 'L1'
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
ON T0.SRC_SECU_ID = T5.VC_INTER_CODE
AND T0.P_DT = T5.P_DT
where t0.p_dt between ${beg_date} and ${end_date}
and (T0.busi_clas in ('05030102','05040101','05040201','05050102','05060102','05100103','05010103')
OR (T0.busi_clas in ('21000113','21000114'))
OR (T0.busi_clas = '05010108' AND T0.SECU_ID NOT LIKE '%BOND%' AND T0.SECU_ID NOT LIKE '%FUND%')
OR (T0.busi_clas in ('05090102') AND nvl(t0.LOCK_LMT_CLAS,'0') <> '5' )
OR (T0.busi_clas in ('05010102') AND T0.SECU_ID NOT LIKE '%STK%' AND nvl(t0.LOCK_LMT_CLAS,'0') <> '5')
)
--05010102	网下新股申购中签（不包含锁定受限类型：网下新股受限）
--05010108	网下新股上市
--05030102	网下定增申购中签
--05040101	分销买入成交确认（交易所）
--05040201	分销买入成交确认（银行间）
--05050102	网下增发申购中签
--05060102	网下战略配售申购中签
--05090102	网下新股（北交所）申购中签（不包含锁定受限类型：网下新股受限）
--05100103	网下ETF基金现金成交确认
--21000113	跨市场转托管转出成交确认（债券）找到转入那笔记录，通过转入那笔证券编码关联持仓
--21000114	跨市场转托管转入成交确认（债券）
--05010103	网下新股申购缴款（第一笔）
union all
select
'3' as BELT_INTF,--所属接口
nvl( T0.TRD_CHAG ,0) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_2') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('05010108') THEN 'L1'
     WHEN T0.busi_clas in ('05090102','05010103') THEN 'L4'
END AS VAR_STAT,--资产状态
CASE WHEN T0.busi_clas in ('05010108') THEN '1'
     WHEN T0.busi_clas in ('05090102','05010103') THEN '0'
END AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
'5' AS trd_typ,--交易类型
CASE WHEN T0.busi_clas in ('05010108') THEN nvl( T0.TNV_VOL ,0)
	 WHEN T0.busi_clas in ('05090102') AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0 THEN T4.L_RESTRICTED_AMOUNT
	 WHEN T0.busi_clas in ('05010103') THEN T4.L_RESTRICTED_AMOUNT
END AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('05010108') AND T5.AST_STAT = 'L1' THEN CAST(T5.HLD_COST AS double) / CAST(T5.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05010108') THEN t6.en_open_price
     WHEN T0.busi_clas in ('05090102') AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0 THEN nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('05010103') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('05010108') AND T5.AST_STAT = 'L1' THEN CAST(T5.HLD_COST AS double) / CAST(T5.HLD_VOL AS double)
     WHEN T0.busi_clas in ('05010108') THEN t6.en_open_price
	 WHEN T0.busi_clas in ('05090102') AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0 THEN nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('05010103') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('05010108') AND T5.AST_STAT = 'L1' THEN CAST(T5.HLD_COST AS double) / CAST(T5.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05010108') THEN cast(t6.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
	 WHEN T0.busi_clas in ('05090102') AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0 THEN T0.TNV_VAL
	 WHEN T0.busi_clas in ('05010103') THEN T0.TNV_VAL
END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('05010108') AND T5.AST_STAT = 'L1' THEN CAST(T5.HLD_COST AS double) / CAST(T5.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('05010108') THEN cast(t6.en_open_price as double) * cast(nvl( T0.TNV_VOL ,0) as double)
	 WHEN T0.busi_clas in ('05090102') AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0 THEN nvl( T0.OCCU_VAL ,0)
	 WHEN T0.busi_clas in ('05010103') THEN nvl( T0.OCCU_VAL ,0)
END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_OFLE_CLEA_JOUR_HIS t0 --网下清算流水表
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
ON T0.PRD_CODE = T1.VC_FUND_CODE
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
ON REPLACE(REPLACE(T0.AST_UNIT_CODE,T0.PRD_CODE,''),'_','') = T2.VC_ASSET_NO
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
ON REPLACE(REPLACE(T0.PFL_CODE,T0.AST_UNIT_CODE,''),'_','') = T3.VC_COMBI_NO
LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
ON T0.P_DT = T4.P_DT
AND T1.L_FUND_ID = T4.L_FUND_ID
AND T3.L_COMBI_ID = T4.L_BASECOMBI_ID
AND T0.SH_CODE = T4.vc_stockholder_id
AND T0.SEAT_CODE = T4.vc_bind_seat
AND T0.SRC_SECU_ID = T4.VC_INTER_CODE
AND T2.l_asset_id = T4.l_asset_id
AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
LEFT JOIN ${dwd_db}.fin_prd_hld_data T5
ON T0.PRD_CODE = T5.PRD_CODE
AND T0.P_DT = T5.P_DT
AND T0.SECU_ID = T5.SECU_ID
AND T5.P_DT between ${beg_date} and ${end_date}
AND T5.AST_STAT = 'L1'
AND T5.SYS_RS_ID IN ('YSSFA45','yssgz25')
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6
ON T0.SRC_SECU_ID = T6.VC_INTER_CODE
AND T0.P_DT = T6.P_DT
where t0.p_dt between ${beg_date} and ${end_date}
and ((T0.busi_clas = '05010108' AND T0.SECU_ID NOT LIKE '%BOND%' AND T0.SECU_ID NOT LIKE '%FUND%')
OR (T0.busi_clas in ('05090102','05010103') AND t0.LOCK_LMT_CLAS = '5')
)
--05010108	网下新股上市（第二笔）
--05090102	网下新股（北交所）申购中签（锁定受限类型：网下新股受限）关联tunitstock表：获取受限股数量（L_RESTRICTED_AMOUNT）成交数量-受限股数量>0
--05010103	网下新股申购缴款（第二笔）
union all
select
'3' as BELT_INTF,--所属接口
nvl( T0.TRD_CHAG ,0) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_3') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
'L5' AS VAR_STAT,--资产状态
'0' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
'5' AS trd_typ,--交易类型
NVL(nvl( T0.TNV_VOL ,0),0) - NVL(T4.L_RESTRICTED_AMOUNT,0) AS TNV_VOL,--成交数量
nvl( T0.TNV_PRC ,0) AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
T0.TNV_VAL AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0)	 AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_OFLE_CLEA_JOUR_HIS t0 --网下清算流水表
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
ON T0.PRD_CODE = T1.VC_FUND_CODE
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
ON REPLACE(REPLACE(T0.AST_UNIT_CODE,T0.PRD_CODE,''),'_','') = T2.VC_ASSET_NO
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
ON REPLACE(REPLACE(T0.PFL_CODE,T0.AST_UNIT_CODE,''),'_','') = T3.VC_COMBI_NO
LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
ON T0.P_DT = T4.P_DT
AND T1.L_FUND_ID = T4.L_FUND_ID
AND T3.L_COMBI_ID = T4.L_BASECOMBI_ID
AND T0.SH_CODE = T4.vc_stockholder_id
AND T0.SEAT_CODE = T4.vc_bind_seat
AND T0.SRC_SECU_ID = T4.VC_INTER_CODE
AND T2.l_asset_id = T4.l_asset_id
AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('05010103')
and NVL(nvl( T0.TNV_VOL ,0),0) - NVL(T4.L_RESTRICTED_AMOUNT,0)>0
and t0.LOCK_LMT_CLAS = '5'
--05010103	网下新股申购缴款（第三笔）
union all
select
'3' as BELT_INTF,--所属接口
nvl( T0.TRD_CHAG ,0) AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_3') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('05010102') AND (T0.SECU_ID LIKE '%BOND%' OR T0.SECU_ID LIKE '%FUND%') THEN 'L1'
ELSE 'L5'
END AS VAR_STAT,--资产状态
'0' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
'5' AS trd_typ,--交易类型
nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT AS TNV_VOL,--成交数量
nvl( T0.TNV_PRC ,0) AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
T0.TNV_VAL AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_OFLE_CLEA_JOUR_HIS t0 --网下清算流水表
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
ON T0.PRD_CODE = T1.VC_FUND_CODE
LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
ON REPLACE(REPLACE(T0.AST_UNIT_CODE,T0.PRD_CODE,''),'_','') = T2.VC_ASSET_NO
LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
ON REPLACE(REPLACE(T0.PFL_CODE,T0.AST_UNIT_CODE,''),'_','') = T3.VC_COMBI_NO
LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
ON T0.P_DT = T4.P_DT
AND T1.L_FUND_ID = T4.L_FUND_ID
AND T3.L_COMBI_ID = T4.L_BASECOMBI_ID
AND T0.SH_CODE = T4.vc_stockholder_id
AND T0.SEAT_CODE = T4.vc_bind_seat
AND T0.SRC_SECU_ID = T4.VC_INTER_CODE
AND T2.l_asset_id = T4.l_asset_id
AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
LEFT JOIN ${dwd_db}.fin_prd_hld_data T5
ON T0.PRD_CODE = T5.PRD_CODE
AND T0.P_DT = T5.P_DT
AND T0.SECU_ID = T5.SECU_ID
AND T5.P_DT between ${beg_date} and ${end_date}
AND T5.SYS_RS_ID IN ('YSSFA45','yssgz25')
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('05010102','05090102')
AND t0.LOCK_LMT_CLAS = '5'
AND nvl( T0.TNV_VOL ,0) - T4.L_RESTRICTED_AMOUNT > 0
--05010102	网下新股申购中签（锁定受限类型：网下新股受限）关联tunitstock表：获取受限股数量（L_RESTRICTED_AMOUNT）成交数量-受限股数量>0
--05090102	网下新股（北交所）申购中签（锁定受限类型：网下新股受限）关联tunitstock表：获取受限股数量（L_RESTRICTED_AMOUNT）成交数量-受限股数量>0

union all
--场外成交
select
'4' as BELT_INTF,--所属接口
T0.PR_FEE AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
T0.TNV_ONUM AS TNV_NO,--成交编号
CASE WHEN T0.busi_clas in ('09000305','09000307') THEN '-1'
ELSE '1' END AS CPTL_DIR,--资金方向
CASE WHEN T0.busi_clas in ('09000305','09000307') THEN '-1'
ELSE '1' END AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('09000301') THEN '20'
     WHEN T0.busi_clas in ('09000303') THEN '22'
     WHEN T0.busi_clas in ('09000305') THEN '23'
ELSE '21' END AS trd_typ,--交易类型
nvl( T0.TNV_VOL ,0) AS TNV_VOL,--成交数量
nvl( T0.TNV_PRC ,0) AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
T0.TNV_VAL AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0) AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_OTC_CLEA_JOUR_HIS t0 --场外清算流水表
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('09000301','09000303','09000305','09000307','09000308')
--09000301	场外开基认购成交确认
--09000303	场外开基申购成交确认
--09000305	场外开基赎回成交确认
--09000307	场外开基转换成交（转出）确认
--09000308	场外开基转换成交（转入）确认

union all
--结算类成交
select
'5' as BELT_INTF,--所属接口
NULL AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CASE WHEN T0.busi_clas in ('10000100','41000101','41000100') THEN CONCAT(T0.TNV_ONUM,'_1') ELSE T0.TNV_ONUM END AS TNV_NO,--成交编号
CASE WHEN T0.busi_clas in ('41000102','99000002','10000100','12000100','12000300','18000100','18000300') THEN '1'
ELSE '-1' END AS CPTL_DIR,--资金方向
CASE WHEN T0.busi_clas in ('41000102','99000002','10000100','12000100','12000300','18000100','18000300') THEN '1'
ELSE '-1' END  AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('41000101') AND T1.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
	 WHEN T0.busi_clas in ('41000101') AND T1.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
	 WHEN T0.busi_clas in ('41000101') AND T1.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
	 WHEN T0.busi_clas in ('41000101') AND T1.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
	 WHEN T0.busi_clas in ('41000100') AND T0.P_DT <= T4.LST_DT THEN 'L5'
	 WHEN T0.busi_clas in ('41000100') AND T0.P_DT > T4.LST_DT THEN 'L1'
	 WHEN T0.busi_clas in ('41000102','41000103') THEN T0.RES_FLAG
	 WHEN T0.busi_clas in ('99000008') THEN 'L5'
ELSE 'L1' END AS VAR_STAT,--资产状态
CASE WHEN T0.busi_clas in ('41000101','41000100','41000102','41000103','99000003') THEN '0'
ELSE '1' END AS CIR_ID,--流通标识
CASE WHEN T0.busi_clas in ('41000103','51000100','99000003','27000100','41000101','45000300','41000100','99000008') THEN '2'
ELSE '1' END AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('27000100','45000300') THEN '23'
     WHEN T0.busi_clas in ('11000100','11000300') THEN '24'
     WHEN T0.busi_clas in ('13000100','13000200') THEN '26'
     WHEN T0.busi_clas in ('10000100') THEN '27'
     WHEN T0.busi_clas in ('41000101') THEN '29'
     WHEN T0.busi_clas in ('12000100','12000300') THEN '30'
	 WHEN T0.busi_clas in ('99000002','41000102') THEN '1'
	 WHEN T0.busi_clas in ('51000100','99000003','41000100','41000103','99000008') THEN '2'
ELSE '11' END AS trd_typ,--交易类型
CASE WHEN T0.busi_clas in ('11000100','11000300','13000100','13000200','15000100','15000200') THEN 0 ELSE nvl( T0.TNV_VOL ,0) END AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN t5.en_open_price
	 WHEN T0.busi_clas in ('41000102','41000103','99000008') THEN T5.EN_LAST_PRICE
ELSE nvl( T0.TNV_PRC ,0) END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)
     WHEN T0.busi_clas in ('13000100','13000200') THEN 0
	 WHEN T0.busi_clas in ('14000100','14000101','14000102','14000103','14000200','15000100','15000101','15000200','15000202','27000100') THEN (CAST(T0.TNV_VAL AS double) - CAST(T0.INTR_VAL AS double)) / CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN t5.en_open_price	 
	 WHEN T0.busi_clas in ('41000102','41000103','99000008') THEN T5.EN_LAST_PRICE
ELSE nvl( T0.TNV_PRC ,0) END AS TRD_NET_PRC,--成交净价
CASE WHEN T0.busi_clas in ('13000100','13000200') THEN nvl( T0.TNV_PRC ,0)
	 WHEN T0.busi_clas in ('14000100','14000101','14000102','14000103','14000200','15000100','15000101','15000200','15000202','27000100') THEN CAST(T0.INTR_VAL AS double) / CAST(nvl( T0.TNV_VOL ,0) AS double)
ELSE 0 END AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('41000102','41000103','99000008') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * CAST(T5.EN_LAST_PRICE AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * cast(t5.en_open_price as double)
ELSE T0.TNV_VAL END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('41000102','41000103','99000008') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * CAST(T5.EN_LAST_PRICE AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * cast(t5.en_open_price as double)	 
ELSE nvl( T0.OCCU_VAL ,0) END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_SETT_CLEA_JOUR_HIS t0 --结算类清算流水表
LEFT JOIN (
SELECT T0.L_UNIT_ID,T7.aft_1_dt,T0.C_LOCKRESTRICTED_TYPE,ROW_NUMBER()OVER(PARTITION BY T0.L_DATE,T0.L_UNIT_ID ORDER BY T0.L_RSEND_DATE ASC) AS RN
  FROM ${ods_db}.O3_THISRESTRICTEDSTOCK T0
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON T0.P_DT = T4.P_DT
   AND T0.L_UNIT_ID = T4.L_UNIT_ID
   AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
   on T0.L_RSEND_DATE = W1.dt
   AND T5.C_MARKET_NO = W1.mkt_no
   and W1.SYS_RS_ID='O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T7
   on W1.PRE_0_DT = T7.dt
   AND T5.C_MARKET_NO = T7.mkt_no
   and t7.SYS_RS_ID='O3'
WHERE T7.aft_1_dt between ${beg_date} and ${end_date} AND NVL(T0.C_RSEND_FLAG,'1') = '1'
AND T0.P_DT between date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
) T1
ON CONCAT(T1.aft_1_dt,'_HSO32_X',T1.L_UNIT_ID,'_',T1.RN) = T0.TNV_ONUM
AND T0.P_DT = T1.aft_1_dt
LEFT JOIN ${dwd_db}.fin_prd_hld_data T2
ON T0.PRD_CODE = T2.PRD_CODE
AND T0.P_DT = T2.P_DT
AND T0.SECU_ID = T2.SECU_ID
AND T2.P_DT between ${beg_date} and ${end_date}
AND T2.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T2.AST_STAT = 'L1'
LEFT JOIN ${dwd_db}.fin_prd_hld_data T3
ON T0.PRD_CODE = T3.PRD_CODE
AND T0.P_DT = T3.P_DT
AND T0.SECU_ID = T3.SECU_ID
AND T0.RES_FLAG = CASE WHEN T3.AST_STAT = 'L15' THEN 'L4' ELSE T3.AST_STAT END
AND T3.P_DT between ${beg_date} and ${end_date}
AND T3.SYS_RS_ID IN ('YSSFA45','yssgz25')
LEFT JOIN ${dwd_db}.VAR_SECU_INFO T4
ON T0.SECU_ID = T4.SECU_ID
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
ON T0.P_DT = T5.P_DT
AND T0.SRC_SECU_ID = T5.VC_INTER_CODE
AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
where t0.p_dt between ${beg_date} and ${end_date}
and (T0.busi_clas in ('99000008','41000102','41000103','41000100','51000100','99000002','99000003','11000100','11000300','12000100','12000300','13000100','13000200','14000100','14000101','14000102','14000103','14000200','15000100','15000101','15000200','15000202','18000100','18000101','18000300','18000301','27000100','45000300')
OR (T0.busi_clas in ('10000100') AND T0.RES_FLAG = '0')
OR (T0.busi_clas in ('41000101') AND T1.L_UNIT_ID IS NOT NULL)
)
--10000100	红股除权（交易所）（识别限售标识：0非限售）
--11000100	红利除权（交易所）
--11000300	红利除权（场外）
--12000100	红利再投（交易所）
--12000300	红利再投（场外）
--13000100	兑息(交易所)
--13000200	兑息(银行间)
--14000100	兑付(交易所库外)
--14000101	兑付(交易所库内未占用)
--14000102	兑付(交易所库内占用)(兑付当日)
--14000103	兑付(交易所库内占用)(质押出库日)
--14000200	兑付(银行间)
--15000100	部分兑付本金(交易所)(面额)
--15000101	部分兑付本金(交易所)(数量)
--15000200	部分兑付本金(银行间)(面额)
--15000202	部分兑付本金(银行间)(数量)
--18000100	份额调增（交易所）
--18000101	份额调减（交易所）
--18000300	份额调增（场外）
--18000301	份额调减（场外）
--27000100	债赎回到账（交易所）
--41000101	限售股转流通关联THISRESTRICTEDSTOCK受限股持仓明细历史表，取L_DATE下一个交易日 =发生日期以及L_UNIT_ID =成交最后一个拼接剔除X
--45000300	场外开基强制赎回
union all
select
'5' as BELT_INTF,--所属接口
NULL AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
CONCAT(T0.TNV_ONUM,'_2') AS TNV_NO,--成交编号
'1' AS CPTL_DIR,--资金方向
'1' AS SECU_DIR,--证券方向
CASE WHEN T0.busi_clas in ('10000100') AND T1.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
	 WHEN T0.busi_clas in ('10000100') AND T1.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
	 WHEN T0.busi_clas in ('10000100') AND T1.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
	 WHEN T0.busi_clas in ('10000100') AND T1.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
     WHEN T0.busi_clas in ('41000101') AND T0.P_DT <= T4.LST_DT THEN 'L5'
	 WHEN T0.busi_clas in ('41000101') AND T0.P_DT > T4.LST_DT THEN 'L1'
	 WHEN T0.busi_clas in ('41000100') THEN T0.RES_FLAG
END AS VAR_STAT,--资产状态
CASE WHEN T0.busi_clas in ('10000100','41000100') THEN '0'
     WHEN T0.busi_clas in ('41000101') THEN '1'
END AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
CASE WHEN T0.busi_clas in ('10000100') THEN '27'
     WHEN T0.busi_clas in ('41000101') THEN '29'
	 WHEN T0.busi_clas in ('41000100') THEN '1'
END AS trd_typ,--交易类型
CASE WHEN T0.busi_clas in ('10000100') THEN CAST(nvl( T0.TNV_VOL ,0) AS double) * CAST(T1.L_RESTRICTED_AMOUNT AS double) / CAST(SUM(T1.L_RESTRICTED_AMOUNT)OVER(PARTITION BY T0.AST_UNIT_CODE,T0.OCCU_DT,T0.TNV_ONUM) AS double)
     WHEN T0.busi_clas in ('41000101','41000100') THEN nvl( T0.TNV_VOL ,0)
END AS TNV_VOL,--成交数量
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN t5.en_open_price	 
     WHEN T0.busi_clas in ('10000100') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_PRC,--交易价格（单价）
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN t5.en_open_price	 	 
     WHEN T0.busi_clas in ('10000100') THEN nvl( T0.TNV_PRC ,0)
END AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN cast(t5.en_open_price as double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('10000100') THEN T0.TNV_VAL
END AS TNV_VAL,--成交金额（不包含费用）
CASE WHEN T0.busi_clas in ('41000101') AND T2.AST_STAT = 'L1' THEN CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
     WHEN T0.busi_clas in ('41000100') THEN CAST(T3.HLD_VAL AS double) / CAST(T3.HLD_VOL AS double) * CAST(nvl( T0.TNV_VOL ,0) AS double)
	 WHEN T0.busi_clas in ('41000100','41000101') THEN cast(t5.en_open_price as double) * CAST(nvl( T0.TNV_VOL ,0) AS double)	 
     WHEN T0.busi_clas in ('10000100') THEN nvl( T0.OCCU_VAL ,0)
END AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_SETT_CLEA_JOUR_HIS t0 --结算类清算流水表
LEFT JOIN (
SELECT CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO, 'C') AS TNV_ONUM, --成交序号
       T6.C_LOCKRESTRICTED_TYPE,t6.L_RESTRICTED_AMOUNT,
	   T0.L_DATE
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.P_DT = W1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.sys_rs_id = 'O3'
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON W1.pre_1_dt = T4.P_DT
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISRESTRICTEDSTOCK T6
    ON T4.P_DT = T6.P_DT
   AND T4.L_UNIT_ID = T6.L_UNIT_ID
   AND T6.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41801')
   AND CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN 0 ELSE T0.L_BUSIN_AMOUNT * NVL(T4.L_RESTRICTED_AMOUNT, 0) / NVL(T4.L_CURRENT_AMOUNT, 0) END <> 0
      --41801红股除权
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}
) T1
ON T0.TNV_ONUM = T1.TNV_ONUM
AND T0.P_DT = T1.L_DATE
LEFT JOIN ${dwd_db}.fin_prd_hld_data T2
ON T0.PRD_CODE = T2.PRD_CODE
AND T0.P_DT = T2.P_DT
AND T0.SECU_ID = T2.SECU_ID
AND T2.P_DT between ${beg_date} and ${end_date}
AND T2.SYS_RS_ID IN ('YSSFA45','yssgz25')
AND T2.AST_STAT = 'L1'
LEFT JOIN ${dwd_db}.fin_prd_hld_data T3
ON T0.PRD_CODE = T3.PRD_CODE
AND T0.P_DT = T3.P_DT
AND T0.SECU_ID = T3.SECU_ID
AND T3.P_DT between ${beg_date} and ${end_date}
AND T0.RES_FLAG = CASE WHEN T3.AST_STAT = 'L15' THEN 'L4' ELSE T3.AST_STAT END
AND T3.SYS_RS_ID IN ('YSSFA45','yssgz25')
LEFT JOIN ${dwd_db}.var_secu_info T4
ON T0.SECU_ID = T4.SECU_ID
LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
ON T0.SRC_SECU_ID = T5.VC_INTER_CODE
AND T0.P_DT = T5.P_DT
where t0.p_dt between ${beg_date} and ${end_date}
and ((T0.busi_clas in ('10000100') AND T0.RES_FLAG = '1' AND T1.TNV_ONUM IS NOT NULL)
OR (T0.busi_clas in ('41000101'))
OR T0.busi_clas in ('41000100')
)
union all
select
'5' as BELT_INTF,--所属接口
NULL AS TRD_FEE,--交易费
T0.BUSI_CLAS AS VOU_TYP,--凭证类别
T0.AST_UNIT_CODE AS PRD_CODE,--产品代码
T0.OCCU_DT AS TRD_DT,--交易日期
T0.SECU_ID,--证券编码
T0.INV_TYP AS INV_TYPE,--投资类型
T0.POS_ID,--多空标识
T0.TNV_ONUM AS TNV_NO,--成交编号
'-1' AS CPTL_DIR,--资金方向
'-1' AS SECU_DIR,--证券方向
'L1' AS VAR_STAT,--资产状态
'1' AS CIR_ID,--流通标识
'1' AS TRD_DIR,--交易方向
'24' AS trd_typ,--交易类型
0 AS TNV_VOL,--成交数量
nvl( T0.TNV_PRC ,0) AS TRD_PRC,--交易价格（单价）
nvl( T0.TNV_PRC ,0) AS TRD_NET_PRC,--成交净价
0 AS ACCR_INT,--应计利息
T0.TNV_VAL - T1.TNV_VAL AS TNV_VAL,--成交金额（不包含费用）
nvl( T0.OCCU_VAL ,0) - T1.OCCU_VAL AS SETT_VAL--结算金额（包含费用）
from ${dwd_db}.EVT_SETT_CLEA_JOUR_HIS t0 --结算类清算流水表
INNER JOIN ${dwd_db}.EVT_SETT_CLEA_JOUR_HIS T1
ON T0.PRD_CODE = T1.PRD_CODE
AND T0.PFL_CODE = T1.PFL_CODE
AND T0.SH_CODE = T1.SH_CODE
AND T0.SECU_ID = T1.SECU_ID
AND T1.BUSI_CLAS = '11000100'
AND T1.p_dt between date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-92),'yyyyMMdd') and ${end_date}
where t0.p_dt between ${beg_date} and ${end_date}
and T0.busi_clas in ('11000101')
and T0.exch_code in ('SHSC','SZSC')
)
insert into ${dwd_db}.fin_prd_astrd_trd partition(p_dt,sys_rs_id)
(prd_code,prd_typ,trd_dt,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_type,cir_id,var_stat,pos_id,lf_curr_id,curr_code,tnv_no,trd_dir,tnv_vol,trd_prc,trd_net_prc,accr_int,tnv_val,sett_val,ytm,trd_fee,trd_fee_cms,trd_fee_hand,trd_fee_stmp,trd_fee_sfee,trd_fee_tfee,trd_fee_chag,excr,trd_cntp,trd_seat,trd_typ,inrt_tax,trad_no,trad_name,vou_typ,busi_date,task_rs_id,dm_src_info,dm_created_time,p_dt,sys_rs_id)
--只取估值产品成立以后的正常数据
SELECT
t1.prd_code
,t1.prd_typ
,t1.trd_dt
,t1.secu_id
,t1.typ_code
,t1.typ_codei
,t1.typ_codeii
,t1.exch_code
,t1.chi_name
,t1.crse_code
,t1.crse_type
,t1.crse_dim
,t1.inv_type
,t1.cir_id
,t1.var_stat
,t1.pos_id
,t1.lf_curr_id
,t1.curr_code
,t1.tnv_no
,t1.trd_dir
,t1.tnv_vol
,t1.trd_prc
,t1.trd_net_prc
,t1.accr_int
,t1.tnv_val
,t1.sett_val
,t1.ytm
,t1.trd_fee
,t1.trd_fee_cms
,t1.trd_fee_hand
,t1.trd_fee_stmp
,t1.trd_fee_sfee
,t1.trd_fee_tfee
,t1.trd_fee_chag
,t1.excr
,t1.trd_cntp
,t1.trd_seat
,t1.trd_typ
,t1.inrt_tax
,t1.trad_no
,t1.trad_name
,t1.vou_typ
,t1.busi_date
,t1.task_rs_id
,t1.dm_src_info
,t1.dm_created_time
,t1.p_dt
,t1.sys_rs_id
FROM (
SELECT
       T0.PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T1.CHI_NAME AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       '1' AS LF_CURR_ID, --本币/原币标识
       'CNY' AS CURR_CODE, --货币类型
       T0.TNV_NO AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       CAST(T0.SECU_DIR AS DOUBLE)* CAST(nvl( T0.TNV_VOL ,0) AS DOUBLE) AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TRD_NET_PRC AS DOUBLE) AS TRD_NET_PRC, --成交净价
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.ACCR_INT AS DOUBLE) AS ACCR_INT, --应计利息
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TNV_VAL AS DOUBLE) AS TNV_VAL, --成交金额（不包含费用）
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.SETT_VAL AS DOUBLE) AS SETT_VAL, --结算金额（包含费用）
	   NULL AS ytm,
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TRD_FEE AS DOUBLE) AS TRD_FEE, --交易费
	   NULL AS trd_fee_cms,   --交易费明细_佣金
	   NULL AS trd_fee_hand,  --交易费明细_经手费
	   NULL AS trd_fee_stmp,  --交易费明细_印花税
	   NULL AS trd_fee_sfee,  --交易费明细_证管费
	   NULL AS trd_fee_tfee,  --交易费明细_过户费
	   NULL AS trd_fee_chag,  --交易费明细_手续费
	   NULL AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   T0.trd_typ AS trd_typ,       --交易类型
	   NULL AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       T0.VOU_TYP AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_4' AS TASK_RS_ID, --任务来源标识
       'TMP_TNV' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.TRD_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM TMP_TNV T0
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
  ON T0.SECU_ID = T1.SECU_ID
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
and T1.TRD_DT >= NVL(T2.FOUND_DT,20991231)

union all
--将估值产品成立以前的数据，日期调整为成立日
SELECT
t1.prd_code
,t1.prd_typ
,T2.FOUND_DT as trd_dt
,t1.secu_id
,t1.typ_code
,t1.typ_codei
,t1.typ_codeii
,t1.exch_code
,t1.chi_name
,t1.crse_code
,t1.crse_type
,t1.crse_dim
,t1.inv_type
,t1.cir_id
,t1.var_stat
,t1.pos_id
,t1.lf_curr_id
,t1.curr_code
,t1.tnv_no
,t1.trd_dir
,t1.tnv_vol
,t1.trd_prc
,t1.trd_net_prc
,t1.accr_int
,t1.tnv_val
,t1.sett_val
,t1.ytm
,t1.trd_fee
,t1.trd_fee_cms
,t1.trd_fee_hand
,t1.trd_fee_stmp
,t1.trd_fee_sfee
,t1.trd_fee_tfee
,t1.trd_fee_chag
,t1.excr
,t1.trd_cntp
,t1.trd_seat
,t1.trd_typ
,t1.inrt_tax
,t1.trad_no
,t1.trad_name
,t1.vou_typ
,t1.busi_date
,t1.task_rs_id
,t1.dm_src_info
,t1.dm_created_time
,T2.FOUND_DT as p_dt
,t1.sys_rs_id
FROM (
SELECT
       T0.PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T1.CHI_NAME AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       '1' AS LF_CURR_ID, --本币/原币标识
       'CNY' AS CURR_CODE, --货币类型
       T0.TNV_NO AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       CAST(T0.SECU_DIR AS DOUBLE)* CAST(nvl( T0.TNV_VOL ,0) AS DOUBLE) AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TRD_NET_PRC AS DOUBLE) AS TRD_NET_PRC, --成交净价
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.ACCR_INT AS DOUBLE) AS ACCR_INT, --应计利息
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TNV_VAL AS DOUBLE) AS TNV_VAL, --成交金额（不包含费用）
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.SETT_VAL AS DOUBLE) AS SETT_VAL, --结算金额（包含费用）
	   NULL AS ytm,
       CAST(T0.CPTL_DIR AS DOUBLE)* CAST(T0.TRD_FEE AS DOUBLE) AS TRD_FEE, --交易费
	   NULL AS trd_fee_cms,   --交易费明细_佣金
	   NULL AS trd_fee_hand,  --交易费明细_经手费
	   NULL AS trd_fee_stmp,  --交易费明细_印花税
	   NULL AS trd_fee_sfee,  --交易费明细_证管费
	   NULL AS trd_fee_tfee,  --交易费明细_过户费
	   NULL AS trd_fee_chag,  --交易费明细_手续费
	   NULL AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   T0.trd_typ AS trd_typ,       --交易类型
	   NULL AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       T0.VOU_TYP AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_5' AS TASK_RS_ID, --任务来源标识
       'TMP_TNV' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.TRD_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM TMP_TNV T0
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
  ON T0.SECU_ID = T1.SECU_ID
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
AND T1.TRD_DT < NVL(T2.FOUND_DT,20991231)
AND T2.FOUND_DT between ${beg_date} and ${end_date}
