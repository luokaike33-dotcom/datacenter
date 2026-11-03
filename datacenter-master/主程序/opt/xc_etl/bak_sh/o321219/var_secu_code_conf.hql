------------------------------------------------------------------------
  -- 模块名称：证券代码配置表
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

alter table ${dwd_db}.var_secu_code_conf drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_secu_code_conf partition(p_dt)
SELECT T0.L_DATE AS occu_dt,
               CASE
                 WHEN T0.C_ASSET_CLASS IN ('2') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.STK.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_ASSET_CLASS IN ('3') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.BOND.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_ASSET_CLASS IN ('4') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.FUND.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_ASSET_CLASS IN ('7') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.WRNT.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_STOCK_TYPE IN ('8') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.REPO.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_ASSET_CLASS IN ('9') THEN
                  CONCAT(T0.VC_REPORT_CODE , '.FUT.' , NVL(T2.PARA_HCODE,''))
                 WHEN T0.C_ASSET_CLASS IN ('6') AND
                      T0.C_STOCK_TYPE in ('{', 'h', 'd', 'a', 'b') THEN --{优先股、h配股、d增发、a股票申购、b申购款
                  CONCAT(T0.VC_REPORT_CODE , '.STK.' , T2.PARA_HCODE)
                 WHEN T0.C_ASSET_CLASS IN ('6') AND
                      T0.C_STOCK_TYPE in
                      ('y', 'Q', 'm', 'l', 'k', 'j', 'C', 'b', 'B') THEN --y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股
                  CONCAT(T0.VC_REPORT_CODE , '.BOND.' , T2.PARA_HCODE)
               END AS SECU_ID, --证券编码
               T0.VC_STOCK_NAME AS CHI_NAME, --证券名称
               T0.VC_REPORT_CODE as SECU_CODE, --证券代码
               T2.PARA_HCODE AS EXCH_CODE, --交易市场
               CASE
                 WHEN T0.C_ASSET_CLASS IN ('2') THEN
                  'STK'
                 WHEN T0.C_ASSET_CLASS IN ('3') THEN
                  'BOND'
                 WHEN T0.C_ASSET_CLASS IN ('4') THEN
                  'FUND'
                 WHEN T0.C_ASSET_CLASS IN ('7') THEN
                  'WRNT'
                 WHEN T0.C_STOCK_TYPE IN ('8') THEN
                  'REPO'
                 WHEN T0.C_ASSET_CLASS IN ('9') THEN
                  'FUT'
                 WHEN T0.C_ASSET_CLASS IN ('6') AND
                      T0.C_STOCK_TYPE in ('{', 'h', 'd', 'a', 'b') THEN --{优先股、h配股、d增发、a股票申购、b申购款
                  'STK'
                 WHEN T0.C_ASSET_CLASS IN ('6') AND
                      T0.C_STOCK_TYPE in
                      ('y', 'Q', 'm', 'l', 'k', 'j', 'C', 'b', 'B') THEN --y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股
                  'BOND'
               END AS TYP_CODE, --证券类别代码（大类）
               T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券代码
               T0.C_MARKET_NO AS SRC_EXCH_CODE, --源交易市场
               t0.C_ASSET_CLASS AS SRC_SECU_CLASS, --源资产分类
               t0.C_STOCK_TYPE as SRC_SECU_TYPE, --源证券类别
               t0.VC_MIXED_TYPE AS SRC_OTH_CLASS, --源杂项分类
               'O3' AS SYS_RS, --源数据更新时间
               NULL AS UPD_TIME, --源数据更新时间
               'O3' AS SYS_RS_ID, --系统来源标识
               'prc_var_secu_code_conf' AS TASK_RS_ID, --任务来源标识
               'tstockinfo' AS DM_SRC_INFO, --来源信息
               CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
               'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
               CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
               'OUTLINE' AS DM_UPDATED_BY,
               T0.L_DATE
          FROM
          (select * from
          ${ods_db}.O3_THISSTOCKINFO T0
          where
          T0.C_ASSET_CLASS IN ('2', '3', '4', '7', '9')
               OR T0.C_STOCK_TYPE = '8'
              union all
              select * from
          ${ods_db}.O3_THISSTOCKINFO T0
          where
          T0.C_ASSET_CLASS IN ('6') AND EXISTS
                (SELECT 1
                    FROM ${ods_db}.O3_THISSTOCKINFO T1
                   WHERE NVL(T1.C_ASSET_CLASS, '999') NOT IN ('2', '3', '4')
                     AND T0.VC_ASSET_RELATIVE_CODE = T1.VC_INTER_CODE
                     AND T0.L_DATE = T1.L_DATE
                     AND T1.L_DATE between ${beg_date} and ${end_date}) AND
                T0.C_STOCK_TYPE IN ('{',
                                     'h',
                                     'd',
                                     'a',
                                     'b',
                                     'y',
                                     'Q',
                                     'm',
                                     'l',
                                     'k',
                                     'j',
                                     'C',
                                     'b',
                                     'B') --{优先股、h配股、d增发、a股票申购、b申购款、y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股

          ) T0
          LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T1
            ON T0.L_DATE = T1.L_DATE
           AND T0.VC_ASSET_RELATIVE_CODE = T1.VC_INTER_CODE
           AND T1.C_ASSET_CLASS IN ('2', '3', '4')
           AND T1.L_DATE BETWEEN ${beg_date} AND ${end_date}
          LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
            ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
           AND T2.PARA_CLASS_HCODE = '4'
           AND T2.ORISYS_HCODE = 'HSO3'
         WHERE   T0.L_DATE BETWEEN ${beg_date} AND ${end_date};
