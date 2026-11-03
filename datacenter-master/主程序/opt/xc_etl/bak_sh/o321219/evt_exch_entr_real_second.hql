------------------------------------------------------------------------
-- 模块名称：交易所委托表(离线)
-- 业务：
--  委托：LOF基金,实时申赎基金认购\申购\赎回
--  委托：20220902 ETF基金申赎_单市场股票、跨市场股票（交易所）、跨市场股票（中登）、跨境\黄金\沪港通\沪深港ETF股票（现金）
--委托：网上新股(股转)
--委托：指定\撤指
--委托：议案投票
--委托：供股权（公开配售）申报\撤销
--委托：分销买入\分销卖出
--委托：股票红利选择权申报\撤销
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

insert into ${dwd_db}.evt_exch_entr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,entr_onum,entr_btno,whdw_entr_onum,rep_id,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,trd_plfm,trd_mode,entr_dir,entr_prc_clas,entr_vol,whdw_vol,entr_prc,busi_typ,busi_clas,rat,entr_val,entr_tot_fee,oper_no,trd_cntp_id,appt_num,guar_sett_flag,deli_dt,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,buyb_val,intr,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_entr_vol,in_entr_prc,in_entr_val,cntp_seat_code,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,bons_mode,pay_dt,cont_mult,covr_dir,arbi_flag,etf_onum,esti_cash_diff,etf_fnd_clas,entr_stat,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--委托：LOF基金,实时申赎基金认购\申购\赎回
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
                      T0.L_BASECOMBI_ID , '_' ,
                      CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                             CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) , '_' , (CASE
                                                                                                                             WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                                                                                  '2' --交易型金融资产
                                                                                                                             WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                                                                                  '1' --持有到期资产
                                                                                                                             ELSE
                                                                                                                                  T0.C_INVEST_TYPE
                                                                                                                        END) , '_' , (CASE
                                                                                                                                           WHEN T0.C_ENTRUST_DIRECTION = 'D' AND T4.VC_REPORT_CODE IS NULL THEN
                                                                                                                                                '30000100'
                                                                                                                                           WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NULL THEN
                                                                                                                                                '31000100'
                                                                                                                                           WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NULL THEN
                                                                                                                                                '32000100'
                                                                                                                                           WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NOT NULL THEN
                                                                                                                                                '38000100'
                                                                                                                                           WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NOT NULL THEN
                                                                                                                                                '38000101'
                                                                                                                                      END))
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
            CASE
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
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     CASE
          WHEN T0.C_ENTRUST_DIRECTION = 'D' THEN
               '13'
          WHEN T0.C_ENTRUST_DIRECTION = 'p' THEN
               '53'
          WHEN T0.C_ENTRUST_DIRECTION = 'q' THEN
               '54'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               CASE WHEN T7.C_LIMIT_PRICE= 0 THEN '2' ELSE T7.C_LIMIT_PRICE END
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               CASE WHEN T0.EN_ENTRUST_PRICE = 0 THEN T0.EN_FACT_PRICE ELSE T0.EN_ENTRUST_PRICE END
     END AS ENTR_PRC, --委托价格
     CASE
          WHEN T0.C_ENTRUST_DIRECTION = 'D' AND T4.VC_REPORT_CODE IS NULL THEN
               '300001'
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NULL THEN
               '310001'
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NULL THEN
               '320001'
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               '380001'
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               '380001'
     END AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_ENTRUST_DIRECTION = 'D' AND T4.VC_REPORT_CODE IS NULL THEN
               '30000100'
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NULL THEN
               '31000100'
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NULL THEN
               '32000100'
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               '38000100'
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               '38000101'
     END AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     CASE
          WHEN T0.C_ENTRUST_DIRECTION = 'D' AND T5.C_MARKET_NO = '1' THEN
               w1.aft_2_dt
          WHEN T0.C_ENTRUST_DIRECTION = 'D' AND T5.C_MARKET_NO = '2' THEN
               w1.aft_1_dt
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NULL THEN
               T0.L_DATE
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NULL THEN
               T0.L_DATE
          WHEN T0.C_ENTRUST_DIRECTION = 'p' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               w1.aft_1_dt
          WHEN T0.C_ENTRUST_DIRECTION = 'q' AND T4.VC_REPORT_CODE IS NOT NULL THEN
               w1.aft_1_dt
     END AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TETFBASICINFO T4
         ON T5.VC_REPORT_CODE = T4.VC_REPORT_CODE
                AND T5.L_DATE = T4.L_DATE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T0.L_DATE = W1.dt
                AND T5.C_MARKET_NO = W1.mkt_no
                AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('5')
   AND T0.C_ENTRUST_DIRECTION IN ('D', 'p', 'q')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

 UNION ALL
--委托：20220902 ETF基金申赎_单市场股票、跨市场股票（交易所）、跨市场股票（中登）、跨境\黄金\沪港通\沪深港ETF股票（现金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(cast(T0.L_ENTRUST_TIME as string),'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
          T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
                      T0.L_BASECOMBI_ID , '_' , (
                           CASE
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0 THEN
                                     CONCAT(T9.VC_REPORT_CODE , '.FUND.SZ') --深交所基金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T5.VC_REPORT_CODE <> '159900' THEN
                                     'XCSZZJ.CASH.SZ' --深交所本方资金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('2') AND
                                     T5.VC_REPORT_CODE = '159900' THEN
                                     'XCQTZJ.CASH.SZ' --深交所跨境资金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('3') AND
                                     T9.C_ETF_TYPE IN ('4', '7') AND T5.VC_REPORT_CODE = '159900' THEN
                                     'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('5', '6') AND
                                     T5.VC_REPORT_CODE = '159900' THEN
                                     'XCGSZJ.CASH.SZ' --深交所港市资金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.VC_REPORT_CODE = '159900' THEN
                                     'XCSHZJ.CASH.SZ' --深交所上海市场资金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0  THEN
                                     CONCAT(T9.VC_REPORT_CODE , '.FUND.SH') --上交所基金
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '2' AND
                                     T5.C_STOCK_TYPE = 'F' THEN
                                     'XCSHZJ.CASH.SH' --上交所本方资金,老模式
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('2') AND
                                     SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
                                     'XCQTZJ.CASH.SH' --上交所跨境资金，老模式
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('3') AND
                                     T9.C_ETF_TYPE IN ('4', '7') AND
                                     SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
                                     'XCQTZJ.CASH.SH' --上交所商品期货、黄金资金，老模式
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('5', '6') AND
                                     SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
                                     'XCGSZJ.CASH.SH' --上交所港市资金,老模式
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND
                                     T5.C_STOCK_TYPE = 'F' THEN
                                     'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
                                WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND
                                     SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' AND
                                     T5.C_STOCK_TYPE = 'F' THEN
                                     CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                                          WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                                          WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                                          WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END --上交所资金,新模式
                                ELSE
                                     (CASE
                                           WHEN T5.C_ASSET_CLASS = '2' THEN
                                                CONCAT(T5.VC_REPORT_CODE , '.STK.' , --股票
                                                       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                            WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                                            WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                                                            WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' end)
                                           WHEN T5.C_ASSET_CLASS = '3' THEN --债券
                                                CONCAT(T5.VC_REPORT_CODE , '.BOND.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                                      END)
                           END
                           ) , '_' , (CASE
                                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                '2' --交易型金融资产
                                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                '1' --持有到期资产
                                           ELSE
                                                T0.C_INVEST_TYPE
                                      END) , '_' , (CASE
                                                         WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <>0 AND T0.C_ENTRUST_DIRECTION = 'P' THEN
                                                              '37000100'  --ETF基金申购_基金
                                                         WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T0.C_ENTRUST_DIRECTION = 'P' THEN
                                                              '37000102'  --ETF基金申购_现金替代
                                                         WHEN T0.C_ENTRUST_DIRECTION = 'P'  THEN
                                                              '37000101'  --ETF基金申购_成分券
                                                         WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <>0 AND T0.C_ENTRUST_DIRECTION = 'Q' THEN
                                                              '37000103'  --ETF基金赎回_基金
                                                         WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T0.C_ENTRUST_DIRECTION = 'Q' THEN
                                                              '37000105'  --ETF基金赎回_现金替代
                                                         WHEN T0.C_ENTRUST_DIRECTION = 'Q'  THEN
                                                              '37000104'  --ETF基金赎回_成分券
                                                    END))
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0 THEN
               CONCAT(T9.VC_REPORT_CODE , '.FUND.SZ') --深交所基金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T5.VC_REPORT_CODE <> '159900' THEN
               'XCSZZJ.CASH.SZ' --深交所本方资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('2') AND
               T5.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ.CASH.SZ' --深交所跨境资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('3') AND
               T9.C_ETF_TYPE IN ('4', '7') AND T5.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('5', '6') AND
               T5.VC_REPORT_CODE = '159900' THEN
               'XCGSZJ.CASH.SZ' --深交所港市资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.VC_REPORT_CODE = '159900' THEN
               'XCSHZJ.CASH.SZ' --深交所上海市场资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0  THEN
               CONCAT(T9.VC_REPORT_CODE , '.FUND.SH') --上交所基金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '2' AND
               T5.C_STOCK_TYPE = 'F' THEN
               'XCSHZJ.CASH.SH' --上交所本方资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('2') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ.CASH.SH' --上交所跨境资金，老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('3') AND
               T9.C_ETF_TYPE IN ('4', '7') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ.CASH.SH' --上交所商品期货、黄金资金，老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('5', '6') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCGSZJ.CASH.SH' --上交所港市资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND
               T5.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND
               SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' AND
               T5.C_STOCK_TYPE = 'F' THEN
               CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END --上交所资金,新模式
          ELSE
               (CASE
                     WHEN T5.C_ASSET_CLASS = '2' THEN
                          CONCAT(T5.VC_REPORT_CODE , '.STK.' , --股票
                                 CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                      WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                      WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                      WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                      WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                                      WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)
                     WHEN T5.C_ASSET_CLASS = '3' THEN --债券
                          CONCAT(T5.VC_REPORT_CODE , '.BOND.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                END)
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
          WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
          WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
          WHEN T5.C_MARKET_NO = 'j' THEN
               CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
          WHEN T5.C_MARKET_NO = 'r' THEN
               'BJ'
     END AS EXCH_CODE, --交易市场代码
     CASE
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0 THEN
               T9.VC_REPORT_CODE --深交所基金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.C_STOCK_TYPE = 'F' AND T5.VC_REPORT_CODE <> '159900' THEN
               'XCSZZJ' --深交所本方资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('2') AND
               T5.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ' --深交所跨境资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('3') AND
               T9.C_ETF_TYPE IN ('4', '7') AND T5.VC_REPORT_CODE = '159900' THEN
               'XCQTZJ' --深交所商品期货、黄金资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T9.C_TYPE IN ('5', '6') AND
               T5.VC_REPORT_CODE = '159900' THEN
               'XCGSZJ' --深交所港市资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SZ') AND T5.VC_REPORT_CODE = '159900' THEN
               'XCSHZJ' --深交所上海市场资金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T5.C_STOCK_TYPE = 'F' AND T4.L_ENTRUST_AMOUNT <> 0  THEN
               T9.VC_REPORT_CODE --上交所基金
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '2' AND
               T5.C_STOCK_TYPE = 'F' THEN
               'XCSHZJ' --上交所本方资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('2') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ' --上交所跨境资金，老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('3') AND
               T9.C_ETF_TYPE IN ('4', '7') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCQTZJ' --上交所商品期货、黄金资金，老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND T9.C_TYPE IN ('5', '6') AND
               SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND T5.C_STOCK_TYPE = 'F' THEN
               'XCGSZJ' --上交所港市资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND SUBSTR(T5.VC_REPORT_CODE, -1) = '5' AND
               T5.C_STOCK_TYPE = 'F' THEN
               'XCSZZJ' --上交所深圳市场资金,老模式
          WHEN SUBSTR(T0.VC_INTER_CODE, -2) IN ('SS') AND
               SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' AND
               T5.C_STOCK_TYPE = 'F' THEN
               CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                    WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END --上交所资金,新模式
          ELSE
               (CASE
                     WHEN T5.C_ASSET_CLASS = '2' THEN
                          T5.VC_REPORT_CODE
                     WHEN T5.C_ASSET_CLASS = '3' THEN --债券
                          T5.VC_REPORT_CODE
                END)
     END AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               'HKD'
          ELSE
               'CNY'
     END AS CURR_CODE, --货币代码
     CASE WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE = '4' AND T0.C_PRICE_TYPE = 'S' THEN
               2
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE = '4'  THEN
               1
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE <> '4' THEN
               1
          ELSE
               0
     END AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     CASE WHEN T0.C_ENTRUST_DIRECTION = 'P' THEN
               '26'
          WHEN T0.C_ENTRUST_DIRECTION = 'Q' THEN
               '27'
     END AS ENTR_DIR, --委托方向
     CASE WHEN T0.C_ENTRUST_DIRECTION = 'P' THEN
               '26'
          WHEN T0.C_ENTRUST_DIRECTION = 'Q' THEN
               '27'
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               CASE WHEN T5.C_STOCK_TYPE = 'F' THEN T4.L_ENTRUST_AMOUNT ELSE T4.L_TOTAL_AMOUNT END
     END AS ENTR_VOL, --委托数量
     0 AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T4.EN_ENTRUST_PRICE
     END AS ENTR_PRC, --委托价格
     '370001' AS BUSI_TYP, --业务类别
     CASE
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <>0 AND T0.C_ENTRUST_DIRECTION = 'P' THEN
               '37000100'  --ETF基金申购_基金
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T0.C_ENTRUST_DIRECTION = 'P'  THEN
               '37000102'  --ETF基金申购_现金替代
          WHEN T0.C_ENTRUST_DIRECTION = 'P'  THEN
               '37000101'  --ETF基金申购_成分券
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <>0 AND T0.C_ENTRUST_DIRECTION = 'Q' THEN
               '37000103'  --ETF基金赎回_基金
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T0.C_ENTRUST_DIRECTION = 'Q'  THEN
               '37000105'  --ETF基金赎回_现金替代
          WHEN T0.C_ENTRUST_DIRECTION = 'Q'  THEN
               '37000104'  --ETF基金赎回_成分券
     END AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <> 0 THEN
               0
          WHEN (T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0)  THEN
               T4.EN_TOTAL_BALANCE
          ELSE
               0
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     CASE WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE = '4' AND T0.C_PRICE_TYPE = 'S' THEN
               w1.aft_2_dt
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE = '4'  THEN
               w1.aft_1_dt
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT = 0 AND T9.C_TYPE <> '4' THEN
               w1.aft_1_dt
          ELSE
               T0.L_DATE
     END AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     T4.L_ETFENTRUST_SERIAL_NO AS ETF_ONUM, --ETF序号
     CASE WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <> 0 AND T0.C_ENTRUST_DIRECTION = 'P' THEN
               T0.L_ENTRUST_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
          WHEN T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <> 0 AND T0.C_ENTRUST_DIRECTION = 'Q' THEN
               - T0.L_ENTRUST_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
          ELSE 0
     END AS ESTI_CASH_DIFF, --预估现金差额
     CASE WHEN  T5.C_STOCK_TYPE in ('F') AND T4.L_ENTRUST_AMOUNT <> 0 AND T0.C_ENTRUST_DIRECTION IN ('P', 'Q')
               THEN
               CASE WHEN T9.C_TYPE IN ('1') AND T9.C_ETF_TYPE IN ('1') THEN '1'  --单市场股票ETF
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('1') THEN '2'  --跨市场股票ETF(沪深)
                    WHEN T9.C_TYPE IN ('4') AND T9.C_ETF_TYPE IN ('1') AND NVL(T0.C_PRICE_TYPE, 0) <> 'S' THEN '2'  --跨市场股票ETF(沪深)
                    WHEN T9.C_TYPE IN ('4') AND T9.C_ETF_TYPE IN ('1') AND NVL(T0.C_PRICE_TYPE, 0) = 'S' THEN '3'  --跨市场股票ETF(中登)
                    WHEN T9.C_TYPE IN ('7', '9') AND T9.C_ETF_TYPE IN ('1') THEN '4'  --跨市场股票ETF(沪深港)
                    WHEN T9.C_TYPE IN ('1') AND T9.C_ETF_TYPE IN ('2') THEN '5'  --单市场债券ETF（成分券申赎）
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('2') AND L_ASSET_DEAL_DAYS = 0 THEN '6'  --债券ETF(现金申赎)
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('2') AND L_ASSET_DEAL_DAYS = 1 THEN '7'  --跨市场债券ETF（成分券申赎）
                    WHEN T9.C_TYPE IN ('2')  THEN '8'  --跨境ETF
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('4') AND NVL(T0.C_PRICE_TYPE, 0) <> 'S' THEN '10'  --黄金ETF(现金申赎)
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('4') AND NVL(T0.C_PRICE_TYPE, 0) = 'S' THEN '11'  --黄金ETF(实物申赎)
                    WHEN T9.C_TYPE IN ('3') AND T9.C_ETF_TYPE IN ('7') THEN '12'  --商品期货ETF
                    WHEN T9.C_TYPE IN ('5', '6') AND T9.C_ETF_TYPE IN ('1') THEN '13'  --港股通ETF
               END
          ELSE
               NULL
     END AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TETFENTRUST T4
         ON T0.L_DATE = T4.L_DATE
                AND T0.L_ENTRUST_SERIAL_NO = T4.L_ENTRUST_SERIAL_NO
       --AND CONCAT(CASE WHEN T4.C_STOCK_TYPE = 'F' THEN 'A' ELSE 'B' END,CASE WHEN T4.L_TOTAL_AMOUNT = 0 THEN 'B' ELSE 'A' END) <> 'BB'
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T4.L_DATE = T5.L_DATE
                AND T4.VC_REALDEAL_CODE = T5.VC_REPORT_CODE
                AND T4.C_STOCK_TYPE = T5.C_STOCK_TYPE
                AND T4.C_MARKET_NO = T5.C_MARKET_NO
       LEFT JOIN ${ods_db}.O3_TETFBASICINFO T9
         ON T0.L_DATE = T9.L_DATE
              --AND CASE WHEN T4.C_STOCK_TYPE = 'F' THEN T4.VC_REPORT_CODE ELSE T5.VC_REPORT_CODE END = CASE WHEN T4.VC_REPORT_CODE = T9.VC_ETF_CODE THEN T9.VC_ETF_CODE ELSE T9.VC_REPORT_CODE END
                AND CASE WHEN T0.C_PRICE_TYPE = 'S' THEN '2' ELSE '0' END = T9.C_EXEC_TYPE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T0.L_DATE = W1.dt
                AND T5.C_MARKET_NO = W1.mkt_no
                AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('6')
   AND T0.C_ENTRUST_DIRECTION IN ('P','Q')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

UNION ALL
--委托：网上新股(股转)
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
          T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' ,
                      CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                           WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END , '_' , (CASE
                                                                                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                                      '2' --交易型金融资产
                                                                                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                                      '1' --持有到期资产
                                                                                 ELSE
                                                                                      T0.C_INVEST_TYPE
                                                                            END) , '_' , '05080100' )
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CONCAT(T6.VC_REPORT_CODE , '.STK.' ,
            CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END) AS SECU_ID, --证券编码
     CASE WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
          WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     1 AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     '12' AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               CASE WHEN T7.C_LIMIT_PRICE = 0 THEN '2' ELSE T7.C_LIMIT_PRICE END
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               CASE WHEN T0.EN_ENTRUST_PRICE = 0 THEN T0.EN_FACT_PRICE ELSE T0.EN_ENTRUST_PRICE END
     END AS ENTR_PRC, --委托价格
     '050801' AS BUSI_TYP, --业务类别
     '05080100' AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     W1.AFT_1_DT AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS,--ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE	 as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3','6')
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T0.L_DATE = W1.dt
                and T5.C_MARKET_NO= W1.mkt_no
                and W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('22')
   AND T0.C_ENTRUST_DIRECTION IN ('C')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

UNION ALL
--委托：指定\撤指
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.QT.SH' , '_' ,
                      (CASE
                            WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                 '2' --交易型金融资产
                            WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                 '1' --持有到期资产
                            ELSE
                                 T0.C_INVEST_TYPE
                       END) , '_' , (CASE
                                          WHEN T0.C_ENTRUST_DIRECTION IN ('H') THEN
                                               '25000200'
                                          WHEN T0.C_ENTRUST_DIRECTION IN ('I') THEN
                                               '25000201'
                                     END))
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T5.VC_REPORT_CODE , '.QT.SH') AS SECU_ID, --证券编码
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
     0 AS CLR_SPED, --清算速度
     'PLAT_BID' AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('H') THEN
               '18'
          WHEN T0.C_ENTRUST_DIRECTION in ('I') THEN
               '19'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     1 AS ENTR_PRC, --委托价格
     '250002' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('H') THEN
               '25000200'
          WHEN T0.C_ENTRUST_DIRECTION in ('I') THEN
               '25000201'
     END AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     0 AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     T0.L_DATE AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE  as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('H', 'I')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

 UNION ALL
--委托：议案投票
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' , --股票
                      (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
                                                                                                                       WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                                                                            '2' --交易型金融资产
                                                                                                                       WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                                                                            '1' --持有到期资产
                                                                                                                       ELSE
                                                                                                                            T0.C_INVEST_TYPE
                                                                                                                  END) , '_' , '29000100')
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T6.VC_REPORT_CODE , '.STK.' , --股票
            (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     0 AS CLR_SPED, --清算速度
     'PLAT_BID' AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     '25' AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_ENTRUST_PRICE
     END AS ENTR_PRC, --委托价格
     '290001' AS BUSI_TYP, --业务类别
     '29000100' AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     T0.L_DATE AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_5' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
         ON T0.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('O')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

 UNION ALL
--委托：供股权（公开配售）申报\撤销
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
               T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.WRNT.' , --权证
                      (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end) , '_' , (CASE
                                                                                                                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                                                                                '2' --交易型金融资产
                                                                                                                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                                                                                '1' --持有到期资产
                                                                                                                           ELSE
                                                                                                                                T0.C_INVEST_TYPE
                                                                                                                      END) , '_' , (CASE
                                                                                                                                         WHEN T0.C_ENTRUST_DIRECTION = '9' THEN
                                                                                                                                              '06000103'
                                                                                                                                         WHEN T0.C_ENTRUST_DIRECTION = '19' THEN
                                                                                                                                              '06000104'
                                                                                                                                    END))
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T6.VC_REPORT_CODE , '.WRNT.' , --权证
            (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end)) AS SECU_ID, --证券编码
     case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
     NULL AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     CASE WHEN T0.C_ENTRUST_DIRECTION = '9' THEN
               '9'
          WHEN T0.C_ENTRUST_DIRECTION = '19' THEN
               '96'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end)
     END AS ENTR_PRC, --委托价格
     '060001' AS BUSI_TYP, --业务类别
     CASE WHEN T0.C_ENTRUST_DIRECTION = '9' THEN
               '06000103'
          WHEN T0.C_ENTRUST_DIRECTION = '19' THEN
               '06000106'
     END AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     w2.aft_1_dt AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     concat(T8.VC_REPORT_CODE , '.WRNT.' , --权证
            (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end)) AS IN_SECU_ID, --转入证券内码
     T8.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入证券编码
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     w1.aft_1_dt AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_6' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('7','6', '3', '2')
                AND T5.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_FROZEN_CODE = T6.VC_INTER_CODE
                AND T6.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T8 --证券基本信息表，获取股票代码
         ON T5.L_DATE = T8.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T8.VC_INTER_CODE
                AND T8.C_ASSET_CLASS IN ('2', '3', '6')
                AND T8.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
       LEFT JOIN ${ods_db}.O3_THKTZXXINFO T9  --当前表和历史表取合集
         ON T8.VC_REPORT_CODE = T9.ZQDM
                AND T9.TZLB IN ('H13', 'H14')
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T9.RQ3 = w1.dt
                AND T5.C_MARKET_NO = w1.mkt_no
                AND W1.SYS_RS_ID = 'O3'
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W2
         ON w1.aft_1_dt = w2.dt
                AND T5.C_MARKET_NO = w2.mkt_no
                AND W2.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('9','19')
   AND T5.C_MARKET_NO IN ('n','o')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE >= T9.RQ2
   AND T0.L_DATE <= T9.RQ3
   AND T0.L_DATE = ${current_date}

 UNION ALL
--委托：分销买入\分销卖出
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|', T0.L_DATE, '_HSO32', '_', T0.L_ENTRUST_SERIAL_NO, '|0')
          ELSE
               CONCAT('0|', T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
     T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
     CASE
          WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_CANCEL_SERIAL_NO)
     END AS WHDW_ENTR_ONUM, --被撤单委托序号
     T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
     CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR T0.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '_',
                      T0.L_BASECOMBI_ID, '_',
                      (CASE
                            WHEN T6.C_ASSET_CLASS = '3' THEN --债券
                                 CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
                       END), '_',
                      (CASE
                            WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                 '2' --交易型金融资产
                            WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                 '1' --持有到期资产
                            ELSE
                                 T0.C_INVEST_TYPE
                       END), '_',
                      (CASE
                            WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
                                 '01000102'
                            WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
                                 '01000103'
                       END)
                    )
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T6.C_ASSET_CLASS = '3' THEN --债券
               CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
     CASE
          WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
     END AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '21'
          WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '22'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
               '31'
          WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
               '14'
          ELSE
               (CASE WHEN T7.C_LIMIT_PRICE = 0 THEN '2' ELSE T7.C_LIMIT_PRICE END)
     END AS ENTR_PRC_CLAS, --委托价格类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_ENTRUST_AMOUNT
     END AS ENTR_VOL, --委托数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.L_CANCEL_AMOUNT
     END AS WHDW_VOL, --撤单数量
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               (CASE WHEN T0.EN_ENTRUST_PRICE = 0 THEN T0.EN_FACT_PRICE ELSE T0.EN_ENTRUST_PRICE END)
     END AS ENTR_PRC, --委托价格
     '010001' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '01000102'
          WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '01000103'
     END AS BUSI_CLAS, --业务类型
     NULL AS RAT, --利率
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS ENTR_VAL, --委托金额
     0 AS ENTR_TOT_FEE, --委托总费用
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
     NULL AS APPT_NUM, --约定号
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     --SF_OFFSET_TRADEDAY(T0.L_DATE, 1, 2, T5.C_MARKET_NO, 2) AS DELI_DT, --交割日期
     T8.AFT_1_DT AS DELI_DT, --交割日期
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
     NULL AS IN_SH_CODE, --转入股东代码
     NULL AS IN_SEAT_CODE, --转入席位号
     NULL AS IN_INV_TYP, --转入投资类型
     NULL AS IN_SECU_ID, --转入证券编码
     NULL AS IN_SRC_SECU_ID, --转入源证券ID
     NULL AS IN_ENTR_VOL, --转入委托数量
     NULL AS IN_ENTR_PRC, --转入委托价格
     NULL AS IN_ENTR_VAL, --转入委托金额
     T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
     0 AS RES_FLAG, --限售标识
     NULL AS LOCK_LMT_CLAS, --锁定受限类型
     NULL AS LMT_CLAS_ONUM, --受限类型序号
     NULL AS AGMT_NUM, --合同号
     NULL AS BONS_MODE, --分红方式
     NULL AS PAY_DT, --缴款日期
     NULL AS CONT_MULT, --合约乘数
     NULL AS COVR_DIR, --平仓方向
     NULL AS ARBI_FLAG, --套利标志
     NULL AS ETF_ONUM, --ETF序号
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     CASE
          WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
               THEN
               '1'
          WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
               THEN
               '2'
          WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
               THEN
               '3'
          WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
               THEN
               '4'
          WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
               THEN
               '5'
          WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
               THEN
               '6'
          WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
               THEN
               '7'
          WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
               THEN
               '8'
     END AS ENTR_STAT, --委托状态
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_exch_entr_real_second_7' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
         ON T0.L_DATE = T6.L_DATE
                AND T5.VC_MATCH_RELATIVE2_CODE = T6.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T0.C_MARKET_NO = T7.C_MARKET_NO
                AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
       LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE T8
         ON T0.L_DATE = T8.DT
                AND T5.C_MARKET_NO = T8.MKT_NO
                AND T8.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('r', 'L')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}

 UNION ALL
--委托：股票红利选择权申报\撤销
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       (CASE
             WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
                  T0.L_DAILY_INSTRUCTION_NO = 0 THEN
                  CONCAT('0|0|', T0.L_DATE, '_HSO32', '_', T0.L_ENTRUST_SERIAL_NO, '|0')
             ELSE
                  CONCAT('0|', T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '|0|0')
        END) AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       (CASE
             WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
                  NULL
             ELSE
                  CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_CANCEL_SERIAL_NO)
        END) AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       (CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
            T0.L_DAILY_INSTRUCTION_NO = 0 THEN
                  NULL
             ELSE
                  CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '_',
                         T0.L_BASECOMBI_ID, '_',
                         T6.VC_REPORT_CODE, '.WRNT.',
                         (CASE WHEN t6.c_market_no = 'n' THEN 'SHSC' WHEN t6.c_market_no = 'o' THEN 'SZSC' END), '_',
                         (CASE
                               WHEN t0.c_invest_type IN ('1') THEN
                                    '2' --交易型金融资产
                               WHEN t0.c_invest_type IN ('2') THEN
                                    '1' --持有到期资产
                               ELSE
                                    t0.c_invest_type
                          END), '_',
                         (CASE
                               WHEN t0.c_entrust_direction IN ('20') THEN
                                    '43000100'
                               WHEN t0.c_entrust_direction IN ('21') THEN
                                    '43000101'
                          END)
                       )
        END) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       (CASE
             WHEN T0.C_INVEST_TYPE IN ('1') THEN
                  '2' --交易型金融资产
             WHEN T0.C_INVEST_TYPE IN ('2') THEN
                  '1' --持有到期资产
             ELSE
                  T0.C_INVEST_TYPE
        END) AS INV_TYP, --投资类型
       CONCAT(T6.VC_REPORT_CODE, '.WRNT.', (CASE WHEN T6.C_MARKET_NO = 'n' THEN 'SHSC' WHEN T6.C_MARKET_NO = 'o' THEN 'SZSC' END)) AS SECU_ID, --证券编码
       (CASE WHEN T6.C_MARKET_NO = 'n' THEN 'SHSC' WHEN T6.C_MARKET_NO = 'o' THEN 'SZSC' END) AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       (CASE
             WHEN T0.C_BUSIN_CLASS IN ('1') THEN
                  'PLAT_BID'
             WHEN T0.C_BUSIN_CLASS = 'I' THEN
                  'PLAT_FIXINC'
        END) AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE,--交易方式
       (CASE
             WHEN T0.C_ENTRUST_DIRECTION in ('20') THEN
                  '97'
             WHEN T0.C_ENTRUST_DIRECTION in ('21') THEN
                  '98'
        END) AS ENTR_DIR, --委托方向
       (CASE
             WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
                  '31'
             WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
                  '14'
             ELSE
                  (CASE WHEN T7.C_LIMIT_PRICE = 0 THEN '2' ELSE T7.C_LIMIT_PRICE END)
        END) AS ENTR_PRC_CLAS, --委托价格类型
       (CASE
             WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
                  0
             ELSE
                  T0.L_ENTRUST_AMOUNT
        END) AS ENTR_VOL, --委托数量
       (CASE
             WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
                  0
             ELSE
                  T0.L_CANCEL_AMOUNT
        END) AS WHDW_VOL, --撤单数量
       0 AS ENTR_PRC, --委托价格
       '430001' AS BUSI_TYP, --业务类别
       (CASE
             WHEN T0.C_ENTRUST_DIRECTION in ('20') THEN
                  '43000100'
             WHEN T0.C_ENTRUST_DIRECTION in ('21') THEN
                  '43000101'
        END) AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       0 AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       (CASE
             WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
                  THEN
                  '1'
             WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
                  THEN
                  '2'
             WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
                  THEN
                  '3'
             WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
                  THEN
                  '4'
             WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
                  THEN
                  '5'
             WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
                  THEN
                  '6'
             WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
                  THEN
                  '7'
             WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
                  THEN
                  '8'
        END) AS ENTR_STAT, --委托状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_real_second_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TENTRUSTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
              ON T0.L_DATE = T5.L_DATE
              AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
              ON T0.L_DATE = T6.L_DATE
              AND T5.VC_MATCH_RELATIVE2_CODE = T6.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
              ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
              AND T0.C_MARKET_NO = T7.C_MARKET_NO
              AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.C_ENTRUST_DIRECTION IN ('20', '21') --20:红利选择权申报；21:红利选择权申报撤销
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.L_DATE = ${current_date}