------------------------------------------------------------------------
  -- 模块名称：网下执行确认表
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

alter table ${dwd_db}.evt_ofle_excf_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='O3');

insert into ${dwd_db}.evt_ofle_excf_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,odr_onum,excf_onum,excf_time,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_sped,entr_dir,entr_vol,entr_prc,entr_val,occu_val,trd_chag,chag_mode,marg,feer,deli_dt,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_entr_vol,in_entr_prc,in_entr_val,sett_mode,res_flag,lock_lmt_clas,lmt_clas_onum,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_prss_clas_o3,busi_clas_dtl_o3,trd_cntp_id,oper_no,tnv_stat,memo,is_marg_mdl,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT       BUSI_SYS_ID,
             TRD_SRC_ID,
             OCCU_DT, --发生日期
             ODR_ONUM, --指令序号
             EXCF_ONUM, --执行确认序号
             EXCF_TIME, --确认时间
             ODR_RELA_ONUM,
             PRD_CODE, --产品代码
             AST_UNIT_CODE, --资产单元代码
             PFL_CODE, --投组代码
             SH_CODE, --股东代码
             SEAT_CODE, --席位号
             SECU_ID, --证券编码
             EXCH_CODE, --交易市场代码
             SECU_CODE, --证券代码
             SRC_SECU_ID,
             SRC_SECU_TRD_ID,
             POS_ID, --多空标志
             CURR_CODE, --货币代码
             BUSI_TYP, --业务类别
             INV_TYP, --投资类型
             BUSI_CLAS, --业务类型
             CLR_SPED,
             ENTR_DIR,
             TNV_VOL AS ENTR_VOL, --委托数量
             TNV_PRC AS ENTR_PRC, --委托价格
             TNV_VAL AS ENTR_VAL, --委托金额
             OCCU_VAL, --发生金额
             TRD_CHAG,
             CHAG_MODE,
             MARG, --保证金
             T0.FEER, --费率
             DELI_DT,
             IN_PRD_CODE,
             IN_AST_UNIT_CODE,
             IN_PFL_CODE,
             IN_SH_CODE,
             IN_SEAT_CODE,
             IN_INV_TYP,
             IN_SECU_ID,
             IN_SRC_SECU_ID,
             IN_ENTR_VOL,
             NULL AS IN_ENTR_PRC,
             NULL AS IN_ENTR_VAL,
             T0.SETT_MODE, --结算方式
             RES_FLAG,
             LOCK_LMT_CLAS,
             LMT_CLAS_ONUM,
             T0.ENTR_DIR_O3, --委托方向_O32
             T0.ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.BUSI_CLAS_O3, --业务分类_O32
             T0.BUSI_PRSS_CLAS_O3, --业务过程分类_O32
             BUSI_CLAS_DTL_O3, --业务类型明细_O3
             T0.TRD_CNTP_ID, --交易对手编码
             T0.OPER_NO, --操作员
             T0.TNV_STAT, --成交状态
             T0.MEMO, --备注
             T0.IS_MARG_MDL, --是否保证金模式
             ${end_date} AS BUSI_DATE, --业务日期
             'evt_ofle_excf_his_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             OCCU_DT as p_dt,
             'O3' AS SYS_RS_ID --系统来源标识
FROM ${dwd_db}.evt_ofle_clea_jour_his t0
WHERE t0.BUSI_CLAS IN ('05010101', '05030101', '05050101', '05060101', '05090101', '21000111', '21000115')  --网下新股申购执行确认,网下增发申购执行确认,网下增发申购执行确认,网下战略配售申购执行确认,网下新股（北交所）申购确认,跨市场转托管转出执行确认（债券）,跨市场手工转托管转出执行确认（银行间债券）
  AND t0.p_dt  BETWEEN ${beg_date} AND ${end_date}
  AND t0.sys_rs_id = 'O3'