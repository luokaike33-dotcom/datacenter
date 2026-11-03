------------------------------------------------------------------------
  -- 模块名称：银行间执行确认表(离线)
  --执行确认：银行间债回售未报
  --执行确认：银行间债回售成交失败\已报
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

alter table ${dwd_db}.evt_inbk_excf_his drop if exists partition (p_dt=${current_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_inbk_excf_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,excf_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,entr_dir,entr_vol,whdw_vol,entr_prc,net_prc,full_prc,busi_typ,busi_clas,rat,entr_val,entr_tot_fee,oper_no,trd_cntp_id,deli_dt,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,fir_net_prc,end_net_prc,fir_hd_intr,end_hd_intr,buyb_val,intr,entr_stat,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--执行确认：银行间债回售未报
SELECT '1' AS busi_sys_id, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DIRECT_DATE , '_HSO32' , '_O' , T0.L_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DIRECT_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
	   END AS TRD_SRC_ID, --交易源ID
       T0.L_DIRECT_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       concat(T0.L_DIRECT_DATE , '_HSO32' , '_O' , T0.L_SERIAL_NO) AS excf_onum, --执行确认序号
       concat(T0.L_DIRECT_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
       T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.BOND.YHJ' , '_' ,
       (case when T0.C_INVEST_TYPE = '1' then '2'
            when T0.C_INVEST_TYPE = '2' then '1'
            when T0.C_INVEST_TYPE = 'a' then '15'
            when T0.C_INVEST_TYPE = 'b' then '10'
            when T0.C_INVEST_TYPE = 'c' then '12'
        else T0.C_INVEST_TYPE end) , '_' , '08000200') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       'HOLDER5' AS SH_CODE, --股东代码
       'SEAT5' AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       0 AS CLR_SPED, --清算速度
       '11' AS ENTR_DIR, --委托方向
       T0.EN_BALANCE / 100 AS ENTR_VOL, --委托数量
       0 AS WHDW_VOL, --撤单数量
       100 AS ENTR_PRC, --委托价格
       T0.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
       T0.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
       '080002' AS BUSI_TYP, --业务类别
       '08000201' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       T0.EN_BALANCE AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.L_FIRST_SETTLE_DATE AS DELI_DT, --交割日期
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
       '1' AS ENTR_STAT, --委托状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_excf_real_1' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DIRECT_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TBANKCONFIRM T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T0.C_ENTRUST_DIRECTION IN ('B')
   AND T0.C_STATUS = '1'
   AND T0.L_DIRECT_DATE = ${current_date}
  AND T0.L_DIRECT_DATE = ${current_date}
UNION ALL
--执行确认：银行间债回售成交失败\已报
SELECT '1' AS busi_sys_id, --业务系统编码
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
              T4.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T4.L_DATE , '_HSO32' , '_O' , T7.L_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T7.L_DIRECT_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
       END  AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       NULL AS OCCU_TIME, --发生时间
       concat(T7.L_DIRECT_DATE , '_HSO32' , '_O' , T7.L_SERIAL_NO) AS excf_onum, --执行确认序号
       concat(T7.L_DIRECT_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
       T0.L_BASECOMBI_ID , '_' ,
       LPAD(T5.C_MARKET_NO,3,'0') , LPAD(T5.VC_REPORT_CODE,9,'0') , '_' ,
       (case when T0.C_INVEST_TYPE = '1' then '2'
             when T0.C_INVEST_TYPE = '2' then '1'
             when T0.C_INVEST_TYPE = 'a' then '15'
             when T0.C_INVEST_TYPE = 'b' then '10'
             when T0.C_INVEST_TYPE = 'c' then '12'
        else T0.C_INVEST_TYPE end) , '_' ,
       '08000200') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       concat(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       0 AS CLR_SPED, --清算速度
       '11' AS ENTR_DIR, --委托方向
       T0.L_BUSIN_AMOUNT AS ENTR_VOL, --委托数量
       0 AS WHDW_VOL, --撤单数量
       T0.EN_ENTRUST_PRICE AS ENTR_PRC, --委托价格
       T4.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
       T4.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
       '080002' AS BUSI_TYP, --业务类别
       '08000201' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       T0.EN_DEAL_BALANCE AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T4.L_LOCK_OPERATOR AS OPER_NO, --操作员编码
       T4.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T4.L_FIRST_SETTLE_DATE AS DELI_DT, --交割日期
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
       CASE WHEN NVL(T4.C_SETTLE_FLAG,'0') <> 1 THEN '2'  --2：已报
             ELSE '7'	 --7：已撤
       END AS ENTR_STAT, --2：已报
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_excf_real_2' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  INNER JOIN ${ods_db}.O3_TPENDSETTLE T8  --当前表和历史表的集合
    ON T0.L_DATE = T0.L_DATE
   AND T0.L_BUSIN_NO = T8.L_SERIAL_NO 
  LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T4
    ON T8.L_TRADE_DATE = T4.L_DATE
   AND T8.VC_ORIGINAL_NO = T4.L_SERIAL_NO
  LEFT JOIN ${ods_db}.O3_TBANKCONFIRM T7
    ON T4.L_EXEC_CONFIRM_NO = T7.L_SERIAL_NO 
   AND T4.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
   AND T4.VC_INTER_CODE = T7.VC_INTER_CODE    
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE   
 WHERE T0.C_BUSIN_CLASS = '2'
   AND T0.L_BUSIN_FLAG = '72571' 
   AND T0.C_STATUS IN ('1','2')--有效、回溯
   AND T0.EN_DEAL_BALANCE > 0 
   AND T0.L_DATE = ${current_date}