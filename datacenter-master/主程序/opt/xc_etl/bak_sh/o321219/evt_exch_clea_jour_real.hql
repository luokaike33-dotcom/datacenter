------------------------------------------------------------------------
-- 模块名称：交易所清算流水(盘后)
-- 业务：
--离线清算：交易所现券业务
--清算：质押式回购
--清算：质押券出入库
--离线清算：配股（不含上交所配股缴款）、配债、上交所老股东配售
--离线清算：配股（上交所配股缴款）
--离线清算：配股/配债/供股权上市
--成交：网上新股/债券申购
--网上新股/债券中签、缴款、交收
--清算：网上新股/新债上市
--清算：预受要约、预受要约撤销、预受要约确认
--债回售登记\到账
--清算：股指期货\国债期货\商品期货\期货申报费用
--离线清算：跨市场转托管转出确认（基金）
--离线清算：场内转托管\跨市场转托管（基金）
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

alter table ${dwd_db}.evt_exch_clea_jour_his drop if exists partition (p_dt=${current_date},sys_rs_id='O3') ;

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
     VHISHGREGISTER AS (
         SELECT
             L_DATE ,
             L_OPERATOR_NO ,
             L_FUND_ID ,
             L_REDEEM_DAYS,
             L_REDEEM_LAWDATE ,
             L_REDEEM_LIQUIDATE ,
             C_MARKET_NO ,
             VC_SEAT_ID ,
             VC_STOCKHOLDER_ID ,
             VC_INTER_CODE ,
             C_STOCK_TYPE,
             C_ENTRUST_DIRECTION ,
             L_DEAL_AMOUNT ,
             EN_DEAL_PRICE ,
             EN_DEAL_BALANCE ,
             EN_REDEEM_INTEREST ,
             L_REPORT_TIME ,
             EN_FEE ,
             L_SETTLE_DATE ,
             L_SETTLE_SPEED ,
             C_FROZEN_FLAG ,
             L_BASECOMBI_ID ,
             C_REDEAL_FLAG ,
             L_SERIAL_NO ,
             L_REDEAL_DATE ,
             L_ENTRUST_SERIAL_NO ,
             L_HG_DATE ,
             C_PURPOSE_TYPE ,
             C_REDEAL_AVAILABLE_FLAG ,
             EN_FIRST_PRICE ,
             EN_FIRST_BOND_INTEREST ,
             EN_MATURE_PRICE,
             EN_MATURE_BOND_INTEREST ,
             EN_INTEREST_PAYMENT_BALANCE ,
             L_BUSIN_AMOUNT ,
             EN_NOW_INTEREST,
             VC_CONTRACT_NO ,
             L_YEAR_DAYS ,
             EN_GH_BALANCE ,
             EN_EXTRA_PAY_INTEREST ,
             EN_NEW_RATE ,
             L_NEW_REDEEM_DATE ,
             C_TRUSTEE ,
             VC_TARGET_INTER_CODE ,
             VC_TARGET_STOCKHOLDER_ID ,
             VC_TARGET_SEAT_ID ,
             VC_SUMMARY ,
             VC_RIVAL_SEAT ,
             L_RIVAL_ID ,
             EN_MORTGAGE_BALANCE ,
             VC_RIVALTRADER_ID ,
             L_HG_TRADE_DATE ,
             VC_BASKET_NO,
             C_CLEAR_TYPE ,
             C_STATUS
         FROM  ${ods_db}.O3_THISHGREGISTER
         WHERE nvl(C_STATUS,'1') = '1'

         UNION ALL
         SELECT
             L_DATE ,
             L_OPERATOR_NO ,
             L_FUND_ID ,
             L_REDEEM_DAYS,
             L_REDEEM_LAWDATE ,
             L_REDEEM_LIQUIDATE ,
             C_MARKET_NO ,
             VC_SEAT_ID ,
             VC_STOCKHOLDER_ID ,
             VC_INTER_CODE ,
             C_STOCK_TYPE,
             C_ENTRUST_DIRECTION ,
             L_DEAL_AMOUNT ,
             EN_DEAL_PRICE ,
             EN_DEAL_BALANCE ,
             EN_REDEEM_INTEREST ,
             L_REPORT_TIME ,
             EN_FEE ,
             L_SETTLE_DATE ,
             L_SETTLE_SPEED ,
             C_FROZEN_FLAG ,
             L_BASECOMBI_ID ,
             C_REDEAL_FLAG ,
             L_SERIAL_NO ,
             L_REDEAL_DATE ,
             L_ENTRUST_SERIAL_NO ,
             L_HG_DATE ,
             C_PURPOSE_TYPE ,
             C_REDEAL_AVAILABLE_FLAG ,
             EN_FIRST_PRICE ,
             EN_FIRST_BOND_INTEREST ,
             EN_MATURE_PRICE,
             EN_MATURE_BOND_INTEREST ,
             EN_INTEREST_PAYMENT_BALANCE ,
             L_BUSIN_AMOUNT ,
             EN_NOW_INTEREST,
             VC_CONTRACT_NO ,
             L_YEAR_DAYS ,
             EN_GH_BALANCE ,
             EN_EXTRA_PAY_INTEREST ,
             EN_NEW_RATE ,
             L_NEW_REDEEM_DATE ,
             C_TRUSTEE ,
             VC_TARGET_INTER_CODE ,
             VC_TARGET_STOCKHOLDER_ID ,
             VC_TARGET_SEAT_ID ,
             VC_SUMMARY ,
             VC_RIVAL_SEAT ,
             L_RIVAL_ID ,
             EN_MORTGAGE_BALANCE ,
             VC_RIVALTRADER_ID ,
             L_HG_TRADE_DATE ,
             VC_BASKET_NO,
             C_CLEAR_TYPE ,
             C_STATUS
         FROM ${ods_db}.O3_THGREGISTER
         WHERE nvl(C_STATUS,'1') = '1'
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
--离线清算：交易所现券业务
--20220309新增逻辑：业务系统编码、指令关联序号、交易源ID、源证券ID、源证券交易ID、委托方向、限售标识、锁定受限类型、合同号、缴款日期、除权日期
--20220309调整逻辑：成交序号、交割日期
--20220309删除逻辑：指令序号
SELECT
    t.BUSI_SYS_ID, --业务系统编码
    t.OCCU_DT, --发生日期
    t.TNV_ONUM, --成交序号
    t.TNV_TIME, --成交时间
    t.ODR_RELA_ONUM, --指令关联序号
    t.TRD_SRC_ID, --交易源ID
    t.ENTR_ONUM, --委托序号
    t.REP_NO, --申报编号
    t.TNV_NO, --成交编号
    t.PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    t.AST_UNIT_CODE, --资产单元代码
    t.PFL_CODE, --投组代码
    t.SH_CODE, -- 股东代码
    t.SEAT_CODE, --席位号
    case when T.EXCH_CODE in ('SHSC','SZSC') then nvl(t1.NEW_SECU_ID,t.SECU_ID) else t.SECU_ID end as SECU_ID, --证券编码
    t.EXCH_CODE, --交易市场代码
    t.SECU_CODE, --证券代码
    t.SRC_SECU_ID, --源证券ID
    t.SRC_SECU_TRD_ID, --源证券交易ID
    t.POS_ID, --多空标志,默认多头
    t.CURR_CODE, --货币代码
    t.BUSI_TYP, --业务类别,交易所现券交易
    t.INV_TYP, --投资类型
    t.BUSI_CLAS, --业务类型
    t.CLR_TYP, --清算类型，银行间市场默认全额清算
    t.ENTR_DIR, --委托方向
    t.CLR_SPED, --清算速度
    t.TNV_VOL, --成交数量
    t.AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    t.TNV_PRC, --成交价格 ,其中港股通为港币，
    t.RAT, --利率,买卖交易为空
    t.TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
    t.OCCU_VAL, --发生金额，其中港股通离线为人民币，实时为港币
    t.AFT_OCCU_VAL, --发生后资金金额，其中港股通离线为人民币，实时为港币
    t.STMP, --印花税，其中港股通离线为人民币，实时为港币
    t.TFEE, --  过户费，其中港股通离线为人民币，实时为港币
    t.HAND_FEE, --  经手费，其中港股通离线为人民币，实时为港币
    t.SFEE, --  证管费，其中港股通离线为人民币，实时为港币
    t.CLEA_CHAG, -- 结算费。其中港股通离线为人民币，实时为港币
    t.CLEA_RPTL, -- 结算风险金，其中港股通离线为人民币，实时为港币
    t.OTH_FEE, -- 其他费用，其中港股通离线为人民币，实时为港币
    t.CMS, -- 佣金，其中港股通离线为人民币，实时为港币
    t.FULL_TFEE, --全额过户费
    t.DELI_DT, --交割日期
    t.TRD_CNTP_ID, -- 交易对手编码
    t.APPT_NUM, --  约定号
    t.TRD_PLFM, --交易平台
    t.TRD_MODE,--交易方式
    t.GUAR_SETT_FLAG, --担保交收标志
    t.RF_VAL, -- 退款金额
    t.MARG, --  保证金
    t.ENTR_DIR_O3, -- 委托方向_O32
    t.ENTR_DIR_NAME_O3, --委托方向名称_O32
    t.BUSI_CLAS_O3, --   业务分类_O32
    t.TRAD_ID, --券商编码
    t.OPER_NO, --操作员
    t.TNV_STAT, --成交状态
    t.CONT_MULT, --合约乘数
    t.COVR_DIR, --平仓方向
    t.ARBI_FLAG, --套利标志
    t.RES_FLAG, --限售标识
    t.LOCK_LMT_CLAS, --锁定受限类型
    t.LMT_CLAS_ONUM, --受限类型序号
    t.AGMT_NUM, --合同号
    t.PAY_DT, --缴款日期
    t.EXCR_DT, --除权日期
    t.ETF_ONUM, --ETF序号
    t.ESTI_CASH_DIFF, --预估现金差额
    t.ETF_FND_CLAS, --ETF基金类型
    t.BUSI_DATE, --业务日期
    t.TASK_RS_ID, --任务来源标识
    t.DM_CREATED_TIME, --数据中台创建时间
    t.p_dt,
    t.SYS_RS_ID --系统来源标识
FROM (
         SELECT
             '1' AS BUSI_SYS_ID, --业务系统编码
             T0.L_DATE AS OCCU_DT, --发生日期
             CASE
                 WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
                      T0.L_SETTLE_SPEED = 1 THEN
                     concat(T0.L_DATE , '_HSO32' , '_Q' , T0.L_BUSIN_NO) --T+1非担保交收,使用Q区分
                 WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
                     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
                 ELSE
                     concat(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
                 END AS TNV_ONUM, --成交序号
             T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
             CASE WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR T4.L_DAILY_INSTRUCTION_NO = 0 THEN NULL
                  ELSE CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                              (CASE WHEN T5.C_ASSET_CLASS = '2' THEN





                                        CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
                                               (case WHEN T5.C_MARKET_NO  = '1' THEN 'SH'

                                                     WHEN T5.C_MARKET_NO  = '2' THEN 'SZ'
                                                     WHEN T5.C_MARKET_NO  = 'n' THEN 'SHSC'
                                                     WHEN T5.C_MARKET_NO  = 'o' THEN 'SZSC'
                                                     WHEN T5.C_MARKET_NO  = 'J' THEN ( CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END )




                                                     WHEN T5.C_MARKET_NO  = 'r' THEN 'BJ'
                                                   END))
                                    WHEN T5.C_ASSET_CLASS = '3' THEN

                                        CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                                               (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                     WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                   END))

                                    WHEN T5.C_ASSET_CLASS = '4' THEN

                                        CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                                               (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                     WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                   END))
                                    WHEN T5.C_ASSET_CLASS = '7' THEN CONCAT(T5.VC_REPORT_CODE , '.WRNT.' ,



                                                                            (CASE WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                                                                  WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                                                                END))

                                  END) , '_' ,

                              CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                                   WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                                   ELSE T0.C_INVEST_TYPE END , '_' ,

                              (CASE
                                   WHEN T0.C_ENTRUST_DIRECTION in ('1', '3') THEN
                                       '01000100'
                                   WHEN T0.C_ENTRUST_DIRECTION in ('2', '4') THEN
                                       '01000101'
                                  END))
                 END AS ODR_RELA_ONUM, --指令关联序号
             CASE
                 WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
                      T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
                     concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')

                 WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
                      T4.L_ENTRUST_SERIAL_NO <> 0 THEN
                     concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
                 WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
                      T0.L_SETTLE_SPEED = 1 THEN
                     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_Q' , T0.L_BUSIN_NO) --T+1非担保交收,使用Q区分
                 WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
                     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
                 ELSE
                     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
                 END AS TRD_SRC_ID, --交易源ID
             CASE
                 WHEN T4.L_ENTRUST_SERIAL_NO IS NULL OR T4.L_ENTRUST_SERIAL_NO = 0 THEN
                     NULL --缺少委托序号时，为空
                 ELSE
                     concat(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
                 END AS ENTR_ONUM, --委托序号
             T4.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
             CASE WHEN T0.VC_DEAL_NO = '0' THEN ''
                  ELSE T4.VC_DEAL_NO END AS TNV_NO, --成交编号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE WHEN T5.C_ASSET_CLASS = '2' THEN CONCAT(T5.VC_REPORT_CODE , '.STK.' ,


                                                          (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                                WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                                WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                                                WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                                                WHEN T5.C_MARKET_NO = 'j' THEN (
                                                                    CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ'
                                                                         ELSE 'SB' END )
                                                                WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
                                                              END)) --股票
                  WHEN T5.C_ASSET_CLASS = '3' THEN CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,

                                                          (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                                WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                              END)
                      ) --债券
                  WHEN T5.C_ASSET_CLASS = '4' THEN CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,

                                                          (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                                                WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                                              END)) --基金
                  WHEN T5.C_ASSET_CLASS = '7' THEN CONCAT(T5.VC_REPORT_CODE , '.WRNT.' ,

                                                          (CASE WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                                                WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                                              END)) --权证
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
                     (CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END)


                 WHEN T5.C_MARKET_NO = 'r' THEN
                     'BJ'
                 END AS EXCH_CODE, --交易市场代码
             T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
             T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
             T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
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
                 WHEN T0.L_BUSIN_FLAG IN ('40801', '40901') THEN
                     '01000100' --交易所现券买入
                 WHEN T0.L_BUSIN_FLAG IN ('40802', '40902') THEN
                     '01000101' --交易所现券卖出
                 END AS BUSI_CLAS, --业务类型
             '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
             T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
             T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
             T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 ,其中港股通为港币，
             NULL AS RAT, --利率,买卖交易为空
             T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
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
             CASE WHEN T0.L_BUSIN_FLAG IN ('40801', '40802') AND T5.C_MARKET_NO IN ('n', 'o') THEN --港股通买卖


                      T6.L_SETTLE_DATE
                  WHEN T0.L_BUSIN_FLAG IN ('40801', '40802') AND T5.C_MARKET_NO IN ('1', '2', 'j', 'r') THEN --股票、基金、债券

                      T9.aft_1_dt
                  WHEN T0.L_BUSIN_FLAG IN ('40901', '40902') AND T0.L_SETTLE_SPEED = 0 THEN --债券买卖，清算速度为0

                      T0.L_DATE
                  WHEN T0.L_BUSIN_FLAG IN ('40901', '40902') AND T0.L_SETTLE_SPEED = 1 THEN --债券买卖，清算速度为1

                      T9.aft_1_dt
                 END AS DELI_DT, --交割日期
             cast(T4.L_TRADE_RIVAL_NO as string) AS TRD_CNTP_ID, -- 交易对手编码
             NULL AS APPT_NUM, --  约定号
             CASE
                 WHEN T5.C_MARKET_NO = '2' AND T5.C_ASSET_CLASS = '3' AND T5.C_STOCK_TYPE <> '5' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
                     'PLAT_FIXINC' --深圳固收平台
                 WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
                     'PLAT_NEW_BOND' --上海新债平台
                 WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS IN ('I', 'E')  AND T5.L_DATE >= '20220512' THEN  --新债平台切换
                     'PLAT_FIXINC' --上海固收平台
                 WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('1','n') THEN
                     'PLAT_BID' -- 上海竞价
                 WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('2','o') THEN
                     'PLAT_BID' --深圳竞价
                 WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('j','r') THEN
                     'PLAT_BID' --股转竞价
                 WHEN T0.C_BUSIN_CLASS = 'I' THEN
                     'PLAT_FIXINC' --上海固收
                 WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
                     'PLAT_BULK' --上海大宗
                 WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
                     'PLAT_BULK' --深圳大宗
                 END AS TRD_PLFM, --交易平台
             CASE
                 WHEN T5.C_MARKET_NO = '2' AND T5.C_ASSET_CLASS = '3' AND T5.C_STOCK_TYPE <> '5' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
                     1 --匹配成交
                 WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
                     1 --匹配成交
                 WHEN T5.C_MARKET_NO = '2' AND T7.C_PRICE_TYPE IN ('I', 'K') THEN
                     2 --点击成交
                 WHEN T5.C_MARKET_NO = '2' AND T7.C_PRICE_TYPE IN ('J', 'V') THEN
                     3 --协商成交
                 WHEN T5.C_MARKET_NO = '2' AND T7.C_PRICE_TYPE IN ('X', 'Y') THEN
                     5 --竞买成交
                 WHEN T5.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE IN ('c', 'd', 'e', 'h') THEN
                     3 --协商成交
                 WHEN T5.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE IN ('f') THEN
                     5 --竞买成交
                 ELSE
                     NULL --其他成交方式
                 END AS TRD_MODE,--交易方式
             CASE
                 WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
                      T0.L_SETTLE_SPEED = 1 THEN --上海固收平台、非净额结算并且清算速度1，为非担保债券
                     '0'
                 WHEN T0.C_BUSIN_CLASS = 'I' AND T0.L_SETTLE_SPEED = 0 THEN --上海固收平台、清算速度0，为非担保债券
                     '0'
                 WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' AND
                      T0.L_SETTLE_SPEED = 0 THEN --深圳综合协议平台并且清算速度0，为非担保债券
                     '0'
                 ELSE
                     '1' --其余为担保债券；
                 END AS GUAR_SETT_FLAG, --担保交收标志
             0 AS RF_VAL, -- 退款金额
             0 AS MARG, --  保证金
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
             T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
             T4.VC_BROKER_NO AS TRAD_ID, --券商编码
             T4.L_OPERATOR_NO AS OPER_NO, --操作员
             CAST(NVL(T4.C_VALID,1) AS INT) AS TNV_STAT, --成交状态
             NULL AS CONT_MULT, --合约乘数
             T4.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
             NULL AS ARBI_FLAG, --套利标志
             CASE
                 WHEN T0.C_BUSIN_CLASS = 'E' AND
                      NVL(T7.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
                     1 --大宗交易限售
                 ELSE
                     0 --非限售
                 END AS RES_FLAG, --限售标识
             CASE
                 WHEN T0.C_BUSIN_CLASS = 'E' AND
                      NVL(T7.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
                     3 --大宗交易买入限售
                 ELSE
                     0 --非限售
                 END AS LOCK_LMT_CLAS, --锁定受限类型
             NULL AS LMT_CLAS_ONUM, --受限类型序号
             NULL AS AGMT_NUM, --合同号
             NULL AS PAY_DT, --缴款日期
             NULL AS EXCR_DT, --除权日期
             NULL AS ETF_ONUM, --ETF序号
             NULL AS ESTI_CASH_DIFF, --预估现金差额
             NULL AS ETF_FND_CLAS, --ETF基金类型
             ${current_date} AS BUSI_DATE, --业务日期
             'evt_exch_clea_jour_real_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.L_DATE as p_dt,
             'O3' AS SYS_RS_ID --系统来源标识
         FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
                  LEFT JOIN VHISPENDSETTLE T6 --待交割表,包含在途和历史的全集
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
                            ON LPAD(T0.VC_DEAL_NO,64,0) = LPAD(case when T4.VC_DEAL_NO like '%|%' then SUBSTR(T4.VC_DEAL_NO,locate('|',T4.VC_DEAL_NO)+1) else T4.VC_DEAL_NO end,64,0)                                AND T0.L_DATE = T4.L_DATE
                                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                                AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                                AND T4.VC_DEAL_NO IS NOT NULL
                                AND T4.C_VALID = '1' --有效

                  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                            ON T0.L_DATE = T5.L_DATE
                                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

                  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                            ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                                AND T5.C_MARKET_NO = T8.C_MARKET_NO
                  LEFT JOIN ${ods_db}.O3_TENTRUSTS T7 --证券基本信息表，筛选交易所市场
                            ON T0.L_DATE = T7.L_DATE
                                AND T4.L_ENTRUST_SERIAL_NO = T7.L_ENTRUST_SERIAL_NO
                                AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
                  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T9 ON T0.L_DATE = T9.DT AND T5.C_MARKET_NO = T9.mkt_no and t9.SYS_RS_ID = 'O3'
         WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E') --筛选交易所流水,1：竞价平台、网上股票、转债、预收要约、债回售、配股；I：固收平台；E:上交所大宗交易 、深圳综合协议平台；
           AND T0.L_BUSIN_FLAG IN ('40801', '40802', '40901', '40902')
           --40801、40802为证券买入卖出、40901、40902债券买入卖出为历史问题所以加入
           AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
           AND T0.L_DATE = ${current_date}
     ) t
         left join ${dwd_db}.VAR_SECU_CODE_CHG t1
                   on t.secu_id = t1.secu_id
     where (t.OCCU_DT between t1.NEW_SECU_ID_BGN_DT and t1.NEW_SECU_ID_END_DT) or t1.secu_id is null

UNION ALL
--清算：质押式回购
--20220309新增逻辑：业务系统编码、指令关联序号、交易源ID、源证券ID、源证券交易ID、委托方向、限售标识、锁定受限类型、合同号、缴款日期、除权日期
--20220309删除逻辑：指令序号
SELECT
     '1' AS BUSI_SYS_ID, --业务系统编码
     T0.L_DATE AS OCCU_DT, --发生日期
     CASE
       WHEN T11.L_REALDEAL_SERIAL_NO IS NULL THEN
        concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
	   WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') THEN
	    concat(T11.L_DATE , '_HSO32' , '_' , T11.L_REALDEAL_SERIAL_NO)
       WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') THEN
        concat(T0.L_DATE , '_HSO32' , '_' , T11.L_REALDEAL_SERIAL_NO,'C')
     END AS TNV_ONUM, --成交序号
     T11.L_BUSINESS_TIME AS TNV_TIME, --成交时间
     CASE
           WHEN T11.L_DAILY_INSTRUCTION_NO IS NULL OR
                T11.L_DAILY_INSTRUCTION_NO = 0 THEN
            NULL
           ELSE
            concat(T0.L_DATE , '_HSO32' , '_' , T11.L_DAILY_INSTRUCTION_NO , '_' ,
            T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REPO.' ,
            (CASE T5.C_MARKET_NO  WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END ) , '_' ,
            CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
          WHEN T0.C_INVEST_TYPE = '2' THEN '1'
          ELSE T0.C_INVEST_TYPE END, '_' ,
            '02000100')
     END AS ODR_RELA_ONUM, --指令关联序号
     CASE
          WHEN T11.L_DAILY_INSTRUCTION_NO IS NOT NULL OR
               T11.L_DAILY_INSTRUCTION_NO <> 0 THEN
           concat('0|' , T11.L_DATE , '_HSO32' , '_' , T11.L_DAILY_INSTRUCTION_NO ,
           '|0|0')
          WHEN T11.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T11.L_ENTRUST_SERIAL_NO <> 0 THEN
           concat('0|0|' , T11.L_DATE , '_HSO32' , '_' , T11.L_ENTRUST_SERIAL_NO , '|0')
          WHEN T11.L_REALDEAL_SERIAL_NO IS NULL THEN
           concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
		  WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') THEN
		  	concat('0|0|0|' ,T11.L_DATE , '_HSO32' , '_' , T11.L_REALDEAL_SERIAL_NO)
		  WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') THEN
		  	concat('0|0|0|' ,T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     CASE
       WHEN T11.L_ENTRUST_SERIAL_NO IS NULL OR
            T11.L_ENTRUST_SERIAL_NO = 0 THEN
        NULL --缺少委托序号时，为空
       ELSE
        concat(T11.L_DATE , '_HSO32' , '_' , T11.L_ENTRUST_SERIAL_NO)
     END AS ENTR_ONUM, --委托序号
     T11.L_REPORT_SERIAL_NO AS REP_NO, --申报编号
     CASE T0.VC_DEAL_NO WHEN '0' THEN '' ELSE T11.VC_DEAL_NO  END AS TNV_NO, --成交编号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
       WHEN T5.C_ASSET_CLASS = '6' AND T9.L_SERIAL_NO IS NOT NULL THEN
        concat(T9.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T9.L_HG_DATE , '_' ,
        T5.VC_REPORT_CODE , '.REPO.' ,
        CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) --回购，能找到回购合约信息
       WHEN T5.C_ASSET_CLASS = '6' AND T9.L_SERIAL_NO IS NULL THEN
        concat('L', T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_DATE , '_' ,
        T5.VC_REPORT_CODE , '.REPO.' ,
         CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) --回购，无首期回购，取带待割表的序号
       WHEN T5.C_ASSET_CLASS = '3' THEN
        concat(T5.VC_REPORT_CODE , '.BOND.' ,
         CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END)--债券
     END AS SECU_ID, --证券编码
     CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END  AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     CASE
       WHEN T0.L_BUSIN_FLAG IN ('41202', '41203') THEN
        'S'
       ELSE
        'L'
     END AS POS_ID, --多空标志,默认多头
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '020001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
       WHEN T0.C_INVEST_TYPE IN ('1') THEN
        '2' --交易型金融资产
       WHEN T0.C_INVEST_TYPE IN ('2') THEN
        '1' --持有到期资产
       ELSE
        T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
       WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') THEN
        '02000100' --交易所质押式回购首期
       WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') THEN
        '02000101' --交易所质押式回购到期
     END AS BUSI_CLAS, --业务类型
     '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
     T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
     T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
     T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
     100 AS TNV_PRC, --成交价格 ,其中港股通为港币，
     T0.EN_ENTRUST_PRICE / 100 AS RAT, --利率,买卖交易为空
     T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
     T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额，其中港股通离线为人民币，实时为港币
     T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额，其中港股通离线为人民币，实时为港币
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
     cast(T11.L_TRADE_RIVAL_NO as string) AS TRD_CNTP_ID, -- 交易对手编码
     NULL AS APPT_NUM, --  约定号
     CASE
       WHEN T0.C_BUSIN_CLASS IN ('1', 'E') AND T5.C_MARKET_NO = '1' AND T0.L_DATE >= '20220512' THEN
      'PLAT_NEW_BOND' --上海新债平台
       WHEN T0.C_BUSIN_CLASS IN ('1', 'E') AND T5.C_MARKET_NO = '2' AND T0.L_DATE >= '20220512' THEN
      'PLAT_FIXINC' --深圳固收平台
       WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO = '1' THEN
        'PLAT_BID' --上海竞价平台
       WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO = '2' THEN
        'PLAT_BID' --深圳竞价平台
       WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
        'PLAT_BULK' --上海大宗平台
       WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '5' THEN
        'PLAT_BULK' --深圳大宗平台
     END AS TRD_PLFM, --交易平台
     NULL AS TRD_MODE,--交易方式
     NULL AS GUAR_SETT_FLAG, --担保交收标志
      0 AS RF_VAL, -- 退款金额
     0 AS MARG, --  保证金
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
     T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
     T11.VC_BROKER_NO AS TRAD_ID, --券商编码
     T11.L_OPERATOR_NO AS OPER_NO, --操作员
     CAST(NVL(T11.C_VALID,1) AS INT) AS TNV_STAT, --成交状态
     NULL AS CONT_MULT, --合约乘数
     T11.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
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
       'evt_exch_clea_jour_real_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
         LEFT JOIN VHISPENDSETTLE T6 --代交割表和历史代交割表合集，
                   ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                       AND T0.L_DATE = T6.L_TRADE_DATE
						AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                       AND T6.C_ENTRUST_DIRECTION IN ('5', '6')
         LEFT JOIN VHISPENDSETTLE T8 --代交割表和历史代交割表合集，获取在途回购表中的流水号
                   ON T0.L_BUSIN_NO = T8.VC_ORIGINAL_NO
                       AND T0.L_DATE = T8.L_TRADE_DATE
						AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
                       AND T8.C_ENTRUST_DIRECTION IN ('7', '8')
LEFT JOIN (
select
T0.L_DATE,T0.L_SERIAL_NO AS L_SERIAL_NO_0,T9.L_HG_DATE,T9.L_SERIAL_NO
FROM ${ods_db}.O3_tcurrents  T0
LEFT JOIN VHISPENDSETTLE T6 --代交割表和历史代交割表合集，
  ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
 AND T0.L_DATE = T6.L_TRADE_DATE
 AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
 AND T6.C_ENTRUST_DIRECTION IN ('5', '6')
LEFT JOIN VHISPENDSETTLE T8 --代交割表和历史代交割表合集，，获取在途回购表中的流水号
  ON T0.L_BUSIN_NO = T8.VC_ORIGINAL_NO
 AND T0.L_DATE = T8.L_TRADE_DATE
 AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
 AND T8.C_ENTRUST_DIRECTION IN ('7', '8')
INNER JOIN VHISHGREGISTER T9
  ON 1=1
WHERE T0.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水
 AND T0.L_BUSIN_FLAG IN ( '41201', '41202','41203', '41204') --'41201', '41202',
 AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
 AND nvl(t6.l_trade_date,t8.l_trade_date) = case when nvl(T6.l_trade_date,0) = 0 then T9.L_REDEEM_LIQUIDATE ELSE T9.l_hg_date END
 AND nvl(t6.L_SERIAL_NO, t8.L_RELATE_NO) = t9.L_SERIAL_NO
) t9
                   ON T0.L_DATE = T9.L_DATE
                       AND T0.L_SERIAL_NO = T9.L_SERIAL_NO_0
         LEFT JOIN ${ods_db}.O3_TREALDEAL T11 --获取成交信息
                   ON T9.L_HG_DATE = T11.L_DATE
                       AND NVL(T6.VC_DEAL_NO, T8.VC_DEAL_NO) = T11.VC_DEAL_NO
                       AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T11.VC_INTER_CODE
                       AND T0.C_BUSIN_CLASS = T11.C_BUSIN_CLASS
                       AND T11.C_VALID = '1' --有效
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水
  AND T0.L_BUSIN_FLAG IN ( '41201', '41202','41203', '41204') --'41201', '41202',
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--清算：质押券出入库
--20220309新增逻辑：业务系统编码、指令关联序号、交易源ID、源证券ID、源证券交易ID、委托方向、限售标识、锁定受限类型、合同号、缴款日期、除权日期
--20220309删除逻辑：指令序号
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                      (CASE
                           WHEN T5.C_ASSET_CLASS = '3' THEN
                               CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
                           WHEN T5.C_ASSET_CLASS = '4' THEN
                               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
                          END) , '_' ,
                      CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END , '_' ,
                      (CASE
                           WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
                               '04000100'
                           WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
                               '04000101'
                          END))
           END AS ODR_RELA_ONUM, --指令关联序号
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
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
       CASE
           WHEN T5.C_ASSET_CLASS = '3' THEN
               CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))--债券
           WHEN T5.C_ASSET_CLASS = '4' THEN
               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))--基金
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
       '040001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
               '04000100'
           WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
               '04000101'
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
               '30'
           WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
               '31'
           END AS ENTR_DIR, --委托方向
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
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
       CAST(T4.L_TRADE_RIVAL_NO AS STRING) AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
           WHEN T0.C_BUSIN_CLASS = 'I' THEN
               'PLAT_FIXINC'
           END AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, --交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T6.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --   业务分类_O32
       T4.VC_BROKER_NO AS TRAD_ID, --券商编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       CAST(NVL(T4.C_VALID,1) AS INT) AS TNV_STAT, --成交状态
       NULL AS CONT_MULT, --合约乘数
       T4.C_CLOSE_TYPE AS COVR_DIR, --平仓方向
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
       'evt_exch_clea_jour_real_3' AS TASK_RS_ID, --任务来源标识
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
                   ON T0.VC_DEAL_NO = T4.VC_DEAL_NO
                       AND T0.L_DATE = T4.L_DATE
                       AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                       AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                       AND T4.C_VALID = '1' --有效

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选上交所、深交所数据
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T6
                   ON T0.C_ENTRUST_DIRECTION = T6.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T6.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水 1：竞价平台；I：固收平台；
  AND T0.L_BUSIN_FLAG IN ('40903', '40904') --40903、40904为回购质押出入库
  AND T0.L_DATE = ${current_date}


UNION ALL
--离线清算：配股（不含上交所配股缴款）、配债、上交所老股东配售
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)  AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN
               concat(T6.VC_REPORT_CODE , '.STK.' , --股票
                      (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
           WHEN T6.C_ASSET_CLASS = '3' THEN --债券
               concat(T6.VC_REPORT_CODE , '.BOND.' ,
                      (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE WHEN (T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN '050701'  --上交所老股东配售
            ELSE '060001' --配股配债
           END AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE WHEN T0.L_BUSIN_FLAG = '41304' THEN '06000102' --配股除权
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN '05070101'  --上交所老股东配售申购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '73383' THEN '06000101' --上交所配债认购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN '06000108' --上交所配债缴款
            ELSE
                '06000101'  --深交所配股认购确认、深交所配债认购确认、上交所配股认购确认
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE WHEN (T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN '12'  --上交所老股东配售
            ELSE '9' --配股配债
           END AS ENTR_DIR, --委托方向
       CASE WHEN T0.L_BUSIN_FLAG = '41304' THEN 0 --配股除权
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN 1  --上交所老股东配售申购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '73383' THEN 2 --上交所配债认购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN 1 --上交所配债缴款
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN 1 --深交所配债缴款
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN datediff(from_unixtime(unix_timestamp(cast(nvl(T11.L_COMPLETE_DATE,T14.L_COMPLETE_DATE) as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'))
                +1 --上交所配股认购确认
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN 1  --深交所配股认购确认
           END AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73383') THEN --冻结
                   T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT
           WHEN T0.L_BUSIN_FLAG IN ('41302') THEN --配股认购确认
               CASE WHEN T0.EN_OCCUR_BALANCE = 0 THEN T0.EN_ENTRUST_PRICE ELSE T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT END
           WHEN T0.L_BUSIN_FLAG IN ('41304') THEN --配股除权
                   T0.EN_SUBJECT_BALANCE / T0.L_BUSIN_AMOUNT
           END AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73383') THEN --冻结
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41302') THEN --配股认购确认
               CASE WHEN T0.EN_OCCUR_BALANCE = 0 THEN T0.L_BUSIN_AMOUNT * T0.EN_ENTRUST_PRICE ELSE T0.EN_OCCUR_BALANCE END
           WHEN T0.L_BUSIN_FLAG IN ('41304') THEN --配股除权
               T0.EN_SUBJECT_BALANCE
           END AS TNV_VAL, --成交金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73383') THEN --冻结
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41302') THEN --配股认购确认
               CASE WHEN T0.EN_OCCUR_BALANCE = 0 THEN T0.L_BUSIN_AMOUNT * T0.EN_ENTRUST_PRICE ELSE T0.EN_OCCUR_BALANCE END
           WHEN T0.L_BUSIN_FLAG IN ('41304') THEN --配股除权
               T0.EN_SUBJECT_BALANCE
           END AS OCCU_VAL, --发生金额
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
       CASE WHEN T0.L_BUSIN_FLAG = '41304' THEN T0.L_DATE --配股除权
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN t12.aft_1_dt  --上交所老股东配售申购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '73383' THEN t12.aft_2_dt --上交所配债认购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN t12.aft_1_dt --上交所配债缴款
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN t12.aft_1_dt --深交所配债缴款
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN t13.aft_1_dt --上交所配股认购确认
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN t12.aft_1_dt  --深交所配股认购确认
           END AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       'PLAT_BID' AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE,-- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       CASE WHEN T0.L_BUSIN_FLAG = '41304' THEN NULL --配股除权
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN T0.L_DATE  --上交所老股东配售申购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '73383' THEN t12.aft_1_dt --上交所配债认购确认
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN T0.L_DATE --上交所配债缴款
            WHEN T6.C_ASSET_CLASS = '3' AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN T0.L_DATE --深交所配债缴款
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' THEN nvl(T11.L_COMPLETE_DATE,T14.L_COMPLETE_DATE) --上交所配股认购确认
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN T0.L_DATE  --深交所配股认购确认
           END AS PAY_DT, --缴款日期
       CASE WHEN T0.L_BUSIN_FLAG = '41304' THEN T0.L_DATE --配股除权
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '1' AND T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NULL THEN t13.aft_1_dt --上交所配股认购确认
            WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND T5.C_MARKET_NO = '2' AND T0.L_BUSIN_FLAG = '41302' THEN nvl(T11.L_COMPLETE_DATE,T14.L_COMPLETE_DATE)  --深交所配股认购确认
            ELSE
                NULL
           END AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_4' AS TASK_RS_ID, --任务来源标识
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

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T7
                   ON T0.L_DATE = T7.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T7.VC_ASSET_RELATIVE_CODE
                       AND T7.C_STOCK_TYPE IN ('d')
                       AND T7.C_STOP_FLAG = '2'

         LEFT JOIN VHISUNCOMPLETELOG T11  --未完成业务表,重点包含当前和离线两张表视图
                   ON T0.L_DATE = T11.L_TRADE_DATE
                       AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T11.VC_INTER_CODE
                       AND T0.L_BUSIN_FLAG = T11.L_BUSIN_FLAG
                       AND T0.L_BUSIN_FLAG IN ('73383', '41302')
         LEFT JOIN VHISUNCOMPLETELOG T14  --未完成业务表,重点包含当前和离线两张表视图
                   ON T0.L_DATE = T14.L_TRADE_DATE
                       AND T0.L_BASECOMBI_ID = T14.L_BASECOMBI_ID
                       AND T6.VC_INTER_CODE = T14.VC_INTER_CODE
                       AND T0.L_BUSIN_FLAG = T14.L_BUSIN_FLAG
                       AND T0.L_BUSIN_FLAG IN ('73383', '41302')
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                   ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T8.C_MARKET_NO
         left join ${dwd_db}.pub_tradeday_offset_trade t12
                   on T0.L_DATE = t12.dt
                       and T5.C_MARKET_NO = t12.mkt_no
                       and t12.sys_rs_id = 'O3'
         left join ${dwd_db}.pub_tradeday_offset_trade t13
                   on nvl(T11.L_COMPLETE_DATE,T14.L_COMPLETE_DATE) = t13.dt
                       and T5.C_MARKET_NO = t13.mkt_no
                       and t13.sys_rs_id = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1')
  AND (T0.L_BUSIN_FLAG IN ('73383', '41304')
    OR ((T0.L_BUSIN_FLAG IN ('41302') AND T6.C_MARKET_NO = '2' )  --深交所认购确认
        OR (T0.L_BUSIN_FLAG IN ('41302') AND T6.C_MARKET_NO = '1' AND (T0.L_ENTRUST_AMOUNT <> 0 OR T0.C_STOCK_TYPE = 'h') --上交所认购确认申报模式
            )))
  AND T5.C_MARKET_NO NOT IN ('n','o')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--离线清算：配股（上交所配股缴款）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T11.L_COMPLETE_DATE AS OCCU_DT, --发生日期
       concat(T11.L_COMPLETE_DATE , '_HSO32' , '_U' , T11.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       concat('0|0|0|' , T11.L_COMPLETE_DATE , '_HSO32' , '_U' , T11.L_SERIAL_NO)  AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN
               concat(T6.VC_REPORT_CODE , '.STK.' , --股票
                      (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '060001' AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '06000108'  AS BUSI_CLAS, --业务类型，上交所配股缴款
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '9'  AS ENTR_DIR, --委托方向
       1 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
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
       t13.aft_1_dt AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       'PLAT_BID' AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE,-- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       T11.L_COMPLETE_DATE AS PAY_DT, --缴款日期
       t13.aft_1_dt AS EXCR_DT, --除权日期
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_clea_jour_real_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T11.L_COMPLETE_DATE as p_dt,
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

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T7
                   ON T0.L_DATE = T7.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T7.VC_ASSET_RELATIVE_CODE
                       AND T7.C_STOCK_TYPE IN ('d')
                       AND T7.C_STOP_FLAG = '2'

         LEFT JOIN VHISUNCOMPLETELOG T11  --未完成业务表,重点包含当前和离线两张表视图
                   ON T0.L_DATE = T11.L_TRADE_DATE
                       AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                       AND T6.VC_INTER_CODE = T11.VC_INTER_CODE
                       AND T0.L_BUSIN_FLAG = T11.L_BUSIN_FLAG
                       AND T0.L_BUSIN_FLAG IN ('41302')
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                   ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T8.C_MARKET_NO
         left join ${dwd_db}.pub_tradeday_offset_trade t13
                   on T11.L_COMPLETE_DATE = t13.dt
                       and T5.C_MARKET_NO = t13.mkt_no
                       and t13.sys_rs_id = 'O3'
WHERE T0.C_BUSIN_CLASS IN ('1')
  AND T0.L_BUSIN_FLAG IN ('41302')
  AND NVL(T7.L_DATE,99991231) = 99991231 --排除上交所老股东配售
  AND T5.C_MARKET_NO = '1'
  AND (T0.L_ENTRUST_AMOUNT <> 0 OR T0.C_STOCK_TYPE = 'h')
  AND (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a'))
  --重点：日期需要通过L_COMPLETE_DATE进行跑批
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--离线清算：配股/配债/供股权上市
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
    CASE
        WHEN T5.C_ASSET_CLASS IN ('2')  THEN --股票
            concat(T5.VC_REPORT_CODE , '.STK.' ,
                   (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END))
        WHEN T5.C_ASSET_CLASS = '3'  THEN --债券
            concat(T5.VC_REPORT_CODE , '.BOND.' ,
                   (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END))
        WHEN T5.C_ASSET_CLASS = '7' THEN
            concat(T5.VC_REPORT_CODE , '.WRNT.' ,
                   (CASE T5.C_MARKET_NO WHEN 'n' THEN 'SHSC' WHEN 'o' THEN 'SZSC' END)) --权证
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
        END AS EXCH_CODE, --交易市场代码
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
    '06000107' AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '9' AS ENTR_DIR, --委托方向
    0 AS CLR_SPED, --清算速度
    T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
    0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    0 AS TNV_VAL, --成交金额，
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
    'PLAT_BID' AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
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
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_6' AS TASK_RS_ID, --任务来源标识
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
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_MARKET_NO IN ('1', '2', 'n', 'o') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE  T0.L_BUSIN_FLAG IN ('41303') --41303配股上市
  AND  T0.C_STATUS ='1'
  AND T0.L_DATE = ${current_date}

UNION ALL
--成交：网上新股/债券申购
SELECT
    '1' AS BUSI_SYS_ID, --业务系统编码
    T0.L_TRADE_DATE AS OCCU_DT, --发生日期
    concat(T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
    NULL AS TNV_TIME, --成交时间
    NULL AS ODR_RELA_ONUM, --指令关联序号
    concat('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
    NULL AS ENTR_ONUM, --委托序号
    NULL AS REP_NO, --申报编号
    NULL AS TNV_NO, --成交编号
    T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
    T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
    T0.VC_SEAT_ID AS SEAT_CODE, --席位号
    CASE
        WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
            concat(T5.VC_REPORT_CODE , '.STK.' ,
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                         WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                         WHEN T5.C_MARKET_NO = 'j' THEN
                             case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end
                         WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END
                       )
                )
        WHEN T6.C_ASSET_CLASS = '3'  OR T6.C_STOCK_TYPE = 'k' THEN --债券
            concat(T6.VC_REPORT_CODE , '.BOND.' ,
                   (CASE
                        WHEN T6.C_MARKET_NO = '1' THEN 'SH'
                        WHEN T6.C_MARKET_NO = '2' THEN 'SZ'
                       END))
        END AS SECU_ID, --证券编码
    CASE
        WHEN T5.C_MARKET_NO = '1' THEN
            'SH'
        WHEN T5.C_MARKET_NO = '2' THEN
            'SZ'
        WHEN T5.C_MARKET_NO = 'j' THEN
            case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end
        WHEN T5.C_MARKET_NO = 'r' THEN
            'BJ'
        END AS EXCH_CODE, --交易市场代码
    T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
    T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
    T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
    'L' AS POS_ID, --多空标志,默认多头
    'CNY' AS CURR_CODE, --货币代码
    '050001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    '05000101' AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '12' AS ENTR_DIR, --委托方向
    3 AS CLR_SPED, --清算速度
    T0.L_AMOUNT AS TNV_VOL, --成交数量
    0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    ROUND(T0.EN_BANLANCE / T0.L_AMOUNT,2) AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    T0.EN_BANLANCE AS TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
    T0.EN_BANLANCE AS OCCU_VAL, --发生金额，其中港股通离线为人民币，实时为港币
    0 AS AFT_OCCU_VAL, --发生后资金金额，其中港股通离线为人民币，实时为港币
    0 AS STMP, --印花税
    0 AS TFEE, --  过户费
    0 AS HAND_FEE, --  经手费
    0 AS SFEE, --  证管费
    0 AS CLEA_CHAG, -- 结算费
    0 AS CLEA_RPTL, -- 结算风险金
    0 AS OTH_FEE, -- 其他费用
    0 AS CMS, -- 佣金
    0 AS FULL_TFEE, --全额过户费
    T8.aft_3_dt AS DELI_DT, --交割日期
    NULL AS TRD_CNTP_ID, -- 交易对手编码
    NULL AS APPT_NUM, --  约定号
    'PLAT_BID' AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
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
    T9.aft_2_dt AS PAY_DT, --缴款日期
    NULL AS EXCR_DT, --除权日期
    NULL AS ETF_ONUM, --ETF序号
    NULL AS ESTI_CASH_DIFF, --预估现金差额
    NULL AS ETF_FND_CLAS,--ETF基金类型
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_7' AS TASK_RS_ID, --任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
    T0.L_TRADE_DATE as p_dt,
    'O3' AS SYS_RS_ID --系统来源标识
FROM VHISUNCOMPLETELOG T0 --未完成业务表与未完成业务表的合集
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                   ON T0.L_TRADE_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_ASSET_CLASS IN ('6', '3', '2')
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                       AND T6.C_ASSET_CLASS IN ('2', '3', '6')
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T8
                   ON T0.L_TRADE_DATE = T8.dt AND T5.C_MARKET_NO = T8.mkt_no and t8.SYS_RS_ID = 'O3'
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T9
                   ON T0.L_TRADE_DATE = T9.dt AND T5.C_MARKET_NO = T9.mkt_no and t9.SYS_RS_ID = 'O3'
WHERE T0.L_BUSIN_FLAG IN ('73171')
  AND T0.L_TRADE_DATE=${current_date}

UNION ALL
--网上新股/债券中签、缴款、交收
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
    CASE
        WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
            concat(T6.VC_REPORT_CODE , '.STK.' ,
                   (CASE
                        WHEN T6.C_MARKET_NO = '1' THEN 'SH'
                        WHEN T6.C_MARKET_NO = '2' THEN 'SZ'
                       END))
        WHEN T6.C_ASSET_CLASS = '3' OR T6.C_STOCK_TYPE = 'k' THEN --债券
            concat(T6.VC_REPORT_CODE , '.BOND.' ,
                   (CASE
                        WHEN T6.C_MARKET_NO = '1' THEN 'SH'
                        WHEN T6.C_MARKET_NO = '2' THEN 'SZ'
                       END))
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
    'L' AS POS_ID, --多空标志,默认多头
    T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
    '050001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173') THEN
            '05000102' --网上新股中签
        WHEN T0.L_BUSIN_FLAG IN ('73182') THEN
            '05000103' --网上新股缴款
        WHEN T0.L_BUSIN_FLAG IN ('73174') THEN
            '05000104' --网上新股交收
        END AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '12' AS ENTR_DIR, --委托方向
    CASE
        WHEN T0.L_BUSIN_FLAG = '73173' THEN 2
        WHEN T0.L_BUSIN_FLAG = '73182' THEN 1
        WHEN T0.L_BUSIN_FLAG = '73174' THEN 0
        END AS CLR_SPED, --清算速度
    T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
    T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173', '73174') THEN --网上新股中签、交收
            T0.EN_ENTRUST_PRICE
        WHEN T0.L_BUSIN_FLAG IN ('73182') THEN --网上新股缴款
                T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT
        END AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173') THEN --网上新股中签
            T0.EN_DEAL_BALANCE
        WHEN T0.L_BUSIN_FLAG IN ('73182', '73174') THEN --网上新股缴款、交收
            T0.EN_OCCUR_BALANCE
        END AS TNV_VAL, --成交金额，
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173') THEN --网上新股中签
            T0.EN_DEAL_BALANCE
        WHEN T0.L_BUSIN_FLAG IN ('73182', '73174') THEN --网上新股缴款、交收
            T0.EN_OCCUR_BALANCE
        END AS OCCU_VAL, --发生金额
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
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173') THEN
            T8.aft_2_dt
        WHEN T0.L_BUSIN_FLAG IN ('73182') THEN
            T8.aft_1_dt
        WHEN T0.L_BUSIN_FLAG IN ('73174') THEN
            T0.L_DATE
        END AS DELI_DT, --交割日期
    NULL AS TRD_CNTP_ID, -- 交易对手编码
    NULL AS APPT_NUM, --  约定号
    CASE
        WHEN T0.C_BUSIN_CLASS IN ('1') THEN
            'PLAT_BID'
        WHEN T0.C_BUSIN_CLASS = 'I' THEN
            'PLAT_FIXINC'
        END AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
    NULL AS GUAR_SETT_FLAG, --担保交收标志
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73174') THEN
            NVL(T11.EN_BANLANCE - T0.EN_OCCUR_BALANCE, 0)
        ELSE
            0
        END AS RF_VAL, -- 退款金额
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
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('73173') THEN
            T8.aft_1_dt
        WHEN T0.L_BUSIN_FLAG IN ('73182') THEN
            T0.L_DATE
        WHEN T0.L_BUSIN_FLAG IN ('73174') THEN
            NULL
        END AS PAY_DT, --缴款日期
    NULL AS EXCR_DT, --除权日期
    NULL AS ETF_ONUM, --ETF序号
    NULL AS ESTI_CASH_DIFF, --预估现金差额
    NULL AS ETF_FND_CLAS, --ETF基金类型
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_8' AS TASK_RS_ID, --任务来源标识
    CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
    T0.L_DATE as p_dt,
    'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         INNER JOIN VHISUNCOMPLETELOG T11 --未完成表和未完成历史表的合集
                    ON T0.L_DATE = T11.L_TRADE_DATE
                        AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                        AND T0.VC_INTER_CODE = T11.VC_INTER_CODE
                        AND T0.L_BUSIN_FLAG = T11.L_BUSIN_FLAG
                        AND T0.L_BUSIN_FLAG IN ('73173', '73182')
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
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                   ON T5.L_DATE = T6.L_DATE
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                       AND T6.C_ASSET_CLASS IN ('2', '3','6')
                       AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T8
                   ON T0.L_DATE = T8.dt AND T5.C_MARKET_NO = T8.mkt_no and t8.SYS_RS_ID = 'O3'


WHERE T0.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水 1：竞价平台,I：固收平台
  AND T0.L_BUSIN_FLAG IN ('73173', '73182', '73174')
  --73173网上新股中签、73182网上新股缴款、73174网上新股交收
  AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
  AND T0.L_DATE = ${current_date}

UNION ALL
--清算：网上新股/新债上市
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
    CASE
        WHEN T5.C_ASSET_CLASS IN ('2')  THEN --股票
            concat(T5.VC_REPORT_CODE , '.STK.' ,
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                         WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                         WHEN T5.C_MARKET_NO = 'j' THEN
                             case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end
                         WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END
                       )
                )
        WHEN T5.C_ASSET_CLASS = '3'  THEN --债券
            concat(T5.VC_REPORT_CODE , '.BOND.' ,
                   (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                         WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
        END AS SECU_ID, --证券编码
    CASE
        WHEN T5.C_MARKET_NO = '1' THEN
            'SH'
        WHEN T5.C_MARKET_NO = '2' THEN
            'SZ'
        WHEN T5.C_MARKET_NO = 'j' THEN
            case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end
        WHEN T5.C_MARKET_NO = 'r' THEN
            'BJ'
        END AS EXCH_CODE, --交易市场代码
    T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
    T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
    T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
    'L' AS POS_ID, --多空标志,默认多头
    T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
    '050001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    '05000105' AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '12' AS ENTR_DIR, --委托方向
    0 AS CLR_SPED, --清算速度
    T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
    0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
    NULL AS RAT, --利率,买卖交易为空
    0 AS TNV_VAL, --成交金额，
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
    CASE
        WHEN T0.C_BUSIN_CLASS IN ('1') THEN
            'PLAT_BID'
        WHEN T0.C_BUSIN_CLASS = 'I' THEN
            'PLAT_FIXINC'
        END AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
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
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_9' AS TASK_RS_ID, --任务来源标识
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
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                       AND T5.C_ASSET_CLASS IN ('3', '2')

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE  T0.L_BUSIN_FLAG IN ('41512')
  AND  T0.C_STATUS ='1'
  AND T0.L_DATE = ${current_date}

UNION ALL
-- 清算：预受要约、预受要约撤销、预受要约确认
SELECT
    '1' AS BUSI_SYS_ID, --业务系统编码
    T0.L_DATE AS OCCU_DT, --发生日期
    concat(T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
    NULL AS TNV_TIME, --成交时间
    NULL AS ODR_RELA_ONUM, --指令关联序号
    concat('0|0|0|' , T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
    NULL AS ENTR_ONUM, --委托序号
    NULL AS REP_NO, --申报编号
    NULL AS TNV_NO, --成交编号
    T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
    T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
    T0.VC_SEAT_ID AS SEAT_CODE, --席位号
    concat(T6.VC_REPORT_CODE , '.STK.' ,
           (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END )) AS SECU_ID, --证券编码
    CASE
        WHEN T5.C_MARKET_NO = '1' THEN
            'SH'
        WHEN T5.C_MARKET_NO = '2' THEN
            'SZ'
        END AS EXCH_CODE, --交易市场代码
    T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
    T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
    T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
    'L' AS POS_ID, --多空标志,默认多头
    T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
    '070001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    CASE
        WHEN T0.L_BUSIN_FLAG = '41607' THEN
            '07000100'	 --预受要约
        WHEN T0.L_BUSIN_FLAG = '41608' THEN
            '07000101'	 --预受要约撤销
        WHEN T0.L_BUSIN_FLAG = '41609' THEN
            '07000102'		--预受要约确认
        END AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    CASE
        WHEN T0.C_ENTRUST_DIRECTION = '0' THEN
            '66'
        WHEN T0.C_ENTRUST_DIRECTION = 'b' THEN
            '38'
        ELSE '66' END AS ENTR_DIR, --委托方向
    0 AS CLR_SPED, --清算速度
    T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
    T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT AS TNV_PRC, --成交价格 ,其中港股通为港币，
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
    'PLAT_BID' AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
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
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_10' AS TASK_RS_ID, --任务来源标识
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
                       AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('1')
  AND T0.L_BUSIN_FLAG IN ('41609','41607','41608')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--债回售登记\到账
SELECT
    '1' AS BUSI_SYS_ID, --业务系统编码
    T0.L_DATE AS OCCU_DT, --发生日期
    concat(T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
    NULL AS TNV_TIME, --成交时间
    NULL AS ODR_RELA_ONUM, --指令关联序号
    concat('0|0|0|' , T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
    NULL AS ENTR_ONUM, --委托序号
    NULL AS REP_NO, --申报编号
    NULL AS TNV_NO, --成交编号
    T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
    concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
    T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
    T0.VC_SEAT_ID AS SEAT_CODE, --席位号
    concat(T5.VC_REPORT_CODE , '.BOND.' ,
           (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END)) AS SECU_ID,--证券编码
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
    '080001' AS BUSI_TYP, --业务类别,交易所现券交易
    CASE
        WHEN T0.C_INVEST_TYPE IN ('1') THEN
            '2' --交易型金融资产
        WHEN T0.C_INVEST_TYPE IN ('2') THEN
            '1' --持有到期资产
        ELSE
            T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41404', '72934') THEN
            '08000101' --债回售登记
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935', '73408') THEN
            '08000102' --债回售到账
        END AS BUSI_CLAS, --业务类型
    '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
    '11' AS ENTR_DIR, --委托方向
    0 AS CLR_SPED, --清算速度
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND --上交所债回售
             T5.C_MARKET_NO = '1' THEN
            CASE
                WHEN T4.EN_CURR_FACE_PRICE = 0 THEN
                    0
                WHEN T0.L_DATE < 20220701 THEN
                        T0.EN_DEAL_BALANCE/
                        T4.EN_CURR_FACE_PRICE --成交金额/面值
                WHEN T0.L_DATE >= 20220701 THEN
                        T0.EN_OCCUR_BALANCE/
                        T4.EN_CURR_FACE_PRICE --发生金额/面值
                END
        WHEN T0.L_BUSIN_FLAG IN ('41406') AND T5.C_MARKET_NO = '2' THEN --深交所债回售
            CASE
                WHEN T4.EN_CURR_FACE_PRICE = 0 THEN
                    0
                ELSE
                        T0.EN_SUBJECT_BALANCE / T4.EN_CURR_FACE_PRICE --科目金额/面值
                END
        WHEN T0.L_BUSIN_FLAG IN ('73408') THEN
            CASE WHEN T0.L_BUSIN_AMOUNT = 0 THEN
                         T0.EN_OCCUR_BALANCE / T4.EN_CURR_FACE_PRICE
                 ELSE T0.L_BUSIN_AMOUNT
                END
        WHEN T0.L_BUSIN_FLAG IN
             ('41404', '72934') THEN --债回售
            T0.L_BUSIN_AMOUNT
        END AS TNV_VOL, --成交数量
    T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND T5.C_MARKET_NO = '1' THEN --上交所债回售
            T4.EN_CURR_FACE_PRICE --上上交易日的面额
        WHEN T0.L_BUSIN_FLAG IN ('41406', '73408') AND T5.C_MARKET_NO = '2' THEN --深交所债回售
            T4.EN_CURR_FACE_PRICE --上上交易日的面额
        WHEN T0.L_BUSIN_FLAG IN ('41404', '72934', '72935') THEN --债回售登记
            T4.EN_CURR_FACE_PRICE --上上交易日的面额
        END AS TNV_PRC, --成交价格
    NULL AS RAT, --利率,买卖交易为空
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND T5.C_MARKET_NO = '1' AND T0.L_DATE < 20220701 THEN --上交所债回售,日期小于20220701
            T0.EN_DEAL_BALANCE --成交金额
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND T5.C_MARKET_NO = '1' AND T0.L_DATE >= 20220701 THEN --上交所债回售,日期大等于20220701
            T0.EN_OCCUR_BALANCE --发生金额
        WHEN T0.L_BUSIN_FLAG IN ('41406', '73408') AND T5.C_MARKET_NO = '2' THEN --深交所债回售
            T0.EN_OCCUR_BALANCE
        WHEN T0.L_BUSIN_FLAG IN ('41404', '72934') THEN --债回售登记
                T4.EN_CURR_FACE_PRICE * T0.L_BUSIN_AMOUNT --上上交易日的面额 *数量
        END AS TNV_VAL, --成交金额
    CASE
        WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND T5.C_MARKET_NO = '1' THEN --上交所债回售
            T0.EN_OCCUR_BALANCE
        WHEN T0.L_BUSIN_FLAG IN ('41406', '73408') AND T5.C_MARKET_NO = '2' THEN --深交所债回售
            T0.EN_OCCUR_BALANCE
        WHEN T0.L_BUSIN_FLAG IN ('41404', '72934') THEN --债回售登记
                T4.EN_CURR_FACE_PRICE * T0.L_BUSIN_AMOUNT --上上交易日的面额 *数量
        END AS OCCU_VAL, --发生金额
    T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
    T0.EN_FARE2 AS STMP, --印花税
    T0.EN_FARE3 AS TFEE, --  过户费
    CASE WHEN T0.L_BUSIN_FLAG IN ('41406', '72935') AND T5.C_MARKET_NO = '1' AND T0.L_DATE < 20220701 --上交所债回售，日期小于20220701
             THEN T0.EN_FARE5
         ELSE 0 END AS HAND_FEE, --  经手费
    T0.EN_FARE6 AS SFEE, --  证管费
    T0.EN_FEE_JS2 AS CLEA_CHAG, -- 结算费。
    T0.EN_RISK_FUND AS CLEA_RPTL, -- 结算风险金，
    T0.EN_FARE7 AS OTH_FEE, -- 其他费用，
    T0.EN_FARE4 AS CMS, -- 佣金，
    T0.EN_FEE_GH_TOTAL AS FULL_TFEE, --全额过户费
    T0.L_DATE AS DELI_DT, --交割日期
    NULL AS TRD_CNTP_ID, -- 交易对手编码
    NULL AS APPT_NUM, --  约定号
    CASE
        WHEN T0.C_BUSIN_CLASS IN ('1') THEN
            'PLAT_BID'
        WHEN T0.C_BUSIN_CLASS = 'I' THEN
            'PLAT_FIXINC'
        WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
            'PLAT_BULK'
        WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
            'PLAT_INTS'
        END AS TRD_PLFM, --  交易平台
    NULL AS TRD_MODE,--交易方式
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
    ${current_date} AS BUSI_DATE, --业务日期.
    'evt_exch_clea_jour_real_11' AS TASK_RS_ID, --任务来源标识
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

         LEFT JOIN VHISUNCOMPLETELOG T6
                   ON T0.L_DATE = T6.L_TRADE_DATE
                       AND T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                       AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                       AND T0.C_INVEST_TYPE = T6.C_INVEST_TYPE
                       AND T6.L_BUSIN_FLAG IN ('41404', '41406')
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                   ON T0.L_DATE = w1.dt
                       AND T5.C_MARKET_NO = W1.MKT_NO
                       and W1.sys_rs_id = 'O3'
         LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T4
                   ON W1.pre_2_dt = T4.L_DATE
                       AND T0.VC_INTER_CODE = T4.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E')
  AND T0.L_BUSIN_FLAG IN ('41404', '72934', '41406', '72935', '73408')
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL

--清算：股指期货\国债期货\商品期货\期货申报费用
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T4.L_BUSINESS_TIME AS TNV_TIME, --成交时间
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
                T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
           ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUT.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                           WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                           WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
                           WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
                           WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
                           WHEN T5.C_MARKET_NO = '9' THEN 'DCE' END , '_' , (CASE
                                                                                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                                     '2' --交易型金融资产
                                                                                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                                     '1' --持有到期资产
                                                                                 WHEN T0.C_INVEST_TYPE IN ('c') THEN
                                                                                     '12' --套利交易
                                                                                 WHEN T0.C_INVEST_TYPE IN ('b') THEN
                                                                                     '10' --套期工具
                                                                                 WHEN T0.C_INVEST_TYPE IN ('a') THEN
                                                                                     '15' --投机
                                                                                 ELSE
                                                                                     T0.C_INVEST_TYPE
                   END) , '_' , (CASE
                                     WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
                                         '22000100'
                                     WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
                                         '22000101'
                                     WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
                                         '22000103'
                                     WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
                                         '22000104'
                   END))
           END AS ODR_RELA_ONUM, --指令关联序号
       CASE
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
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
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73229') THEN
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO)
           ELSE
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO)
           END AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.FUT.' ,
              CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                   WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
                   WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
                   WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
                   WHEN T5.C_MARKET_NO = '9' THEN 'DCE'
                  END) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
            WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
            WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
            WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
            WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
            WHEN T5.C_MARKET_NO = '9' THEN 'DCE'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('X', 'Y') THEN
               'S'
           ELSE
               'L'
           END AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '220001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           WHEN T0.C_INVEST_TYPE IN ('c') THEN
               '12' --套利交易
           WHEN T0.C_INVEST_TYPE IN ('b') THEN
               '10' --套期工具
           WHEN T0.C_INVEST_TYPE IN ('a') THEN
               '15' --投机
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
               '22000100'
           WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
               '22000101'
           WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
               '22000103'
           WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
               '22000104'
           WHEN T0.L_BUSIN_FLAG IN ('73119') THEN
               '22000106' --期货申报费用增加
           WHEN T0.L_BUSIN_FLAG IN ('73229') AND T0.EN_OCCUR_BALANCE < 0 THEN
               '22000106' -- 期货申报费用增加
           WHEN T0.L_BUSIN_FLAG IN ('73229') AND T0.EN_OCCUR_BALANCE > 0 THEN
               '22000107' -- 期货申报费用减少
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
               '32'
           WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
               '33'
           WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
               '34'
           WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
               '35'
           END AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       ABS(T0.L_BUSIN_AMOUNT) AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       ABS(T0.EN_ENTRUST_PRICE) AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73119', '73229') THEN
               ABS(T0.EN_OCCUR_BALANCE)
           WHEN T0.L_BUSIN_FLAG IN ('42401', '42403', '42402', '42404') THEN
               ABS(T0.EN_DEAL_BALANCE)
           END AS TNV_VAL, --成交金额，其中港股通离线为人民币，实时为港币
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73119', '73229') THEN
               ABS(T0.EN_OCCUR_BALANCE)
           ELSE
               T0.EN_OCCUR_BALANCE
           END AS OCCU_VAL, --发生金额
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
       NULL AS TRAD_ID, --券商编码
       NULL AS OPER_NO, --操作员
       CAST(CAST(NVL(T4.C_VALID, 1) AS INT) AS INT) AS TNV_STAT, --成交状态
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('42401', '42403', '42402', '42404') and
                T0.EN_ENTRUST_PRICE <> 0 and T0.L_BUSIN_AMOUNT <> 0 THEN
               ABS(T0.EN_DEAL_BALANCE / (T0.EN_ENTRUST_PRICE * T0.L_BUSIN_AMOUNT))
           ELSE
               NULL
           END AS CONT_MULT, --合约乘数
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('42402', '42404') AND T5.C_MARKET_NO = '7' THEN --中金所 期货买入/卖出平仓,默认普通平仓 先开先平
               NVL(T4.C_CLOSE_TYPE, 1)
           ELSE
               T4.C_CLOSE_TYPE
           END AS COVR_DIR, --平仓方向
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('73119', '73229') THEN
               NULL
           WHEN T0.C_BUSIN_CLASS IN ('j', 'k') THEN
               '1'
           ELSE
               '0'
           END AS ARBI_FLAG, --套利标志
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
       'evt_exch_clea_jour_real_12' AS TASK_RS_ID, --任务来源标识
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
                       AND T4.C_VALID = '1' --有效

         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
                   ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T7.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('4', 'j', 'k', 'y', 'z')
  AND (T0.L_BUSIN_FLAG IN ('42401', '42403', '42402', '42404', '73119') OR
       (T0.L_BUSIN_FLAG IN ('73229') AND T0.EN_OCCUR_BALANCE <> 0))
  --42401期货买入开仓，42403期货卖出开仓，42402期货卖出平仓，42404期货买入平仓，72922期货多头交割，72923期货空头交割
  --73119中金所申报费用的增加，73229中金所申报费调差
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}

UNION ALL
--离线清算：跨市场转托管转出确认（基金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_TRADE_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_TRADE_DATE , '_1' , '_U' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_1' , '_U' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN --基金
               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '6' THEN 'NONE' END)
           END AS SECU_ID, --证券编码
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
       'CNY' AS CURR_CODE, --货币代码
       '210001'  AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '21000106' AS BUSI_CLAS, --业务类型,跨市场转托管转出确认（基金）
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       '43' AS ENTR_DIR, --委托方向，跨市场转托管
       CASE WHEN T5.C_MARKET_NO = '1' THEN
                1
            ELSE
                0
           END AS CLR_SPED, --清算速度
       T0.L_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       0 AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
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
       CASE WHEN T5.C_MARKET_NO = '1' THEN
                W1.aft_1_dt
            ELSE
                T0.L_TRADE_DATE
           END AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       CASE
           WHEN T0.C_BUSIN_CLASS = '1' THEN
               'PLAT_BID'
           WHEN T0.C_BUSIN_CLASS = 'I' THEN
               'PLAT_FIXINC'
           WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
               'PLAT_BULK'
           WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
               'PLAT_INTS'
           END AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, -- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_13' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_TRADE_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM VHISUNCOMPLETELOG T0 --未完成业务表，包含当前和历史
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.L_TRADE_DATE = T5.L_DATE
                       AND T0.VC_INTER_CODE = T5.VC_INTER_CODE

         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                   ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T8.C_MARKET_NO
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
                   ON T0.L_TRADE_DATE = W1.dt
                       AND T5.C_MARKET_NO = W1.mkt_no
                       AND W1.SYS_RS_ID = 'O3'
WHERE T0.L_BUSIN_FLAG IN ('41604')
  AND T0.L_TRADE_DATE = ${current_date}

UNION ALL
--离线清算：场内转托管\跨市场转托管（基金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS TNV_TIME, --成交时间
       NULL AS ODR_RELA_ONUM, --指令关联序号
       CONCAT('0|0|0|' , T0.L_DATE , '_1' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       NULL AS ENTR_ONUM, --委托序号
       NULL AS REP_NO, --申报编号
       NULL AS TNV_NO, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '2' THEN
               CONCAT(T5.VC_REPORT_CODE , '.STK.' , --股票
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
           WHEN T5.C_ASSET_CLASS = '3' THEN --债券
               CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
           WHEN T5.C_ASSET_CLASS = '4' THEN --基金
               CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                      CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '6' THEN 'NONE' END)
           END AS SECU_ID, --证券编码
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
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               '200001' --场内转托管
           WHEN T0.C_BUSIN_CLASS IN ('5', 'v') THEN
               '210001' --跨市场转托管
           END AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') AND T0.L_BUSIN_FLAG IN ('41603') THEN
               '20000100' --场内转托管转出
           WHEN T0.C_BUSIN_CLASS IN ('1') AND T0.L_BUSIN_FLAG IN ('41602') THEN
               '20000101' --场内转托管转入
           WHEN T0.C_BUSIN_CLASS IN ('5', 'v') AND T0.L_BUSIN_FLAG IN ('41603') THEN
               '21000108' --跨市场转托管转出成交（基金）
           WHEN T0.C_BUSIN_CLASS IN ('5', 'v') AND T0.L_BUSIN_FLAG IN ('41602') THEN
               '21000109' --跨市场转托管转入成交（基金）
           END AS BUSI_CLAS, --业务类型
       '' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               '17'--场内转托管
           WHEN T0.C_BUSIN_CLASS IN ('5', 'v') THEN
               '43' --跨市场转托管
           END AS ENTR_DIR, --委托方向
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       case
           when T0.L_BUSIN_AMOUNT = 0 then
               0
           else
                   T7.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT
           end AS TNV_PRC, --成交价格 ,其中港股通为港币，
       NULL AS RAT, --利率,买卖交易为空
       NVL(T7.EN_OCCUR_BALANCE, 0) AS TNV_VAL, --成交金额，
       NVL(T7.EN_OCCUR_BALANCE, 0) AS OCCU_VAL, --发生金额，
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
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       NULL AS APPT_NUM, --  约定号
       CASE
           WHEN T0.C_BUSIN_CLASS = '1' THEN
               'PLAT_BID'
           WHEN T0.C_BUSIN_CLASS = 'I' THEN
               'PLAT_FIXINC'
           WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
               'PLAT_BULK'
           WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
               'PLAT_INTS'
           END AS TRD_PLFM, --  交易平台
       NULL AS TRD_MODE, -- 交易方式
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       0 AS RF_VAL, -- 退款金额
       0 AS MARG, --  保证金
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, -- 委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
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
       ${current_date} AS BUSI_DATE, --业务日期.
       'evt_exch_clea_jour_real_14' AS TASK_RS_ID, --任务来源标识
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

         LEFT JOIN VHISLIQUIDATEDETAIL T7 --清算接口表，债回售到账在流水中无法获取成交数量信息
                   ON T0.L_DATE = T7.L_DATE
                       AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
                       AND T0.VC_STOCKHOLDER_ID = T7.VC_STOCKHOLDER_ID
                       AND T0.VC_SEAT_ID = T7.VC_SEAT_ID
                       AND T0.L_BUSIN_FLAG = T7.L_BUSIN_FLAG
                       AND T0.L_BUSIN_NO = T7.L_SERIAL_NO
         LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
                   ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
                       AND T5.C_MARKET_NO = T8.C_MARKET_NO
WHERE T0.C_BUSIN_CLASS IN ('1', '5', 'v')
  AND T0.L_BUSIN_FLAG IN ('41602', '41603')
  --41602交易所托管转入
  --41603交易所托管转出
  AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
  AND T0.L_DATE = ${current_date}
