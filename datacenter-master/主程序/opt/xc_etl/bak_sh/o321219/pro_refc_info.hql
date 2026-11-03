------------------------------------------------------------------------
  -- 模块名称：转融通合约表
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

alter table ${dwd_db}.pro_refc_info drop if exists partition (sys_rs_id='O3') ;
with VTHISSECURITYLOAN as (
select
L_CLEAR_DATE,VC_ORIGINAL_DEAL_NO,C_ENTRUST_DIRECTION
from ${ods_db}.O3_THISSECURITYLOAN
union
select
L_CLEAR_DATE,VC_ORIGINAL_DEAL_NO,C_ENTRUST_DIRECTION
from ${ods_db}.O3_TSECURITYLOAN
)

insert into ${dwd_db}.pro_refc_info partition (sys_rs_id)
SELECT T0.L_DATE AS OCCU_DT, --发生日期
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,
             T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
               WHEN T0.C_INVEST_TYPE IN ('1') THEN
                '2' --交易型金融资产
               WHEN T0.C_INVEST_TYPE IN ('2') THEN
                '1' --持有到期资产
               ELSE
                T0.C_INVEST_TYPE
             END AS INV_TYP, --投资类型
             CONCAT(T0.VC_CONTRACT_NO , '.REFC.' , (CASE
               WHEN T0.C_MARKET_NO = '1' THEN
                'SH'
               WHEN T0.C_MARKET_NO = '2' THEN
                'SZ'
             END)) AS SECU_ID, --证券编码
             T0.VC_CONTRACT_NO AS SECU_CODE, --证券代码
             T0.VC_CONTRACT_NO AS CONT_ID, --合约编码
             T0.VC_DEAL_NO AS TNV_NO, --成交编号
             CASE
               WHEN T5.C_ASSET_CLASS = '2' THEN
                CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
                  WHEN T0.C_MARKET_NO = '1' THEN
                   'SH'
                  WHEN T0.C_MARKET_NO = '2' THEN
                   'SZ'
                END)) --股票
               WHEN T5.C_ASSET_CLASS = '4' THEN
                CONCAT(T5.VC_REPORT_CODE , '.FUND.' , (CASE
                  WHEN T0.C_MARKET_NO = '1' THEN
                   'SH'
                  WHEN T0.C_MARKET_NO = '2' THEN
                   'SZ'
                END)) --基金
             END AS REFC_SECU_ID, --转融通证券编码
             T5.VC_REPORT_CODE AS REFC_SECU_CODE, --转融通证券代码
             T0.C_STRATEGY_PLACING AS RES_FLAG, --限售标识
             CASE
               WHEN T0.C_CONTRACT_TYPE = 0 AND T0.C_ZRT_TYPE = 1 THEN
                '1' --转融券合约
               WHEN T0.C_CONTRACT_TYPE = 1 AND T0.C_ZRT_TYPE = 1 THEN
                '2' --权益补偿合约
               WHEN T0.C_CONTRACT_TYPE = 0 AND T0.C_ZRT_TYPE = 0 THEN
                '3' --转融资合约
             END AS REFC_CONT_CLAS, --转融通合约类型
             T0.L_CLEAR_DATE AS TNV_DT, --成交日期
             CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END AS END_DT, --到期日
             T0.L_CLEAR_DATE AS FIR_DELI_DT, --首期交割日期
             CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END AS END_DELI_DT, --到期交割日期
             T0.L_REDEEM_DAYS AS REFC_CONT_DAYS, --转融通天数
	         (unix_timestamp(cast(CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END as string),'yyyymmdd') - unix_timestamp(cast(T0.L_CLEAR_DATE as string),'yyyymmdd')) AS INTA_DAYS, --计息天数
             CAST(T0.L_DEAL_AMOUNT  AS INT)  AS CONT_VOL, --合约数量
             T0.EN_DEAL_BALANCE AS CONT_VAL, --合约金额
             T0.EN_DEAL_PRICE AS REFC_FEER, --转融通费率
             T0.EN_STOCK_PRICE AS REFC_SECU_PRC, --转融通证券价格
             T0.EN_FEE AS TRD_CHAG, --交易手续费
             (unix_timestamp(cast(CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END as string),'yyyymmdd') - unix_timestamp(cast(T0.L_CLEAR_DATE as string),'yyyymmdd')) * T0.EN_DEAL_PRICE / 360 AS REFE_INTR, --转融通利息
             T0.EN_RETURN_INTEREST AS REPY_INTR, --已偿还利息
             T0.L_RETURN_AMOUNT AS REPY_VOL, --已偿还数量
             T0.L_RETURN_DATE AS ACTL_REPY_DT, --实际偿还日期
             T0.C_RETURN_FLAG AS REFC_REPY_FLAG, --转融通偿还标志
             T0.VC_ORIGINAL_DEAL_NO AS ORIG_CONT_ID, --原合约编码
             T0.C_ENGAGED_REPORT AS APPT_REP_FLAG, --约定申报标志
             T0.L_EXTEND_TIMES AS RENL_TIMES, --展期次数
             T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
             T0.VC_ENGAGED_NO AS APPT_NUM, --约定号
             T0.VC_RIVAL_CONTRACT_NO AS CNTP_CONT_ID, --对手方合约编码
             T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
             T0.VC_RIVALtradeR_ID AS CNTP_DELR_ID, --对手方交易员
             T0.VC_RIVAL_STOCKHOLDER_ID AS CNTP_SH_CODE, --对手方股东代码
             T0.VC_RIVAL_SEAT_ID AS CNTP_SEAT_CODE, --对手方席位号
             T0.VC_SUMMARY AS MEMO, --备注
             CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN T0.L_DEAL_DATE ELSE NULL END AS ORIG_TNV_DT, --原成交日期
             ${current_date} as busi_date, --业务日期
             'pro_refc_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_THISSECURITYLOAN T0
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表
          ON T0.L_DATE = T5.L_DATE
         AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('2', '4')
         AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
        LEFT JOIN VTHISSECURITYLOAN T4 --当前表和历史表的合集,提前了结新开
          ON T0.VC_CONTRACT_NO = T4.VC_ORIGINAL_DEAL_NO
         AND T0.C_RETURN_FLAG = '3'  --原提前了结合约
         AND T4.C_ENTRUST_DIRECTION = '98'  --提前了结新开

union all

      SELECT T0.L_DATE AS OCCU_DT, --发生日期
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,
             T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
               WHEN T0.C_INVEST_TYPE IN ('1') THEN
                '2' --交易型金融资产
               WHEN T0.C_INVEST_TYPE IN ('2') THEN
                '1' --持有到期资产
               ELSE
                T0.C_INVEST_TYPE
             END AS INV_TYP, --投资类型
             CONCAT(T0.VC_CONTRACT_NO , '.REFC.' ,
             (case when T0.C_MARKET_NO =  '1' then  'SH'
              when T0.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
             T0.VC_CONTRACT_NO AS SECU_CODE, --证券代码
             T0.VC_CONTRACT_NO AS CONT_ID, --合约编码
             T0.VC_DEAL_NO AS TNV_NO, --成交编号
             CASE
               WHEN T5.C_ASSET_CLASS = '2' THEN
                CONCAT(T5.VC_REPORT_CODE , '.STK.' ,
              (case when T0.C_MARKET_NO =  '1' then  'SH'
              when T0.C_MARKET_NO = '2' then 'SZ' end)) --股票
               WHEN T5.C_ASSET_CLASS = '4' THEN
                CONCAT(T5.VC_REPORT_CODE , '.FUND.' ,
                (case when T0.C_MARKET_NO =  '1' then  'SH'
                when T0.C_MARKET_NO = '2' then 'SZ' end)) --基金
             END AS REFC_SECU_ID, --转融通证券编码
             T5.VC_REPORT_CODE AS REFC_SECU_CODE, --转融通证券代码
             T0.C_STRATEGY_PLACING AS RES_FLAG, --限售标识
             CASE
               WHEN T0.C_CONTRACT_TYPE = 0 AND T0.C_ZRT_TYPE = 1 THEN
                '1' --转融券合约
               WHEN T0.C_CONTRACT_TYPE = 1 AND T0.C_ZRT_TYPE = 1 THEN
                '2' --权益补偿合约
               WHEN T0.C_CONTRACT_TYPE = 0 AND T0.C_ZRT_TYPE = 0 THEN
                '3' --转融资合约
             END AS REFC_CONT_CLAS, --转融通合约类型
             T0.L_CLEAR_DATE AS TNV_DT, --成交日期
             CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END AS END_DT, --到期日
             T0.L_CLEAR_DATE AS FIR_DELI_DT, --首期交割日期
             CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END AS END_DELI_DT, --到期交割日期
             T0.L_REDEEM_DAYS AS REFC_CONT_DAYS, --转融通天数
	         (unix_timestamp(cast(CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END as string),'yyyymmdd') - unix_timestamp(cast(T0.L_CLEAR_DATE as string),'yyyymmdd')) AS INTA_DAYS, --计息天数
             CAST(T0.L_DEAL_AMOUNT AS INT) AS CONT_VOL, --合约数量
             T0.EN_DEAL_BALANCE AS CONT_VAL, --合约金额
             T0.EN_DEAL_PRICE AS REFC_FEER, --转融通费率
             T0.EN_STOCK_PRICE AS REFC_SECU_PRC, --转融通证券价格
             T0.EN_FEE AS TRD_CHAG, --交易手续费
             (unix_timestamp(cast(CASE WHEN T0.C_RETURN_FLAG = '3' THEN T4.L_CLEAR_DATE ELSE T0.L_REDEEM_LIQUIDATE END as string),'yyyymmdd') - unix_timestamp(cast(T0.L_CLEAR_DATE as string),'yyyymmdd')) * T0.EN_DEAL_PRICE / 360 AS REFE_INTR, --转融通利息
             T0.EN_RETURN_INTEREST AS REPY_INTR, --已偿还利息
             T0.L_RETURN_AMOUNT AS REPY_VOL, --已偿还数量
             T0.L_RETURN_DATE AS ACTL_REPY_DT, --实际偿还日期
             T0.C_RETURN_FLAG AS REFC_REPY_FLAG, --转融通偿还标志
             T0.VC_ORIGINAL_DEAL_NO AS ORIG_CONT_ID, --原合约编码
             T0.C_ENGAGED_REPORT AS APPT_REP_FLAG, --约定申报标志
             T0.L_EXTEND_TIMES AS RENL_TIMES, --展期次数
             T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
             T0.VC_ENGAGED_NO AS APPT_NUM, --约定号
             T0.VC_RIVAL_CONTRACT_NO AS CNTP_CONT_ID, --对手方合约编码
             T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
             T0.VC_RIVALtradeR_ID AS CNTP_DELR_ID, --对手方交易员
             T0.VC_RIVAL_STOCKHOLDER_ID AS CNTP_SH_CODE, --对手方股东代码
             T0.VC_RIVAL_SEAT_ID AS CNTP_SEAT_CODE, --对手方席位号
             T0.VC_SUMMARY AS MEMO, --备注
             CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN T0.L_DEAL_DATE ELSE NULL END AS ORIG_TNV_DT, --原成交日期
             ${current_date} as busi_date, --业务日期
             'pro_refc_info_2' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TSECURITYLOAN T0
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
          ON T0.L_DATE = T5.L_DATE
         AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('2', '4')
         AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
        LEFT JOIN ${ods_db}.O3_TSECURITYLOAN T4 --当前表提前了结新开
          ON T0.VC_CONTRACT_NO = T4.VC_ORIGINAL_DEAL_NO
         AND T0.C_RETURN_FLAG = '3'  --原提前了结合约
         AND T4.C_ENTRUST_DIRECTION = '98'  --提前了结新开

