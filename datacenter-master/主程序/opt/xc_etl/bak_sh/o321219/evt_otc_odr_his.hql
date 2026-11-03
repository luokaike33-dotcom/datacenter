------------------------------------------------------------------------
--模块名称：场外指令表(离线)
--指令：场外基金认购、申购、赎回业务
--指令：场外基金转换业务
--指令：存款存入
--指令：存款支取
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

alter table ${dwd_db}.evt_otc_odr_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='O3') ;

insert into ${dwd_db}.evt_otc_odr_his partition(p_dt, sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,odr_onum,odr_clas,odr_rela_dt,odr_strt_dt,odr_end_dt,odr_strt_time,odr_end_time,odr_secu_ctrl_clas,odr_secu_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,inv_typ,busi_typ,busi_clas,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,entr_dir,odr_prc,odr_vol,odr_val,intr_val,bgng_has_entr_vol,bgng_has_entr_val,bgng_has_tnv_vol,bgng_has_tnv_val,entr_vol,entr_val,tnv_vol,tnv_val,trd_cntp_id,deli_dt,rela_rrsn,agt_rela_rrsn,memo,huge_redp_mode,bons_mode,in_prd_code,in_ast_unit_code,in_pfl_code,in_inv_typ,in_secu_id,in_src_secu_id,in_odr_vol,in_odr_prc,in_odr_val,odr_stat,dpsi_agmt_num,dpsi_no,dpsi_typ,bnk_hbnk_id,rat,pay_dt,srte_dt,end_dt,ahed_coll_lim,ahed_coll_noty_days,intr_tran_dpsi,appt_tran_dpsi,cont_id,whdw_clas,noty_dt,whdw_dt,busi_date,task_rs_id,dm_created_time,delr_id,p_dt,sys_rs_id)
--指令：场外基金认购、申购、赎回业务
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
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --date_format(T0.D_DATETIME,'HHmmss')
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.NONE' , '_' ,
       (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('D') THEN
          '09000309'
         WHEN T4.C_ENTRUST_DIRECTION in ('p') THEN
          '09000312'
         WHEN T4.C_ENTRUST_DIRECTION in ('q') THEN
          '09000315'
       END)) AS ODR_RELA_ONUM, --指令关联序号
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
       '090003' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('D') THEN
          '09000309'
         WHEN T4.C_ENTRUST_DIRECTION in ('p') THEN
          '09000312'
         WHEN T4.C_ENTRUST_DIRECTION in ('q') THEN
          '09000315'
       END AS BUSI_CLAS, --业务类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('D') THEN
          '13'
         WHEN T4.C_ENTRUST_DIRECTION in ('p') THEN
          '53'
         WHEN T4.C_ENTRUST_DIRECTION in ('q') THEN
          '54'
       END AS ENTR_DIR, --委托方向
       CASE WHEN T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 END AS ODR_PRC, --指令价格
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       0 AS INTR_VAL, --利息金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.L_DATE AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T4.C_EXCEED_FLAG AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       --NULL AS OPER_TYP, --操作类型
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       NULL AS DPSI_AGMT_NUM, --存款合同号
       NULL AS DPSI_NO, --存款编号
       NULL AS DPSI_TYP, --存款类型
       NULL AS BNK_HBNK_ID, --银行总行编码
       NULL AS RAT, --存款利率
       NULL AS PAY_DT, --缴款日期
       NULL AS SRTE_DT, --起息日期
       NULL AS END_DT, --到期日期
       NULL AS AHED_COLL_LIM, --提前支取限制
       NULL AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS APPT_TRAN_DPSI, --存款约定转存
       NULL AS CONT_ID, --合约编码
       NULL AS WHDW_CLAS, --支取类型
       NULL AS NOTY_DT, --通知日期
       NULL AS WHDW_DT, --支取日期
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_odr_his_1' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	   T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   and t4.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   and t5.p_dt BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T4.C_ENTRUST_DIRECTION IN ('q','p','D')
   AND T5.C_MARKET_NO NOT IN ('1', '2')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：场外基金转换业务
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
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --date_format(T0.D_DATETIME,'HHmmss')
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.NONE' , '_' ,
       (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '09000317') AS ODR_RELA_ONUM, --指令关联序号
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
       '090003' AS BUSI_TYP, --业务类别
       '09000317' AS BUSI_CLAS, --业务类型
       CONCAT(T5.VC_REPORT_CODE , '.FUND.NONE') AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --币种
       '14' AS ENTR_DIR, --委托方向
       CASE WHEN T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 END AS ODR_PRC, --指令价格
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       0 AS INTR_VAL, --利息金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.L_DATE AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T4.C_EXCEED_FLAG AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       --NULL AS OPER_TYP, --操作类型
       T8.VC_FUND_CODE AS IN_PRD_CODE, --转入产品代码
       CONCAT(T8.VC_FUND_CODE , '_' , T10.VC_ASSET_NO) AS IN_AST_UNIT_CODE, --转入资产单元代码
       CONCAT(T8.VC_FUND_CODE , '_' , T10.VC_ASSET_NO , '_' , T9.VC_COMBI_NO) AS IN_PFL_CODE, --转入投组代码
       CASE WHEN T7.C_INVEST_TYPE = '1' THEN '2'
	        WHEN T7.C_INVEST_TYPE = '2' THEN '1'
			WHEN T7.C_INVEST_TYPE = 'a' THEN '15'
			WHEN T7.C_INVEST_TYPE = 'b' THEN '10'
			WHEN T7.C_INVEST_TYPE = 'c' THEN '12'
	   ELSE T7.C_INVEST_TYPE END AS IN_INV_TYP, --转入投资类型
       CONCAT(T6.VC_REPORT_CODE , '.FUND.NONE') AS IN_SECU_ID, --转入证券编码
       T6.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
       T7.L_AMOUNT AS IN_ODR_VOL, --转入指令数量
       CASE WHEN T7.EN_PRICE1 = 0 THEN T7.EN_FACT_PRICE ELSE T7.EN_PRICE1 END AS IN_ODR_PRC, --转入指令价格
       T7.EN_BALANCE AS IN_ODR_VAL, --转入指令金额
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       NULL AS DPSI_AGMT_NUM, --存款合同号
       NULL AS DPSI_NO, --存款编号
       NULL AS DPSI_TYP, --存款类型
       NULL AS BNK_HBNK_ID, --银行总行编码
       NULL AS RAT, --存款利率
       NULL AS PAY_DT, --缴款日期
       NULL AS SRTE_DT, --起息日期
       NULL AS END_DT, --到期日期
       NULL AS AHED_COLL_LIM, --提前支取限制
       NULL AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS APPT_TRAN_DPSI, --存款约定转存
       NULL AS CONT_ID, --合约编码
       NULL AS WHDW_CLAS, --支取类型
       NULL AS NOTY_DT, --通知日期
       NULL AS WHDW_DT, --支取日期
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_odr_his_2' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	   T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   and t4.p_dt BETWEEN ${beg_date} and ${end_date}
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T7
    ON T0.L_DATE = T7.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
   AND T7.C_ENTRUST_DIRECTION IN ('p')
   AND T7.C_ORIGINAL_DIRECTION IN ('E')
   and t7.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T8 --产品基本信息表，获取产品代码
    ON T7.L_FUND_ID = T8.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T9 --投资组合基本信息表，获取投资组合代码
    ON T7.L_BASECOMBI_ID = T9.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T10 --资产单元基本信息表，获取资产单元代码
    ON T9.L_ASSET_ID = T10.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   and t5.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6
    ON T7.L_DATE = T6.L_DATE
   AND T7.VC_INTER_CODE = T6.VC_INTER_CODE
   and t6.p_dt BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('A')
   AND T4.C_ENTRUST_DIRECTION IN ('E')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   and t0.p_dt BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：存款存入
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
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --date_format(T0.D_DATETIME,'HHmmss')
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
       T4.L_BASECOMBI_ID , '_' , CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
	                                     WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                                         WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                                         WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
							     END , '.DPSI.NONE', '_' ,
       (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '16000300') AS ODR_RELA_ONUM, --指令关联序号
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
       '160003' AS BUSI_TYP, --业务类别
       '16000300' AS BUSI_CLAS, --业务类型
       CONCAT(CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
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
       'CNY' AS CURR_CODE, --币种
       '16' AS ENTR_DIR, --委托方向
       CASE WHEN T4.EN_PRICE1 = 0 THEN T4.EN_FACT_PRICE ELSE T4.EN_PRICE1 END AS ODR_PRC, --指令价格
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       0 AS INTR_VAL, --利息金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       CASE WHEN T0.L_FIRST_SETTLE_DATE = 0 THEN T0.L_DATE ELSE T0.L_FIRST_SETTLE_DATE END AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       --NULL AS OPER_TYP, --操作类型
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T7.VC_INTER_NO AS DPSI_AGMT_NUM, --存款合同号
       T7.VC_RECEIPT_NO AS DPSI_NO, --存款编号
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
       T7.EN_RATE AS RAT, --存款利率
       CASE WHEN T0.L_FIRST_SETTLE_DATE = 0 THEN T0.L_DATE ELSE T0.L_FIRST_SETTLE_DATE END AS PAY_DT, --缴款日期
       CASE WHEN T7.L_INTEREST_START_DATE = 0 THEN T7.L_DATE ELSE T7.L_INTEREST_START_DATE END AS SRTE_DT, --起息日期
       CASE
         WHEN T7.L_DRAW_DATE IS NULL OR T7.L_DRAW_DATE = 0 THEN
          cast(date_format(add_months(from_unixtime(unix_timestamp(cast(cast(CASE WHEN T0.L_FIRST_SETTLE_DATE = 0 THEN T0.L_DATE ELSE T0.L_FIRST_SETTLE_DATE END as bigint) as string)
		                                       ,'yyyyMMdd'),'yyyy-MM-dd'),
								       cast(T7.L_LIMIT_TIME as int)),
			                'yyyyMMdd') as bigint)
         ELSE
          T7.L_DRAW_DATE
       END AS END_DT, --到期日期
       T7.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
       T7.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
       T7.C_AUTO_REDEPOSIT AS APPT_TRAN_DPSI, --存款约定转存
       NULL AS CONT_ID, --合约编码
       NULL AS WHDW_CLAS, --支取类型
       NULL AS NOTY_DT, --通知日期
       NULL AS WHDW_DT, --支取日期
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_odr_his_3' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	   T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   and t4.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   and t5.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONDEPOSITDETAIL T7
    ON T0.L_DATE = T7.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
   and t7.p_dt BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T4.C_ENTRUST_DIRECTION IN ('F')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   and t0.p_dt BETWEEN ${beg_date} and ${end_date}

UNION ALL
--指令：存款支取
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
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --date_format(T0.D_DATETIME,'HHmmss')
       CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' ,
       T4.L_BASECOMBI_ID , '_' , CASE WHEN T5.VC_REPORT_CODE = '890890' THEN 'DPSI103'
                                      WHEN T5.VC_REPORT_CODE = '870870' THEN 'DPSI102'
                                      WHEN T5.VC_REPORT_CODE = '860860' THEN 'DPSI104'
                                      WHEN T5.VC_REPORT_CODE = '880880' THEN 'DPSI108'
                                 END , '.DPSI.NONE' , '_' ,
       (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '16000301') AS ODR_RELA_ONUM, --指令关联序号
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
       '160003' AS BUSI_TYP, --业务类别
       '16000301' AS BUSI_CLAS, --业务类型
       CONCAT(T7.L_CONFIRM_NO , '-' , T1.VC_FUND_CODE , '-' , T7.L_DATE , '-' ,
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
       'CNY' AS CURR_CODE, --币种
       '46' AS ENTR_DIR, --委托方向
       CASE WHEN T4.EN_PRICE1 = 0 THEN T4.EN_FACT_PRICE ELSE T4.EN_PRICE1 END AS ODR_PRC, --指令价格
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.EN_FEE AS INTR_VAL, --利息金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.L_DATE AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS HUGE_REDP_MODE, --巨额赎回方式
       NULL AS BONS_MODE, --分红方式
       --NULL AS OPER_TYP, --操作类型
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       T7.VC_INTER_NO AS DPSI_AGMT_NUM, --存款合同号
       T7.VC_RECEIPT_NO AS DPSI_NO, --存款编号
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
       T7.EN_RATE AS RAT, --存款利率
       NULL AS PAY_DT, --缴款日期
       NULL AS SRTE_DT, --起息日期
       NULL AS END_DT, --到期日期
       T7.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
       T7.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       T7.C_INTEREST_DEPOSIT AS INTR_TRAN_DPSI, --存款利息转存
       T7.C_AUTO_REDEPOSIT AS APPT_TRAN_DPSI, --存款约定转存
       CONCAT(T7.L_DATE, '_' , T7.L_CONFIRM_NO , '_' , T7.L_DEPOSIT_CONFIRM_NO , '_1') AS CONT_ID, --合约编码
       CASE
         WHEN T5.VC_REPORT_CODE = '850850' THEN
          '5' --活期支取
         WHEN T5.VC_REPORT_CODE = '860860' THEN
          '2' --通知支取
         ELSE
          T7.C_DRAW_TYPE
       END AS WHDW_CLAS, --支取类型
       T7.L_NOTIFY_DATE AS NOTY_DT, --通知日期
       T7.L_DRAW_DATE AS WHDW_DT, --支取日期
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_odr_his_4' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	   T0.L_DATE,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISINSTRUCTION T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
 INNER JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   and t4.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   and t5.p_dt BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONDEPOSITDETAIL T7
    ON T0.L_DATE = T7.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
   and t7.p_dt BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('B')
   AND T4.C_ENTRUST_DIRECTION IN ('i')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   and t0.p_dt BETWEEN ${beg_date} and ${end_date}
