------------------------------------------------------------------------
--模块名称：网下清算流水表兴全个性化
--网下业务：定增业务
--网下业务：跨市场转托管（债券）
--网下业务：两融业务（担保品提交和交存）
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


WITH VHISOUTCONFIRM AS
         (SELECT L_DATE,
                 L_FUND_ID,
                 VC_INTER_CODE,
                 C_ENTRUST_DIRECTION,
                 C_STATUS,
                 C_BUSIN_CLASS,
                 EN_AMOUNT,
                 EN_PRICE,
                 C_INVEST_TYPE,
                 VC_SEAT_ID,
                 VC_STOCKHOLDER_ID,
                 L_BASECOMBI_ID,
                 L_CONFIRM_DATE,
                 L_CONFIRM_NO,
                 L_EXECCONFIRM_NO,
                 L_BUSIN_FLAG,
                 EN_BALANCE,
                 L_DAILY_INSTRUCTION_NO,
                 L_INDEX_DAILY_MODIFY,
                 L_STOCK_SERIAL_NO,
                 EN_FEE_RATIO,
                 C_SETTLE_TYPE,
                 C_BUSIN_PRO_TYPE,
                 C_DEAL_STATUS,
                 VC_REMARK,
                 EN_CBALANCE,
                 L_OPERATOR_NO,
                 L_RIVAL_ID,
                 L_TIME,
                 C_FEE_DEAL_TYPE,
                 L_SETTLE_DATE,
                 L_IN_COMBI_ID,
                 VC_IN_INTERCODE,
                 C_TRAN_FLAG,
                 EN_FEE,
                 VC_IN_STOCKHOLDER_ID,
                 VC_IN_SEAT_ID,
                 C_IN_INVEST_TYPE,
                 C_RESTRICTED_FLAG,
                 L_RESTRICTED_NO
          FROM ${ods_db}.O3_TOUTCONFIRM
          WHERE C_STATUS = '1' --正常
          UNION ALL
          SELECT L_DATE,
                 L_FUND_ID,
                 VC_INTER_CODE,
                 C_ENTRUST_DIRECTION,
                 C_STATUS,
                 C_BUSIN_CLASS,
                 EN_AMOUNT,
                 EN_PRICE,
                 C_INVEST_TYPE,
                 VC_SEAT_ID,
                 VC_STOCKHOLDER_ID,
                 L_BASECOMBI_ID,
                 L_CONFIRM_DATE,
                 L_CONFIRM_NO,
                 L_EXECCONFIRM_NO,
                 L_BUSIN_FLAG,
                 EN_BALANCE,
                 L_DAILY_INSTRUCTION_NO,
                 L_INDEX_DAILY_MODIFY,
                 L_STOCK_SERIAL_NO,
                 EN_FEE_RATIO,
                 C_SETTLE_TYPE,
                 C_BUSIN_PRO_TYPE,
                 C_DEAL_STATUS,
                 VC_REMARK,
                 EN_CBALANCE,
                 L_OPERATOR_NO,
                 L_RIVAL_ID,
                 L_TIME,
                 C_FEE_DEAL_TYPE,
                 L_SETTLE_DATE,
                 L_IN_COMBI_ID,
                 VC_IN_INTERCODE,
                 C_TRAN_FLAG,
                 EN_FEE,
                 VC_IN_STOCKHOLDER_ID,
                 VC_IN_SEAT_ID,
                 C_IN_INVEST_TYPE,
                 C_RESTRICTED_FLAG,
                 L_RESTRICTED_NO
          FROM ${ods_db}.O3_THISOUTCONFIRM
          WHERE C_STATUS = '1' --正常
         )

insert into ${dwd_db}.evt_ofle_clea_jour_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,tnv_onum,odr_onum,excf_onum,excf_time,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_sped,entr_dir,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,deli_dt,rf_val,makp_val,feer,trd_chag,chag_mode,chag_arvd_dt,cms,marg,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_entr_vol,in_tnv_prc,in_tnv_val,in_occu_val,res_flag,lock_lmt_clas,lmt_clas_onum,sett_mode,savc_iss_reqy,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,trd_cntp_id,oper_no,tnv_stat,memo,is_marg_mdl,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--网下业务：定增业务:
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T10.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
	   NULL AS odr_onum,
       CONCAT(T10.L_CONFIRM_DATE , '_HSO32' , '_O' , T10.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
       NULL AS EXCF_TIME, --确认时间
       CASE
        WHEN T0.L_BUSIN_NO IS NULL THEN
        NULL --当天缺失成交信息，直接为空
        WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
        NULL --缺少指令序号，直接为空
       ELSE
        CONCAT(T10.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' ,
            (CASE
                WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
                 CONCAT(T5.VC_REPORT_CODE , '.STK.' , --股票
                    CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
                 CONCAT(T5.VC_REPORT_CODE , '.BOND.' , --债券
                    CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
                WHEN T5.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE = '50' THEN
                 CONCAT(T5.VC_REPORT_CODE , '.FUND.' , --基金
                    CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' END)
        END) , '_' , (CASE
               WHEN T0.C_INVEST_TYPE IN ('1') THEN
                 '2' --交易型金融资产
               WHEN T0.C_INVEST_TYPE IN ('2') THEN
                 '1' --持有到期资产
               ELSE
                T0.C_INVEST_TYPE
               END) , '_' , '05030100')
       END AS odr_rela_onum, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.STK.' , CASE
                                                WHEN T5.C_MARKET_NO = '1' THEN
                                                 'SH'
                                                WHEN T5.C_MARKET_NO = '2' THEN
                                                 'SZ'
                                              END) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       'CNY' AS CURR_CODE, --货币代码
       '050301' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '05030102' AS BUSI_CLAS, --业务类型
       0 AS CLR_SPED, --清算速度
       '150' AS ENTR_DIR, --委托方向
       CAST(REGEXP_REPLACE(regexp_extract(replace(T0.VC_SUMMARY,'：',''),
                                                      '(中签数量为)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '中签数量为',
                                        '') AS DECIMAL(20, 4))  AS TNV_VOL, --成交数量 
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格 中签金额/中签数量
       CAST(REGEXP_REPLACE(regexp_extract(replace(T0.VC_SUMMARY,'：',''),
                                                      '(中签金额为)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '中签金额为',
                                        '') AS DECIMAL(20, 4))  AS TNV_VAL, --成交金额 
       CAST(REGEXP_REPLACE(regexp_extract(replace(T0.VC_SUMMARY,'：',''),
                                                      '(中签金额为)([0-9]+([.]{1}[0-9]+){0,1})',0),
                                        '中签金额为',
                                        '') AS DECIMAL(20, 4))  AS OCCU_VAL, --发生金额 
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.L_DATE AS DELI_DT, --交割日期
       0 AS RF_VAL, --  退款金额，
       0 AS MAKP_VAL, -- 补款金额
       0 AS FEER, --费率
       0 as TRD_CHAG, --交易手续费
       NULL AS CHAG_MODE, --手续费方式
       NULL AS CHAG_ARVD_DT, --手续费到账日
	     NULL AS CMS, -- 佣金
       0 AS MARG, --  保证金 ，执行确认使用发生金额作为定金
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入成交数量
       NULL AS IN_TNV_PRC, --转入成交价格
       NULL AS IN_TNV_VAL, --转入成交金额
       NULL AS IN_OCCU_VAL, --转入发生金额
       0 AS RES_FLAG, --限售标志
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
	     NULL AS SETT_MODE, -- 结算方式
       NULL as SAVC_ISS_REQY, --续发期数
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       NULL AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
	     NULL AS TRD_CNTP_ID,--交易对手编码
       NULL AS OPER_NO, --操作员
       '1' AS TNV_STAT, --成交状态
       T0.VC_SUMMARY AS MEMO, --备注
	     NULL AS IS_MARG_MDL, --是否保证金模式
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as BUSI_DATE, --业务日期
       'evt_ofle_clea_jour_his_spcl1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS t0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
   AND T5.C_MARKET_NO IN ('1', '2', '5', '6')
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
  LEFT JOIN VHISOUTCONFIRM T4   
    ON T0.L_BUSIN_NO = T4.L_CONFIRM_NO
   AND T0.P_DT = T4.L_CONFIRM_DATE
  LEFT JOIN VHISOUTCONFIRM T10 --中签找执行确认记录
    ON T4.L_EXECCONFIRM_NO = T10.L_CONFIRM_NO
   AND T4.L_BASECOMBI_ID = T10.L_BASECOMBI_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T10.L_DAILY_INSTRUCTION_NO
   AND T4.L_BUSIN_FLAG = '73999'
   AND T10.L_BUSIN_FLAG = '41501'
 WHERE T0.L_BUSIN_FLAG IN ('73999') --73999网下申购定向增发中签
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}

UNION ALL
--网下业务：跨市场转托管（债券）:
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
	   NULL AS odr_onum,
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS EXCF_ONUM, --执行确认序号
       NULL AS EXCF_TIME, --确认时间
       NULL AS odr_rela_onum, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.BOND.' , CASE
                                                WHEN T5.C_MARKET_NO = '1' THEN
                                                 'SH'
                                                WHEN T5.C_MARKET_NO = '2' THEN
                                                 'SZ'
                                                WHEN T5.C_MARKET_NO = '5' THEN
                                                 'YHJ'
                                              END) AS SECU_ID, --证券编码
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
       'L' AS POS_ID, --多空标志,默认多头
       'CNY' AS CURR_CODE, --货币代码
       '210001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE WHEN T0.VC_SUMMARY IN ('ims-债券转托管调用银行间证券减少', '非交易过户数量减少') THEN '21000113'
	        WHEN T0.VC_SUMMARY IN ('ims-债券转托管调用银行间证券增加', '非交易过户数量增加') THEN '21000114'
	   END AS BUSI_CLAS, --业务类型
       0 AS CLR_SPED, --清算速度
       '150' AS ENTR_DIR, --委托方向
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       0 AS TNV_PRC, --成交价格
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T0.L_DATE AS DELI_DT, --交割日期
       0 AS RF_VAL, --  退款金额，
       0 AS MAKP_VAL, -- 补款金额
       0 AS FEER, --费率
       0 as TRD_CHAG, --交易手续费
       NULL AS CHAG_MODE, --手续费方式
       NULL AS CHAG_ARVD_DT, --手续费到账日
       NULL AS CMS, -- 佣金
       0 AS MARG, --  保证金 ，执行确认使用发生金额作为定金
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入成交数量
       NULL AS IN_TNV_PRC, --转入成交价格
       NULL AS IN_TNV_VAL, --转入成交金额
       NULL AS IN_OCCU_VAL, --转入发生金额
       0 AS RES_FLAG, --限售标志
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS SETT_MODE, -- 结算方式
       NULL as SAVC_ISS_REQY, --续发期数
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       NULL AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
       NULL AS TRD_CNTP_ID,--交易对手编码
       NULL AS OPER_NO, --操作员
       '1' AS TNV_STAT, --成交状态
       T0.VC_SUMMARY AS MEMO, --备注
	     NULL AS IS_MARG_MDL, --是否保证金模式
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as BUSI_DATE, --业务日期
       'evt_ofle_clea_jour_his_spcl2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  INNER JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('3') --只要债券的
   AND T5.C_MARKET_NO IN ('1', '2', '5')
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.VC_SUMMARY IN ('ims-债券转托管调用银行间证券减少', 'ims-债券转托管调用银行间证券增加','非交易过户数量增加','非交易过户数量减少')
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}
