------------------------------------------------------------------------
  -- 模块名称：银行间指令抵押品(盘后)
  --指令抵质押品：协议回购
  --债券借贷首期（质押物）
  --债券借贷首期（标的券）
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

alter table ${dwd_db}.evt_inbk_odr_mort_his drop if exists partition (p_dt=${current_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_inbk_odr_mort_his partition(p_dt,sys_rs_id)
(agmt_tnv_no,odr_secu_onum,prd_code,ast_unit_code,pfl_code,pldg_secu_id,pldg_src_secu_id,prov_side,mort_rati,pldg_vol,pldg_par_gamt,pldg_typ,inv_typ,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)

   --指令抵质押品：协议回购
   SELECT NULL AS AGMT_TNV_NO, --合约成交编号
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
          T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
          T1.VC_FUND_CODE AS PRD_CODE, --产品代码
          concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
          concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
          concat(T6.VC_REPORT_CODE , '.BOND.YHJ') AS PLDG_SECU_ID, --质押物证券编码
          T7.VC_INTER_CODE AS PLDG_SRC_SECU_ID, --质押物源证券ID
          T7.C_MORTAGAGE_SIDE AS PROV_SIDE, --提供方
          T7.EN_RATIO / 100 AS MORT_RATI, --质押比例
          T7.L_MORTAGAGE_AMOUNT AS PLDG_VOL, --质押物数量
          T7.L_MORTAGAGE_AMOUNT * T8.EN_CURR_FACE_PRICE AS PLDG_PAR_GAMT, --质押物券面总额
          CASE
            WHEN T5.C_STOCK_TYPE IN ('I') AND T7.C_BAIL_TYPE = '1' THEN
             '2'
            ELSE
             T7.C_BAIL_TYPE
          END AS PLDG_TYP, --质押物类别
          case when T7.C_INVEST_TYPE = '1' then '2'
                      when T7.C_INVEST_TYPE = '2' then '1'
                      when T7.C_INVEST_TYPE = 'a' then '15'
                      when T7.C_INVEST_TYPE = 'b' then '10'
                      when T7.C_INVEST_TYPE = 'c' then '12'
                 else T7.C_INVEST_TYPE
          end AS INV_TYP, --投资类型
          ${current_date} AS BUSI_DATE, --业务日期
          'evt_inbk_odr_mort_real_1' AS TASK_RS_ID, --任务来源标识
          CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
          T0.L_DATE,
          'O3' AS SYS_RS_ID --系统来源标识
     FROM ${ods_db}.O3_TINSTRUCTION T0
    INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
       ON T0.L_DATE = T4.L_DATE
      AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
      AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
     LEFT JOIN ${ods_db}.O3_TCOMBI T3 -- 投资组合基本信息表，获取投资组合代码
       ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
     LEFT JOIN ${ods_db}.O3_TINSTRUCTIONHGMORTAGAGE T7
       ON T0.L_DATE = T7.L_DATE
      AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
     LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
       ON T7.L_FUND_ID = T1.L_FUND_ID
     LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
       ON T3.L_ASSET_ID = T2.L_ASSET_ID
     LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
       ON T4.L_DATE = T5.L_DATE
      AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
     LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
       ON T7.L_DATE = T6.L_DATE
      AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
     LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
          ON T0.L_DATE = w1.dt
         AND T5.C_MARKET_NO = w1.mkt_no
         AND W1.SYS_RS_ID = 'O3'
     LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T8 --债券基本信息表，获取面值
       ON W1.pre_2_dt= T8.L_DATE
      AND T7.VC_INTER_CODE = T8.VC_INTER_CODE
      AND T8.C_MARKET_NO IN ('1', '2')
    WHERE T0.C_BUSIN_CLASS IN ('I')
      AND T4.C_ENTRUST_DIRECTION IN ('15', '16', '17', '18', '37', '38', '35', '36')--15:协议正回购；16：协议逆回购
      AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
      AND T0.L_DATE = ${current_date}

UNION ALL
--指令抵质押品：债券借贷首期（质押物）
SELECT NULL AS AGMT_TNV_NO, --合约成交编号
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CONCAT(T6.VC_REPORT_CODE , '.BL.YHJ') AS PLDG_SECU_ID, --质押物证券编码
       T7.VC_INTER_CODE AS PLDG_SRC_SECU_ID, --质押物源证券ID
       T7.C_MORTAGAGE_SIDE AS PROV_SIDE, --提供方
       T7.EN_RATIO / 100 AS MORT_RATI, --质押比例
       T7.L_MORTAGAGE_AMOUNT AS PLDG_VOL, --质押物数量
       T7.L_MORTAGAGE_AMOUNT * T8.EN_CURR_FACE_PRICE AS PLDG_PAR_GAMT, --质押物券面总额
       '1' AS PLDG_TYP, --质押物类别
       case when T7.C_INVEST_TYPE = '1' then '2'
            when T7.C_INVEST_TYPE = '2' then '1'
            when T7.C_INVEST_TYPE = 'a' then '15'
            when T7.C_INVEST_TYPE = 'b' then '10'
            when T7.C_INVEST_TYPE = 'c' then '12'
       else T7.C_INVEST_TYPE end AS INV_TYP, --投资类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_mort_real_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 -- 投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TINSTRUCTIONHGMORTAGAGE T7
    ON T0.L_DATE = T7.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T7.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
    ON T7.L_DATE = T6.L_DATE
   AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
       ON T0.L_DATE = w1.dt
      AND T5.C_MARKET_NO = w1.mkt_no
      AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T8 --债券基本信息表，获取面值
    ON W1.pre_2_dt = T8.L_DATE
   AND T7.VC_INTER_CODE = T8.VC_INTER_CODE
   AND T8.C_MARKET_NO = '5'
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T4.C_ENTRUST_DIRECTION IN ('?', '-') --？:债券融入；-：债券融出
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令抵质押品：债券借贷首期（标的券）
SELECT NULL AS AGMT_TNV_NO, --合约成交编号
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CONCAT(T6.VC_REPORT_CODE , '.BL.YHJ') AS PLDG_SECU_ID, --质押物证券编码
       T7.VC_INTER_CODE AS PLDG_SRC_SECU_ID, --质押物源证券ID
       CASE
         WHEN T4.C_ENTRUST_DIRECTION IN ('?') THEN
          '2'
         WHEN T4.C_ENTRUST_DIRECTION IN ('-') THEN
          '1'
       END AS PROV_SIDE, --提供方
       1 AS MORT_RATI, --质押比例
       T7.L_AMOUNT AS PLDG_VOL, --质押物数量
       T7.L_AMOUNT * T8.EN_CURR_FACE_PRICE AS PLDG_PAR_GAMT, --质押物券面总额
       '2' AS PLDG_TYP, --质押物类别
       case when T7.C_INVEST_TYPE = '1' then '2'
            when T7.C_INVEST_TYPE = '2' then '1'
            when T7.C_INVEST_TYPE = 'a' then '15'
            when T7.C_INVEST_TYPE = 'b' then '10'
            when T7.C_INVEST_TYPE = 'c' then '12'
       else T7.C_INVEST_TYPE end AS INV_TYP, --投资类型
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_mort_real_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 -- 投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T7
    ON T0.L_DATE = T7.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
   AND T7.C_ENTRUST_DIRECTION IN ('3','4')
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T7.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
    ON T7.L_DATE = T6.L_DATE
   AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
       ON T0.L_DATE = w1.dt
      AND T5.C_MARKET_NO = w1.mkt_no
      AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T8 --债券基本信息表，获取面值
    ON W1.pre_2_dt = T8.L_DATE
   AND T7.VC_INTER_CODE = T8.VC_INTER_CODE
   AND T8.C_MARKET_NO = '5'
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T4.C_ENTRUST_DIRECTION IN ('?', '-') --？:债券融入；-：债券融出
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
   AND T0.L_DATE = ${current_date}