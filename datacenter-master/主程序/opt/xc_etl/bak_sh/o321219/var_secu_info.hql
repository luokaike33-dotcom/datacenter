------------------------------------------------------------------------
-- 模块名称：证券基本信息表
-- lucas：20221229改为全量加工，盘后任务和T-1相同
-- lucas：20230424删除盘后脚本，添加转融券股票部分券信息
------------------------------------------------------------------------
----set hive.vectorized.execution.enabled=FALSE;
----set hive.strict.checks.type.safety=FALSE;
----set hive.exec.dynamic.partition.mode=nonstrict;
----set hive.execution.engine=spark;
----set hive.exec.max.dynamic.partitions.pernode=10000;
----set hive.exec.max.dynamic.partitions=10000;
----set hive.exec.max.created.files=10000;
----set hive.merge.sparkfiles=TRUE;
----set hive.optimize.sort.dynamic.partition=TRUE;
----set hive.merge.orcfile.stripe.level=FALSE;
----set spark.memory.fraction=0.8;
----set hive.exec.dynamic.partition=TRUE;
----set hive.crud.dynamic.partition=TRUE;
----set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=TRUE;

WITH TMP_TABLE AS
  (
 --基础全部券
 SELECT T0.L_COMPANY_ID AS COM_ID, --发行机构编号
 T3.VC_ISSUER_NAME AS COM_NAME, --公司名称
 CASE
     WHEN T0.C_ASSET_CLASS IN ('2') THEN CONCAT(T0.VC_REPORT_CODE, '.STK.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('3') THEN CONCAT(T0.VC_REPORT_CODE, '.BOND.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('4') THEN CONCAT(T0.VC_REPORT_CODE, '.FUND.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('7') THEN CONCAT(T0.VC_REPORT_CODE, '.WRNT.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('9') THEN CONCAT(T0.VC_REPORT_CODE, '.FUT.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('6')
          AND T0.C_STOCK_TYPE IN ('{',
                                  'h',
                                  'd',
                                  'a',
                                  'b') THEN --{优先股、h配股、d增发、a股票申购、b申购款
 CONCAT(T0.VC_REPORT_CODE, '.STK.', T2.PARA_HCODE)
     WHEN T0.C_ASSET_CLASS IN ('6')
          AND T0.C_STOCK_TYPE IN ('y',
                                  'Q',
                                  'm',
                                  'l',
                                  'k',
                                  'j',
                                  'C',
                                  'b',
                                  'B') THEN --y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股
 CONCAT(T0.VC_REPORT_CODE, '.BOND.', T2.PARA_HCODE)
 END AS SECU_ID, --证券编码
 T0.VC_REPORT_CODE AS TRD_CODE, --交易代码
 T0.VC_STOCK_NAME AS SECU_SHT, --中文简称
 T0.VC_STOCK_FULLNAME AS CHI_NAME, --中文名称
 T0.VC_STOCK_SPELL AS PY_SHT, --中文拼音简称
 T2.PARA_HCODE AS EXCH_CODE, --交易市场代码
 T2.PARA_NAME AS EXCH_NAME, --交易市场名称
 CASE
     WHEN T0.C_ASSET_CLASS IN ('2') THEN 'STK'
     WHEN T0.C_ASSET_CLASS IN ('3') THEN 'BOND'
     WHEN T0.C_ASSET_CLASS IN ('4') THEN 'FUND'
     WHEN T0.C_ASSET_CLASS IN ('9') THEN 'FUT'
     WHEN T0.C_ASSET_CLASS IN ('7') THEN 'WRNT'
     WHEN T0.C_ASSET_CLASS IN ('6')
          AND T0.C_STOCK_TYPE IN ('{',
                                  'h',
                                  'd',
                                  'a',
                                  'b') THEN --{优先股、h配股、d增发、a股票申购、b申购款
 'STK'
     WHEN T0.C_ASSET_CLASS IN ('6')
          AND T0.C_STOCK_TYPE IN ('y',
                                  'Q',
                                  'm',
                                  'l',
                                  'k',
                                  'j',
                                  'C',
                                  'b',
                                  'B') THEN --y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股
 'BOND'
 END AS TYP_CODE, --证券类别代码（大类）
 NULL AS TYP_CODEI, --证券类别代码（中类）
 NULL AS TYP_CODEII, --证券类别代码（细分）
 T0.EN_FACE_VALUES AS PAR_VAL, --面值
 T0.L_LISTING_DATE AS LST_DT, --上市日期
 NULL AS DLST_DT, --终止上市日期
 T0.VC_INTERNATIONAL_CODE AS ISIN_CODE, --ISIN代码
 T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
 T0.VC_ISSUE_COUNTRY AS NATI, --国家
 (CASE
      WHEN T0.VC_trade_CURRENCY_NO IN ('HK1',
                                       'HK2') THEN 'HKD'
      ELSE T0.VC_trade_CURRENCY_NO
  END) AS TRD_CURR_CODE, --交易币种
 'thisstockinfo' AS dm_src_info
   FROM
     (SELECT T0.*,
             row_number() over(partition BY T0.VC_report_CODE,T0.C_MARKET_NO
                               ORDER BY T0.l_date DESC) rn
      FROM
        (SELECT *
         FROM ${ods_db}.O3_THISSTOCKINFO T0
         WHERE T0.C_ASSET_CLASS IN ('2',
                                    '3',
                                    '4',
                                    '7',
                                    '9')
         UNION ALL SELECT *
         FROM ${ods_db}.O3_THISSTOCKINFO T0
         WHERE T0.C_ASSET_CLASS IN ('6')
           AND EXISTS
             (SELECT 1
              FROM ${ods_db}.O3_THISSTOCKINFO T1
              WHERE NVL(T1.C_ASSET_CLASS, '999') NOT IN ('2',
                                                         '3',
                                                         '4')
                AND T0.VC_ASSET_RELATIVE_CODE = T1.VC_INTER_CODE
                AND T0.L_DATE = T1.L_DATE )
           AND (T0.C_STOCK_TYPE IN ('{',
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
                                    'B')--{优先股、h配股、d增发、a股票申购、b申购款、y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股

                OR (T0.C_ASSET_CLASS IN ('6')
                    AND T0.C_STOCK_TYPE IN ('50'))) ) T0 ) T0
   JOIN ${dwd_db}.PUB_PARA_MAPPING T2 ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
   AND T2.PARA_CLASS_HCODE = '4'
   AND T2.ORISYS_HCODE = 'HSO3'
   LEFT JOIN ${ods_db}.O3_TISSUER T3 ON T0.L_COMPANY_ID = T3.L_ISSUER_ID
   WHERE t0.rn = 1
   
  
   UNION ALL
 --补充银行间回购
 SELECT T0.L_COMPANY_ID AS COM_ID, --发行机构编号
 T3.VC_ISSUER_NAME AS COM_NAME, --公司名称
 CASE
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = '8'
          AND VC_REPORT_CODE LIKE 'R%' THEN CONCAT(VC_REPORT_CODE,'.REPO.YHJ')
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = 'I'
          AND VC_REPORT_CODE LIKE 'OR%' THEN CONCAT(VC_REPORT_CODE,'.REPO.YHJ')
     WHEN t0.c_asset_class = 6
          AND T0.C_STOCK_TYPE = '+' THEN CONCAT(VC_REPORT_CODE,'.BL.YHJ')
 END AS SECU_ID, --证券编码
 T0.VC_REPORT_CODE AS TRD_CODE, --交易代码
 T0.VC_STOCK_NAME AS SECU_SHT, --中文简称
 T0.VC_STOCK_FULLNAME AS CHI_NAME, --中文名称
 T0.VC_STOCK_SPELL AS PY_SHT, --中文拼音简称
 T2.PARA_HCODE AS EXCH_CODE, --交易市场代码
 T2.PARA_NAME AS EXCH_NAME, --交易市场名称
 CASE
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = '8'
          AND VC_REPORT_CODE LIKE 'R%' THEN 'REPO'
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = 'I'
          AND VC_REPORT_CODE LIKE 'OR%' THEN 'REPO'
     WHEN t0.c_asset_class = 6
          AND T0.C_STOCK_TYPE = '+' THEN 'BL'
 END AS TYP_CODE, --证券类别代码（大类）
 CASE
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = '8'
          AND VC_REPORT_CODE LIKE 'R%' THEN 'REPO101'
     WHEN T0.C_STOCK_TYPE = 'I'
          AND VC_REPORT_CODE LIKE 'OR%' THEN 'REPO102'
     WHEN t0.c_asset_class = 6
          AND T0.C_STOCK_TYPE = '+' THEN 'BL101'
 END AS TYP_CODEI, --证券类别代码（中类）
 CASE
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = '8'
          AND VC_REPORT_CODE LIKE 'R%' THEN 'REPO10101'
     WHEN t0.c_asset_class = 5
          AND T0.C_STOCK_TYPE = 'I'
          AND VC_REPORT_CODE LIKE 'OR%' THEN 'REPO10201'
     WHEN t0.c_asset_class = 6
          AND T0.C_STOCK_TYPE = '+' THEN 'BL10101'
 END AS TYP_CODEII, --证券类别代码（细分）
 T0.EN_FACE_VALUES AS PAR_VAL, --面值
 T0.L_LISTING_DATE AS LST_DT, --上市日期
 NULL AS DLST_DT, --终止上市日期
 T0.VC_INTERNATIONAL_CODE AS ISIN_CODE, --ISIN代码
 T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
 T0.VC_ISSUE_COUNTRY AS NATI, --国家
 (CASE
      WHEN T0.VC_trade_CURRENCY_NO IN ('HK1',
                                       'HK2') THEN 'HKD'
      ELSE T0.VC_trade_CURRENCY_NO
  END) AS TRD_CURR_CODE, --交易币种
 'thisstockinfo-yhj' AS dm_src_info
   FROM ${ods_db}.o3_tstockinfo t0
   JOIN ${dwd_db}.PUB_PARA_MAPPING T2 ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
   AND T2.PARA_CLASS_HCODE = '4'
   AND T2.ORISYS_HCODE = 'HSO3'
   LEFT JOIN ${ods_db}.o3_tissuer T3 ON T0.L_COMPANY_ID = T3.L_ISSUER_ID
   WHERE (t0.c_asset_class = 5
          AND C_STOCK_TYPE IN ('8',
                               'I')
          AND (VC_REPORT_CODE LIKE 'R%'
               OR VC_REPORT_CODE LIKE 'OR%'))
     OR (t0.c_asset_class = 6
         AND C_STOCK_TYPE IN ('+'))
 ),
 var_secu_info_o32_tmp AS
  (SELECT cast(b.com_id AS string) AS com_id, --发行机构编号
 b.com_name,
 b.secu_id, --证券编码
 b.trd_code, --交易代码
 b.secu_sht, --中文简称
 b.chi_name, --中文名称
 '' AS name_sht,
 b.py_sht, --中文拼音简称
 '' AS eng_name,
 '' AS eng_sht,
 b.exch_code, --交易市场代码
 b.exch_name, --交易市场名称
 b.typ_code, --证券类别代码（大类）
 b.typ_codei, --证券类别代码（中类）
 b.typ_codeii, --证券类别代码（细分）
 '' AS typ_desc,
 '' AS secu_var,
 b.par_val, --面值
 cast(b.lst_dt AS bigint) AS lst_dt, --上市日期
 cast(b.dlst_dt AS bigint) AS dlst_dt, --终止上市日期
 '' AS lst_sect_code,
 '' AS lst_sect_name,
 '' AS lst_sts_code,
 b.isin_code, --isin代码
 b.curr_code, --货币代码
 '' AS main_secu_id,
 b.nati, --国家
 cast(b.dlst_dt AS bigint) AS end_dt, --到期日
 b.trd_curr_code, --交易币种
 date_format(CURRENT_TIMESTAMP, 'yyyyMMdd') AS busi_date, --业务日期
 NULL AS upd_time, --源数据修改时间
 'O3' AS sys_rs_id, --系统来源标识
 'var_secu_info_o32_1' AS task_rs_id, --任务来源标识
 b.dm_src_info, --来源信息
 CURRENT_DATE AS dm_created_time, --数据中台创建时间
 'OUTLINE' AS dm_created_by, --数据中台创建者
 CURRENT_DATE AS dm_updated_time, --数据中台更新时间
 'OUTLINE' AS dm_updated_by --数据中台更新者

   FROM TMP_TABLE b )
INSERT overwrite TABLE ${dwd_db}.var_secu_info_o32 partition (sys_rs_id)
SELECT DISTINCT secu_id,
                com_id,
                com_name,
                trd_code,
                secu_sht,
                chi_name,
                name_sht,
                py_sht,
                eng_name,
                eng_sht,
                exch_code,
                exch_name,
                typ_code,
                typ_codei,
                typ_codeii,
                typ_desc,
                par_val,
                lst_dt,
                dlst_dt,
                lst_sect_code,
                lst_sect_name,
                lst_sts_code,
                isin_code,
                curr_code,
                trd_curr_code,
                main_secu_id,
                nati,
                end_dt,
                busi_date,
                upd_time,
                task_rs_id,
                dm_src_info,
                dm_created_time,
                dm_created_by,
                dm_updated_time,
                dm_updated_by,
                sys_rs_id
FROM var_secu_info_o32_tmp;


ALTER TABLE ${dwd_db}.var_secu_info
DROP IF EXISTS partition (sys_rs_id = 'O3');


INSERT INTO ${dwd_db}.var_secu_info partition(sys_rs_id) (secu_id, --证券编码
 com_id, --发行机构编号
 com_name, --公司名称
 trd_code, --交易代码
 secu_sht, --中文简称
 chi_name, --中文名称
 name_sht, --中文名称缩写
 py_sht, --中文拼音简称
 eng_name, --证券英文名称
 exch_code, --交易市场代码
 exch_name, --交易市场名称
 typ_code, --证券类别代码（大类）
 typ_code_desc, --证券类别代码（大类）描述
 typ_codei, --证券类别代码（中类）
 typ_codei_desc, --证券类别代码（中类）描述
 typ_codeii, --证券类别代码（细分）
 typ_codeii_desc, --证券类别代码（细分）描述
 typ_desc, --证券类别描述
 secu_var,--证券品种
 par_val, --面值
 lst_dt, --上市日期
 dlst_dt, --终止上市日期
 lst_sect_code, --上市板块代码
 lst_sect_name, --上市板块名称
 lst_sts_code, --上市状态代码
 isin_code, --isin代码
 curr_code, --货币代码
 main_secu_id, --证券主编码
 nati, --国家
 end_dt, --到期日
 busi_date, --业务日期
 task_rs_id, --任务来源标识
 dm_created_time, --数据中台创建时间
 sys_rs_id)
SELECT DISTINCT t1.secu_id,
       t1.com_id,
       t1.com_name,
       t1.trd_code,
       t1.secu_sht,
       t1.chi_name,
       t1.name_sht,
       t1.py_sht,
       t1.eng_name,
       t1.exch_code,
       t1.exch_name,
       t1.typ_code,
       t3.para_cname,
       t1.typ_codei,
       t4.para_cname,
       t1.typ_codeii,
       t5.para_cname,
       t1.typ_desc,
       NULL AS secu_var,
       t1.par_val,
       t1.lst_dt,
       t1.dlst_dt,
       t1.lst_sect_code,
       t1.lst_sect_name,
       t1.lst_sts_code,
       t1.isin_code,
       t1.curr_code,
       t1.main_secu_id,
       t1.nati,
       t1.end_dt,
       t1.busi_date,
       t1.task_rs_id,
       t1.dm_created_time,
       'O3' AS sys_rs_id
FROM ${dwd_db}.var_secu_info_o32 t1
LEFT JOIN ${dwd_db}.var_secu_info t2 ON t1.secu_id = t2.secu_id
LEFT JOIN ${dwd_db}.pub_para_info t3 ON t1.typ_code = t3.para_hcode AND T3.PARA_CLASS_HCODE = '1'
LEFT JOIN ${dwd_db}.pub_para_info t4 ON t1.typ_codei = t4.para_hcode AND T4.PARA_CLASS_HCODE = '2'
LEFT JOIN ${dwd_db}.pub_para_info t5 ON t1.typ_codeii = t5.para_hcode AND T5.PARA_CLASS_HCODE = '3'
WHERE t2.secu_id IS NULL AND T1.SECU_ID IS NOT NULL;

