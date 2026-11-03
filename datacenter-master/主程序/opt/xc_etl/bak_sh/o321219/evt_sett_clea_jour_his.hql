------------------------------------------------------------------------
--模块名称：结算类清算
--债赎回业务
--交易所债回售记录中含有利息部分
--交易所兑息
--交易所债面额兑付和数量兑付
--交易所债面额兑付和数量兑付中利息部分
--银行间兑付和面额兑付
--银行间兑息
--存款兑息
--存款兑息到账（结转）
--场内普通红股除权
--场内限售红股除权
--场内红股上市、红利除权、到账、红利再投以及场内和场外份额折算
--补充场内基金红利除权数据
--场外基金红利除权及红利再投数据（日终）
--开放式基金除权（日终）
--红利再投除权数据（实时）
--红利再投数据（实时）
--红利税补缴成交
--限售股转流通
--离线清算：非投资类业务
--离线清算：强制赎回
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

alter table ${dwd_db}.evt_sett_clea_jour_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},SYS_RS_ID='O3') ;

WITH
     VHISPENDSETTLE AS
         (SELECT L_SERIAL_NO,
                 L_ENTRUST_SERIAL_NO,
                 L_trade_DATE,
                 VC_ORIGINAL_NO,
                 C_ENTRUST_DIRECTION,
                 VC_DEAL_NO,
                 l_Relate_No,
                 VC_INTER_CODE,
                 L_BASECOMBI_ID,
                 L_SETTLE_DATE,
                 L_BUSIN_FLAG,
                 L_FUND_ID,
                 L_DATE,
                 C_STATUS,
                 VC_STOCKHOLDER_ID,
                 VC_BIND_SEAT,
                 VC_CURRENCY_NO,
                 C_INVEST_TYPE,
                 EN_ACT_SETTLE_BALANCE,
                 EN_SETTLE_BALANCE,
                 C_CASHSETTLE_FLAG,
                 C_SETTLE_FLAG
          FROM ${ods_db}.O3_THISPENDSETTLE
          WHERE C_STATUS = '1'
		  AND P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-60),'yyyyMMdd') and ${end_date}
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
                 L_SETTLE_DATE,
                 L_BUSIN_FLAG,
                 L_FUND_ID,
                 L_DATE,
                 C_STATUS,
                 VC_STOCKHOLDER_ID,
                 VC_BIND_SEAT,
                 VC_CURRENCY_NO,
                 C_INVEST_TYPE,
                 EN_ACT_SETTLE_BALANCE,
                 EN_SETTLE_BALANCE,
                 C_CASHSETTLE_FLAG,
                 C_SETTLE_FLAG
          FROM ${ods_db}.O3_TPENDSETTLE
          WHERE C_STATUS = '1'),
     VHISUNCOMPLETELOG AS
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
		  where p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-60),'yyyyMMdd') and ${end_date}
         ),
VHISOUTCONFIRM AS
         (SELECT L_DATE,
                 L_FUND_ID,
                 VC_INTER_CODE,
                 C_ENTRUST_DIRECTION,
                 C_STATUS,
                 C_BUSIN_CLASS,
                 EN_AMOUNT,
                 EN_PRICE,
                 C_INVEST_TYPE,
                 VC_SEAT_ID,
                 VC_STOCKHOLDER_ID,
                 L_BASECOMBI_ID,
                 L_CONFIRM_DATE,
                 L_CONFIRM_NO,
                 L_EXECCONFIRM_NO,
                 L_BUSIN_FLAG,
                 EN_BALANCE,
                 L_DAILY_INSTRUCTION_NO,
                 L_INDEX_DAILY_MODIFY,
                 L_STOCK_SERIAL_NO,
                 EN_FEE_RATIO,
                 C_SETTLE_TYPE,
                 C_BUSIN_PRO_TYPE,
                 C_DEAL_STATUS,
                 VC_REMARK,
                 EN_CBALANCE,
                 L_OPERATOR_NO,
                 L_RIVAL_ID,
                 L_TIME,
                 C_FEE_DEAL_TYPE,
                 L_SETTLE_DATE,
                 L_IN_COMBI_ID,
                 VC_IN_INTERCODE,
                 C_TRAN_FLAG,
                 EN_FEE,
                 VC_IN_STOCKHOLDER_ID,
                 VC_IN_SEAT_ID,
                 C_IN_INVEST_TYPE
          FROM ${ods_db}.O3_TOUTCONFIRM
          WHERE C_STATUS = '1' --正常
          UNION ALL
          SELECT L_DATE,
                 L_FUND_ID,
                 VC_INTER_CODE,
                 C_ENTRUST_DIRECTION,
                 C_STATUS,
                 C_BUSIN_CLASS,
                 EN_AMOUNT,
                 EN_PRICE,
                 C_INVEST_TYPE,
                 VC_SEAT_ID,
                 VC_STOCKHOLDER_ID,
                 L_BASECOMBI_ID,
                 L_CONFIRM_DATE,
                 L_CONFIRM_NO,
                 L_EXECCONFIRM_NO,
                 L_BUSIN_FLAG,
                 EN_BALANCE,
                 L_DAILY_INSTRUCTION_NO,
                 L_INDEX_DAILY_MODIFY,
                 L_STOCK_SERIAL_NO,
                 EN_FEE_RATIO,
                 C_SETTLE_TYPE,
                 C_BUSIN_PRO_TYPE,
                 C_DEAL_STATUS,
                 VC_REMARK,
                 EN_CBALANCE,
                 L_OPERATOR_NO,
                 L_RIVAL_ID,
                 L_TIME,
                 C_FEE_DEAL_TYPE,
                 L_SETTLE_DATE,
                 L_IN_COMBI_ID,
                 VC_IN_INTERCODE,
                 C_TRAN_FLAG,
                 EN_FEE,
                 VC_IN_STOCKHOLDER_ID,
                 VC_IN_SEAT_ID,
                 C_IN_INVEST_TYPE
          FROM ${ods_db}.O3_THISOUTCONFIRM
          WHERE C_STATUS = '1' --正常
          AND P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-60),'yyyyMMdd') and ${end_date}
         ),
V_XS AS (
SELECT
T.L_DATE,T.L_FUND_ID,T.L_BASECOMBI_ID,T.VC_STOCKHOLDER_ID,T.VC_INTER_CODE,
       sum(case when t.l_busin_flag in ('73427','41808') then T.l_busin_amount ELSE -T.l_busin_amount END) as l_busin_amount
  FROM ${ods_db}.O3_THISCURRENTS T --清算流水主表
 WHERE ((t.L_BUSIN_FLAG in ('73427','73428') and l_busin_amount<>0) or (t.L_BUSIN_FLAG IN ('41808')))
   AND t.C_STATUS = '1'
   AND T.P_DT BETWEEN ${beg_date} and ${end_date}
group by t.l_date,t.l_fund_id,t.l_basecombi_id,t.vc_stockholder_id,t.vc_inter_code
)
insert into ${dwd_db}.evt_sett_clea_jour_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,intr_val,deli_dt,intr_tran_dpsi,pnlt_val,cont_id,res_flag,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--债赎回业务
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.BOND.' , (CASE
          WHEN T5.C_MARKET_NO = '1' THEN
              'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
              'SZ'
           END)) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '270001' AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE WHEN '1' THEN '2' WHEN '2' THEN '1' WHEN 'a' THEN '15' WHEN 'b' THEN '10' WHEN 'c' THEN '12' ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '27000100' AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
       T6.EN_CURR_FACE_PRICE AS TNV_PRC, --成交价格
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_OCCUR_BALANCE - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISCURRENTS T0
    LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
     ON T0.L_FUND_ID = T1.L_FUND_ID
    LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
     ON T0.L_ASSET_ID = T2.L_ASSET_ID
    LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
     ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
    LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
     ON T0.P_DT = T5.P_DT
     AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
     AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
    LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T7
	 on T0.P_DT = T7.dt
	 AND T5.C_MARKET_NO = T7.mkt_no
	 and t7.SYS_RS_ID='O3'
    LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
     ON T7.aft_2_dt = T6.P_DT
     AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
     AND T6.P_DT BETWEEN  ${beg_date}  AND  date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),2),'yyyyMMdd')
WHERE T0.L_BUSIN_FLAG IN ('72720')
  AND T0.C_STATUS = '1'
  AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--交易所债回售记录中含有利息部分
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.BOND.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '130001' AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE WHEN '1' THEN '2' WHEN '2' THEN '1' WHEN 'a' THEN '15' WHEN 'b' THEN '10' WHEN 'c' THEN '12' ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '13000100' AS BUSI_CLAS, --业务类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72935') THEN
          T0.L_BUSIN_AMOUNT
         WHEN T0.L_BUSIN_FLAG IN ('41406') THEN
          T0.EN_OCCUR_BALANCE / (T4.EN_OCCUR_BALANCE / T4.L_DEAL_AMOUNT)
       END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72935') THEN
          (T0.EN_OCCUR_BALANCE + T0.EN_FARE5)/ T0.L_BUSIN_AMOUNT - T6.EN_CURR_FACE_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41406') THEN
          T4.EN_OCCUR_BALANCE  / T4.L_DEAL_AMOUNT - T6.EN_CURR_FACE_PRICE
       END AS TNV_PRC, --成交价格
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72935') THEN
          (T0.EN_OCCUR_BALANCE + T0.EN_FARE5) - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41406') THEN
          T0.EN_OCCUR_BALANCE -
          T6.EN_CURR_FACE_PRICE * T0.EN_OCCUR_BALANCE / (T4.EN_OCCUR_BALANCE / T4.L_DEAL_AMOUNT)
       END AS TNV_VAL, --成交金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72935') THEN
          (T0.EN_OCCUR_BALANCE + T0.EN_FARE5) - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41406') THEN
          T0.EN_OCCUR_BALANCE -
          T6.EN_CURR_FACE_PRICE * T0.EN_OCCUR_BALANCE / (T4.EN_OCCUR_BALANCE / T4.L_DEAL_AMOUNT)
       END AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72935') THEN
          (T0.EN_OCCUR_BALANCE + T0.EN_FARE5) - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41406') THEN
          T0.EN_OCCUR_BALANCE -
          T6.EN_CURR_FACE_PRICE * T0.EN_OCCUR_BALANCE / (T4.EN_OCCUR_BALANCE / T4.L_DEAL_AMOUNT)
       END AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISLIQUIDATEDETAIL T4
    ON T0.P_DT = T4.P_DT
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
   AND T0.VC_SEAT_ID = T4.VC_SEAT_ID
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND T4.L_BUSIN_FLAG IN ('41406')
   AND T4.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T7
    on T0.P_DT = T7.dt
   AND '1' = T7.mkt_no
   and t7.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T7.pre_2_dt = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
    ON T7.pre_2_dt = T6.P_DT
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd')  AND  ${end_date}
 WHERE ((T0.L_BUSIN_FLAG IN ('72935') AND
       T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT > T6.EN_CURR_FACE_PRICE)
    OR (T0.L_BUSIN_FLAG IN ('41406') AND T5.C_MARKET_NO = '2' AND
       T4.EN_OCCUR_BALANCE / T4.L_DEAL_AMOUNT > T6.EN_CURR_FACE_PRICE))
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--交易所兑息
SELECT
       T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.BOND.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
                     T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
                            T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '130001' AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE
       WHEN '1' THEN '2'
       WHEN '2' THEN '1'
       WHEN 'a' THEN '15'
       WHEN 'b' THEN '10'
       WHEN 'c' THEN '12'
	   ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '13000100' AS BUSI_CLAS, --业务类型
       CASE WHEN T0.VC_SUMMARY NOT LIKE '%持仓%' AND T0.VC_SUMMARY NOT LIKE '%数量%' THEN 0
         ELSE
         CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                                      '(持仓\\[|数量\\[)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '持仓\\[|数量\\[',
                                        '') AS DECIMAL(20, 4))
       END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE WHEN T0.VC_SUMMARY NOT LIKE '%持仓%' AND T0.VC_SUMMARY NOT LIKE '%数量%' THEN 0
         ELSE
          ROUND(T0.EN_OCCUR_BALANCE / CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                                      '(持仓\\[|数量\\[)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '持仓\\[|数量\\[',
                                        '') AS DECIMAL(20, 4)),4)
       END AS TNV_PRC, --成交价格
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_OCCUR_BALANCE AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
   LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T8
    ON T0.L_TRADE_DATE = T8.dt
    AND T5.C_MARKET_NO = T8.mkt_no
	and t8.SYS_RS_ID='O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
    ON T8.pre_2_dt = T6.P_DT
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd')  AND  ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41702')
   AND T5.C_ASSET_CLASS NOT IN ('4')  --剔除基金
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--交易所债面额兑付和数量兑付
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.BOND.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '150001' AS BUSI_TYP, --业务类别
      case when T0.C_INVEST_TYPE = '1' then '2'
           when T0.C_INVEST_TYPE = '2' then '1'
           when T0.C_INVEST_TYPE = 'a' then '15'
           when T0.C_INVEST_TYPE = 'b' then '10'
           when T0.C_INVEST_TYPE = 'c' then '12'
           else T0.C_INVEST_TYPE end AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72915') THEN
          '15000100'
         WHEN T0.L_BUSIN_FLAG IN ('72830') THEN
          '15000101'
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72915') THEN
          0
         WHEN T0.L_BUSIN_FLAG IN ('72830') THEN
          T0.L_BUSIN_AMOUNT
       END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72915') THEN
          CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                                      '(减面\\[)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '减面\\[',
                                        '') AS DECIMAL(20, 4))
         WHEN T0.L_BUSIN_FLAG IN ('72830') THEN
          100
       END AS TNV_PRC, --成交价格
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72915') THEN
          T0.EN_OCCUR_BALANCE - T0.EN_SUBJECT_BALANCE
         WHEN T0.L_BUSIN_FLAG IN ('72830') THEN
          T0.EN_OCCUR_BALANCE - T0.EN_SUBJECT_BALANCE
       END AS TNV_VAL, --成交金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('72915') THEN
          T0.EN_OCCUR_BALANCE - T0.EN_SUBJECT_BALANCE
         WHEN T0.L_BUSIN_FLAG IN ('72830') THEN
          T0.EN_OCCUR_BALANCE - T0.EN_SUBJECT_BALANCE
       END AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM (
  select t1.*
  from ${ods_db}.O3_THISCURRENTS t1
  where t1.L_BUSIN_FLAG IN ('72830')
   AND t1.C_STATUS = '1'
   AND T1.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  union all
  select t1.*
  from ${ods_db}.O3_THISCURRENTS t1
  where T1.L_BUSIN_FLAG IN ('72915')
   AND T1.C_STATUS = '1'
   AND T1.EN_OCCUR_BALANCE > 0
   AND T1.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
   AND not exists (select 1
     from ${ods_db}.O3_THISLIQUIDATEDETAIL tt0
    where  tt0.L_BUSIN_FLAG = '72915'
      AND tt0.L_DEAL_AMOUNT <> 0
      AND tt0.EN_OCCUR_BALANCE / tt0.L_DEAL_AMOUNT > 100
      and t1.P_DT = TT0.P_DT
      AND t1.VC_INTER_CODE = TT0.VC_INTER_CODE
      AND t1.VC_STOCKHOLDER_ID = TT0.VC_STOCKHOLDER_ID
      AND t1.VC_SEAT_ID = TT0.VC_SEAT_ID
      AND t1.L_BUSIN_FLAG = TT0.L_BUSIN_FLAG
	  AND TT0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
	  )
  ) T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle t7
	ON T0.P_DT = T7.DT
	AND T7.mkt_no = '1'
	AND T7.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
    ON T7.pre_2_dt = T6.P_DT
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd')  AND  ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('72915','72830')
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--交易所债面额兑付和数量兑付中利息部分
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO , 'C') AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO , 'C') AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE, '.BOND.', (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '130001' AS BUSI_TYP, --业务类别
      case when T0.C_INVEST_TYPE = '1' then '2'
           when T0.C_INVEST_TYPE = '2' then '1'
           when T0.C_INVEST_TYPE = 'a' then '15'
           when T0.C_INVEST_TYPE = 'b' then '10'
           when T0.C_INVEST_TYPE = 'c' then '12'
           else T0.C_INVEST_TYPE end AS INV_TYP, --投资类型
       '13000100' AS BUSI_CLAS, --业务类型
       CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                         '(持仓\\[)([0-9]+([.]{1}[0-9]+){0,1})',0),
                           '持仓\\[',
                           '') AS DECIMAL(20, 4))  AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE
         WHEN T0.VC_SUMMARY NOT LIKE '%持仓%' AND
              T0.VC_SUMMARY NOT LIKE '%数量%' THEN
          0
         ELSE
          ROUND(T0.EN_SUBJECT_BALANCE /
                CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                                  '(持仓\\[)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                    '持仓\\[',
                                    '') AS DECIMAL(20, 4)),
                4)
       END AS TNV_PRC, --成交价格
       T0.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
       T0.EN_SUBJECT_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_SUBJECT_BALANCE AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
              'evt_sett_clea_jour_his_5' AS TASK_RS_ID, --任务来源标识
              CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM (
  select t1.*
  from ${ods_db}.O3_THISCURRENTS t1
  where t1.L_BUSIN_FLAG IN ('72830')
   AND t1.C_STATUS = '1'
   AND T1.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  union all
  select t1.*
  from ${ods_db}.O3_THISCURRENTS t1
  where T1.L_BUSIN_FLAG IN ('72915')
   AND T1.C_STATUS = '1'
   AND T1.EN_OCCUR_BALANCE > 0
   AND T1.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
   AND not exists (select 1
     from ${ods_db}.O3_THISLIQUIDATEDETAIL tt0
    where  tt0.L_BUSIN_FLAG = '72915'
      AND tt0.L_DEAL_AMOUNT <> 0
      AND tt0.EN_OCCUR_BALANCE / tt0.L_DEAL_AMOUNT > 100
      and t1.P_DT = TT0.P_DT
      AND t1.VC_INTER_CODE = TT0.VC_INTER_CODE
      AND t1.VC_STOCKHOLDER_ID = TT0.VC_STOCKHOLDER_ID
      AND t1.VC_SEAT_ID = TT0.VC_SEAT_ID
      AND t1.L_BUSIN_FLAG = TT0.L_BUSIN_FLAG
	  AND tt0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
	  )
  ) T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle t7
	ON T0.P_DT = T7.DT
	AND T7.mkt_no = '1'
	AND T7.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
    ON T7.pre_2_dt = T6.P_DT
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd')  AND  ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('72915','72830')
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--银行间兑付和面额兑付
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_J' , T0.L_BUSIN_NO)
	        WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
	   END AS TRD_SRC_ID, --交易源ID
       CASE WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN concat(T0.L_DATE , '_HSO32' , '_J' , T0.L_BUSIN_NO)
	        WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
	   END AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , '.BOND.' ,
       (CASE
             WHEN T5.C_MARKET_NO = '1' THEN
                 'SH'
             WHEN T5.C_MARKET_NO = '2' THEN
                 'SZ'
             WHEN T5.C_MARKET_NO = '5' THEN
                 'YHJ'
                 END)) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               '140002'
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               '150002'
           END AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE WHEN '1' THEN '2'
            WHEN '2' THEN '1'
            WHEN 'a'  THEN '15'
            WHEN 'b' THEN  '10'
            WHEN 'c' THEN '12'
		ELSE T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               '14000200'
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               '15000200'
           END AS BUSI_CLAS, --业务类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               T0.L_BUSIN_AMOUNT
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               0
           END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND VC_BUSIN_OPFLAG = '411' THEN
			   T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT
		   WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               T0.EN_ENTRUST_PRICE
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               T0.EN_ENTRUST_PRICE
           END AS TNV_PRC, --成交价格
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND VC_BUSIN_OPFLAG = '411' THEN
			   T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               T0.EN_DEAL_BALANCE
           END AS TNV_VAL, --成交金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND VC_BUSIN_OPFLAG = '411' THEN
			   T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41707') THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               T0.EN_DEAL_BALANCE
           END AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND T0.VC_BUSIN_OPFLAG = '411' AND T0.EN_DEAL_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE <=0 THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND T0.VC_BUSIN_OPFLAG = '411' AND T0.EN_DEAL_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE >0 THEN
                   T0.EN_OCCUR_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND T0.EN_DEAL_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE <=0 THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('41707') AND T0.EN_DEAL_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE >0 THEN
                   T0.EN_SUBJECT_BALANCE -T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE
           WHEN T0.L_BUSIN_FLAG IN ('72573') THEN
               0
           END AS INTR_VAL, --利息金额
       CASE WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN T4.L_SETTLE_DATE
	        WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN T0.L_DATE
	   END AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_6' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISCURRENTS T0
  LEFT JOIN VHISPENDSETTLE T4
    ON T0.P_DT = T4.L_TRADE_DATE
   AND T0.L_BUSIN_NO = T4.VC_ORIGINAL_NO
   AND T4.L_BUSIN_FLAG IN ('41707','72573')
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.L_DATE BETWEEN ${beg_date} AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
            ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
            ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
            ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
            ON T0.P_DT = T5.P_DT
            AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
            AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T8
             ON T0.P_DT = T8.dt
             AND T5.C_MARKET_NO = T8.mkt_no
			    and t8.SYS_RS_ID='O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
             ON T8.pre_2_dt = T6.L_DATE
             AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
			 AND T6.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
WHERE T0.L_BUSIN_FLAG IN ('41707','72573')
  AND T0.C_STATUS = '1'
  AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--银行间兑息
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN
		CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_J', T0.L_BUSIN_NO)
		    WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN
		CONCAT('0|0|0|', T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO)
	   END AS TRD_SRC_ID, --交易源ID
       CASE WHEN T0.l_subject_no = 1221 THEN
	    CONCAT(T0.L_DATE, '_HSO32', '_J', T0.L_BUSIN_NO, 'C')
	        WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN
		CONCAT(T0.L_DATE, '_HSO32', '_J', T0.L_BUSIN_NO)
		    WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN
		CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO)
	   END AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE, '.BOND.',
              (CASE
                   WHEN T5.C_MARKET_NO = '1' THEN
                       'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN
                       'SZ'
                   WHEN T5.C_MARKET_NO = '5' THEN
                       'YHJ'
               END)
       ) AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '130002' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '13000200' AS BUSI_CLAS, --业务类型
       CASE WHEN T0.VC_BUSIN_OPFLAG = '412' THEN
			T0.L_BUSIN_AMOUNT
            ELSE
			CASE WHEN T0.L_BUSIN_AMOUNT = 0 THEN T0.EN_DEAL_BALANCE / T0.EN_ENTRUST_PRICE ELSE T0.L_BUSIN_AMOUNT END
       END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE WHEN T0.VC_BUSIN_OPFLAG = '412' THEN T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT ELSE T0.EN_ENTRUST_PRICE END AS TNV_PRC, --成交价格
       CASE WHEN T0.VC_BUSIN_OPFLAG = '412' THEN T0.EN_OCCUR_BALANCE ELSE T0.EN_SUBJECT_BALANCE END AS TNV_VAL, --成交金额
       CASE WHEN T0.VC_BUSIN_OPFLAG = '412' THEN T0.EN_OCCUR_BALANCE ELSE T0.EN_SUBJECT_BALANCE END AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       CASE WHEN T0.VC_BUSIN_OPFLAG = '412' THEN T0.EN_OCCUR_BALANCE ELSE T0.EN_SUBJECT_BALANCE END AS INTR_VAL, --利息金额
       CASE WHEN NVL(T0.L_BUSIN_NO,0) <> 0 THEN
		T4.L_SETTLE_DATE
		    WHEN NVL(T0.L_BUSIN_NO,0) = 0 THEN
		T0.L_DATE
	   END AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0
       LEFT JOIN VHISPENDSETTLE T4
              ON T0.P_DT = T4.L_TRADE_DATE
             AND T0.L_BUSIN_NO = T4.VC_ORIGINAL_NO
			 AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
			 AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选交易所市场
              ON T0.P_DT = T5.P_DT
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41708')
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--存款兑息
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_D' , T0.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_D' , T0.L_BUSIN_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T0.L_BUSIN_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END) , '.DPSI.NONE') --存款付息取成交时的成交确认号
       AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       CONCAT(T0.L_BUSIN_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END)) --存款付息取成交时的成交确认号
       AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '160003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '16000303' AS BUSI_CLAS, --业务类型
       T4.EN_BALANCE AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       NULL AS TNV_PRC, --成交价格
       T0.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
       T0.EN_SUBJECT_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_SUBJECT_BALANCE AS INTR_VAL, --利息金额
       T8.L_SETTLE_DATE AS DELI_DT, --交割日期
       T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
       0 AS PNLT_VAL, --存款罚息金额
       CONCAT(T7.L_DATE , '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表,4笔发生金额为0
  INNER JOIN VHISPENDSETTLE T8
    ON T0.P_DT = T8.L_TRADE_DATE
   AND T0.L_BUSIN_NO = T8.VC_ORIGINAL_NO
   AND T0.L_BASECOMBI_ID = T8.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
   AND T8.L_DATE BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN VHISOUTCONFIRM T4 --当前表和历史表的合集，获取成交执行序号
    ON T0.P_DT = T4.L_CONFIRM_DATE
   AND T0.L_BUSIN_NO2 = T4.L_CONFIRM_NO
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('8') --存款
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
    ON T0.L_BUSIN_NO = CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0'))
 WHERE T0.C_BUSIN_CLASS IN ('B') -- B：存款
   AND T0.L_BUSIN_FLAG IN ('40222') --40222存款付息
   AND T0.EN_SUBJECT_BALANCE <> 0
   AND T0.C_STATUS IN ('1', '2') --1-正常，2-被回溯，3-回溯；
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--存款兑息到账（结转）
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_D' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CONCAT(T0.VC_ORIGINAL_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END) , '.DPSI.NONE') --存款付息取成交时的成交确认号
       AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       CONCAT(T0.VC_ORIGINAL_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
       (CASE
         WHEN T5.VC_REPORT_CODE = '890890' THEN
          'DPSI103'
         WHEN T5.VC_REPORT_CODE = '870870' THEN
          'DPSI102'
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          'DPSI104'
         WHEN T5.VC_REPORT_CODE = '880880' THEN
          'DPSI108'
       END)) --存款付息取成交时的成交确认号
       AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '160003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '16000308' AS BUSI_CLAS, --业务类型
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       NULL AS TNV_PRC, --成交价格
       T0.EN_SETTLE_BALANCE AS TNV_VAL, --成交金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
       T0.EN_SETTLE_BALANCE - CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE ELSE T0.EN_ACT_SETTLE_BALANCE END AS PNLT_VAL, --存款罚息金额
       CONCAT(T7.L_DATE , '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_9' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
    ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
    ON T0.VC_ORIGINAL_NO = CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0'))
 WHERE T0.L_BUSIN_FLAG IN ('40222')
   AND T0.C_CASHSETTLE_FLAG IN ('2','4') AND NVL(T0.C_SETTLE_FLAG,0) <> '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T7.C_INTEREST_DEPOSIT = '1'
   --注意：筛选条件需要关联成交数据，识别成交接口中利息转存字段为1：是，利息结转类；
   AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场内普通红股除权
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'SB' ELSE 'BJ' END
         WHEN T5.C_MARKET_NO = 'r' THEN
          'SB'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
         WHEN T5.C_MARKET_NO = '6' THEN
          'NONE'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'SB' ELSE 'BJ' END
         WHEN T5.C_MARKET_NO = 'r' THEN
          'SB'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '100001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41801') THEN
          '10000100' --红股除权（交易所）
       END AS BUSI_CLAS, --业务类型
       ROUND(CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN T0.L_BUSIN_AMOUNT
                  ELSE T0.L_BUSIN_AMOUNT * (NVL(T4.L_CURRENT_AMOUNT, 0) - NVL(T4.L_RESTRICTED_AMOUNT, 0)) / NVL(T4.L_CURRENT_AMOUNT, 0) END, 2) AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       '0' AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_10' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.P_DT = W1.dt
   AND T5.C_MARKET_NO = W1.mkt_no
   AND W1.sys_rs_id = 'O3'
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON W1.pre_1_dt = T4.P_DT
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
   AND T0.VC_SEAT_ID = T4.VC_BIND_SEAT
   AND T4.C_POSITION_FLAG NOT IN ('8')
   AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41801')
      --41801红股除权
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场内限售红股除权
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO , 'C') AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO, 'C') AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'SB' ELSE 'BJ' END
         WHEN T5.C_MARKET_NO = 'r' THEN
          'SB'
       END)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
         WHEN T5.C_MARKET_NO = '6' THEN
          'NONE'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'SB' ELSE 'BJ' END
         WHEN T5.C_MARKET_NO = 'r' THEN
          'SB'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '100001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
            ELSE T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41801') THEN
          '10000100' --红股除权（交易所）
       END AS BUSI_CLAS, --业务类型
       CASE WHEN PMOD(CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN 0
                          ELSE T0.L_BUSIN_AMOUNT * NVL(T4.L_RESTRICTED_AMOUNT, 0) / NVL(T4.L_CURRENT_AMOUNT, 0) END, 1) = 0.5 THEN
                 ROUND(CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN 0
                            ELSE T0.L_BUSIN_AMOUNT * NVL(T4.L_RESTRICTED_AMOUNT, 0) / NVL(T4.L_CURRENT_AMOUNT, 0) END, 2) - 1
            ELSE
                 ROUND(CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN 0
                            ELSE T0.L_BUSIN_AMOUNT * NVL(T4.L_RESTRICTED_AMOUNT, 0) / NVL(T4.L_CURRENT_AMOUNT, 0) END, 2)
       END AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       '1' AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_11' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.P_DT = W1.dt
   AND T5.C_MARKET_NO = W1.mkt_no
   AND W1.sys_rs_id = 'O3'
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON W1.pre_1_dt = T4.P_DT
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
   AND T0.VC_SEAT_ID = T4.VC_BIND_SEAT
   AND T4.C_POSITION_FLAG NOT IN ('8')
   AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41801')
   AND CASE WHEN NVL(T4.L_CURRENT_AMOUNT, 0) = 0 THEN 0 ELSE T0.L_BUSIN_AMOUNT * NVL(T4.L_RESTRICTED_AMOUNT, 0) / NVL(T4.L_CURRENT_AMOUNT, 0) END <> 0
      --41801红股除权
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--场内红股上市、红利除权、到账、红利再投以及场内和场外份额折算
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '2' THEN
                   concat(T5.VC_REPORT_CODE , '.STK.' ,
                   (CASE
                     WHEN T5.C_MARKET_NO = '1' THEN
                         'SH'
                     WHEN T5.C_MARKET_NO = '2' THEN
                         'SZ'
                     WHEN T5.C_MARKET_NO = 'n' THEN
                         'SHSC'
                     WHEN T5.C_MARKET_NO = 'o' THEN
                         'SZSC'
                     WHEN T5.C_MARKET_NO = 'j' THEN
                         CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'SB' ELSE 'BJ' END
                     WHEN T5.C_MARKET_NO = 'r' THEN
                         'SB'
                    END)) --股票
           WHEN T5.C_ASSET_CLASS = '3' THEN
                   concat(T5.VC_REPORT_CODE , '.BOND.' ,
                   (CASE
                     WHEN T5.C_MARKET_NO = '1' THEN
                         'SH'
                     WHEN T5.C_MARKET_NO = '2' THEN
                         'SZ'
                     WHEN T5.C_MARKET_NO = '5' THEN
                        'YHJ'
                   END)) --债券
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                      WHEN T5.C_MARKET_NO = '1' THEN
                          'SH'
                      WHEN T5.C_MARKET_NO = '2' THEN
                          'SZ'
                      WHEN T5.C_MARKET_NO = '6' THEN
                          'NONE'
                   END)) --基金
           WHEN T5.C_STOCK_TYPE IN ('15', '1') AND T5.C_ASSET_CLASS = '7' THEN
                   concat(T5.VC_REPORT_CODE , '.WRNT.' ,
                   (CASE
                      WHEN T5.C_MARKET_NO = 'n' THEN
                          'SHSC'
                      WHEN T5.C_MARKET_NO = 'o' THEN
                          'SZSC'
                   END)) --权证
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           WHEN T5.C_MARKET_NO = 'j' THEN
               CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'SB' ELSE 'BJ' END
           WHEN T5.C_MARKET_NO = 'r' THEN
               'SB'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41801', '41802') AND T5.C_ASSET_CLASS = '2' THEN
               '100001' --红股（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4' THEN
               '120001' --红利再投（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41703', '41704', '41702', '73204') THEN
               '110001' --红利（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('72575', '73375', '73376') THEN
               '120001' --红利再投（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('40933', '40934') AND
                T5.C_MARKET_NO IN ('1', '2') THEN
               '180001' --份额折算 (交易所)
           WHEN T0.L_BUSIN_FLAG IN ('40933', '40934') AND
                T5.C_MARKET_NO IN ('6') THEN
               '180003' --份额折算 (场外)
           END AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE
           WHEN '1' THEN '2'
           WHEN '2' THEN '1'
           WHEN 'a' THEN '15'
           WHEN 'b' THEN '10'
           WHEN 'c' THEN '12'
        ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41801') THEN
               '10000100' --红股除权（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '2' THEN
               '10000101' --红股上市（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4' THEN
               '12000100' --红利再投（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               '11000100' --红利除权（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('41704', '41702', '73204') THEN
               '11000101' --红利到账（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('72575', '73375') THEN
               '12000100' --红利再投（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('73376') THEN
               '12000101' --红利再投零碎股份额现金（交易所）
           WHEN T0.L_BUSIN_FLAG IN ('40933', '73152') AND T5.C_MARKET_NO IN ('1', '2') THEN
               '18000100' --份额调整(交易所)
           WHEN T0.L_BUSIN_FLAG IN ('40934', '73154') AND T5.C_MARKET_NO IN ('1', '2') THEN
               '18000101' --份额调调减(交易所)
           WHEN T0.L_BUSIN_FLAG IN ('40933', '73152') AND T5.C_MARKET_NO IN ('6') THEN
               '18000300' --份额调增 (场外)
           WHEN T0.L_BUSIN_FLAG IN ('40934', '73154') AND T5.C_MARKET_NO IN ('6') THEN
               '18000301' --份额调减 (场外)
           END AS BUSI_CLAS, --业务类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN
                ('41801', '41802', '72575', '40933', '73152', '40934', '73154', '73375') --红股除权、红股上市、红利再投、份额调增、调减 使用成交数量
               THEN
               T0.L_BUSIN_AMOUNT
           WHEN T0.L_BUSIN_FLAG IN ('41703', '41704', '73376', '41702', '73204') --红利除权、红利到账 无数量
               THEN
               0
           END AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4' THEN--红利再投
               T0.EN_ENTRUST_PRICE
           WHEN T0.L_BUSIN_FLAG IN
                ('41801', '41802', '41703', '41704', '40933', '73152', '40934', '73154', '73376', '41702', '73204') --红股除权、红股上市、红利除权、红利到账、份额调增、调减 无成交价格
               THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('72575', '73375') AND
                T0.EN_ENTRUST_PRICE = 0 THEN --红利再投当价格为0时，默认为1
               1
           WHEN T0.L_BUSIN_FLAG IN ('72575', '73375') --红利再投当价格不为0时，使用成交价格
               THEN
               T0.EN_ENTRUST_PRICE
           END AS TNV_PRC, --成交价格
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4' THEN--红利再投
                   T0.L_BUSIN_AMOUNT *
                   (CASE T0.EN_ENTRUST_PRICE WHEN '0' THEN '1' ELSE T0.EN_ENTRUST_PRICE END)
           WHEN T0.L_BUSIN_FLAG IN ('41801', '41802', '40933', '40934') ----红股除权、红股上市、份额调增、调减 无成交金额
               THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('41703', '73375') --红利除权 使用科目余额
               THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41704', '73376', '41702', '73204') --红利到账使用发生金额
               THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72575') THEN --红利再投金额使用成交数量*成交价格（价格为0默认1）
                   T0.L_BUSIN_AMOUNT *
                   (CASE T0.EN_ENTRUST_PRICE WHEN '0' THEN '1' ELSE T0.EN_ENTRUST_PRICE END)
           END AS TNV_VAL, --成交金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4' THEN--红利再投
                   T0.L_BUSIN_AMOUNT *
                   (CASE T0.EN_ENTRUST_PRICE WHEN '0' THEN '1' ELSE T0.EN_ENTRUST_PRICE END)
           WHEN T0.L_BUSIN_FLAG IN ('41801', '41802', '40933', '73152', '40934', '73154') ----红股除权、红股上市、份额调增、调减 无成交金额
               THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('41703', '73375') --红利除权 使用科目余额
               THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('41704', '73376', '41702', '73204') --红利到账使用发生金额
               THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72575') THEN --红利再投金额使用成交数量*成交价格（价格为0默认1）
               NVL(T8.EN_OCCUR_BALANCE, 0)
           END AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_12' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME ,--数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
                   ON T0.P_DT = T5.P_DT
                   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
         LEFT JOIN ${ods_db}.O3_THISCURRENTS T8
                   ON T0.P_DT = T8.P_DT
                   AND T0.L_BASECOMBI_ID = T8.L_BASECOMBI_ID
                   AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
                   AND T0.C_INVEST_TYPE = T8.C_INVEST_TYPE
                   AND T8.L_BUSIN_FLAG = '73376'
                   AND T8.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
WHERE (T0.L_BUSIN_FLAG IN ('41802', '73375', '73376', '40933', '40934', '73204', '73152', '73154') OR
    --41801红股除权
    --41802红股上市,其中红股上市包含上证基金通红利再投，并需要另外再取一次，做除权数据；
    --40933份额调增40934份额减少
    --73375基金红利再投增加份额 73376基金红利再投增加零碎份额现金
	--73204港股通红利股票选择权增加零碎股现金
	--73152	开放式基金强制调增 73154开放式基金强制调减
       (T0.L_BUSIN_FLAG IN ('72575') AND T0.L_BUSIN_AMOUNT <> 0) --其中存在交易数量为0的数据需要排除,72575场内基金收益结转份额
    OR (T0.L_BUSIN_FLAG IN ('41704','41703') AND T5.C_MARKET_NO NOT IN ('6')) --41703红利除权\41704红利到账，剔除场外部分
    OR (T0.L_BUSIN_FLAG IN ('41702') AND T5.C_ASSET_CLASS IN ('4'))  --41702债券付息,上证基金通分红数据，并需要另外再取一次，做除权数据；
    )
  AND T0.C_STATUS = '1'
  --红利除权  41801 41703
  --红股上市  41802（股票）
  --红利到账  73376  41704  41702
  --红利再投  41802（基金） 73375 72575
  --份额调整  40933  40934
  AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--补充场内基金红利除权数据
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO , 'C') AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO , 'C') AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                     WHEN T5.C_MARKET_NO = '1' THEN
                         'SH'
                     WHEN T5.C_MARKET_NO = '2' THEN
                         'SZ'
                     WHEN T5.C_MARKET_NO = '6' THEN
                         'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '110001' AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END) AS INV_TYP, --投资类型
       '11000100' AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41702', '41704') --红利到账使用发生金额
               THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72575', '41802') THEN --红利再投金额使用成交数量*成交价格（价格为0默认1）
                   T0.L_BUSIN_AMOUNT *
                   (CASE WHEN T0.EN_ENTRUST_PRICE = 0 THEN 1 ELSE T0.EN_ENTRUST_PRICE END)
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_BUSIN_AMOUNT
           END AS TNV_VAL, --成交金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41702', '41704') --红利到账使用发生金额
               THEN
               T0.EN_OCCUR_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72575', '41802') THEN --红利再投金额使用成交数量*成交价格（价格为0默认1）
                   T0.L_BUSIN_AMOUNT *
                   (CASE WHEN T0.EN_ENTRUST_PRICE = 0 THEN 1 ELSE T0.EN_ENTRUST_PRICE END)
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_BUSIN_AMOUNT
           END AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_13' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
                   ON T0.P_DT = T5.P_DT
                   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
WHERE ((T0.L_BUSIN_FLAG IN ('41802') AND T5.C_ASSET_CLASS = '4') OR
    --41802红股上市,其中红股上市包含上证基金通红利再投，并需要另外再取一次，做除权数据；
       (T0.L_BUSIN_FLAG IN ('72575') AND T0.L_BUSIN_AMOUNT <> 0) --其中存在交易数量为0的数据需要排除,72575场内基金收益结转份额
    OR (T0.L_BUSIN_FLAG IN ('41702') AND T5.C_ASSET_CLASS IN ('4')) --41702债券付息,上证基金通分红数据，并需要另外再取一次，做除权数据；
    OR (T0.L_BUSIN_FLAG IN ('73145'))
	OR (T0.L_BUSIN_FLAG IN ('41704') AND T5.C_STOCK_TYPE = '2' AND T5.C_MARKET_NO = '2' ) --补充深交所封闭式基金除权数据
    )
  AND T0.C_STATUS = '1'
  AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--场外基金红利除权及红利再投数据（日终）
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
                   concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_J' , T0.L_BUSIN_NO)
           WHEN T0.L_BUSIN_FLAG IN ('72402', '73145') THEN
                   concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO)
           END AS TRD_SRC_ID, --交易源ID
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
                   concat(T0.L_DATE , '_HSO32' , '_J' , T0.L_BUSIN_NO)
           WHEN T0.L_BUSIN_FLAG IN ('72402', '73145') THEN
                   concat(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO)
           END AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                      WHEN T5.C_MARKET_NO = '1' THEN
                          'SH'
                      WHEN T5.C_MARKET_NO = '2' THEN
                          'SZ'
                      WHEN T5.C_MARKET_NO = '6' THEN
                          'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               '110003' --红利（场外）
           WHEN T0.L_BUSIN_FLAG IN ('72402', '73145') THEN
               '120003' --红利再投（场外）
           END AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END) AS INV_TYP, --投资类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               '11000300' --红利除权（场外）
           WHEN T0.L_BUSIN_FLAG IN ('72402', '73145') THEN
               '12000300' --红利再投（场外）
           END AS BUSI_CLAS, --业务类型
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('72402') THEN
               T0.L_BUSIN_AMOUNT
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_BUSIN_AMOUNT
           END AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               0
           WHEN T0.L_BUSIN_FLAG IN ('72402') THEN
               ROUND(T0.EN_DEAL_BALANCE / T0.L_BUSIN_AMOUNT, 2)
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               1
           END AS TNV_PRC, --成交价格
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72402') THEN
               T0.EN_DEAL_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_BUSIN_AMOUNT
           END AS TNV_VAL, --成交金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               T0.EN_SUBJECT_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('72402') THEN
               T0.EN_DEAL_BALANCE
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_BUSIN_AMOUNT
           END AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       CASE
           WHEN T0.L_BUSIN_FLAG IN ('41703') THEN
               T4.L_SETTLE_DATE
           WHEN T0.L_BUSIN_FLAG IN ('72402') THEN
               T0.L_DATE
           WHEN T0.L_BUSIN_FLAG IN ('73145') THEN
               T0.L_DATE
           END AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_14' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
         LEFT JOIN VHISPENDSETTLE T4 --当前和历史的合集
                   ON T0.P_DT = T4.L_TRADE_DATE
                   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
                   AND T0.L_BUSIN_NO = T4.VC_ORIGINAL_NO
                   AND T4.L_BUSIN_FLAG = '41703'
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T0.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
                   ON T0.P_DT = T5.P_DT
                   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
WHERE ((T0.L_BUSIN_FLAG IN ('41703') AND T5.C_MARKET_NO IN ('6')) OR
    --41703红利除权,场外除权
       (T0.L_BUSIN_FLAG IN ('72402', '73145') AND T0.L_BUSIN_AMOUNT <> 0) --72402场外红利再投资（LOF）73145开放式基金份额分红
    )
  AND T0.C_STATUS = '1'
  AND T0.P_DT BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--开放式基金除权（日终）
SELECT T0.L_TRADE_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_J' , T0.VC_ORIGINAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_TRADE_DATE , '_HSO32' , '_J' , T0.VC_ORIGINAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                      WHEN T5.C_MARKET_NO = '1' THEN
                          'SH'
                      WHEN T5.C_MARKET_NO = '2' THEN
                          'SZ'
                      WHEN T5.C_MARKET_NO = '6' THEN
                          'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '110003' AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END) AS INV_TYP, --投资类型
       '11000300' AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE
            ELSE T0.EN_ACT_SETTLE_BALANCE
           END AS TNV_VAL, --成交金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE
            ELSE T0.EN_ACT_SETTLE_BALANCE
           END  AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_SETTLE_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_15' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_TRADE_DATE AS P_DT,
      'O3' AS SYS_RS_ID --系统来源标识
FROM VHISPENDSETTLE T0 --当前和历史的合集
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                   ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
WHERE T0.L_BUSIN_FLAG IN ('73147')
  --73147开放式基金现金分红
  AND T0.C_STATUS = '1'
  AND T0.L_TRADE_DATE BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--红利再投除权数据（实时）
SELECT T4.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T4.L_DATE , '_HSO32' , '_L' , T4.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       concat(T4.L_DATE , '_HSO32' , '_L' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T4.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                      WHEN T5.C_MARKET_NO = '1' THEN
                          'SH'
                      WHEN T5.C_MARKET_NO = '2' THEN
                          'SZ'
                      WHEN T5.C_MARKET_NO = '6' THEN
                          'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '110003' AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END) AS INV_TYP, --投资类型
       '11000300' AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       T4.L_BUSIN_AMOUNT * (CASE
                                WHEN T4.EN_ENTRUST_PRICE = 0 THEN
                                    1
                                ELSE
                                    T4.EN_ENTRUST_PRICE
           END) AS TNV_VAL, --成交金额
       T4.L_BUSIN_AMOUNT * (CASE
                                WHEN T4.EN_ENTRUST_PRICE = 0 THEN
                                    1
                                ELSE
                                    T4.EN_ENTRUST_PRICE
           END) AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_SETTLE_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_16' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T4.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM VHISPENDSETTLE T0  ----当前和历史的合集
         LEFT JOIN ${ods_db}.O3_THISCURRENTS T4
                   ON T0.L_TRADE_DATE = T4.L_DATE
                   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
                   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
                   AND T4.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
WHERE T0.L_BUSIN_FLAG IN ('72401', '72694')
  AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
  AND T0.L_TRADE_DATE BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--红利再投数据（实时）
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_J' , T4.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_J' , T4.L_BUSIN_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T4.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
           WHEN T5.C_ASSET_CLASS = '4' THEN
                   concat(T5.VC_REPORT_CODE , '.FUND.' ,
                   (CASE
                     WHEN T5.C_MARKET_NO = '1' THEN
                         'SH'
                     WHEN T5.C_MARKET_NO = '2' THEN
                         'SZ'
                     WHEN T5.C_MARKET_NO = '6' THEN
                         'NONE'
                   END)) --基金
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
           WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
           WHEN T5.C_MARKET_NO = 'n' THEN
               'SHSC'
           WHEN T5.C_MARKET_NO = 'o' THEN
               'SZSC'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '120003' AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END) AS INV_TYP, --投资类型
       '12000300' AS BUSI_CLAS, --业务类型
       T4.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE
           WHEN T4.EN_ENTRUST_PRICE = 0 THEN
               1
           ELSE
               T4.EN_ENTRUST_PRICE
           END AS TNV_PRC, --成交价格
       T4.L_BUSIN_AMOUNT *
            (CASE
                WHEN T4.EN_ENTRUST_PRICE = 0 THEN
                    1
                ELSE
                    T4.EN_ENTRUST_PRICE
           END) AS TNV_VAL, --成交金额
       CASE WHEN NVL(T0.EN_ACT_SETTLE_BALANCE,0) = 0 THEN T0.EN_SETTLE_BALANCE
            ELSE T0.EN_ACT_SETTLE_BALANCE
           END  AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_17' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM VHISPENDSETTLE T0 --当前和历史的合集
         LEFT JOIN ${ods_db}.O3_THISCURRENTS T4
                   ON T0.L_TRADE_DATE = T4.P_DT
                   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
                   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
                   AND T4.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
         LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                   ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                   ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
         LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                   ON T3.L_ASSET_ID = T2.L_ASSET_ID
         LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选交易所市场
                   ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
WHERE T0.L_BUSIN_FLAG IN ('72401', '72694')
  AND T0.C_CASHSETTLE_FLAG IN ('0', '2', '4')
  AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
  AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
  AND T0.L_TRADE_DATE BETWEEN  ${beg_date}  AND  ${end_date}

UNION ALL
--红利税补缴成交
SELECT T0.L_TRADE_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_U' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
            WHEN T5.C_MARKET_NO = '1' THEN
             'SH'
            WHEN T5.C_MARKET_NO = '2' THEN
             'SZ'
            WHEN T5.C_MARKET_NO = 'n' THEN
             'SHSC'
            WHEN T5.C_MARKET_NO = 'o' THEN
             'SZSC'
          END))  AS SECU_ID, --证券编码
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
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '400001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '40000100' AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       T0.EN_BANLANCE AS TNV_VAL, --成交金额
       T0.EN_BANLANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_COMPLETE_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_18' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_TRADE_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISUNCOMPLETELOG T0 --未完成表，当前表和历史表合集
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，当前表和历史表合集
    ON T0.L_TRADE_DATE = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  ${beg_date}  AND  ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('72576')
   AND T0.L_TRADE_DATE BETWEEN  ${beg_date}  AND  ${end_date}
      --72576红利税补缴冻结
      --使用L_TRADE_DATE筛选业务日期

UNION ALL
--限售股转流通
SELECT T7.aft_1_dt AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T7.aft_1_dt , '_HSO32' , '_X' , T0.L_UNIT_ID) AS TRD_SRC_ID, --交易源ID
       CONCAT(T7.aft_1_dt , '_HSO32' , '_X' , T0.L_UNIT_ID, '_',
	   ROW_NUMBER()OVER(PARTITION BY T0.L_DATE,T0.L_UNIT_ID ORDER BY T0.L_RSEND_DATE ASC)
	   )  AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T4.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T5.C_ASSET_CLASS = '2' THEN
          CONCAT(T5.VC_REPORT_CODE , '.STK.' , (CASE
            WHEN T5.C_MARKET_NO = '1' THEN
             'SH'
            WHEN T5.C_MARKET_NO = '2' THEN
             'SZ'
            WHEN T5.C_MARKET_NO = 'n' THEN
             'SHSC'
            WHEN T5.C_MARKET_NO = 'o' THEN
             'SZSC'
            WHEN T5.C_MARKET_NO = 'j' THEN
              CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'SB' ELSE 'BJ' END
            WHEN T5.C_MARKET_NO = 'r' THEN
            'SB'
          END)) --股票
         WHEN T5.C_ASSET_CLASS = '3' THEN
          CONCAT(T5.VC_REPORT_CODE , '.BOND.' , (CASE
            WHEN T5.C_MARKET_NO = '1' THEN
             'SH'
            WHEN T5.C_MARKET_NO = '2' THEN
             'SZ'
            WHEN T5.C_MARKET_NO = '5' THEN
             'YHJ'
          END)) --债券
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'SB' ELSE 'BJ' END
         WHEN T5.C_MARKET_NO = 'r' THEN
          'SB'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T4.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T4.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '410001' AS BUSI_TYP, --业务类别
		CASE WHEN T4.C_INVEST_TYPE = '1' THEN '2'
             WHEN T4.C_INVEST_TYPE = '2' THEN '1'
             WHEN T4.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T4.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T4.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T4.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '41000101' AS BUSI_CLAS, --业务类型
       T0.L_RESTRICTED_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_RSEND_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_19' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T7.aft_1_dt as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISRESTRICTEDSTOCK T0
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON T0.P_DT = T4.P_DT
   AND T0.L_UNIT_ID = T4.L_UNIT_ID
   AND T4.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-31),'yyyyMMdd') AND ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T4.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.P_DT = T5.P_DT
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-31),'yyyyMMdd') AND ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
   on T0.L_RSEND_DATE = W1.dt
   AND T5.C_MARKET_NO = W1.mkt_no
   and W1.SYS_RS_ID='O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T7
   on W1.pre_0_dt = T7.dt
   AND T5.C_MARKET_NO = T7.mkt_no
   and t7.SYS_RS_ID='O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T8
    on T0.P_DT = T8.dt
   AND T5.C_MARKET_NO = T8.mkt_no
   and t8.SYS_RS_ID='O3'
 WHERE T7.aft_1_dt = T8.aft_1_dt
   AND T7.aft_1_dt between ${beg_date} and ${end_date}
   AND NVL(T0.C_RSEND_FLAG,'1') = '1'
   and t0.P_DT BETWEEN  date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-31),'yyyyMMdd') AND ${end_date}

UNION ALL
--离线清算：非投资类业务
SELECT T0.L_TRADE_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|0|0|' , T0.L_TRADE_DATE , '_HSO32' , '_P' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_TRADE_DATE , '_HSO32' , '_P' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'GLF.CASH.NONE'  --管理费
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'TGF.CASH.NONE'  --托管费
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'JSBFJ.CASH.SH'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'JSBFJ.CASH.SZ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'JSBFJ.CASH.SH'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'JSBFJ.CASH.SZ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'ZDBFJ.CASH.SH'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'ZDBFJ.CASH.SZ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'JYBZJ.CASH.SH'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'JYBZJ.CASH.SZ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'JSSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'YFYJ.CASH.SH'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'YFYJ.CASH.SZ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'JYSXF.CASH.NONE'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'DPSI101.DPSI.NONE'  --活期存款
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'LXZZS.CASH.NONE'  --利息增值税
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'ZRZZS.CASH.NONE'	    --转让增值税
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'FJS.CASH.NONE'	--附加税
       END AS SECU_ID, --证券编码
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'SH'
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'SZ'
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'NONE'
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'NONE'
       END AS EXCH_CODE, --交易市场代码
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN 'GLF'  --管理费
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN 'TGF'  --托管费
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN 'JSBFJ'  --结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN 'ZDBFJ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN 'ZDBFJ'  --最低结算备付金
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN 'JYBZJ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN 'JYBZJ'  --交易保证金
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN 'JSSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN 'YFYJ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN 'YFYJ'  --应付佣金
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN 'JYSXF'  --交易手续费
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN 'DPSI101'  --活期存款
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN 'LXZZS'  --利息增值税
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN 'ZRZZS'  --转让增值税
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN 'FJS'  --附加税
       END AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '440003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG = '40108' THEN '44000300'  --管理费支付
		 WHEN T0.L_BUSIN_FLAG = '40107' THEN '44000302'  --托管费支付
		 WHEN T0.L_BUSIN_FLAG = '72457' THEN '44000308'  --非担保备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72458' THEN '44000308'  --非担保备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72512' THEN '44000304'  --DVP备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72513' THEN '44000304'  --DVP备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72459' THEN '44000306'  --最低备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72460' THEN '44000306'  --最低备付金利息收入
		 WHEN T0.L_BUSIN_FLAG = '72461' THEN '44000334'  --结算保证金利息支付
		 WHEN T0.L_BUSIN_FLAG = '72462' THEN '44000334'  --结算保证金利息支付
		 WHEN T0.L_BUSIN_FLAG = '72480' THEN '44000310'  --上清所现券结算费支付
		 WHEN T0.L_BUSIN_FLAG = '72481' THEN '44000312'  --上清所回购结算费支付
		 WHEN T0.L_BUSIN_FLAG = '72933' THEN '44000318'  --外汇交易中心现券交易手续费支付
		 WHEN T0.L_BUSIN_FLAG = '72454' THEN '44000320'  --外汇交易中心回购交易手续费支付
		 WHEN T0.L_BUSIN_FLAG = '72515' THEN '44000314'  --中债登现券结算费支付
		 WHEN T0.L_BUSIN_FLAG = '72516' THEN '44000316'  --中债登回购结算费支付
		 WHEN T0.L_BUSIN_FLAG = '72446' THEN '44000322'  --上交所佣金支付
		 WHEN T0.L_BUSIN_FLAG = '72447' THEN '44000324'  --深交所佣金支付
		 WHEN T0.L_BUSIN_FLAG = '72445' THEN '44000326'  --银行手续费支付
		 WHEN T0.L_BUSIN_FLAG = '72456' THEN '44000328'  --活期存款利息收入
		 WHEN T0.L_BUSIN_FLAG = '73429' THEN '44000330'  --贷款服务销项税支付
		 WHEN T0.L_BUSIN_FLAG = '73430' THEN '44000332'  --转让金融商品销项税支付
		 WHEN T0.L_BUSIN_FLAG = '73431' THEN '44000336'	--增值税附加税支付
       END AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       T0.EN_SETTLE_BALANCE AS TNV_VAL, --成交金额
       T0.EN_SETTLE_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_SETTLE_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_20' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_TRADE_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --当前和历史的合集
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 WHERE T0.L_BUSIN_FLAG IN ('40108', '40107', '72457', '72458', '72512' ,'72513', '72459', '72460', '72461', '72462', '72480', '72481', '72933', '72454', '72515', '72516', '72446', '72447', '72445', '72456', '73429', '73430', '73431')
 --40108管理费支付 40107托管费支付
 --72457上海结算备付金利息收入 72458深圳结算备付金利息收入
 --72512上海DVP备付金利息收入 72513深圳DVP备付金利息收入
 --72459上海最低备付金利息收入 72460深圳最低备付金利息收入
 --72461上海交易保证金利息收入 72462深圳交易保证金利息收入
 --72480上清所现券结算费支付 72481上清所回购结算费支付 72933外汇交易中心现券费用支付 72454外汇交易中心回购费用支付 72515中央国债现券结算费支付  72516中央国债回购结算费支付
 --72446上海佣金支付 72447深圳佣金支付
 --72445银行手续费支付
 --72456银行间活期利息收入
 --73429贷款服务销项税 73430转让金融商品销项税
  --73431 应交增值税附加税
   AND NVL(T0.C_SETTLE_FLAG, 0) <> '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯
   AND T0.L_TRADE_DATE BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线清算：强制赎回
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('73088') THEN
          CONCAT('0|0|0|' , T4.L_TRADE_DATE , '_HSO32' , '_S' , T4.L_SERIAL_NO)
       END AS TRD_SRC_ID, --交易源ID
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('73088') THEN
          CONCAT(T4.L_TRADE_DATE , '_HSO32' , '_S' , T4.L_SERIAL_NO)
       END AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.FUND.' , (CASE
            WHEN T5.C_MARKET_NO = '1' THEN
             'SH'
            WHEN T5.C_MARKET_NO = '2' THEN
             'SZ'
            WHEN T5.C_MARKET_NO = '6' THEN
             'NONE'
          END)) AS SECU_ID, --证券编码
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
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '450003' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '45000300' AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_DEAL_BALANCE - T0.EN_FARE7 AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T4.L_SETTLE_DATE AS DELI_DT, --交割日期,可能不准，可能并非按照这个日期进行交收
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_21' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN VHISPENDSETTLE T4 --当前和历史的合集
    ON T0.L_DATE = T4.L_TRADE_DATE
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
   AND CASE WHEN T0.L_BUSIN_NO <> 0 THEN T0.L_BUSIN_NO ELSE T0.L_BUSIN_NO2 END = CASE WHEN T4.VC_ORIGINAL_NO <> 0 THEN T4.VC_ORIGINAL_NO ELSE T4.L_SERIAL_NO END
   AND T4.L_BUSIN_FLAG = '73088'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
    ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T0.L_BUSIN_FLAG IN ('73088')
   AND T0.C_STATUS = '1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线清算：新增限售
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码，
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END
	  ) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '410001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '41000100' AS BUSI_CLAS, --业务类型
       CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                         '数量:([0-9]+)',0),
                           '数量:',
                           '') AS DECIMAL(20, 4)) AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       CASE WHEN T7.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
       END AS RES_FLAG, --限售标识
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_22' AS TASK_RS_ID, --任务来源标识
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
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.L_ASSET_ID = T4.L_ASSET_ID
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
   AND T4.L_RESTRICTED_AMOUNT <> 0
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISRESTRICTEDSTOCK T7
    ON T0.L_DATE = T7.L_DATE
   AND T4.L_UNIT_ID = T7.L_UNIT_ID
   AND T7.P_DT BETWEEN ${beg_date} AND ${end_date}
   AND CAST(REGEXP_REPLACE(regexp_extract(T0.VC_SUMMARY,
                                         '数量:([0-9]+)',0),
                           '数量:',
                           '') AS DECIMAL(20, 4))
	    = T7.L_RESTRICTED_AMOUNT
 WHERE T0.L_BUSIN_FLAG IN ('41808')  --
   AND T0.C_STATUS = '1'
   AND T0.L_BUSIN_AMOUNT = 0
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线清算：新增限售\解限
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_XS' , T0.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_XS' , T0.L_BUSIN_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码，
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_BIND_SEAT AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END
	  ) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '410001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE WHEN T0.VC_BUSIN_OPFLAG IN ('201') THEN '41000102' --限售增加
	        WHEN T0.VC_BUSIN_OPFLAG IN ('202') THEN '41000103' --限售减少
	   END AS BUSI_CLAS, --业务类型
       T0.en_occur_amount AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       CASE WHEN T0.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
            WHEN T0.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
            WHEN T0.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
            WHEN T0.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
			WHEN T0.C_LOCKRESTRICTED_TYPE = '1' THEN 'L5'
       END AS RES_FLAG, --限售标识
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_23' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISRESTRICTEDSTOCKBUSINESS T0
 INNER JOIN V_XS T9
    ON T0.P_DT = T9.L_DATE
   AND T0.L_FUND_ID = T9.L_FUND_ID
   AND T0.L_BASECOMBI_ID = T9.L_BASECOMBI_ID
   AND T0.VC_STOCKHOLDER_ID = T9.VC_STOCKHOLDER_ID
   AND T0.VC_INTER_CODE = T9.VC_INTER_CODE
   AND T9.L_BUSIN_AMOUNT <> 0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.VC_BUSIN_OPFLAG IN ('201','202')
   AND T0.C_CHECK_FLAG IN ('2','3')
   AND T0.en_occur_amount <> 0
   AND T0.C_DEAL_FLAG = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--离线清算：新增限售增加
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码，
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END
	  ) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING,0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '410001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '41000102' AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       CASE WHEN T7.C_LOCKRESTRICTED_TYPE = '2' THEN 'L2'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '3' THEN 'L14'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '4' THEN 'L13'
            WHEN T7.C_LOCKRESTRICTED_TYPE = '5' THEN 'L4'
       END AS RES_FLAG, --限售标识
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_24' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
 INNER JOIN V_XS T9
    ON T0.P_DT = T9.L_DATE
   AND T0.L_FUND_ID = T9.L_FUND_ID
   AND T0.L_BASECOMBI_ID = T9.L_BASECOMBI_ID
   AND T0.VC_STOCKHOLDER_ID = T9.VC_STOCKHOLDER_ID
   AND T0.VC_INTER_CODE = T9.VC_INTER_CODE
   AND T9.L_BUSIN_AMOUNT <> 0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISUNITSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.L_ASSET_ID = T4.L_ASSET_ID
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T0.VC_STOCKHOLDER_ID = T4.VC_STOCKHOLDER_ID
   AND T4.L_RESTRICTED_AMOUNT <> 0
   AND T4.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISRESTRICTEDSTOCK T7
    ON T0.L_DATE = T7.L_DATE
   AND T4.L_UNIT_ID = T7.L_UNIT_ID
   AND T7.P_DT BETWEEN ${beg_date} AND ${end_date}
   AND T0.L_BUSIN_AMOUNT = T7.L_RESTRICTED_AMOUNT
 WHERE T0.L_BUSIN_FLAG IN ('41808')  --
   AND T0.C_STATUS = '1'
   AND T0.L_BUSIN_AMOUNT <> 0
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}


UNION ALL
--交易所兑付（手工类）
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码，
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.BOND.' , CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
       END
	  ) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '140001' AS BUSI_TYP, --业务类别
       CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
       ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '14000100' AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       T0.EN_OCCUR_BALANCE / T0.L_BUSIN_AMOUNT AS TNV_PRC, --成交价格
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       CASE WHEN T0.EN_OCCUR_BALANCE - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE <= 0 THEN 0
	   ELSE T0.EN_OCCUR_BALANCE - T0.L_BUSIN_AMOUNT * T6.EN_CURR_FACE_PRICE END
	   AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标识
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_clea_jour_his_25' AS TASK_RS_ID, --任务来源标识
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
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} AND ${end_date}
   LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = W1.dt
    AND T5.C_MARKET_NO = W1.mkt_no
	and W1.SYS_RS_ID='O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T6
    ON W1.PRE_2_DT = T6.P_DT
   AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd') AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('41701')  --
   AND T0.C_STATUS = '1'
   AND T0.VC_BUSIN_OPFLAG IN ('411')
   AND T0.L_BUSIN_AMOUNT <> 0
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}