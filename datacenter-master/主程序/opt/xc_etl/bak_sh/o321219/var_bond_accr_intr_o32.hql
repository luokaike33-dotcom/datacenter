------------------------------------------------------------------------
  -- 模块名称：债券应计利息
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

alter table ${dwd_db}.var_bond_accr_intr_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;
alter table ${dwd_db}.var_bond_accr_intr_o32 drop if exists partition (p_dt = ${current_date}) ;

insert into ${dwd_db}.var_bond_accr_intr_o32 partition(p_dt)
SELECT CONCAT(T1.VC_REPORT_CODE , '.BOND.' , NVL(T2.PARA_HCODE,'')) AS SECU_ID, --证券编码
             T0.L_DATE AS TRD_DT, --交易日期
             NULL AS BGN_ACCT_D, --开始计息日
             T0.L_RATE_DAYS AS REAL_INTA_DAYS, --已计息天数
             T0.EN_TODAY_INTEREST AS ACCR_INT, --应计利息
             NULL AS INTR_DAYS, --利息天数
             T0.EN_CURR_FACE_PRICE AS REM_PRIN, --剩余本金
             T0.EN_BOND_INTEREST AS HUND_INTR_BFR_TAX_BS, --税前每百元利息(买卖使用）
             NULL AS HUND_INTR_AFT_TAX_BS, --税后每百元利息(买卖使用）
             T0.EN_NEXT_BOND_INTEREST AS HUND_INTR_BFR_TAX_TMW, --税前下一日每百元利息(买卖使用）
             NULL AS HUND_INTR_AFT_TAX_TMW, --税后下一日每百元利息(买卖使用）
             NULL AS HUND_INTR_BFR_TAX_INTA, --税前每百元利息（计息使用）
             NULL AS HUND_INTR_AFT_TAX_INTA, --税后每百元利息（计息使用）
             T0.L_DATE AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'prc_var_bond_accr_intr_1' AS TASK_RS_ID, --任务来源标识
             'thisbondproperty' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     T0.L_DATE
        FROM ${ods_db}.O3_THISBONDPROPERTY T0
        JOIN ${ods_db}.O3_THISSTOCKINFO T1
          ON T0.L_DATE = T1.L_DATE
         AND T0.VC_INTER_CODE = T1.VC_INTER_CODE
         AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3'
       WHERE T0.L_DATE BETWEEN ${beg_date} AND ${end_date}
      UNION ALL
      SELECT CONCAT(T1.VC_REPORT_CODE , '.BOND.' , T2.PARA_HCODE) AS SECU_ID, --证券编码
             T0.L_DATE AS TRD_DT, --交易日期
             NULL AS BGN_ACCT_D, --开始计息日
             T0.L_RATE_DAYS AS REAL_INTA_DAYS, --已计息天数
             T0.EN_TODAY_INTEREST AS ACCR_INT, --应计利息
             NULL AS INTR_DAYS, --利息天数
             T0.EN_CURR_FACE_PRICE AS REM_PRIN, --剩余本金
             T0.EN_BOND_INTEREST AS HUND_INTR_BFR_TAX_BS, --税前每百元利息(买卖使用）
             NULL AS HUND_INTR_AFT_TAX_BS, --税后每百元利息(买卖使用）
             T0.EN_NEXT_BOND_INTEREST AS HUND_INTR_BFR_TAX_TMW, --税前下一日每百元利息(买卖使用）
             NULL AS HUND_INTR_AFT_TAX_TMW, --税后下一日每百元利息(买卖使用）
             NULL AS HUND_INTR_BFR_TAX_INTA, --税前每百元利息（计息使用）
             NULL AS HUND_INTR_AFT_TAX_INTA, --税后每百元利息（计息使用）
             T0.L_DATE AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'prc_var_bond_accr_intr_2' AS TASK_RS_ID, --任务来源标识
             'tbondproperty' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     T0.L_DATE
        FROM ${ods_db}.O3_TBONDPROPERTY T0
        JOIN ${ods_db}.O3_TSTOCKINFO T1
          ON T0.L_DATE = T1.L_DATE
         AND T0.VC_INTER_CODE = T1.VC_INTER_CODE
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3'
       WHERE T0.L_DATE = date_format(current_date,'yyyyMMdd');