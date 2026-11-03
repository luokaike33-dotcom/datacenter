------------------------------------------------------------------------
-- 模块名称：交易所指令表(离线)
--业务：
--指令：LOF基金,实时申赎基金认购\申购\赎回
--指令：20220902 ETF基金申赎_单市场股票、跨市场股票（交易所）、跨市场股票（中登）、跨境\黄金\沪港通\沪深港ETF股票（现金）
--指令：网上新股(股转)
--离线指令：质押式协议回购首期\到期\续作\提前到期\解除质押
--指令：股票红利选择权申报\撤销
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
----set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;



insert into ${dwd_db}.evt_exch_odr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,odr_onum,odr_clas,odr_rela_dt,odr_strt_dt,odr_end_dt,odr_strt_time,odr_end_time,odr_ctrl_clas,odr_secu_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,inv_typ,busi_typ,busi_clas,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,trd_plfm,trd_mode,entr_dir,odr_prc_clas,odr_prc,rat,odr_vol,odr_val,bgng_has_entr_vol,bgng_has_entr_val,bgng_has_tnv_vol,bgng_has_tnv_val,entr_vol,entr_val,tnv_vol,tnv_val,trd_cntp_id,appt_num,guar_sett_flag,deli_dt,rela_rrsn,agt_rela_rrsn,memo,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,buyb_val,intr,in_prd_code,in_ast_unit_code,in_pfl_code,in_inv_typ,in_secu_id,in_src_secu_id,in_odr_vol,in_odr_prc,in_odr_val,cntp_seat_code,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,bons_mode,pay_dt,cont_mult,arbi_flag,esti_cash_diff,etf_fnd_clas,odr_stat,busi_date,task_rs_id,dm_created_time,delr_id,p_dt,sys_rs_id)
--指令：LOF基金,实时申赎基金认购\申购\赎回
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO ,
            '|0|0') AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
     T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
     T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
     T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
     T0.L_END_DATE AS ODR_END_DT, --指令结束日期
     T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
     T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
     T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END)
          , '_' , (CASE
                        WHEN T4.C_INVEST_TYPE IN ('1') THEN
                             '2' --交易型金融资产
                        WHEN T4.C_INVEST_TYPE IN ('2') THEN
                             '1' --持有到期资产
                        ELSE
                             T4.C_INVEST_TYPE
                   END) , '_' , (CASE
                                      WHEN T4.C_ENTRUST_DIRECTION = 'D' AND T7.VC_REPORT_CODE IS NULL THEN
                                           '30000100'
                                      WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NULL THEN
                                           '31000100'
                                      WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NULL THEN
                                           '32000100'
                                      WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NOT NULL THEN
                                           '38000100'
                                      WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NOT NULL THEN
                                           '38000101'
                                 END)) AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     CASE
          WHEN T4.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T4.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T4.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T4.C_ENTRUST_DIRECTION = 'D' AND T7.VC_REPORT_CODE IS NULL THEN
               '300001'
          WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NULL THEN
               '310001'
          WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NULL THEN
               '320001'
          WHEN T4.C_ENTRUST_DIRECTION IN ('p', 'q') AND
               T7.VC_REPORT_CODE IS NOT NULL THEN
               '380001'
     END AS BUSI_TYP, --业务类别
     CASE
          WHEN T4.C_ENTRUST_DIRECTION = 'D' AND T7.VC_REPORT_CODE IS NULL THEN
               '30000100'
          WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NULL THEN
               '31000100'
          WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NULL THEN
               '32000100'
          WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NOT NULL THEN
               '38000100'
          WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NOT NULL THEN
               '38000101'
     END AS BUSI_CLAS, --业务类型
     CONCAT(T5.VC_REPORT_CODE , '.FUND.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END)) AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE, --交易方式
     CASE
          WHEN T4.C_ENTRUST_DIRECTION = 'D' THEN
               '13'
          WHEN T4.C_ENTRUST_DIRECTION = 'p' THEN
               '53'
          WHEN T4.C_ENTRUST_DIRECTION = 'q' THEN
               '54'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               '2'
          ELSE
               '1'
     END AS ODR_PRC_CLAS, --指令价格类型
     (CASE T4.EN_PRICE1 WHEN 0 THEN T4.EN_FACT_PRICE ELSE  T4.EN_PRICE1 END)AS ODR_PRC, --指令价格
     NULL AS RAT, --利率
     T4.L_AMOUNT AS ODR_VOL, --指令数量
     T4.EN_BALANCE AS ODR_VAL, --指令金额
     T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
     T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
     T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
     T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
     T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
     T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
     T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
     T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标识
     CASE
          WHEN T4.C_ENTRUST_DIRECTION = 'D' AND T5.C_MARKET_NO = '1' THEN  aft_2_dt
          WHEN T4.C_ENTRUST_DIRECTION = 'D' AND T5.C_MARKET_NO = '2' THEN  aft_1_dt
          WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NULL THEN
               GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
          WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NULL THEN
               GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
          WHEN T4.C_ENTRUST_DIRECTION = 'p' AND T7.VC_REPORT_CODE IS NOT NULL THEN aft_1_dt
          WHEN T4.C_ENTRUST_DIRECTION = 'q' AND T7.VC_REPORT_CODE IS NOT NULL THEN aft_1_dt
     END AS DELI_DT, --交割日期
     T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
     T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
     T0.VC_SUMMARY AS MEMO, --备注
     NULL AS CONT_DAYS, --合约天数
     NULL AS INTA_DAYS, --计息天数
     NULL AS CONT_TNV_DT, --合约成交日期
     NULL AS CONT_END_DT, --合约到期日期
     NULL AS FIR_DELI_DT, --首期交割日期
     NULL AS END_DELI_DT, --到期交割日期
     NULL AS FIR_DELI_MODE, --首期交割方式
     NULL AS END_DELI_MODE, --到期交割方式
     NULL AS BUYB_VAL, --购回金额
     NULL AS INTR, --利息
     NULL AS IN_PRD_CODE, --转入产品代码
     NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
     NULL AS IN_PFL_CODE, --转入投组代码
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ORD_VOL, --转入指令数量
     NULL AS IN_ORD_PRC, --转入指令价格
     NULL AS IN_ORD_VAL, --转入指令金额
     T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
               '4'
          WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
               '5'
          ELSE
               T0.C_INSTRUCTION_STATUS
     END AS ODR_STAT, --指令状态
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_exch_odr_his_second_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_OPERATOR_NO AS DELR_ID, --交易员
     T0.L_DATE,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
       INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
         ON T0.P_DT = T4.P_DT
                AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
                AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T4.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T4.P_DT = T5.P_DT
                AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISETFBASICINFO T7
         ON T5.VC_REPORT_CODE = T7.VC_REPORT_CODE
                AND T5.P_DT = T7.P_DT
                AND T7.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE T8
         ON GREATEST(T0.L_BEGIN_DATE, T0.P_DT) = T8.DT
                AND T5.C_MARKET_NO = T8.MKT_NO
                AND T8.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('5')
   AND T4.C_ENTRUST_DIRECTION IN ('D', 'p', 'q')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

 UNION ALL
--指令：20220902 ETF基金申赎_单市场股票、跨市场股票（交易所）、跨市场股票（中登）、跨境\黄金\沪港通\沪深港ETF股票（现金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0' )AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME, 'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
     T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
     T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
     T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
     T0.L_END_DATE AS ODR_END_DT, --指令结束日期
     T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
     T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
     T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T7.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
                                                                                                                CONCAT(NVL(T9.VC_REPORT_CODE,T11.VC_REPORT_CODE) , '.FUND.SZ') --深交所基金
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE <> '159900' AND
                                                                                                                T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCSZZJ.CASH.SZ' --深交所本方资金
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('2'),T11.C_TYPE IN ('2')) AND
                                                                                                                T6.VC_REPORT_CODE = '159900' THEN
                                                                                                                'XCQTZJ.CASH.SZ' --深交所跨境资金
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('3'),T11.C_TYPE IN ('3')) AND
                                                                                                                NVL(T9.C_ETF_TYPE,T11.C_ETF_TYPE) IN ('4', '7') AND T6.VC_REPORT_CODE = '159900' THEN
                                                                                                                'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('5', '6'),T11.C_TYPE IN ('5', '6')) AND
                                                                                                                T6.VC_REPORT_CODE = '159900' THEN
                                                                                                                'XCGSZJ.CASH.SZ' --深交所港市资金
                                                                                                           WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE = '159900' THEN
                                                                                                                'XCSHZJ.CASH.SZ' --深交所上海市场资金
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
                                                                                                                CONCAT(NVL(T9.VC_REPORT_CODE,T11.VC_REPORT_CODE) , '.FUND.SH') --上交所基金
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '2' AND
                                                                                                                T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCSHZJ.CASH.SH' --上交所本方资金,老模式
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('2'),T11.C_TYPE IN ('2')) AND
                                                                                                                SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCQTZJ.CASH.SH' --深交所跨境资金，老模式
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('3'),T11.C_TYPE IN ('3')) AND
                                                                                                                NVL(T9.C_ETF_TYPE,T11.C_ETF_TYPE) IN ('4', '7') AND
                                                                                                                SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCQTZJ.CASH.SH' --深交所商品期货、黄金资金，老模式
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('5', '6'),T11.C_TYPE IN ('5', '6')) AND
                                                                                                                SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCGSZJ.CASH.SH' --上交所港市资金,老模式
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND
                                                                                                                T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
                                                                                                           WHEN T5.C_MARKET_NO = '1' AND
                                                                                                                SUBSTR(T6.VC_REPORT_CODE, 1, 2) = 'HS' AND
                                                                                                                T6.C_STOCK_TYPE = 'F' THEN
                                                                                                                (CASE T7.VC_INTER_CODE
                                                                                                                      WHEN 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                                                                                                                      WHEN 'HSQTZJSS' THEN  'XCQTZJ.CASH.SH'
                                                                                                                      WHEN 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                                                                                                                      WHEN  'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END) --上交所资金,新模式
                                                                                                           ELSE
                                                                                                                (CASE
                                                                                                                      WHEN T6.C_ASSET_CLASS = '2' THEN
                                                                                                                           CONCAT(T6.VC_REPORT_CODE , '.STK.' , --股票
                                                                                                                                  (CASE T6.C_MARKET_NO
                                                                                                                                        WHEN '1' THEN 'SH'
                                                                                                                                        WHEN '2' THEN  'SZ'
                                                                                                                                        WHEN 'n' THEN 'SHSC'
                                                                                                                                        WHEN  'o' THEN  'SZSC'
                                                                                                                                        WHEN 'j' THEN  (CASE NVL(T6.VC_LAYERING, 0) WHEN 2 THEN 'BJ' ELSE 'SB' END)
                                                                                                                                        WHEN 'r' THEN 'BJ'  END))
                                                                                                                      WHEN T6.C_ASSET_CLASS = '3' THEN --债券
                                                                                                                           CONCAT(T6.VC_REPORT_CODE , '.BOND.' ,
                                                                                                                                  (CASE T6.C_MARKET_NO
                                                                                                                                        WHEN '1' THEN 'SH'
                                                                                                                                        WHEN '2' THEN 'SZ' END))
                                                                                                                 END)
                                                                                                      END) , '_' , (CASE
                                                                                                                         WHEN T4.C_INVEST_TYPE IN ('1') THEN
                                                                                                                              '2' --交易型金融资产
                                                                                                                         WHEN T4.C_INVEST_TYPE IN ('2') THEN
                                                                                                                              '1' --持有到期资产
                                                                                                                         ELSE
                                                                                                                              T4.C_INVEST_TYPE
                                                                                                                    END) , '_' , (CASE
                                                                                                                                       WHEN T7.C_ENTRUST_DIRECTION in ('P') AND
                                                                                                                                            T4.C_ENTRUST_DIRECTION = 'P' THEN
                                                                                                                                            '37000100' --ETF基金申购_基金
                                                                                                                                       WHEN T6.C_STOCK_TYPE in ('F') AND T4.C_ENTRUST_DIRECTION = 'P' THEN
                                                                                                                                            '37000102' --ETF基金申购_现金替代
                                                                                                                                       WHEN T4.C_ENTRUST_DIRECTION = 'P' THEN
                                                                                                                                            '37000101' --ETF基金申购_成分券
                                                                                                                                       WHEN T7.C_ENTRUST_DIRECTION IN ('Q') AND
                                                                                                                                            T4.C_ENTRUST_DIRECTION = 'Q' THEN
                                                                                                                                            '37000103' --ETF基金赎回_基金
                                                                                                                                       WHEN T6.C_STOCK_TYPE IN ('F') AND T4.C_ENTRUST_DIRECTION = 'Q' THEN
                                                                                                                                            '37000105' --ETF基金赎回_现金替代
                                                                                                                                       WHEN T4.C_ENTRUST_DIRECTION = 'Q' THEN
                                                                                                                                            '37000104' --ETF基金赎回_成分券
                                                                                                                                  END)) AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     CASE
          WHEN T4.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T4.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T4.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '370001' AS BUSI_TYP, --业务类别
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P') AND
               T4.C_ENTRUST_DIRECTION = 'P' THEN
               '37000100' --ETF基金申购_基金
          WHEN T6.C_STOCK_TYPE in ('F') AND T4.C_ENTRUST_DIRECTION = 'P' THEN
               '37000102' --ETF基金申购_现金替代
          WHEN T4.C_ENTRUST_DIRECTION = 'P' THEN
               '37000101' --ETF基金申购_成分券
          WHEN T7.C_ENTRUST_DIRECTION IN ('Q') AND
               T4.C_ENTRUST_DIRECTION = 'Q' THEN
               '37000103' --ETF基金赎回_基金
          WHEN T6.C_STOCK_TYPE IN ('F') AND T4.C_ENTRUST_DIRECTION = 'Q' THEN
               '37000105' --ETF基金赎回_现金替代
          WHEN T4.C_ENTRUST_DIRECTION = 'Q' THEN
               '37000104' --ETF基金赎回_成分券
     END AS BUSI_CLAS, --业务类型
     CASE
          WHEN T5.C_MARKET_NO = '2' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
               CONCAT(NVL(T9.VC_REPORT_CODE,T11.VC_REPORT_CODE) , '.FUND.SZ') --深交所基金
          WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE <> '159900' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ.CASH.SZ' --深交所本方资金
          WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('2'),T11.C_TYPE IN ('2')) AND
               T6.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ.CASH.SZ' --深交所跨境资金
          WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('3'),T11.C_TYPE IN ('3')) AND
               NVL(T9.C_ETF_TYPE IN ('4', '7'),T11.C_ETF_TYPE IN ('4', '7')) AND T6.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
          WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('5', '6'),T11.C_TYPE IN ('5', '6')) AND
               T6.VC_REPORT_CODE = '159900' THEN
               'XCGSZJ.CASH.SZ' --深交所港市资金
          WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE = '159900' THEN
               'XCSHZJ.CASH.SZ' --深交所上海市场资金
          WHEN T5.C_MARKET_NO = '1' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
               CONCAT(NVL(T9.VC_REPORT_CODE,T11.VC_REPORT_CODE) , '.FUND.SH') --上交所基金
          WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '2' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSHZJ.CASH.SH' --上交所本方资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('2'),T11.C_TYPE IN ('2')) AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ.CASH.SH' --深交所跨境资金，老模式
          WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('3'),T11.C_TYPE IN ('3')) AND
               NVL(T9.C_ETF_TYPE IN ('4', '7'),T11.C_ETF_TYPE IN ('4', '7')) AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ.CASH.SH' --深交所商品期货、黄金资金，老模式
          WHEN T5.C_MARKET_NO = '1' AND NVL(T9.C_TYPE IN ('5', '6'),T11.C_TYPE IN ('5', '6')) AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCGSZJ.CASH.SH' --上交所港市资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND
               SUBSTR(T6.VC_REPORT_CODE, 1, 2) = 'HS' AND
               T6.C_STOCK_TYPE = 'F' THEN
               (CASE T7.VC_INTER_CODE
                     WHEN 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                     WHEN 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                     WHEN  'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                     WHEN  'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END)--上交所资金,新模式
          ELSE
               (CASE
                     WHEN T6.C_ASSET_CLASS = '2' THEN
                          CONCAT(T6.VC_REPORT_CODE , '.STK.' , --股票
                                 (CASE T6.C_MARKET_NO
                                       WHEN '1' THEN 'SH'
                                       WHEN '2' THEN 'SZ'
                                       WHEN 'n' THEN 'SHSC'
                                       WHEN 'o' THEN 'SZSC'
                                       WHEN 'j' THEN (CASE NVL(T6.VC_LAYERING, 0) WHEN 2 THEN 'BJ' ELSE 'SB' END)
                                       WHEN 'r' THEN 'BJ'
                                  END))
                     WHEN T6.C_ASSET_CLASS = '3' THEN --债券
                          CONCAT(T6.VC_REPORT_CODE , '.BOND.' ,
                                 (CASE T6.C_MARKET_NO
                                       WHEN '1' THEN 'SH'
                                       WHEN '2' THEN 'SZ' END))
                END)
     END AS SECU_ID, --证券编码
     CASE
          WHEN T6.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T6.C_MARKET_NO = '2' THEN
               'SZ'
          WHEN T6.C_MARKET_NO = 'n' THEN
               'SHSC'
          WHEN T6.C_MARKET_NO = 'o' THEN
               'SZSC'
          WHEN T6.C_MARKET_NO = 'j' THEN
               (CASE NVL(T6.VC_LAYERING,0) WHEN 2 THEN 'BJ' ELSE 'SB' END )
          WHEN T6.C_MARKET_NO = 'r' THEN
               'BJ'
     END AS EXCH_CODE, --交易市场代码
     CASE
          WHEN T5.C_MARKET_NO = '2' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
               NVL(T9.VC_REPORT_CODE,T11.VC_REPORT_CODE) --深交所基金
          WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE <> '159900' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ' --深交所本方资金
          WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('2'),T11.C_TYPE IN ('2')) AND
               T6.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ' --深交所跨境资金
          WHEN T5.C_MARKET_NO = '2' AND NVL(T9.C_TYPE IN ('3'),T11.C_TYPE IN ('3')) AND
               T9.C_ETF_TYPE IN ('4', '7') AND T6.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ' --深交所商品期货、黄金资金
          WHEN T5.C_MARKET_NO = '2' AND T9.C_TYPE IN ('5', '6') AND
               T6.VC_REPORT_CODE = '159900' THEN
               'XCGSZJ' --深交所港市资金
          WHEN T5.C_MARKET_NO = '2' AND T6.VC_REPORT_CODE = '159900' THEN
               'XCSHZJ' --深交所上海市场资金
          WHEN T5.C_MARKET_NO = '1' AND T7.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
               T9.VC_REPORT_CODE --上交所基金
          WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '2' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSHZJ' --上交所本方资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND T9.C_TYPE IN ('2') AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ' --上交所跨境资金，老模式
          WHEN T5.C_MARKET_NO = '1' AND T9.C_TYPE IN ('3') AND
               T9.C_ETF_TYPE IN ('4', '7') AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ' --上交所商品期货、黄金资金，老模式
          WHEN T5.C_MARKET_NO = '1' AND T9.C_TYPE IN ('5', '6') AND
               SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND T6.C_STOCK_TYPE = 'F' THEN
               'XCGSZJ' --上交所港市资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND SUBSTR(T6.VC_REPORT_CODE, -1) = '5' AND
               T6.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ' --上交所深圳市场资金,老模式
          WHEN T5.C_MARKET_NO = '1' AND
               SUBSTR(T6.VC_REPORT_CODE, 1, 2) = 'HS' AND
               T6.C_STOCK_TYPE = 'F' THEN
               (CASE T7.VC_INTER_CODE
                     WHEN 'HSHKZJSS' THEN 'XCGSZJ'
                     WHEN 'HSQTZJSS' THEN 'XCQTZJ'
                     WHEN 'HSSHZJSS' THEN 'XCSHZJ'
                     WHEN 'HSSZZJSS' THEN 'XCSZZJ' END) --上交所资金,新模式
          ELSE
               (CASE
                     WHEN T6.C_ASSET_CLASS = '2' THEN
                          T6.VC_REPORT_CODE
                     WHEN T6.C_ASSET_CLASS = '3' THEN --债券
                          T6.VC_REPORT_CODE
                END)
     END AS SECU_CODE, --证券代码
     T6.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     CASE
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE = '4' AND
               T0.C_SPECIAL_FLAG = '3' THEN
               2
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE = '4' THEN
               1
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE <> '4' THEN
               1
          ELSE
               0
     END AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE, --交易方式
     CASE
          WHEN T4.C_ENTRUST_DIRECTION = 'P' THEN
               '26'
          WHEN T4.C_ENTRUST_DIRECTION = 'Q' THEN
               '27'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               '2'
          ELSE
               '1'
     END AS ODR_PRC_CLAS, --指令价格类型
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               (CASE T7.EN_PRICE1 WHEN 0 THEN  T7.EN_FACT_PRICE ELSE T7.EN_PRICE1 END)
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               0
          ELSE
               (CASE T7.EN_PRICE1 WHEN 0 THEN T7.EN_FACT_PRICE ELSE T7.EN_PRICE1 END )
     END AS ODR_PRC, --指令价格
     NULL AS RAT, --利率
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               T7.L_AMOUNT
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               0
          ELSE
               T7.L_AMOUNT
     END AS ODR_VOL, --指令数量
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               0
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               T7.EN_BALANCE
          ELSE
               0
     END AS ODR_VAL, --指令金额
     T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               0
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               T7.EN_TOTAL_ENTRUST_BALANCE
          ELSE
               0
     END AS BGNG_HAS_ENTR_VAL, --期初已委托金额
     T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               0
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               T7.EN_TOTAL_DEAL_BALANCE
          ELSE
               0
     END AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               0
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               T7.EN_TODAY_ENTRUST_BALANCE
          ELSE
               0
     END AS ENTR_VAL, --当日委托金额
     T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
     CASE
          WHEN T7.C_ENTRUST_DIRECTION in ('P', 'Q') THEN
               0
          WHEN T6.C_STOCK_TYPE in ('F') THEN
               T7.EN_TODAY_DEAL_BALANCE
          ELSE
               0
     END AS TNV_VAL, --当日成交金额
     T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标识
     CASE
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE = '4' AND
               T0.C_SPECIAL_FLAG = '3' THEN  T10.aft_2_dt
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE = '4' THEN T10.aft_1_dt
          WHEN T7.C_ENTRUST_DIRECTION NOT IN ('P', 'Q') AND
               T6.C_STOCK_TYPE = 'F' AND T9.C_TYPE <> '4' THEN T10.aft_1_dt
          ELSE
               GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
     END AS DELI_DT, --交割日期
     T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
     T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
     T0.VC_SUMMARY AS MEMO, --备注
     NULL AS CONT_DAYS, --合约天数
     NULL AS INTA_DAYS, --计息天数
     NULL AS CONT_TNV_DT, --合约成交日期
     NULL AS CONT_END_DT, --合约到期日期
     NULL AS FIR_DELI_DT, --首期交割日期
     NULL AS END_DELI_DT, --到期交割日期
     NULL AS FIR_DELI_MODE, --首期交割方式
     NULL AS END_DELI_MODE, --到期交割方式
     NULL AS BUYB_VAL, --购回金额
     NULL AS INTR, --利息
     NULL AS IN_PRD_CODE, --转入产品代码
     NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
     NULL AS IN_PFL_CODE, --转入投组代码
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ORD_VOL, --转入指令数量
     NULL AS IN_ORD_PRC, --转入指令价格
     NULL AS IN_ORD_VAL, --转入指令金额
     T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS ARBI_FLAG, --套利标志
     CASE
          WHEN T7.C_ENTRUST_DIRECTION IN ('P') THEN
               T4.L_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
          WHEN T7.C_ENTRUST_DIRECTION IN ('Q') THEN
               -T4.L_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
          ELSE
               0
     END AS ESTI_CASH_DIFF, --预估现金差额
     CASE
          WHEN T7.C_ENTRUST_DIRECTION IN ('P', 'Q') AND
               T4.C_ENTRUST_DIRECTION IN ('P', 'Q') THEN
               CASE
                    WHEN T9.C_TYPE IN ('1') AND T9.C_ETF_TYPE IN ('1') THEN
                         '1' --单市场股票ETF
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('1') THEN
                         '2' --跨市场股票ETF(沪深)
                    WHEN T9.C_TYPE IN ('4') AND T9.C_ETF_TYPE IN ('1') AND
                         NVL(T0.C_SPECIAL_FLAG, 0) <> '3' THEN
                         '2' --跨市场股票ETF(沪深)
                    WHEN T9.C_TYPE IN ('4') AND T9.C_ETF_TYPE IN ('1') AND
                         NVL(T0.C_SPECIAL_FLAG, 0) = '3' THEN
                         '3' --跨市场股票ETF(中登)
                    WHEN T9.C_TYPE IN ('7', '9') AND T9.C_ETF_TYPE IN ('1') THEN
                         '4' --跨市场股票ETF(沪深港)
                    WHEN T9.C_TYPE IN ('1') AND T9.C_ETF_TYPE IN ('2') THEN
                         '5' --单市场债券ETF（成分券申赎）
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('2') AND
                         T9.L_ASSET_DEAL_DAYS = 0 THEN
                         '6' --债券ETF(现金申赎)
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('2') AND
                         T9.L_ASSET_DEAL_DAYS = 1 THEN
                         '7' --跨市场债券ETF（成分券申赎）
                    WHEN T9.C_TYPE IN ('2') THEN
                         '8' --跨境ETF
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('4') AND
                         NVL(T0.C_SPECIAL_FLAG, 0) <> '3' THEN
                         '10' --黄金ETF(现金申赎)
                    WHEN T9.C_TYPE IN ('3') AND NVL(T0.C_SPECIAL_FLAG, 0) = '3' THEN
                         '11' --黄金ETF(实物申赎)
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('7') THEN
                         '12' --商品期货ETF
                    WHEN T9.C_TYPE IN ('5', '6') AND T9.C_ETF_TYPE IN ('1') THEN
                         '13' --港股通ETF
               END
          ELSE
               NULL
     END AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
               '4'
          WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
               '5'
          ELSE
               T0.C_INSTRUCTION_STATUS
     END AS ODR_STAT ,--指令状态
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_exch_odr_his_second_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_OPERATOR_NO AS DELR_ID, --交易员
     T0.L_DATE	,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
       INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
         ON T0.P_DT = T4.P_DT
                AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
                AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T7 --成分券\ETF基金
         ON T4.P_DT = T7.P_DT
                AND T4.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
                AND T4.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
                AND T7.VC_INTER_CODE NOT IN ('HSXJCESS', 'HSXJCESZ')
                AND T7.L_AMOUNT <> 0
                AND T7.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T4.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T4.P_DT = T5.P_DT
                AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6
         ON T7.P_DT = T6.P_DT
                AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISETFBASICINFO T9
         ON T0.P_DT = T9.P_DT
                AND T5.VC_REPORT_CODE =T9.VC_ETF_CODE
                AND T9.C_EXEC_TYPE = (case when T0.C_SPECIAL_FLAG = '3' then '2' else '0' end)
                AND T9.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISETFBASICINFO T11
         ON T0.P_DT = T11.P_DT
                AND T5.VC_REPORT_CODE =T11.VC_REPORT_CODE
                AND T11.C_EXEC_TYPE = (case when T0.C_SPECIAL_FLAG = '3' then '2' else '0' end)
                AND T11.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T10
         ON GREATEST(T0.L_BEGIN_DATE, T0.P_DT) = T10.dt
                and T5.C_MARKET_NO= T10.mkt_no
                and T10.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('6')
   AND T4.C_ENTRUST_DIRECTION IN ('P', 'Q')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

 UNION ALL
--指令：网上新股(股转)
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
     T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
     T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
     T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
     T0.L_END_DATE AS ODR_END_DT, --指令结束日期
     T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
     T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
     T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' ,
            (CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                  WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)
          , '_' , (CASE
                        WHEN T4.C_INVEST_TYPE IN ('1') THEN
                             '2' --交易型金融资产
                        WHEN T4.C_INVEST_TYPE IN ('2') THEN
                             '1' --持有到期资产
                        ELSE
                             T4.C_INVEST_TYPE
                   END) , '_' , '05080100') AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     CASE
          WHEN T4.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T4.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T4.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '050801' AS BUSI_TYP, --业务类别
     '05080100' AS BUSI_CLAS, --业务类型
     CONCAT(T6.VC_REPORT_CODE , '.STK.' ,
            (CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                  WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)) AS SECU_ID, --证券编码
     CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
          WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     1 AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE, --交易方式
     '12' AS ENTR_DIR, --委托方向
     CASE
          WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               '2'
          ELSE
               '1'
     END AS ODR_PRC_CLAS, --指令价格类型
     CASE WHEN T4.EN_PRICE1 = 0 THEN T4.EN_FACT_PRICE ELSE T4.EN_PRICE1 END AS ODR_PRC, --指令价格
     NULL AS RAT, --利率
     T4.L_AMOUNT AS ODR_VOL, --指令数量
     T4.EN_BALANCE AS ODR_VAL, --指令金额
     T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
     T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
     T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
     T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
     T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
     T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
     T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
     T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标识
     W1.AFT_1_DT AS DELI_DT, --交割日期
     T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
     T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
     T0.VC_SUMMARY AS MEMO, --备注
     NULL AS CONT_DAYS, --合约天数
     NULL AS INTA_DAYS, --计息天数
     NULL AS CONT_TNV_DT, --合约成交日期
     NULL AS CONT_END_DT, --合约到期日期
     NULL AS FIR_DELI_DT, --首期交割日期
     NULL AS END_DELI_DT, --到期交割日期
     NULL AS FIR_DELI_MODE, --首期交割方式
     NULL AS END_DELI_MODE, --到期交割方式
     NULL AS BUYB_VAL, --购回金额
     NULL AS INTR, --利息
     NULL AS IN_PRD_CODE, --转入产品代码
     NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
     NULL AS IN_PFL_CODE, --转入投组代码
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ORD_VOL, --转入指令数量
     NULL AS IN_ORD_PRC, --转入指令价格
     NULL AS IN_ORD_VAL, --转入指令金额
     T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
               '4'
          WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
               '5'
          ELSE
               T0.C_INSTRUCTION_STATUS
     END AS ODR_STAT, --指令状态
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_exch_odr_his_second_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_OPERATOR_NO AS DELR_ID, --交易员
     T0.L_DATE	,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
       INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
         ON T0.P_DT = T4.P_DT
                AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
                AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T4.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T4.P_DT = T5.P_DT
                AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
                AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.P_DT = T6.P_DT
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3','6')
                AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON GREATEST(T0.L_BEGIN_DATE,T0.P_DT) = W1.dt
                and T5.C_MARKET_NO= W1.mkt_no
                and W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('22')  --网上股转
   AND T4.C_ENTRUST_DIRECTION IN ('C')  --申购
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

 union all
--离线指令：质押式协议回购首期\到期\续作\提前到期\解除质押
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO ,
            '|0|0') AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
     T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
     T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
     T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
     T0.L_END_DATE AS ODR_END_DT, --指令结束日期
     T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
     T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
     T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
            T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REPO.' , CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END , '_' , (CASE
                                                                                                                                                WHEN T4.C_INVEST_TYPE IN ('1') THEN
                                                                                                                                                     '2' --交易型金融资产
                                                                                                                                                WHEN T4.C_INVEST_TYPE IN ('2') THEN
                                                                                                                                                     '1' --持有到期资产
                                                                                                                                                ELSE
                                                                                                                                                     T4.C_INVEST_TYPE
                                                                                                                                           END) , '_' , (CASE
                                                                                                                                                              WHEN T10.L_DAILY_INSTRUCTION_NO IS NOT NULL THEN
                                                                                                                                                                   '02010104' --续作
                                                                                                                                                              WHEN T4.C_ENTRUST_DIRECTION IN ('15', '16') THEN
                                                                                                                                                                   '02010100' --首期
                                                                                                                                                              WHEN T4.C_ENTRUST_DIRECTION IN ('17', '18') THEN
                                                                                                                                                                   '02010101' --到期
                                                                                                                                                              WHEN T4.C_ENTRUST_DIRECTION IN ('37', '38') THEN
                                                                                                                                                                   '02010102' --提前购回
                                                                                                                                                              WHEN T4.C_ENTRUST_DIRECTION IN ('35', '36') THEN
                                                                                                                                                                   '02010105' --解除质押
                                                                                                                                                         END)) AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     CASE
          WHEN T4.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T4.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T4.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '020101' AS BUSI_TYP, --业务类别
     CASE
          WHEN T10.L_DAILY_INSTRUCTION_NO IS NOT NULL THEN
               '02010104' --续作
          WHEN T4.C_ENTRUST_DIRECTION IN ('15', '16') THEN
               '02010100' --首期
          WHEN T4.C_ENTRUST_DIRECTION IN ('17', '18') THEN
               '02010101' --到期
          WHEN T4.C_ENTRUST_DIRECTION IN ('37', '38') THEN
               '02010102' --提前购回
          WHEN T4.C_ENTRUST_DIRECTION IN ('35', '36') THEN
               '02010105' --解除质押
     END AS BUSI_CLAS, --业务类型
     CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) AS SECU_ID, --证券编码
     CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     CASE
          WHEN T4.C_ENTRUST_DIRECTION IN ('15', '17', '37', '35') THEN
               'S'
          WHEN T4.C_ENTRUST_DIRECTION IN ('16', '18', '38', '36') THEN
               'L'
     END AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     0 AS CLR_SPED, --清算速度
     CASE
          WHEN T0.C_BUSIN_CLASS IN ('I') AND T5.C_MARKET_NO = '1' THEN
               '3' --上海固收平台
          WHEN T0.C_BUSIN_CLASS IN ('I') AND T5.C_MARKET_NO = '2' THEN
               '8' --深圳固收平台
     END AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE, --交易方式
     CASE
          WHEN T4.C_ENTRUST_DIRECTION IN ('15') THEN
               '103'
          WHEN T4.C_ENTRUST_DIRECTION IN ('16') THEN
               '104'
          WHEN T4.C_ENTRUST_DIRECTION IN ('17') THEN
               '105'
          WHEN T4.C_ENTRUST_DIRECTION IN ('18') THEN
               '106'
          WHEN T4.C_ENTRUST_DIRECTION IN ('37') THEN
               '113'
          WHEN T4.C_ENTRUST_DIRECTION IN ('38') THEN
               '114'
          WHEN T4.C_ENTRUST_DIRECTION IN ('35') THEN
               '111'
          WHEN T4.C_ENTRUST_DIRECTION IN ('36') THEN
               '112'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               '2'
          ELSE
               '1'
     END AS ODR_PRC_CLAS, --指令价格类型
     100 AS ODR_PRC, --指令价格
     CASE
          WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               T4.EN_DAY_AVG_PRICE / 100
          ELSE
               T4.EN_PRICE1 / 100
     END AS RAT, --利率
     NVL(T9.EN_DEAL_BALANCE,T4.EN_BALANCE) / 100 AS ODR_VOL, --指令数量
     T4.EN_BALANCE AS ODR_VAL, --指令金额
     T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
     T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
     T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
     T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
     T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
     T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
     T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
     T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标识
     NULL AS DELI_DT, --交割日期
     T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
     T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
     T0.VC_SUMMARY AS MEMO, --备注
     T0.L_HG_DAYS AS CONT_DAYS, --合约天数
     datediff(from_unixtime(unix_timestamp(cast(T4.L_SECOND_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd'),
              from_unixtime(unix_timestamp(cast(T4.L_FIRST_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
     T4.L_FIRST_SETTLE_DATE AS CONT_TNV_DT, --合约成交日期
     T4.L_SECOND_SETTLE_DATE AS CONT_END_DT, --合约到期日期
     T4.L_FIRST_SETTLE_DATE AS FIR_DELI_DT, --首期交割日期
     T4.L_SECOND_SETTLE_DATE AS END_DELI_DT, --到期交割日期
     '3' AS FIR_DELI_MODE, --首期交割方式
     '3' AS END_DELI_MODE, --到期交割方式
     ROUND(NVL(T9.EN_DEAL_BALANCE,T4.EN_BALANCE) +
                (datediff(from_unixtime(unix_timestamp(cast(T4.L_SECOND_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd'),
                          from_unixtime(unix_timestamp(cast(T4.L_FIRST_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd'))) * (CASE
                                                                                                                                  WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                                                                                                                                       T4.EN_DAY_AVG_PRICE
                                                                                                                                  ELSE
                                                                                                                                       T4.EN_PRICE1
                                                                                                                             END) / 100 / 365 * NVL(T9.EN_DEAL_BALANCE,T4.EN_BALANCE),
           2) AS BUYB_VAL, --购回金额
     ROUND((datediff(from_unixtime(unix_timestamp(cast(T4.L_SECOND_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd'),
                     from_unixtime(unix_timestamp(cast(T4.L_FIRST_SETTLE_DATE as string),'YYYYMMDD'),'yyyy-MM-dd'))) * (CASE
                                                                                                                             WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                                                                                                                                  T4.EN_DAY_AVG_PRICE
                                                                                                                             ELSE
                                                                                                                                  T4.EN_PRICE1
                                                                                                                        END) / 100 / 365 * NVL(T9.EN_DEAL_BALANCE,T4.EN_BALANCE),
           2) AS INTR, --利息
     NULL AS IN_PRD_CODE, --转入产品代码
     NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
     NULL AS IN_PFL_CODE, --转入投组代码
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ORD_VOL, --转入指令数量
     NULL AS IN_ORD_PRC, --转入指令价格
     NULL AS IN_ORD_VAL, --转入指令金额
     T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
               '4'
          WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
               '5'
          ELSE
               T0.C_INSTRUCTION_STATUS
     END AS ODR_STAT, --指令状态
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_exch_odr_his_second_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_OPERATOR_NO AS DELR_ID, --交易员
     T0.L_DATE	,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
       INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
         ON T0.P_DT = T4.P_DT
                AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
				AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T4.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T4.P_DT = T5.P_DT
                AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
				AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISHGREGISTER T9  --当前和历史回购表的合集
         ON T4.L_BASECOMBI_ID = T9.L_BASECOMBI_ID
                AND T4.VC_INTER_CODE = T9.VC_INTER_CODE
                AND T4.VC_ORIGIN_CONTRACT_NO = T9.Vc_Contract_No
       LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T10
         ON T4.P_DT = T10.P_DT
                AND T4.L_DAILY_INSTRUCTION_NO = T10.L_DAILY_INSTRUCTION_NO
                AND T4.L_BASECOMBI_ID = T10.L_BASECOMBI_ID
                AND T4.L_INDEX_DAILY_MODIFY = T10.L_INDEX_DAILY_MODIFY
                AND T10.C_ENTRUST_DIRECTION IN ('30', '31')  --30：正回购续作；31：逆回购续作
				AND T10.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('I')
   AND T4.C_ENTRUST_DIRECTION IN ('15', '16', '17', '18', '37', '38', '35', '36')
   --15:协议正回购；16：协议逆回购；17:协议正回购到期；16：协议逆回购到期；
   --35  正回购解除质押； 36  逆回购解除质押； 37  正回购提前到期； 38  逆回购提前到期
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

 UNION ALL
--指令：股票红利选择权申报\撤销
SELECT '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|', t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '|0|0') AS trd_src_id, --交易源ID
       t0.l_date AS occu_dt, --发生日期
       date_format(d_datetime,'HHmmss') AS occu_time, --发生时间
       CONCAT(t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '_', t0.l_index_daily_modify) AS odr_onum, --指令序号
       t0.c_instruction_type AS odr_clas, --指令类型
       t0.l_direct_date AS ODR_rela_dt, --指令下达日期
       t0.l_begin_date AS ODR_strt_dt, --指令开始日期
       t0.l_end_date AS ODR_end_dt, --指令结束日期
       t0.l_begin_time AS ODR_strt_time, --指令开始时间
       t0.l_end_time AS ODR_end_time, --指令结束时间
       t0.c_stock_target_type AS odr_ctrl_clas, --指令控制类型
       CONCAT(t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '_', t0.l_index_daily_modify, '_', t4.l_stock_serial_no) AS ODR_secu_onum, --指令证券序号
       CONCAT(t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '_',
              t4.l_basecombi_id, '_', t6.vc_report_code, '.WRNT.',
              (CASE WHEN t5.c_market_no = 'n' THEN 'SHSC' WHEN t5.c_market_no = 'o' THEN 'SZSC' END),
              '_',
              (CASE
                    WHEN t4.c_invest_type IN ('1')
                         THEN
                         '2' --交易型金融资产
                    WHEN t4.c_invest_type IN ('2')
                         THEN
                         '1' --持有到期资产
                    ELSE
                         t4.c_invest_type
               END),
              '_',
              (CASE
                    WHEN t4.c_entrust_direction IN ('20')
                         THEN
                         '43000100'
                    WHEN t4.c_entrust_direction IN ('21')
                         THEN
                         '43000101'
               END)
            ) AS ODR_rela_onum, --指令关联序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       t4.vc_stockholder_id AS sh_code, --股东代码
       CASE
            WHEN t4.c_invest_type IN ('1') THEN
                 '2' --交易型金融资产
            WHEN t4.c_invest_type IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 t4.c_invest_type
       END AS inv_typ, --投资类型
       '430001' AS busi_typ, --业务类别
       CASE
            WHEN t4.c_entrust_direction IN ('20') THEN
                 '43000100'
            WHEN t4.c_entrust_direction IN ('21') THEN
                 '43000101'
       END AS busi_clas, --业务类型
       CONCAT(t6.vc_report_code, '.WRNT.',
              (CASE WHEN t5.c_market_no = 'n' THEN 'SHSC' WHEN t5.c_market_no = 'o' THEN 'SZSC' END)) AS secu_id, --证券编码
       (CASE WHEN t5.c_market_no = 'n' THEN 'SHSC' WHEN t5.c_market_no = 'o' THEN 'SZSC' END) AS exch_code, --交易市场代码
       t5.vc_report_code AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t6.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       'L' AS pos_id, --多空标志
       'CNY' AS curr_code, --货币代码
       0 AS clr_sped, --清算速度
       (CASE
             WHEN t0.c_busin_class IN ('1') THEN
                  'PLAT_BID'
             WHEN t0.c_busin_class = 'I' THEN
                  'PLAT_FIXINC'
             WHEN t0.c_busin_class = 'E' AND t5.c_market_no = '1' THEN
                  'PLAT_BULK'
             WHEN t0.c_busin_class = 'E' AND t5.c_market_no = '2' THEN
                  'PLAT_INTS'
        END) AS trd_plfm, --交易平台
       NULL AS trd_mode, --交易方式
       (CASE
             WHEN t4.c_entrust_direction IN ('20') THEN
                  '97'
             WHEN t4.c_entrust_direction IN ('21') THEN
                  '98'
        END) AS entr_dir, --委托方向
       (CASE
             WHEN t4.c_price_type IN ('4', '5', '6') THEN
                  '2'
             ELSE
                  '1'
        END) AS ODR_prc_clas, --指令价格类型
       (CASE WHEN t4.en_price1 = 0 THEN t4.en_fact_price ELSE t4.en_price1 END) AS ODR_prc, --指令价格
       NULL AS rat, --利率
       t4.l_amount AS ODR_vol, --指令数量
       t4.en_balance AS ODR_val, --指令金额
       t4.l_total_entrust_amount AS bgng_has_entr_vol, --期初已委托数量
       t4.en_total_entrust_balance AS bgng_has_entr_val, --期初已委托金额
       t4.l_total_deal_amount AS bgng_has_tnv_vol, --期初已成交数量
       t4.en_total_deal_balance AS bgng_has_tnv_val, --期初已成交金额
       t4.l_today_entrust_amount AS entr_vol, --当日委托数量
       t4.en_today_entrust_balance AS entr_val, --当日委托金额
       t4.l_today_deal_amount AS tnv_vol, --当日成交数量
       t4.en_today_deal_balance AS tnv_val, --当日成交金额
       t0.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       NULL AS appt_num, --约定号
       NULL AS guar_sett_flag, --担保交收标识
       GREATEST(t0.l_begin_date, t0.l_date) AS deli_dt, --交割日期
       t0.l_direct_operator AS rela_rrsn, --下达人
       t0.l_direct_instead_operator AS agt_rela_rrsn, --代下达人
       t0.vc_summary AS memo, --备注
       NULL AS cont_days, --合约天数
       NULL AS inta_days, --计息天数
       NULL AS cont_tnv_dt, --合约成交日期
       NULL AS cont_end_dt, --合约到期日期
       NULL AS fir_deli_dt, --首期交割日期
       NULL AS end_deli_dt, --到期交割日期
       NULL AS fir_deli_mode, --首期交割方式
       NULL AS end_deli_mode, --到期交割方式
       NULL AS buyb_val, --购回金额
       NULL AS intr, --利息
       NULL AS in_prd_code, --转入产品代码
       NULL AS in_ast_unit_code, --转入资产单元代码
       NULL AS in_pfl_code, --转入投组代码
       NULL AS in_inv_typ, --转入投资类型
       NULL AS in_secu_id, --转入证券编码
       NULL AS in_src_secu_id, --转入源证券ID
       NULL AS in_ord_vol, --转入指令数量
       NULL AS in_ord_prc, --转入指令价格
       NULL AS in_ord_val, --转入指令金额
       t4.vc_rival_seat AS cntp_seat_code, --对手方席位号
       0 AS res_flag, --限售标识
       NULL AS lock_lmt_clas, --锁定受限类型
       NULL AS lmt_clas_onum, --受限类型序号
       NULL AS agmt_num, --合同号
       NULL AS bons_mode, --分红方式
       NULL AS pay_dt, --缴款日期
       NULL AS cont_mult, --合约乘数
       NULL AS arbi_flag, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       (CASE
             WHEN t0.c_instruction_status IN ('5') THEN --审批拒绝
                  '4'
             WHEN t0.c_instruction_status IN ('6') THEN --分发拒绝
                  '5'
             ELSE
                  t0.c_instruction_status
        END) AS ODR_stat, --指令状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_his_second_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION t0
       INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK t4
              ON t0.P_DT = t4.P_DT
              AND t0.l_daily_instruction_no = t4.l_daily_instruction_no
              AND t0.l_index_daily_modify = t4.l_index_daily_modify
			  AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO t1 --产品基本信息表，获取产品代码
              ON t4.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.O3_TCOMBI t3 --投资组合基本信息表，获取投资组合代码
              ON t4.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.O3_TASSET t2 --资产单元基本信息表，获取资产单元代码
              ON t3.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO t5
              ON t4.P_DT = t5.P_DT
              AND t4.vc_inter_code = t5.vc_inter_code
			  AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO t6
              ON t4.P_DT = t6.P_DT
              AND t5.vc_match_relative2_code = t6.vc_inter_code
			  AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE t0.c_busin_class IN ('1', 'I')
   AND t4.c_entrust_direction IN ('20', '21') --20:红利选择权申报；21:红利选择权申报撤销；
   AND t0.c_instruction_status IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND t0.p_dt BETWEEN ${beg_date} and ${end_date}