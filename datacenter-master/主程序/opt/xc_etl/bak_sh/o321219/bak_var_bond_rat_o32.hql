------------------------------------------------------------------------
  -- 模块名称：债券评级信息
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

alter table ${dwd_db}.var_bond_rat_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_bond_rat_o32 partition(p_dt)
 SELECT CONCAT(T1.VC_REPORT_CODE , '.BOND.' , T2.PARA_HCODE) AS SECU_ID, --证券编码
             NULL AS  pub_dt  , -- 信息发布日期
             NULL AS info_sour,
             T0.L_DATE AS RAT_DT, --评级日期
             T0.RAT_AGY_CODE, --评级机构代码
             T0.RAT_COM_NAME, --评级机构名称
             T0.RAT_TYP, --评级类型
             T0.RAT_NAME, --信用评级
             NULL AS rat_desc,
             NULL AS rat_name_lst,
             NULL AS rat_chg ,
             NULL AS rat_expt_typ,
             T0.RAT_SIGN, --评级标识
             T0.L_DATE AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'prc_var_bond_rat_1' AS TASK_RS_ID, --任务来源标识
             'thisbondproperty' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
             NULL AS brek_rate,
             NULL AS brek_defc_rate,
             T0.L_DATE
        FROM (
              --外部债项评级
              SELECT T0.VC_INTER_CODE,
                      T0.C_MARKET_NO,
                      T0.L_DATE, --评级日期
                      T0.VC_APPRAISE_ORGAN AS RAT_AGY_CODE, --评级机构代码
                      T3.VC_ITEM_NAME AS RAT_COM_NAME, --评级机构名称
                      1 AS RAT_TYP, --评级类型
                      T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
                      '1' AS RAT_SIGN --评级标识
                FROM ${ods_db}.O3_THISBONDPROPERTY T0
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T3
                  ON T3.L_DICTIONARY_NO = '60200'
                 AND T0.VC_APPRAISE_ORGAN = T3.C_LEMMA_ITEM
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                  ON T4.L_DICTIONARY_NO = '110000'
                 AND T0.C_OUTER_APPRAISE = T4.C_LEMMA_ITEM
               WHERE T0.C_OUTER_APPRAISE IS NOT NULL
                 AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}
              UNION ALL
              --内部债项评级
              SELECT T0.VC_INTER_CODE,
                      T0.C_MARKET_NO,
                      T0.L_DATE, --评级日期
                      'TK' AS RAT_AGY_CODE, --评级机构代码
                      'TK' AS RAT_COM_NAME, --评级机构名称
                      1 AS RAT_TYP, --评级类型
                      T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
                      '2' AS RAT_SIGN --评级标识, --评级标识
                FROM ${ods_db}.O3_THISBONDPROPERTY T0
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                  ON T4.L_DICTIONARY_NO = '110001'
                 AND T0.C_INSIDE_APPRAISE = T4.C_LEMMA_ITEM
               WHERE T0.C_INSIDE_APPRAISE IS NOT NULL
                 AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}) T0
        JOIN ${ods_db}.O3_THISSTOCKINFO T1
          ON T0.L_DATE = T1.L_DATE
         AND T0.VC_INTER_CODE = T1.VC_INTER_CODE
         AND T1.L_DATE BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3'
      UNION ALL
      SELECT CONCAT(T1.VC_REPORT_CODE , '.BOND.' , T2.PARA_HCODE) AS SECU_ID, --证券编码
             NULL AS  pub_dt  , -- 信息发布日期
             NULL AS info_sour,
             T0.L_DATE AS RAT_DT, --评级日期
             T0.RAT_AGY_CODE, --评级机构代码
             T0.RAT_COM_NAME, --评级机构名称
             T0.RAT_TYP, --评级类型
             T0.RAT_NAME, --信用评级
             NULL AS rat_desc,
             NULL AS rat_name_lst,
             NULL AS rat_chg,
             NULL AS rat_expt_typ,
             T0.RAT_SIGN, --评级标识
             T0.L_DATE AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'prc_var_bond_rat_2' AS TASK_RS_ID, --任务来源标识
             'thisbondproperty' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
             NULL AS brek_rate,
             NULL AS brek_defc_rate,
             T0.L_DATE
        FROM (
              --外部债项评级
              SELECT T0.VC_INTER_CODE,
                      T0.C_MARKET_NO,
                      T0.L_DATE, --评级日期
                      T0.VC_APPRAISE_ORGAN AS RAT_AGY_CODE, --评级机构代码
                      T3.VC_ITEM_NAME AS RAT_COM_NAME, --评级机构名称
                      1 AS RAT_TYP, --评级类型
                      T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
                      '1' AS RAT_SIGN --评级标识
                FROM ${ods_db}.O3_TBONDPROPERTY T0
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T3
                  ON T3.L_DICTIONARY_NO = '60200'
                 AND T0.VC_APPRAISE_ORGAN = T3.C_LEMMA_ITEM
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                  ON T4.L_DICTIONARY_NO = '110000'
                 AND T0.C_OUTER_APPRAISE = T4.C_LEMMA_ITEM
               WHERE T0.C_OUTER_APPRAISE IS NOT NULL
                 AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}
              UNION ALL
              --内部债项评级
              SELECT T0.VC_INTER_CODE,
                      T0.C_MARKET_NO,
                      T0.L_DATE, --评级日期
                      'TK' AS RAT_AGY_CODE, --评级机构代码
                      'TK' AS RAT_COM_NAME, --评级机构名称
                      1 AS RAT_TYP, --评级类型
                      T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
                      '3' AS RAT_SIGN --评级标识, --评级标识
                FROM ${ods_db}.O3_TBONDPROPERTY T0
                LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                  ON T4.L_DICTIONARY_NO = '110001'
                 AND T0.C_INSIDE_APPRAISE = T4.C_LEMMA_ITEM
               WHERE T0.C_INSIDE_APPRAISE IS NOT NULL
                 AND T0.L_DATE BETWEEN ${beg_date} AND ${end_date}) T0
        JOIN ${ods_db}.O3_TSTOCKINFO T1
          ON T0.L_DATE = T1.L_DATE
         AND T0.VC_INTER_CODE = T1.VC_INTER_CODE
         AND T1.L_DATE BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3';