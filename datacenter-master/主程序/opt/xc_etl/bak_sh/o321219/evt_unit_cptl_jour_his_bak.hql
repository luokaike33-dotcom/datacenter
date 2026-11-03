-------------------------------------------------------------------------
-- 模块名称：资产单元资金流入流出T-1
-- 改为全量跑批20230301-lucas
-------------------------------------------------------------------------
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

alter table ${dwd_db}.evt_unit_cptl_jour_his drop if exists partition (p_dt>=20180101,SYS_RS_ID='O3') ;

  WITH VHISPENDSETTLE AS
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
		  l_settle_amount,
		  L_DEAL_DATE
               FROM ${ods_db}.O3_THISPENDSETTLE
              WHERE C_STATUS = '1'
              AND P_DT >= 20180101
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
		  l_settle_amount,
		  L_DEAL_DATE
               FROM ${ods_db}.O3_TPENDSETTLE
              WHERE C_STATUS = '1')

insert into ${dwd_db}.evt_unit_cptl_jour_his partition(p_dt,sys_rs_id)
     (occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,prd_code,ast_unit_code,cptl_adj_clas,curr_code,busi_typ,busi_clas,tnv_vol,tnv_val,belg_prd_fee,deli_dt,oper_no,cptl_add,cptl_red,memo,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--离线：TA申购（包含认购）
SELECT T0.L_DEAL_DATE AS OCCU_DT, --发生日期
 NULL AS OCCU_TIME, --发生时间
 '1' AS BUSI_SYS_ID, --业务系统编码
 CASE WHEN T4.L_BUSIN_NO IS NULL THEN
 CONCAT('0|0|0|', T0.L_DEAL_DATE, '_HSO32', '_T', T0.VC_ORIGINAL_NO)
 ELSE CONCAT('0|0|0|', T4.L_DATE, '_HSO32', '_T', T4.L_BUSIN_NO) END AS TRD_SRC_ID, --交易源ID
 CASE WHEN T4.L_BUSIN_NO IS NULL THEN
 CONCAT(T0.L_DEAL_DATE, '_HSO32', '_T', T0.VC_ORIGINAL_NO)
 ELSE CONCAT(T4.L_DATE, '_HSO32', '_T', T4.L_BUSIN_NO) END AS TNV_ONUM, --成交序号
 T1.VC_FUND_CODE AS PRD_CODE, --产品代码
 CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
 NULL AS CPTL_ADJ_CLAS, --资金调整类型
 'CNY' AS CURR_CODE, --货币代码
 '350003' AS BUSI_TYP, --业务类别
 '35000302' AS BUSI_CLAS, --业务类型
 NVL(T5.L_BUSIN_AMOUNT,T0.l_settle_amount) AS TNV_VOL, --成交数量
 NVL(T4.EN_SUBJECT_BALANCE,T0.EN_SETTLE_BALANCE) AS TNV_VAL, --成交金额
 0 AS BELG_PRD_FEE, --归属产品费用
 T0.L_SETTLE_DATE AS DELI_DT, --交割日期
 T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
 NULL AS CPTL_ADD,--资金增加
 NULL AS CPTL_RED,--资金减少
 NULL AS MEMO, --备注
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_unit_cptl_jour_his_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DEAL_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN
  ( SELECT t4.*
   FROM VHISPENDSETTLE t0
   INNER JOIN ${ods_db}.O3_thiscurrents t4 ON T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG --AND T4.p_dt between ${beg_date} and ${end_date}
   AND T4.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
   WHERE datediff(from_unixtime(unix_timestamp(cast(T0.L_TRADE_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd'), from_unixtime(unix_timestamp(cast(T4.L_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd')) <= 30
     AND T0.L_TRADE_DATE >= T4.L_DATE
	 ) T4
	 ON T0.L_FUND_ID = T4.L_FUND_ID
AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
LEFT JOIN ${ods_db}.O3_tcombi T3
ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISCURRENTS T5
         ON T0.L_FUND_ID = T5.L_FUND_ID
                AND T4.L_DATE = T5.L_DATE
                AND T0.VC_ORIGINAL_NO = T5.L_BUSIN_NO
                AND T5.L_BUSIN_FLAG = '71908'
                AND T5.p_dt between date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') and ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('71902')
   AND T0.C_STATUS IN ('1')
  AND T0.EN_SETTLE_BALANCE <> 0

 UNION ALL
--实时清算：TA赎回
SELECT T0.L_DEAL_DATE AS OCCU_DT, --发生日期
 NULL AS OCCU_TIME, --发生时间
 '1' AS BUSI_SYS_ID, --业务系统编码
 CONCAT('0|0|0|', T0.L_DEAL_DATE, '_HSO32', '_T', T4.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
 CONCAT(T0.L_DEAL_DATE, '_HSO32', '_T', T4.L_BUSIN_NO) AS TNV_ONUM, --成交序号
 T1.VC_FUND_CODE AS PRD_CODE, --产品代码
 CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
 NULL AS CPTL_ADJ_CLAS, --资金调整类型
 'CNY' AS CURR_CODE, --货币代码
 '350003' AS BUSI_TYP, --业务类别
 '35000304' AS BUSI_CLAS, --业务类型
 T5.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
 T4.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
 ROUND((T6.EN_BALANCE / T4.EN_SUBJECT_BALANCE) * T6.EN_FEE_GJJZC, 2) AS BELG_PRD_FEE, --归属产品费用
 T0.L_SETTLE_DATE AS DELI_DT, --交割日期
 T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
 NULL AS CPTL_ADD,--资金增加
 NULL AS CPTL_RED,--资金减少
 NULL AS MEMO, --备注
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_unit_cptl_jour_his_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DEAL_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN
  ( SELECT t4.*
   FROM VHISPENDSETTLE t0
   INNER JOIN ${ods_db}.O3_thiscurrents t4 ON T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG --AND T4.p_dt between ${beg_date} and ${end_date}

   AND T4.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
   WHERE datediff(from_unixtime(unix_timestamp(cast(T0.L_TRADE_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd'), from_unixtime(unix_timestamp(cast(T4.L_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd')) <= 30
     AND T0.L_TRADE_DATE >= T4.L_DATE
	 ) T4 ON T0.L_FUND_ID = T4.L_FUND_ID
AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
LEFT JOIN ${ods_db}.O3_tcombi T3
ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_THISCURRENTS T5
         ON T0.L_FUND_ID = T5.L_FUND_ID
                AND T4.L_DATE = T5.L_DATE
                AND T0.VC_ORIGINAL_NO = T5.L_BUSIN_NO
                AND T5.L_BUSIN_FLAG = '71910'
       LEFT JOIN ${ods_db}.O3_THISAPPLYREDEEM T6
         ON T0.L_FUND_ID = T6.L_FUND_ID
                AND T4.L_DATE = T6.L_DATE
                AND T0.VC_ORIGINAL_NO = T6.L_SERIAL_NO
                AND T6.VC_BUSIN_FLAG = '03'
                AND T6.p_dt BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('71903')
   AND T0.C_STATUS IN ('1')
   AND T0.EN_SETTLE_BALANCE <> 0

 UNION ALL
--实时清算：TA分红
SELECT T0.L_TRADE_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|0|0|' , T4.L_DATE , '_HSO32' , '_T' , T4.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
     CONCAT(T4.L_DATE , '_HSO32' , '_T' , T4.L_BUSIN_NO) AS TNV_ONUM, --成交序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     NULL AS CPTL_ADJ_CLAS, --资金调整类型
     'CNY' AS CURR_CODE, --货币代码
     '350003' AS BUSI_TYP, --业务类别
     '35000306' AS BUSI_CLAS, --业务类型
     T4.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
     T4.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
     0 AS BELG_PRD_FEE, --归属产品费用
     T0.L_SETTLE_DATE AS DELI_DT, --交割日期
     T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
     NULL AS CPTL_ADD,--资金增加
     NULL AS CPTL_RED,--资金减少
     NULL AS MEMO, --备注
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_unit_cptl_jour_his_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_TRADE_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN
  ( SELECT t4.*
   FROM VHISPENDSETTLE t0
   INNER JOIN ${ods_db}.O3_thiscurrents t4 ON T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG --AND T4.p_dt between ${beg_date} and ${end_date}

   AND T4.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
   WHERE datediff(from_unixtime(unix_timestamp(cast(T0.L_TRADE_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd'), from_unixtime(unix_timestamp(cast(T4.L_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd')) <= 30
     AND T0.L_TRADE_DATE >= T4.L_DATE ) T4 ON T0.L_FUND_ID = T4.L_FUND_ID
AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
LEFT JOIN ${ods_db}.O3_tcombi T3 ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
 WHERE T0.L_BUSIN_FLAG IN ('71909')
   AND T0.C_STATUS IN ('1')
   AND T0.EN_SETTLE_BALANCE <>0

 UNION ALL
--实时清算：分红再投
SELECT T0.L_TRADE_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|0|0|' , T4.L_DATE , '_HSO32' , '_T' , T4.L_BUSIN_NO) AS TRD_SRC_ID, --交易源ID
     CONCAT(T4.L_DATE , '_HSO32' , '_T' , T4.L_BUSIN_NO) AS TNV_ONUM, --成交序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     NULL AS CPTL_ADJ_CLAS, --资金调整类型
     'CNY' AS CURR_CODE, --货币代码
     '350003' AS BUSI_TYP, --业务类别
     '35000308' AS BUSI_CLAS, --业务类型
     T4.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
     T4.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
     0 AS BELG_PRD_FEE, --归属产品费用
     T0.L_SETTLE_DATE AS DELI_DT, --交割日期
     T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
     NULL AS CPTL_ADD,--资金增加
     NULL AS CPTL_RED,--资金减少
     NULL AS MEMO, --备注
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_unit_cptl_jour_his_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_TRADE_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM VHISPENDSETTLE T0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
         ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN
  ( SELECT t4.*
   FROM VHISPENDSETTLE t0
   INNER JOIN ${ods_db}.O3_thiscurrents t4 ON T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
   AND T4.L_BUSIN_FLAG = '71911' --AND T4.p_dt between ${beg_date} and ${end_date}

   AND T4.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
   WHERE datediff(from_unixtime(unix_timestamp(cast(T0.L_TRADE_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd'), from_unixtime(unix_timestamp(cast(T4.L_DATE AS string), 'yyyyMMdd'), 'yyyy-MM-dd')) <= 30
     AND T0.L_TRADE_DATE >= T4.L_DATE
	 ) T4 ON T0.L_FUND_ID = T4.L_FUND_ID
AND T0.VC_ORIGINAL_NO = T4.L_BUSIN_NO
AND T4.L_BUSIN_FLAG = '71911'
LEFT JOIN ${ods_db}.O3_tcombi T3 ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2
         ON T3.L_ASSET_ID = T2.L_ASSET_ID
 WHERE T0.L_BUSIN_FLAG IN ('71912')
   AND T0.C_STATUS IN ('1')

 UNION ALL
--资金增加、资金减少
SELECT T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     '0|0|0|' || T0.L_DATE || '_HSO32' || '_L' || T0.L_SERIAL_NO AS TRD_SRC_ID, --交易源ID
     T0.L_DATE || '_HSO32' || '_L' || T0.L_SERIAL_NO AS TNV_ONUM, --成交序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     NULL AS CPTL_ADJ_CLAS, --资金调整类型
     'CNY' AS CURR_CODE, --货币代码
     '350003' AS BUSI_TYP, --业务类别
     CASE WHEN T0.L_BUSIN_FLAG IN ('40101') THEN '35000310'
          WHEN T0.L_BUSIN_FLAG IN ('40102') THEN '35000309'
     END AS BUSI_CLAS, --业务类型
     0 AS TNV_VOL, --成交数量
     T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
     0 AS BELG_PRD_FEE, --归属产品费用
     T0.L_DATE AS DELI_DT, --交割日期
     T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
     NULL AS CPTL_ADD,--资金增加
     NULL AS CPTL_RED,--资金减少
     NULL AS MEMO, --备注
     ${end_date} AS BUSI_DATE, --业务日期
     'evt_unit_cptl_jour_his_5' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE as p_dt,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
WHERE T0.L_BUSIN_FLAG IN ('40101',
                          '40102')--40101资金增加40102资金减少

  AND T0.C_STATUS = '1' --AND T0.p_dt between ${beg_date} and ${end_date}
  AND T0.VC_SUMMARY LIKE '%资金划转%'
  AND T0.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date} ;


