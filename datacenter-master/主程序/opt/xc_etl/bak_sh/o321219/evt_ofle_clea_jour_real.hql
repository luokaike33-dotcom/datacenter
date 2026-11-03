------------------------------------------------------------------------
--模块名称：网下清算流水表（盘后）
--网下证券上市
--网下新债、网下增发、网下定增、网下战略配售（执行确认和中签）
--新规则网下中签
--网下新股执行确认（新规）
--跨市场转托管执行确认/手工执行确认
--清算：跨市场转托管成交确认
--一级市场债券分销买入成交
--一级市场债券分销缴款
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

alter table ${dwd_db}.evt_ofle_clea_jour_his drop if exists partition (p_dt = ${current_date}, sys_rs_id='O3');
WITH LHISCURRENTS AS
(SELECT T0.L_DATE,
       T0.L_BASECOMBI_ID,
       T0.C_INVEST_TYPE,
       T5.VC_INTER_CODE,
       T5.VC_REPORT_CODE,
       NVL(T6.VC_INTER_CODE,T7.VC_INTER_CODE )AS VC_INTER_CODE_Z
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSIGN_CODE=T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3', '6')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T7 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T7.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE=T7.VC_INTER_CODE
   AND T7.C_ASSET_CLASS IN ('2', '3', '6')
  WHERE T0.L_BUSIN_FLAG = '41520'
   AND  NOT (T5.VC_INTER_CODE = T5.VC_ASSIGN_CODE AND T5.VC_INTER_CODE = T5.VC_ASSET_RELATIVE_CODE)
   AND  T0.C_STATUS ='1'
AND t0.L_DATE = ${current_date}
)
insert into ${dwd_db}.evt_ofle_clea_jour_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,tnv_onum,odr_onum,excf_onum,excf_time,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_sped,entr_dir,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,deli_dt,rf_val,makp_val,feer,trd_chag,chag_mode,chag_arvd_dt,cms,marg,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_entr_vol,in_tnv_prc,in_tnv_val,in_occu_val,res_flag,lock_lmt_clas,lmt_clas_onum,sett_mode,savc_iss_reqy,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,trd_cntp_id,oper_no,tnv_stat,memo,is_marg_mdl,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--网下证券上市
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
     T0.L_DATE AS OCCU_DT, --发生日期
     CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
     NULL AS ODR_ONUM, --指令序号
     NULL EXCF_ONUM, --执行确认序号
     NULL AS EXCF_TIME, --确认时间
     NULL AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
     CASE
          WHEN T5.C_ASSET_CLASS = '2' THEN
               CONCAT(T5.VC_REPORT_CODE , '.STK.' , --股票
                      (CASE T5.C_MARKET_NO WHEN '1'THEN 'SH' WHEN '2' THEN 'SZ' END))
          WHEN T5.C_ASSET_CLASS IN ('3') THEN
               CONCAT(T5.VC_REPORT_CODE , '.BOND.' , --债券
                      (CASE T5.C_MARKET_NO WHEN '1'THEN 'SH' WHEN '2' THEN 'SZ' WHEN '5' THEN 'YHJ' END))
          WHEN T5.C_ASSET_CLASS = '4' THEN
               CONCAT(T5.VC_REPORT_CODE , '.FUND.' , --基金
                      (CASE T5.C_MARKET_NO WHEN '1'THEN 'SH' WHEN '2' THEN 'SZ' END))
     END AS SECU_ID, --证券编码
     CASE
          WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
          WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
          WHEN T5.C_MARKET_NO = '5' THEN
               'YHJ'
          WHEN T5.C_MARKET_NO = '6' THEN
               'NONE'
     END AS EXCH_CODE, --交易市场代码
     NVL(T4.VC_REPORT_CODE,T5.VC_REPORT_CODE) AS SECU_CODE, --证券代码
     NVL(T4.VC_INTER_CODE,T5.VC_INTER_CODE)  AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志,默认多头
     'CNY' AS CURR_CODE, --货币代码
     '050101' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '05010108' AS BUSI_CLAS, --业务类型
     0 AS CLR_SPED, --清算速度
     '12' AS ENTR_DIR, --委托方向
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
     0 AS TRD_CHAG, --交易手续费
     NULL AS CHAG_MODE, --手续费方式
     NULL AS CHAG_ARVD_DT, --手续费到账日
     NULL AS CMS, --佣金
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
     NULL AS SETT_MODE, --结算方式
     0 as SAVC_ISS_REQY, --续发期数
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
     T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
     NULL AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
     T0.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
     NULL AS TRD_CNTP_ID, -- 交易对手编码
     T0.L_OPERATOR_NO AS OPER_NO, --操作员
     '1' AS TNV_STAT, --成交状态
     NULL AS MEMO, --备注
	 NULL AS IS_MARG_MDL, --是否保证金模式
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_ofle_clea_jour_real_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
                AND T5.C_ASSET_CLASS IN ('3', '2','4')
       LEFT JOIN LHISCURRENTS T4
         ON T0.L_DATE = T4.L_DATE
                AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.C_INVEST_TYPE = T4.C_INVEST_TYPE
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE_Z
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.L_BUSIN_FLAG IN ('41520')
   AND T0.C_STATUS ='1'
   AND T5.VC_INTER_CODE = T5.VC_ASSIGN_CODE
   AND T5.VC_INTER_CODE = T5.VC_ASSET_RELATIVE_CODE
   AND T0.L_DATE = ${current_date}
--41520网上证券上市

UNION ALL
--网下新债、网下增发、网下定增、网下战略配售（执行确认和中签）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , (CASE
            WHEN T0.L_BUSIN_FLAG = '41501' THEN
             T0.L_DATE
            ELSE
             T10.L_CONFIRM_DATE
          END) , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO ,
          '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
         WHEN T4.L_CONFIRM_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
         ELSE
          CONCAT(T0.L_DATE , '_HSO32' , '_' , CASE T0.L_BUSIN_FLAG WHEN '41501' THEN 'O' ELSE '' END ,
          (CASE T0.L_BUSIN_FLAG
          WHEN '41501' THEN T4.L_CONFIRM_NO
          ELSE NVL(NVL(T7.L_CONFIRM_NO,T8.L_CONFIRM_NO),T4.L_CONFIRM_NO)
          END)) --成交使用退补款流水号
       END AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失成交信息，直接为空
         WHEN (T0.L_BUSIN_FLAG = '41501' AND T4.L_CONFIRM_NO IS NULL) OR
              (T0.L_BUSIN_FLAG <> '41501' AND T10.L_CONFIRM_NO IS NULL) THEN
          NULL --缺少执行确认序号时，为空
         ELSE
          CONCAT((CASE
            WHEN T0.L_BUSIN_FLAG = '41501' THEN
             T0.L_DATE
            ELSE
             T10.L_CONFIRM_DATE
          END) , '_HSO32' , '_O' , (CASE
            WHEN T0.L_BUSIN_FLAG = '41501' THEN
             T4.L_CONFIRM_NO
            ELSE
             T10.L_CONFIRM_NO
          END))
       END AS EXCF_ONUM, --执行确认序号
       T4.L_TIME AS EXCF_TIME, --确认时间
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失成交信息，直接为空
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
          NULL --缺少指令序号，直接为空
         ELSE
          CONCAT((CASE
            WHEN T0.L_BUSIN_FLAG = '41501' THEN
             T0.L_DATE
            ELSE
             T10.L_CONFIRM_DATE
          END) , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
          T4.L_BASECOMBI_ID , '_' , (CASE
           WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
                        CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.STK.' , --股票
                        (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END))
                       WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
                        CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.BOND.' , --债券
                        (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END))
                       WHEN T6.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE = '50' THEN
                        CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.FUND.' , --基金
                        (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END))
                     END) , '_' , (CASE
                                                                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                  '2' --交易型金融资产
                                                                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                  '1' --持有到期资产
                                                                 ELSE
                                                                  T0.C_INVEST_TYPE
                                                               END) , '_' , (CASE
            WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
                 T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
             '05010100' --网下新股\新债\基金
            WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                 INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                 NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
             '05030100' --网下定增
            WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                 INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
                 NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
             '05060100' --网下战略配售
            WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
                 INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
             '05050100' --网下增发
          END))
       END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27', 'a', '23') THEN
         CONCAT( NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.STK.' , --股票
          (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END ))
         WHEN T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k') THEN
          CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) || '.BOND.' || --债券
          (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END ))
         WHEN T6.C_ASSET_CLASS = '4' OR T5.C_STOCK_TYPE = '50' THEN
          CONCAT(NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.FUND.' , --基金
          (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' WHEN '6' THEN 'NONE' END ))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = '6' THEN
          'NONE'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
          '050101' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '050301' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '050601' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
          '050501' --网下增发
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
              (CASE WHEN T0.L_BUSIN_FLAG='41501' THEN '05010101' ELSE '05010102' END) --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
              (CASE WHEN T0.L_BUSIN_FLAG= '41501' THEN '05030101' ELSE '05030102'END) --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
              (CASE WHEN T0.L_BUSIN_FLAG='41501' THEN '05060101' ELSE '05060102'END) --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
              (CASE WHEN T0.L_BUSIN_FLAG='41501' THEN '05050101' ELSE  '05050102' END)--网下增发
       END AS BUSI_CLAS, --业务类型
       0 AS CLR_SPED, --清算速度
       CASE
         WHEN T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('a', 'k', '23', '50') THEN
          '12' --网下新股\新债\基金
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          '150' --网下定增
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          '12' --网下战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
          '12' --网下增发
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
          T0.L_ENTRUST_AMOUNT
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          T0.L_BUSIN_AMOUNT
       END AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
          T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          T0.L_BUSIN_AMOUNT * T0.EN_ENTRUST_PRICE
       END AS TNV_VAL, --成交金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
          T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          T0.L_BUSIN_AMOUNT * T0.EN_ENTRUST_PRICE
         ELSE
          T0.EN_OCCUR_BALANCE
       END AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
          T4.L_SETTLE_DATE
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          NVL(T12.L_SETTLE_DATE,T4.L_CONFIRM_DATE)
       END AS DELI_DT, --交割日期
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          NVL(T8.EN_BALANCE, 0)
         ELSE
          0
       END AS RF_VAL, --  退款金额，
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
          NVL(T7.EN_BALANCE, 0)
         ELSE
          0
       END AS MAKP_VAL, -- 补款金额
       T4.EN_FEE_RATIO AS FEER, --费率
       0 as trd_chag, --交易手续费
       NULL as chag_mode, --手续费方式
       NULL as chag_arvd_dt, --手续费到账日
       NULL AS CMS, --佣金
       NVL(CASE
             WHEN T0.L_BUSIN_FLAG IN ('41501') THEN
              T0.EN_OCCUR_BALANCE
             WHEN T0.L_BUSIN_FLAG IN ('41521') THEN
              T4.EN_CBALANCE
           END,
           0) AS MARG, --  保证金 ，执行确认使用发生金额作为定金
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
       CASE
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
          0 --网下增发非限售
         WHEN (T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k')) AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '-') > 0 THEN
          1 --网下定向可转债限售
         WHEN (T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('k', '50')) AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '-') = 0 THEN
          0 --网下可转债(非定向)\基金
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND
              NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
          0 --网下部分新股非限售
         ELSE
          1 --限售，包含网下新股、定增和战略配售
       END AS RES_FLAG, --限售标识
       CASE
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND
              NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
          5 --网下新股受限
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '0' THEN
          2 --非公开发行限售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') > 0 AND
              NVL(T4.C_RESTRICTED_FLAG, '0') = '1' THEN
          4 --战略配售
         WHEN T5.C_STOCK_TYPE IN ('1', 'd', '27') AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '7') = 0 THEN
          NULL --网下增发非限售
         WHEN (T5.C_ASSET_CLASS IN ('3') OR T5.C_STOCK_TYPE IN ('k')) AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '-') > 0 THEN
          6 --网下定向可转债限售
         WHEN (T5.C_ASSET_CLASS IN ('3', '4') OR
              T5.C_STOCK_TYPE IN ('k', '50')) AND
              INSTR(NVL(NVL(T11.VC_MIXED_TYPE, T5.VC_MIXED_TYPE), 0), '-') = 0 THEN
          NULL --网下可转债(非定向)\基金
         WHEN T5.C_STOCK_TYPE IN ('a', '23') AND
              NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
          NULL --网下部分新股非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS SETT_MODE, --结算方式
       0 as SAVC_ISS_REQY, --续发期数
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME  AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS       AS BUSI_CLAS_O3, --业务分类_O32
       T4.C_BUSIN_PRO_TYPE    AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.L_BUSIN_FLAG        as busi_clas_dtl_o3, --业务类型明细_O3
       NULL AS TRD_CNTP_ID, --交易对手编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
       T4.VC_REMARK     AS MEMO, --备注
	   '1' AS IS_MARG_MDL, --是否保证金模式
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_clea_jour_real_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM  ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN  ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN  ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN  ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN  ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
   AND T5.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
  LEFT JOIN  ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3', '4', '6')
   AND T6.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
  LEFT JOIN ( select T4.*
  from ${ods_db}.O3_TCURRENTS T0
  LEFT JOIN  ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
   ON T0.L_DATE = T5.L_DATE
  AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
  AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
  AND T5.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
  inner join ${ods_db}.O3_TOUTCONFIRM T4
    ON T0.L_BUSIN_NO = T4.L_CONFIRM_NO
    where T0.L_DATE = (CASE WHEN concat(T0.L_BUSIN_FLAG , T5.C_ASSET_CLASS) = '415014'  THEN  T4.L_SETTLE_DATE  ELSE T4.L_CONFIRM_DATE END)
     AND T0.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
       AND T0.L_BUSIN_FLAG IN ('41501','41521') --41501执行确认,41521中签
       AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
  ) T4 --获取成交执行序号
    ON T0.L_BUSIN_NO = T4.L_CONFIRM_NO
  LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T10 --中签找执行确认记录
    ON T4.L_EXECCONFIRM_NO = T10.L_CONFIRM_NO
   AND T4.L_BASECOMBI_ID = T10.L_BASECOMBI_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T10.L_DAILY_INSTRUCTION_NO
   AND T4.L_BUSIN_FLAG = '41521'
   AND T10.L_BUSIN_FLAG = '41501'
  LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T7 --获取补款确认编号
    ON T4.L_DATE = T7.L_DATE
   AND T4.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
   AND T4.L_EXECCONFIRM_NO = T7.L_EXECCONFIRM_NO
   AND T7.L_BUSIN_FLAG = '41507'
  LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T8 --获取退款确认编号
    ON T4.L_DATE = T8.L_DATE
   AND T4.L_BASECOMBI_ID = T8.L_BASECOMBI_ID
   AND T4.L_EXECCONFIRM_NO = T8.L_EXECCONFIRM_NO
   AND T8.L_BUSIN_FLAG = '41522'
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T11 --证券基本信息表，获取执行确认时证券属性
    ON T10.VC_INTER_CODE = T11.VC_INTER_CODE
   AND T11.C_ASSET_CLASS IN ('2', '3', '6')
   AND T11.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
  LEFT JOIN ${ods_db}.O3_TPENDSETTLE T12
    ON T0.L_BASECOMBI_ID = T12.L_BASECOMBI_ID
   AND NVL(T7.L_CONFIRM_NO, T8.L_CONFIRM_NO) = T12.VC_ORIGINAL_NO
   AND T0.L_DATE = T12.L_TRADE_DATE
   AND T12.L_BUSIN_FLAG IN ('41507', '41522')
 WHERE T0.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
   AND T0.L_BUSIN_FLAG IN ('41501', '41521') --41501执行确认,41521中签
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
     AND T0.L_DATE = ${current_date}

      UNION ALL --新规则网下中签
      SELECT '1' AS BUSI_SYS_ID,
       CONCAT('0|' , T10.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , '|0|0') AS TRD_SRC_ID,
             T0.L_DATE AS OCCU_DT, --发生日期
             CASE
               WHEN T0.L_BUSIN_NO IS NULL THEN
                CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
               WHEN T4.L_CONFIRM_NO IS NULL THEN
                CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
               ELSE
                CONCAT(T0.L_DATE , '_HSO32' , '_C' , T4.L_CONFIRM_NO) --执行确认业务无成交序号用C拼上执行确认号作为成交序号
             END AS TNV_ONUM, --成交序号
             NULL AS ODR_ONUM, --指令序号
             CASE
               WHEN T0.L_BUSIN_NO IS NULL THEN
                NULL --当天缺失成交信息，直接为空
               WHEN (T0.L_BUSIN_FLAG= '73171' AND T4.L_CONFIRM_NO IS NULL) OR (T0.L_BUSIN_FLAG<>'73171' AND T10.L_CONFIRM_NO IS NULL) THEN
                NULL --缺少执行确认序号时，为空
               ELSE
                CONCAT((CASE WHEN T0.L_BUSIN_FLAG= '73171' THEN T0.L_DATE ELSE T10.L_CONFIRM_DATE END)
                , '_HSO32' , '_' , (CASE WHEN T0.L_BUSIN_FLAG= '73171' THEN T4.L_CONFIRM_NO ELSE T10.L_CONFIRM_NO END))
             END AS EXCF_ONUM, --执行确认序号
             T4.L_TIME AS EXCF_TIME, --确认时间
             CONCAT(T10.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' ,
                    NVL(T6.VC_REPORT_CODE, T5.VC_REPORT_CODE) , '.STK.' , --股票
                    (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
             		END) , '_' , '05010100') AS ODR_RELA_ONUM,
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,
             T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
               WHEN T6.C_ASSET_CLASS = '2' THEN
                CONCAT(T6.VC_REPORT_CODE , '.STK.' , (CASE
                  WHEN T6.C_MARKET_NO = '1' THEN
                   'SH'
                  WHEN T6.C_MARKET_NO = '2' THEN
                   'SZ'
                END)) --股票
               WHEN T6.C_ASSET_CLASS = '3' THEN
                CONCAT(T6.VC_REPORT_CODE , '.BOND.' , (CASE
                  WHEN T6.C_MARKET_NO = '1' THEN
                   'SH'
                  WHEN T6.C_MARKET_NO = '2' THEN
                   'SZ'
                END)) --债券
               WHEN T6.C_ASSET_CLASS = '4' THEN
                CONCAT(T6.VC_REPORT_CODE , '.FUND.' , (CASE
                  WHEN T6.C_MARKET_NO = '1' THEN
                   'SH'
                  WHEN T6.C_MARKET_NO = '2' THEN
                   'SZ'
                  WHEN T6.C_MARKET_NO = '6' THEN
                   'NONE'
                END)) --基金
               WHEN T5.C_STOCK_TYPE = 'k' THEN
                CONCAT(SUBSTR(T5.VC_ASSET_RELATIVE_CODE,
                       1,
                       LENGTH(T5.VC_ASSET_RELATIVE_CODE) - 2) , '.BOND.' ,
                (CASE
                   WHEN T5.C_MARKET_NO = '1' THEN
                    'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN
                    'SZ'
                 END)) --债券,存在部分还是使用申购代码无法转换成正式代码
               WHEN T5.C_STOCK_TYPE IN ('a', 'd') THEN
                CONCAT(SUBSTR(T5.VC_ASSET_RELATIVE_CODE,
                       1,
                       LENGTH(T5.VC_ASSET_RELATIVE_CODE) - 2) , '.STK.' ,
                (CASE
                   WHEN T5.C_MARKET_NO = '1' THEN
                    'SH'
                   WHEN T5.C_MARKET_NO = '2' THEN
                    'SZ'
                 END)) --股票,存在部分还是使用申购代码无法转换成正式代码
             END AS SECU_ID, --证券编码
             CASE
               WHEN T5.C_MARKET_NO = '1' THEN
                'SH'
               WHEN T5.C_MARKET_NO = '2' THEN
                'SZ'
             END AS EXCH_CODE, --交易市场代码
             T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
             T5.VC_INTER_CODE AS SRC_SECU_ID,
             T6.VC_INTER_CODE AS SRC_SECU_TRD_ID,
             'L' AS POS_ID, --多空标志,默认多头
             T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('73173', '73174', '73171') THEN
                     '050101' --网下新股\债
                 END AS BUSI_TYP, --业务类别
             CASE
                 WHEN T0.C_INVEST_TYPE IN ('1') THEN
                     '2' --交易型金融资产
                 WHEN T0.C_INVEST_TYPE IN ('2') THEN
                     '1' --持有到期资产
                 ELSE
                     T0.C_INVEST_TYPE
                 END AS INV_TYP, --投资类型
             CASE
                 WHEN T0.L_BUSIN_FLAG IN ('73171') THEN
                     '05010101' --网下新股申购执行确认
                 WHEN T0.L_BUSIN_FLAG IN ('73173') THEN
                     '05010102' --网下新股申购中签
                 WHEN T0.L_BUSIN_FLAG IN ('73174') THEN
                     '05010103' --网下新股申购交收
                 END AS BUSI_CLAS, --业务类型
             0 AS CLR_SPED,
             '12' AS ENTR_DIR,
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('73171') THEN
                T0.L_ENTRUST_AMOUNT
               WHEN T0.L_BUSIN_FLAG IN ('73173', '73174') THEN
                T0.L_BUSIN_AMOUNT
             END AS TNV_VOL, --成交数量
             T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('73171') THEN
                T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE
               WHEN T0.L_BUSIN_FLAG IN ('73173', '73174') THEN
                T0.L_BUSIN_AMOUNT * T0.EN_ENTRUST_PRICE
             END AS TNV_VAL, --成交金额
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('73171') THEN
                T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE
               ELSE
                T0.EN_OCCUR_BALANCE
             END AS OCCU_VAL, --发生金额
             T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
             case when T0.L_BUSIN_FLAG = '73173' then T10.L_SETTLE_DATE else NVL(T7.L_SETTLE_DATE, T0.L_DATE) end AS DELI_DT, --交割日期
             0 AS RF_VAL, --  退款金额，
             0 AS MAKP_VAL, -- 补款金额
             T4.EN_FEE_RATIO AS FEER, --费率
             0 as trd_chag, --交易手续费
             T4.C_FEE_DEAL_TYPE as chag_mode, --手续费方式
             null as chag_arvd_dt, --手续费到账日
             nvl(t0.en_fare4, 0) as cms, --佣金
             T10.EN_CBALANCE AS MARG, --  保证金 ，执行确认使用发生金额作为定金
             NULL AS IN_PRD_CODE,
             NULL AS IN_AST_UNIT_CODE,
             NULL AS IN_PFL_CODE,
             NULL AS IN_SH_CODE,
             NULL AS IN_SEAT_CODE,
             NULL AS IN_INV_TYP,
             NULL AS IN_SECU_ID,
             NULL AS IN_SRC_SECU_ID,
             NULL AS IN_ENTR_VOL,
             NULL AS IN_TNV_PRC,
             NULL AS IN_TNV_VAL,
             NULL AS IN_OCCU_VAL,
             CASE
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
                       0 --部分新股非限售
                      ELSE
                       1 --限售，包含网下新股、定增和战略配售
                    END AS RES_FLAG, --限售标志
                    CASE
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
                       5 --网下新股受限
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
                       0 --部分新股非限售
                    END AS LOCK_LMT_CLAS, --锁定受限类型
                    NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
             --REPLACE(T4.C_SETTLE_TYPE, CHR(10), '') AS SETT_MODE, --结算方式
             NULL AS SETT_MODE, --结算方式
             0 as savc_iss_reqy, --续发期数
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
             T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
             T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
             T0.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
             T4.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
             T4.L_OPERATOR_NO AS OPER_NO, --操作员
             T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
             T4.VC_REMARK AS MEMO, --备注
	         '0' AS IS_MARG_MDL, --是否保证金模式
             ${current_date} AS BUSI_DATE, --业务日期
             'evt_ofle_clea_jour_real_3' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	         T0.L_DATE,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T0.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
          ON T0.L_DATE = T5.L_DATE
         AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
         AND T5.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
        LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T4 --获取成交执行序号
          ON T0.L_DATE = T4.L_CONFIRM_DATE
         AND T0.L_BUSIN_NO = T4.L_CONFIRM_NO
        LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T10 --中签找执行确认记录
          ON T4.L_EXECCONFIRM_NO = T10.L_CONFIRM_NO
         AND T4.L_BASECOMBI_ID = T10.L_BASECOMBI_ID
         AND T10.L_BUSIN_FLAG = '73171'
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
          ON T5.L_DATE = T6.L_DATE
         AND (CASE WHEN T5.VC_ASSET_RELATIVE_CODE = T5.VC_INTER_CODE THEN
                       T5.VC_ASSIGN_CODE
                   ELSE
                       T5.VC_ASSET_RELATIVE_CODE
                  END) = T6.VC_INTER_CODE
         AND T6.C_ASSET_CLASS IN ('2', '3', '4', '6')
         AND T6.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
        LEFT JOIN ${ods_db}.O3_TPENDSETTLE T7
          ON T0.L_DATE = T7.L_TRADE_DATE
         AND T0.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
         AND T4.L_CONFIRM_NO = T7.VC_ORIGINAL_NO
         AND T0.L_BUSIN_FLAG = T7.L_BUSIN_FLAG
        LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
          ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
         AND T5.C_MARKET_NO = T9.C_MARKET_NO
       WHERE T0.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
         AND T0.L_BUSIN_FLAG IN
             ( '73173', '73174') --73173网下申购中签,41521网下中签交收
         AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
         AND T0.L_DATE =  ${current_date}

      UNION ALL --网下新股执行确认（新规）
      SELECT '1' AS BUSI_SYS_ID,
       CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID,
             T4.L_CONFIRM_DATE AS OCCU_DT, --发生日期
             CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_C' , T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
             CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
             T4.L_INDEX_DAILY_MODIFY , '_' , NVL(T4.L_STOCK_SERIAL_NO, 0)) AS ODR_ONUM, --指令序号
             CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
             T4.L_TIME AS EXCF_TIME, --确认时间
             NULL AS ODR_RELA_ONUM,
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,
             T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T4.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T4.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
               WHEN T6.C_ASSET_CLASS = '2' THEN
                CONCAT(T6.VC_REPORT_CODE , '.STK.' ,
                (case when T6.C_MARKET_NO='1' then 'SH' when  T6.C_MARKET_NO='2' then  'SZ' else null end )) --股票
               WHEN T6.C_ASSET_CLASS = '3' THEN
                CONCAT(T6.VC_REPORT_CODE , '.BOND.' ,
                (case when T6.C_MARKET_NO='1' then 'SH' when  T6.C_MARKET_NO='2' then  'SZ' else null end )) --债券
               WHEN T5.C_STOCK_TYPE = 'k' THEN
                CONCAT(SUBSTR(T5.VC_ASSET_RELATIVE_CODE,
                       1,
                       LENGTH(T5.VC_ASSET_RELATIVE_CODE) - 2) , '.BOND.' ,
                (case when T5.C_MARKET_NO='1' then 'SH' when  T5.C_MARKET_NO='2' then  'SZ' else null end )) --债券,存在部分还是使用申购代码无法转换成正式代码
               WHEN T5.C_STOCK_TYPE = 'a' THEN
                CONCAT(SUBSTR(T5.VC_ASSET_RELATIVE_CODE,
                       1,
                       LENGTH(T5.VC_ASSET_RELATIVE_CODE) - 2) , '.STK.' ,
                (case when T5.C_MARKET_NO='1' then 'SH' when  T5.C_MARKET_NO='2' then  'SZ' else null end )) --股票,存在部分还是使用申购代码无法转换成正式代码
             END AS SECU_ID, --证券编码
             CASE
               WHEN T5.C_MARKET_NO = '1' THEN
                'SH'
               WHEN T5.C_MARKET_NO = '2' THEN
                'SZ'
             END AS EXCH_CODE, --交易市场代码
             T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
             T5.VC_INTER_CODE AS SRC_SECU_ID,
             T6.VC_INTER_CODE AS SRC_SECU_TRD_ID,
             'L' AS POS_ID, --多空标志,默认多头
             'CNY' AS CURR_CODE, --货币代码
             '050101' AS BUSI_TYP, --业务类别,网下新股\债
             CASE
                 WHEN T4.C_INVEST_TYPE IN ('1') THEN
                     '2' --交易型金融资产
                 WHEN T4.C_INVEST_TYPE IN ('2') THEN
                     '1' --持有到期资产
                 ELSE
                     T4.C_INVEST_TYPE
                 END AS INV_TYP, --投资类型
             '05010101' AS BUSI_CLAS, --业务类型
             0 AS CLR_SPED,
             '12' AS ENTR_DIR,
             T4.EN_AMOUNT AS TNV_VOL, --成交数量
             0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T4.EN_PRICE AS TNV_PRC, --成交价格
             T4.EN_BALANCE AS TNV_VAL, --成交金额
             T4.EN_BALANCE AS OCCU_VAL, --发生金额
             0 AS AFT_OCCU_VAL, --发生后资金金额
             T4.L_SETTLE_DATE AS DELI_DT, --交割日期
             0 AS RF_VAL, --  退款金额，
             0 AS MAKP_VAL, -- 补款金额
             T4.EN_FEE_RATIO AS FEER, --费率
             0 as trd_chag, --交易手续费
             T4.C_FEE_DEAL_TYPE as chag_mode, --手续费方式
             null as chag_arvd_dt, --手续费到账日
             0 as cms, --佣金
             T4.EN_CBALANCE AS MARG, --  保证金 ，执行确认使用发生金额作为定金
             NULL AS IN_PRD_CODE,
             NULL AS IN_AST_UNIT_CODE,
             NULL AS IN_PFL_CODE,
             NULL AS IN_SH_CODE,
             NULL AS IN_SEAT_CODE,
             NULL AS IN_INV_TYP,
             NULL AS IN_SECU_ID,
             NULL AS IN_SRC_SECU_ID,
             NULL AS IN_ENTR_VOL,
             NULL AS IN_TNV_PRC,
             NULL AS IN_TNV_VAL,
             NULL AS IN_OCCU_VAL,
             CASE
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
                       0 --部分新股非限售
                      ELSE
                       1 --限售，包含网下新股、定增和战略配售
                    END AS RES_FLAG, --限售标志
                    CASE
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
                       5 --网下新股受限
                      WHEN NVL(T4.L_RESTRICTED_NO, 0) = 0 THEN
                       0 --部分新股非限售
                    END AS LOCK_LMT_CLAS, --锁定受限类型
                    NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
             --REPLACE(T4.C_SETTLE_TYPE, CHR(10), '') AS SETT_MODE, --结算方式
             NULL AS SETT_MODE, --结算方式
             0 as savc_iss_reqy, --续发期数
             T4.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
             T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T4.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
             T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
             T4.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
             T4.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
             T4.L_OPERATOR_NO AS OPER_NO, --操作员
             T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
             T4.VC_REMARK AS MEMO, --备注
	         '0' AS IS_MARG_MDL, --是否保证金模式
             ${current_date}  AS BUSI_DATE, --业务日期
             'evt_ofle_clea_jour_real_4' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	         T4.L_CONFIRM_DATE,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TOUTCONFIRM T4
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T4.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
          ON T4.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T4.L_CONFIRM_DATE = T5.L_DATE
         AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
         AND T5.C_MARKET_NO IN ('1', '2', '5', '6') --1是上交所、2深交所
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
          ON T5.L_DATE = T6.L_DATE
         AND (CASE WHEN T5.VC_ASSET_RELATIVE_CODE = T5.VC_INTER_CODE THEN
                       T5.VC_ASSIGN_CODE
                   ELSE
                       T5.VC_ASSET_RELATIVE_CODE
                  END) = T6.VC_INTER_CODE
         AND T6.C_ASSET_CLASS IN ('2', '3', '6')
         AND T6.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
        LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
          ON T4.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
         AND T5.C_MARKET_NO = T9.C_MARKET_NO
       WHERE T4.C_BUSIN_CLASS IN ('C') --筛选交易所流水 C：网下股票、转债
         AND T4.L_BUSIN_FLAG IN ('73171') --73171配售（新规则）申购
         AND T4.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
         --AND T4.L_CONFIRM_DATE>=20200228  --20200227及之前不补充
         AND T4.L_CONFIRM_DATE =  ${current_date}

      UNION ALL
-- 跨市场转托管执行确认/手工执行确认
      SELECT '1' AS BUSI_SYS_ID, --业务系统编码
             CONCAT('0|' , T0.L_CONFIRM_DATE , '_HSO32' , '_' ,
                    T0.L_DAILY_INSTRUCTION_NO , '_' , '|0|0') AS TRD_SRC_ID, --交易源ID
             T0.L_CONFIRM_DATE AS OCCU_DT, --发生日期
             CONCAT(T0.L_CONFIRM_DATE , '_HSO32' , '_O' , T0.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
             NULL AS ODR_ONUM, --指令序号
             CONCAT(T0.L_CONFIRM_DATE , '_HSO32' , '_O' , T0.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
             T0.L_TIME AS EXCF_TIME, --确认时间
             CONCAT(T0.L_CONFIRM_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
                    T0.L_BASECOMBI_ID , '_' ,
                    T5.VC_REPORT_CODE , '.BOND.' , --债券
                    (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                          WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
                        END) , '_' ,CASE
                                                             WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                 '2' --交易型金融资产
                                                             WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                 '1' --持有到期资产
                                                             ELSE
                                                                 T0.C_INVEST_TYPE
                                                             END, '_' , '21000100') AS ODR_RELA_ONUM, --指令关联序号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CONCAT(T5.VC_REPORT_CODE , '.BOND.' , --债券
                    (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                          WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
                        END)) AS SECU_ID, --证券编码
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
             CASE WHEN T0.C_TRAN_FLAG = '1' THEN
                      '21000115' --跨市场手工转托管转出执行确认（银行间债券）
                  ELSE
                      '21000111'  --跨市场转托管转出执行确认（债券））
                 END AS BUSI_CLAS, --业务类型
             0 AS CLR_SPED, --清算速度
             '43' AS ENTR_DIR, --委托方向
             T0.EN_AMOUNT AS TNV_VOL, --成交数量
             0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T0.EN_PRICE AS TNV_PRC, --成交价格
             T0.EN_BALANCE AS TNV_VAL, --成交金额
             T0.EN_BALANCE AS OCCU_VAL, --发生金额
             0 AS AFT_OCCU_VAL, --发生后资金金额
             T0.L_CONFIRM_DATE AS DELI_DT, --交割日期
             0 AS RF_VAL, --  退款金额，
             0 AS MAKP_VAL, -- 补款金额
             0 AS FEER, --费率
             T0.EN_FEE as TRD_CHAG, --交易手续费
             NULL AS CHAG_MODE, --手续费方式
             NULL AS CHAG_ARVD_DT, --手续费到账日
             NULL AS CMS, --佣金
             0 AS MARG, --  保证金 ，执行确认使用发生金额作为定金
             T1.VC_FUND_CODE AS IN_PRD_CODE, --转入产品代码
             CONCAT(T1.VC_FUND_CODE , '_' , T8.VC_ASSET_NO) AS IN_AST_UNIT_CODE, --转入资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T8.VC_ASSET_NO , '_' , T7.VC_COMBI_NO) AS IN_PFL_CODE, --转入投组代码
             T0.VC_IN_STOCKHOLDER_ID AS IN_SH_CODE, --转入股东代码
             T0.VC_IN_SEAT_ID AS IN_SEAT_CODE, --转入席位号
             CASE WHEN T0.C_IN_INVEST_TYPE = '1' THEN '2'
                  WHEN T0.C_IN_INVEST_TYPE = '2' THEN '1'
                  WHEN T0.C_IN_INVEST_TYPE = 'a' THEN '15'
                  WHEN T0.C_IN_INVEST_TYPE = 'b' THEN '10'
                  WHEN T0.C_IN_INVEST_TYPE = 'c' THEN '12'
                  ELSE T0.C_IN_INVEST_TYPE
                 END AS IN_INV_TYP, --转入投资类型
             CONCAT(T6.VC_REPORT_CODE , '.BOND.' , --债券
                    (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T6.C_MARKET_NO = '2' THEN 'SZ'
                          WHEN T6.C_MARKET_NO = '5' THEN 'YHJ'
                        END)) AS IN_SECU_ID, --转入证券编码
             T6.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
             T0.EN_AMOUNT AS IN_ENTR_VOL, --转入成交数量
             T0.EN_PRICE AS IN_TNV_PRC, --转入成交价格
             T0.EN_BALANCE AS IN_TNV_VAL, --转入成交金额
             T0.EN_BALANCE AS IN_OCCU_VAL, --转入发生金额
             0 AS RES_FLAG, --限售标志
             NULL AS LOCK_LMT_CLAS, --锁定受限类型
             NULL AS LMT_CLAS_ONUM, --受限类型序号
             NULL AS SETT_MODE, --结算方式
             0 as SAVC_ISS_REQY, --续发期数
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
             T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
             T0.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
             T0.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
             NULL AS TRD_CNTP_ID, -- 交易对手编码
             T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
             T0.C_DEAL_STATUS AS TNV_STAT, --成交状态
             T0.VC_REMARK AS MEMO, --备注
	         NULL AS IS_MARG_MDL, --是否保证金模式
             ${current_date} AS BUSI_DATE, --业务日期
             'evt_ofle_clea_jour_real_5' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.L_CONFIRM_DATE,
             'O3' AS SYS_RS_ID --系统来源标识
      FROM ${ods_db}.O3_TOUTCONFIRM T0  --场外执行确认,当前和历史的合集
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                         ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                         ON T3.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T7 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_IN_COMBI_ID = T7.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TASSET T8 --资产单元基本信息表，获取资产单元代码
                         ON T7.L_ASSET_ID = T8.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                         ON T0.L_DATE = T5.L_DATE
                             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
                         ON T0.L_DATE = T6.L_DATE
                             AND T0.VC_IN_INTERCODE = T6.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
                         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                             AND T5.C_MARKET_NO = T9.C_MARKET_NO
      WHERE T0.C_BUSIN_CLASS IN ('Q')
        AND T0.L_BUSIN_FLAG IN ('72121')
        AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
        AND T0.L_CONFIRM_DATE =  ${current_date}
--   AND T0.L_CONFIRM_DATE = [$DATE]

      UNION ALL
--清算：跨市场转托管成交确认
      SELECT '1' AS BUSI_SYS_ID, --业务系统编码
             CONCAT('0|' , T7.L_CONFIRM_DATE , '_HSO32' , '_' ,
                    T7.L_DAILY_INSTRUCTION_NO , '_' , '|0|0') AS TRD_SRC_ID, --交易源ID
             T4.L_CONFIRM_DATE AS OCCU_DT, --发生日期
             CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号

             NULL AS ODR_ONUM, --指令序号
             CONCAT(T7.L_CONFIRM_DATE , '_HSO32' , '_O' , T7.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
             T4.L_TIME AS EXCF_TIME, --确认时间
             CONCAT(T7.L_CONFIRM_DATE , '_HSO32' , '_' , T7.L_DAILY_INSTRUCTION_NO , '_' ,
                    T0.L_BASECOMBI_ID , '_' ,
                    T5.VC_REPORT_CODE , '.BOND.' , --债券
                    (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                          WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
                        END) , '_' ,CASE
                                                             WHEN T0.C_INVEST_TYPE IN ('1') THEN
                                                                 '2' --交易型金融资产
                                                             WHEN T0.C_INVEST_TYPE IN ('2') THEN
                                                                 '1' --持有到期资产
                                                             ELSE
                                                                 T0.C_INVEST_TYPE
                                                             END, '_' , '21000100') AS ODR_RELA_ONUM, --指令关联序号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CONCAT(T5.VC_REPORT_CODE , '.BOND.' , --债券
                    (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH'
                          WHEN T5.C_MARKET_NO = '2' THEN 'SZ'
                          WHEN T5.C_MARKET_NO = '5' THEN 'YHJ'
                        END)) AS SECU_ID, --证券编码
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
             CASE WHEN T0.L_BUSIN_FLAG = '72122' AND (CASE WHEN T7.C_TRAN_FLAG = '1' THEN 1 ELSE 0 END) = 0 THEN
                      '21000114' --跨市场转托管转入成交确认（债券）
                  WHEN T0.L_BUSIN_FLAG = '72123' AND (CASE WHEN T7.C_TRAN_FLAG = '1' THEN 1 ELSE 0 END) = 0  THEN
                      '21000113'  --跨市场转托管转出成交确认（债券）
                  WHEN T0.L_BUSIN_FLAG = '72122' AND (CASE WHEN T7.C_TRAN_FLAG = '1' THEN 1 ELSE 0 END) = 1 THEN
                      '21000117' --跨市场手工转托管转出成交确认（银行间债券）
                  WHEN T0.L_BUSIN_FLAG = '72123' AND (CASE WHEN T7.C_TRAN_FLAG = '1' THEN 1 ELSE 0 END) = 1  THEN
                      '21000118'  --跨市场手工转托管转入成交确认（银行间债券）
                 END AS BUSI_CLAS, --业务类型
             0 AS CLR_SPED, --清算速度
             '43' AS ENTR_DIR, --委托方向
             T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
             0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
             T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
             T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
             T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
             0 AS AFT_OCCU_VAL, --发生后资金金额
             T0.L_DATE AS DELI_DT, --交割日期
             0 AS RF_VAL, --  退款金额，
             0 AS MAKP_VAL, -- 补款金额
             0 AS FEER, --费率
             T0.EN_FARE4 as TRD_CHAG, --交易手续费
             NULL AS CHAG_MODE, --手续费方式
             NULL AS CHAG_ARVD_DT, --手续费到账日
             NULL AS CMS, --佣金
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
             NULL AS SETT_MODE, --结算方式
             0 as SAVC_ISS_REQY, --续发期数
             T4.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
             T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T4.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
             T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
             T4.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
             NULL AS TRD_CNTP_ID, -- 交易对手编码
             T4.L_OPERATOR_NO AS OPER_NO, --操作员
             T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
             T4.VC_REMARK AS MEMO, --备注
	         NULL AS IS_MARG_MDL, --是否保证金模式
             ${current_date} AS BUSI_DATE, --业务日期
             'evt_ofle_clea_jour_real_6' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T4.L_CONFIRM_DATE,
             'O3' AS SYS_RS_ID --系统来源标识
      FROM ${ods_db}.O3_TCURRENTS T0 --流水表
               LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
                         ON T0.L_FUND_ID = T1.L_FUND_ID
               LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
                         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
               LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
                         ON T3.L_ASSET_ID = T2.L_ASSET_ID
               LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T4  --当前和历史的合集
                         ON T0.L_DATE =T4.L_CONFIRM_DATE
                             AND T0.L_BUSIN_NO =T4.L_CONFIRM_NO
                             AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
               LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T7 --执行确认信息,当前和历史的合集
                         ON T4.L_EXECCONFIRM_NO = T7.L_CONFIRM_NO
                             AND T4.L_FUND_ID = T7.L_FUND_ID
                             AND T7.L_BUSIN_FLAG IN ('72121')
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
                         ON T0.L_DATE = T5.L_DATE
                             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，
                         ON T0.L_DATE = T6.L_DATE
                             AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
               LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
                         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                             AND T5.C_MARKET_NO = T9.C_MARKET_NO
      WHERE T0.C_BUSIN_CLASS IN ('Q')
        AND T0.L_BUSIN_FLAG IN ('72122','72123')
        AND T0.C_STATUS IN ('1') --1-正常
        AND T0.L_DATE =  ${current_date}

UNION ALL
--一级市场债券分销买入成交
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               NULL --当天缺失成交信息，直接为空
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
               NULL --缺少指令序号，直接为空
           ELSE
               CONCAT('0|', T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_', '|0|0')
           END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           WHEN T4.L_CONFIRM_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO)
           ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T4.L_CONFIRM_NO)
           END AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       NULL AS EXCF_ONUM, --执行确认序号
       T4.L_TIME AS EXCF_TIME, --确认时间
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               NULL --当天缺失成交信息，直接为空
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
               NULL --缺少指令序号，直接为空
           ELSE
               CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_',
                      T0.L_BASECOMBI_ID, '_', T5.VC_REPORT_CODE, '.BOND.',
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END), '_',
                      (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
                            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
                            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
                            ELSE T0.C_INVEST_TYPE END), '_',
                      (CASE WHEN T5.C_MARKET_NO IN ('1', '2') THEN
                                '05040100'
                            WHEN T5.C_MARKET_NO IN ('5') THEN
                                '05040200'
                          END)
                   )
           END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE, '.BOND.', --债券
              (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END)) AS SECU_ID, --证券编码
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
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '050401'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '050402'
           END  AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '05040101'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '05040201'
           END AS BUSI_CLAS, --业务类型
       0 AS CLR_SPED, --清算速度
       '21' AS ENTR_DIR, --委托方向
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_DEAL_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T4.L_SETTLE_DATE AS DELI_DT, --交割日期
       0 AS RF_VAL, --  退款金额，
       0 AS MAKP_VAL, -- 补款金额
       T4.EN_FEE_RATIO AS FEER, --费率
       ABS(T4.EN_FEE) as TRD_CHAG, --交易手续费
       T4.C_FEE_DEAL_TYPE AS CHAG_MODE, --手续费方式
       NULL AS CHAG_ARVD_DT, --手续费到账日
       NULL AS CMS, --佣金
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
       NULL AS SETT_MODE, --结算方式
       0 as SAVC_ISS_REQY, --续发期数
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T4.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T4.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
       T4.VC_REMARK AS MEMO, --备注
	   NULL AS IS_MARG_MDL, --是否保证金模式
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_clea_jour_real_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T4 --获取成交执行序号
              ON T0.L_DATE = T4.L_CONFIRM_DATE
             AND T0.L_BUSIN_NO = T4.L_CONFIRM_NO
             AND T4.C_STATUS = '1' --正常
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
             AND T5.C_MARKET_NO IN ('1', '2', '5', '6')
       LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T6
              ON T0.L_DATE = T6.L_DATE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
              ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
             AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('D') --筛选交易所流水 D：债券一级市场
   AND T0.L_BUSIN_FLAG IN ('40321') --40321分销买入成交确认
   AND T0.EN_DEAL_BALANCE <> 0 --识别成交确认
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.L_DATE = ${current_date}

UNION ALL
--一级市场债券分销缴款
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               NULL --当天缺失成交信息，直接为空
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
               NULL --缺少指令序号，直接为空
           ELSE
               CONCAT('0|', T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_', '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
           WHEN T4.L_CONFIRM_NO IS NULL THEN
               CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO)
           ELSE
               CONCAT(T0.L_DATE, '_HSO32', '_', T4.L_CONFIRM_NO, 'C')
       END AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       NULL AS EXCF_ONUM, --执行确认序号
       T4.L_TIME AS EXCF_TIME, --确认时间
       CASE
           WHEN T0.L_BUSIN_NO IS NULL THEN
               NULL --当天缺失成交信息，直接为空
           WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
               NULL --缺少指令序号，直接为空
           ELSE
               CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_DAILY_INSTRUCTION_NO, '_',
                      T0.L_BASECOMBI_ID, '_', T6.VC_REPORT_CODE, '.BOND.',
                      (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END), '_',
                      (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                            WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                            WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
                            WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
                            WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
                            ELSE T0.C_INVEST_TYPE END), '_',
                      (CASE WHEN T5.C_MARKET_NO IN ('1', '2') THEN '05040100'
                            WHEN T5.C_MARKET_NO IN ('5') THEN '05040200'
                          END)
                   )
       END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T6.VC_REPORT_CODE, '.BOND.', --债券
              (CASE WHEN T5.C_MARKET_NO = '1' THEN 'SH' WHEN T5.C_MARKET_NO = '2' THEN 'SZ' WHEN T5.C_MARKET_NO = '5' THEN 'YHJ' END)) AS SECU_ID, --证券编码
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
       'L' AS POS_ID, --多空标志,默认多头
       'CNY' AS CURR_CODE, --货币代码
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '050401'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '050402'
       END AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
           WHEN T5.C_MARKET_NO IN ('1', '2') THEN
               '05040102'
           WHEN T5.C_MARKET_NO IN ('5') THEN
               '05040202'
       END AS BUSI_CLAS, --业务类型
       0 AS CLR_SPED, --清算速度
       '21' AS ENTR_DIR, --委托方向
       T4.EN_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       case when nvl(T0.EN_ENTRUST_PRICE,0) = 0 then t4.en_price else T0.EN_ENTRUST_PRICE end AS TNV_PRC, --成交价格
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       T4.L_SETTLE_DATE AS DELI_DT, --交割日期
       0 AS RF_VAL, --  退款金额，
       0 AS MAKP_VAL, -- 补款金额
       T4.EN_FEE_RATIO AS FEER, --费率
       ABS(T4.EN_FEE) as TRD_CHAG, --交易手续费
       T4.C_FEE_DEAL_TYPE AS CHAG_MODE, --手续费方式
       NULL AS CHAG_ARVD_DT, --手续费到账日
       NULL AS CMS, --佣金
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
       NULL AS SETT_MODE, --结算方式
       T7.L_TIMES as SAVC_ISS_REQY, --续发期数
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T4.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T4.L_BUSIN_FLAG as busi_clas_dtl_o3, --业务类型明细_O3
       NULL AS TRD_CNTP_ID, -- 交易对手编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
       T4.VC_REMARK AS MEMO, --备注
	   NULL AS IS_MARG_MDL, --是否保证金模式
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_ofle_clea_jour_real_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T4 --获取成交执行序号
              ON T0.L_DATE = T4.L_CONFIRM_DATE
             AND T0.L_BUSIN_NO = T4.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
              ON T0.L_DATE = T5.L_DATE
             AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
             AND T5.C_ASSET_CLASS IN ('2', '3', '4', '6')
             AND T5.C_MARKET_NO IN ('1', '2', '5', '6')
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
              ON T5.L_DATE = T6.L_DATE
             AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
             AND T6.C_ASSET_CLASS IN ('2', '3', '6')
       LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T7
              ON T0.L_DATE = T7.L_DATE
             AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
              ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
             AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('D') --筛选交易所流水 D：债券一级市场
   AND T0.L_BUSIN_FLAG IN ('40321') --40321分销买入成交确认
   AND T0.EN_OCCUR_BALANCE <> 0 --识别缴款
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要
   AND T0.L_DATE = ${current_date}