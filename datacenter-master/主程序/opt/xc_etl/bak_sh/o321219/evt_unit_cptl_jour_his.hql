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

ALTER TABLE ${dwd_db}.evt_unit_cptl_jour_his DROP IF EXISTS PARTITION (p_dt>=${beg_date}, p_dt<=${end_date}, sys_rs_id = 'O3');

WITH vhispendsettle AS (
  SELECT l_serial_no,
         l_entrust_serial_no,
         l_trade_date,
         vc_original_no,
         c_entrust_direction,
         vc_deal_no,
         l_relate_no,
         vc_inter_code,
         l_basecombi_id,
         l_settle_date,
         l_busin_flag,
         l_fund_id,
         l_date,
         c_status,
         vc_stockholder_id,
         vc_bind_seat,
         vc_currency_no,
         c_invest_type,
         en_act_settle_balance,
         en_settle_balance,
         l_settle_amount,
         l_deal_date
    FROM ${ods_db}.o3_thispendsettle
   WHERE c_status = '1'
  UNION ALL
  SELECT l_serial_no,
         l_entrust_serial_no,
         l_trade_date,
         vc_original_no,
         c_entrust_direction,
         vc_deal_no,
         l_relate_no,
         vc_inter_code,
         l_basecombi_id,
         l_settle_date,
         l_busin_flag,
         l_fund_id,
         l_date,
         c_status,
         vc_stockholder_id,
         vc_bind_seat,
         vc_currency_no,
         c_invest_type,
         en_act_settle_balance,
         en_settle_balance,
         l_settle_amount,
         l_deal_date
    FROM ${ods_db}.o3_tpendsettle
   WHERE c_status = '1')
INSERT INTO ${dwd_db}.evt_unit_cptl_jour_his PARTITION (p_dt, sys_rs_id)
  (occu_dt,
   occu_time,
   busi_sys_id,
   trd_src_id,
   tnv_onum,
   prd_code,
   ast_unit_code,
   cptl_adj_clas,
   curr_code,
   busi_typ,
   busi_clas,
   tnv_vol,
   tnv_val,
   belg_prd_fee,
   deli_dt,
   oper_no,
   cptl_add,
   cptl_red,
   memo,
   busi_date,
   task_rs_id,
   dm_created_time,
   p_dt,
   sys_rs_id)
--离线：TA申购（包含认购）
SELECT t0.l_deal_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t0.l_deal_date, '_HSO32', '_T', t4.l_busin_no) AS trd_src_id, --交易源ID
       CONCAT(t0.l_deal_date, '_HSO32', '_T', t4.l_busin_no) AS tnv_onum, --成交序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       NULL AS cptl_adj_clas, --资金调整类型
       'CNY' AS curr_code, --货币代码
       '350003' AS busi_typ, --业务类别
       '35000302' AS busi_clas, --业务类型
       t5.l_busin_amount AS tnv_vol, --成交数量
       t4.en_subject_balance AS tnv_val, --成交金额
       0 AS belg_prd_fee, --归属产品费用
       t0.l_settle_date AS deli_dt, --交割日期
       t4.l_operator_no AS oper_no, --操作员编码
       NULL AS cptl_add,--资金增加
       NULL AS cptl_red,--资金减少
       NULL AS memo, --备注
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS busi_date, --业务日期
       'evt_unit_cptl_jour_his_1' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_deal_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM vhispendsettle t0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.o3_tfundinfo t1
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t4
              ON t0.l_fund_id = t4.l_fund_id
             AND t0.l_deal_date = t4.l_date
             AND t0.vc_original_no = t4.l_busin_no
             AND t0.l_busin_flag = t4.l_busin_flag
       LEFT JOIN ${ods_db}.o3_tasset t2
              ON t1.l_default_asset = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t5
              ON t0.l_fund_id = t5.l_fund_id
             AND t4.l_date = t5.l_date
             AND t0.vc_original_no = t5.l_busin_no
             AND t5.l_busin_flag = '71908'
 WHERE t0.l_busin_flag IN ('71902')
   AND t0.c_status IN ('1')
   AND t0.en_settle_balance <> 0
   AND t4.l_date BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
--实时清算：TA赎回
--筛选条件：T0.L_DEAL_DATE
--20230412：关联调整调整，使用L_DEAL_DATE
--20230412:只考虑未分组估值情况,调整资产单元取值
SELECT t0.l_deal_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t0.l_deal_date, '_HSO32', '_T', t4.l_busin_no) AS trd_src_id, --交易源ID
       CONCAT(t0.l_deal_date, '_HSO32', '_T', t4.l_busin_no) AS tnv_onum, --成交序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       NULL AS cptl_adj_clas, --资金调整类型
       'CNY' AS curr_code, --货币代码
       '350003' AS busi_typ, --业务类别
       '35000304' AS busi_clas, --业务类型
       t5.l_busin_amount AS tnv_vol, --成交数量
       t4.en_subject_balance AS tnv_val, --成交金额
       ROUND((t4.en_subject_balance / t6.en_balance) * t6.en_fee_gjjzc, 2) AS belg_prd_fee, --归属产品费用
       t0.l_settle_date AS deli_dt, --交割日期
       t4.l_operator_no AS oper_no, --操作员编码
       NULL AS cptl_add,--资金增加
       NULL AS cptl_red,--资金减少
       NULL AS memo, --备注
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS busi_date, --业务日期
       'evt_unit_cptl_jour_his_2' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_deal_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM vhispendsettle t0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.o3_tfundinfo t1
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t4
              ON t0.l_fund_id = t4.l_fund_id
             AND t0.l_deal_date = t4.l_date
             AND t0.vc_original_no = t4.l_busin_no
             AND t0.l_busin_flag = t4.l_busin_flag
       LEFT JOIN ${ods_db}.o3_tasset t2
              ON t1.l_default_asset = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t5
              ON t0.l_fund_id = t5.l_fund_id
             AND t4.l_date = t5.l_date
             AND t0.vc_original_no = t5.l_busin_no
             AND t5.l_busin_flag = '71910'
       LEFT JOIN ${ods_db}.o3_thisapplyredeem t6
              ON t0.l_fund_id = t6.l_fund_id
             AND t4.l_date = t6.l_date
             AND t0.vc_original_no = t6.l_serial_no
             AND t6.vc_busin_flag = '03'
 WHERE t0.l_busin_flag IN ('71903')
   AND t0.c_status IN ('1')
   AND t0.en_settle_balance <> 0
   AND t4.l_date BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--实时清算：TA分红
--筛选条件：T0.L_DEAL_DATE
--20230412：关联调整调整，使用L_DEAL_DATE
--20230412:只考虑未分组估值情况,调整资产单元取值
SELECT t4.l_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t4.l_date, '_HSO32', '_T', t4.l_busin_no) AS trd_src_id, --交易源ID
       CONCAT(t4.l_date, '_HSO32', '_T', t4.l_busin_no) AS tnv_onum, --成交序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       NULL AS cptl_adj_clas, --资金调整类型
       'CNY' AS curr_code, --货币代码
       '350003' AS busi_typ, --业务类别
       '35000306' AS busi_clas, --业务类型
       t4.l_busin_amount AS tnv_vol, --成交数量
       t4.en_subject_balance AS tnv_val, --成交金额
       0 AS belg_prd_fee, --归属产品费用
       t0.l_settle_date AS deli_dt, --交割日期
       t4.l_operator_no AS oper_no, --操作员编码
       NULL AS cptl_add,--资金增加
       NULL AS cptl_red,--资金减少
       NULL AS memo, --备注
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS busi_date, --业务日期
       'evt_unit_cptl_jour_his_3' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t4.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM vhispendsettle t0 --待交割，当前表和历史表合集
       LEFT JOIN ${ods_db}.o3_tfundinfo t1
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t4
              ON t0.l_fund_id = t4.l_fund_id
             AND t0.l_deal_date = t4.l_date
             AND t0.vc_original_no = t4.l_busin_no
             AND t0.l_busin_flag = t4.l_busin_flag
       LEFT JOIN ${ods_db}.o3_tasset t2
              ON t1.l_default_asset = t2.l_asset_id
 WHERE t0.l_busin_flag IN ('71909')
   AND t0.c_status IN ('1')
   AND t0.en_settle_balance <> 0
   AND t4.l_date BETWEEN ${beg_date} AND ${end_date}

 UNION ALL

--实时清算：TA分红再投
--筛选条件：T0.L_DATE
--20230412：调整整段逻辑
SELECT t0.l_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t0.l_date, '_HSO32', '_T', t0.l_busin_no) AS trd_src_id, --交易源ID
       CONCAT(t0.l_date, '_HSO32', '_T', t0.l_busin_no) AS tnv_onum, --成交序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       NULL AS cptl_adj_clas, --资金调整类型
       'CNY' AS curr_code, --货币代码
       '350003' AS busi_typ, --业务类别
       '35000308' AS busi_clas, --业务类型
       t0.l_busin_amount AS tnv_vol, --成交数量
       t4.en_subject_balance AS tnv_val, --成交金额
       0 AS belg_prd_fee, --归属产品费用
       t0.l_date AS deli_dt, --交割日期
       t0.l_operator_no AS oper_no, --操作员编码
       NULL AS cptl_add,--资金增加
       NULL AS cptl_red,--资金减少
       NULL AS memo, --备注
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS busi_date, --业务日期
       'evt_unit_cptl_jour_his_4' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --流水表
       LEFT JOIN ${ods_db}.o3_tfundinfo t1
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_thiscurrents t4
              ON t0.l_fund_id = t4.l_fund_id
              AND t0.l_date = t4.l_date
              AND t0.l_busin_no = t4.l_busin_no
              AND t4.l_busin_flag = '71911' --金额
       LEFT JOIN ${ods_db}.o3_tasset t2
              ON t1.l_default_asset = t2.l_asset_id
 WHERE t0.l_busin_flag IN ('71912') --份额
   AND t0.c_status IN ('1')
   AND t0.l_date BETWEEN ${beg_date} AND ${end_date}


 UNION ALL
--资金增加、资金减少
--筛选条件：T0.L_DATE
SELECT t0.l_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t0.l_date, '_HSO32', '_L', t0.l_serial_no) AS trd_src_id, --交易源ID
       CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no) AS tnv_onum, --成交序号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       NULL AS cptl_adj_clas, --资金调整类型
       'CNY' AS curr_code, --货币代码
       '350003' AS busi_typ, --业务类别
       CASE
            WHEN t0.l_busin_flag IN ('40101') THEN '35000310'
            WHEN t0.l_busin_flag IN ('40102') THEN '35000309'
       END AS busi_clas, --业务类型
       0 AS tnv_vol, --成交数量
       t0.en_occur_balance AS tnv_val, --成交金额
       0 AS belg_prd_fee, --归属产品费用
       t0.l_date AS deli_dt, --交割日期
       t0.l_operator_no AS oper_no, --操作员编码
       NULL AS cptl_add,--资金增加
       NULL AS cptl_red,--资金减少
       NULL AS memo, --备注
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS busi_date, --业务日期
       'evt_unit_cptl_jour_his_5' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表，获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表，获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
 WHERE t0.l_busin_flag IN ('40101', '40102') --40101资金增加40102资金减少
   AND t0.c_status = '1'
   AND t0.vc_summary LIKE '%资金划转%'
   AND t0.l_date BETWEEN ${beg_date} AND ${end_date}