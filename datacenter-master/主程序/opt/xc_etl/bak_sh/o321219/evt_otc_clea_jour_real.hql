------------------------------------------------------------------------
--模块名称：场外清算流水表(盘后)
--场外申购、赎回、转换业务的取数逻辑
--场外开基转换执行(转入)确认
--离线清算：存款存入执行确认
--离线清算：存款存入成交确认
--离线清算：存款支取成交确认
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

alter table ${dwd_db}.evt_otc_clea_jour_his drop if exists partition (p_dt = ${current_date}, sys_rs_id='O3') ;

WITH VHISOUTCONFIRM AS (
       SELECT L_DATE,
               L_FUND_ID,
               L_CONFIRM_DATE,
               L_CONFIRM_NO,
               L_EXECCONFIRM_NO,
               L_BUSIN_FLAG,
               EN_INTEREST,
               L_SETTLE_DATE,
               C_EXCEED_FLAG,
               EN_BALANCE,
               L_DAILY_INSTRUCTION_NO,
               L_INDEX_DAILY_MODIFY,
               L_STOCK_SERIAL_NO,
               EN_FEE_RATIO,
               C_SETTLE_TYPE,
               C_BUSIN_PRO_TYPE,
               C_DEAL_STATUS,
               VC_REMARK,
               EN_PUNISH_INTEREST,
               EN_PROFIT_RATIO,
               L_OPERATOR_NO,
               L_RIVAL_ID,
               L_TIME,
               L_BASECOMBI_ID,
               EN_AMOUNT,EN_DEAL_AMOUNT,EN_DEAL_BALANCE
          FROM ${ods_db}.O3_TOUTCONFIRM
         WHERE C_STATUS = '1' --正常
        UNION ALL
        SELECT L_DATE,
               L_FUND_ID,
               L_CONFIRM_DATE,
               L_CONFIRM_NO,
               L_EXECCONFIRM_NO,
               L_BUSIN_FLAG,
               EN_INTEREST,
               L_SETTLE_DATE,
               C_EXCEED_FLAG,
               EN_BALANCE,
               L_DAILY_INSTRUCTION_NO,
               L_INDEX_DAILY_MODIFY,
               L_STOCK_SERIAL_NO,
               EN_FEE_RATIO,
               C_SETTLE_TYPE,
               C_BUSIN_PRO_TYPE,
               C_DEAL_STATUS,
               VC_REMARK,
               EN_PUNISH_INTEREST,
               EN_PROFIT_RATIO,
               L_OPERATOR_NO,
               L_RIVAL_ID,
               L_TIME,
               L_BASECOMBI_ID,
               EN_AMOUNT,EN_DEAL_AMOUNT,EN_DEAL_BALANCE
          FROM ${ods_db}.O3_THISOUTCONFIRM
         WHERE C_STATUS = '1' --正常
),
 VHISPENDSETTLE AS ( --待交割表数据当前和历史的集合（目前用于存款存入）
             SELECT L_SERIAL_NO,
                    L_ENTRUST_SERIAL_NO,
                    L_TRADE_DATE,
                    VC_ORIGINAL_NO,
                    C_ENTRUST_DIRECTION,
                    VC_DEAL_NO,
                    L_RELATE_NO,
                    VC_INTER_CODE,
                    L_BASECOMBI_ID,
                    L_BUSIN_FLAG,
                    L_SETTLE_DATE
               FROM ${ods_db}.O3_THISPENDSETTLE t0
              WHERE C_STATUS = '1'
              AND t0.L_BUSIN_FLAG IN (40227)
             UNION ALL
             SELECT L_SERIAL_NO,
                    L_ENTRUST_SERIAL_NO,
                    L_TRADE_DATE,
                    VC_ORIGINAL_NO,
                    C_ENTRUST_DIRECTION,
                    VC_DEAL_NO,
                    L_RELATE_NO,
                    VC_INTER_CODE,
                    L_BASECOMBI_ID,
                    L_BUSIN_FLAG,
                    L_SETTLE_DATE
               FROM ${ods_db}.O3_TPENDSETTLE t1
              WHERE C_STATUS = '1'
              AND t1.L_BUSIN_FLAG IN (40227)
)
insert into ${dwd_db}.evt_otc_clea_jour_his partition(p_dt, sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,excf_time,tnv_onum,odr_onum,excf_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,entr_dir,tnv_vol,aft_par_vol,tnv_prc,tnv_val,rf_val,rf_intr,occu_val,aft_occu_val,pr_fee,intr_val,puni_val,deli_dt,dpsi_rat,huge_redp_mode,bons_mode,bgng_has_tnv_vol,bgng_has_tnv_val,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,expe_yld,tnv_stat,trd_cntp_id,oper_no,memo,dpsi_agmt_num,dpsi_no,dpsi_typ,bnk_hbnk_id,pay_dt,srte_dt,end_dt,ahed_coll_lim,ahed_coll_noty_days,intr_tran_dpsi,appt_tran_dpsi,cont_id,whdw_clas,whdw_dt,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--场外申购、赎回、转换业务的取数逻辑
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
          CONCAT('0|',
                 T4.L_CONFIRM_DATE,
                 '_HSO32',
                 '_',
                 T4.L_DAILY_INSTRUCTION_NO,
                 '|0|0')
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41542', '41549', '41550', '41546') THEN
          CONCAT('0|',
                 T8.L_CONFIRM_DATE,
                 '_HSO32',
                 '_',
                 T8.L_DAILY_INSTRUCTION_NO,
                 '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T4.L_TIME AS EXCF_TIME, --确认时间
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          CONCAT(T0.L_DATE, '_HSO32', '_L', T0.L_SERIAL_NO) --当天缺失执行确认信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
          CONCAT(T0.L_DATE, '_HSO32', '_C', T4.L_CONFIRM_NO) --执行确认业务无成交序号用C拼上执行确认号作为成交序号
         ELSE
          CONCAT(T0.L_DATE, '_HSO32', '_', T4.L_CONFIRM_NO)
       END AS TNV_ONUM, --成交序号
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失成交信息，直接为空
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
          NULL --缺少指令序号，直接为空
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
          CONCAT(T4.L_CONFIRM_DATE,
                 '_HSO32',
                 '_',
                 T4.L_DAILY_INSTRUCTION_NO,
                 '_',
                 T4.L_INDEX_DAILY_MODIFY,
                 '_',
                 NVL(T4.L_STOCK_SERIAL_NO, 0))
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41542', '41549', '41550', '41546') THEN
          CONCAT(T8.L_CONFIRM_DATE,
                 '_HSO32',
                 '_',
                 T4.L_DAILY_INSTRUCTION_NO,
                 '_',
                 T4.L_INDEX_DAILY_MODIFY,
                 '_',
                 NVL(T4.L_STOCK_SERIAL_NO, 0))
       END AS ODR_ONUM, --指令序号，指令日期为空，目前指令序号未做统一
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失执行确认信息，直接为空
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
          CONCAT(T4.L_CONFIRM_DATE, '_HSO32', '_', T4.L_CONFIRM_NO) --执行确认信息取确认号
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41542', '41549', '41550', '41546') THEN
          CONCAT(T8.L_CONFIRM_DATE, '_HSO32', '_', T4.L_EXECCONFIRM_NO) --成交确认信息取执行确认号
       END AS EXCF_ONUM, --执行确认序号
       CONCAT(CASE WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
                              T4.L_CONFIRM_DATE
                            WHEN T0.L_BUSIN_FLAG IN ('41535', '41542', '41549', '41550', '41546') THEN
                              T8.L_CONFIRM_DATE
                            END,
              '_HSO32',
              '_',
              T4.L_DAILY_INSTRUCTION_NO,
              '_',
              T0.L_BASECOMBI_ID,
              '_',
              T5.VC_REPORT_CODE,
              '.FUND.NONE',
              '_',
              CASE
                WHEN T0.C_INVEST_TYPE = '1' THEN
                 '2'
                WHEN T0.C_INVEST_TYPE = '2' THEN
                 '1'
                WHEN T0.C_INVEST_TYPE = 'a' THEN
                 '15'
                WHEN T0.C_INVEST_TYPE = 'b' THEN
                 '10'
                WHEN T0.C_INVEST_TYPE = 'c' THEN
                 '12'
                ELSE
                 T0.C_INVEST_TYPE
              END,
              '_',
              CASE
                WHEN T0.L_BUSIN_FLAG IN ('41545', '41546') THEN
                 '09000309' --场外认购执行确认
                WHEN T0.L_BUSIN_FLAG IN ('41534', '41535') THEN
                 '09000312' --场外申购执行确认
                WHEN T0.L_BUSIN_FLAG IN ('41541', '41542') THEN
                 '09000315' --场外赎回执行确认
                WHEN T0.L_BUSIN_FLAG IN ('41548', '41549', '41550') THEN
                 '09000317' --场外转换执行确认
              END) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CASE
         WHEN T5.C_ASSET_CLASS = '4' THEN
          CONCAT(T5.VC_REPORT_CODE, '.FUND.NONE') --基金,非公募基金使用的是自定义的基金代码
       END AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,默认多头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '090003' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41545') THEN
          '09000300' --场外认购执行确认
         WHEN T0.L_BUSIN_FLAG IN ('41546') THEN
          '09000301' --场外认购成交确认
         WHEN T0.L_BUSIN_FLAG IN ('41534') THEN
          '09000302' --场外申购执行确认
         WHEN T0.L_BUSIN_FLAG IN ('41541') THEN
          '09000304' --场外赎回执行确认
         WHEN T0.L_BUSIN_FLAG IN ('41548') THEN
          '09000306' --场外转换执行确认
         WHEN T0.L_BUSIN_FLAG IN ('41535') THEN
          '09000303' --场外申购成交确认
         WHEN T0.L_BUSIN_FLAG IN ('41542') THEN
          '09000305' --场外赎回成交确认
         WHEN T0.L_BUSIN_FLAG IN ('41549') THEN
          '09000307' --场外转换成交（转出）确认
         WHEN T0.L_BUSIN_FLAG IN ('41550') THEN
          '09000308' --场外转换成交（转入）确认
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41545', '41546') THEN
          '13'
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41535') THEN
          '53'
         WHEN T0.L_BUSIN_FLAG IN ('41541', '41542') THEN
          '54'
         WHEN T0.L_BUSIN_FLAG IN ('41548', '41549', '41550') THEN
          '14'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41545') THEN
          T0.EN_OCCUR_BALANCE / T0.EN_ENTRUST_PRICE --记录中存在数量错误情况
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548') THEN
          T0.L_ENTRUST_AMOUNT --执行确认取委托数量
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41542', '41549', '41550', '41546') THEN
          T0.L_BUSIN_AMOUNT --成交确认取成交数量
       END AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41542', '41549', '41550') AND
              T0.L_BUSIN_AMOUNT <> 0 THEN
          T0.EN_DEAL_BALANCE / T0.L_BUSIN_AMOUNT --转入时价格不对，采用成交金额/成交数量
         ELSE
          T0.EN_ENTRUST_PRICE
       END AS TNV_PRC, --成交价格
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41545') THEN
          T0.EN_OCCUR_BALANCE --记录中存在数量错误情况
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548') THEN
          case when nvl(T0.EN_OCCUR_BALANCE,0) = 0 then T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE else T0.EN_OCCUR_BALANCE end --执行确认，使用委托数量*成交价格
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41546', '41549', '41550', '41542') THEN
          T0.EN_DEAL_BALANCE ----申购、转出成交确认,赎回和转入执行确认，使用成交金额
       END AS TNV_VAL, --成交金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41535', '41546') THEN
          NVL(T7.EN_BALANCE, 0)
         ELSE
          0
       END AS RF_VAL, --  退款金额  申购成交取执行确认表的退款金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41535', '41546') THEN
          nvl(T4.EN_INTEREST, 0)
         ELSE
          0
       END AS RF_INTR, --退款利息  申购成交取执行确认表的退款利息
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41545') THEN
          T0.EN_OCCUR_BALANCE --记录中存在数量错误情况
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548') THEN
          case when nvl(T0.EN_OCCUR_BALANCE,0) = 0 then T0.L_ENTRUST_AMOUNT * T0.EN_ENTRUST_PRICE else T0.EN_OCCUR_BALANCE end
         WHEN T0.L_BUSIN_FLAG IN ('41535', '41546', '41550') THEN
          T0.EN_DEAL_BALANCE + nvl(T0.EN_FARE7, 0) --申购、转入需要加入费用
         WHEN T0.L_BUSIN_FLAG IN ('41542', '41549') THEN
          T0.EN_DEAL_BALANCE - nvl(T0.EN_FARE7, 0) --赎回、转出成交需要减去费用
       END AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       CASE
         WHEN T0.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') THEN
          0
         WHEN T0.L_BUSIN_FLAG IN
              ('41535', '41542', '41549', '41550', '41546') THEN
          nvl(T0.EN_FARE7, 0)
       END AS PR_FEE, --申赎费用 ，--成交确认有申赎费用
       0 AS INTR_VAL, --利息金额
       0 AS PUNI_VAL, --罚息金额
       CASE
                    WHEN T0.L_BUSIN_FLAG IN
                            ('41534', '41545', '41541', '41548') THEN T4.L_DATE
              		 WHEN T0.L_BUSIN_FLAG IN
                            ('41546', '41535', '41542', '41549', '41550') THEN T4.L_SETTLE_DATE
              END AS DELI_DT, --交割日期 申购、认购执行确认、赎回成交确认取交割表的交割日期，申购、认购成交确认如有退款则取交割表的交割日期，无则取当天，对于赎回执行确认、转换执行确认和成交确认取当天
       NULL AS DPSI_RAT, --存款利率
       CASE
         WHEN T0.L_BUSIN_FLAG IN
              ('41541', '41542', '41548', '41549', '41550') THEN
          T4.C_EXCEED_FLAG
       END AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       NVL(T4.EN_DEAL_AMOUNT, 0) AS BGNG_HAS_TNV_VOL, --期初已成交数量
       NVL(T4.EN_DEAL_BALANCE, 0) AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.L_BUSIN_FLAG as BUSI_CLAS_DTL_O3, --业务类型明细_O3
       t4.EN_PROFIT_RATIO as EXPE_YLD, --预期收益率
       T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
       T4.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.VC_REMARK AS MEMO, --备注
       NULL AS DPSI_AGMT_NUM, --存款合同号
       NULL AS DPSI_NO, --银行存单编号
       NULL AS DPSI_TYP, --存款类型
       NULL AS BNK_HBNK_ID, --银行总行编码
       NULL AS PAY_DT, --缴款日期
       NULL AS SRTE_DT, --起息日期
       NULL AS END_DT, --到期日期
       NULL AS AHED_COLL_LIM, --提前支取限制
       NULL AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS APPT_TRAN_DPSI, --存款约定转存
       NULL AS CONT_ID, --合约编码
       NULL AS WHDW_CLAS, --支取类型
       NULL AS WHDW_DT, --支取日期
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_otc_clea_jour_real_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN VHISOUTCONFIRM T4 --获取成交执行序号
    ON T0.L_DATE = T4.L_CONFIRM_DATE
   AND T0.L_BUSIN_NO = T4.L_CONFIRM_NO
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('4')
  LEFT JOIN VHISOUTCONFIRM T7 --获取退款金额
    ON T4.L_EXECCONFIRM_NO = T7.L_EXECCONFIRM_NO
   AND T7.L_BUSIN_FLAG IN ('41536', '41547')
  LEFT JOIN VHISOUTCONFIRM T8 --获取执行确认日期
    ON T4.L_EXECCONFIRM_NO = T8.L_CONFIRM_NO
   AND T0.L_FUND_ID = T8.L_FUND_ID
   AND T4.L_DAILY_INSTRUCTION_NO = T8.L_DAILY_INSTRUCTION_NO
   AND T8.L_BUSIN_FLAG IN ('41534', '41541', '41548', '41545') --执行确认记录
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('A') --41542 A：开放式基金
   AND (T0.L_BUSIN_FLAG IN
 ('41545', '41546', '41534', '41541', '41548', '41542', '41549')
 --41545场外认购执行确认,41546场外认购成交确认,
 --41534场外申购执行确认,41535场外申购成交确认,
 --41541场外赎回执行确认,41542场外赎回成交确认,
 --41548场外转换执行确认,41549场外转换成交（转出）确认,41550场外转换转入成交确认
 OR
 (T0.L_BUSIN_FLAG IN ('41535', '41550') AND nvl(T0.C_DEAL_TYPE,0) <> '2') --不等于交收
 )
   AND T0.C_STATUS = '1' --1-正常，2-回溯，3-被回溯；2和3为冲减不需要  '41534','41541','41548','41535','41542','41549','41550'
   AND T5.C_MARKET_NO NOT IN ('1', '2')
   and T0.L_DATE = ${current_date}

UNION ALL
--场外开基转换执行(转入)确认
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
	   NULL AS EXCF_TIME,--确认时间
       CONCAT(T0.L_DATE , '_HSO32' , '_O' , T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
	   NULL AS ODR_ONUM,--指令序号
       CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
       CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
       T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.NONE' , '_' ,
       CASE
        WHEN T0.C_INVEST_TYPE = '1' THEN
         '2'
        WHEN T0.C_INVEST_TYPE = '2' THEN
         '1'
        WHEN T0.C_INVEST_TYPE = 'a' THEN
         '15'
        WHEN T0.C_INVEST_TYPE = 'b' THEN
         '10'
        WHEN T0.C_INVEST_TYPE = 'c' THEN
         '12'
        ELSE
         T0.C_INVEST_TYPE
       END , '_' , '09000306') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '090003' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '09000318' AS BUSI_CLAS, --业务类型
       '14' AS ENTR_DIR, --委托方向
       T7.L_AMOUNT AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       CASE WHEN T7.EN_PRICE1 = 0 THEN T7.EN_FACT_PRICE ELSE T7.EN_PRICE1 END AS TNV_PRC, --成交价格
       T7.EN_BALANCE AS TNV_VAL, --成交金额
       0 AS RF_VAL, --退款金额
       0 AS RF_INTR, --退款利息
       T7.EN_BALANCE OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS PR_FEE, --申赎费用
       0 AS INTR_VAL, --利息金额
       0 AS PUNI_VAL, --罚息金额
       T4.L_CONFIRM_DATE AS DELI_DT, --交割日期
       NULL AS DPSI_RAT, --存款利率
       T4.C_EXCEED_FLAG AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       NVL(T4.EN_DEAL_AMOUNT, 0) AS BGNG_HAS_TNV_VOL, --期初已成交数量
       NVL(T4.EN_DEAL_BALANCE, 0) AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.L_BUSIN_FLAG AS BUSI_CLAS_DTL_O3, --业务分类明细_O32
       T4.EN_PROFIT_RATIO AS EXPE_YLD, --预期收益率
       T4.C_DEAL_STATUS AS TNV_STAT, --成交状态
	   NULL AS TRD_CNTP_ID,--交易对手编码
       T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T4.VC_REMARK AS MEMO, --备注
       NULL AS DPSI_AGMT_NUM, --存款合同号
       NULL AS DPSI_NO, --银行存单编号
       NULL AS DPSI_TYP, --存款类型
       NULL AS BNK_HBNK_ID, --银行总行编码
       NULL AS PAY_DT, --缴款日期
       NULL AS SRTE_DT, --起息日期
       NULL AS END_DT, --到期日期
       NULL AS AHED_COLL_LIM, --提前支取限制
       NULL AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS APPT_TRAN_DPSI, --存款约定转存
       NULL AS CONT_ID, --合约编码
       NULL AS WHDW_CLAS, --支取类型
       NULL AS WHDW_DT, --支取日期
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_otc_clea_jour_real_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN VHISOUTCONFIRM T4 --场外执行确认
    ON T0.L_DATE = T4.L_CONFIRM_DATE
   AND T0.L_BUSIN_NO = T4.L_CONFIRM_NO
   AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T7
    ON T4.L_DATE = T7.L_DATE
   AND T4.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
   AND T4.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
   AND T7.C_ENTRUST_DIRECTION IN ('p')
   AND T7.C_ORIGINAL_DIRECTION IN ('E')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
    ON T7.L_DATE = T5.L_DATE
   AND T7.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T0.L_BUSIN_FLAG IN ('41548')
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯
   AND T0.L_DATE = ${current_date}

UNION ALL
--离线清算：存款存入执行确认
SELECT T4.L_CONFIRM_DATE AS OCCU_DT, --发生日期
     T4.L_TIME AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
     NULL AS EXCF_TIME, --确认时间
     CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_O' , T4.L_CONFIRM_NO) AS TNV_ONUM, --成交序号
     NULL AS ODR_ONUM, --指令序号
     CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_O' , T4.L_CONFIRM_NO) AS EXCF_ONUM, --执行确认序号
     CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE' , '_' ,
            CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                 WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                 WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
                 WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
                 WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
                 ELSE T0.C_INVEST_TYPE END , '_' ,
            '16000304') AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' , T1.VC_FUND_CODE , '-' , T7.L_BEGIN_DATE , '-' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_ID, --证券编码
     'NONE' AS EXCH_CODE, --交易市场代码
     CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
          WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
          WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
          WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
     END AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '160003' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '16000304' AS BUSI_CLAS, --业务类型
     '16' AS ENTR_DIR, --委托方向
     T4.EN_AMOUNT AS TNV_VOL, --成交数量
     0 AS AFT_PAR_VOL, --发生后数量
     1 AS TNV_PRC, --成交价格
     T4.EN_BALANCE AS TNV_VAL, --成交金额
     0 AS RF_VAL, --退款金额
     0 AS RF_INTR, --退款利息
     T4.EN_BALANCE OCCU_VAL, --发生金额
     0 AS AFT_OCCU_VAL, --发生后资金金额
     0 AS PR_FEE, --申赎费用
     0 AS INTR_VAL, --利息金额
     0 AS PUNI_VAL, --罚息金额
     T6.L_SETTLE_DATE AS DELI_DT, --交割日期
     T7.EN_RATE AS DPSI_RAT, --存款利率
     NULL AS HUGE_REDP_MODE, --巨额赎回方式
     NULL AS BONS_MODE, --分红方式
     NVL(T4.EN_DEAL_AMOUNT, 0) AS BGNG_HAS_TNV_VOL, --期初已成交数量
     NVL(T4.EN_DEAL_BALANCE, 0) AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
     T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
     T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
     T0.L_BUSIN_FLAG AS BUSI_CLAS_DTL_O3, --业务分类明细_O32
     NULL AS EXPE_YLD, --预期收益率
     '1' AS TNV_STAT, --成交状态
     NULL AS TRD_CNTP_ID, --交易对手编码
     T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T4.VC_REMARK AS MEMO, --备注
     T7.VC_INTER_NO AS DPSI_AGMT_NUM, --存款合同号
     T7.VC_RECEIPT_NO AS DPSI_NO, --银行存单编号
     CASE
          WHEN T5.VC_REPORT_CODE = '850850' THEN
               '1' --活期存款
          WHEN T5.VC_REPORT_CODE = '890890' THEN
               '3' --协议存款
          WHEN T5.VC_REPORT_CODE = '870870' THEN
               '2' --定期存款
          WHEN T5.VC_REPORT_CODE = '860860' THEN
               '4' --通知存款
          WHEN T5.VC_REPORT_CODE = '880880' THEN
               '6' --次级债务
     END AS DPSI_TYP, --存款类型
     T7.L_BANK AS BNK_HBNK_ID, --银行总行编码
     T6.L_SETTLE_DATE AS PAY_DT, --缴款日期
     T7.L_BEGIN_DATE AS SRTE_DT, --起息日期
     T7.L_END_DATE AS END_DT, --到期日期
     T7.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
     T7.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
     T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
     T7.C_AUTO_REDEPOSIT AS APPT_TRAN_DPSI, --存款约定转存
     CONCAT(T7.L_DATE , '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
     NULL AS WHDW_CLAS, --支取类型
     NULL AS WHDW_DT, --支取日期
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_otc_clea_jour_real_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_CONFIRM_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0  --清算流水表
       INNER JOIN ${ods_db}.O3_TPENDSETTLE T6
         ON T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                AND T0.L_DATE = T6.L_TRADE_DATE
                AND T6.L_BUSIN_FLAG IN ('40227')
       LEFT JOIN ${ods_db}.O3_TOUTCONFIRM T4 --场外执行确认
         ON T0.L_DATE = T4.L_CONFIRM_DATE
                AND T0.L_BUSIN_NO =T4.L_CONFIRM_NO
                AND T4.L_BUSIN_FLAG = '40227'
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
         ON CAST(T0.L_BUSIN_NO AS STRING) = T7.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T0.L_BUSIN_FLAG IN ('72133') --存款执行冻结资金
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T4.L_CONFIRM_DATE = ${current_date}

 UNION ALL
--离线清算：存款存入成交确认
SELECT T0.L_DATE AS OCCU_DT, --发生日期
     NULL AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T4.L_DATE IS NULL THEN
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
          ELSE
               CONCAT('0|' , T8.L_CONFIRM_DATE , '_HSO32' , '_' , T8.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     NULL AS EXCF_TIME, --确认时间
     CASE
          WHEN T4.L_DATE IS NULL THEN
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
          ELSE
               CONCAT(T0.L_DATE , '_HSO32' , '_' , T8.L_CONFIRM_NO)
     END AS TNV_ONUM, --成交序号
     NULL AS ODR_ONUM, --指令序号
     CASE
          WHEN T4.L_DATE IS NULL THEN
               NULL
          ELSE
               CONCAT(T8.L_CONFIRM_DATE , '_HSO32' , '_O' , T8.L_CONFIRM_NO)
     END AS EXCF_ONUM, --执行确认序号
     CASE
          WHEN T4.L_DATE IS NULL THEN
               NULL
          ELSE
               CONCAT(T8.L_CONFIRM_DATE , '_HSO32' , '_' , T8.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                      CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                           WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                           WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                           WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
                      END , '.DPSI.NONE' , '_' ,
                      CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                           WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                           WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
                           WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
                           WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
                           ELSE T0.C_INVEST_TYPE END , '_' ,
                      (CASE
                            WHEN T7.C_INPUT_TYPE = '1' AND T8.L_CONFIRM_DATE IS NULL  THEN
                                 '99040000' --存款新增存单（手工）
                            ELSE
                                 '16000300'
                       END))
     END
          AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0')  , '-' , T1.VC_FUND_CODE , '-' , T7.L_BEGIN_DATE , '-' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_ID, --证券编码
     'NONE' AS EXCH_CODE, --交易市场代码
     CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
          WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
          WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
          WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
     END AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     CASE
          WHEN T7.C_INPUT_TYPE = '1' AND T8.L_CONFIRM_DATE IS NULL THEN
               '990400' --存款新增存单（手工）
          ELSE
               '160003'
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
          WHEN T7.C_INPUT_TYPE = '1' AND T8.L_CONFIRM_DATE IS NULL THEN
               '99040000' --存款新增存单（手工）
          ELSE
               '16000305'
     END AS BUSI_CLAS, --业务类型
     '16' AS ENTR_DIR, --委托方向
     T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
     0 AS AFT_PAR_VOL, --发生后数量
     1 AS TNV_PRC, --成交价格
     T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
     0 AS RF_VAL, --退款金额
     0 AS RF_INTR, --退款利息
     T0.EN_OCCUR_BALANCE OCCU_VAL, --发生金额
     0 AS AFT_OCCU_VAL, --发生后资金金额
     0 AS PR_FEE, --申赎费用
     0 AS INTR_VAL, --利息金额
     0 AS PUNI_VAL, --罚息金额
     CASE WHEN T4.L_DATE IS NULL THEN T0.L_DATE ELSE T4.L_SETTLE_DATE END AS DELI_DT, --交割日期
     T7.EN_RATE AS DPSI_RAT, --存款利率
     NULL AS HUGE_REDP_MODE, --巨额赎回方式
     NULL AS BONS_MODE, --分红方式
     NULL AS BGNG_HAS_TNV_VOL, --期初已成交数量
     NULL AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
     T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
     T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
     T0.L_BUSIN_FLAG AS BUSI_CLAS_DTL_O3, --业务分类明细_O32
     NULL AS EXPE_YLD, --预期收益率
     '1' AS TNV_STAT, --成交状态
     NULL AS TRD_CNTP_ID,--交易对手编码
     T8.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T8.VC_REMARK AS MEMO, --备注
     T7.VC_INTER_NO AS DPSI_AGMT_NUM, --存款合同号
     T7.VC_RECEIPT_NO AS DPSI_NO, --银行存单编号
     CASE
          WHEN T5.VC_REPORT_CODE = '850850' THEN
               '1' --活期存款
          WHEN T5.VC_REPORT_CODE = '890890' THEN
               '3' --协议存款
          WHEN T5.VC_REPORT_CODE = '870870' THEN
               '2' --定期存款
          WHEN T5.VC_REPORT_CODE = '860860' THEN
               '4' --通知存款
          WHEN T5.VC_REPORT_CODE = '880880' THEN
               '6' --次级债务
     END AS DPSI_TYP, --存款类型
     T7.L_BANK AS BNK_HBNK_ID, --银行总行编码
     T4.L_SETTLE_DATE AS PAY_DT, --缴款日期
     T7.L_BEGIN_DATE AS SRTE_DT, --起息日期
     T7.L_END_DATE AS END_DT, --到期日期
     T7.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
     T7.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
     T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
     T7.C_AUTO_REDEPOSIT AS APPT_TRAN_DPSI, --存款约定转存
     CONCAT(T7.L_DATE , '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
     NULL AS WHDW_CLAS, --支取类型
     NULL AS WHDW_DT, --支取日期
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_otc_clea_jour_real_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T0.L_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水表
       LEFT JOIN ${ods_db}.O3_TPENDSETTLE T4 --待交割，识别是否有交收数据，交收数据：指令发起；
         ON T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
                AND T0.L_BUSIN_NO = T4.VC_ORIGINAL_NO
                AND T0.L_DATE = T4.L_TRADE_DATE
                AND T0.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
       LEFT JOIN VHISOUTCONFIRM T8 --场外执行确认表，当前表和历史表合集
         ON T0.L_BUSIN_NO = T8.L_CONFIRM_NO
                AND T4.L_SETTLE_DATE = T8.L_CONFIRM_DATE
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，存单管理新增的存入是有数据。
         ON CAST(T0.L_BUSIN_NO AS STRING) = T7.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T0.L_BUSIN_FLAG IN ('40227') --存款成交确认
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND NVL(T4.C_SETTLE_FLAG , '0') <> '1'
   AND T0.L_DATE = ${current_date}

 UNION ALL
--离线清算：存款支取成交确认
SELECT T4.L_CONFIRM_DATE AS OCCU_DT, --发生日期
     T4.L_TIME AS OCCU_TIME, --发生时间
     '1' AS BUSI_SYS_ID, --业务系统编码
     CASE
          WHEN T6.L_DATE IS NULL THEN
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO) --存单管理生成(解约)的支取
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
               T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               CONCAT('0|0|0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_D' , T0.L_BUSIN_NO)
          ELSE
               CONCAT('0|' , T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
     END AS TRD_SRC_ID, --交易源ID
     NULL AS EXCF_TIME,--确认时间
     CASE
          WHEN T6.L_DATE IS NULL THEN
               CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --存单管理生成(解约)生成的支取
          ELSE
               CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_D' , T0.L_BUSIN_NO)
     END AS TNV_ONUM, --成交序号
     NULL AS ODR_ONUM,--指令序号
     NULL AS EXCF_ONUM, --执行确认序号
     CASE
          WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
               T4.L_DAILY_INSTRUCTION_NO = 0 THEN
               NULL
          ELSE
               CONCAT(T4.L_CONFIRM_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
                      CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                           WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                           WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                           WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
                      END , '.DPSI.NONE' , '_' ,
                      CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
                           WHEN T0.C_INVEST_TYPE = '2' THEN '1'
                           WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
                           WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
                           WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
                           ELSE T0.C_INVEST_TYPE END , '_' , '16000301')
     END AS ODR_RELA_ONUM, --指令关联序号
     T1.VC_FUND_CODE AS PRD_CODE, --产品代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
     CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
     CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' , T1.VC_FUND_CODE , '-' , T7.L_BEGIN_DATE , '-' ,
            CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                 WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                 WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                 WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
            END , '.DPSI.NONE') AS SECU_ID, --证券编码
     'NONE' AS EXCH_CODE, --交易市场代码
     CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
          WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
          WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
          WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
     END AS SECU_CODE, --证券代码
     T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
     T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
     'L' AS POS_ID, --多空标志
     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
     '160003' AS BUSI_TYP, --业务类别
     CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
          ELSE
               T0.C_INVEST_TYPE
     END AS INV_TYP, --投资类型
     '16000306' AS BUSI_CLAS, --业务类型
     '46' AS ENTR_DIR, --委托方向
     T4.EN_AMOUNT AS TNV_VOL, --成交数量
     0 AS AFT_PAR_VOL, --发生后数量
     1 AS TNV_PRC, --成交价格
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('40223', '40224', '72832') THEN
               T0.EN_SUBJECT_BALANCE - T7.EN_PUNISH_INTEREST
          WHEN T0.L_BUSIN_FLAG IN ('40225') THEN
               T0.EN_OCCUR_BALANCE - T7.EN_PUNISH_INTEREST
          WHEN T0.L_BUSIN_FLAG IN ('40232') THEN
               T0.EN_DEAL_BALANCE - T7.EN_PUNISH_INTEREST
     END AS TNV_VAL, --成交金额
     0 AS RF_VAL, --退款金额
     0 AS RF_INTR, --退款利息
     CASE
          WHEN T0.L_BUSIN_FLAG IN ('40223', '40224', '72832') THEN
               T0.EN_SUBJECT_BALANCE - T7.EN_PUNISH_INTEREST
          WHEN T0.L_BUSIN_FLAG IN ('40225') THEN
               T0.EN_OCCUR_BALANCE - T7.EN_PUNISH_INTEREST
          WHEN T0.L_BUSIN_FLAG IN ('40232') THEN
               T0.EN_DEAL_BALANCE - T7.EN_PUNISH_INTEREST
     END OCCU_VAL, --发生金额
     0 AS AFT_OCCU_VAL, --发生后资金金额
     0 AS PR_FEE, --申赎费用
     0 AS INTR_VAL, --利息金额
     0 AS PUNI_VAL, --罚息金额
     CASE WHEN T6.L_DATE IS NULL THEN T0.L_DATE ELSE T6.L_SETTLE_DATE END AS DELI_DT, --交割日期
     T7.EN_RATE AS DPSI_RAT, --存款利率
     NULL AS HUGE_REDP_MODE, --巨额赎回方式
     NULL AS BONS_MODE, --分红方式
     NVL(T4.EN_DEAL_AMOUNT, 0) AS BGNG_HAS_TNV_VOL, --期初已成交数量
     NVL(T4.EN_DEAL_BALANCE, 0) AS BGNG_HAS_TNV_VAL, --期初已成交金额
     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
     T9.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
     T4.C_BUSIN_PRO_TYPE AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
     T0.L_BUSIN_FLAG AS BUSI_CLAS_DTL_O3, --业务分类明细_O32
     NULL AS EXPE_YLD, --预期收益率
     '1' AS TNV_STAT, --成交状态
     NULL AS TRD_CNTP_ID,--交易对手编码
     T4.L_OPERATOR_NO AS OPER_NO, --操作员编码
     T4.VC_REMARK AS MEMO, --备注
     T7.VC_INTER_NO AS DPSI_AGMT_NUM, --存款合同号
     T7.VC_RECEIPT_NO AS DPSI_NO, --银行存单编号
     CASE
          WHEN T5.VC_REPORT_CODE = '850850' THEN
               '1' --活期存款
          WHEN T5.VC_REPORT_CODE = '890890' THEN
               '3' --协议存款
          WHEN T5.VC_REPORT_CODE = '870870' THEN
               '2' --定期存款
          WHEN T5.VC_REPORT_CODE = '860860' THEN
               '4' --通知存款
          WHEN T5.VC_REPORT_CODE = '880880' THEN
               '6' --次级债务
     END AS DPSI_TYP, --存款类型
     T7.L_BANK AS BNK_HBNK_ID, --银行总行编码
     NULL AS PAY_DT, --缴款日期
     T7.L_BEGIN_DATE AS SRTE_DT, --起息日期
     T7.L_END_DATE AS END_DT, --到期日期
     T7.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
     T7.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
     T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
     T7.C_AUTO_REDEPOSIT AS APPT_TRAN_DPSI, --存款约定转存
     CONCAT(T7.L_DATE , '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
     CASE
          WHEN T0.C_STATUS IN ('2') THEN
               NULL
          WHEN T5.VC_REPORT_CODE = '850850' THEN
               '5' --活期支取
          WHEN T5.VC_REPORT_CODE = '860860' THEN
               '2' --通知支取
          WHEN T7.C_STATUS = '2' THEN
               '4' --到期支取
          WHEN T7.C_STATUS = '3' THEN
               '1' --提前支取
          WHEN T7.C_STATUS = '4' THEN
               '3' --解约
     END AS WHDW_CLAS, --支取类型
     CASE WHEN T6.L_DATE IS NULL THEN T0.L_DATE ELSE T6.L_SETTLE_DATE END AS WHDW_DT, --支取日期
     ${current_date} AS BUSI_DATE, --业务日期
     'evt_otc_clea_jour_real_5' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     T4.L_CONFIRM_DATE AS P_DT,
     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水表
       LEFT JOIN ${ods_db}.O3_TPENDSETTLE T6 --待交割，识别是否有交收数据，交收数据：指令发起\非解约类的存单管理
         ON T0.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
                AND T0.VC_INTER_CODE = T6.VC_INTER_CODE
                AND T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
                AND T0.L_DATE = T6.L_TRADE_DATE
                AND T6.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
       LEFT JOIN VHISOUTCONFIRM T4 --场外执行确认,当前表和历史表合集
         ON T0.L_DATE = T4.L_CONFIRM_DATE
                AND T0.L_BUSIN_NO2 = T4.L_CONFIRM_NO
       LEFT JOIN ${ods_db}.O3_TDEPOSITRECEIPT T7 --在途存单表，获取存款维度信息
         ON cast(T0.L_BUSIN_NO as string) = CONCAT(T7.L_CONFIRM_NO , LPAD(T7.L_DEPOSIT_CONFIRM_NO, 2, '0'))
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
         ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
         ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
         ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
         ON T0.L_DATE = T5.L_DATE
                AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T9
         ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
                AND T5.C_MARKET_NO = T9.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T0.L_BUSIN_FLAG IN ('40223', '40224', '72832', '40225', '40232')
   --40223存款到期兑付、40224存款提前兑付、40225存款解约、40232通知存款兑付、72832活期存款支取
   AND T0.C_DELIVER_STATUS <> '1'
   AND T0.C_STATUS IN ('1') --1-正常，2-被回溯，3-回溯；
   AND T4.L_CONFIRM_DATE = ${current_date}