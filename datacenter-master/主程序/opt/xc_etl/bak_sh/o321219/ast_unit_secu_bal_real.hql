------------------------------------------------------------------------
-- 模块名称：投资单元证券余额历史表(盘后)
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

--清除当前分区的数据
alter table ${dwd_db}.ast_unit_secu_bal_his drop if exists partition (p_dt = ${current_date},sys_rs_id='O3') ;

--下午5点半获取股票、债券、基金持仓
  WITH V_THISRESTRICTEDSTOCK AS
            (SELECT A.L_UNIT_ID,
                 A.L_DATE,
                 SUM(A.L_RESTRICTED_AMOUNT) AS L_RESTRICTED_AMOUNT,
                 SUM(A.EN_BUY_BALANCE) AS EN_BUY_BALANCE,
                 SUM(A.EN_BUY_FEE) AS EN_BUY_FEE,
                 SUM(A.EN_UNTRANSFERED_INVEST) AS EN_UNTRANSFERED_INVEST
               FROM ${ods_db}.O3_TRESTRICTEDSTOCK A
              WHERE A.L_DATE = ${current_date}
              GROUP BY A.L_UNIT_ID, A.L_DATE
            ),
       VHISHOLDINGDETAIL AS
            (SELECT A.L_DATE,
                 A.L_UNIT_ID,
                 A.L_BASECOMBI_ID,
                 SUM(A.L_HOLDING_AMOUNT * A.EN_OPEN_PRICE) AS CB
               FROM ${ods_db}.O3_THOLDINGDETAIL A
              WHERE A.L_DATE = ${current_date}
              GROUP BY A.L_DATE, A.L_UNIT_ID, A.L_BASECOMBI_ID
            )

insert into ${dwd_db}.ast_unit_secu_bal_his partition(p_dt,sys_rs_id)
     (prd_code,ast_unit_code,pfl_code,sh_code,seat_code,hld_dt,secu_id,ivsm_type,hld_flag,pos_id,bgng_vol,curr_vol,curr_cost,frz_vol,unfz_vol,lmt_stk_vol,curr_divd,curr_plac,curr_buy_vol,curr_sell_vol,curr_buy_val,curr_sell_val,curr_buy_fee,curr_sell_fee,curr_val,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--普通A股、港股通持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
            END
          ) AS SECU_ID, --证券编码
     CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     T0.L_BEGIN_AMOUNT AS BGNG_VOL, --期初数量
     T0.L_CURRENT_AMOUNT - NVL(T0.L_RESTRICTED_AMOUNT, 0) AS CURR_VOL, --当前数量
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               ROUND(T4.EN_UNTRANSFERED_INVEST + T4.EN_BUY_BALANCE +
                          T4.EN_BUY_FEE -
                          T4.L_SALE_AMOUNT * (T4.EN_UNTRANSFERED_INVEST +
                               T4.EN_BUY_BALANCE + T4.EN_BUY_FEE) /
                               (T4.L_CURRENT_AMOUNT + T4.L_SALE_AMOUNT),
                     2)
          ELSE
               ROUND(T0.EN_UNTRANSFERED_INVEST - T9.EN_UNTRANSFERED_INVEST -
                          T9.EN_BUY_BALANCE - T9.EN_BUY_FEE --限售股成本
                            + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE -
                          T0.L_SALE_AMOUNT * (T0.EN_UNTRANSFERED_INVEST +
                               T0.EN_BUY_BALANCE + T0.EN_BUY_FEE) /
                               (T0.L_CURRENT_AMOUNT + T0.L_SALE_AMOUNT - NVL(T0.L_RESTRICTED_AMOUNT, 0) ),
                     2)
     END AS CURR_COST, --当前成本
     T0.L_FROZEN_AMOUNT AS FRZ_VOL, --冻结数量
     T0.L_UNFROZEN_AMOUNT AS UNFZ_VOL, --解冻数量
     T0.L_RESTRICTED_AMOUNT AS LMT_STK_VOL, --受限股数量
     NVL(T8.EN_TODAY_DIVIDEND, 0) AS CURR_DIVD, --当日红利
     NVL(T8.L_TODAY_SHAREOUT, 0) AS CURR_PLAC, --当日配股
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.L_BUY_AMOUNT, 0)
          ELSE
               T0.L_BUY_AMOUNT - CASE
                                      WHEN NVL(T9.EN_BUY_BALANCE, 0) = 0 THEN
                                           0
                                      ELSE
                                           T9.L_RESTRICTED_AMOUNT
                                 END
     END AS CURR_BUY_VOL, --当日买入数量
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.L_SALE_AMOUNT, 0)
          ELSE
               T0.L_SALE_AMOUNT
     END AS CURR_SELL_VOL, --当日卖出数量
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.EN_BUY_BALANCE, 0)
          ELSE
               T0.EN_BUY_BALANCE - NVL(T9.EN_BUY_BALANCE, 0)
     END AS CURR_BUY_VAL, --当日买入金额（本币）
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.EN_SALE_BALANCE, 0)
          ELSE
               T0.EN_SALE_BALANCE
     END AS CURR_SELL_VAL, --当日卖出金额（本币）
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.EN_BUY_FEE, 0)
           WHEN NVL(T0.EN_REAL_BUY_FEE, 0) = 0 THEN
               NVL(T0.EN_BUY_FEE, 0) - NVL(T9.EN_BUY_FEE, 0)
           ELSE
               NVL(T0.EN_REAL_BUY_FEE, 0) - NVL(T9.EN_BUY_FEE, 0)
     END AS CURR_BUY_FEE, --当日买入费用（本币）
     CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.EN_SALE_FEE, 0)
          ELSE
               T0.EN_SALE_FEE
     END AS CURR_SELL_FEE, --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TSETTLEUNITSTOCK T4
         ON T0.L_DATE = T4.L_DATE
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
                AND T0.VC_BIND_SEAT = T4.VC_BIND_SEAT
                AND T0.C_POSITION_FLAG = T4.C_POSITION_FLAG
                AND T0.C_INVEST_TYPE = T4.C_INVEST_TYPE
       LEFT JOIN ${ods_db}.O3_TSPECSTOCK T8
         ON T0.L_DATE = T8.L_DATE
                AND T0.L_UNIT_ID = T8.L_UNIT_ID
       LEFT JOIN V_THISRESTRICTEDSTOCK T9
         ON T0.L_DATE = T9.L_DATE
                AND T0.L_UNIT_ID = T9.L_UNIT_ID
 WHERE T5.C_ASSET_CLASS IN ('2')
   AND T0.C_POSITION_FLAG = '1'
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      (T0.L_CURRENT_AMOUNT - nvl(T0.L_RESTRICTED_AMOUNT,0) <> 0))
   AND T0.L_DATE = ${current_date}

 UNION ALL
--股票限售持仓
SELECT
PRD_CODE, --产品代码
AST_UNIT_CODE, --资产单元代码
PFL_CODE, --投组代码
SH_CODE, --股东代码
SEAT_CODE, --席位号
HLD_DT, --持仓日期
SECU_ID, --证券编码
IVSM_TYPE, --投资类型
HLD_FLAG, --持仓标志
POS_ID, --多空标志
SUM(BGNG_VOL) AS BGNG_VOL, --期初数量
SUM(CURR_VOL) AS CURR_VOL, --当前数量
SUM(CURR_COST) AS CURR_COST, --当前成本
SUM(FRZ_VOL) AS FRZ_VOL, --冻结数量
SUM(UNFZ_VOL) AS UNFZ_VOL, --解冻数量
SUM(LMT_STK_VOL) AS LMT_STK_VOL, --受限股数量
SUM(CURR_DIVD) AS CURR_DIVD, --当日红利
SUM(CURR_PLAC) AS CURR_PLAC, --当日配股
SUM(CURR_BUY_VOL) AS CURR_BUY_VOL, --当日买入数量
SUM(CURR_SELL_VOL) AS CURR_SELL_VOL, --当日卖出数量
SUM(CURR_BUY_VAL) AS CURR_BUY_VAL, --当日买入金额（本币）
SUM(CURR_SELL_VAL) AS CURR_SELL_VAL, --当日卖出金额（本币）
SUM(CURR_BUY_FEE) AS CURR_BUY_FEE, --当日买入费用（本币）
SUM(CURR_SELL_FEE) AS CURR_SELL_FEE, --当日卖出费用（本币）
SUM(CURR_VAL) AS CURR_VAL, --当前市值
MAX(BUSI_DATE) AS BUSI_DATE, --业务日期
MAX(TASK_RS_ID) AS TASK_RS_ID, --任务来源标识
MAX(DM_CREATED_TIME) AS DM_CREATED_TIME, --数据中台创建时间
MAX(p_dt) AS p_dt,
MAX(SYS_RS_ID) AS SYS_RS_ID --系统来源标识
FROM (
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
            END
          ) AS SECU_ID, --证券编码
     CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
     CASE WHEN T4.C_LOCKRESTRICTED_TYPE = '2' THEN '3'
          WHEN T4.C_LOCKRESTRICTED_TYPE = '3' THEN '4'
          WHEN T4.C_LOCKRESTRICTED_TYPE = '4' THEN '5'
          WHEN T4.C_LOCKRESTRICTED_TYPE = '5' THEN '2'
     END AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     T4.L_RESTRICTED_AMOUNT AS BGNG_VOL, --期初数量
     T4.L_RESTRICTED_AMOUNT AS CURR_VOL, --当前数量
     T4.EN_UNTRANSFERED_INVEST AS CURR_COST, --当前成本
     T4.L_RESTRICTED_AMOUNT AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     T4.L_RESTRICTED_AMOUNT AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     0 AS CURR_BUY_VOL, --当日买入数量
     0 AS CURR_SELL_VOL, --当日卖出数量
     0 AS CURR_BUY_VAL, --当日买入金额（本币）
     0 AS CURR_SELL_VAL, --当日卖出金额（本币）
     0 AS CURR_BUY_FEE, --当日买入费用（本币）
     0 AS CURR_SELL_FEE, --当日卖出费用（本币）
     T4.L_RESTRICTED_AMOUNT * (1-T7.EN_FLOW_DISCOUNT_RATIO) * T5.EN_LAST_PRICE AS CURR_VAL,        --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TRESTRICTEDSTOCK T4
       INNER JOIN ${ods_db}.O3_TUNITSTOCK T0
         ON T0.L_DATE = T4.L_DATE
                AND T0.L_UNIT_ID = T4.L_UNIT_ID
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TFLOWDISCOUNTRATIO T7
         ON T4.L_DATE = T7.L_DATE
                AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
                AND T4.L_RSEND_DATE = T7.L_RSEND_DATE
 WHERE T5.C_ASSET_CLASS IN ('2')
   AND T0.C_POSITION_FLAG = '1'
   AND T4.L_RSEND_DATE > T4.L_DATE
   AND T0.L_DATE = ${current_date}
) T
GROUP BY PRD_CODE, AST_UNIT_CODE, PFL_CODE, SH_CODE, SEAT_CODE, HLD_DT, SECU_ID, IVSM_TYPE, HLD_FLAG, POS_ID

 UNION ALL
--债券持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.BOND.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END) AS SECU_ID, --证券编码
     CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
     CASE
          WHEN T0.C_POSITION_FLAG = '1' THEN
               '1'
          WHEN T0.C_POSITION_FLAG = '5' THEN
               '6' --远期买入
          WHEN T0.C_POSITION_FLAG = '6' THEN
               '7' --远期卖出
     END AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     CASE
          WHEN T0.C_POSITION_FLAG = '1' THEN
               T0.L_BEGIN_AMOUNT
          WHEN T0.C_POSITION_FLAG = '5' THEN
               T0.L_BEGIN_AMOUNT
          WHEN T0.C_POSITION_FLAG = '6' THEN
               -T0.L_BEGIN_AMOUNT
     END AS BGNG_VOL, --期初数量
     CASE
          WHEN T0.C_POSITION_FLAG = '1' THEN
               T0.L_CURRENT_AMOUNT
          WHEN T0.C_POSITION_FLAG = '5' THEN
               T0.L_CURRENT_AMOUNT
          WHEN T0.C_POSITION_FLAG = '6' THEN
               -T0.L_CURRENT_AMOUNT
     END AS CURR_VOL, --当前数量
     ROUND(T0.EN_UNTRANSFERED_INVEST + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE -
                T0.L_SALE_AMOUNT *
                     (T0.EN_UNTRANSFERED_INVEST + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE) /
                     (T0.L_CURRENT_AMOUNT + T0.L_SALE_AMOUNT),
           2) AS CURR_COST, --当前成本
     T0.L_FROZEN_AMOUNT AS FRZ_VOL, --冻结数量
     T0.L_UNFROZEN_AMOUNT AS UNFZ_VOL, --解冻数量
     T0.L_RESTRICTED_AMOUNT AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     T0.L_BUY_AMOUNT AS CURR_BUY_VOL, --当日买入数量
     T0.L_SALE_AMOUNT AS CURR_SELL_VOL, --当日卖出数量
     T0.EN_BUY_BALANCE AS CURR_BUY_VAL, --当日买入金额（本币）
     T0.EN_SALE_BALANCE AS CURR_SELL_VAL, --当日卖出金额（本币）
       CASE WHEN nvl(T0.EN_REAL_BUY_FEE,0) = 0 THEN
         T0.EN_BUY_FEE
       ELSE
         T0.EN_REAL_BUY_FEE
       END                                                                                                      AS CURR_BUY_FEE,    --当日买入费用（本币）
       CASE WHEN nvl(T0.EN_REAL_SALE_FEE,0) = 0 THEN
         T0.EN_SALE_FEE
       ELSE
         T0.EN_REAL_SALE_FEE
       END                                                                                                      AS CURR_SELL_FEE,   --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN (SELECT NVL(B.VC_VALUE, 0) AS VC_VALUE
                    FROM ${ods_db}.O3_TSYSPARAMETER B
                   WHERE B.L_SERIAL_NO = '60533') T4
         ON 1 = 1
 WHERE T5.C_ASSET_CLASS IN ('3')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      T0.L_CURRENT_AMOUNT <> 0)
   AND ((T4.VC_VALUE = 0 AND T0.C_POSITION_FLAG IN ('1', '5', '6')) OR
      (T4.VC_VALUE = 1 AND T0.C_POSITION_FLAG IN ('1')))
   AND T0.VC_INTER_CODE NOT IN ('131990SZ', '888880SS')
   AND T0.L_DATE = ${current_date}

 UNION ALL
--基金持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '6' THEN 'NONE' END) AS SECU_ID, --证券编码
     CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     T0.L_BEGIN_AMOUNT AS BGNG_VOL, --期初数量
     T0.L_CURRENT_AMOUNT AS CURR_VOL, --当前数量
     ROUND(T0.EN_UNTRANSFERED_INVEST + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE -
                T0.L_SALE_AMOUNT *
                     (T0.EN_UNTRANSFERED_INVEST + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE) /
                     (T0.L_CURRENT_AMOUNT + T0.L_SALE_AMOUNT),
           2) AS CURR_COST, --当前成本
     T0.L_FROZEN_AMOUNT AS FRZ_VOL, --冻结数量
     T0.L_UNFROZEN_AMOUNT AS UNFZ_VOL, --解冻数量
     T0.L_RESTRICTED_AMOUNT AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     T0.L_BUY_AMOUNT AS CURR_BUY_VOL, --当日买入数量
     T0.L_SALE_AMOUNT AS CURR_SELL_VOL, --当日卖出数量
     T0.EN_BUY_BALANCE AS CURR_BUY_VAL, --当日买入金额（本币）
     T0.EN_SALE_BALANCE AS CURR_SELL_VAL, --当日卖出金额（本币）
       CASE WHEN nvl(T0.EN_REAL_BUY_FEE,0) = 0 THEN
         T0.EN_BUY_FEE
       ELSE
         T0.EN_REAL_BUY_FEE
       END                                                                                                      AS CURR_BUY_FEE,    --当日买入费用（本币）
       CASE WHEN nvl(T0.EN_REAL_SALE_FEE,0) = 0 THEN
         T0.EN_SALE_FEE
       ELSE
         T0.EN_REAL_SALE_FEE
       END                                                                                                      AS CURR_SELL_FEE,   --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T5.C_ASSET_CLASS IN ('4')
   AND T0.C_POSITION_FLAG = '1'
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      T0.L_CURRENT_AMOUNT <> 0)
   AND T0.L_DATE = ${current_date}

 UNION ALL

--回购持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     T4.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END) AS SECU_ID, --证券编码
     '2' AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     CASE
          WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7', '15', '17') THEN
               'S'
          ELSE
               'L'
     END AS POS_ID, --多空标志
     CASE
          WHEN T4.L_DATE = T0.L_HG_DATE THEN
               0
          ELSE
               T0.L_DEAL_AMOUNT
     END AS BGNG_VOL, --期初数量
     CASE
          WHEN T4.L_DATE = T0.L_REDEEM_LIQUIDATE THEN
               0
          ELSE
               T0.L_DEAL_AMOUNT
     END AS CURR_VOL, --当前数量
     CASE
          WHEN T4.L_DATE = T0.L_REDEEM_LIQUIDATE THEN
               0
          ELSE
               T0.EN_DEAL_BALANCE
     END AS CURR_COST, --当前成本
     0 AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     0 AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     CASE
          WHEN T4.L_DATE = T0.L_HG_DATE THEN
               T0.L_DEAL_AMOUNT
          ELSE
               0
     END AS CURR_BUY_VOL, --当日买入数量
     CASE
          WHEN T4.L_DATE = T0.L_REDEEM_LIQUIDATE THEN
               T0.L_DEAL_AMOUNT
          ELSE
               0
     END AS CURR_SELL_VOL, --当日卖出数量
     CASE
          WHEN T4.L_DATE = T0.L_HG_DATE THEN
               T0.EN_DEAL_BALANCE
          ELSE
               0
     END AS CURR_BUY_VAL, --当日买入金额（本币）
     CASE
          WHEN T4.L_DATE = T0.L_REDEEM_LIQUIDATE THEN
               T0.EN_DEAL_BALANCE
          ELSE
               0
     END AS CURR_SELL_VAL, --当日卖出金额（本币）
     CASE
          WHEN T4.L_DATE = T0.L_HG_DATE THEN
               T0.EN_FEE
          ELSE
               0
     END AS CURR_BUY_FEE, --当日买入费用（本币）
     0 AS CURR_SELL_FEE, --当日卖出费用（本币）
     CASE
          WHEN T4.L_DATE = T0.L_REDEEM_LIQUIDATE THEN
               0
          ELSE
               T0.EN_DEAL_BALANCE
     END AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_5' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
       INNER JOIN ${ods_db}.O3_THGREGISTER T0 --当前表和历史表的合集
         ON NVL(T0.C_STATUS, 0) = 0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'
   AND T4.L_DATE >= T0.L_HG_DATE
   AND T4.L_DATE <= T0.L_REDEEM_LIQUIDATE
   AND T4.L_DATE = ${current_date}

 UNION ALL
--存款持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     NULL AS SH_CODE, --股东代码
     NULL AS SEAT_CODE, --席位号
     T4.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T0.L_CONFIRM_NO , LPAD(T0.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' ,
            T1.VC_FUND_CODE , '-' , T0.L_DATE , '-' , (CASE
                                                            WHEN T5.VC_REPORT_CODE = '890890' THEN
                                                                 'DPSI103'
                                                            WHEN T5.VC_REPORT_CODE = '870870' THEN
                                                                 'DPSI102'
                                                            WHEN T5.VC_REPORT_CODE = '860860' THEN
                                                                 'DPSI104'
                                                            WHEN T5.VC_REPORT_CODE = '880880' THEN
                                                                 'DPSI108'
                                                       END) , '.DPSI.NONE') AS SECU_ID, --证券编码
     '2' AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     CASE
          WHEN T4.L_DATE = T0.L_DATE THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS BGNG_VOL, --期初数量
     CASE
          WHEN T4.L_DATE = T0.L_END_DATE THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS CURR_VOL, --当前数量
     CASE
          WHEN T4.L_DATE = T0.L_END_DATE THEN
               0
          ELSE
               T0.EN_BALANCE
     END AS CURR_COST, --当前成本
     0 AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     0 AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     CASE
          WHEN T4.L_DATE = T0.L_DATE THEN
               T0.EN_BALANCE
          ELSE
               0
     END AS CURR_BUY_VOL, --当日买入数量
     CASE
          WHEN T4.L_DATE = T0.L_END_DATE THEN
               T0.EN_BALANCE
          ELSE
               0
     END AS CURR_SELL_VOL, --当日卖出数量
     CASE
          WHEN T4.L_DATE = T0.L_DATE THEN
               T0.EN_BALANCE
          ELSE
               0
     END AS CURR_BUY_VAL, --当日买入金额（本币）
     CASE
          WHEN T4.L_DATE = T0.L_END_DATE THEN
               T0.EN_BALANCE
          ELSE
               0
     END AS CURR_SELL_VAL, --当日卖出金额（本币）
     0 AS CURR_BUY_FEE, --当日买入费用（本币）
     0 AS CURR_SELL_FEE, --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_6' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
       INNER JOIN ${ods_db}.O3_TDEPOSITRECEIPT T0
         ON NVL(T0.C_STATUS, '0') IN ('1', '2', '3', '4', '5')
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'
   AND T4.L_DATE >= T0.L_DATE
   AND T4.L_DATE <= T0.L_END_DATE
   AND T4.L_DATE = ${current_date}

 UNION ALL
--期货持仓
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.FUT.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
                 WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
                 WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
                 WHEN T5.C_MARKET_NO = '9' THEN 'DCE'
            END) AS SECU_ID, --证券编码
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
     END AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     CASE WHEN T0.C_POSITION_FLAG = '1' THEN 'L' WHEN T0.C_POSITION_FLAG = '2' THEN 'S' END AS POS_ID, --多空标志
     T0.L_BEGIN_AMOUNT AS BGNG_VOL, --期初数量
     T0.L_CURRENT_AMOUNT AS CURR_VOL, --当前数量
     0 AS CURR_COST, --当前成本
     0 AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     0 AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     T0.L_BUY_AMOUNT AS CURR_BUY_VOL, --当日买入数量
     T0.L_SALE_AMOUNT AS CURR_SELL_VOL, --当日卖出数量
     T0.EN_BUY_BALANCE AS CURR_BUY_VAL, --当日买入金额（本币）
     T0.EN_SALE_BALANCE AS CURR_SELL_VAL, --当日卖出金额（本币）
     T0.EN_BUY_FEE AS CURR_BUY_FEE, --当日买入费用（本币）
     T0.EN_SALE_FEE AS CURR_SELL_FEE, --当日卖出费用（本币）
     (T0.L_CURRENT_AMOUNT * T6.EN_PRICE - T4.CB) * T6.L_MULTIPLE AS CURR_VAL, --当前市值
     ${current_date} AS BUSI_DATE, --业务日期
     'ast_unit_secu_bal_real_7' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TUNITSTOCK T0
       LEFT JOIN VHISHOLDINGDETAIL T4
         ON T0.L_DATE = T4.L_DATE
                AND T0.L_UNIT_ID = T4.L_UNIT_ID
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TFUTURESINFO T6
         ON T0.L_DATE = T6.L_DATE
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
 WHERE T5.C_ASSET_CLASS IN ('9')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      T0.L_CURRENT_AMOUNT <> 0)
   AND T0.L_DATE = ${current_date}
;