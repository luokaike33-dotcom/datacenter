-----------------------------------------------------------------------
-- 模块名称：交易所清算流水(盘后)
-- 业务：
--离线清算：质押式协议回购首期\到期\续做\提前购回\解除质押
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

insert into ${dwd_db}.evt_exch_clea_jour_his partition(p_dt,sys_rs_id)
(busi_sys_id,occu_dt,tnv_onum,tnv_time,odr_rela_onum,trd_src_id,entr_onum,rep_no,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_typ,entr_dir,clr_sped,tnv_vol,aft_par_vol,tnv_prc,rat,tnv_val,occu_val,aft_occu_val,stmp,tfee,hand_fee,sfee,clea_chag,clea_rptl,oth_fee,cms,full_tfee,deli_dt,trd_cntp_id,appt_num,trd_plfm,trd_mode,guar_sett_flag,rf_val,marg,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,trad_id,oper_no,tnv_stat,cont_mult,covr_dir,arbi_flag,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,pay_dt,excr_dt,etf_onum,esti_cash_diff,etf_fnd_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--离线清算：质押式协议回购首期\到期\续做\提前购回\解除质押
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_' , nvl(T4.L_REALDEAL_SERIAL_NO,T41.L_REALDEAL_SERIAL_NO)) AS TNV_ONUM, --成交序号
       nvl(T4.L_BUSINESS_TIME,T41.L_BUSINESS_TIME) AS TNV_TIME, --成交时间
       CASE
         WHEN nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) IS NULL OR
              nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) = 0 THEN
          NULL
         ELSE
          CONCAT(T0.L_DATE , '_HSO32' , '_' , nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) , '_' ,
          T0.L_BASECOMBI_ID , '_' ,
          CONCAT(T5.VC_REPORT_CODE , '.REPO.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END )) , '_' ,
          CONCAT(CASE T0.C_INVEST_TYPE WHEN '1' THEN '2' WHEN '2' THEN '1' WHEN 'a' THEN '15' WHEN 'b' THEN '10' WHEN 'c' THEN '12' ELSE T0.C_INVEST_TYPE END) , '_' ,
          (CASE
         WHEN T11.L_DAILY_INSTRUCTION_NO IS NOT NULL THEN
          '02010104' --续作
         WHEN T0.L_BUSIN_FLAG IN ('73109', '73111','73164','73166') THEN
          '02010100' --首期
         WHEN T0.L_BUSIN_FLAG IN ('73112', '73114','73161','73163') THEN
          '02010101' --到期
         WHEN T0.L_BUSIN_FLAG IN ('73158', '73160') THEN
          '02010102' --提前购回
         WHEN T0.L_BUSIN_FLAG IN ('73325', '73327') THEN
          '02010105' --解除质押
       END))
       END AS ODR_RELA_ONUM, --指令关联序号
       CASE
         WHEN nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) IS NOT NULL AND nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) <> 0 THEN
        CONCAT('0|' , nvl(T4.L_DATE,T41.L_DATE) , '_HSO32' , '_' , nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) ,
          '|0|0')
         WHEN nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO) IS NOT NULL AND nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO) <> 0 THEN
          CONCAT('0|0|' , nvl(T4.L_DATE,T41.L_DATE) , '_HSO32' , '_' , nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO) ,
          '|0')
         ELSE
          CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
       END AS TRD_SRC_ID, --交易源ID
       CASE
         WHEN nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO) IS NULL OR nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO) = 0 THEN
          NULL --缺少委托序号时,为空
         ELSE
          CONCAT(nvl(T4.L_DATE,T41.L_DATE) , '_HSO32' , '_' , nvl(T4.L_ENTRUST_SERIAL_NO,T41.L_ENTRUST_SERIAL_NO))
       END AS ENTR_ONUM, --委托序号
       nvl(T4.L_REPORT_SERIAL_NO,T41.L_REPORT_SERIAL_NO) AS REP_NO, --申报编号
       CASE T0.VC_DEAL_NO WHEN '0' THEN '' ELSE nvl(T4.VC_DEAL_NO,T41.VC_DEAL_NO) END  AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
         WHEN  T7.L_SERIAL_NO IS NOT NULL THEN
          CONCAT(T7.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T7.L_HG_DATE , '_' ,
          T5.VC_REPORT_CODE , '.REPO.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END ))--回购,能找到回购合约信息
       END AS SECU_ID, --证券编码
       CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('73109', '73112', '73164', '73161', '73158', '73325') THEN
          'S'
         WHEN T0.L_BUSIN_FLAG IN ('73111', '73114', '73166', '73163', '73160', '73327') THEN
          'L'
       END AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '020101' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T11.L_DAILY_INSTRUCTION_NO IS NOT NULL THEN
          '02010104' --续作
         WHEN T0.L_BUSIN_FLAG IN ('73109', '73111','73164','73166') THEN
          '02010100' --首期
         WHEN T0.L_BUSIN_FLAG IN ('73112', '73114','73161','73163') THEN
          '02010101' --到期
         WHEN T0.L_BUSIN_FLAG IN ('73158', '73160') THEN
          '02010102' --提前购回
         WHEN T0.L_BUSIN_FLAG IN ('73325', '73327') THEN
          '02010105' --解除质押
       END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型,银行间市场默认全额清算
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('15') THEN
          '103'
         WHEN T0.C_ENTRUST_DIRECTION IN ('16') THEN
          '104'
         WHEN T0.C_ENTRUST_DIRECTION IN ('17') THEN
          '105'
         WHEN T0.C_ENTRUST_DIRECTION IN ('18') THEN
          '106'
         WHEN T0.C_ENTRUST_DIRECTION IN ('37') THEN
          '113'
         WHEN T0.C_ENTRUST_DIRECTION IN ('38') THEN
          '114'
         WHEN T0.C_ENTRUST_DIRECTION IN ('35') THEN
          '111'
         WHEN T0.C_ENTRUST_DIRECTION IN ('36') THEN
          '112'
       END AS ENTR_DIR, --委托方向
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T7.EN_DEAL_BALANCE / 100 AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准,暂不使用
       100 AS TNV_PRC, --成交价格 ,其中港股通为港币,
       T0.EN_ENTRUST_PRICE / 100 AS RAT, --利率,买卖交易为空
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额,其中港股通离线为人民币,实时为港币
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额,其中港股通离线为人民币,实时为港币
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额,其中港股通离线为人民币,实时为港币
       NVL(T0.EN_FARE2, 0) AS STMP, --印花税
       NVL(T0.EN_FARE3, 0) AS TFEE, --  过户费
       NVL(T0.EN_FARE5, 0) AS HAND_FEE, --  经手费
       NVL(T0.EN_FARE6, 0) AS SFEE, --  证管费
       NVL(T0.EN_FEE_JS2, 0) AS CLEA_CHAG, -- 结算费
       NVL(T0.EN_RISK_FUND, 0) AS CLEA_RPTL, -- 结算风险金
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, -- 其他费用
       NVL(T0.EN_FARE4, 0) AS CMS, -- 佣金
       NVL(T0.EN_FEE_GH_TOTAL, 0) AS FULL_TFEE, --全额过户费
       NULL AS DELI_DT, --交割日期
       nvl(T4.L_TRADE_RIVAL_NO,T41.L_TRADE_RIVAL_NO) AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       CASE
         WHEN T5.C_MARKET_NO = '1'  THEN
        '3' --上海固收平台
         WHEN T5.C_MARKET_NO = '2'  THEN
        '8' --深圳固收平台
       END AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE,--交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       nvl(T4.VC_BROKER_NO,T41.VC_BROKER_NO) AS TRAD_ID, --券商编码
       nvl(T4.L_OPERATOR_NO,T41.L_OPERATOR_NO) AS OPER_NO, --操作员
       NVL(T4.C_VALID, '1') AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       nvl(T4.C_CLOSE_TYPE,T41.C_CLOSE_TYPE) AS COVR_DIR, --平仓方向
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
       'evt_exch_clea_jour_real_third_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.o3_trealdeal  T4 --获取成交序号、委托序号、指令序号等交易过程数据
    ON T0.VC_SUMMARY = T4.VC_CONTRACT_NO
   AND T0.L_DATE = T4.L_DATE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
   AND T4.C_VALID = T0.C_STATUS
   AND T0.C_STOCK_TYPE = T4.C_STOCK_TYPE
   AND T4.C_ENTRUST_DIRECTION IN ('15', '16', '17', '18', '37', '38', '35', '36')
  LEFT JOIN ${ods_db}.o3_trealdeal  T41 --获取成交序号、委托序号、指令序号等交易过程数据
    ON LPAD(T0.VC_DEAL_NO, 64, 0)=LPAD(T41.VC_DEAL_NO, 64, 0)
   AND T0.L_DATE = T41.L_DATE
   AND T0.L_BASECOMBI_ID = T41.L_BASECOMBI_ID
   AND T0.C_BUSIN_CLASS = T41.C_BUSIN_CLASS
   AND T41.C_VALID = T0.C_STATUS
   AND T0.C_STOCK_TYPE = T41.C_STOCK_TYPE
   AND T41.C_ENTRUST_DIRECTION IN ('15', '16', '17', '18', '37', '38', '35', '36')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_MARKET_NO IN ('1', '2', 'o', 'n') --1是上交所、2深交所,n沪港通，o是深港通
  LEFT JOIN ${ods_db}.O3_THGREGISTER T7  --当前和历史的回购合约合集
    ON nvl(T4.VC_CONTRACT_NO,T41.VC_CONTRACT_NO) = T7.VC_CONTRACT_NO
   AND T7.C_ENTRUST_DIRECTION IN ('15', '16')
   LEFT JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T11
    ON nvl(T4.L_DATE,T41.L_DATE) = T11.L_DATE
   AND nvl(T4.L_DAILY_INSTRUCTION_NO,T41.L_DAILY_INSTRUCTION_NO) = T11.L_DAILY_INSTRUCTION_NO
   AND nvl(T4.L_BASECOMBI_ID,T41.L_BASECOMBI_ID) = T11.L_BASECOMBI_ID
   AND T11.C_INSTRUCTION_STATUS IN ('1', '3') --有效/中途撤销
   AND T11.C_ENTRUST_DIRECTION IN ('30', '31')
   LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
    ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T8.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('I') --筛选交易所流水 1：竞价平台、网上股票、转债、预收要约、债回售、配股；I：固收平台；E:上交所大宗交易 、深圳综合协议平台；
   AND T0.L_BUSIN_FLAG IN ('73109', '73111', '73112' , '73114', '73164', '73166', '73161' ,'73163', '73158', '73160', '73325', '73327')
   --73109  正回购资金增加；73112  正回购到期资金减少；73111  逆回购资金减少；73114  逆回购到期资金增加
   --73164  正回购续做资金增加；73166  逆回购续做资金减少；73161  正回购到期续做原资金减少；73163  逆回购到期续做原资金增加
   --73158  正回购提前到期资金减少  73160逆回购提前到期资金增加 73325正回购解除质押资金减少 73327逆回购解除质押资金增加
   AND T0.C_STATUS IN ('1') --1-正常，2-回溯，3-被回溯；
   AND T0.L_DATE = ${current_date}

 UNION ALL
--清算：网上申购（北交所）确认、中签
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     T0.L_DATE AS OCCU_DT, --发生日期
     CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_TIME, --成交时间
     NULL AS ODR_RELA_ONUM, --指令关联序号
     CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     NULL AS ENTR_ONUM, --委托序号
     NULL AS REP_NO, --申报编号
     NULL AS TNV_NO, --成交编号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CONCAT(T6.VC_REPORT_CODE , '.STK.SB') AS SECU_ID, --证券编码
     'SB' AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志,默认多头
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '050801' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T0.L_BUSIN_FLAG = '41501' THEN
               '05080101'
          WHEN T0.L_BUSIN_FLAG = '41503' THEN
               '05080102'
     END AS BUSI_CLAS, --业务类型
     '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
     '12' AS ENTR_DIR, --委托方向
     1 AS CLR_SPED, --清算速度
     T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
     0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
     T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
     NULL AS RAT, --利率,买卖交易为空
     T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
     T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
     0 AS AFT_OCCU_VAL, --发生后资金金额
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
     NULL AS TRD_MODE, --交易方式
     NULL AS GUAR_SETT_FLAG, --担保交收标志
     CASE
          WHEN T0.L_BUSIN_FLAG = '41501' THEN
               0
          WHEN T0.L_BUSIN_FLAG = '41503' THEN
               T4.EN_OCCUR_BALANCE - T0.EN_OCCUR_BALANCE
     END AS RF_VAL, -- 退款金额
     0 AS MARG, --  保证金
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
     T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
     NULL AS TRAD_ID, --券商编码
     NULL AS OPER_NO, --操作员
     '1' AS TNV_STAT, --成交状态
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
     NULL AS ESTI_CASH_DIFF, --预估现金差额
     NULL AS ETF_FND_CLAS, --ETF基金类型
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_clea_jour_real_third_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3', '6')
       LEFT JOIN (SELECT B.VC_ASSET_RELATIVE_CODE, A.*
                    FROM ${ods_db}.O3_TCURRENTS A
                         LEFT JOIN ${ods_db}.O3_TSTOCKINFO B
                           ON A.L_DATE = B.L_DATE
                                  AND A.VC_INTER_CODE = B.VC_INTER_CODE
                   WHERE A.C_BUSIN_CLASS = '22'
                     AND A.L_BUSIN_FLAG IN ('41502')
                 ) T4
         ON T0.L_DATE = T4.L_DATE
                AND T6.VC_INTER_CODE = T4.VC_ASSET_RELATIVE_CODE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.L_FUND_ID = T4.L_FUND_ID
                AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
                AND T0.VC_SEAT_ID = T4.VC_SEAT_ID
                AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.L_BUSIN_FLAG = '41502' --退款
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
         ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                AND T5.C_MARKET_NO = T7.C_MARKET_NO
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T0.L_DATE = W1.dt
                AND T5.C_MARKET_NO = W1.mkt_no
                AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('22')
   AND T0.L_BUSIN_FLAG IN ('41501', '41503') --申购确认,中签
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.L_DATE = ${current_date}

  UNION ALL
--清算：股票红利选择权申报\撤销
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T6.VC_REPORT_CODE, '.WRNT.', (CASE WHEN T6.C_MARKET_NO = 'n' THEN 'SHSC' WHEN T6.C_MARKET_NO = 'o' THEN 'SZSC' END)) AS SECU_ID, --证券编码
       (CASE WHEN T6.C_MARKET_NO = 'n' THEN 'SHSC' WHEN T6.C_MARKET_NO = 'o' THEN 'SZSC' END) AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '430001' AS BUSI_TYP, --业务类别,交易所现券交易
       (CASE
             WHEN T0.C_INVEST_TYPE IN ('1') THEN
                  '2' --交易型金融资产
             WHEN T0.C_INVEST_TYPE IN ('2') THEN
                  '1' --持有到期资产
             ELSE
                  T0.C_INVEST_TYPE
        END) AS INV_TYP, --投资类型
       '43000102' AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '97' AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额，其中港股通离线为人民币，实时为港币
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额，其中港股通离线为人民币，实时为港币
       T0.EN_FARE2 AS STMP, --印花税，其中港股通离线为人民币，实时为港币
       T0.EN_FARE3 AS TFEE, --  过户费，其中港股通离线为人民币，实时为港币
       T0.EN_FARE5 AS HAND_FEE, --  经手费，其中港股通离线为人民币，实时为港币
       T0.EN_FARE6 AS SFEE, --  证管费，其中港股通离线为人民币，实时为港币
       T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费。其中港股通离线为人民币，实时为港币
       T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金，其中港股通离线为人民币，实时为港币
       T0.EN_FARE7 AS OTH_FEE, -- 其他费用，其中港股通离线为人民币，实时为港币
       T0.EN_FARE4 AS CMS, -- 佣金，其中港股通离线为人民币，实时为港币
       T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       (CASE
             WHEN T0.C_BUSIN_CLASS IN ('1') THEN
                  'PLAT_BID'
             WHEN T0.C_BUSIN_CLASS = 'I' THEN
                  'PLAT_FIXINC'
             WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
                  'PLAT_BULK'
             WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
                  'PLAT_INTS'
        END) AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, --交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       NULL AS TRAD_ID, --券商编码
       NULL AS OPER_NO, --操作员
       '1' AS TNV_STAT, --成交状态
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
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_third_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
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
             AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
              ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
             AND T5.C_MARKET_NO = T7.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.L_BUSIN_FLAG IN ('73201')
   AND T0.C_STATUS IN ('1') --1-正常，2-回溯，3-被回溯
   AND T0.L_DATE = ${current_date}