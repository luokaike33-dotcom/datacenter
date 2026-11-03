------------------------------------------------------------------------
-- 模块名称：网下成交确认表
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

alter table ${dwd_db}.evt_ofle_tnv_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='O3') ;

insert into ${dwd_db}.evt_ofle_tnv_his partition(p_dt, sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,tnv_onum,odr_onum,excf_onum,excf_time,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_sped,entr_dir,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,cms,deli_dt,rf_val,makp_val,feer,sett_mode,trd_chag,chag_mode,chag_arvd_dt,marg,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_tnv_vol,in_tnv_prc,in_tnv_val,in_occu_val,res_flag,lock_lmt_clas,lmt_clas_onum,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,trd_cntp_id,oper_no,tnv_stat,memo,is_marg_mdl,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT T0.BUSI_SYS_ID, --业务系统编码
       T0.TRD_SRC_ID, --交易源ID
       T0.OCCU_DT, --发生日期
       T0.TNV_ONUM, --成交序号
       T0.ODR_ONUM, --指令序号
       T0.EXCF_ONUM, --执行确认序号
       T0.EXCF_TIME, --确认时间
       T0.ODR_RELA_ONUM AS ODR_RELA_ONUM, --指令关联序号
       T0.PRD_CODE, --产品代码
       T0.AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE, --投组代码
       T0.SH_CODE, --股东代码
       T0.SEAT_CODE, --席位号
       T0.SECU_ID, --证券编码
       T0.EXCH_CODE, --交易市场代码
       T0.SECU_CODE, --证券代码
       T0.SRC_SECU_ID, --源证券ID
       T0.SRC_SECU_TRD_ID, --源证券交易ID
       T0.POS_ID, --多空标志
       T0.CURR_CODE, --货币代码
       T0.BUSI_TYP, --业务类别
       T0.INV_TYP, --投资类型
       T0.BUSI_CLAS, --业务类型
       T0.CLR_SPED, --清算速度
       T0.ENTR_DIR, --委托方向
       T0.TNV_VOL, --成交数量
       T0.AFT_PAR_VOL, --发生后数量
       T0.TNV_PRC, --成交价格
       T0.TNV_VAL, --成交金额
       T0.OCCU_VAL, --发生金额
       T0.AFT_OCCU_VAL, --发生后资金金额
       T0.CMS, --佣金
       T0.DELI_DT, --交割日期
       T0.RF_VAL, --退款金额
       T0.MAKP_VAL, --补款金额
       T0.FEER, --费率
       T0.SETT_MODE, --结算方式
       T0.TRD_CHAG, --交易手续费
       T0.CHAG_MODE, --手续费方式
       T0.CHAG_ARVD_DT, --手续费到账日
       T0.MARG, --保证金
       T1.PRD_CODE AS IN_PRD_CODE, --转入产品代码
       T1.AST_UNIT_CODE AS IN_AST_UNIT_CODE, --转入资产单元代码
       T1.PFL_CODE AS IN_PFL_CODE, --转入投组代码
       T1.SH_CODE AS IN_SH_CODE, --转入股东代码
       T1.SEAT_CODE AS IN_SEAT_CODE, --转入席位号
       T1.INV_TYP AS IN_INV_TYP, --转入投资类型
       T1.SECU_ID AS IN_SECU_ID, --转入证券编码
       T1.SRC_SECU_ID AS IN_SRC_SECU_ID, --转入源证券ID
       T1.TNV_VOL AS IN_TNV_VOL, --转入成交数量
       T1.TNV_PRC AS IN_TNV_PRC, --转入成交价格
       T1.TNV_VAL AS IN_TNV_VAL, --转入成交金额
       T1.OCCU_VAL AS IN_OCCU_VAL, --转入发生金额
       T0.RES_FLAG, --限售标识
       T0.LOCK_LMT_CLAS, --锁定受限类型
       T0.LMT_CLAS_ONUM, --受限类型序号
       T0.ENTR_DIR_O3, --委托方向_O32
       T0.ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.BUSI_CLAS_O3, --业务分类_O32
       T0.BUSI_PRSS_CLAS_O3, --业务过程分类_O32
       T0.BUSI_CLAS_DTL_O3, --业务分类明细_O32
       T0.TRD_CNTP_ID, --交易对手编码
       T0.OPER_NO, --操作员
       T0.TNV_STAT, --成交状态
       T0.MEMO, --备注
       T0.IS_MARG_MDL, --是否保证金模式
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_ofle_tnv_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.OCCU_DT as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${dwd_db}.evt_ofle_clea_jour_his T0
         LEFT JOIN ${dwd_db}.evt_ofle_clea_jour_his T1
                   ON T0.OCCU_DT= T1.OCCU_DT
                       AND T0.EXCF_ONUM = T1.EXCF_ONUM
                       AND T1.BUSI_CLAS IN ('21000114', '21000118')
                       AND T1.P_DT BETWEEN ${beg_date} AND ${end_date}
                       AND T1.SYS_RS_ID = 'O3'
WHERE T0.BUSI_CLAS NOT IN ('05010101', '05030101', '05050101', '05060101', '05090101', '21000111', '21000115', '21000114', '21000118')
  --网下新股申购执行确认,网下增发申购执行确认,网下增发申购执行确认,网下战略配售申购执行确认,网下新股（北交所）申购确认,跨市场转托管转出执行确认（债券）,跨市场手工转托管转出执行确认（银行间债券）--跨市场转托管转入成交确认（债券）,跨市场手工转托管转入成交确认（银行间债券）
  AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}
  AND T0.SYS_RS_ID = 'O3'