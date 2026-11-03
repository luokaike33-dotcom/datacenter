------------------------------------------------------------------------
-- 模块名称：交易所清算流水(盘后)
-- 业务：
--离线清算：转融券新开\转融券到期\转融券提前了结\转融券资金权益除权\转融券资金权益到账\转融券证券权益除权\转融券证券权益到账
--离线清算：转融券展期新开
--离线清算：债转股（债券转出）\债转股（股票转入）
--供股权（公开配售）申报确认
--供股权（公开配售）缴款
--证券组合费
--清算：分销买入\分销卖出
--清算：实时申赎货币基金
--成交：20220902ETF申购_基金、成分券_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）
--成交：20220902ETF申购_现金替代_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）只含申购部分
--成交：20220902 ETF现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
--20220902 跨市场ETF(中登)确认_ETF申购_基金、成分券、现金替代
--20220902:跨市场ETF(中登)成交_ETF申购_基金、成分券、现金替代、现金差额退补、现金替代退补
--清算：网上申购（北交所）确认、中签
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

WITH VHISPENDSETTLE AS (
    SELECT  L_SERIAL_NO,
            L_ENTRUST_SERIAL_NO,
            L_trade_DATE,
            VC_ORIGINAL_NO,
            C_ENTRUST_DIRECTION,
            VC_DEAL_NO,
            l_Relate_No,
            VC_INTER_CODE,
            L_BASECOMBI_ID,
            L_SETTLE_DATE
    FROM ${ods_db}.O3_THISPENDSETTLE
    WHERE C_STATUS = '1'
    UNION ALL
    SELECT L_SERIAL_NO,
           L_ENTRUST_SERIAL_NO,
           L_trade_DATE,
           VC_ORIGINAL_NO,
           C_ENTRUST_DIRECTION,
           VC_DEAL_NO,
           l_Relate_No,
           VC_INTER_CODE,
           L_BASECOMBI_ID,
           L_SETTLE_DATE
    FROM ${ods_db}.O3_TPENDSETTLE
    WHERE C_STATUS = '1'
),
     VHISUNCOMPLETELOG AS (
         SELECT
             L_TRADE_DATE,
             L_SERIAL_NO,
             VC_STOCKHOLDER_ID,
             VC_SEAT_ID,
             C_INVEST_TYPE,
             L_AMOUNT,
             EN_BANLANCE,
             C_ENTRUST_DIRECTION,
             C_BUSIN_CLASS,
             L_FUND_ID,
             L_ASSET_ID,
             L_BASECOMBI_ID,
             VC_INTER_CODE,
             L_BUSIN_FLAG,
             VC_DEAL_NO,
             L_COMPLETE_DATE
         FROM ${ods_db}.O3_TUNCOMPLETELOG
         UNION ALL
         SELECT
             L_TRADE_DATE,
             L_SERIAL_NO,
             VC_STOCKHOLDER_ID,
             VC_SEAT_ID,
             C_INVEST_TYPE,
             L_AMOUNT,
             EN_BANLANCE,
             C_ENTRUST_DIRECTION,
             C_BUSIN_CLASS,
             L_FUND_ID,
             L_ASSET_ID,
             L_BASECOMBI_ID,
             VC_INTER_CODE,
             L_BUSIN_FLAG,
             VC_DEAL_NO,
             L_COMPLETE_DATE
         FROM ${ods_db}.O3_THISUNCOMPLETELOG
     ),
     VHISSECURITYLOAN AS (
         SELECT
             L_CLEAR_DATE,
             VC_DEAL_NO,
             C_CONTRACT_TYPE ,
             C_ENTRUST_DIRECTION ,
             VC_CONTRACT_NO,
             EN_STOCK_PRICE,
             EN_DEAL_PRICE,
             L_FUND_ID,
             L_BASECOMBI_ID,
             L_DATE,
             VC_INTER_CODE,
             L_SERIAL_NO,
             C_INVEST_TYPE,
             L_DEAL_AMOUNT,
             VC_STOCKHOLDER_ID,
             VC_SEAT_ID
         FROM ${ods_db}.O3_THISSECURITYLOAN
         UNION ALL
         SELECT
             L_CLEAR_DATE,
             VC_DEAL_NO,
             C_CONTRACT_TYPE ,
             C_ENTRUST_DIRECTION ,
             VC_CONTRACT_NO,
             EN_STOCK_PRICE,
             EN_DEAL_PRICE,
             L_FUND_ID,
             L_BASECOMBI_ID,
             L_DATE,
             VC_INTER_CODE,
             L_SERIAL_NO,
             C_INVEST_TYPE,
             L_DEAL_AMOUNT,
             VC_STOCKHOLDER_ID,
             VC_SEAT_ID
         FROM ${ods_db}.O3_TSECURITYLOAN
     ),
     VHISLIQUIDATEDETAIL AS (
         SELECT
             L_DATE
              ,VC_INTER_CODE
              ,VC_STOCKHOLDER_ID
              ,VC_SEAT_ID
              ,L_BUSIN_FLAG
              ,L_SERIAL_NO
              ,EN_OCCUR_BALANCE
              ,L_BASECOMBI_ID
              ,C_INVEST_TYPE
              ,VC_CURRENCY_NO
              ,L_DEAL_AMOUNT
              ,EN_FEE_YH
              ,EN_FEE_GH
              ,EN_FEE_JS
              ,EN_FEE_ZG
              ,EN_FEE_JS2
              ,EN_RISK_FUND
              ,EN_FEE_QT
              ,EN_FEE_YJ
              ,C_ENTRUST_DIRECTION
              ,L_BATCH_SERIAL_NO
              ,L_FUND_ID
              ,cast(VC_REPORT_ID as decimal) as VC_REPORT_ID
              ,C_BUSIN_CLASS
              ,VC_DEAL_NO
              ,EN_DEAL_PRICE
              ,EN_DEAL_BALANCE
              ,L_BUSINESS_DATE
         FROM ${ods_db}.O3_THISLIQUIDATEDETAIL
         UNION ALL
         SELECT
             L_DATE
              ,VC_INTER_CODE
              ,VC_STOCKHOLDER_ID
              ,VC_SEAT_ID
              ,L_BUSIN_FLAG
              ,L_SERIAL_NO
              ,EN_OCCUR_BALANCE
              ,L_BASECOMBI_ID
              ,C_INVEST_TYPE
              ,VC_CURRENCY_NO
              ,L_DEAL_AMOUNT
              ,EN_FEE_YH
              ,EN_FEE_GH
              ,EN_FEE_JS
              ,EN_FEE_ZG
              ,EN_FEE_JS2
              ,EN_RISK_FUND
              ,EN_FEE_QT
              ,EN_FEE_YJ
              ,C_ENTRUST_DIRECTION
              ,L_BATCH_SERIAL_NO
              ,L_FUND_ID
              ,cast(VC_REPORT_ID as decimal) as VC_REPORT_ID
              ,C_BUSIN_CLASS
              ,VC_DEAL_NO
              ,EN_DEAL_PRICE
              ,EN_DEAL_BALANCE
              ,L_BUSINESS_DATE
         FROM ${ods_db}.O3_TLIQUIDATEDETAIL
     )
insert into ${dwd_db}.evt_exch_clea_jour_his partition(p_dt,sys_rs_id)
(busi_sys_id,occu_dt,tnv_onum,tnv_time,odr_rela_onum,trd_src_id,entr_onum,rep_no,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_typ,entr_dir,clr_sped,tnv_vol,aft_par_vol,tnv_prc,rat,tnv_val,occu_val,aft_occu_val,stmp,tfee,hand_fee,sfee,clea_chag,clea_rptl,oth_fee,cms,full_tfee,deli_dt,trd_cntp_id,appt_num,trd_plfm,trd_mode,guar_sett_flag,rf_val,marg,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,trad_id,oper_no,tnv_stat,cont_mult,covr_dir,arbi_flag,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,pay_dt,excr_dt,etf_onum,esti_cash_diff,etf_fnd_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)

--离线清算：转融券新开\转融券到期\转融券提前了结\转融券资金权益除权\转融券资金权益到账\转融券证券权益除权\转融券证券权益到账
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T0.L_BUSIN_FLAG = '72467' THEN
               CONCAT(T6.VC_CONTRACT_NO , '.REFC.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
           WHEN T0.L_BUSIN_FLAG IN
                ('72469', '72471', '72472', '72473', '72475') THEN
               CONCAT(T7.VC_CONTRACT_NO , '.REFC.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
           END AS SECU_ID, --证券编码
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
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '230001' AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72467') THEN
               '23000100' --转融券新开
           WHEN T0.L_BUSIN_FLAG IN ('72469')  AND T0.C_ENTRUST_DIRECTION IN ('l','M') THEN
               '23000101' --转融券到期
           WHEN T0.L_BUSIN_FLAG IN ('72469')  AND T0.C_ENTRUST_DIRECTION = '98' THEN
               '23000103' --转融券提前了结
           WHEN T0.L_BUSIN_FLAG IN ('72471') THEN
               '23000105' --转融券资金权益除权
           WHEN T0.L_BUSIN_FLAG IN ('72472') THEN
               '23000106' --转融券资金权益到账
           WHEN T0.L_BUSIN_FLAG IN ('72473') THEN
               '23000107' --转融券证券权益除权
           WHEN T0.L_BUSIN_FLAG IN ('72475') THEN
               '23000108' --转融券证券权益到账
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE WHEN T0.C_ENTRUST_DIRECTION = 'l' THEN '49' WHEN T0.C_ENTRUST_DIRECTION = 'M' THEN '23' WHEN T0.C_ENTRUST_DIRECTION = '98' THEN '210' END AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       CASE
           WHEN T0.L_BUSIN_FLAG = '72467' THEN
               T6.EN_STOCK_PRICE
           WHEN T0.L_BUSIN_FLAG IN
                ('72469', '72471', '72472', '72473', '72475') THEN
               T7.EN_STOCK_PRICE
           END AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NVL(T6.EN_DEAL_PRICE, T7.EN_DEAL_PRICE) AS RAT, --利率,买卖交易为空
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72467', '72472', '72473', '72475') THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG = '72471' THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG = '72469' THEN
               T8.EN_OCCUR_BALANCE
           END AS TNV_VAL, --成交金额，
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72467', '72472', '72473', '72475') THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG = '72471' THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG = '72469' THEN
               T8.EN_OCCUR_BALANCE
           END AS OCCU_VAL, --发生金额，
       0 AS AFT_OCCU_VAL, --发生后资金金额
       NVL(T0.EN_FARE2, 0) AS STMP, --印花税
       NVL(T0.EN_FARE3, 0) AS TFEE, --  过户费
       NVL(T0.EN_FARE5, 0) AS HAND_FEE, --  经手费
       NVL(T0.EN_FARE6, 0) AS SFEE, --  证管费
       NVL(T0.EN_FEE_JS2, 0) AS CLEA_CHAG, -- 结算费
       NVL(T0.EN_RISK_FUND, 0) AS CLEA_RPTL, -- 结算风险金
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, -- 其他费用
       NVL(T0.EN_FARE4, 0) AS CMS, -- 佣金
       NVL(T0.EN_FEE_GH_TOTAL, 0) AS FULL_TFEE, --全额过户费
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, -- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       CASE
           WHEN T0.L_BUSIN_FLAG = '72467' THEN
               T6.VC_CONTRACT_NO
           WHEN T0.L_BUSIN_FLAG IN
                ('72469', '72471', '72472', '72473', '72475') THEN
               T7.VC_CONTRACT_NO
           END AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS  ETF_ONUM,--ETF序号
       NULL AS  ESTI_CASH_DIFF,--预估现金差额
       NULL AS  ETF_FND_CLAS,--ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM (SELECT T0.L_DATE,
             T0.L_FUND_ID,
             T0.L_ASSET_ID,
             T0.L_BASECOMBI_ID,
             T0.VC_DEAL_NO,
             T0.L_BUSIN_FLAG,
             T0.C_ENTRUST_DIRECTION,
             T0.VC_STOCKHOLDER_ID,
             T0.VC_SEAT_ID,
             T0.VC_CURRENCY_NO,
             T0.C_INVEST_TYPE,
             T0.L_SETTLE_SPEED,
             T0.C_BUSIN_CLASS,
             T0.VC_INTER_CODE,
             MIN(T0.L_SERIAL_NO) L_SERIAL_NO,
             SUM(T0.L_BUSIN_AMOUNT) L_BUSIN_AMOUNT,
             SUM(T0.EN_OCCUR_BALANCE) EN_OCCUR_BALANCE,
             SUM(T0.EN_SUBJECT_BALANCE) EN_SUBJECT_BALANCE,
             SUM(T0.EN_FARE2) AS EN_FARE2,
             SUM(T0.EN_FARE3) AS EN_FARE3,
             SUM(T0.EN_FARE5) AS EN_FARE5,
             SUM(T0.EN_FARE6) AS EN_FARE6,
             SUM(T0.EN_FEE_JS2) AS EN_FEE_JS2,
             SUM(T0.EN_RISK_FUND) AS EN_RISK_FUND,
             SUM(T0.EN_FARE7) AS EN_FARE7,
             SUM(T0.EN_FARE4) AS EN_FARE4,
             SUM(T0.EN_FEE_GH_TOTAL) AS EN_FEE_GH_TOTAL,
             MAX(T0.L_OPERATOR_NO) AS L_OPERATOR_NO
      FROM ${ods_db}.O3_TCURRENTS T0
      WHERE ((T0.L_BUSIN_FLAG IN ('72467') AND
              T0.VC_SUMMARY <> '转融券现券减少-展期新开') OR
             (T0.L_BUSIN_FLAG IN ('72469') AND T0.L_BUSIN_AMOUNT <> 0) OR
             T0.L_BUSIN_FLAG IN ('72471', '72472', '72473', '72475'))
        --72467转融券到期现券处理、72469转融券到期现券处理
        --72471转融券资金权益补偿登记、72472转融券资金权益补偿到账、72473转融券证券权益补偿登记、72475转融券证券权益补偿到账现券处理
        AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
        AND T0.L_DATE = ${current_date}
      GROUP BY T0.L_DATE,
               T0.L_FUND_ID,
               T0.L_ASSET_ID,
               T0.L_BASECOMBI_ID,
               T0.VC_DEAL_NO,
               T0.L_BUSIN_FLAG,
               T0.C_ENTRUST_DIRECTION,
               T0.VC_STOCKHOLDER_ID,
               T0.VC_SEAT_ID,
               T0.VC_CURRENCY_NO,
               T0.C_INVEST_TYPE,
               T0.L_SETTLE_SPEED,
               T0.C_BUSIN_CLASS,
               T0.VC_INTER_CODE) T0 --清算流水主表,到期会有分笔到期，利息在另外一条记录中
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN VHISSECURITYLOAN T6 --转融通合约表,当前和历史合集
                   ON T0.L_DATE = T6.L_CLEAR_DATE
                       AND T0.VC_DEAL_NO = T6.VC_DEAL_NO
                       AND T6.C_CONTRACT_TYPE = '0'
                       AND T6.C_ENTRUST_DIRECTION = 'l'
                       AND T0.L_BUSIN_FLAG = '72467'
         LEFT JOIN VHISSECURITYLOAN T7 --转融通合约表，当前和历史合集
                   ON T0.VC_DEAL_NO = T7.VC_CONTRACT_NO
                       AND T0.L_BUSIN_FLAG IN ('72469', '72471', '72472', '72473', '72475')
         LEFT JOIN ${ods_db}.O3_TCURRENTS T8 --获取到期的转融券费用
                   ON T0.L_BUSIN_FLAG = T8.L_BUSIN_FLAG
                       AND T0.L_DATE = T8.L_DATE
                       AND T0.VC_DEAL_NO = T8.VC_DEAL_NO
                       AND T8.L_BUSIN_FLAG = '72469'
                       AND T8.L_BUSIN_AMOUNT = 0
                       AND T8.C_STATUS = '1'

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
                   ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T9.C_MARKET_NO

UNION ALL
--离线清算：转融券展期新开
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_Z' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_Z' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T0.VC_CONTRACT_NO , '.REFC.' ,
              CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) AS SECU_ID, --证券编码
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
       '230001' AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '23000102' AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '23' AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_DEAL_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_STOCK_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
       T0.EN_DEAL_PRICE AS RAT, --利率,买卖交易为空
       0 AS TNV_VAL, --成交金额，
       0 AS OCCU_VAL, --发生金额，
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
       NULL AS TRD_MODE, -- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       'E' AS BUSI_CLAS_O3, --   业务分类_O32
       NULL AS TRAD_ID, --券商编码
       NULL AS OPER_NO, --操作员
       1 AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       T0.VC_CONTRACT_NO AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS  ETF_ONUM,--ETF序号
       NULL AS  ESTI_CASH_DIFF,--预估现金差额
       NULL AS  ETF_FND_CLAS,--ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM VHISSECURITYLOAN T0 --转融通合约表,当前和历史合集
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                   ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T10.C_MARKET_NO
WHERE T0.C_ENTRUST_DIRECTION = 'M'
  AND T0.C_CONTRACT_TYPE = '0'
  AND T0.L_DATE = ${current_date}

UNION ALL
--离线清算：债转股（债券转出）\债转股（股票转入）
SELECT
    '1' AS BUSI_SYS_ID, --业务系统编码
    T0.L_DATE AS OCCU_DT, --发生日期
    concat(T0.L_DATE , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
    NULL AS TNV_TIME, --成交时间
    CASE
        WHEN T6.L_DAILY_INSTRUCTION_NO IS NULL OR
             T6.L_DAILY_INSTRUCTION_NO = 0 THEN
            NULL
        ELSE
            concat(T6.L_DATE , '_HSO32' , '_' , T6.L_DAILY_INSTRUCTION_NO , '_' ,
                   T0.L_BASECOMBI_ID , '_' , (CASE
                                                  WHEN T5.C_ASSET_CLASS = '2' THEN
                                                      concat(T5.VC_REPORT_CODE , '.STK.' ,
                                                             (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
                                                  WHEN T5.C_ASSET_CLASS = '3' THEN
                                                      concat(T5.VC_REPORT_CODE , '.BOND.' ,
                                                             (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
                END) , '_' ,
                   (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END) , '_' ,
                   (CASE
                        WHEN T0.L_BUSIN_FLAG IN ('41401') THEN
                            '26000100' --债转股（债券转出）
                        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
                            '26000101' --债转股（股票转入）
                       END))
        END AS ODR_RELA_ONUM, --指令关联序号
    CASE
        WHEN T6.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
             T6.L_DAILY_INSTRUCTION_NO <> 0 THEN
            concat('0|' , T6.L_DATE , '_HSO32' , '_' , T6.L_DAILY_INSTRUCTION_NO ,
                   '|0|0')
        WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
             T4.L_ENTRUST_SERIAL_NO <> 0 THEN
            concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
        ELSE
            concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_J' , T0.L_SERIAL_NO)
        END AS TRD_SRC_ID, --交易源ID
    CASE
        WHEN T4.L_ENTRUST_SERIAL_NO IS NULL OR T4.L_ENTRUST_SERIAL_NO = 0 THEN
            NULL --缺少委托序号时，为空
        ELSE
            concat(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
        END AS ENTR_ONUM, --委托序号
    T4.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
    NULL AS TNV_NO, --成交编号
    T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
    T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
    T0.VC_SEAT_ID AS SEAT_CODE, --席位号
    CASE
        WHEN T5.C_ASSET_CLASS = '2' THEN
            concat(T5.VC_REPORT_CODE , '.STK.' ,
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
        WHEN T5.C_ASSET_CLASS = '3' THEN
            concat(T5.VC_REPORT_CODE , '.BOND.' ,
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
        END AS SECU_ID, --证券编码
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
    T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
    '260001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41401') THEN
            '26000100' --债转股（债券转出）
        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
            '26000101' --债转股（股票转入）
        END AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '10' AS ENTR_DIR, --委托方向
    1 AS CLR_SPED, --清算速度
    T0.L_DEAL_AMOUNT AS TNV_VOL, --成交数量
    0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41401') THEN
            (CASE WHEN SUBSTR(T0.VC_INTER_CODE, -2) = 'SH' THEN T6.EN_PRICE1 ELSE 100 END)
        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
            T6.EN_FACT_PRICE
        END AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41401') THEN
                (CASE WHEN SUBSTR(T0.VC_INTER_CODE, -2) = 'SH' THEN T6.EN_PRICE1 ELSE 100 END) *
                T0.L_DEAL_AMOUNT
        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
                T6.EN_FACT_PRICE * T0.L_DEAL_AMOUNT
        END AS TNV_VAL, --成交金额，
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41401') THEN
                    (CASE WHEN SUBSTR(T0.VC_INTER_CODE, -2) = 'SH' THEN T6.EN_PRICE1 ELSE 100 END) *
                    T0.L_DEAL_AMOUNT - NVL(T0.EN_FEE_YH, 0) - NVL(T0.EN_FEE_GH, 0) -
                    NVL(T0.EN_FEE_JS, 0) - NVL(T0.EN_FEE_ZG, 0) -
                    NVL(T0.EN_FEE_JS2, 0) - NVL(T0.EN_RISK_FUND, 0) -
                    NVL(T0.EN_FEE_QT, 0) - NVL(T0.EN_FEE_YJ, 0)
        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
                    T6.EN_FACT_PRICE * T0.L_DEAL_AMOUNT + NVL(T0.EN_FEE_YH, 0) +
                    NVL(T0.EN_FEE_GH, 0) + NVL(T0.EN_FEE_JS, 0) + NVL(T0.EN_FEE_ZG, 0) +
                    NVL(T0.EN_FEE_JS2, 0) + NVL(T0.EN_RISK_FUND, 0) +
                    NVL(T0.EN_FEE_QT, 0) + NVL(T0.EN_FEE_YJ, 0)
        END AS OCCU_VAL, --发生金额，
    0 AS AFT_OCCU_VAL, --发生后资金金额
    T0.EN_FEE_YH AS STMP, --印花税
    T0.EN_FEE_GH AS TFEE, --  过户费
    T0.EN_FEE_JS AS HAND_FEE, --  经手费
    T0.EN_FEE_ZG AS SFEE, --  证管费
    T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
    T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
    T0.EN_FEE_QT AS OTH_FEE, -- 其他费用
    T0.EN_FEE_YJ AS CMS, -- 佣金
    0 AS FULL_TFEE, --全额过户费
    aft_1_dt AS DELI_DT, --交割日期
    NULL AS TRD_CNTP_ID, -- 交易对手编码
    NULL AS APPT_NUM, --  约定号
    'PLAT_BID' AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
    NULL AS GUAR_SETT_FLAG, --担保交收标志
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41402') THEN
            T7.EN_OCCUR_BALANCE
        ELSE
            0
        END AS RF_VAL, -- 退款金额
    0 AS MARG, --  保证金
    T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
    T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
    T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
    NULL AS TRAD_ID, --券商编码
    NULL AS OPER_NO, --操作员
    1 AS TNV_STAT, --成交状态
    NULL AS CONT_MULT, --合约乘数
    NULL AS COVR_DIR, --平仓方向
    NULL AS ARBI_FLAG, --套利标志
    CASE
        WHEN NVL(T6.L_RESTRICTED_NO, 0) <> 0 THEN
            1 --限售
        ELSE
            0 --非限售
        END AS RES_FLAG, --限售标识
    CASE
        WHEN NVL(T6.L_RESTRICTED_NO, 0) <> 0 THEN
            7 --定向可转债转股受限
        ELSE
            NULL --非限售
        END AS LOCK_LMT_CLAS, --锁定受限类型
    NVL(T6.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
    NULL AS AGMT_NUM, --合同号
    NULL AS PAY_DT, --缴款日期
    NULL AS EXCR_DT, --除权日期
    NULL AS  ETF_ONUM,--ETF序号
    NULL AS  ESTI_CASH_DIFF,--预估现金差额
    NULL AS  ETF_FND_CLAS,--ETF基金类型
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_second_3' AS TASK_RS_ID, --任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
    T0.L_DATE as p_dt,
    'O3' AS SYS_RS_ID --系统来源标识
FROM VHISLIQUIDATEDETAIL T0 --清算接口表
         LEFT JOIN ${ods_db}.O3_TENTRUSTS T4
                   ON T0.L_DATE = T4.L_DATE
                       AND T0.L_BATCH_SERIAL_NO = T4.L_BATCH_SERIAL_NO
                       AND LPAD(T0.VC_REPORT_ID, 64, 0) = LPAD(T4.L_REPORT_SERIAL_NO, 64, 0)
                       AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
                       AND T0.L_FUND_ID = T4.L_FUND_ID
                       AND T4.C_ENTRUST_DIRECTION = 'A'
                       AND T4.C_ENTRUST_STATUS IN ('1', '3', '4', '5', '6', '7', '8', '9')

         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T4.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T6
                   ON T4.L_DATE = T6.L_DATE
                       AND T4.L_DAILY_INSTRUCTION_NO = T6.L_DAILY_INSTRUCTION_NO
                       AND T4.L_INDEX_DAILY_MODIFY = T6.L_INDEX_DAILY_MODIFY
                       AND T4.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                       AND T6.C_ENTRUST_DIRECTION = '1'
                       AND T6.C_ORIGINAL_DIRECTION = 'A'
                       AND T6.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a')

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_MARKET_NO IN ('1', '2')
                       AND T5.C_ASSET_CLASS IN ('2', '3')

         LEFT JOIN VHISLIQUIDATEDETAIL T7
                   ON T0.L_DATE = T7.L_DATE
                       AND T0.VC_STOCKHOLDER_ID = T7.VC_STOCKHOLDER_ID
                       AND T0.VC_SEAT_ID = T7.VC_SEAT_ID
                       AND T0.L_BATCH_SERIAL_NO = T7.L_BATCH_SERIAL_NO
                       AND LPAD(T0.VC_REPORT_ID, 64, 0) = LPAD(T7.VC_REPORT_ID, 64, 0)
                       AND T7.L_BUSIN_FLAG IN ('41403')

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                   ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T10.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T11
                   ON T0.L_DATE = T11.dt AND T5.C_MARKET_NO = T11.MKT_NO and t11.SYS_RS_ID = 'O3'
WHERE T0.L_BUSIN_FLAG IN ('41401', '41402')
--41401债转股债券减少，41402债转股股票增加，41403债转股现金增加
  AND T0.L_DATE = ${current_date}

UNION ALL
--供股权（公开配售）申报确认
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO )AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.WRNT.' ,
              (CASE T5.C_MARKET_NO
                   WHEN 'n' THEN 'SHSC'
                   WHEN 'o' THEN 'SZSC'
                  END)) AS SECU_ID, --证券编码
       CASE T5.C_MARKET_NO
           WHEN 'n' THEN 'SHSC'
           WHEN 'o' THEN 'SZSC'
           END  AS EXCH_CODE, --交易市场代码
       T8.FZDM1 AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID，成交中用源证券编码赋值，该字段复制到转入证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '060001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '06000105' AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '9' AS ENTR_DIR, --委托方向
       T0.L_SETTLE_SPEED  AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT AS TNV_PRC, --成交价格
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       NVL(T0.EN_FARE2, 0) AS STMP, --印花税
       NVL(T0.EN_FARE3, 0) AS TFEE, --  过户费
       NVL(T0.EN_FARE5, 0) AS HAND_FEE, --  经手费
       NVL(T0.EN_FARE6, 0) AS SFEE, --  证管费
       NVL(T0.EN_FEE_JS2, 0) AS CLEA_CHAG, -- 结算费
       NVL(T0.EN_RISK_FUND, 0) AS CLEA_RPTL, -- 结算风险金
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, -- 其他费用
       NVL(T0.EN_FARE4, 0) AS CMS, -- 佣金
       NVL(T0.EN_FEE_GH_TOTAL, 0) AS FULL_TFEE, --全额过户费
       T12.aft_1_dt AS DELI_DT, --交割日期
       concat(T6.VC_REPORT_CODE , '.STK.' ,
              (CASE T5.C_MARKET_NO WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END)) AS TRD_CNTP_ID, -- 交易对手编码,成交时该字段为空，该值存入转入证券内码中
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE,-- 交易方式
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
       T11.aft_1_dt AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_second_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_MATCH_RELATIVE1_CODE = T6.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${ods_db}.O3_THKTZXXINFO T8
                   ON T6.VC_REPORT_CODE = T8.ZQDM
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T11
                   ON  T8.RQ3 =T11.dt
                       AND T5.C_MARKET_NO = T11.MKT_NO
                       and T11.sys_rs_id = 'O3'
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T12
                   ON T11.aft_1_dt = T12.dt
                       AND T5.C_MARKET_NO = T12.MKT_NO
                       and T12.sys_rs_id = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
  AND T0.L_BUSIN_FLAG IN ('73206')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE >= T8.RQ2
  AND T0.L_DATE <= T8.RQ3
  AND T0.L_DATE = ${current_date}

UNION ALL
--供股权（公开配售）缴款
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO )AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO )AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO )AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.STK.' ,
              (CASE T5.C_MARKET_NO WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END)) AS SECU_ID, --证券编码
       CASE T5.C_MARKET_NO WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '060001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '06000109' AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '9' AS ENTR_DIR, --委托方向
       1 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_SUBJECT_BALANCE / T0.L_BUSIN_AMOUNT AS TNV_PRC, --成交价格
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
       T0.EN_SUBJECT_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       NVL(T0.EN_FARE2, 0) AS STMP, --印花税
       NVL(T0.EN_FARE3, 0) AS TFEE, --  过户费
       NVL(T0.EN_FARE5, 0) AS HAND_FEE, --  经手费
       NVL(T0.EN_FARE6, 0) AS SFEE, --  证管费
       NVL(T0.EN_FEE_JS2, 0) AS CLEA_CHAG, -- 结算费
       NVL(T0.EN_RISK_FUND, 0) AS CLEA_RPTL, -- 结算风险金
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, -- 其他费用
       NVL(T0.EN_FARE4, 0) AS CMS, -- 佣金
       NVL(T0.EN_FEE_GH_TOTAL, 0) AS FULL_TFEE, --全额过户费
       T11.aft_1_dt  AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE,-- 交易方式
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
       T0.L_DATE AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_second_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T11
                   ON T0.L_DATE = T11.dt
                       AND T5.C_MARKET_NO = T11.MKT_NO
                       and T11.sys_rs_id = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
  AND T0.L_BUSIN_FLAG IN ('41304')
  AND T5.C_MARKET_NO IN ('n', 'o')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--证券组合费
SELECT
    '1' AS BUSI_SYS_ID, --业务系统编码
    T0.L_DATE AS OCCU_DT, --发生日期
    concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
    NULL AS TNV_TIME, --成交时间
    NULL AS ODR_RELA_ONUM, --指令关联序号
    concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
    NULL AS ENTR_ONUM, --委托序号
    NULL AS REP_NO, --申报编号
    NULL AS TNV_NO, --成交编号
    T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
    T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
    T0.VC_SEAT_ID AS SEAT_CODE, --席位号
    CASE WHEN T0.VC_SUMMARY LIKE '%沪港通证券组合费%' THEN 'ZQQSK.CASH.SHSC'
         WHEN T0.VC_SUMMARY LIKE '%深港通证券组合费%' THEN 'ZQQSK.CASH.SZSC'
        END AS SECU_ID, --证券编码
    CASE WHEN T0.VC_SUMMARY LIKE '%沪港通证券组合费%' THEN 'SHSC'
         WHEN T0.VC_SUMMARY LIKE '%深港通证券组合费%' THEN 'SZSC'
        END AS EXCH_CODE, --交易市场代码
    'ZQQSK' AS SECU_CODE, --证券代码
    NULL AS SRC_SECU_ID, --源证券ID
    NULL AS SRC_SECU_TRD_ID, --源证券交易ID
    'L' AS POS_ID, --多空标志,默认多头
    T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
    '340001' AS BUSI_TYP, --业务类别
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    '34000100' AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    NULL AS ENTR_DIR, --委托方向
    1 AS CLR_SPED, --清算速度
    0 AS TNV_VOL, --成交数量
    0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额，
    T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
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
    T4.aft_2_dt AS DELI_DT, --交割日期
    NULL AS TRD_CNTP_ID, -- 交易对手编码
    NULL AS APPT_NUM, --  约定号
    NULL AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
    NULL AS GUAR_SETT_FLAG, --担保交收标志
    0 AS RF_VAL, -- 退款金额
    0 AS MARG, --  保证金
    NULL AS ENTR_DIR_O3, -- 委托方向_O32
    NULL AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
    ${current_date} AS BUSI_DATE, --业务日期
    'evt_exch_clea_jour_real_second_6' AS TASK_RS_ID, --任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
    T0.L_DATE as p_dt,
    'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T4
                   ON T0.L_DATE = T4.dt
                       AND T4.mkt_no = 'n'
                       and t4.SYS_RS_ID = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1') --筛选交易所流水 1：竞价平台,
  AND T0.L_BUSIN_FLAG IN ('72969')
  --72969港股通证券组合费收取
  AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
  AND T0.L_DATE = ${current_date}

UNION ALL
--清算：分销买入\分销卖出
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T4.L_REALDEAL_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
           ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_',
                      T0.L_BASECOMBI_ID, '_',
                      (CASE
                           WHEN T6.C_ASSET_CLASS = '3' THEN
                               CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
                          END), '_',
                      (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END), '_',
                      (CASE
                           WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
                               '01000102'
                           WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
                               '01000103'
                          END)
                   )
           END AS ODR_RELA_ONUM, --指令关联序号
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               CONCAT('0|', T4.L_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '|0|0')
           WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               CONCAT('0|0|', T4.L_DATE, '_HSO32', '_', T4.L_ENTRUST_SERIAL_NO, '|0')
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_', T4.L_REALDEAL_SERIAL_NO)
           END AS TRD_SRC_ID, --交易源ID
       CASE
           WHEN T4.L_ENTRUST_SERIAL_NO IS NULL OR T4.L_ENTRUST_SERIAL_NO = 0 THEN
               NULL --缺少委托序号时，为空
           ELSE
               CONCAT(T4.L_DATE, '_HSO32', '_', T4.L_ENTRUST_SERIAL_NO)
           END AS ENTR_ONUM, --委托序号
       T4.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
       CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T6.C_ASSET_CLASS = '3' THEN
               CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END)) --债券
           END AS SECU_ID, --证券编码
       CASE
           WHEN T6.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T6.C_MARKET_NO = '2' THEN
               'SZ'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '010001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '01000102'
           WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '01000103'
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '21'
           WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '22'
           END AS ENTR_DIR, --委托方向
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_FARE2 AS STMP, --印花税
       T0.EN_FARE3 AS TFEE, --  过户费
       T0.EN_FARE5 AS HAND_FEE, --  经手费
       T0.EN_FARE6 AS SFEE, --  证管费
       T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
       T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
       T0.EN_FARE7 AS OTH_FEE, -- 其他费用
       T0.EN_FARE4 AS CMS, -- 佣金
       T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
       --SF_OFFSET_TRADEDAY(T0.L_DATE, T0.L_SETTLE_SPEED, 2, T5.C_MARKET_NO, 2) AS DELI_DT, --交割日期
       CASE WHEN T0.L_SETTLE_SPEED = 0 THEN
                T8.AFT_0_DT
            WHEN T0.L_SETTLE_SPEED = 1 THEN
                T8.AFT_1_DT
            WHEN T0.L_SETTLE_SPEED = 2 THEN
                T8.AFT_2_DT
            WHEN T0.L_SETTLE_SPEED = 3 THEN
                T8.AFT_3_DT
            WHEN T0.L_SETTLE_SPEED = 4 THEN
                T8.AFT_4_DT
           END AS DELI_DT, --交割日期
       cast(T4.L_TRADE_RIVAL_NO as string) AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
           END AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE,-- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       T4.VC_BROKER_NO AS TRAD_ID, --券商编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       CAST(NVL(T4.C_VALID, 1) as INT) AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       T4.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_second_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
                   ON LPAD(T0.Vc_Deal_No, 64, 0) = LPAD(T4.Vc_Deal_No, 64, 0)
                       AND T0.l_date = t4.l_date
                       AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                       AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                       AND T4.C_VALID = T0.C_STATUS

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所,n沪港通，o是深港通

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE T8
                   ON T0.L_DATE = T8.DT
                       AND T5.C_MARKET_NO = T8.MKT_NO
                       AND T8.SYS_RS_ID = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1')
  AND T0.L_BUSIN_FLAG IN ('41503', '72441')
  --41503网上申购中签,72441分销卖出摘牌
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--清算：实时申赎货币基金
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
       CASE WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR T4.L_DAILY_INSTRUCTION_NO = 0 THEN
                NULL
            ELSE
                CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
                       T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.' ,
                       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END , '_' ,
                       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END , '_' ,
                       (CASE WHEN T0.L_BUSIN_FLAG = '72567' THEN '38000101'
                             WHEN T0.L_BUSIN_FLAG = '72568' THEN '38000102'
                           END))
           END AS ODR_RELA_ONUM, --指令关联序号
       CASE WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
                CONCAT('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
            WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND T4.L_ENTRUST_SERIAL_NO <> 0 THEN
                CONCAT('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
            WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
                CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
            ELSE
                CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
           END AS TRD_SRC_ID, --交易源ID
       CASE
           WHEN T4.L_ENTRUST_SERIAL_NO IS NULL OR T4.L_ENTRUST_SERIAL_NO = 0 THEN
               NULL --缺少委托序号时，为空
           ELSE
               CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
           END AS ENTR_ONUM, --委托序号
       T4.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
       CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.FUND.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) AS SECU_ID, --证券编码
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
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '380001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE WHEN T0.L_BUSIN_FLAG = '72567' THEN '38000100'
            WHEN T0.L_BUSIN_FLAG = '72568' THEN '38000101'
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE WHEN T0.L_BUSIN_FLAG = '72567' THEN '53'
            WHEN T0.L_BUSIN_FLAG = '72568' THEN '54'
           END AS ENTR_DIR, --委托方向
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_FARE2 AS STMP, --印花税
       T0.EN_FARE3 AS TFEE, --  过户费
       T0.EN_FARE5 AS HAND_FEE, --  经手费
       T0.EN_FARE6 AS SFEE, --  证管费
       T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
       T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
       T0.EN_FARE7 AS OTH_FEE, -- 其他费用
       T0.EN_FARE4 AS CMS, -- 佣金
       T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
       W1.aft_1_dt AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, -- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       T4.VC_BROKER_NO AS TRAD_ID, --券商编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       CAST(NVL(T4.C_VALID, 1) AS INT) AS TNV_STAT, --成交状态
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
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN VHISPENDSETTLE T6 --待交割表,当前和历史合集
                   ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                       AND T0.L_DATE = T6.L_TRADE_DATE
                       AND T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
                   ON  T0.l_date = t4.l_date
                       AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                       AND T6.L_ENTRUST_SERIAL_NO = T4.L_ENTRUST_SERIAL_NO
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W1
                   ON T0.L_DATE = W1.dt
                       AND T5.C_MARKET_NO = W1.mkt_no
                       AND W1.SYS_RS_ID = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('5')
  AND T0.L_BUSIN_FLAG IN ('72567','72568')
  --72567：场内基金申购，72568：场内基金申购
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--成交：20220902ETF申购_基金、成分券_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
       CASE
           WHEN T7.L_DAILY_INSTRUCTION_NO IS NULL OR T7.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                      (CASE
                           WHEN T5.C_ASSET_CLASS = '2' THEN
                               CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
                                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                           WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                           WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                           WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                           WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                                           WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)
                           WHEN T5.C_ASSET_CLASS = '3' THEN
                               CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                           WHEN T5.C_ASSET_CLASS = '4' THEN
                               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                          END) , '_' ,
                      CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END , '_' ,
                      (CASE
                           WHEN T0.L_BUSIN_FLAG in ('41513') THEN
                               '37000100' --ETF基金申购_基金
                           WHEN T0.L_BUSIN_FLAG in ('41515') THEN
                               '37000101' --ETF基金申购_成分券
                           WHEN T0.L_BUSIN_FLAG in ('41514') THEN
                               '37000103' --ETF基金赎回_基金
                           WHEN T0.L_BUSIN_FLAG in ('41516') THEN
                               '37000104' --ETF基金赎回_成分券
                          END))
           END AS ODR_RELA_ONUM, --指令关联序号
       CASE WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
                CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
            WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND T7.L_ENTRUST_SERIAL_NO <> 0 THEN
                CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
            ELSE
                CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
           END AS TRD_SRC_ID, --交易源ID
       CASE
           WHEN T7.L_ENTRUST_SERIAL_NO IS NULL OR T7.L_ENTRUST_SERIAL_NO = 0 THEN
               NULL --缺少委托序号时，为空
           ELSE
               CONCAT(T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO)
           END AS ENTR_ONUM, --委托序号
       T4.L_REPORT_ID AS REP_NO, --申报编号
       CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '2' THEN
               CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                            WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                            WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                            WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END))
           WHEN T5.C_ASSET_CLASS = '3' THEN
               CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
           WHEN T5.C_ASSET_CLASS = '4' THEN
               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
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
               CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
           WHEN T5.C_MARKET_NO = 'r' THEN
               'BJ'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '370001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG in ('41513') THEN
               '37000116' --ETF基金申购成交_基金
           WHEN T0.L_BUSIN_FLAG in ('41517') THEN
               '37000118' --ETF基金申购成交_现金替代
           WHEN T0.L_BUSIN_FLAG in ('41515') THEN
               '37000117' --ETF基金申购成交_成分券
           WHEN T0.L_BUSIN_FLAG in ('41514') THEN
               '37000119' --ETF基金赎回成交_基金
           WHEN T0.L_BUSIN_FLAG in ('41518') THEN
               '37000121' --ETF基金赎回成交_现金替代
           WHEN T0.L_BUSIN_FLAG in ('41516') THEN
               '37000120' --ETF基金赎回成交_成分券
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41513', '41517', '41515') THEN
               '26'
           WHEN T0.L_BUSIN_FLAG IN ('41514', '41518', '41516') THEN
               '27'
           END AS ENTR_DIR, --委托方向
       CASE
           WHEN T0.L_BUSIN_FLAG in ('41513', '41514') THEN
               0
           WHEN T0.L_BUSIN_FLAG in ('41517', '41518') THEN
               1
           WHEN T0.L_BUSIN_FLAG in ('41515', '41516') THEN
               0
           END AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T4.EN_DEAL_PRICE AS TNV_PRC, --成交价格 ,
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_FARE2 AS STMP, --印花税
       T0.EN_FARE3 AS TFEE, --  过户费
       T0.EN_FARE5 AS HAND_FEE, --  经手费
       T0.EN_FARE6 AS SFEE, --  证管费
       T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
       T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
       T0.EN_FARE7 AS OTH_FEE, -- 其他费用
       T0.EN_FARE4 AS CMS, -- 佣金
       T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
       CASE
           WHEN T0.L_BUSIN_FLAG in ('41513', '41514') THEN
               T0.L_DATE
           WHEN T0.L_BUSIN_FLAG in ('41517', '41518') THEN
               W1.aft_1_dt
           WHEN T0.L_BUSIN_FLAG in ('41515', '41516') THEN
               T0.L_DATE
           END AS DELI_DT, --交割日期
       CAST(T9.L_TRADE_RIVAL_NO AS STRING) AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE,--交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       T9.VC_BROKER_NO AS TRAD_ID, --券商编码
       T9.L_OPERATOR_NO AS OPER_NO, --操作员
       CAST(NVL(T9.C_VALID,1) AS INT) AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       T9.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS PAY_DT, --缴款日期
       NULL AS EXCR_DT, --除权日期
       T4.L_REALDEAL_SERIAL_NO AS ETF_ONUM, --ETF序号
       CASE
           WHEN T0.L_BUSIN_FLAG in ('41513') THEN
                       T0.L_BUSIN_AMOUNT / T8.L_REPORT_UNIT * T8.EN_ESTIMATECASH
           WHEN T0.L_BUSIN_FLAG in ('41514') THEN
                       -T0.L_BUSIN_AMOUNT / T8.L_REPORT_UNIT * T8.EN_ESTIMATECASH
           ELSE
               0
           END AS ESTI_CASH_DIFF, --预估现金差额
       CASE WHEN  T0.L_BUSIN_FLAG IN ('41513', '41514')
                THEN
                CASE WHEN T8.C_TYPE IN ('1') AND T8.C_ETF_TYPE IN ('1') THEN '1'  --单市场股票ETF
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('1') THEN '2'  --跨市场股票ETF(沪深)
                     WHEN T8.C_TYPE IN ('4') AND T8.C_ETF_TYPE IN ('1') AND NVL(T7.C_PRICE_TYPE, 0) <> 'S' THEN '2'  --跨市场股票ETF(沪深)
                     WHEN T8.C_TYPE IN ('4') AND T8.C_ETF_TYPE IN ('1') AND NVL(T7.C_PRICE_TYPE, 0) = 'S' THEN '3'  --跨市场股票ETF(中登)
                     WHEN T8.C_TYPE IN ('7', '9') AND T8.C_ETF_TYPE IN ('1') THEN '4'  --跨市场股票ETF(沪深港)
                     WHEN T8.C_TYPE IN ('1') AND T8.C_ETF_TYPE IN ('2') THEN '5'  --单市场债券ETF（成分券申赎）
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('2') AND T8.L_ASSET_DEAL_DAYS = 0 THEN '6'  --债券ETF(现金申赎)
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('2') AND T8.L_ASSET_DEAL_DAYS = 1 THEN '7'  --跨市场债券ETF（成分券申赎）
                     WHEN T8.C_TYPE IN ('2')  THEN '8'  --跨境ETF
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('4') AND NVL(T7.C_PRICE_TYPE, 0) <> 'S' THEN '10'  --黄金ETF(现金申赎)
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('4') AND NVL(T7.C_PRICE_TYPE, 0) = 'S' THEN '11'  --黄金ETF(实物申赎)
                     WHEN T8.C_TYPE IN ('3') AND T8.C_ETF_TYPE IN ('7') THEN '12'  --商品期货ETF
                     WHEN T8.C_TYPE IN ('5', '6') AND T8.C_ETF_TYPE IN ('1') THEN '13'  --港股通ETF
                    END
            ELSE
                NULL
           END AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_9' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         LEFT JOIN ${ods_db}.O3_TETFREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
                   ON LPAD(T0.Vc_Deal_No, 64, 0) = LPAD(T4.Vc_Deal_No, 64, 0)
                       AND T0.L_DATE = T4.L_DATE
                       AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                       AND T5.VC_REPORT_CODE = T4.VC_REALDEAL_CODE
                       AND T5.C_MARKET_NO = T4.C_MARKET_NO
                       AND T4.L_DEAL_AMOUNT <> 0
         LEFT JOIN ${ods_db}.O3_TENTRUSTS T7
                   ON T4.L_DATE = T7.L_DATE
                       AND T4.L_ENTRUST_SERIAL_NO = T7.L_ENTRUST_SERIAL_NO
         LEFT JOIN ${ods_db}.O3_TREALDEAL T9
                   ON T4.L_DATE = T9.L_DATE
                       AND T4.L_ENTRUST_SERIAL_NO = T9.L_ENTRUST_SERIAL_NO
                       AND T9.C_VALID = T0.C_STATUS
         LEFT JOIN ${ods_db}.O3_TETFBASICINFO T8
                   ON T0.L_DATE = T8.L_DATE
                       AND T5.VC_REPORT_CODE = T8.VC_REPORT_CODE
                       AND T8.C_EXEC_TYPE NOT IN ('2')
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                   ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T10.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                   ON T0.L_DATE = W1.dt
                       AND T5.C_MARKET_NO = W1.mkt_no
                       AND W1.SYS_RS_ID = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('6')
  AND T0.L_BUSIN_FLAG IN ('41513', '41515', '41514', '41516')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--成交：20220902ETF申购_现金替代_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）只含申购部分
SELECT T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
       T0.OCCU_DT AS OCCU_DT, --发生日期
       MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
       T0.TNV_TIME AS TNV_TIME, --成交时间
       T0.ODR_RELA_ONUM AS ODR_RELA_ONUM, --指令关联序号
       T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
       T0.ENTR_ONUM AS ENTR_ONUM, --委托序号
       T0.REP_NO AS REP_NO, --申报编号
       MAX(T0.TNV_NO) AS TNV_NO, --成交编号
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE AS PFL_CODE, --投组代码
       T0.SH_CODE AS SH_CODE, --股东代码
       T0.SEAT_CODE AS SEAT_CODE, --席位号
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.SECU_CODE AS SECU_CODE, --证券代码
       T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
       T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
       T0.POS_ID AS POS_ID, --多空标志
       T0.CURR_CODE AS CURR_CODE, --货币代码
       T0.BUSI_TYP AS BUSI_TYP, --业务类别
       T0.INV_TYP AS INV_TYP, --投资类型
       T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
       T0.CLR_TYP AS CLR_TYP, --清算类型
       T0.ENTR_DIR AS ENTR_DIR, --委托方向
       T0.CLR_SPED AS CLR_SPED, --清算速度
       SUM(T0.TNV_VOL) AS TNV_VOL, --成交数量
       SUM(T0.AFT_PAR_VOL) AS AFT_PAR_VOL, --发生后数量
       MAX(T0.TNV_PRC) AS TNV_PRC, --成交价格
       T0.RAT AS RAT, --利率
       SUM(T0.TNV_VAL) AS TNV_VAL, --成交金额
       SUM(T0.OCCU_VAL) AS OCCU_VAL, --发生金额
       SUM(T0.AFT_OCCU_VAL) AS AFT_OCCU_VAL, --发生后资金金额
       SUM(T0.STMP) AS STMP, --印花税
       SUM(T0.TFEE) AS TFEE, --过户费
       SUM(T0.HAND_FEE) AS HAND_FEE, --经手费
       SUM(T0.SFEE) AS SFEE, --证管费
       SUM(T0.CLEA_CHAG) AS CLEA_CHAG, --结算费
       SUM(T0.CLEA_RPTL) AS CLEA_RPTL, --结算风险金
       SUM(T0.OTH_FEE) AS OTH_FEE, --其他费用
       SUM(T0.CMS) AS CMS, --佣金
       SUM(T0.FULL_TFEE) AS FULL_TFEE, --全额过户费
       T0.DELI_DT AS DELI_DT, --交割日期
       T0.TRD_CNTP_ID AS TRD_CNTP_ID, --交易对手编码
       T0.APPT_NUM AS APPT_NUM, --约定号
       T0.TRD_PLFM AS TRD_PLFM, --交易平台
       T0.TRD_MODE AS TRD_MODE, --交易方式
       T0.GUAR_SETT_FLAG AS GUAR_SETT_FLAG, --担保交收标志
       T0.RF_VAL AS RF_VAL, --退款金额
       T0.MARG AS MARG, --保证金
       T0.ENTR_DIR_O3 AS ENTR_DIR_O3, --委托方向_O32
       T0.ENTR_DIR_NAME_O3 AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.BUSI_CLAS_O3 AS BUSI_CLAS_O3, --业务分类_O32
       T0.TRAD_ID AS TRAD_ID, --券商编码
       T0.OPER_NO AS OPER_NO, --操作员编码
       T0.TNV_STAT AS TNV_STAT, --成交状态
       T0.CONT_MULT AS CONT_MULT, --合约乘数
       T0.COVR_DIR AS COVR_DIR, --平仓方向
       T0.ARBI_FLAG AS ARBI_FLAG, --套利标志
       T0.RES_FLAG AS RES_FLAG, --限售标识
       T0.LOCK_LMT_CLAS AS LOCK_LMT_CLAS, --锁定受限类型
       T0.LMT_CLAS_ONUM AS LMT_CLAS_ONUM, --受限类型序号
       T0.AGMT_NUM AS AGMT_NUM, --合同号
       T0.PAY_DT AS PAY_DT, --缴款日期
       T0.EXCR_DT AS EXCR_DT, --除权日期
       MAX(T0.ETF_ONUM) AS ETF_ONUM, --ETF序号
       T0.ESTI_CASH_DIFF AS ESTI_CASH_DIFF, --预估现金差额
       T0.ETF_FND_CLAS AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_10' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       OCCU_DT as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
             T0.L_DATE AS OCCU_DT, --发生日期
             CASE
                 WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
                     CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
                 ELSE
                     CONCAT(T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO, '_C')
                 END AS TNV_ONUM, --成交序号
             T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
             CASE WHEN T7.L_DAILY_INSTRUCTION_NO IS NULL OR T7.L_DAILY_INSTRUCTION_NO = 0 THEN
                      NULL
                  ELSE
                      CONCAT(T0.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '_' ,
                             T0.L_BASECOMBI_ID , '_' , (CASE
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                                                                 T5.VC_REPORT_CODE <> '159900' THEN
                                                                'XCSZZJ.CASH.SZ' --深交所本方资金
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                                                                 T10.C_TYPE IN ('2') THEN
                                                                'XCQTZJ.CASH.SZ' --深交所跨境资金
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                                                                 T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                                                                'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                                                                 T10.C_TYPE IN ('5', '6') THEN
                                                                'XCGSZJ.CASH.SZ' --深交所港市资金
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') THEN
                                                                'XCSHZJ.CASH.SZ' --深交所上海市场资金
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 SUBSTR(T5.VC_REPORT_CODE, -1) = '2' THEN
                                                                'XCSHZJ.CASH.SH' --上交所本方资金,老模式
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 T10.C_TYPE IN ('2') THEN
                                                                'XCQTZJ.CASH.SH' --上交所跨境资金，老模式
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                                                                'XCQTZJ.CASH.SH' --上交所商品期货、黄金资金，老模式
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 T10.C_TYPE IN ('5', '6') THEN
                                                                'XCGSZJ.CASH.SH' --上交所港市资金,老模式
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 SUBSTR(T5.VC_REPORT_CODE, 1, 2) <> 'HS' THEN
                                                                'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
                                                            WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                                                                 SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' THEN
                                                                CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                                                                     WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                                                                     WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                                                                     WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH'
                                                                    END --上交所资金,新模式
                          END) , '_' , CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                                            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                                            ELSE T0.C_INVEST_TYPE END , '_' , (CASE
                                                                                   WHEN T0.L_BUSIN_FLAG in ('41517') THEN
                                                                                       '37000102' --ETF基金申购_现金替代
                                                                                   WHEN T0.L_BUSIN_FLAG in ('41518') THEN
                                                                                       '37000105' --ETF基金赎回_现金替代
                          END))
                 END AS ODR_RELA_ONUM, --指令关联序号
             CASE WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
                      CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
                  WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND T7.L_ENTRUST_SERIAL_NO <> 0 THEN
                      CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
                  ELSE
                      CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
                 END AS TRD_SRC_ID, --交易源ID
             CASE
                 WHEN T7.L_ENTRUST_SERIAL_NO IS NULL OR
                      T7.L_ENTRUST_SERIAL_NO = 0 THEN
                     NULL --缺少委托序号时，为空
                 ELSE
                     CONCAT(T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO)
                 END AS ENTR_ONUM, --委托序号
             T4.L_REPORT_ID AS REP_NO, --申报编号
             CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T5.VC_REPORT_CODE <> '159900' THEN
                     'XCSZZJ.CASH.SZ' --深交所本方资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('2') THEN
                     'XCQTZJ.CASH.SZ' --深交所跨境资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                     'XCQTZJ.CASH.SZ' --深交所商品期货、黄金资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('5', '6') THEN
                     'XCGSZJ.CASH.SZ' --深交所港市资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') THEN
                     'XCSHZJ.CASH.SZ' --深交所上海市场资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, -1) = '2' THEN
                     'XCSHZJ.CASH.SH' --上交所本方资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('2') THEN
                     'XCQTZJ.CASH.SH' --上交所跨境资金，老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                     'XCQTZJ.CASH.SH' --上交所商品期货、黄金资金，老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('5', '6') THEN
                     'XCGSZJ.CASH.SH' --上交所港市资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, 1, 2) <> 'HS' THEN
                     'XCSZZJ.CASH.SH' --上交所深圳市场资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' THEN
                     CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH'
                         END --上交所资金,新模式
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
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T5.VC_REPORT_CODE <> '159900' THEN
                     'XCSZZJ' --深交所本方资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('2') THEN
                     'XCQTZJ' --深交所跨境资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                     'XCQTZJ' --深交所商品期货、黄金资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') AND
                      T10.C_TYPE IN ('5', '6') THEN
                     'XCGSZJ' --深交所港市资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SZ') THEN
                     'XCSHZJ' --深交所上海市场资金
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, -1) = '2' THEN
                     'XCSHZJ' --上交所本方资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('2') THEN
                     'XCQTZJ' --上交所跨境资金，老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('3') AND T10.C_ETF_TYPE IN ('4', '7') THEN
                     'XCQTZJ' --上交所商品期货、黄金资金，老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      T10.C_TYPE IN ('5', '6') THEN
                     'XCGSZJ' --上交所港市资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, 1, 2) <> 'HS' THEN
                     'XCSZZJ' --上交所深圳市场资金,老模式
                 WHEN SUBSTR(T9.VC_INTER_CODE, -2) IN ('SS') AND
                      SUBSTR(T5.VC_REPORT_CODE, 1, 2) = 'HS' THEN
                     CASE WHEN T5.VC_INTER_CODE = 'HSHKZJSS' THEN 'XCGSZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSQTZJSS' THEN 'XCQTZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSSHZJSS' THEN 'XCSHZJ.CASH.SH'
                          WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH'
                         END --上交所资金,新模式
                 END AS SECU_CODE, --证券代码
             T9.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
             T9.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
             'L' AS POS_ID, --多空标志,默认多头
             T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
             '370001' AS BUSI_TYP, --业务类别,交易所现券交易
             CASE
                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                     '2' --交易型金融资产
                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                     '1' --持有到期资产
                 ELSE
                     T0.C_INVEST_TYPE
                 END AS INV_TYP, --投资类型
             CASE
                 WHEN T0.L_BUSIN_FLAG in ('41517') THEN
                     '37000118' --ETF基金申购成交_现金替代
                 WHEN T0.L_BUSIN_FLAG in ('41518') THEN
                     '37000121' --ETF基金赎回成交_现金替代
                 END AS BUSI_CLAS, --业务类型
             '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('41513', '41517', '41515') THEN
                     '26'
                 WHEN T0.L_BUSIN_FLAG IN ('41514', '41518', '41516') THEN
                     '27'
                 END AS ENTR_DIR, --委托方向
             1 AS CLR_SPED, --清算速度
             T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
             T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T4.EN_DEAL_PRICE AS TNV_PRC, --成交价格 ,
             NULL AS RAT, --利率,买卖交易为空
             T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
             T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
             T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
             T0.EN_FARE2 AS STMP, --印花税
             T0.EN_FARE3 AS TFEE, --  过户费
             T0.EN_FARE5 AS HAND_FEE, --  经手费
             T0.EN_FARE6 AS SFEE, --  证管费
             T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
             T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
             T0.EN_FARE7 AS OTH_FEE, -- 其他费用
             T0.EN_FARE4 AS CMS, -- 佣金
             T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
             W1.aft_1_dt AS DELI_DT, --交割日期
             CAST(T9.L_TRADE_RIVAL_NO AS STRING) AS TRD_CNTP_ID, -- 交易对手编码
             NULL AS APPT_NUM, --  约定号
             NULL AS TRD_PLFM, --交易平台
             NULL AS TRD_MODE, --交易方式
             NULL AS GUAR_SETT_FLAG, --担保交收标志
             0 AS RF_VAL, -- 退款金额
             0 AS MARG, --  保证金
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
             T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
             T9.VC_BROKER_NO AS TRAD_ID, --券商编码
             T9.L_OPERATOR_NO AS OPER_NO, --操作员
             CAST(NVL(T9.C_VALID, 1) AS INT) AS TNV_STAT, --成交状态
             NULL AS CONT_MULT, --合约乘数
             T9.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
             NULL AS ARBI_FLAG, --套利标志
             0 AS RES_FLAG, --限售标识
             NULL AS LOCK_LMT_CLAS, --锁定受限类型
             NULL AS LMT_CLAS_ONUM, --受限类型序号
             NULL AS AGMT_NUM, --合同号
             NULL AS PAY_DT, --缴款日期
             NULL AS EXCR_DT, --除权日期
             T4.L_REALDEAL_SERIAL_NO AS ETF_ONUM, --ETF序号
             0 AS ESTI_CASH_DIFF, --预估现金差额
             NULL AS ETF_FND_CLAS --ETF基金类型
      FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                         ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                         ON T0.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                         ON T0.L_DATE = T5.L_DATE
                             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_tliquidatedetail T11 --证券基本信息表，筛选交易所市场
                         ON T0.L_DATE = T11.L_DATE
                             AND LPAD(T0.Vc_Deal_No, 64, 0) = LPAD(T11.Vc_Deal_No, 64, 0)
                             AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                             AND T0.VC_STOCKHOLDER_ID = T11.VC_STOCKHOLDER_ID
                             AND T0.VC_SEAT_ID = T11.VC_SEAT_ID
                             AND T0.L_BUSIN_FLAG = T11.L_BUSIN_FLAG
                             AND T0.VC_INTER_CODE = T11.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TETFREALDEAL  T4 --获取成交序号、委托序号、指令序号等交易过程数据
                         ON LPAD(T11.VC_REPORT_ID, 64, 0) = LPAD(T4.L_REPORT_ID, 64, 0)
                             AND T0.L_DATE = T4.L_DATE
                             AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                             AND T5.VC_REPORT_CODE = T4.VC_REALDEAL_CODE
                             AND T5.C_MARKET_NO = T4.C_MARKET_NO
               LEFT JOIN ${ods_db}.O3_TENTRUSTS T7
                         ON T4.L_DATE = T7.L_DATE
                             AND T4.L_ENTRUST_SERIAL_NO = T7.L_ENTRUST_SERIAL_NO
               LEFT JOIN ${ods_db}.O3_TREALDEAL T9
                         ON T4.L_DATE = T9.L_DATE
                             AND T4.L_ENTRUST_SERIAL_NO = T9.L_ENTRUST_SERIAL_NO
                             AND T9.C_VALID = T0.C_STATUS
               LEFT JOIN ${ods_db}.O3_TETFBASICINFO T10
                         ON T0.L_DATE = T10.L_DATE
                             AND T4.VC_REPORT_CODE = T10.VC_ETF_CODE
                             AND T10.C_EXEC_TYPE NOT IN ('2')
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                         ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                             AND T5.C_MARKET_NO = T8.C_MARKET_NO
               LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                         ON T0.L_DATE = W1.dt
                             AND T5.C_MARKET_NO = W1.mkt_no
                             AND W1.SYS_RS_ID = 'O3'
      WHERE T0.C_BUSIN_CLASS IN ('6')
        AND T0.L_BUSIN_FLAG IN ('41517', '41518')
        AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
        AND T0.L_DATE = ${current_date}
     ) T0
GROUP BY BUSI_SYS_ID,
         OCCU_DT,
         TNV_TIME,
         ODR_RELA_ONUM,
         TRD_SRC_ID,
         ENTR_ONUM,
         REP_NO,
         PRD_CODE,
         AST_UNIT_CODE,
         PFL_CODE,
         SH_CODE,
         SEAT_CODE,
         SECU_ID,
         EXCH_CODE,
         SECU_CODE,
         SRC_SECU_ID,
         SRC_SECU_TRD_ID,
         POS_ID,
         CURR_CODE,
         BUSI_TYP,
         INV_TYP,
         BUSI_CLAS,
         CLR_TYP,
         ENTR_DIR,
         CLR_SPED,
         RAT,
         DELI_DT,
         TRD_CNTP_ID,
         APPT_NUM,
         TRD_PLFM,
         TRD_MODE,
         GUAR_SETT_FLAG,
         RF_VAL,
         MARG,
         ENTR_DIR_O3,
         ENTR_DIR_NAME_O3,
         BUSI_CLAS_O3,
         TRAD_ID,
         OPER_NO,
         TNV_STAT,
         CONT_MULT,
         COVR_DIR,
         ARBI_FLAG,
         RES_FLAG,
         LOCK_LMT_CLAS,
         LMT_CLAS_ONUM,
         AGMT_NUM,
         PAY_DT,
         EXCR_DT,
         ESTI_CASH_DIFF,
         ETF_FND_CLAS

UNION ALL
--成交：20220902 ETF现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
SELECT T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
       T0.OCCU_DT AS OCCU_DT, --发生日期
       MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
       T0.TNV_TIME AS TNV_TIME, --成交时间
       T0.ODR_RELA_ONUM AS ODR_RELA_ONUM, --指令关联序号
       T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
       T0.ENTR_ONUM AS ENTR_ONUM, --委托序号
       T0.REP_NO AS REP_NO, --申报编号
       MAX(T0.TNV_NO) AS TNV_NO, --成交编号
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE AS PFL_CODE, --投组代码
       T0.SH_CODE AS SH_CODE, --股东代码
       T0.SEAT_CODE AS SEAT_CODE, --席位号
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.SECU_CODE AS SECU_CODE, --证券代码
       T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
       T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
       T0.POS_ID AS POS_ID, --多空标志
       T0.CURR_CODE AS CURR_CODE, --货币代码
       T0.BUSI_TYP AS BUSI_TYP, --业务类别
       T0.INV_TYP AS INV_TYP, --投资类型
       T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
       T0.CLR_TYP AS CLR_TYP, --清算类型
       T0.ENTR_DIR AS ENTR_DIR, --委托方向
       T0.CLR_SPED AS CLR_SPED, --清算速度
       SUM(T0.TNV_VOL) AS TNV_VOL, --成交数量
       SUM(T0.AFT_PAR_VOL) AS AFT_PAR_VOL, --发生后数量
       MAX(T0.TNV_PRC) AS TNV_PRC, --成交价格
       T0.RAT AS RAT, --利率
       SUM(T0.TNV_VAL) AS TNV_VAL, --成交金额
       SUM(T0.OCCU_VAL) AS OCCU_VAL, --发生金额
       SUM(T0.AFT_OCCU_VAL) AS AFT_OCCU_VAL, --发生后资金金额
       SUM(T0.STMP) AS STMP, --印花税
       SUM(T0.TFEE) AS TFEE, --过户费
       SUM(T0.HAND_FEE) AS HAND_FEE, --经手费
       SUM(T0.SFEE) AS SFEE, --证管费
       SUM(T0.CLEA_CHAG) AS CLEA_CHAG, --结算费
       SUM(T0.CLEA_RPTL) AS CLEA_RPTL, --结算风险金
       SUM(T0.OTH_FEE) AS OTH_FEE, --其他费用
       SUM(T0.CMS) AS CMS, --佣金
       SUM(T0.FULL_TFEE) AS FULL_TFEE, --全额过户费
       T0.DELI_DT AS DELI_DT, --交割日期
       T0.TRD_CNTP_ID AS TRD_CNTP_ID, --交易对手编码
       T0.APPT_NUM AS APPT_NUM, --约定号
       T0.TRD_PLFM AS TRD_PLFM, --交易平台
       T0.TRD_MODE AS TRD_MODE, --交易方式
       T0.GUAR_SETT_FLAG AS GUAR_SETT_FLAG, --担保交收标志
       T0.RF_VAL AS RF_VAL, --退款金额
       T0.MARG AS MARG, --保证金
       T0.ENTR_DIR_O3 AS ENTR_DIR_O3, --委托方向_O32
       T0.ENTR_DIR_NAME_O3 AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.BUSI_CLAS_O3 AS BUSI_CLAS_O3, --业务分类_O32
       T0.TRAD_ID AS TRAD_ID, --券商编码
       T0.OPER_NO AS OPER_NO, --操作员编码
       T0.TNV_STAT AS TNV_STAT, --成交状态
       T0.CONT_MULT AS CONT_MULT, --合约乘数
       T0.COVR_DIR AS COVR_DIR, --平仓方向
       T0.ARBI_FLAG AS ARBI_FLAG, --套利标志
       T0.RES_FLAG AS RES_FLAG, --限售标识
       T0.LOCK_LMT_CLAS AS LOCK_LMT_CLAS, --锁定受限类型
       T0.LMT_CLAS_ONUM AS LMT_CLAS_ONUM, --受限类型序号
       T0.AGMT_NUM AS AGMT_NUM, --合同号
       T0.PAY_DT AS PAY_DT, --缴款日期
       T0.EXCR_DT AS EXCR_DT, --除权日期
       MAX(T0.ETF_ONUM) AS ETF_ONUM, --ETF序号
       T0.ESTI_CASH_DIFF AS ESTI_CASH_DIFF, --预估现金差额
       T0.ETF_FND_CLAS AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_11' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.OCCU_DT AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
             W1.pre_1_dt AS OCCU_DT, --发生日期
             CONCAT(W1.pre_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
             NULL AS TNV_TIME, --成交时间
             CASE WHEN T7.L_DAILY_INSTRUCTION_NO IS NULL OR T7.L_DAILY_INSTRUCTION_NO = 0 THEN
                      NULL
                  ELSE
                      CONCAT(T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                             T5.VC_REPORT_CODE , '.FUND.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END , '_' ,
                             CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                                  WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                                  ELSE T0.C_INVEST_TYPE END , '_' , (CASE
                                                                         WHEN T9.C_ENTRUST_DIRECTION IN ('P') THEN
                                                                             '37000100' --ETF基金申购_基金
                                                                         WHEN T9.C_ENTRUST_DIRECTION IN ('Q') THEN
                                                                             '37000103' --ETF基金赎回_基金
                          END))
                 END AS ODR_RELA_ONUM, --指令关联序号
             CASE WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
                      CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
                  WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND T7.L_ENTRUST_SERIAL_NO <> 0 THEN
                      CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
                  ELSE
                      CONCAT('0|0|0|' , T9.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
                 END AS TRD_SRC_ID, --交易源ID
             CASE
                 WHEN T7.L_ENTRUST_SERIAL_NO IS NULL OR
                      T7.L_ENTRUST_SERIAL_NO = 0 THEN
                     NULL --缺少委托序号时，为空
                 ELSE
                     CONCAT(T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO)
                 END AS ENTR_ONUM, --委托序号
             T9.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
             CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                    CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) AS SECU_ID, --证券编码
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
             T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
             '370001' AS BUSI_TYP, --业务类别,交易所现券交易
             CASE
                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                     '2' --交易型金融资产
                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                     '1' --持有到期资产
                 ELSE
                     T0.C_INVEST_TYPE
                 END AS INV_TYP, --投资类型
             CASE
                 WHEN T0.L_BUSIN_FLAG in ('41519') THEN
                     '37000106' --ETF现金差额退款
                 WHEN T0.L_BUSIN_FLAG in ('72109') THEN
                     '37000107' --ETF现金差额补款
                 WHEN T0.L_BUSIN_FLAG in ('72110') THEN
                     '37000108' --ETF现金替代退款
                 WHEN T0.L_BUSIN_FLAG in ('72114') THEN
                     '37000109' --ETF现金替代补款
                 END AS BUSI_CLAS, --业务类型
             '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
             CASE
                 WHEN T7.C_ENTRUST_DIRECTION = 'P' THEN
                     '26'
                 WHEN T7.C_ENTRUST_DIRECTION = 'Q' THEN
                     '27'
                 END AS ENTR_DIR, --委托方向
             1 AS CLR_SPED, --清算速度
             0 AS TNV_VOL, --成交数量
             0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             0 AS TNV_PRC, --成交价格
             NULL AS RAT, --利率,买卖交易为空
             T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
             T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
             T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
             T0.EN_FARE2 AS STMP, --印花税
             T0.EN_FARE3 AS TFEE, --  过户费
             T0.EN_FARE5 AS HAND_FEE, --  经手费
             T0.EN_FARE6 AS SFEE, --  证管费
             T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
             T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
             T0.EN_FARE7 AS OTH_FEE, -- 其他费用
             T0.EN_FARE4 AS CMS, -- 佣金
             T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
             T0.L_DATE AS DELI_DT, --交割日期
             CAST(T9.L_TRADE_RIVAL_NO AS STRING) AS TRD_CNTP_ID, -- 交易对手编码
             NULL AS APPT_NUM, --  约定号
             NULL AS TRD_PLFM, --交易平台
             NULL AS TRD_MODE, --交易方式
             NULL AS GUAR_SETT_FLAG, --担保交收标志
             0 AS RF_VAL, -- 退款金额
             0 AS MARG, --  保证金
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
             T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
             T9.VC_BROKER_NO AS TRAD_ID, --券商编码
             T9.L_OPERATOR_NO AS OPER_NO, --操作员
             CAST(NVL(T9.C_VALID, 1) AS INT) AS TNV_STAT, --成交状态
             NULL AS CONT_MULT, --合约乘数
             T9.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
             NULL AS ARBI_FLAG, --套利标志
             0 AS RES_FLAG, --限售标识
             NULL AS LOCK_LMT_CLAS, --锁定受限类型
             NULL AS LMT_CLAS_ONUM, --受限类型序号
             NULL AS AGMT_NUM, --合同号
             NULL AS PAY_DT, --缴款日期
             NULL AS EXCR_DT, --除权日期
             NULL AS ETF_ONUM, --ETF序号
             NULL AS ESTI_CASH_DIFF, --预估现金差额
             NULL AS ETF_FND_CLAS --ETF基金类型
      FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                         ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                         ON T0.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                         ON T0.L_DATE = T5.L_DATE
                             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN (
          select t8.*
          from ${ods_db}.O3_TCURRENTS T0
                   inner join VHISUNCOMPLETELOG T8 --未完成，取未完成和已完成表的全量数据
                              ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T8.VC_DEAL_NO, 64, 0)
                                  AND T0.L_FUND_ID = T8.L_FUND_ID
                                  AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
                                  AND T8.L_BUSIN_FLAG = '72855'
          where T0.L_DATE >= T8.L_TRADE_DATE
            AND T0.L_DATE <= T8.L_COMPLETE_DATE
      ) t8
                         ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T8.VC_DEAL_NO, 64, 0)
                             AND T0.L_FUND_ID = T8.L_FUND_ID
                             AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TETFREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
                         ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T4.VC_DEAL_NO, 64, 0)
                             AND T8.L_TRADE_DATE = T4.L_DATE
                             AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                             AND T5.VC_REPORT_CODE = T4.VC_REALDEAL_CODE
                             AND T5.C_MARKET_NO = T4.C_MARKET_NO
               LEFT JOIN ${ods_db}.O3_TENTRUSTS T7
                         ON T4.L_DATE = T7.L_DATE
                             AND T4.L_ENTRUST_SERIAL_NO = T7.L_ENTRUST_SERIAL_NO
               LEFT JOIN ${ods_db}.O3_TREALDEAL T9
                         ON T4.L_DATE = T9.L_DATE
                             AND T4.L_ENTRUST_SERIAL_NO = T9.L_ENTRUST_SERIAL_NO
                             AND T9.C_VALID = T0.C_STATUS
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                         ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                             AND T5.C_MARKET_NO = T10.C_MARKET_NO
               LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                         ON T0.L_DATE = W1.dt
                             AND T5.C_MARKET_NO = W1.mkt_no
                             AND W1.SYS_RS_ID = 'O3'
      WHERE T0.C_BUSIN_CLASS IN ('6')
        AND T0.L_BUSIN_FLAG IN ('41519', '72109', '72110', '72114')
        AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
        AND W1.pre_1_dt = ${current_date}
     ) T0
GROUP BY BUSI_SYS_ID,
         OCCU_DT,
         TNV_TIME,
         ODR_RELA_ONUM,
         TRD_SRC_ID,
         ENTR_ONUM,
         REP_NO,
         PRD_CODE,
         AST_UNIT_CODE,
         PFL_CODE,
         SH_CODE,
         SEAT_CODE,
         SECU_ID,
         EXCH_CODE,
         SECU_CODE,
         SRC_SECU_ID,
         SRC_SECU_TRD_ID,
         POS_ID,
         CURR_CODE,
         BUSI_TYP,
         INV_TYP,
         BUSI_CLAS,
         CLR_TYP,
         ENTR_DIR,
         CLR_SPED,
         RAT,
         DELI_DT,
         TRD_CNTP_ID,
         APPT_NUM,
         TRD_PLFM,
         TRD_MODE,
         GUAR_SETT_FLAG,
         RF_VAL,
         MARG,
         ENTR_DIR_O3,
         ENTR_DIR_NAME_O3,
         BUSI_CLAS_O3,
         TRAD_ID,
         OPER_NO,
         TNV_STAT,
         CONT_MULT,
         COVR_DIR,
         ARBI_FLAG,
         RES_FLAG,
         LOCK_LMT_CLAS,
         LMT_CLAS_ONUM,
         AGMT_NUM,
         PAY_DT,
         EXCR_DT,
         ESTI_CASH_DIFF,
         ETF_FND_CLAS

UNION ALL
--20220902 跨市场ETF(中登)确认_ETF申购_基金、成分券、现金替代
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       W1.pre_1_dt  AS OCCU_DT, --发生日期
       CONCAT(W1.pre_1_dt , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , W1.pre_1_dt , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.VC_REPORT_ID AS REP_NO, --申报编号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72834', '72835', '72836', '72837') THEN
               CASE
                   WHEN T5.C_ASSET_CLASS = '2' THEN
                       CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
                              CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                   WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                   WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                   WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                   WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                                   WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
                                  END)
                   WHEN T5.C_ASSET_CLASS = '3' THEN
                       CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                              CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                   WHEN T5.C_ASSET_CLASS = '4' THEN
                       CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                              CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                   END
           WHEN T0.L_BUSIN_FLAG in ('72489','72492') THEN
               (CASE
                    WHEN  T5.VC_REPORT_CODE <> '159900' THEN
                        'XCSZZJ.CASH.SZ' --深交所本方资金
                    WHEN  T5.VC_REPORT_CODE = '159900' THEN
                        'XCSHZJ.CASH.SZ' --深交所上海市场资金
                   END)
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           END AS EXCH_CODE, --交易市场代码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72834', '72835', '72836', '72837') THEN
               (CASE
                    WHEN T5.C_ASSET_CLASS = '2' THEN
                        T5.VC_REPORT_CODE
                    WHEN T5.C_ASSET_CLASS = '3' THEN
                        T5.VC_REPORT_CODE
                    WHEN T5.C_ASSET_CLASS = '4' THEN
                        T5.VC_REPORT_CODE
                   END)
           WHEN T0.L_BUSIN_FLAG IN ('72489','72492') THEN
               (CASE
                    WHEN T5.VC_REPORT_CODE <> '159900' THEN
                        'XCSZZJ' --深交所本方资金
                    WHEN T5.VC_REPORT_CODE = '159900' THEN
                        'XCSHZJ' --深交所上海市场资金
                   END)
           END AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '370001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG in ('72834') THEN
               '37000110' --ETF基金申购确认_基金
           WHEN T0.L_BUSIN_FLAG in ('72836') THEN
               '37000111' --ETF基金申购确认_成分券
           WHEN T0.L_BUSIN_FLAG in ('72489') THEN
               '37000112' --ETF基金申购确认_现金替代
           WHEN T0.L_BUSIN_FLAG in ('72835') THEN
               '37000113' --ETF基金赎回确认_基金
           WHEN T0.L_BUSIN_FLAG in ('72837') THEN
               '37000114' --ETF基金赎回确认_成分券
           WHEN T0.L_BUSIN_FLAG in ('72492') THEN
               '37000115' --ETF基金赎回确认_现金替代
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72834', '72836', '72489') THEN
               '26'
           WHEN T0.L_BUSIN_FLAG IN ('72835', '72837', '72492') THEN
               '27'
           END AS ENTR_DIR, --委托方向
       1 AS CLR_SPED, --清算速度
       T0.L_DEAL_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_DEAL_PRICE AS TNV_PRC, --成交价格 ,
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_DEAL_BALANCE + NVL(T0.EN_FEE_YH, 0) +
       NVL(T0.EN_FEE_GH, 0) + NVL(T0.EN_FEE_JS, 0) + NVL(T0.EN_FEE_ZG, 0) +
       NVL(T0.EN_FEE_JS2, 0) + NVL(T0.EN_RISK_FUND, 0) +
       NVL(T0.EN_FEE_QT, 0) + NVL(T0.EN_FEE_YJ, 0) AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_FEE_YH AS STMP, --印花税
       T0.EN_FEE_GH AS TFEE, --  过户费
       T0.EN_FEE_JS AS HAND_FEE, --  经手费
       T0.EN_FEE_ZG AS SFEE, --  证管费
       T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
       T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
       T0.EN_FEE_QT AS OTH_FEE, -- 其他费用
       T0.EN_FEE_YJ AS CMS, -- 佣金
       0 AS FULL_TFEE, --全额过户费
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('72834', '72836', '72835', '72837') THEN
               T0.L_DATE
           WHEN T0.L_BUSIN_FLAG IN ('72489', '72492') THEN
               W1.aft_1_dt
           END AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       NULL AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE,--交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       NULL AS ETF_ONUM, --ETF序号
       CASE
           WHEN T0.L_BUSIN_FLAG in ('72834') THEN
                       T0.L_DEAL_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
           WHEN T0.L_BUSIN_FLAG in ('72835') THEN
                       -T0.L_DEAL_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
           END AS ESTI_CASH_DIFF, --预估现金差额
       CASE WHEN T0.L_BUSIN_FLAG in ('72834', '72835') THEN
                '3'
            ELSE NULL
           END AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_second_12' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       W1.pre_1_dt as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM VHISLIQUIDATEDETAIL T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                   ON T0.L_DATE = W1.dt
                       AND W1.mkt_no in ('1','2')
                       AND W1.SYS_RS_ID = 'O3'
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON W1.pre_1_dt = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         LEFT JOIN ${ods_db}.O3_TETFBASICINFO T9
                   ON W1.pre_1_dt = T9.L_DATE
                       AND T5.VC_REPORT_CODE = T9.VC_REPORT_CODE
                       AND T9.C_EXEC_TYPE IN ('2')
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                   ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T10.C_MARKET_NO
     LEFT JOIN ${ods_db}.O3_TENTRUSTS T4
       ON T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
              AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
              AND T0.VC_SEAT_ID = T4.VC_SEAT_ID
              AND LPAD(T0.VC_REPORT_ID, 64, '0') = LPAD(T4.L_REPORT_SERIAL_NO, 64, '0')
              AND T0.L_BUSINESS_DATE = T4.L_DATE
WHERE T0.C_BUSIN_CLASS IN ('6')
  AND T0.L_BUSIN_FLAG IN ('72834', '72836', '72489', '72835', '72837', '72492')
  --YANGLI
  AND W1.pre_1_dt = ${current_date}

UNION ALL
--20220902:跨市场ETF(中登)成交_ETF申购_基金、成分券、现金替代、现金差额退补、现金替代退补
SELECT T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
       T0.OCCU_DT AS OCCU_DT, --发生日期
       MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
       T0.TNV_TIME AS TNV_TIME, --成交时间
       T0.ODR_RELA_ONUM AS ODR_RELA_ONUM, --指令关联序号
       T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
       T0.ENTR_ONUM AS ENTR_ONUM, --委托序号
       T0.REP_NO AS REP_NO, --申报编号
       MAX(T0.TNV_NO) AS TNV_NO, --成交编号
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE AS PFL_CODE, --投组代码
       T0.SH_CODE AS SH_CODE, --股东代码
       T0.SEAT_CODE AS SEAT_CODE, --席位号
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.SECU_CODE AS SECU_CODE, --证券代码
       T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
       T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
       T0.POS_ID AS POS_ID, --多空标志
       T0.CURR_CODE AS CURR_CODE, --货币代码
       T0.BUSI_TYP AS BUSI_TYP, --业务类别
       T0.INV_TYP AS INV_TYP, --投资类型
       T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
       T0.CLR_TYP AS CLR_TYP, --清算类型
       T0.ENTR_DIR AS ENTR_DIR, --委托方向
       T0.CLR_SPED AS CLR_SPED, --清算速度
       SUM(T0.TNV_VOL) AS TNV_VOL, --成交数量
       SUM(T0.AFT_PAR_VOL) AS AFT_PAR_VOL, --发生后数量
       MAX(T0.TNV_PRC) AS TNV_PRC, --成交价格
       T0.RAT AS RAT, --利率
       SUM(T0.TNV_VAL) AS TNV_VAL, --成交金额
       SUM(T0.OCCU_VAL) AS OCCU_VAL, --发生金额
       SUM(T0.AFT_OCCU_VAL) AS AFT_OCCU_VAL, --发生后资金金额
       SUM(T0.STMP) AS STMP, --印花税
       SUM(T0.TFEE) AS TFEE, --过户费
       SUM(T0.HAND_FEE) AS HAND_FEE, --经手费
       SUM(T0.SFEE) AS SFEE, --证管费
       SUM(T0.CLEA_CHAG) AS CLEA_CHAG, --结算费
       SUM(T0.CLEA_RPTL) AS CLEA_RPTL, --结算风险金
       SUM(T0.OTH_FEE) AS OTH_FEE, --其他费用
       SUM(T0.CMS) AS CMS, --佣金
       SUM(T0.FULL_TFEE) AS FULL_TFEE, --全额过户费
       T0.DELI_DT AS DELI_DT, --交割日期
       T0.TRD_CNTP_ID AS TRD_CNTP_ID, --交易对手编码
       T0.APPT_NUM AS APPT_NUM, --约定号
       T0.TRD_PLFM AS TRD_PLFM, --交易平台
       T0.TRD_MODE AS TRD_MODE, --交易方式
       T0.GUAR_SETT_FLAG AS GUAR_SETT_FLAG, --担保交收标志
       T0.RF_VAL AS RF_VAL, --退款金额
       T0.MARG AS MARG, --保证金
       T0.ENTR_DIR_O3 AS ENTR_DIR_O3, --委托方向_O32
       T0.ENTR_DIR_NAME_O3 AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.BUSI_CLAS_O3 AS BUSI_CLAS_O3, --业务分类_O32
       T0.TRAD_ID AS TRAD_ID, --券商编码
       T0.OPER_NO AS OPER_NO, --操作员编码
       T0.TNV_STAT AS TNV_STAT, --成交状态
       T0.CONT_MULT AS CONT_MULT, --合约乘数
       T0.COVR_DIR AS COVR_DIR, --平仓方向
       T0.ARBI_FLAG AS ARBI_FLAG, --套利标志
       T0.RES_FLAG AS RES_FLAG, --限售标识
       T0.LOCK_LMT_CLAS AS LOCK_LMT_CLAS, --锁定受限类型
       T0.LMT_CLAS_ONUM AS LMT_CLAS_ONUM, --受限类型序号
       T0.AGMT_NUM AS AGMT_NUM, --合同号
       T0.PAY_DT AS PAY_DT, --缴款日期
       T0.EXCR_DT AS EXCR_DT, --除权日期
       MAX(T0.ETF_ONUM) AS ETF_ONUM, --ETF序号
       T0.ESTI_CASH_DIFF AS ESTI_CASH_DIFF, --预估现金差额
       T0.ETF_FND_CLAS AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_second_13' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.OCCU_DT AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
             W1.pre_1_dt AS OCCU_DT, --发生日期
             CONCAT(W1.pre_1_dt , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
             NULL AS TNV_TIME, --成交时间
             NULL AS ODR_RELA_ONUM, --指令关联序号
             CONCAT('0|0|0|' , W1.pre_1_dt , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
             CONCAT(T8.L_DATE , '_HSO32' , '_' , T8.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
             T0.VC_REPORT_ID AS REP_NO, --申报编号
             T0.VC_DEAL_NO AS TNV_NO, --成交编号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO, '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('72840',
                                          '72841',
                                          '72842',
                                          '72843',
                                          '72501',
                                          '72504',
                                          '72495',
                                          '72498') THEN
                     (CASE
                          WHEN T5.C_ASSET_CLASS = '2' THEN
                              CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
                                     (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                           WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                           WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                           WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                           WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                                           WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
                                         END))
                          WHEN T5.C_ASSET_CLASS = '3' THEN
                              CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                                     CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                          WHEN T5.C_ASSET_CLASS = '4' THEN
                              CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                                     CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                         END)
                 WHEN T0.L_BUSIN_FLAG in ('72490', '72493') THEN
                     (CASE
                          WHEN T5.VC_REPORT_CODE <> '159900' THEN
                              'XCSZZJ.CASH.SZ' --深交所本方资金
                          WHEN T5.VC_REPORT_CODE = '159900' THEN
                              'XCSHZJ.CASH.SZ' --深交所上海市场资金
                         END)
                 END AS SECU_ID, --证券编码
             CASE
                 WHEN T5.C_MARKET_NO = '1' THEN
                     'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN
                     'SZ'
                 END AS EXCH_CODE, --交易市场代码
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('72840',
                                          '72841',
                                          '72842',
                                          '72843',
                                          '72501',
                                          '72504',
                                          '72495',
                                          '72498') THEN
                     (CASE
                          WHEN T5.C_ASSET_CLASS = '2' THEN
                              T5.VC_REPORT_CODE
                          WHEN T5.C_ASSET_CLASS = '3' THEN
                              T5.VC_REPORT_CODE
                          WHEN T5.C_ASSET_CLASS = '4' THEN
                              T5.VC_REPORT_CODE
                         END)
                 WHEN T0.L_BUSIN_FLAG in ('72490', '72493') THEN
                     (CASE
                          WHEN T5.VC_REPORT_CODE <> '159900' THEN
                              'XCSZZJ' --深交所本方资金
                          WHEN T5.VC_REPORT_CODE = '159900' THEN
                              'XCSHZJ' --深交所上海市场资金
                         END)
                 END AS SECU_CODE, --证券代码
             T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
             T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
             'L' AS POS_ID, --多空标志,默认多头
             T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
             '370001' AS BUSI_TYP, --业务类别,交易所现券交易
             CASE
                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                     '2' --交易型金融资产
                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                     '1' --持有到期资产
                 ELSE
                     T0.C_INVEST_TYPE
                 END AS INV_TYP, --投资类型
             CASE
                 WHEN T0.L_BUSIN_FLAG in ('72840') THEN
                     '37000116' --ETF基金申购成交_基金
                 WHEN T0.L_BUSIN_FLAG in ('72842') THEN
                     '37000117' --ETF基金申购成交_成分券
                 WHEN T0.L_BUSIN_FLAG in ('72490') THEN
                     '37000118' --ETF基金申购成交_现金替代
                 WHEN T0.L_BUSIN_FLAG in ('72841') THEN
                     '37000119' --ETF基金赎回成交_基金
                 WHEN T0.L_BUSIN_FLAG in ('72843') THEN
                     '37000120' --ETF基金赎回成交_成分券
                 WHEN T0.L_BUSIN_FLAG in ('72493') THEN
                     '37000121' --ETF基金赎回成交_现金替代
                 WHEN T0.L_BUSIN_FLAG in ('72495') THEN
                     '37000106' --ETF基金（投资端）现金差额退款
                 WHEN T0.L_BUSIN_FLAG in ('72498') THEN
                     '37000107' --ETF基金（投资端）现金差额补款
                 WHEN T0.L_BUSIN_FLAG in ('72501') THEN
                     '37000108' --ETF基金（投资端）现金替代退款
                 WHEN T0.L_BUSIN_FLAG in ('72504') THEN
                     '37000109' --ETF基金（投资端）现金替代补款
                 END AS BUSI_CLAS, --业务类型
             '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('72840', '72841') THEN
                     0
                 ELSE
                     1
                 END AS CLR_SPED, --清算速度
             CASE
                 WHEN nvl(T4.L_BUSIN_FLAG,T41.L_BUSIN_FLAG) IN ('72834') THEN
                     '26'
                 WHEN nvl(T4.L_BUSIN_FLAG,T41.L_BUSIN_FLAG) IN ('72835') THEN
                     '27'
                 END AS ENTR_DIR, --委托方向
             T0.L_DEAL_AMOUNT AS TNV_VOL, --成交数量
             0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T0.EN_DEAL_PRICE AS TNV_PRC, --成交价格 ,
             NULL AS RAT, --利率,买卖交易为空
             ABS(T0.EN_DEAL_BALANCE) AS TNV_VAL, --成交金额
             ABS(T0.EN_DEAL_BALANCE) + NVL(T0.EN_FEE_YH, 0) +
             NVL(T0.EN_FEE_GH, 0) + NVL(T0.EN_FEE_JS, 0) +
             NVL(T0.EN_FEE_ZG, 0) + NVL(T0.EN_FEE_JS2, 0) +
             NVL(T0.EN_RISK_FUND, 0) + NVL(T0.EN_FEE_QT, 0) +
             NVL(T0.EN_FEE_YJ, 0) AS OCCU_VAL, --发生金额
             0 AS AFT_OCCU_VAL, --发生后资金金额
             T0.EN_FEE_YH AS STMP, --印花税
             T0.EN_FEE_GH AS TFEE, --  过户费
             T0.EN_FEE_JS AS HAND_FEE, --  经手费
             T0.EN_FEE_ZG AS SFEE, --  证管费
             T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费
             T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金
             T0.EN_FEE_QT AS OTH_FEE, -- 其他费用
             T0.EN_FEE_YJ AS CMS, -- 佣金
             0 AS FULL_TFEE, --全额过户费
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('72840', '72841') THEN
                     W1.pre_1_dt
                 ELSE
                     T0.L_DATE
                 END AS DELI_DT, --交割日期
             NULL AS TRD_CNTP_ID, -- 交易对手编码
             NULL AS APPT_NUM, --  约定号
             NULL AS TRD_PLFM, --交易平台
             NULL AS TRD_MODE, --交易方式
             NULL AS GUAR_SETT_FLAG, --担保交收标志
             0 AS RF_VAL, -- 退款金额
             0 AS MARG, --  保证金
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
             T10.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
             NULL AS ETF_ONUM, --ETF序号
             CASE
                 WHEN T0.L_BUSIN_FLAG in ('72840') THEN
                             T0.L_DEAL_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
                 WHEN T0.L_BUSIN_FLAG in ('72841') THEN
                             -T0.L_DEAL_AMOUNT / T9.L_REPORT_UNIT * T9.EN_ESTIMATECASH
                 END AS ESTI_CASH_DIFF, --预估现金差额
             CASE
                 WHEN T0.L_BUSIN_FLAG in ('72840', '72841') THEN
                     '3'
                 ELSE
                     NULL
                 END AS ETF_FND_CLAS --ETF基金类型
      FROM VHISLIQUIDATEDETAIL T0 --清算流水主表
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                         ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                         ON T3.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                         ON T0.L_DATE = T5.L_DATE
                             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN VHISLIQUIDATEDETAIL T4
                         ON SUBSTR(T0.VC_REPORT_ID, -3) = SUBSTR(T4.VC_REPORT_ID, -3)
                             AND T0.L_FUND_ID = T4.L_FUND_ID
                             AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                             AND T4.L_BUSIN_FLAG IN ('72834', '72835')
               LEFT JOIN VHISLIQUIDATEDETAIL T41
                         ON SUBSTR(T0.VC_REPORT_ID, -3) = SUBSTR(T41.VC_REPORT_ID, -3)
                             AND T0.L_FUND_ID = T41.L_FUND_ID
                             AND T0.L_BASECOMBI_ID = T41.L_BASECOMBI_ID
                             AND T0.L_BUSINESS_DATE = T41.L_DATE
                             AND T41.L_BUSIN_FLAG IN ('72834', '72835')
               LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W2
                         ON T4.L_DATE = W2.dt
                             AND T5.C_MARKET_NO = W2.mkt_no
                             AND W2.SYS_RS_ID = 'O3'
                             AND T0.L_BUSINESS_DATE = W2.pre_1_dt
           LEFT JOIN ${ods_db}.O3_TENTRUSTS T8
             ON T4.L_BASECOMBI_ID = T8.L_BASECOMBI_ID
                    AND T4.VC_STOCKHOLDER_ID = T8.VC_STOCKHOLDER_ID
                    AND T4.VC_SEAT_ID = T8.VC_SEAT_ID
                    AND LPAD(T4.VC_REPORT_ID, 64, '0') = LPAD(T8.L_REPORT_SERIAL_NO, 64, '0')
                    AND T4.L_BUSINESS_DATE = T8.L_DATE
           LEFT JOIN ${ods_db}.O3_TETFBASICINFO T9
                         ON T0.L_DATE = T9.L_DATE
                             AND T5.VC_REPORT_CODE = T9.VC_REPORT_CODE
                             AND T9.C_EXEC_TYPE IN ('2')
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                         ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                             AND T5.C_MARKET_NO = T10.C_MARKET_NO
               LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                         ON T0.L_DATE = W1.dt
                             AND T5.C_MARKET_NO = W1.mkt_no
                             AND W1.SYS_RS_ID = 'O3'
      WHERE T0.C_BUSIN_CLASS IN ('6')
        AND T0.L_BUSIN_FLAG IN ('72840','72841','72842','72843','72490','72493','72495','72498','72501','72504')
        AND W1.pre_1_dt = ${current_date}
     ) T0
GROUP BY BUSI_SYS_ID,
         OCCU_DT,
         TNV_TIME,
         ODR_RELA_ONUM,
         TRD_SRC_ID,
         ENTR_ONUM,
         REP_NO,
         PRD_CODE,
         AST_UNIT_CODE,
         PFL_CODE,
         SH_CODE,
         SEAT_CODE,
         SECU_ID,
         EXCH_CODE,
         SECU_CODE,
         SRC_SECU_ID,
         SRC_SECU_TRD_ID,
         POS_ID,
         CURR_CODE,
         BUSI_TYP,
         INV_TYP,
         BUSI_CLAS,
         CLR_TYP,
         ENTR_DIR,
         CLR_SPED,
         RAT,
         DELI_DT,
         TRD_CNTP_ID,
         APPT_NUM,
         TRD_PLFM,
         TRD_MODE,
         GUAR_SETT_FLAG,
         RF_VAL,
         MARG,
         ENTR_DIR_O3,
         ENTR_DIR_NAME_O3,
         BUSI_CLAS_O3,
         TRAD_ID,
         OPER_NO,
         TNV_STAT,
         CONT_MULT,
         COVR_DIR,
         ARBI_FLAG,
         RES_FLAG,
         LOCK_LMT_CLAS,
         LMT_CLAS_ONUM,
         AGMT_NUM,
         PAY_DT,
         EXCR_DT,
         ESTI_CASH_DIFF,
         ETF_FND_CLAS

