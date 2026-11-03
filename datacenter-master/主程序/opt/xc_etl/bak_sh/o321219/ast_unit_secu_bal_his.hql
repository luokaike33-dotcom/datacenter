------------------------------------------------------------------------
-- 模块名称：投资单元证券余额历史表
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
----set spark.driver.memory=4G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;

--清除指定范围分区的数据
alter table ${dwd_db}.ast_unit_secu_bal_his drop if exists partition (p_dt>=${beg_date}, p_dt<=${end_date}, sys_rs_id='O3');

--离线获取T-1日股票、债券、基金持仓
WITH V_THISRESTRICTEDSTOCK AS (
  SELECT A.L_UNIT_ID,
     A.L_DATE,
     SUM(A.L_RESTRICTED_AMOUNT) AS L_RESTRICTED_AMOUNT,
     SUM(A.EN_BUY_BALANCE) AS EN_BUY_BALANCE,
     SUM(A.EN_BUY_FEE) AS EN_BUY_FEE,
     SUM(A.EN_UNTRANSFERED_INVEST) AS EN_UNTRANSFERED_INVEST
   FROM ${ods_db}.O3_THISRESTRICTEDSTOCK A
  WHERE A.p_dt between ${beg_date} and ${end_date}
  GROUP BY A.L_UNIT_ID, A.L_DATE
),
VHISHOLDINGDETAIL AS (
SELECT A.L_DATE,
     A.L_UNIT_ID,
     A.L_BASECOMBI_ID,
     SUM(cast(A.L_HOLDING_AMOUNT as DECIMAL(18,2)) * cast(A.EN_OPEN_PRICE as DECIMAL(18,2))) AS CB
   FROM ${ods_db}.O3_THISHOLDINGDETAIL A
  WHERE A.p_dt between ${beg_date} and ${end_date}
  GROUP BY A.L_DATE, A.L_UNIT_ID, A.L_BASECOMBI_ID
),
VHISSECURITYLOAN AS (
SELECT
T0.VC_STOCKHOLDER_ID,T0.VC_SEAT_ID,T0.VC_CONTRACT_NO,T0.L_DEAL_AMOUNT,T0.L_REDEEM_LIQUIDATE,T0.EN_DEAL_BALANCE,T0.EN_FEE,T0.EN_DEAL_PRICE,T0.C_ENTRUST_DIRECTION ,T0.L_DEAL_DATE ,T0.L_CLEAR_DATE,T0.L_FUND_ID,T0.L_BASECOMBI_ID,T0.L_DATE,T0.VC_INTER_CODE, T0.VC_ORIGINAL_DEAL_NO, T0.C_RETURN_FLAG
FROM ${ods_db}.O3_THISSECURITYLOAN T0
WHERE p_dt BETWEEN ${beg_date} AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),365),'yyyyMMdd')
UNION
SELECT
T0.VC_STOCKHOLDER_ID,T0.VC_SEAT_ID,T0.VC_CONTRACT_NO,T0.L_DEAL_AMOUNT,T0.L_REDEEM_LIQUIDATE,T0.EN_DEAL_BALANCE,T0.EN_FEE,T0.EN_DEAL_PRICE,T0.C_ENTRUST_DIRECTION ,T0.L_DEAL_DATE ,T0.L_CLEAR_DATE,T0.L_FUND_ID,T0.L_BASECOMBI_ID,T0.L_DATE,T0.VC_INTER_CODE, T0.VC_ORIGINAL_DEAL_NO, T0.C_RETURN_FLAG
FROM ${ods_db}.O3_TSECURITYLOAN T0
),
VHISHGREGISTER AS (
SELECT L_DATE , L_OPERATOR_NO , L_FUND_ID , L_REDEEM_DAYS, L_REDEEM_LAWDATE , L_REDEEM_LIQUIDATE , C_MARKET_NO , VC_SEAT_ID , VC_STOCKHOLDER_ID , VC_INTER_CODE , C_STOCK_TYPE, C_ENTRUST_DIRECTION , L_DEAL_AMOUNT , EN_DEAL_PRICE , EN_DEAL_BALANCE , EN_REDEEM_INTEREST , L_REPORT_TIME , EN_FEE , L_SETTLE_DATE , L_SETTLE_SPEED , C_FROZEN_FLAG , L_BASECOMBI_ID , C_REDEAL_FLAG , L_SERIAL_NO , L_REDEAL_DATE , L_ENTRUST_SERIAL_NO , L_HG_DATE , C_PURPOSE_TYPE , C_REDEAL_AVAILABLE_FLAG , EN_FIRST_PRICE , EN_FIRST_BOND_INTEREST , EN_MATURE_PRICE, EN_MATURE_BOND_INTEREST , EN_INTEREST_PAYMENT_BALANCE , L_BUSIN_AMOUNT , EN_NOW_INTEREST, VC_CONTRACT_NO , L_YEAR_DAYS , EN_GH_BALANCE , EN_EXTRA_PAY_INTEREST , EN_NEW_RATE , L_NEW_REDEEM_DATE , C_TRUSTEE , VC_TARGET_INTER_CODE , VC_TARGET_STOCKHOLDER_ID , VC_TARGET_SEAT_ID , VC_SUMMARY , VC_RIVAL_SEAT , L_RIVAL_ID , EN_MORTGAGE_BALANCE , VC_RIVALTRADER_ID , L_HG_TRADE_DATE , VC_BASKET_NO, C_CLEAR_TYPE , C_STATUS
FROM  ${ods_db}.o3_thishgregister
WHERE nvl(C_STATUS,'0') <> '1'
AND p_dt BETWEEN ${beg_date} AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),365),'yyyyMMdd')
UNION ALL
SELECT L_DATE , L_OPERATOR_NO , L_FUND_ID , L_REDEEM_DAYS, L_REDEEM_LAWDATE , L_REDEEM_LIQUIDATE , C_MARKET_NO , VC_SEAT_ID , VC_STOCKHOLDER_ID , VC_INTER_CODE , C_STOCK_TYPE, C_ENTRUST_DIRECTION , L_DEAL_AMOUNT , EN_DEAL_PRICE , EN_DEAL_BALANCE , EN_REDEEM_INTEREST , L_REPORT_TIME , EN_FEE , L_SETTLE_DATE , L_SETTLE_SPEED , C_FROZEN_FLAG , L_BASECOMBI_ID , C_REDEAL_FLAG , L_SERIAL_NO , L_REDEAL_DATE , L_ENTRUST_SERIAL_NO , L_HG_DATE , C_PURPOSE_TYPE , C_REDEAL_AVAILABLE_FLAG , EN_FIRST_PRICE , EN_FIRST_BOND_INTEREST , EN_MATURE_PRICE, EN_MATURE_BOND_INTEREST , EN_INTEREST_PAYMENT_BALANCE , L_BUSIN_AMOUNT , EN_NOW_INTEREST, VC_CONTRACT_NO , L_YEAR_DAYS , EN_GH_BALANCE , EN_EXTRA_PAY_INTEREST , EN_NEW_RATE , L_NEW_REDEEM_DATE , C_TRUSTEE , VC_TARGET_INTER_CODE , VC_TARGET_STOCKHOLDER_ID , VC_TARGET_SEAT_ID , VC_SUMMARY , VC_RIVAL_SEAT , L_RIVAL_ID , EN_MORTGAGE_BALANCE , VC_RIVALTRADER_ID , L_HG_TRADE_DATE , VC_BASKET_NO, C_CLEAR_TYPE , C_STATUS
FROM ${ods_db}.o3_thgregister
WHERE nvl(C_STATUS,'0') <> '1'       
),
V_FUND_ZTG AS(
SELECT
L_DATE,L_FUND_ID,L_ASSET_ID,L_BASECOMBI_ID,VC_STOCKHOLDER_ID,VC_SEAT_ID,VC_INTER_CODE,C_INVEST_TYPE,SUM(L_BUSIN_AMOUNT) AS L_BUSIN_AMOUNT
FROM ${ods_db}.o3_THISCURRENTS 
WHERE P_DT BETWEEN ${beg_date} AND ${end_date}
AND L_BUSIN_FLAG = '41603'
AND C_BUSIN_CLASS = '1'
AND C_ENTRUST_DIRECTION IN ('G')
AND VC_INTER_CODE LIKE '%SZ%'
GROUP BY L_DATE,L_FUND_ID,L_ASSET_ID,L_BASECOMBI_ID,VC_STOCKHOLDER_ID,VC_SEAT_ID,VC_INTER_CODE,C_INVEST_TYPE
)

insert into ${dwd_db}.ast_unit_secu_bal_his partition(p_dt,sys_rs_id)
(prd_code,ast_unit_code,pfl_code,sh_code,seat_code,hld_dt,secu_id,ivsm_type,hld_flag,pos_id,bgng_vol,curr_vol,curr_cost,frz_vol,unfz_vol,lmt_stk_vol,curr_divd,curr_plac,curr_buy_vol,curr_sell_vol,curr_buy_val,curr_sell_val,curr_buy_fee,curr_sell_fee,curr_val,quot_prc,accr_intr,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
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
	 CASE WHEN NVL(T8.L_UNCIRCULATED_AMOUNT, 0) <>0 THEN '9'  --新股
            WHEN T0.C_POSITION_FLAG = '8' THEN '10'  --证券融出
			ELSE '1'
	 END AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     ABS(T0.L_BEGIN_AMOUNT) AS BGNG_VOL, --期初数量
     T0.L_CURRENT_AMOUNT - case when ABS(NVL(T9.L_RESTRICTED_AMOUNT, 0)-NVL(T0.L_RESTRICTED_AMOUNT, 0)) > 0 AND ABS(NVL(T9.L_RESTRICTED_AMOUNT, 0)-NVL(T0.L_RESTRICTED_AMOUNT, 0)) < 1 THEN NVL(T9.L_RESTRICTED_AMOUNT, 0) ELSE NVL(T0.L_RESTRICTED_AMOUNT, 0) END AS CURR_VOL, --当前数量
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
     ABS(T0.L_FROZEN_AMOUNT) AS FRZ_VOL, --冻结数量
     ABS(T0.L_UNFROZEN_AMOUNT) AS UNFZ_VOL, --解冻数量
     ABS(T0.L_RESTRICTED_AMOUNT) AS LMT_STK_VOL, --受限股数量
     NVL(T8.EN_ONTHEWAY_DIVIDEND, 0) AS CURR_DIVD, --当日红利
     NVL(T8.L_TODAY_SHAREOUT, 0) AS CURR_PLAC, --当日配股
     ABS(CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.L_BUY_AMOUNT, 0)
          ELSE
               T0.L_BUY_AMOUNT - CASE
                                      WHEN NVL(T9.EN_BUY_BALANCE, 0) = 0 THEN
                                           0
                                      ELSE
                                           T9.L_RESTRICTED_AMOUNT
                                 END
     END) AS CURR_BUY_VOL, --当日买入数量
     ABS(CASE
          WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
               NVL(T4.L_SALE_AMOUNT, 0)
          ELSE
               T0.L_SALE_AMOUNT
     END) AS CURR_SELL_VOL, --当日卖出数量
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
           WHEN NVL(T0.EN_REAL_SALE_FEE, 0) = 0 THEN
               T0.EN_SALE_FEE
           ELSE
               T0.EN_REAL_SALE_FEE
           END AS CURR_SELL_FEE,   --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
	 0 AS QUOT_PRC, --行情价格
	 0 as ACCR_INTR,--应计利息
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_1' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T0.p_dt = T5.p_dt
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSETTLEUNITSTOCK T4
         ON T0.p_dt = T4.p_dt
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
                AND T0.VC_BIND_SEAT = T4.VC_BIND_SEAT
                AND T0.C_POSITION_FLAG = T4.C_POSITION_FLAG
                AND T0.C_INVEST_TYPE = T4.C_INVEST_TYPE
                AND T4.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISSPECSTOCK T8
         ON T0.p_dt = T8.p_dt
                AND T0.L_UNIT_ID = T8.L_UNIT_ID
                AND T8.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN V_THISRESTRICTEDSTOCK T9
         ON T0.p_dt = T9.L_DATE
                AND T0.L_UNIT_ID = T9.L_UNIT_ID
 WHERE T5.C_ASSET_CLASS IN ('2')
   AND T0.C_POSITION_FLAG IN ('1', '8') --8转融券证券借出
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      (T0.L_CURRENT_AMOUNT - nvl(T0.L_RESTRICTED_AMOUNT,0) <> 0) OR nvl(T8.EN_ONTHEWAY_DIVIDEND,0) <> 0)
   AND T0.p_dt between ${beg_date} and ${end_date}

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
0 AS QUOT_PRC, --行情价格
0 as ACCR_INTR,--应计利息
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
          WHEN T4.C_LOCKRESTRICTED_TYPE in ('1','5') THEN '2'
     END AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     ABS(T4.L_RESTRICTED_AMOUNT) AS BGNG_VOL, --期初数量
     ABS(T4.L_RESTRICTED_AMOUNT) AS CURR_VOL, --当前数量
     T4.EN_UNTRANSFERED_INVEST AS CURR_COST, --当前成本
     ABS(T4.L_RESTRICTED_AMOUNT) AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     ABS(T4.L_RESTRICTED_AMOUNT) AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     0 AS CURR_BUY_VOL, --当日买入数量
     0 AS CURR_SELL_VOL, --当日卖出数量
     0 AS CURR_BUY_VAL, --当日买入金额（本币）
     0 AS CURR_SELL_VAL, --当日卖出金额（本币）
     0 AS CURR_BUY_FEE, --当日买入费用（本币）
     0 AS CURR_SELL_FEE, --当日卖出费用（本币）
     T4.L_RESTRICTED_AMOUNT * 
	 CASE WHEN T1.C_RESACCOUNT_TYPE IS NULL OR (
	         INSTR(CONCAT(',' , NVL(T1.VC_DISCOUNT_RESTYPE,0) , ',') , CONCAT(',' , NVL(T4.C_LOCKRESTRICTED_TYPE,0) , ',')) <= 0 AND
			 INSTR(CONCAT(',' , NVL(T1.VC_DISCOUNT_RESTYPE,0) , ',') , CONCAT(',' , '-1' , ',')) <= 0
			 ) THEN T5.EN_LAST_PRICE
	 ELSE round((1-nvl(T7.EN_FLOW_DISCOUNT_RATIO,0)) * T5.EN_LAST_PRICE,2) 
	 END AS CURR_VAL,        --当前市值
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_2' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISRESTRICTEDSTOCK T4
       INNER JOIN ${ods_db}.O3_THISUNITSTOCK T0
         ON T0.p_dt = T4.p_dt
                AND T0.L_UNIT_ID = T4.L_UNIT_ID
                AND T0.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T0.p_dt = T5.p_dt
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN ${ods_db}.O3_THISFLOWDISCOUNTRATIO T7
         ON T4.p_dt = T7.p_dt
                AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
                AND T4.L_RSEND_DATE = CASE WHEN T7.p_dt = 20230602 AND T7.VC_INTER_CODE = '002928SZ' THEN 20230605 
										   WHEN T7.p_dt = 20230609 AND T7.VC_INTER_CODE = '600703SS' THEN 20230612 
										   WHEN T7.p_dt = 20230621 AND T7.VC_INTER_CODE = '300982SZ' THEN 20230627
									  ELSE T7.L_RSEND_DATE END
                AND T7.p_dt between ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('2')
   AND T0.C_POSITION_FLAG IN ('1','8') --8转融券证券借出
   AND T4.L_RSEND_DATE >= T4.p_dt
   AND T4.p_dt between ${beg_date} and ${end_date}
) T
GROUP BY PRD_CODE, AST_UNIT_CODE, PFL_CODE, SH_CODE, SEAT_CODE, HLD_DT, SECU_ID, IVSM_TYPE, HLD_FLAG, POS_ID

UNION ALL
--融券负债
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       T0.L_DATE AS HLD_DT, --持仓日期
       CONCAT(T5.VC_REPORT_CODE , '.STK.' ,CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
            END) AS SECU_ID, --证券编码
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
       '1' AS HLD_FLAG, --持仓标志
       CASE WHEN T0.C_POSITION_FLAG = '9' THEN 'S' ELSE 'L' END AS POS_ID, --多空标志 9 融券负债  a 余券
       ABS(T0.L_BEGIN_AMOUNT) AS BGNG_VOL, --期初数量
       ABS(T0.L_CURRENT_AMOUNT) AS CURR_VOL, --当前数量
       ROUND(T0.EN_UNTRANSFERED_INVEST + T0.EN_BUY_BALANCE + T0.EN_BUY_FEE -
                T0.L_SALE_AMOUNT * (T0.EN_BUY_BALANCE + T0.EN_BUY_FEE + T0.EN_UNTRANSFERED_INVEST) /
                (T0.L_CURRENT_AMOUNT + T0.L_SALE_AMOUNT),
                2) AS CURR_COST, --当前成本
       ABS(T0.L_FROZEN_AMOUNT) AS FRZ_VOL, --冻结数量
       ABS(T0.L_UNFROZEN_AMOUNT) AS UNFZ_VOL, --解冻数量
       0 AS LMT_STK_VOL, --受限股数量
       0 AS CURR_DIVD, --当日红利
       0 AS CURR_PLAC, --当日配股
       ABS(T0.L_BUY_AMOUNT) AS CURR_BUY_VOL, --当日买入数量
       ABS(T0.L_SALE_AMOUNT) AS CURR_SELL_VOL, --当日卖出数量
       T0.EN_BUY_BALANCE  AS CURR_BUY_VAL, --当日买入金额（本币）
       T0.EN_SALE_BALANCE AS CURR_SELL_VAL, --当日卖出金额（本币）
       T0.EN_BUY_FEE AS CURR_BUY_FEE, --当日买入费用（本币）
       T0.EN_SALE_FEE AS CURR_SELL_FEE, --当日卖出费用（本币）
       NULL AS CURR_VAL, --当前市值
	   0 AS QUOT_PRC, --行情价格
	   0 as ACCR_INTR,--应计利息
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'ast_unit_secu_bal_his_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISSUBJECTSTOCK T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T5.C_ASSET_CLASS IN ('2')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
       (T0.L_CURRENT_AMOUNT <> 0))
   AND T0.p_dt between ${beg_date} and ${end_date}

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
         WHEN T0.C_POSITION_FLAG = '1' AND T6.L_UNCIRCULATED_AMOUNT > 0 THEN
          '9'
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
       END AS CURR_BUY_FEE,    --当日买入费用（本币）
       CASE WHEN nvl(T0.EN_REAL_SALE_FEE,0) = 0 THEN
         T0.EN_SALE_FEE
       ELSE
         T0.EN_REAL_SALE_FEE
       END AS CURR_SELL_FEE,   --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
	 0 AS QUOT_PRC, --行情价格
	 0 as ACCR_INTR,--应计利息
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_4' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T0.p_dt = T5.p_dt
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.p_dt between ${beg_date} and ${end_date}
       LEFT JOIN (SELECT NVL(B.VC_VALUE, 0) AS VC_VALUE
                    FROM ${ods_db}.O3_TSYSPARAMETER B
                   WHERE B.L_SERIAL_NO = '60533') T4
         ON 1 = 1
       LEFT JOIN ${ods_db}.O3_THISSPECSTOCK T6
         ON T0.p_dt = T6.p_dt
                AND T0.L_UNIT_ID = T6.L_UNIT_ID
                AND T6.p_dt between ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('3')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      T0.L_CURRENT_AMOUNT <> 0)
   AND ((T4.VC_VALUE = 0 AND T0.C_POSITION_FLAG IN ('1', '5', '6')) OR
      (T4.VC_VALUE = 1 AND T0.C_POSITION_FLAG IN ('1')))
   AND T0.VC_INTER_CODE NOT IN ('131990SZ', '888880SS')
   AND T0.p_dt between ${beg_date} and ${end_date}

 UNION ALL
--基金持仓
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
0 AS QUOT_PRC, --行情价格
0 as ACCR_INTR,--应计利息
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
       END AS CURR_BUY_FEE,    --当日买入费用（本币）
       CASE WHEN nvl(T0.EN_REAL_SALE_FEE,0) = 0 THEN
         T0.EN_SALE_FEE
       ELSE
         T0.EN_REAL_SALE_FEE
       END AS CURR_SELL_FEE,   --当日卖出费用（本币）
     NULL AS CURR_VAL, --当前市值
	 0 AS QUOT_PRC, --行情价格
	 0 as ACCR_INTR,--应计利息
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_5' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T0.p_dt = T5.p_dt
        AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
        AND T5.p_dt between ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('4')
   AND T0.C_POSITION_FLAG = '1'
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
      T0.L_CURRENT_AMOUNT <> 0)
   AND T0.p_dt between ${beg_date} and ${end_date}
   
union all

SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     T0.L_DATE AS HLD_DT, --持仓日期
     CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '6' THEN 'NONE' END) AS SECU_ID, --证券编码
     CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2' WHEN T0.C_INVEST_TYPE = '2' THEN '1' ELSE T0.C_INVEST_TYPE END AS IVSM_TYPE, --投资类型
     '1' AS HLD_FLAG, --持仓标志
     'L' AS POS_ID, --多空标志
     0 AS BGNG_VOL, --期初数量
     T0.L_BUSIN_AMOUNT AS CURR_VOL, --当前数量
     T0.L_BUSIN_AMOUNT * T5.en_last_price AS CURR_COST, --当前成本
     0 AS FRZ_VOL, --冻结数量
     0 AS UNFZ_VOL, --解冻数量
     0 AS LMT_STK_VOL, --受限股数量
     0 AS CURR_DIVD, --当日红利
     0 AS CURR_PLAC, --当日配股
     0 AS CURR_BUY_VOL, --当日买入数量
     0 AS CURR_SELL_VOL, --当日卖出数量
     0 AS CURR_BUY_VAL, --当日买入金额（本币）
     0 AS CURR_SELL_VAL, --当日卖出金额（本币）
     0 AS CURR_BUY_FEE,    --当日买入费用（本币）
     0 AS CURR_SELL_FEE,   --当日卖出费用（本币）
     0 AS CURR_VAL, --当前市值
	 0 AS QUOT_PRC, --行情价格
	 0 as ACCR_INTR,--应计利息
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_5' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM V_FUND_ZTG T0
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
         ON T0.L_DATE = T5.p_dt
        AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
        AND T5.p_dt between ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('4')
) T
GROUP BY PRD_CODE, AST_UNIT_CODE, PFL_CODE, SH_CODE, SEAT_CODE, HLD_DT, SECU_ID, IVSM_TYPE, HLD_FLAG, POS_ID
   
UNION ALL
--期货品种：期货合约20230515
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
       T4.CB * T6.L_MULTIPLE AS CURR_COST, --当前成本
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
       T0.L_CURRENT_AMOUNT * T6.EN_PRICE * T6.L_MULTIPLE AS CURR_VAL, --当前市值
	   T6.EN_PRICE AS QUOT_PRC, --行情价格
	   0 as ACCR_INTR,--应计利息
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'ast_unit_secu_bal_his_6' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
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
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.L_DATE between  ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISFUTURESINFO T6
    ON T0.p_dt = T6.p_dt
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.L_DATE between  ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('9')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
       T0.L_CURRENT_AMOUNT <> 0)
   AND T0.p_dt between ${beg_date} and ${end_date}

UNION ALL
--期货品种：期货冲抵合约20230515
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       T0.L_DATE AS HLD_DT, --持仓日期
       CONCAT('CXXJ.CASH.' ,
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
       sum(T0.L_BEGIN_AMOUNT) AS BGNG_VOL, --期初数量
       sum(T0.L_CURRENT_AMOUNT) AS CURR_VOL, --当前数量
       sum(T4.CB * T6.L_MULTIPLE) AS CURR_COST, --当前成本
       0 AS FRZ_VOL, --冻结数量
       0 AS UNFZ_VOL, --解冻数量
       0 AS LMT_STK_VOL, --受限股数量
       0 AS CURR_DIVD, --当日红利
       0 AS CURR_PLAC, --当日配股
       sum(T0.L_BUY_AMOUNT) AS CURR_BUY_VOL, --当日买入数量
       sum(T0.L_SALE_AMOUNT) AS CURR_SELL_VOL, --当日卖出数量
       sum(T0.EN_BUY_BALANCE) AS CURR_BUY_VAL, --当日买入金额（本币）
       sum(T0.EN_SALE_BALANCE) AS CURR_SELL_VAL, --当日卖出金额（本币）
       sum(T0.EN_BUY_FEE) AS CURR_BUY_FEE, --当日买入费用（本币）
       sum(T0.EN_SALE_FEE) AS CURR_SELL_FEE, --当日卖出费用（本币）
       sum(T4.CB * T6.L_MULTIPLE) AS CURR_VAL, --当前市值
	   sum(T4.CB / T0.L_CURRENT_AMOUNT) AS QUOT_PRC, --行情价格
	   0 as ACCR_INTR,--应计利息
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'ast_unit_secu_bal_his_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
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
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.L_DATE between  ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISFUTURESINFO T6
    ON T0.p_dt = T6.p_dt
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.L_DATE between  ${beg_date} and ${end_date}
 WHERE T5.C_ASSET_CLASS IN ('9')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
       T0.L_CURRENT_AMOUNT <> 0)
   AND T0.p_dt between ${beg_date} and ${end_date}
group by  T1.VC_FUND_CODE,
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO),
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) ,
       T0.VC_STOCKHOLDER_ID ,
       T0.VC_BIND_SEAT,
       T0.L_DATE ,
       CONCAT('CXXJ.CASH.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
                 WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
                 WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
                 WHEN T5.C_MARKET_NO = '9' THEN 'DCE'
            END) ,
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
          END ,
       '1' ,
       CASE WHEN T0.C_POSITION_FLAG = '1' THEN 'L' WHEN T0.C_POSITION_FLAG = '2' THEN 'S' END 

UNION ALL
--期货品种：期货清算款20230515
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       T0.L_DATE AS HLD_DT, --持仓日期
       CONCAT('ZQQSK.CASH.' ,
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
       0 AS BGNG_VOL, --期初数量
       0 AS CURR_VOL, --当前数量
       0 AS CURR_COST, --当前成本
       0 AS FRZ_VOL, --冻结数量
       0 AS UNFZ_VOL, --解冻数量
       0 AS LMT_STK_VOL, --受限股数量
       0 AS CURR_DIVD, --当日红利
       0 AS CURR_PLAC, --当日配股
       sum(T0.L_BUY_AMOUNT) AS CURR_BUY_VOL, --当日买入数量
       sum(T0.L_SALE_AMOUNT) AS CURR_SELL_VOL, --当日卖出数量
       sum(T0.EN_BUY_BALANCE) AS CURR_BUY_VAL, --当日买入金额（本币）
       sum(T0.EN_SALE_BALANCE) AS CURR_SELL_VAL, --当日卖出金额（本币）
       sum(T0.EN_BUY_FEE) AS CURR_BUY_FEE, --当日买入费用（本币）
       sum(T0.EN_SALE_FEE) AS CURR_SELL_FEE, --当日卖出费用（本币）
       sum((T4.CB - T0.L_CURRENT_AMOUNT * T6.EN_PRICE) * T6.L_MULTIPLE) AS CURR_VAL, --当前市值
	   0 AS QUOT_PRC, --行情价格
	   0 as ACCR_INTR,--应计利息
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'ast_unit_secu_bal_his_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISUNITSTOCK T0
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
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.L_DATE between  ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISFUTURESINFO T6
    ON T0.p_dt = T6.p_dt
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
 WHERE T5.C_ASSET_CLASS IN ('9')
   AND ((T0.L_BUY_AMOUNT + T0.L_SALE_AMOUNT) <> 0 OR
       T0.L_CURRENT_AMOUNT <> 0)
   AND T0.p_dt between ${beg_date} and ${end_date}
group by T1.VC_FUND_CODE ,
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO),
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) ,
       T0.VC_STOCKHOLDER_ID ,
       T0.VC_BIND_SEAT ,
       T0.L_DATE ,
       CONCAT('ZQQSK.CASH.' ,
            CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                 WHEN T5.C_MARKET_NO = '7' THEN 'CFFEX'
                 WHEN T5.C_MARKET_NO = '3' THEN 'SHFE'
                 WHEN T5.C_MARKET_NO = '4' THEN 'CZCE'
                 WHEN T5.C_MARKET_NO = '9' THEN 'DCE'
            END) ,
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
          END,
       '1' ,
       CASE WHEN T0.C_POSITION_FLAG = '1' THEN 'L' WHEN T0.C_POSITION_FLAG = '2' THEN 'S' END 

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
               CASE WHEN T0.C_ENTRUST_DIRECTION IN ('5','15') THEN T0.EN_DEAL_BALANCE - T0.EN_FEE ELSE T0.EN_DEAL_BALANCE + T0.EN_FEE END
     END AS CURR_VAL, --当前市值
	 0 AS QUOT_PRC, --行情价格
	 CASE --上交所、深交所正回购
	      WHEN T0.C_ENTRUST_DIRECTION IN ('5', '15') AND T0.C_MARKET_NO IN ('1', '2') 
		  AND T4.L_DATE = T0.L_HG_DATE THEN 0
		  WHEN T0.C_ENTRUST_DIRECTION IN ('5', '15') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所正回购
	          AND W2.aft_1_dt = (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) 
			AND datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) = 1 THEN --当下一个交易日是到期交割日并且中间未间隔自然日时，利息金额0
			0
	      WHEN T0.C_ENTRUST_DIRECTION IN ('5', '15') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所正回购
	          AND W2.aft_1_dt = (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) 
			AND datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) > 1 THEN --当下一个交易日是到期交割日并且中间间隔自然日时，利息金额兜底
			ROUND(
	          ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 + T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
			, 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	
              * (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2)
			- (T0.EN_REDEEM_INTEREST + T0.EN_FEE) 
		WHEN T0.C_ENTRUST_DIRECTION IN ('5', '15') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所正回购
	          AND W2.aft_1_dt <> (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) THEN --当下一个交易日不是到期交割日时，利息直接算
			ROUND(
	          ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 + T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
		    , from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
		    , 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	  
              * (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')  
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2) 				 
		--上交所、深交所逆回购
	      WHEN T0.C_ENTRUST_DIRECTION IN ('6', '16') AND T0.C_MARKET_NO IN ('1', '2') 
		  AND T4.L_DATE = T0.L_HG_DATE THEN 0		
          WHEN T0.C_ENTRUST_DIRECTION IN ('6', '16') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所逆回购
	          AND W2.aft_1_dt = (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) AND 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) = 1 THEN --当下一个交易日是到期交割日并且中间未间隔自然时，利息金额0
	          0
          WHEN T0.C_ENTRUST_DIRECTION IN ('6', '16') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所逆回购
	          AND W2.aft_1_dt = (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) AND 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) > 1 THEN --当下一个交易日是到期交割日并且中间未间隔自然时，利息金额兜底			
			ROUND(
	          ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 - T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
			, 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	
              * (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2)
			- (T0.EN_REDEEM_INTEREST - T0.EN_FEE) 			
		WHEN T0.C_ENTRUST_DIRECTION IN ('6', '16') AND T0.C_MARKET_NO IN ('1', '2') --上交所、深交所逆回购
	          AND W2.aft_1_dt <> (CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END ) THEN --当下一个交易日不是到期交割日时，利息直接算
		    ROUND(
	          ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 - T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_REDEEM_LIQUIDATE WHEN T0.L_SETTLE_SPEED = 1 THEN W3.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
			, 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	  
              * (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd') 
			, from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2) 						 
		--银行间正回购 
          WHEN T0.C_ENTRUST_DIRECTION IN ('5', '15') AND T0.C_MARKET_NO IN ('5') THEN--银行间正回购
			ROUND(
			ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 + T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(T0.L_REDEEM_LIQUIDATE as string),'yyyyMMdd'),'yyyy-MM-dd') , from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
			, 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	  
			* (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd') , from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2) 
		--银行间逆回购
          WHEN T0.C_ENTRUST_DIRECTION IN ('6', '16') AND T0.C_MARKET_NO IN ('5') THEN--银行间逆回购
			ROUND(
			ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE / 100 / 365 - T0.EN_FEE / 
			datediff(from_unixtime(unix_timestamp(cast(T0.L_REDEEM_LIQUIDATE as string),'yyyyMMdd'),'yyyy-MM-dd') , from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'))
			, 2) --每日计提利息，其中金额中已扣费用，需要利息中加均摊(估值处理逻辑)	  
			* (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd') , from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN W1.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) + 1)
			, 2) 
     END AS ACCR_INTR, --应计利息
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_9' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
       INNER JOIN VHISHGREGISTER T0 --当前表和历史表的合集
         ON 1=1
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
         ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
	     ON T0.L_HG_DATE = W1.DT
		AND T5.C_MARKET_NO = W1.MKT_NO
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w2
	     ON T4.L_DATE = W2.DT
		AND T5.C_MARKET_NO = W2.MKT_NO	
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w3
	     ON T0.L_REDEEM_LIQUIDATE = W3.DT
		AND T5.C_MARKET_NO = W3.MKT_NO		
 WHERE T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'
   AND T4.L_DATE >= T0.L_HG_DATE
   AND ((T4.L_DATE <= T0.L_REDEEM_LIQUIDATE AND T5.C_MARKET_NO IN ('1','2')) 
   OR (T4.L_DATE < T0.L_REDEEM_LIQUIDATE AND T5.C_MARKET_NO IN ('5')))
   AND T4.L_DATE between  ${beg_date} and ${end_date}

UNION ALL
--转融券品种，20230515
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       T4.L_DATE AS HLD_DT, --持仓日期
       CONCAT(T0.VC_CONTRACT_NO , '.REFC.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END) AS SECU_ID, --证券编码
       '2' AS IVSM_TYPE, --投资类型
       '1' AS HLD_FLAG, --持仓标志
       'L' AS POS_ID, --多空标志
       CASE
         WHEN T4.L_DATE = T0.L_CLEAR_DATE THEN
          0
         ELSE
          T0.L_DEAL_AMOUNT
       END AS BGNG_VOL, --期初数量
       CASE
         WHEN T4.L_DATE = (CASE WHEN T0.C_RETURN_FLAG = '3' THEN T0.L_CLEAR_DATE_NEW ELSE T0.L_REDEEM_LIQUIDATE END) THEN
          0
         ELSE
          T0.L_DEAL_AMOUNT
       END AS CURR_VOL, --当前数量
       CASE
         WHEN T4.L_DATE = (CASE WHEN T0.C_RETURN_FLAG = '3' THEN T0.L_CLEAR_DATE_NEW ELSE T0.L_REDEEM_LIQUIDATE END) THEN
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
         WHEN T4.L_DATE = T0.L_CLEAR_DATE THEN
          T0.L_DEAL_AMOUNT
         ELSE
          0
       END AS CURR_BUY_VOL, --当日买入数量
       CASE
         WHEN T4.L_DATE = (CASE WHEN T0.C_RETURN_FLAG = '3' THEN T0.L_CLEAR_DATE_NEW ELSE T0.L_REDEEM_LIQUIDATE END) THEN
          T0.L_DEAL_AMOUNT
         ELSE
          0
       END AS CURR_SELL_VOL, --当日卖出数量
       CASE
         WHEN T4.L_DATE = T0.L_CLEAR_DATE THEN
          T0.EN_DEAL_BALANCE
         ELSE
          0
       END AS CURR_BUY_VAL, --当日买入金额（本币）
       CASE
         WHEN T4.L_DATE = (CASE WHEN T0.C_RETURN_FLAG = '3' THEN T0.L_CLEAR_DATE_NEW ELSE T0.L_REDEEM_LIQUIDATE END) THEN
          T0.EN_DEAL_BALANCE
         ELSE
          0
       END AS CURR_SELL_VAL, --当日卖出金额（本币）
       CASE
         WHEN T4.L_DATE = T0.L_CLEAR_DATE THEN
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
	  0 AS QUOT_PRC, --行情价格
	   ROUND(ROUND(T0.EN_DEAL_BALANCE * T0.EN_DEAL_PRICE  / 360,2) *
                                  (datediff(from_unixtime(unix_timestamp(cast(T4.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN T0.L_DEAL_DATE ELSE T0.L_CLEAR_DATE END as string),'yyyyMMdd'),'yyyy-MM-dd'))),2)
                                   AS ACCR_INTR, --应计利息,算尾不算头
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'ast_unit_secu_bal_his_10' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN (SELECT A.*,B.L_CLEAR_DATE AS L_CLEAR_DATE_NEW
          FROM VHISSECURITYLOAN A --当前表和历史表的合集
          LEFT JOIN VHISSECURITYLOAN B --当前表和历史表的合集
            ON A.VC_CONTRACT_NO = B.VC_ORIGINAL_DEAL_NO
           AND A.C_RETURN_FLAG = '3'
           AND B.C_ENTRUST_DIRECTION = '98') T0
    ON 1=1
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN (
   SELECT L_COMPANY_ID,VC_REPORT_CODE,VC_STOCK_NAME,VC_STOCK_FULLNAME,VC_STOCK_SPELL,C_STOCK_TYPE,C_ASSET_CLASS,C_MARKET_NO,L_DATE,VC_INTER_CODE
   FROM ${ods_db}.O3_THISSTOCKINFO
   WHERE P_DT BETWEEN DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') and DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${end_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
   UNION ALL
   SELECT L_COMPANY_ID,VC_REPORT_CODE,VC_STOCK_NAME,VC_STOCK_FULLNAME,VC_STOCK_SPELL,C_STOCK_TYPE,C_ASSET_CLASS,C_MARKET_NO,L_DATE,VC_INTER_CODE
   FROM ${ods_db}.O3_TSTOCKINFO
   ) T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'
   AND T4.L_DATE between  ${beg_date} and ${end_date}
   AND T4.L_DATE >= T0.L_CLEAR_DATE  --提前了结合约获取真实到期日
   AND T4.L_DATE < NVL(T0.L_CLEAR_DATE_NEW, T0.L_REDEEM_LIQUIDATE)