------------------------------------------------------------------------
  -- 模块名称：证券O32扩展资料信息
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

alter table ${dwd_db}.var_min_trd_unit drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.var_min_trd_unit partition(sys_rs_id)
(
secu_id,
occu_dt,
buy_min_unit,
sell_min_unit,
unit_prc,
lmtu_prc,
lmtd_prc,
min_vol_lmt,
mkt_min_vol_lmt,
o32_ast_clas,
o32_secu_clas,
o32_mix_typ,
o32_tran_clas,
busi_date,
task_rs_id,
dm_created_time,
sys_rs_id
)
SELECT
    CASE
                   WHEN A.C_ASSET_CLASS = '2' THEN
                    CONCAT(A.VC_REPORT_CODE , '.STK.' , (CASE
                      WHEN A.C_MARKET_NO = '1' THEN
                       'SH'
                      WHEN A.C_MARKET_NO = '2' THEN
                       'SZ'
                      WHEN A.C_MARKET_NO = 'n' then
                       'SHSC'
                      WHEN A.C_MARKET_NO = 'o' THEN
                       'SZSC'
                      when A.C_MARKET_NO = 'j' then (case when NVL(A.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
                      when A.C_MARKET_NO = 'r' then 'BJ'
                      else A.C_MARKET_NO
                    END)) --股票
                   WHEN A.C_ASSET_CLASS = '3' THEN
                    CONCAT(A.VC_REPORT_CODE , '.BOND.' , (CASE
                      WHEN A.C_MARKET_NO = '1' THEN
                       'SH'
                      WHEN A.C_MARKET_NO = '2' THEN
                       'SZ'
                       WHEN A.C_MARKET_NO = '6' then
                       'NONE'
                       WHEN A.C_MARKET_NO = '5' then
                       'YHJ'
                       else A.C_MARKET_NO
                    END)) --债券
                   WHEN A.C_ASSET_CLASS = '4' THEN
                    CONCAT(A.VC_REPORT_CODE , '.FUND.' , (CASE
                      WHEN A.C_MARKET_NO = '1' THEN
                       'SH'
                      WHEN A.C_MARKET_NO = '2' THEN
                       'SZ'
                      WHEN A.C_MARKET_NO = '6' THEN
                      'NONE'
                      else A.C_MARKET_NO
                    END)) --基金
                   WHEN A.C_ASSET_CLASS = '5' THEN
                      CONCAT(A.VC_REPORT_CODE , '.REPO.' , (CASE
                       WHEN A.C_MARKET_NO = '5' THEN
                         'YHJ'
                       WHEN A.C_MARKET_NO = '2' THEN
                         'SZ'
                       WHEN A.C_MARKET_NO = '1' THEN
                         'SH'
                    END)) --回购
                   WHEN A.C_ASSET_CLASS IN ('6') AND
                        A.C_STOCK_TYPE in ('{', 'h', 'd', 'a', 'b') THEN --{优先股、h配股、d增发、a股票申购、b申购款
                        CONCAT(A.VC_REPORT_CODE , '.STK.' , (CASE
                                                                  WHEN A.C_MARKET_NO = '1' THEN
                                                                       'SH'
                                                                  WHEN A.C_MARKET_NO = '2' THEN
                                                                       'SZ'
                                                                  WHEN A.C_MARKET_NO = 'n' then
                                                                       'SHSC'
                                                                  WHEN A.C_MARKET_NO = 'o' THEN
                                                                       'SZSC'
                                                                  when A.C_MARKET_NO = 'j' then (case when NVL(A.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
                                                                  when A.C_MARKET_NO = 'r' then 'BJ'
                                                                  else A.C_MARKET_NO
                                                             END))
                   WHEN A.C_ASSET_CLASS IN ('6') AND
                        A.C_STOCK_TYPE in
                             ('y', 'Q', 'm', 'l', 'k', 'j', 'C', 'b', 'B') THEN --y债回售、Q债券质押,m债券配号,l债券申购款,k债券申购,j债券承销、C配债、B债转股
                        CONCAT(A.VC_REPORT_CODE , '.BOND.' , (CASE
                                                                   WHEN A.C_MARKET_NO = '1' THEN
                                                                        'SH'
                                                                   WHEN A.C_MARKET_NO = '2' THEN
                                                                        'SZ'
                                                                   WHEN A.C_MARKET_NO = '6' then
                                                                        'NONE'
                                                                   WHEN A.C_MARKET_NO = '5' then
                                                                        'YHJ'
                                                                   else A.C_MARKET_NO
                                                              END))
                   WHEN A.C_ASSET_CLASS = '6' AND A.C_STOCK_TYPE = 'z'  THEN
                      CONCAT(A.VC_REPORT_CODE , '.IB.', (CASE
                                                                  WHEN A.C_MARKET_NO = '1' THEN
                                                                       'SH'
                                                                  WHEN A.C_MARKET_NO = '2' THEN
                                                                       'SZ'
                                                                  WHEN A.C_MARKET_NO = '5' then
                                                                       'YHJ'
                                                             END)) --信用拆借
                   WHEN A.C_ASSET_CLASS = '6' AND A.C_STOCK_TYPE = '+'  THEN
                      CONCAT(A.VC_REPORT_CODE , '.LB.', (CASE
                                                                  WHEN A.C_MARKET_NO = '1' THEN
                                                                       'SH'
                                                                  WHEN A.C_MARKET_NO = '2' THEN
                                                                       'SZ'
                                                                  WHEN A.C_MARKET_NO = '5' then
                                                                       'YHJ'
                                                             END)) --债券借贷
                   WHEN A.C_ASSET_CLASS = '6' AND A.C_STOCK_TYPE IN ('I','8','-')  THEN
                      CONCAT(A.VC_REPORT_CODE , '.REPO.', (CASE
                                                                  WHEN A.C_MARKET_NO = '1' THEN
                                                                       'SH'
                                                                  WHEN A.C_MARKET_NO = '2' THEN
                                                                       'SZ'
                                                                  WHEN A.C_MARKET_NO = '5' then
                                                                       'YHJ'
                                                             END)) --回购
                   WHEN A.C_ASSET_CLASS = '7' THEN
                    CONCAT(A.VC_REPORT_CODE , '.WRNT.' , (CASE
                      WHEN A.C_MARKET_NO = 'n' then
                       'SHSC'
                      WHEN A.C_MARKET_NO = 'o' THEN
                       'SZSC'
                       else A.C_MARKET_NO
                    END)) --权证
                   WHEN A.C_ASSET_CLASS = '9' THEN
                    CONCAT(A.VC_REPORT_CODE , '.FUT.' , (CASE
                      WHEN A.C_MARKET_NO = '1' THEN
                       'SH'
                      WHEN A.C_MARKET_NO = '2' THEN
                       'SZ'
                      WHEN A.C_MARKET_NO = '7' THEN
                       'CFFEX'
                      else A.C_MARKET_NO
                    END))
                   else A.VC_INTER_CODE
                 END AS SECU_ID, --证券编码
    A.l_date as OCCU_DT,--发生日期
    A.l_buy_unit as BUY_MIN_UNIT,--买入最小单位
    A.l_sale_unit as SELL_MIN_UNIT,--卖出最小单位
    A.en_last_price as UNIT_PRC,--单位价格
    A.EN_UPLIMITED_PRICE AS LMTU_PRC,--涨停板价格
    A.EN_DOWNLIMITED_PRICE AS LMTD_PRC,--跌停板价格
    A.L_DOWNLIMITED_AMOUNT AS MIN_VOL_LMT,--最低数量限额
    A.L_DOWNLIMITED_AMOUNT_SJ AS MKT_MIN_VOL_LMT,--市价最低数量限额
    C.para_hcode AS O32_AST_CLAS,--O32_资产类型
    D.para_hcode AS O32_SECU_CLAS,--O32_证券类型
    A.VC_MIXED_TYPE AS O32_MIX_TYP,--杂项分类
    F.para_hcode  AS O32_TRAN_CLAS,--O32_转让类型
    ${current_date} as BUSI_DATE, --业务日期
    'var_min_trd_unit_1' as TASK_RS_ID, --任务来源标识
    current_timestamp as DM_CREATED_TIME, --数据中台创建时间
    'O3' as SYS_RS_ID --系统来源标识
FROM ${ods_db}.o3_TSTOCKINFO A
INNER JOIN ${ods_db}.o3_TSTOCKTYPE ST ON A.C_MARKET_NO = ST.C_MARKET_NO AND A.C_STOCK_TYPE = ST.C_STOCK_TYPE
LEFT JOIN ${dwd_db}.pub_para_mapping as C ON C.orisys_para_code = A.C_ASSET_CLASS AND C.para_class_hcode = 'v2001'
LEFT JOIN ${dwd_db}.pub_para_mapping as D ON D.orisys_para_code = A.C_STOCK_TYPE AND D.para_class_hcode = 'v2002'
LEFT JOIN ${dwd_db}.pub_para_mapping as F ON F.orisys_para_code = A.C_ATTORN_TYPE AND F.para_class_hcode = 'v2003'
where A.C_ASSET_CLASS in ('2','3','4','6','7','9');