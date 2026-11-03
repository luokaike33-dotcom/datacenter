------------------------------------------------------------------------
--模块名称：网下指令表(盘后)
--网下新股、网下新债、网下增发、网下定增、网下战略配售
--指令：跨市场转托管（债券）
--指令：一级市场分销
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

alter table ${dwd_db}.evt_ofle_odr_his drop if exists partition (p_dt=${current_date}, sys_rs_id='O3') ;

insert into ${dwd_db}.evt_ofle_odr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,odr_onum,odr_clas,odr_rela_dt,odr_strt_dt,odr_end_dt,odr_strt_time,odr_end_time,odr_ctrl_clas,odr_secu_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,inv_typ,busi_typ,busi_clas,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,entr_dir,odr_prc_clas,odr_prc,odr_vol,odr_val,bgng_has_entr_vol,bgng_has_entr_val,bgng_has_tnv_vol,bgng_has_tnv_val,entr_vol,entr_val,tnv_vol,tnv_val,marg,feer,trd_chag,chag_mode,deli_dt,in_prd_code,in_ast_unit_code,in_pfl_code,in_inv_typ,in_secu_id,in_src_secu_id,in_odr_vol,in_odr_prc,in_odr_val,res_flag,lock_lmt_clas,lmt_clas_onum,rela_rrsn,agt_rela_rrsn,memo,odr_stat,busi_date,task_rs_id,dm_created_time,delr_id,p_dt,sys_rs_id)
--网下新股、网下新债、网下增发、网下定增、网下战略配售
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
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , 
	   (CASE
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.STK.' , --股票
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.BOND.' , --债券
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE ='50' THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.FUND.' , --基金
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' when T5.C_MARKET_NO = '6' then 'NONE' end))            
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产    
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR T5.C_STOCK_TYPE IN ('a', 'k','23','50') THEN
          '05010100' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '05030100' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '05060100' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          '05050100' --网下增发        
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产      
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR T5.C_STOCK_TYPE IN ('a', 'k','23','50') THEN
          '050101' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '050301' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '050601' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          '050501' --网下增发        
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR T5.C_STOCK_TYPE IN ('a', 'k','23','50') THEN
          '05010100' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '05030100' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '05060100' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          '05050100' --网下增发        
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.STK.' , --股票
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.BOND.' , --债券
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE ='50' THEN
          concat(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.FUND.' , --基金
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' when T5.C_MARKET_NO = '6' then 'NONE' end))            
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       NVL(T6.VC_INTER_CODE,T5.VC_INTER_CODE) AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
          '12' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '150' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '12' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          '12' --网下增发        
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
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
       T4.EN_EARNEST_BALANCE AS MARG, --保证金
       0 AS FEER, --费率
       NULL AS TRD_CHAG, --交易手续费
       NULL AS CHAG_MODE, --手续费方式
       T4.L_FIRST_SETTLE_DATE AS DELI_DT, --交割日期
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ORD_VOL, --转入指令数量
       NULL AS IN_ORD_PRC, --转入指令价格
       NULL AS IN_ORD_VAL, --转入指令金额
       CASE
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          0 --网下增发非限售
         WHEN (T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k')) AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '-') > 0 THEN
          1 --网下定向可转债限售  
         WHEN (T5.C_ASSET_CLASS IN ('3', '4') OR T5.C_STOCK_TYPE IN ('k', '50')) AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '-') = 0 THEN
          0 --网下可转债(非定向)\基金        
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
          0 --网下部分新股非限售     
         ELSE
          1 --限售，包含网下新股、定增和战略配售       
       END AS RES_FLAG, --限售标识
       CASE
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
          5 --网下新股受限
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          2 --非公开发行限售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          4 --战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '7') = 0 THEN
          NULL --网下增发非限售  
         WHEN (T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k')) AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '-') > 0 THEN
          6 --网下定向可转债限售  
         WHEN (T5.C_ASSET_CLASS IN ('3', '4') OR T5.C_STOCK_TYPE IN ('k', '50')) AND
              INSTR(NVL(T5.VC_MIXED_TYPE, 0), '-') = 0 THEN
          NULL --网下可转债(非定向)\基金           
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
          NULL --网下部分新股非限售            
       END AS LOCK_LMT_CLAS, --锁定受限类型 
       NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_odr_real_1' AS TASK_RS_ID, --任务来源标识       
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND case when T5.VC_ASSET_RELATIVE_CODE = T5.VC_INTER_CODE then T5.VC_ASSIGN_CODE else T5.VC_ASSET_RELATIVE_CODE end = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3', '6', '4')
   AND T5.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所   
 WHERE T0.C_BUSIN_CLASS IN ('C')
   AND T4.C_ENTRUST_DIRECTION IN ('C')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：跨市场转托管（债券）
SELECT '1' AS BUSI_SYS_ID,--业务系统编码
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
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.BOND.' , --债券
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' when T5.C_MARKET_NO = '5' then 'YHJ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产    
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '21000100') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产      
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '210001' AS BUSI_TYP, --业务类别
       '21000100' AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.BOND.' , --债券
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' when T5.C_MARKET_NO = '5' then 'YHJ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'          
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       '43' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
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
       0 AS MARG, --保证金
       0 AS FEER, --费率
       NULL AS TRD_CHAG, --交易手续费
       NULL AS CHAG_MODE, --手续费方式
       GREATEST(T0.L_BEGIN_DATE,T0.L_DATE)  AS DELI_DT, --交割日期
       T0.L_FUND_ID AS IN_PRD_CODE, --转入产品代码
       T3.L_ASSET_ID AS IN_AST_UNIT_CODE, --转入资产单元代码
       T0.L_BASECOMBI_ID AS IN_PFL_CODE, --转入投组代码
       case when T4.C_OTHER_INVEST_TYPE = '1' then '2'
            when T4.C_OTHER_INVEST_TYPE	= '2' then '1'
			when T4.C_OTHER_INVEST_TYPE	= 'a' then '15'
            when T4.C_OTHER_INVEST_TYPE	= 'b' then '10' 
            when T4.C_OTHER_INVEST_TYPE	= 'c' then '12'
            else T4.C_OTHER_INVEST_TYPE
		end AS IN_INV_TYP, --转入投资类型
       concat(T6.VC_REPORT_CODE , '.BOND.' , --债券
       (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' when T6.C_MARKET_NO = '5' then 'YHJ' end)) AS IN_SECU_ID, --转入证券编码
       T6.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
       T4.L_AMOUNT AS IN_ORD_VOL, --转入指令数量
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS IN_ORD_PRC, --转入指令价格
       T4.EN_BALANCE AS IN_ORD_VAL, --转入指令金额
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型 
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_odr_real_2' AS TASK_RS_ID, --任务来源标识       
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T4.L_DATE = T6.L_DATE
   AND T4.VC_OTHER_INTER_CODE = T6.VC_INTER_CODE   
 WHERE T0.C_BUSIN_CLASS IN ('Q')
   AND T4.C_ENTRUST_DIRECTION IN ('g')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：一级市场分销
SELECT '1' AS BUSI_SYS_ID,--业务系统编码
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
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.BOND.' , --债券
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' when T5.C_MARKET_NO = '5' then 'YHJ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产    
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T5.C_MARKET_NO IN ('1', '2') THEN
          '05040100'
         WHEN T5.C_MARKET_NO IN ('5') THEN
          '05040200'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产      
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_MARKET_NO IN ('1', '2') THEN
          '050401'
         WHEN T5.C_MARKET_NO IN ('5') THEN
          '050402'
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T5.C_MARKET_NO IN ('1', '2') THEN
          '05040100'
         WHEN T5.C_MARKET_NO IN ('5') THEN
          '05040200'
       END AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.BOND.' , --债券
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '5' THEN
          'YHJ'          
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       '21' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
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
       T4.EN_EARNEST_BALANCE AS MARG, --保证金
       ABS(T4.EN_FEE) / T4.EN_BALANCE AS FEER, --费率
       ABS(T4.EN_FEE) AS TRD_CHAG, --交易手续费
       CASE
         WHEN T4.EN_FEE > 0 THEN
          1
         WHEN T4.EN_FEE < 0 THEN
          2
         WHEN T4.EN_FEE = 0 THEN
          3
       END AS CHAG_MODE, --手续费方式
       GREATEST(T0.L_BEGIN_DATE,T0.L_DATE)  AS DELI_DT, --交割日期
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ORD_VOL, --转入指令数量
       NULL AS IN_ORD_PRC, --转入指令价格
       NULL AS IN_ORD_VAL, --转入指令金额
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型 
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_odr_real_3' AS TASK_RS_ID, --任务来源标识       
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3', '6', '4')
   AND T5.C_MARKET_NO IN ('1', '2' ,'5') --1是上交所、2深交所 、5银行间     
 WHERE T0.C_BUSIN_CLASS IN ('D')
   AND T4.C_ENTRUST_DIRECTION IN ('K')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}