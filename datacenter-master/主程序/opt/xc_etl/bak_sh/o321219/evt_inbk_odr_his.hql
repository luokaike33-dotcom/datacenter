------------------------------------------------------------------------
  -- 模块名称：银行间指令表(离线)
  --指令：银行间现券
  --指令：质押式回购首期/信用拆借首期/买断式回购首期
  --指令：银行间债回售
  --指令：债券借贷首期
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

alter table ${dwd_db}.evt_inbk_odr_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_inbk_odr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,odr_onum,odr_clas,odr_rela_dt,odr_strt_dt,odr_end_dt,odr_strt_time,odr_end_time,odr_secu_ctrl_clas,odr_secu_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,inv_typ,busi_typ,busi_clas,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,entr_dir,odr_prc,rat,odr_vol,odr_val,bgng_has_entr_vol,bgng_has_entr_val,bgng_has_tnv_vol,bgng_has_tnv_val,entr_vol,entr_val,tnv_vol,tnv_val,trd_cntp_id,deli_dt,rela_rrsn,agt_rela_rrsn,memo,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,fir_net_prc,end_net_prc,fir_hd_intr,end_hd_intr,buyb_val,intr,repo_use_typ,odr_stat,delr_id,exer_yld,ytm,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--指令：银行间现券
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_SECU_CTRL_CLAS, --指令证券控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODRE_SCR_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.BOND.YHJ' , '_' ,
       (case when T4.C_INVEST_TYPE = '1' then '2'
             when T4.C_INVEST_TYPE = '2' then '1'
             when T4.C_INVEST_TYPE = 'a' then '15'
             when T4.C_INVEST_TYPE = 'b' then '10'
             when T4.C_INVEST_TYPE = 'c' then '12'
        else T4.C_INVEST_TYPE end) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('3') THEN
          '01000200'
         WHEN T4.C_ENTRUST_DIRECTION in ('4') THEN
          '01000201'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '010002' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('3') THEN
          '01000200'
         WHEN T4.C_ENTRUST_DIRECTION in ('4') THEN
          '01000201'
       END AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       --SF_OFFSET_TRADEDAY(GREATEST(T0.L_BEGIN_DATE, T0.L_DATE), T0.L_SETTLE_SPEED, 2, T5.C_MARKET_NO, 2)
	   case when T0.L_SETTLE_SPEED = 0 then W1.aft_1_dt
	        when T0.L_SETTLE_SPEED = 1 then W1.aft_2_dt
			when T0.L_SETTLE_SPEED = 2 then W1.aft_3_dt
	   end AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS FIR_NET_PRC, --首期净价价格
       NULL AS END_NET_PRC, --到期净价价格
       NULL AS FIR_HD_INTR, --首期百元利息
       NULL AS END_HD_INTR, --到期百元利息
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS REPO_USE_TYP, --回购用途类别
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T4.en_profit_ratio AS EXER_YLD,--行权收益率
       T4.en_profit_ratio2 AS YTM,--到期收益率
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_his_1' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('2') --tdictionary 40396
   AND T4.C_ENTRUST_DIRECTION IN ('3', '4') --tentrustdicrtion
   AND T4.C_SECOND_SETTLE_TYPE IS NULL
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：质押式回购首期/信用拆借首期/买断式回购首期
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_SECU_CTRL_CLAS, --指令证券控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODRE_SCR_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ' , '_' ,
       (case when T4.C_INVEST_TYPE = '1' then '2'
             when T4.C_INVEST_TYPE = '2' then '1'
             when T4.C_INVEST_TYPE = 'a' then '15'
             when T4.C_INVEST_TYPE = 'b' then '10'
             when T4.C_INVEST_TYPE = 'c' then '12'
        else T4.C_INVEST_TYPE end) , '_' , (CASE
         WHEN T5.C_STOCK_TYPE IN ('8') THEN
          '02000200'
         WHEN T5.C_STOCK_TYPE IN ('I') THEN
          '03000200'
         WHEN T5.C_STOCK_TYPE = 'z' THEN
          '24000200'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_STOCK_TYPE IN ('8') THEN
          '020002'
         WHEN T5.C_STOCK_TYPE IN ('I') THEN
          '030002'
         WHEN T5.C_STOCK_TYPE = 'z' THEN
          '240002'
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T5.C_STOCK_TYPE IN ('8') THEN
          '02000200'
         WHEN T5.C_STOCK_TYPE IN ('I') THEN
          '03000200'
         WHEN T5.C_STOCK_TYPE = 'z' THEN
          '24000200'
       END AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.REPO.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T4.C_ENTRUST_DIRECTION IN ('5') THEN
          'S'
         WHEN T4.C_ENTRUST_DIRECTION IN ('6') THEN
          'L'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       T4.EN_FACT_PRICE AS ODR_PRC, --指令价格
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          T4.EN_DAY_AVG_PRICE / 100
         ELSE
          T4.EN_PRICE1 / 100
       END AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T0.L_HG_DAYS AS CONT_DAYS, --合约天数
       date_format(cast(T0.L_SECOND_SETTLE_DATE as string), 'YYYYMMDD') - date_format(cast(T0.L_FIRST_SETTLE_DATE as string), 'YYYYMMDD') AS INTA_DAYS, --计息天数
       T0.L_DATE AS CONT_TNV_DT, --合约成交日期
       w1.aft_1_dt as CONT_END_DT, --合约到期日期
	   T0.L_FIRST_SETTLE_DATE AS FIR_DELI_DT, --首期交割日期
       T0.L_SECOND_SETTLE_DATE AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       T8.EN_FACT_PRICE AS FIR_NET_PRC, --首期净价价格
       T8.EN_INTEREST AS END_NET_PRC, --到期净价价格
       T9.EN_FACT_PRICE AS FIR_HD_INTR, --首期百元利息
       T9.EN_INTEREST AS END_HD_INTR, --到期百元利息
       ROUND(T4.EN_BALANCE +
             (date_format(cast(T0.L_SECOND_SETTLE_DATE as string), 'YYYYMMDD') -
             date_format(cast(T0.L_FIRST_SETTLE_DATE as string), 'YYYYMMDD')) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                    cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                    cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS BUYB_VAL, --购回金额
       ROUND((date_format(cast(T0.L_SECOND_SETTLE_DATE as string), 'YYYYMMDD') -
             date_format(cast(T0.L_FIRST_SETTLE_DATE as string), 'YYYYMMDD')) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS INTR, --利息
       T0.C_PURPOSE_TYPE AS REPO_USE_TYP, --回购用途类别
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T4.en_profit_ratio AS EXER_YLD,--行权收益率
       T4.en_profit_ratio2 AS YTM,--到期收益率
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_his_2' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T8
    ON T0.L_DATE = T8.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T8.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T8.L_INDEX_DAILY_MODIFY
   AND T8.C_ENTRUST_DIRECTION IN ('3', '4')
   AND T8.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T9
    ON T0.L_DATE = T9.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T9.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T9.L_INDEX_DAILY_MODIFY
   AND T9.C_ENTRUST_DIRECTION IN ('c', 'd')
   AND T9.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 -- 投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON date_format(cast(date_format(cast(T0.L_FIRST_SETTLE_DATE as string),'YYYYMMDD') + T0.L_HG_DAYS as string),'YYYYMMDD') = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
   WHERE T0.C_BUSIN_CLASS IN ('2', 'Z', 'O')  --2 银行间 Z 信用拆借 O：买断式回购
   AND T4.C_ENTRUST_DIRECTION IN ('5', '6', '7', '8') --5:融资(正)回购；6：融资(逆)回购；7:融资购回；8：融券购回；
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：银行间债回售
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_SECU_CTRL_CLAS, --指令证券控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODRE_SCR_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.BOND.YHJ' , '_' ,
              (case when T4.C_INVEST_TYPE = '1' then '2'
             when T4.C_INVEST_TYPE = '2' then '1'
             when T4.C_INVEST_TYPE = 'a' then '15'
             when T4.C_INVEST_TYPE = 'b' then '10'
             when T4.C_INVEST_TYPE = 'c' then '12'
        else T4.C_INVEST_TYPE end) , '_' , '08000200') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '080002' AS BUSI_TYP, --业务类别
       '08000200' AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       0 AS CLR_SPED, --清算速度
       '11' AS ENTR_DIR, --委托方向
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.L_FIRST_SETTLE_DATE AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS FIR_NET_PRC, --首期净价价格
       NULL AS END_NET_PRC, --到期净价价格
       NULL AS FIR_HD_INTR, --首期百元利息
       NULL AS END_HD_INTR, --到期百元利息
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS REPO_USE_TYP, --回购用途类别
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T4.en_profit_ratio AS EXER_YLD,--行权收益率
       T4.en_profit_ratio2 AS YTM,--到期收益率
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_his_3' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T4.C_ENTRUST_DIRECTION IN ('B')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝；a:临时下达
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：债券借贷首期
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_SECU_CTRL_CLAS, --指令证券控制类型
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODRE_SCR_ONUM, --指令证券序号
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.BL.YHJ' , '_' ,
       (case when T4.C_INVEST_TYPE = '1' then '2'
             when T4.C_INVEST_TYPE = '2' then '1'
             when T4.C_INVEST_TYPE = 'a' then '15'
             when T4.C_INVEST_TYPE = 'b' then '10'
             when T4.C_INVEST_TYPE = 'c' then '12'
        else T4.C_INVEST_TYPE end) , '_' , '33000200') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '330002' AS BUSI_TYP, --业务类别
       '33000200' AS BUSI_CLAS, --业务类型
       CONCAT(T5.VC_REPORT_CODE , '.BL.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T4.C_ENTRUST_DIRECTION IN ('?') THEN
          'S'
         WHEN T4.C_ENTRUST_DIRECTION IN ('-') THEN
          'L'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
         WHEN T4.C_ENTRUST_DIRECTION IN ('?') THEN
          '151'
         WHEN T4.C_ENTRUST_DIRECTION IN ('-') THEN
          '152'
       END AS ENTR_DIR, --委托方向
       T4.EN_FACT_PRICE AS ODR_PRC, --指令价格
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          T4.EN_DAY_AVG_PRICE / 100
         ELSE
          T4.EN_PRICE1 / 100
       END AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T0.L_HG_DAYS AS CONT_DAYS, --合约天数
       datediff(from_unixtime(unix_timestamp(cast(T0.L_SECOND_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.L_FIRST_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_DATE AS CONT_TNV_DT, --合约成交日期
       w1.aft_1_dt as CONT_END_DT, --合约到期日期
       T0.L_FIRST_SETTLE_DATE AS FIR_DELI_DT, --首期交割日期
       T0.L_SECOND_SETTLE_DATE AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       NULL AS FIR_NET_PRC, --首期净价价格
       NULL AS END_NET_PRC, --到期净价价格
       NULL AS FIR_HD_INTR, --首期百元利息
       NULL AS END_HD_INTR, --到期百元利息
       ROUND(T4.EN_BALANCE +
             (date_format(cast(T0.L_SECOND_SETTLE_DATE as string), 'YYYYMMDD') -
             date_format(cast(T0.L_FIRST_SETTLE_DATE as string), 'YYYYMMDD')) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS BUYB_VAL, --购回金额
       ROUND((date_format(cast(T0.L_SECOND_SETTLE_DATE as string), 'YYYYMMDD') -
             date_format(cast(T0.L_FIRST_SETTLE_DATE as string), 'YYYYMMDD')) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS INTR, --利息
       T0.C_PURPOSE_TYPE AS REPO_USE_TYP, --回购用途类别
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T4.en_profit_ratio AS EXER_YLD,--行权收益率
       T4.en_profit_ratio2 AS YTM,--到期收益率
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_inbk_odr_his_4' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 -- 投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON date_format(cast(date_format(cast(T0.L_FIRST_SETTLE_DATE as string),'YYYYMMDD') + T0.L_HG_DAYS as string),'YYYYMMDD') = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
   WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T4.C_ENTRUST_DIRECTION IN ('?', '-') --？:债券融入,-：债券融出
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a') --1:有效,3:已撤销,5:审批拒绝,6:分发拒绝,a:临时下达
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}
