-----------------------------------------------------------------------
-- 模块名称：交易所交收数据(盘后)
--离线交收：交易所现券业务资金交收
--离线交收：交易所现券业务证券交收
--交收：交易所回购首期资金交收
--交收：交易所回购到期资金交收
--交收：网上新股交收
--交收：配股\配债\老股东配售交收
--交收：供股权交收
--交收：证券组合费交收
--日初始化交收：债转股零碎股现金
--离线交收：分销买入\分销卖出资金交收
--离线交收：实时申赎基金申购\赎回
--20220902:ETF基金申赎_现金替代交收_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）只含申购部分
--交收：20220902 过户费
--交收：20220902 ETF 现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
--20220902 跨市场ETF(中登)交收：过户费、现金替代、ETF现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
--离线交收：网上申购(股转/北交所)确认交收、网上中签(股转/北交所)退款交收
--离线资金交收：质押式协议回购首期\到期\续做\提前购回\解除质押
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

alter table ${dwd_db}.evt_exch_sett_his drop if exists partition (p_dt=${current_date},sys_rs_id='O3') ;
  with  VHISUNCOMPLETELOG AS
             (SELECT
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
                  L_BUSIN_FLAG
                       L_BUSIN_FLAG,L_COMPLETE_DATE
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
                   L_BUSIN_FLAG
                        L_BUSIN_FLAG,L_COMPLETE_DATE
                FROM ${ods_db}.O3_THISUNCOMPLETELOG
             )
insert into ${dwd_db}.evt_exch_sett_his partition(p_dt,sys_rs_id)
     (busi_sys_id,trd_src_id,occu_dt,occu_time,sett_onum,tnv_onum,tnv_no,tnv_dt,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,entr_dir,trd_plfm,busi_typ,busi_clas,sett_clas,sett_vol,sett_val,actl_sett_val,cptl_sett_stat,secu_sett_stat,oper_no,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT T.BUSI_SYS_ID, --业务系统编码
T.TRD_SRC_ID, --交易源ID
T.OCCU_DT, --发生日期
T.occu_time, --发生时间
T.SETT_ONUM, --交收序号
T.TNV_ONUM, --成交序号
T.TNV_NO, --成交编号
T.TNV_DT, --成交日期
T.PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
T.AST_UNIT_CODE, --资产单元代码
T.PFL_CODE, --投组代码
T.SH_CODE, -- 股东代码
T.SEAT_CODE, --席位号
T.INV_TYP, --投资类型
case when T.EXCH_CODE in ('SHSC','SZSC') then nvl(t1.NEW_SECU_ID,t.SECU_ID) else t.SECU_ID end as SECU_ID, --证券编码
T.EXCH_CODE, --交易市场代码
T.SECU_CODE, --证券代码
T.SRC_SECU_ID, --证券ID
T.SRC_SECU_TRD_ID, --源证券交易ID
T.POS_ID, --多空标志
T.CURR_CODE, --货币代码
T.ENTR_DIR, --委托方向
T.TRD_PLFM, --交易平台
T.BUSI_TYP, --业务类别,交易所现券交易
T.BUSI_CLAS, --业务类型
T.SETT_CLAS, --交收类型
T.SETT_VOL, --交收数量
T.SETT_VAL, --交收金额
T.ACTL_SETT_VAL, --实际交收金额
T.CPTL_SETT_STAT, --资金交收状态
T.SECU_SETT_STAT, --证券交收状态
T.OPER_NO, -- '操作员编码'
T.BUSI_DATE, --业务日期.
T.TASK_RS_ID, --任务来源标识
T.DM_CREATED_TIME, --数据中台创建时间
T.p_dt,
T.SYS_RS_ID --系统来源标识
FROM (
--离线交收：交易所现券业务资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
               T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
                      '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
          WHEN T5.VC_MIXED_TYPE = 'p' AND T7.C_BUSIN_CLASS = 'I' AND
               T7.L_SETTLE_SPEED = 1 THEN
               concat('0|0|0|' , T7.L_DATE , '_HSO32' , '_Q' , T7.L_BUSIN_NO) --T+1非担保交收,使用Q区分
          ELSE
               concat('0|0|0|' , T7.L_DATE , '_HSO32' , '_Q' , T7.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CASE
          WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
               T7.L_SETTLE_SPEED = 1 THEN
               concat(T7.L_DATE , '_HSO32' , '_Q' , T7.L_BUSIN_NO) --T+1非担保交收,使用Q区分
          WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               concat(T7.L_DATE , '_HSO32' , '_L' , T7.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
          ELSE
               concat(T7.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
     END AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T5.C_ASSET_CLASS = '2' THEN
               concat(T5.VC_REPORT_CODE , '.STK.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                            WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                            WHEN T5.C_MARKET_NO = 'j' THEN
                                 (CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END)
                            WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)) --股票
          WHEN T5.C_ASSET_CLASS = '3' THEN
               concat(T5.VC_REPORT_CODE , '.BOND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))    --债券
          WHEN T5.C_ASSET_CLASS = '4' THEN
               concat(T5.VC_REPORT_CODE , '.FUND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))
          WHEN T5.C_ASSET_CLASS = '7' THEN
               concat(T5.VC_REPORT_CODE , '.WRNT.' ,
                      (CASE WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC' END))
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
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
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
     '010001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('40801', '40901') THEN
               '01000100'
          WHEN T0.L_BUSIN_FLAG IN ('40802', '40902') THEN
               '01000101'
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T0.EN_ACT_SETTLE_BALANCE, T0.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TPENDSETTLE T0 --获取代交收数据
       LEFT JOIN ${ods_db}.O3_TCURRENTS T7 --清算流水主表
         ON T7.L_BUSIN_NO = T0.VC_ORIGINAL_NO
                AND T7.L_DATE = T0.L_TRADE_DATE
                AND T7.L_BASECOMBI_ID = T0.L_BASECOMBI_ID
                AND T7.VC_INTER_CODE = T0.VC_INTER_CODE

       LEFT JOIN ${ods_db}.O3_TREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
         ON LPAD(T7.VC_DEAL_NO, 64, 0) = LPAD(T4.VC_DEAL_NO, 64, 0)
                AND T7.L_DATE = T4.L_DATE
                AND T7.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T7.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T7.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.VC_DEAL_NO IS NOT NULL
                AND T4.C_VALID = '1' --有效

       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

 WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E') --筛选交易所流水 1：竞价平台；I：固收平台；E:上交所大宗交易 、深圳综合协议平台；
   AND T0.L_BUSIN_FLAG IN ('40901', '40902', '40801', '40802')
   --40909、40910为债券买入卖出交收,40801、40802为证券买入卖出
   AND T0.C_STATUS IN ('1') --1-正常，2-回溯，3-被回溯；
   AND T0.L_DATE = ${current_date}

 UNION ALL
--离线交收：交易所现券业务证券交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
               T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
                      '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
          WHEN T5.VC_MIXED_TYPE = 'p' AND T7.C_BUSIN_CLASS = 'I' AND
               T7.L_SETTLE_SPEED = 1 THEN
               concat('0|0|0|' , T7.L_DATE , '_HSO32' , '_Q' , T7.L_BUSIN_NO) --T+1非担保交收,使用Q区分
          ELSE
               concat('0|0|0|' , T7.L_DATE , '_HSO32' , '_Q' , T7.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CASE
          WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
               T7.L_SETTLE_SPEED = 1 THEN
               concat(T7.L_DATE , '_HSO32' , '_Q' , T7.L_BUSIN_NO) --T+1非担保交收,使用Q区分
          WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               concat(T7.L_DATE , '_HSO32' , '_L' , T7.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
          ELSE
               concat(T7.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
     END AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T5.C_ASSET_CLASS = '2' THEN
               concat(T5.VC_REPORT_CODE , '.STK.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                            WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                            WHEN T5.C_MARKET_NO = 'j' THEN
                                 (CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END)
                            WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)) --股票
          WHEN T5.C_ASSET_CLASS = '3' THEN
               concat(T5.VC_REPORT_CODE , '.BOND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))    --债券
          WHEN T5.C_ASSET_CLASS = '4' THEN
               concat(T5.VC_REPORT_CODE , '.FUND.' ,
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                            WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END))    --债券
          WHEN T5.C_ASSET_CLASS = '7' THEN
               concat(T5.VC_REPORT_CODE , '.WRNT.' ,
                      (CASE WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                            WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC' END)) --供股权
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
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
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
     '010001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('40801', '40909') THEN
               '01000100'
          WHEN T0.L_BUSIN_FLAG IN ('40802', '40910') THEN
               '01000101'
     END AS BUSI_CLAS, --业务类型
     '2' AS SETT_CLAS, --交收类型
     T0.L_SETTLE_AMOUNT AS SETT_VOL, --交收数量
     0 AS SETT_VAL, --交收金额
     0 AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T0.C_CASHSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T0.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T0.C_STOCKSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TPENDSETTLE T0 --获取代交收数据
       LEFT JOIN ${ods_db}.O3_TCURRENTS T7 --清算流水主表
         ON T7.L_BUSIN_NO = T0.VC_ORIGINAL_NO
                AND T7.L_DATE = T0.L_TRADE_DATE
                AND T7.L_BASECOMBI_ID = T0.L_BASECOMBI_ID
                AND T7.VC_INTER_CODE = T0.VC_INTER_CODE

       LEFT JOIN ${ods_db}.O3_TREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
         ON LPAD(T7.VC_DEAL_NO, 64, 0) = LPAD(T4.VC_DEAL_NO, 64, 0)
                AND T7.L_DATE = T4.L_DATE
                AND T7.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T7.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T7.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.VC_DEAL_NO IS NOT NULL
                AND T4.C_VALID = '1' --有效

       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

 WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E') --筛选交易所流水 1：竞价平台；I：固收平台；E:上交所大宗交易 、深圳综合协议平台；
   AND T0.L_BUSIN_FLAG IN ('40909', '40910', '40801', '40802')
   --40909、40910为债券买入卖出交收,40801、40802为证券买入卖出
   AND T0.C_STATUS IN ('1') --1-正常，2-回溯，3-被回溯；
   AND NVL(T0.C_STOCKSETTLE_FLAG,0) <> '0'
   AND T0.L_DATE = ${current_date}
) t
left join ${dwd_db}.VAR_SECU_CODE_CHG t1
on t.secu_id = t1.secu_id
     where (t.OCCU_DT between t1.NEW_SECU_ID_BGN_DT and t1.NEW_SECU_ID_END_DT) or t1.secu_id is null

 UNION ALL
--交收：交易所回购首期资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
               T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
                      '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
          WHEN T4.L_REALDEAL_SERIAL_NO IS NOT NULL THEN
               concat('0|0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
          ELSE
               concat('0|0|0|' , concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO))
     END AS TRD_SRC_ID, --交易源ID
     t14.aft_1_dt AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T6.L_DATE , '_HSO32' , '_' , T6.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO) AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     T6.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T6.VC_BIND_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T7.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T7.L_HG_DATE , '_' ,
            T5.VC_REPORT_CODE , '.REPO.' ,
            CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) AS SECU_ID, --证券编码

     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     CASE
          WHEN T0.C_ENTRUST_DIRECTION IN ('5') THEN
               '2'
          WHEN T0.C_ENTRUST_DIRECTION IN ('6') THEN
               '1'
     END AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     T6.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
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
     '020001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') THEN
               '02000100' --交易所质押式回购首期
          WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') THEN
               '02000101' --交易所质押式回购到期
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T6.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T6.EN_ACT_SETTLE_BALANCE, T6.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_CASHSETTLE_FLAG,0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG,0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG,0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_STOCKSETTLE_FLAG,0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG,0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG,0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT,--证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     t14.aft_1_dt as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TPENDSETTLE T6 --代交割表，
       LEFT JOIN ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                AND T0.L_DATE = T6.L_TRADE_DATE
                AND T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T6.C_ENTRUST_DIRECTION IN ('5', '6')

       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
         ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T4.VC_DEAL_NO, 64, 0)
                AND T0.L_DATE = T4.L_DATE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.C_VALID = T0.C_STATUS

       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

       LEFT JOIN ${ods_db}.O3_THGREGISTER T7
         ON T6.L_SERIAL_NO = T7.L_SERIAL_NO
                AND T6.L_TRADE_DATE = T7.L_HG_DATE

       left join ${dwd_db}.pub_tradeday_offset_trade t14 on  T0.L_DATE = t14.dt  and    T5.C_MARKET_NO = t14.mkt_no and t14.SYS_RS_ID = 'O3'
 WHERE T6.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水
   AND T6.L_BUSIN_FLAG IN ('41201', '41202')
   AND T6.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
   AND T6.L_DATE = ${current_date}

 UNION ALL
--交收：交易所回购到期资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     t15.aft_1_dt  AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T8.L_DATE , '_HSO32' , '_' , T8.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO,'C') AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T8.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T8.VC_BIND_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T7.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T7.L_HG_DATE , '_' ,
            T5.VC_REPORT_CODE , '.REPO.' ,
            CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN  '2' THEN  'SZ' END)  AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     CASE
          WHEN T0.C_ENTRUST_DIRECTION IN ('7') THEN
               '2'
          WHEN T0.C_ENTRUST_DIRECTION IN ('8') THEN
               '1'
     END AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     T8.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
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
     '020001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') THEN
               '02000100' --交易所质押式回购首期
          WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') THEN
               '02000101' --交易所质押式回购到期
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T8.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T8.EN_ACT_SETTLE_BALANCE, T8.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T8.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T8.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T8.C_CASHSETTLE_FLAG,0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T8.C_CASHSETTLE_FLAG,0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T8.C_CASHSETTLE_FLAG,0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T8.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T8.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T8.C_STOCKSETTLE_FLAG,0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T8.C_STOCKSETTLE_FLAG,0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T8.C_STOCKSETTLE_FLAG,0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     t15.aft_1_dt  as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TPENDSETTLE T8 --代交割表
       INNER JOIN ${ods_db}.O3_TCURRENTS T0 --清算流水主表
         ON T0.L_BUSIN_NO = T8.VC_ORIGINAL_NO
                AND T0.L_BASECOMBI_ID = T8.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
                AND T0.L_DATE = T8.L_TRADE_DATE

       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2', 'o', 'n') --1是上交所、2深交所,n沪港通，o是深港通

       LEFT JOIN ${ods_db}.O3_TPENDSETTLE T6 --代交割表
         ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                AND T6.C_ENTRUST_DIRECTION IN ('5', '6')

       LEFT JOIN ${ods_db}.O3_THGREGISTER T7
         ON T6.VC_ORIGINAL_NO = T7.L_SERIAL_NO
                AND T6.L_TRADE_DATE = T7.L_HG_DATE

       left join ${dwd_db}.pub_tradeday_offset_trade t15 on  T0.L_DATE= t15.dt  and    t5.c_market_no = t15.mkt_no and t15.SYS_RS_ID = 'O3'
 WHERE T8.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水
   AND T8.L_BUSIN_FLAG IN ('41203', '41204')
   AND T8.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
   AND T8.C_ENTRUST_DIRECTION IN ('7', '8')
   AND T8.L_DATE = ${current_date}

 UNION ALL
--交收：网上新股交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
               concat(T6.VC_REPORT_CODE , '.STK.' ,
                      (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
          WHEN T6.C_ASSET_CLASS = '3' OR T6.C_STOCK_TYPE = 'k' THEN --债券
               concat(T6.VC_REPORT_CODE , '.BOND.' ,
                      (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     '12' AS ENTR_DIR, --委托方向
     CASE
          WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
          WHEN T0.C_BUSIN_CLASS = 'I' THEN
               'PLAT_FIXINC'
     END TRD_PLFM, --交易平台
     '050001' AS BUSI_TYP, --业务类别,交易所现券交易
     '05000104' AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_5' AS TASK_RS_ID, --任务来源标识
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
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3','6')
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

 WHERE T0.C_BUSIN_CLASS IN ('1', 'I') --筛选交易所流水 1：竞价平台,I：固收平台
   AND T0.L_BUSIN_FLAG IN ('73174')
   --73174网上新股交收
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.L_DATE = ${current_date}

 UNION ALL
--交收：配股\配债\老股东配售交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' ,
            (CASE
                  WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND
                       T5.C_MARKET_NO = '1' AND T7.L_DATE IS NULL THEN
                       t12.aft_1_dt
                  ELSE
                       t13.aft_1_dt
             END)
          , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     CASE
          WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND
               T5.C_MARKET_NO = '1' AND T7.L_DATE IS NULL THEN
               t12.aft_1_dt
          ELSE
               t13.aft_1_dt
     END AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat((CASE
                  WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND
                       T5.C_MARKET_NO = '1' AND T7.L_DATE IS NULL THEN
                       t12.aft_1_dt
                  ELSE
                       t13.aft_1_dt
             END) , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN
               concat(T6.VC_REPORT_CODE , '.STK.' , --股票
                      (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END ))
          WHEN T6.C_ASSET_CLASS = '3' THEN --债券
               concat(T6.VC_REPORT_CODE , '.BOND.' ,
                      (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END))
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     CASE
          WHEN (T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a')) AND
               T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN
               '12' --上交所老股东配售
          ELSE
               '9' --配股配债
     END AS ENTR_DIR, --委托方向
     'PLAT_BID' TRD_PLFM, --交易平台
     CASE
          WHEN (T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a')) AND
               T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN
               '050701' --上交所老股东配售
          ELSE
               '060001' --配股配债
     END AS BUSI_TYP, --业务类别
     CASE
          WHEN (T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a')) AND
               T0.L_BUSIN_FLAG = '41302' AND T7.L_DATE IS NOT NULL THEN
               '05070103' --上交所老股东配售交收
          ELSE
               '06000106' --配股缴款交收
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_6' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     CASE
          WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND
               T5.C_MARKET_NO = '1' AND T7.L_DATE IS NULL THEN
               t12.aft_1_dt
          ELSE
               t13.aft_1_dt
     END as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3', '6')
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

       LEFT JOIN ${ods_db}.O3_TUNCOMPLETELOG T11 --未完成业务表,重点包含当前和离线两张表视图
         ON T0.L_DATE = T11.L_TRADE_DATE
                AND T0.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
                AND T6.VC_INTER_CODE = T11.VC_INTER_CODE
                AND T0.L_BUSIN_FLAG = T11.L_BUSIN_FLAG
                AND T0.L_BUSIN_FLAG IN ('41302')

       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T7
         ON T0.L_DATE = T7.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T7.VC_ASSET_RELATIVE_CODE
                AND T7.C_STOCK_TYPE IN ('d')
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
                AND T7.C_STOP_FLAG = '2'

       left join ${dwd_db}.pub_tradeday_offset_trade t12 on  T11.L_COMPLETE_DATE = t12.dt  and  T5.C_MARKET_NO = t12.mkt_no and t12.SYS_RS_ID = 'O3'
       left join ${dwd_db}.pub_tradeday_offset_trade t13 on  T0.L_DATE = t13.dt  and    T5.C_MARKET_NO = t13.mkt_no and t13.SYS_RS_ID = 'O3'

 WHERE T0.C_BUSIN_CLASS IN ('1') --筛选交易所流水 1：竞价平台
   AND T0.L_BUSIN_FLAG IN ('41302')
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND (CASE
             WHEN (T6.C_ASSET_CLASS = '2' OR T6.C_STOCK_TYPE IN ('a')) AND
                  T5.C_MARKET_NO = '1' AND T7.L_DATE IS NULL THEN
                  t12.aft_1_dt
             ELSE
                  t13.aft_1_dt
        END) = ${current_date}

 UNION ALL
--交收：供股权交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' , t6.aft_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     t6.aft_1_dt AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(t6.aft_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T5.VC_REPORT_CODE , '.STK.' ,
            case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end) AS SECU_ID, --证券编码
     case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     '9' AS ENTR_DIR, --委托方向
     NULL TRD_PLFM, --交易平台
     '060001' AS BUSI_TYP, --业务类别,交易所现券交易
     '06000110' AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_SUBJECT_BALANCE AS SETT_VAL, --交收金额
     T0.EN_SUBJECT_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_7' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     t6.aft_1_dt  as p_dt,
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
                AND T5.C_ASSET_CLASS IN ('7', '6', '2')
                AND T5.C_MARKET_NO IN ('n', 'o')
       left join ${dwd_db}.pub_tradeday_offset_settle t6
         on T0.L_DATE = t6.dt
                and T5.C_MARKET_NO = t6.mkt_no
                and t6.sys_rs_id = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.L_BUSIN_FLAG IN ('41304')
   AND T5.C_MARKET_NO IN ('n', 'o')
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.L_DATE = ${current_date}

 UNION ALL
--交收：证券组合费交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     T4.aft_1_dt AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T4.aft_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE WHEN T0.VC_SUMMARY LIKE '%沪港通证券组合费%' THEN 'ZQQSK.CASH.SHSC'
          WHEN T0.VC_SUMMARY LIKE '%深港通证券组合费%' THEN 'ZQQSK.CASH.SZSC'
     END AS SECU_ID, --证券编码
     CASE WHEN T0.VC_SUMMARY LIKE '%沪港通证券组合费%' THEN 'SHSC'
          WHEN T0.VC_SUMMARY LIKE '%深港通证券组合费%' THEN 'SZSC'
     END AS EXCH_CODE, --交易市场代码
     'ZQQSK' AS SECU_CODE, --证券代码
     NULL AS SRC_SECU_ID, --证券ID
     NULL AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     NULL AS ENTR_DIR, --委托方向
     NULL TRD_PLFM, --交易平台
     '340001' AS BUSI_TYP, --业务类别,交易所现券交易
     '34000101' AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_8' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.aft_1_dt as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T4
         ON T0.L_DATE = T4.dt
                AND T4.mkt_no = 'n'
                and t4.SYS_RS_ID = 'O3'
 WHERE T0.L_BUSIN_FLAG IN ('72969')
   AND T0.C_BUSIN_CLASS = '1'
   AND T0.C_STATUS ='1'
   AND T0.L_DATE = ${current_date}

 UNION ALL
--日初始化交收：债转股零碎股现金
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     T7.aft_1_dt AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     concat(T7.aft_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     concat(T6.VC_REPORT_CODE , '.STK.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
            END) AS SECU_ID, --证券编码
     CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     'CNY' AS CURR_CODE, --货币代码
     '10' AS ENTR_DIR, --委托方向
     NULL TRD_PLFM, --交易平台
     '260001' AS BUSI_TYP, --业务类别,交易所现券交易
     '26000103' AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_9' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T7.aft_1_dt  as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2')

       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所

       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T7
         ON T0.L_DATE = T7.dt
                AND T5.C_MARKET_NO = T7.mkt_no
                and t7.SYS_RS_ID = 'O3'
 WHERE T0.L_BUSIN_FLAG IN ('41403')
   AND T0.C_STATUS ='1'
   AND T0.L_DATE = ${current_date}

 UNION ALL
--离线交收：分销买入\分销卖出资金交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               CONCAT('0|', T4.L_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               CONCAT('0|0|', T4.L_DATE, '_HSO32', '_', T4.L_ENTRUST_SERIAL_NO, '|0')
          WHEN T4.L_REALDEAL_SERIAL_NO IS NOT NULL THEN
               CONCAT('0|0|0|', T4.L_DATE, '_HSO32', '_', T4.L_REALDEAL_SERIAL_NO)
          ELSE
               CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     T6.L_DATE AS OCCU_DT, --发生日期
     NULL AS occu_time, --发生时间
     CONCAT(T6.L_DATE, '_HSO32', '_', T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CASE
          WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_HSO32', T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
          ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_HSO32', T4.L_REALDEAL_SERIAL_NO)
     END AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T6.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T6.VC_BIND_SEAT AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN T5.C_ASSET_CLASS = '3' THEN
               CONCAT(T5.VC_REPORT_CODE, '.BOND.', (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)) --债券
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '21'
          WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '22'
     END AS ENTR_DIR, --委托方向
     CASE
          WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
     END AS TRD_PLFM, --交易平台
     '010001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.C_ENTRUST_DIRECTION in ('r') THEN
               '01000102'
          WHEN T0.C_ENTRUST_DIRECTION in ('L') THEN
               '01000103'
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T6.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T6.EN_ACT_SETTLE_BALANCE, T6.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_10' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TPENDSETTLE T6 --待交割表
       INNER JOIN ${ods_db}.O3_TCURRENTS T0 --清算流水主表
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
 WHERE T0.C_BUSIN_CLASS IN ('1') --筛选交易所流水
   AND T0.L_BUSIN_FLAG IN ('41503', '72441')
   --41503网上申购中签,72441分销卖出摘牌
   AND T6.C_STATUS = '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T0.L_DATE = ${current_date}

 UNION ALL
--离线交收：实时申赎基金申购\赎回
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
               T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               CONCAT('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               CONCAT('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
          WHEN T4.L_REALDEAL_SERIAL_NO IS NOT NULL THEN
               CONCAT('0|0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
          ELSE
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     T6.L_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     CONCAT(T6.L_DATE , '_HSO32' , '_' , T6.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CASE
          WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
     END AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     T0.L_TRADE_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T6.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T6.VC_BIND_SEAT AS SEAT_CODE, --席位号
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
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     CASE
          WHEN T0.L_BUSIN_FLAG = '72567' THEN
               '53'
          WHEN T0.L_BUSIN_FLAG = '72568' THEN
               '54'
     END AS ENTR_DIR, --委托方向
     NULL AS TRD_PLFM, --交易平台
     '380001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG = '72567' THEN
               '38000101'
          WHEN T0.L_BUSIN_FLAG = '72568' THEN
               '38000102'
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T6.EN_SETTLE_BALANCE AS SETT_VAL, --交收金额
     NVL(T6.EN_ACT_SETTLE_BALANCE, T6.EN_SETTLE_BALANCE) AS ACTL_SETT_VAL, --实际交收金额
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_CASHSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS CPTL_SETT_STAT, --资金交收状态
     CASE
          WHEN T6.C_STATUS IN ('2') THEN
               '5' --已回溯
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) = '1' THEN
               '4' --交收失败
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('2', '4') THEN
               '3' --已交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('1', '3') THEN
               '2' --未交收
          WHEN NVL(T6.C_STOCKSETTLE_FLAG, 0) IN ('0') THEN
               '1' --无需交收
     END AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_11' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T6.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISPENDSETTLE T6 --待交割表
       INNER JOIN ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
         ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                AND T0.L_DATE = T6.L_TRADE_DATE
                AND T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T0.C_STATUS = '1'
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISREALDEAL T4 --获取成交序号、委托序号、指令序号等交易过程数据
         ON T0.L_DATE = T4.L_DATE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T6.L_ENTRUST_SERIAL_NO = T4.L_ENTRUST_SERIAL_NO
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('5')
   AND T0.L_BUSIN_FLAG IN ('72567', '72568')
   --72567：场内基金申购，72568：场内基金赎回
   AND T6.C_STATUS = '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯
   AND T6.P_DT = ${current_date}

 UNION ALL
--20220902:ETF基金申赎_现金替代交收_单市场股票、跨市场股票（交易所）、跨境\黄金\沪港通\沪深港ETF股票（现金）只含申购部分
select T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
     T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
     T0.OCCU_DT AS OCCU_DT, --发生日期
     T0.OCCU_TIME AS OCCU_TIME, --发生时间
     MAX(T0.SETT_ONUM) AS SETT_ONUM, --交收序号
     MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
     MAX(T0.TNV_NO) AS TNV_NO, --成交编号
     T0.TNV_DT AS TNV_DT, --成交日期
     T0.PRD_CODE AS PRD_CODE, --产品代码
     T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
     T0.PFL_CODE AS PFL_CODE, --投组代码
     T0.SH_CODE AS SH_CODE, --股东代码
     T0.SEAT_CODE AS SEAT_CODE, --席位号
     T0.INV_TYP AS INV_TYP, --投资类型
     T0.SECU_ID AS SECU_ID, --证券编码
     T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
     T0.SECU_CODE AS SECU_CODE, --证券代码
     T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
     T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
     T0.POS_ID AS POS_ID, --多空标志
     T0.CURR_CODE AS CURR_CODE, --货币代码
     T0.ENTR_DIR AS ENTR_DIR, --委托方向
     T0.TRD_PLFM AS TRD_PLFM, --交易平台
     T0.BUSI_TYP AS BUSI_TYP, --业务类别
     T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
     T0.SETT_CLAS AS SETT_CLAS, --交收类型
     SUM(T0.SETT_VOL) AS SETT_VOL, --交收数量
     SUM(T0.SETT_VAL) AS SETT_VAL, --交收金额
     SUM(T0.ACTL_SETT_VAL) AS ACTL_SETT_VAL, --实际交收金额
     T0.CPTL_SETT_STAT AS CPTL_SETT_STAT, --资金交收状态
     T0.SECU_SETT_STAT AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_12' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.OCCU_DT as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
            WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
                 T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
                 CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
            WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND
                 T7.L_ENTRUST_SERIAL_NO <> 0 THEN
                 CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
            ELSE
                 CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
       END AS TRD_SRC_ID, --交易源ID
       W1.AFT_1_DT AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       CONCAT(W1.AFT_1_DT , '_HSO32' , '_' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CASE
            WHEN T4.L_REALDEAL_SERIAL_NO IS NULL THEN
                 CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
            ELSE
                 CONCAT(T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
       END AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       T0.L_DATE AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
            WHEN T0.C_INVEST_TYPE IN ('1') THEN
                 '2' --交易型金融资产
            WHEN T0.C_INVEST_TYPE IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
                      WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END --上交所资金,新模式
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
                      WHEN T5.VC_INTER_CODE = 'HSSZZJSS' THEN 'XCSZZJ.CASH.SH' END --上交所资金,新模式
       END AS SECU_CODE, --证券代码
       T9.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T9.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
            WHEN T0.L_BUSIN_FLAG IN ('41513', '41517', '41515') THEN
                 '26'
            WHEN T0.L_BUSIN_FLAG IN ('41514', '41518', '41516') THEN
                 '27'
       END AS ENTR_DIR, --委托方向
       NULL AS TRD_PLFM, --交易平台
       '370001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
            WHEN T0.L_BUSIN_FLAG in ('41517') THEN
                 '37000118' --ETF基金申购成交_现金替代
            WHEN T0.L_BUSIN_FLAG in ('41518') THEN
                 '37000121' --ETF基金赎回成交_现金替代
       END AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
       T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
       '3' AS CPTL_SETT_STAT, --资金交收状态
       '3' AS SECU_SETT_STAT --证券交收状态
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
               LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE W1
                 ON T0.L_DATE = W1.DT
                        AND T5.C_MARKET_NO = W1.MKT_NO
                        AND W1.SYS_RS_ID = 'O3'
         WHERE T0.C_BUSIN_CLASS IN ('6')
           AND T0.L_BUSIN_FLAG IN ('41517', '41518')
           AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
           AND W1.AFT_1_DT = ${current_date}
  ) T0
 GROUP BY BUSI_SYS_ID,
          TRD_SRC_ID,
          OCCU_DT,
          OCCU_TIME,
          TNV_DT,
          PRD_CODE,
          AST_UNIT_CODE,
          PFL_CODE,
          SH_CODE,
          SEAT_CODE,
          INV_TYP,
          SECU_ID,
          EXCH_CODE,
          SECU_CODE,
          SRC_SECU_ID,
          SRC_SECU_TRD_ID,
          POS_ID,
          CURR_CODE,
          ENTR_DIR,
          TRD_PLFM,
          BUSI_TYP,
          BUSI_CLAS,
          SETT_CLAS,
          CPTL_SETT_STAT,
          SECU_SETT_STAT

 UNION ALL
--交收：20220902 过户费
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
               T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
               CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
          WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND
               T7.L_ENTRUST_SERIAL_NO <> 0 THEN
               CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
          ELSE
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     W1.AFT_1_DT AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     CONCAT(W1.AFT_1_DT , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     T4.VC_DEAL_NO AS TNV_NO, --成交编号
     W1.AFT_1_DT AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
     END AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     CASE
          WHEN T7.C_ENTRUST_DIRECTION = 'P' THEN
               '26'
          WHEN T7.C_ENTRUST_DIRECTION = 'Q' THEN
               '27'
     END AS ENTR_DIR, --委托方向
     NULL AS TRD_PLFM, --交易平台
     '370001' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG in ('41515') THEN
               '37000127' --ETF基金申购交收_成分券过户费交收
          WHEN T0.L_BUSIN_FLAG in ('41516') THEN
               '37000128' --ETF基金赎回交收_成分券过户费交收
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '3' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_13' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     W1.AFT_1_DT as p_dt,
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
       LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE W1
         ON T0.L_DATE = W1.DT
                AND T5.C_MARKET_NO = W1.MKT_NO
                AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('6')
   AND T0.L_BUSIN_FLAG IN ('41515', '41516')
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
   AND W1.AFT_1_DT = ${current_date}

 UNION ALL
--交收：20220902 ETF 现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
select T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
     T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
     T0.OCCU_DT AS OCCU_DT, --发生日期
     T0.OCCU_TIME AS OCCU_TIME, --发生时间
     MAX(T0.SETT_ONUM) AS SETT_ONUM, --交收序号
     MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
     MAX(T0.TNV_NO) AS TNV_NO, --成交编号
     T0.TNV_DT AS TNV_DT, --成交日期
     T0.PRD_CODE AS PRD_CODE, --产品代码
     T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
     T0.PFL_CODE AS PFL_CODE, --投组代码
     T0.SH_CODE AS SH_CODE, --股东代码
     T0.SEAT_CODE AS SEAT_CODE, --席位号
     T0.INV_TYP AS INV_TYP, --投资类型
     T0.SECU_ID AS SECU_ID, --证券编码
     T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
     T0.SECU_CODE AS SECU_CODE, --证券代码
     T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
     T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
     T0.POS_ID AS POS_ID, --多空标志
     T0.CURR_CODE AS CURR_CODE, --货币代码
     T0.ENTR_DIR AS ENTR_DIR, --委托方向
     T0.TRD_PLFM AS TRD_PLFM, --交易平台
     T0.BUSI_TYP AS BUSI_TYP, --业务类别
     T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
     T0.SETT_CLAS AS SETT_CLAS, --交收类型
     SUM(T0.SETT_VOL) AS SETT_VOL, --交收数量
     SUM(T0.SETT_VAL) AS SETT_VAL, --交收金额
     SUM(T0.ACTL_SETT_VAL) AS ACTL_SETT_VAL, --实际交收金额
     T0.CPTL_SETT_STAT AS CPTL_SETT_STAT, --资金交收状态
     T0.SECU_SETT_STAT AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_14' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.OCCU_DT as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
            WHEN T7.L_DAILY_INSTRUCTION_NO IS NOT NULL AND
                 T7.L_DAILY_INSTRUCTION_NO <> 0 THEN
                 CONCAT('0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '|0|0')
            WHEN T7.L_ENTRUST_SERIAL_NO IS NOT NULL AND
                 T7.L_ENTRUST_SERIAL_NO <> 0 THEN
                 CONCAT('0|0|' , T7.L_DATE , '_HSO32' , '_' , T7.L_ENTRUST_SERIAL_NO , '|0')
            ELSE
                 CONCAT('0|0|0|' , T9.L_DATE , '_HSO32' , '_' , T9.L_REALDEAL_SERIAL_NO , '_E' , T4.L_REALDEAL_SERIAL_NO)
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(W1.pre_1_dt , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T4.VC_DEAL_NO AS TNV_NO, --成交编号
       W1.pre_1_dt AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
            WHEN T0.C_INVEST_TYPE IN ('1') THEN
                 '2' --交易型金融资产
            WHEN T0.C_INVEST_TYPE IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.' , CASE
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
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
            WHEN T7.C_ENTRUST_DIRECTION = 'P' THEN
                 '26'
            WHEN T7.C_ENTRUST_DIRECTION = 'Q' THEN
                 '27'
       END AS ENTR_DIR, --委托方向
       NULL AS TRD_PLFM, --交易平台
       '370001' AS BUSI_TYP, --业务类别,交易所现券交易
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
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
       T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
       '3' AS CPTL_SETT_STAT, --资金交收状态
       '1' AS SECU_SETT_STAT --证券交收状态
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
               LEFT JOIN ${ods_db}.O3_TUNCOMPLETELOG T8 --未完成，取未完成和已完成表的全量数据
                 ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T8.VC_DEAL_NO, 64, 0)
                        AND T0.L_FUND_ID = T8.L_FUND_ID
                        AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
                        AND T8.L_BUSIN_FLAG = '72855'
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
               LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE W1
                 ON T0.L_DATE = W1.DT
                        AND T5.C_MARKET_NO = W1.MKT_NO
                        AND W1.SYS_RS_ID = 'O3'
         WHERE T0.C_BUSIN_CLASS IN ('6')
           AND T0.L_BUSIN_FLAG IN ('41519', '72109', '72110', '72114')
           AND T0.C_STATUS IN ('1', '2') --1-正常，2-回溯，3-被回溯；
           AND T0.L_DATE = ${current_date}
           AND T0.L_DATE >= T8.L_TRADE_DATE
           AND T0.L_DATE <= T8.L_COMPLETE_DATE
  ) T0
 GROUP BY BUSI_SYS_ID,
          TRD_SRC_ID,
          OCCU_DT,
          OCCU_TIME,
          TNV_DT,
          PRD_CODE,
          AST_UNIT_CODE,
          PFL_CODE,
          SH_CODE,
          SEAT_CODE,
          INV_TYP,
          SECU_ID,
          EXCH_CODE,
          SECU_CODE,
          SRC_SECU_ID,
          SRC_SECU_TRD_ID,
          POS_ID,
          CURR_CODE,
          ENTR_DIR,
          TRD_PLFM,
          BUSI_TYP,
          BUSI_CLAS,
          SETT_CLAS,
          CPTL_SETT_STAT,
          SECU_SETT_STAT

 UNION ALL
--20220902 跨市场ETF(中登)交收：过户费、现金替代、ETF现金差额退款\ETF现金差额补款\ETF现金替代退款\ETF现金替代补款
select T0.BUSI_SYS_ID AS BUSI_SYS_ID, --业务系统编码
     T0.TRD_SRC_ID AS TRD_SRC_ID, --交易源ID
     T0.OCCU_DT AS OCCU_DT, --发生日期
     T0.OCCU_TIME AS OCCU_TIME, --发生时间
     MAX(T0.SETT_ONUM) AS SETT_ONUM, --交收序号
     MAX(T0.TNV_ONUM) AS TNV_ONUM, --成交序号
     MAX(T0.TNV_NO) AS TNV_NO, --成交编号
     T0.TNV_DT AS TNV_DT, --成交日期
     T0.PRD_CODE AS PRD_CODE, --产品代码
     T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
     T0.PFL_CODE AS PFL_CODE, --投组代码
     T0.SH_CODE AS SH_CODE, --股东代码
     T0.SEAT_CODE AS SEAT_CODE, --席位号
     T0.INV_TYP AS INV_TYP, --投资类型
     T0.SECU_ID AS SECU_ID, --证券编码
     T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
     T0.SECU_CODE AS SECU_CODE, --证券代码
     T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
     T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
     T0.POS_ID AS POS_ID, --多空标志
     T0.CURR_CODE AS CURR_CODE, --货币代码
     T0.ENTR_DIR AS ENTR_DIR, --委托方向
     T0.TRD_PLFM AS TRD_PLFM, --交易平台
     T0.BUSI_TYP AS BUSI_TYP, --业务类别
     T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
     T0.SETT_CLAS AS SETT_CLAS, --交收类型
     SUM(T0.SETT_VOL) AS SETT_VOL, --交收数量
     SUM(T0.SETT_VAL) AS SETT_VAL, --交收金额
     SUM(T0.ACTL_SETT_VAL) AS ACTL_SETT_VAL, --实际交收金额
     T0.CPTL_SETT_STAT AS CPTL_SETT_STAT, --资金交收状态
     T0.SECU_SETT_STAT AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_15' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.OCCU_DT as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM (SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|0|0|' , W2.pre_1_dt , '_HSO32' , '_J' , T4.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
       CONCAT(W1.pre_1_dt , '_HSO32' , '_J' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       W1.pre_1_dt AS TNV_DT, --成交日期
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
            WHEN T0.C_INVEST_TYPE IN ('1') THEN
                 '2' --交易型金融资产
            WHEN T0.C_INVEST_TYPE IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
                                   CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                        WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                                        WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                                        WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                                        WHEN T5.C_MARKET_NO = 'j' THEN
                                             CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                                        WHEN T5.C_MARKET_NO = 'r' THEN 'BJ' END)
                       WHEN T5.C_ASSET_CLASS = '3' THEN
                            CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
                                   CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                        WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                       WHEN T5.C_ASSET_CLASS = '4' THEN
                            CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                                   CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                                        WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
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
       T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
            WHEN T4.L_BUSIN_FLAG IN ('72834') THEN
                 '26'
            WHEN T4.L_BUSIN_FLAG IN ('72835') THEN
                 '27'
       END AS ENTR_DIR, --委托方向
       NULL AS TRD_PLFM, --交易平台
       '370001' AS BUSI_TYP, --业务类别,交易所现券交易
       CASE
            WHEN T0.L_BUSIN_FLAG in ('72842') THEN
                 '37000127' --ETF基金（投资端）申购交收_成分券过户费交收
            WHEN T0.L_BUSIN_FLAG in ('72490') THEN
                 '37000122' --ETF基金（投资端）申购交收_现金替代
            WHEN T0.L_BUSIN_FLAG in ('72843') THEN
                 '37000128' --ETF基金（投资端）赎回交收_成分券过户费交收
            WHEN T0.L_BUSIN_FLAG in ('72493') THEN
                 '37000123' --ETF基金（投资端）赎回交收_现金替代
            WHEN T0.L_BUSIN_FLAG in ('72495') THEN
                 '37000106' --ETF现金差额退款
            WHEN T0.L_BUSIN_FLAG in ('72498') THEN
                 '37000107' --ETF现金差额补款
            WHEN T0.L_BUSIN_FLAG in ('72501') THEN
                 '37000108' --ETF现金替代退款
            WHEN T0.L_BUSIN_FLAG in ('72504') THEN
                 '37000109' --ETF现金替代补款
       END AS BUSI_CLAS, --业务类型
       '1' AS SETT_CLAS, --交收类型
       0 AS SETT_VOL, --交收数量
       ABS(T0.EN_DEAL_BALANCE) + NVL(T0.EN_FEE_YH, 0) +
            NVL(T0.EN_FEE_GH, 0) + NVL(T0.EN_FEE_JS, 0) +
            NVL(T0.EN_FEE_ZG, 0) + NVL(T0.EN_FEE_JS2, 0) +
            NVL(T0.EN_RISK_FUND, 0) + NVL(T0.EN_FEE_QT, 0) +
            NVL(T0.EN_FEE_YJ, 0) AS SETT_VAL, --交收金额
       ABS(T0.EN_DEAL_BALANCE) + NVL(T0.EN_FEE_YH, 0) +
            NVL(T0.EN_FEE_GH, 0) + NVL(T0.EN_FEE_JS, 0) +
            NVL(T0.EN_FEE_ZG, 0) + NVL(T0.EN_FEE_JS2, 0) +
            NVL(T0.EN_RISK_FUND, 0) + NVL(T0.EN_FEE_QT, 0) +
            NVL(T0.EN_FEE_YJ, 0) AS ACTL_SETT_VAL, --实际交收金额
       '3' AS CPTL_SETT_STAT, --资金交收状态
       '1' AS SECU_SETT_STAT --证券交收状态
          FROM ${ods_db}.O3_TLIQUIDATEDETAIL T0 --清算流水主表
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                 ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                 ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                 ON T3.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                 ON T0.L_DATE = T5.L_DATE
                        AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TLIQUIDATEDETAIL T4
                 ON SUBSTR(T0.VC_REPORT_ID, -3) = SUBSTR(T4.VC_REPORT_ID, -3)
                        AND T0.L_FUND_ID = T4.L_FUND_ID
                        AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                        AND T4.L_BUSIN_FLAG IN ('72834', '72835')
               INNER JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE W2
                 ON T4.L_DATE = W2.DT
                        AND T5.C_MARKET_NO = W2.MKT_NO
                        AND W2.SYS_RS_ID = 'O3'
               LEFT JOIN ${ods_db}.O3_TETFBASICINFO T9
                 ON T0.L_DATE = T9.L_DATE
                        AND T5.VC_REPORT_CODE = T9.VC_REPORT_CODE
                        AND T9.C_EXEC_TYPE IN ('2')
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T10
                 ON T0.C_ENTRUST_DIRECTION = T10.C_ENTRUST_DIRECTION
                        AND T5.C_MARKET_NO = T10.C_MARKET_NO
               LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE W1
                 ON T0.L_DATE = W1.DT
                        AND T5.C_MARKET_NO = W1.MKT_NO
                        AND W1.SYS_RS_ID = 'O3'
         WHERE T0.C_BUSIN_CLASS IN ('6')
           AND T0.L_BUSIN_FLAG IN ('72842',
                                   '72843',
                                   '72490',
                                   '72493',
                                   '72495',
                                   '72498',
                                   '72501',
                                   '72504')
           AND T0.L_DATE = ${current_date}
           --YANGLI
           AND T0.L_BUSINESS_DATE = CASE WHEN T0.L_BUSINESS_DATE = W2.pre_1_dt THEN W2.pre_1_dt ELSE T4.L_DATE END
  ) T0
 GROUP BY BUSI_SYS_ID,
          TRD_SRC_ID,
          OCCU_DT,
          OCCU_TIME,
          TNV_DT,
          PRD_CODE,
          AST_UNIT_CODE,
          PFL_CODE,
          SH_CODE,
          SEAT_CODE,
          INV_TYP,
          SECU_ID,
          EXCH_CODE,
          SECU_CODE,
          SRC_SECU_ID,
          SRC_SECU_TRD_ID,
          POS_ID,
          CURR_CODE,
          ENTR_DIR,
          TRD_PLFM,
          BUSI_TYP,
          BUSI_CLAS,
          SETT_CLAS,
          CPTL_SETT_STAT,
          SECU_SETT_STAT

 UNION ALL
--离线交收：网上申购(股转/北交所)确认交收、网上中签(股转/北交所)退款交收
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T0.L_BUSIN_FLAG = '41501' THEN
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO)
          WHEN T0.L_BUSIN_FLAG = '41502' THEN
               CONCAT('0|0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     W1.AFT_1_DT AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     CONCAT(W1.AFT_1_DT , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CASE
          WHEN T0.L_BUSIN_FLAG = '41501' THEN
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO)
          WHEN T0.L_BUSIN_FLAG = '41502' THEN
               CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
     END AS TNV_ONUM, --成交序号
     NULL AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
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
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '12' AS ENTR_DIR, --委托方向
     NULL AS TRD_PLFM, --交易平台
     '050801' AS BUSI_TYP, --业务类别,交易所现券交易
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
               '05080103'
          WHEN T0.L_BUSIN_FLAG IN ('41502') THEN
               '05080104'
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     CASE WHEN T0.L_BUSIN_FLAG = '41501' THEN T0.EN_OCCUR_BALANCE ELSE T0.EN_OCCUR_BALANCE - NVL(T4.EN_OCCUR_BALANCE, 0) END AS SETT_VAL, --交收金额
     CASE WHEN T0.L_BUSIN_FLAG = '41501' THEN T0.EN_OCCUR_BALANCE ELSE T0.EN_OCCUR_BALANCE - NVL(T4.EN_OCCUR_BALANCE, 0) END AS ACTL_SETT_VAL, --实际交收金额
     '1' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_16' AS TASK_RS_ID, --任务来源标识
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
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('6', '3', '2')
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
         ON T5.L_DATE = T6.L_DATE
                AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
                AND T6.C_ASSET_CLASS IN ('2', '3', '6')
       LEFT JOIN ${ods_db}.O3_TCURRENTS T4
         ON T0.L_DATE = T4.L_DATE
                AND T6.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.L_FUND_ID = T4.L_FUND_ID
                AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
                AND T0.VC_SEAT_ID = T4.VC_SEAT_ID
                AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.L_BUSIN_FLAG = '41503'
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
         ON T0.L_DATE = W1.dt
                and T5.C_MARKET_NO= W1.mkt_no
                and W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('22')
   AND T0.L_BUSIN_FLAG IN ('41501', '41502') --申购确认、中签退款
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND W1.AFT_1_DT = ${current_date}

 UNION ALL
--离线资金交收：质押式协议回购首期\到期\续做\提前购回\解除质押
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
               CONCAT('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
                      '|0|0')
          WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND T4.L_ENTRUST_SERIAL_NO <> 0 THEN
               CONCAT('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO ,
                      '|0')
          ELSE
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO)
     END AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS SETT_ONUM, --交收序号
     CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_REALDEAL_SERIAL_NO) AS TNV_ONUM, --成交序号
     CASE T0.VC_DEAL_NO WHEN '0' THEN '' ELSE  T4.VC_DEAL_NO END AS TNV_NO, --成交编号
     T0.L_DATE AS TNV_DT, --成交日期
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     CASE
          WHEN  T7.L_SERIAL_NO IS NOT NULL THEN
               CONCAT(T7.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T7.L_HG_DATE , '_' ,
                      T5.VC_REPORT_CODE , '.REPO.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END))  --回购，能找到回购合约信息
     END AS SECU_ID, --证券编码
     CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END  AS EXCH_CODE, --交易市场代码
     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('73109', '73112', '73164', '73161', '73158', '73325') THEN
               '2'
          WHEN T0.L_BUSIN_FLAG IN ('73111', '73114', '73166', '73163', '73160', '73327') THEN
               '1'
     END AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
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
     NULL AS TRD_PLFM, --交易平台
     '020101' AS BUSI_TYP, --业务类别
     CASE
          WHEN T11.L_DAILY_INSTRUCTION_NO IS NOT NULL THEN
               '02010104' --续作
          WHEN T0.L_BUSIN_FLAG IN ('73109', '73111') THEN
               '02010100' --首期
          WHEN T0.L_BUSIN_FLAG IN ('73112', '73114') THEN
               '02010101' --到期
          WHEN T0.L_BUSIN_FLAG IN ('73158', '73160') THEN
               '02010102' --提前购回
          WHEN T0.L_BUSIN_FLAG IN ('73325', '73327') THEN
               '02010105' --解除质押
     END AS BUSI_CLAS, --业务类型
     '1' AS SETT_CLAS, --交收类型
     0 AS SETT_VOL, --交收数量
     T0.EN_OCCUR_BALANCE AS SETT_VAL, --交收金额
     T0.EN_OCCUR_BALANCE AS ACTL_SETT_VAL, --实际交收金额
     '3' AS CPTL_SETT_STAT, --资金交收状态
     '1' AS SECU_SETT_STAT, --证券交收状态
     NULL AS OPER_NO, -- '操作员编码'
     ${current_date} AS BUSI_DATE, --业务日期.
     'evt_exch_sett_real_17' AS TASK_RS_ID, --任务来源标识
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
         ON LPAD(T0.VC_DEAL_NO, 64, 0) = LPAD(T4.VC_DEAL_NO, 64, 0)
                AND T0.L_DATE = T4.L_DATE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.C_BUSIN_CLASS = T4.C_BUSIN_CLASS
                AND T4.C_VALID = T0.C_STATUS
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_MARKET_NO IN ('1', '2', 'o', 'n') --1是上交所、2深交所,n沪港通，o是深港通
       LEFT JOIN ${ods_db}.O3_THGREGISTER T7  --当前和历史的回购合约合集
         ON T4.VC_CONTRACT_NO = T7.VC_CONTRACT_NO
                AND T7.C_ENTRUST_DIRECTION IN ('15', '16')
       LEFT JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T11
         ON T4.L_DATE = T11.L_DATE
                AND T4.L_DAILY_INSTRUCTION_NO = T11.L_DAILY_INSTRUCTION_NO
                AND T4.L_BASECOMBI_ID = T11.L_BASECOMBI_ID
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