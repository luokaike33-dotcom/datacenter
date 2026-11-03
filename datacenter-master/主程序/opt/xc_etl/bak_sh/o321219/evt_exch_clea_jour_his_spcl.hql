-----------------------------------------------------------------------
-- 模块名称：交易所清算流水兴全个性化
-- 业务：
--跨市场转托管（基金）
------------------------------------------------------------------------
----set hive.vectorized.execution.enabled=false;
----set hive.strict.checks.type.safety=false;
----set hive.exec.dynamic.partition.mode=nonstrict;
----set hive.execution.engine=spark;
----set hive.exec.max.dynamic.partitions.pernode=10000;
----set hive.exec.max.dynamic.partitions=10000;
----set hive.exec.max.created.files=10000;
----set hive.merge.sparkfiles=true;
----set hive.optimize.sort.dynamic.partition=true;
----set hive.merge.orcfile.stripe.level=false;
----set spark.memory.fraction=0.8;
----set hive.exec.dynamic.partition=true;
----set hive.crud.dynamic.partition=true;
----set spark.driver.memory=2G; --内存默认2G,复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;


insert into ${dwd_db}.evt_exch_clea_jour_his partition(p_dt,sys_rs_id)
(busi_sys_id,occu_dt,tnv_onum,tnv_time,odr_rela_onum,trd_src_id,entr_onum,rep_no,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_typ,entr_dir,clr_sped,tnv_vol,aft_par_vol,tnv_prc,rat,tnv_val,occu_val,aft_occu_val,stmp,tfee,hand_fee,sfee,clea_chag,clea_rptl,oth_fee,cms,full_tfee,deli_dt,trd_cntp_id,appt_num,trd_plfm,trd_mode,guar_sett_flag,rf_val,marg,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,trad_id,oper_no,tnv_stat,cont_mult,covr_dir,arbi_flag,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,pay_dt,excr_dt,etf_onum,esti_cash_diff,etf_fnd_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--交易所业务：跨市场转托管（基金）:
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,(CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '6' THEN 'NONE' END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '6' THEN
          'NONE'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '210001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE WHEN T0.L_BUSIN_FLAG = '40301' THEN '21000109'
            WHEN T0.L_BUSIN_FLAG = '40302' THEN '21000108'
	   END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       NULL AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       T4.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额，
       T4.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS STMP, --印花税
       0 AS TFEE, --  过户费
       0 AS HAND_FEE, --  经手费
       0 AS SFEE, --  证管费
       0 AS CLEA_CHAG, -- 结算费
       0 AS CLEA_RPTL, -- 结算风险金
       0 AS OTH_FEE, -- 其他费用
       0 AS CMS, -- 佣金
       0 AS FULL_TFEE, --全额过户费
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
	   NULL AS trd_mode,
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       NULL AS TRAD_ID, --券商编码
       NULL AS OPER_NO, --操作员
       1 AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS  ETF_ONUM,--ETF序号
       NULL AS  ESTI_CASH_DIFF,--预估现金差额
       NULL AS  ETF_FND_CLAS,--ETF基金类型
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期.
       'evt_exch_clea_jour_his_spcl' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISCURRENTS T4
    ON T0.p_dt = T4.p_dt
   AND T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.L_BUSIN_FLAG IN ('40311','40312')
   AND T4.VC_SUMMARY = '迅策ufx证券持仓调整指令结转成本'
   AND T4.C_STATUS ='1'
   AND T4.p_dt BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_MARKET_NO IN ('1', '2', '6') --1是上交所、2深交所
   AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T7.C_MARKET_NO
 WHERE T0.L_BUSIN_FLAG IN ('40301','40302')
   AND T0.VC_SUMMARY = '迅策ufx证券持仓调整指令'
   AND T0.C_STATUS ='1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--交易所业务：两融业务（担保品提交和交存）:
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE
												WHEN T5.C_MARKET_NO = '1' THEN
												'SH'
												WHEN T5.C_MARKET_NO = '2' THEN
												'SZ'
											END) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       'CNY' AS CURR_CODE, --货币代码
       '210001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE WHEN T0.VC_SUMMARY IN ('非交易过户数量减少') AND T4.C_CREDIT_STOCKHOLDER = '0' THEN '42000108'
	        WHEN T0.VC_SUMMARY IN ('非交易过户数量增加') AND T4.C_CREDIT_STOCKHOLDER = '0' THEN '42000115'
			WHEN T0.VC_SUMMARY IN ('非交易过户数量减少') AND T4.C_CREDIT_STOCKHOLDER = '1' THEN '42000109'
	        WHEN T0.VC_SUMMARY IN ('非交易过户数量增加') AND T4.C_CREDIT_STOCKHOLDER = '1' THEN '42000116'
	   END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算	   
       NULL AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       0 AS TNV_PRC, --成交价格
       NULL AS RAT, --利率,买卖交易为空	   
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS STMP, --印花税
       0 AS TFEE, --  过户费
       0 AS HAND_FEE, --  经手费
       0 AS SFEE, --  证管费
       0 AS CLEA_CHAG, -- 结算费
       0 AS CLEA_RPTL, -- 结算风险金
       0 AS OTH_FEE, -- 其他费用
       0 AS CMS, -- 佣金
       0 AS FULL_TFEE, --全额过户费	   
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
	   NULL AS trd_mode,
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       NULL AS TRAD_ID, --券商编码
       NULL AS OPER_NO, --操作员
       1 AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM,--ETF序号
       NULL AS ESTI_CASH_DIFF,--预估现金差额
       NULL AS ETF_FND_CLAS,--ETF基金类型
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期.
       'evt_exch_clea_jour_his_spcl2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKHOLDER T4
    ON T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
  INNER JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('2') --只要股票的
   AND T5.C_MARKET_NO IN ('1', '2')
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.VC_SUMMARY IN ('非交易过户数量增加','非交易过户数量减少')
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}   
   