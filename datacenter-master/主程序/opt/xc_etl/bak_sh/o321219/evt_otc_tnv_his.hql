-------------------------------------------------------------------------
  -- 模块名称：场外成交确认表
-------------------------------------------------------------------------
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

alter table ${dwd_db}.evt_otc_tnv_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_otc_tnv_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,excf_time,tnv_onum,odr_onum,excf_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,entr_dir,tnv_vol,aft_par_vol,tnv_prc,tnv_val,rf_val,rf_intr,occu_val,aft_occu_val,pr_fee,intr_val,puni_val,deli_dt,whdw_clas,dpsi_typ,dpsi_rat,huge_redp_mode,bons_mode,in_prd_code,in_ast_unit_code,in_pfl_code,in_inv_typ,in_secu_id,in_src_secu_id,in_tnv_vol,in_tnv_prc,in_tnv_val,in_occu_val,in_fee,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,expe_yld,tnv_stat,trd_cntp_id,oper_no,memo,dpsi_agmt_num,dpsi_no,bnk_hbnk_id,pay_dt,srte_dt,end_dt,ahed_coll_lim,ahed_coll_noty_days,intr_tran_dpsi,appt_tran_dpsi,cont_id,whdw_dt,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT T0.OCCU_DT AS OCCU_DT, --发生日期
       T0.OCCU_TIME,--发生时间
       T0.BUSI_SYS_ID ,-- 业务系统编码
       T0.TRD_SRC_ID,--交易源ID
       T0.EXCF_TIME, --确认时间
       T0.TNV_ONUM AS TNV_ONUM, --成交序号
       T0.ODR_ONUM AS ODR_ONUM, --指令序号
       T0.EXCF_ONUM AS EXCF_ONUM, --执行确认序号
       T0.ODR_RELA_ONUM,--指令关联序号
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE AS PFL_CODE, --投组代码
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.SECU_CODE AS SECU_CODE, --证券代码
       T0.SRC_SECU_ID AS SRC_SECU_ID, --源证券ID
       T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID, --源证券交易ID
       T0.POS_ID AS POS_ID, --多空标志
       T0.CURR_CODE AS CURR_CODE, --货币代码
       T0.BUSI_TYP AS BUSI_TYP, --业务类别
       T0.INV_TYP AS INV_TYP, --投资类型
       T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
       T0.ENTR_DIR AS ENTR_DIR, --委托方向
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.AFT_PAR_VOL AS AFT_PAR_VOL, --发生后数量
       T0.TNV_PRC AS TNV_PRC, --成交价格
       T0.TNV_VAL AS TNV_VAL, --成交金额
       T0.RF_VAL AS RF_VAL, --退款金额
       T0.RF_INTR AS RF_INTR, --退款利息
       T0.OCCU_VAL AS OCCU_VAL, --发生金额
       T0.AFT_OCCU_VAL AS AFT_OCCU_VAL, --发生后资金金额
       T0.PR_FEE AS PR_FEE, --申赎费用
       T0.INTR_VAL AS INTR_VAL, --利息金额
       T0.PUNI_VAL AS PUNI_VAL, --罚息金额
       T0.DELI_DT AS DELI_DT, --交割日期
       T0.WHDW_CLAS AS WHDW_CLAS, --支取类型
       T0.DPSI_TYP AS DPSI_TYP, --存款类型
       T0.DPSI_RAT AS DPSI_RAT, --存款利率
       T0.HUGE_REDP_MODE AS HUGE_REDP_MODE, --巨额赎回方式
       T0.BONS_MODE AS BONS_MODE, --分红方式
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.PRD_CODE END AS IN_PRD_CODE, --转入产品代码
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.AST_UNIT_CODE END AS IN_AST_UNIT_CODE, --转入资产单元代码
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.PFL_CODE END AS IN_PFL_CODE, --转入投组代码
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.INV_TYP END AS IN_INV_TYP, --转入投资类型
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.SECU_ID END AS IN_SECU_ID, --转入证券编码
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.SRC_SECU_ID END AS IN_SRC_SECU_ID, --转入源证券ID
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.TNV_VOL END AS IN_TNV_VOL, --转入成交数量
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.TNV_PRC END AS IN_TNV_PRC, --转入成交价格
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.TNV_VAL END AS IN_TNV_VAL, --转入成交金额
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.OCCU_VAL END AS IN_OCCU_VAL, --转入发生金额
       CASE WHEN T0.BUSI_CLAS = '09000307' THEN T1.PR_FEE END AS IN_FEE, --转入费用
       T0.ENTR_DIR_O3 AS ENTR_DIR_O3, --委托方向_O32
       T0.ENTR_DIR_NAME_O3 AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.BUSI_CLAS_O3 AS BUSI_CLAS_O3, --业务分类_O32
       T0.BUSI_PRSS_CLAS_O3 AS BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.BUSI_CLAS_DTL_O3 AS BUSI_CLAS_DTL_O3, --业务分类明细_O32
       T0.EXPE_YLD AS EXPE_YLD, --预期收益率
       T0.TNV_STAT AS TNV_STAT, --成交状态
       T0.TRD_CNTP_ID AS TRD_CNTP_ID, --交易对手编码
       T0.OPER_NO AS OPER_NO, --操作员编码
       T0.MEMO AS MEMO, --备注
       T0.DPSI_AGMT_NUM AS DPSI_AGMT_NUM, --存款合同号
       T0.DPSI_NO AS DPSI_NO, --银行存单编号
       T0.BNK_HBNK_ID AS BNK_HBNK_ID, --银行总行编码
       T0.PAY_DT AS PAY_DT, --缴款日期
       T0.SRTE_DT AS SRTE_DT, --起息日期
       T0.END_DT AS END_DT, --到期日期
       T0.AHED_COLL_LIM AS AHED_COLL_LIM, --提前支取限制
       T0.AHED_COLL_NOTY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
       T0.INTR_TRAN_DPSI AS INTR_TRAN_DPSI, --存款利息转存
       T0.APPT_TRAN_DPSI AS APPT_TRAN_DPSI, --存款约定转存
       T0.CONT_ID AS CONT_ID, --合约编码
       T0.WHDW_DT AS WHDW_DT, --支取日期
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_otc_tnv_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
  	   T0.OCCU_DT as p_dt,
  	   'O3' AS SYS_RS_ID --系统来源标识
FROM ${dwd_db}.EVT_OTC_CLEA_JOUR_HIS T0
LEFT JOIN ${dwd_db}.EVT_OTC_CLEA_JOUR_HIS T1
 ON T0.OCCU_DT = T1.OCCU_DT
AND T0.EXCF_ONUM = T1.EXCF_ONUM
AND T1.BUSI_CLAS IN ('09000308')
AND T1.P_DT BETWEEN ${beg_date} AND ${end_date}
WHERE T0.BUSI_CLAS NOT IN ('09000302',
                           '09000304',
                           '09000306',
                           '09000300',
                           '28000300',
                           '16000304',
                           '09000318',
                           '09000308')
AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}
 ;



