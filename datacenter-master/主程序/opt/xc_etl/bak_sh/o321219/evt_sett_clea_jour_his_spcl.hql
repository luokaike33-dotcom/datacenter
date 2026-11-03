------------------------------------------------------------------------
--模块名称：结算类清算兴全个性化
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

insert into ${dwd_db}.evt_sett_clea_jour_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,intr_val,deli_dt,intr_tran_dpsi,pnlt_val,cont_id,res_flag,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , 
	    CASE
			WHEN T5.C_ASSET_CLASS IN ('2') THEN '.STK.'
			WHEN T5.C_ASSET_CLASS IN ('3') THEN '.BOND.'
			WHEN T5.C_ASSET_CLASS IN ('4') THEN '.FUND.'
		END,CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
            END) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'				 
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '990000' AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE WHEN '1' THEN '2' WHEN '2' THEN '1' WHEN 'a' THEN '15' WHEN 'b' THEN '10' WHEN 'c' THEN '12' ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       CASE WHEN T0.L_BUSIN_FLAG IN ('40301','73242','72517') THEN '99000002'
            WHEN T0.L_BUSIN_FLAG IN ('40302','73243','72518') THEN '99000003'
			WHEN T0.L_BUSIN_FLAG IN ('40602') THEN '99000008'
	   END AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       T5.EN_LAST_PRICE AS TNV_PRC, --成交价格
       CAST(T0.L_BUSIN_AMOUNT AS double) * CAST(T5.EN_LAST_PRICE AS double) AS TNV_VAL, --成交金额
       CAST(T0.L_BUSIN_AMOUNT AS double) * CAST(T5.EN_LAST_PRICE AS double) AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_spcl' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('40301','40302','73242','73243','72517','72518','40602')  
 --73242基金通核对手工调整，73243基金通核对手工调减
   AND nvl(T0.VC_SUMMARY,'') NOT IN (
   '迅策ufx证券持仓调整指令',
   'ims-债券回售持仓调整',
   'ims-债券转托管调用银行间证券减少', 
   'ims-债券转托管调用银行间证券增加',
   '非交易过户数量增加',
   '非交易过户数量减少'
   )
   AND T0.C_STATUS = '1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}

UNION ALL
   
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       concat(T5.VC_REPORT_CODE , 
	    CASE
			WHEN T5.C_ASSET_CLASS IN ('2') THEN '.STK.'
			WHEN T5.C_ASSET_CLASS IN ('3') THEN '.BOND.'
			WHEN T5.C_ASSET_CLASS IN ('4') THEN '.FUND.'
		END,CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
            END) AS SECU_ID, --证券编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                 WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
				 WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
				 WHEN T5.C_MARKET_NO = '6' THEN 'NONE'				 
                 WHEN T5.C_MARKET_NO = 'n' THEN 'SHSC'
                 WHEN T5.C_MARKET_NO = 'o' THEN 'SZSC'
                 WHEN T5.C_MARKET_NO = 'j' THEN CASE WHEN NVL(T5.VC_LAYERING, 0) = 2 THEN 'BJ' ELSE 'SB' END
                 WHEN T5.C_MARKET_NO = 'r' THEN 'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       '510001' AS BUSI_TYP, --业务类别
       CASE T0.C_INVEST_TYPE WHEN '1' THEN '2' WHEN '2' THEN '1' WHEN 'a' THEN '15' WHEN 'b' THEN '10' WHEN 'c' THEN '12' ELSE T0.C_INVEST_TYPE END AS INV_TYP, --投资类型
       '51000100' AS BUSI_CLAS, --业务类型
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_spcl_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
 WHERE T0.L_BUSIN_FLAG IN ('73565')
   AND T0.C_STATUS = '1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}
   