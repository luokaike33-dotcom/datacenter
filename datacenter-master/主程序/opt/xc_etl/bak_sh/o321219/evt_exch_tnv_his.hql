------------------------------------------------------------------------
  -- 模块名称：交易所成交流水
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

alter table ${dwd_db}.evt_exch_tnv_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_exch_tnv_his partition(p_dt,sys_rs_id)
 (busi_sys_id,occu_dt,tnv_onum,tnv_time,odr_onum,odr_rela_onum,trd_src_id,entr_onum,rep_no,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,clr_typ,entr_dir,clr_sped,tnv_vol,aft_par_vol,tnv_prc,rat,tnv_val,occu_val,aft_occu_val,stmp,tfee,hand_fee,sfee,clea_chag,clea_rptl,oth_fee,cms,full_tfee,deli_dt,trd_cntp_id,appt_num,trd_plfm,trd_mode,guar_sett_flag,rf_val,marg,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,trad_id,oper_no,tnv_stat,cont_mult,covr_dir,arbi_flag,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,buyb_val,intr,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_tnv_prc,in_tnv_val,in_occu_val,in_fee,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,pay_dt,excr_dt,etf_onum,esti_cash_diff,etf_fnd_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT
              T0.BUSI_SYS_ID, --业务系统编码
             T0.OCCU_DT, --发生日期
             T0.TNV_ONUM, --成交序号
             T0.TNV_TIME, --成交时间
             null as odr_onum, --指令序号
              T0.ODR_RELA_ONUM, --指令关联序号
               T0.TRD_SRC_ID, --交易源ID
             T0.ENTR_ONUM, --委托序号
             T0.REP_NO, --申报编号
             T0.TNV_NO, --成交编号
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
             T0.CLR_TYP, --清算类型
               T0.ENTR_DIR, --委托方向
             T0.CLR_SPED, --清算速度
             T0.TNV_VOL, --成交数量
             T0.AFT_PAR_VOL, --发生后数量
             T0.TNV_PRC, --成交价格
             T0.rat, --回购利率
             T0.TNV_VAL, --成交金额
             T0.OCCU_VAL, --发生金额
             T0.AFT_OCCU_VAL, --发生后资金金额
             T0.STMP, --印花税
             T0.TFEE, --过户费
             T0.HAND_FEE, --经手费
             T0.SFEE, --证管费
             T0.CLEA_CHAG, --结算费
             T0.CLEA_RPTL, --结算风险金
             T0.OTH_FEE, --其他费用
             T0.CMS, --佣金
               T2.FULL_TFEE as full_tfee,--全额过户费
             T0.DELI_DT, --交割日期
             T0.TRD_CNTP_ID, --交易对手编码
             T0.APPT_NUM, --约定号
             T0.TRD_PLFM, --交易平台
               T0.TRD_MODE,--交易方式
             T0.GUAR_SETT_FLAG, --担保交收标志
             T0.RF_VAL, --退款金额
             T0.MARG, --保证金
             T0.ENTR_DIR_O3, --委托方向_O32
             T0.ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.BUSI_CLAS_O3, --业务分类_O32
             T0.TRAD_ID, --券商编码
             T0.OPER_NO, --操作员
             T0.TNV_STAT, --成交状态
             T0.CONT_MULT, --合约乘数
             T0.COVR_DIR, --平仓方向
             T0.ARBI_FLAG, --套利标志
             T1.REPO_DAYS AS cont_days, --合约天数
             T1.INTA_DAYS, --计息天数
             T1.TNV_DT as cont_tnv_dt, --合约成交日期
             T1.BUYB_DT as cont_end_dt, --合约到期日期
             T1.FIR_DELI_DT, --首期交割日期
             T1.END_DELI_DT, --到期交割日期
             T1.FIR_DELI_MODE, --首期交割方式
             T1.END_DELI_MODE, --到期交割方式
             T1.BUYB_VAL, --购回金额
             T1.REPO_INTR as intr, --利息
            T2.PRD_CODE AS IN_PRD_CODE, --转入产品代码
            T2.AST_UNIT_CODE AS IN_AST_UNIT_CODE, --转入资产单元代码
             T2.PFL_CODE AS IN_PFL_CODE, --转入投组代码
            T2.SH_CODE AS IN_SH_CODE, --转入股东代码
             T2.SEAT_CODE AS IN_SEAT_CODE, --转入席位号
              T2.INV_TYP AS IN_INV_TYP, --转入投资类型
             T2.SECU_ID AS IN_SECU_ID, --转入证券编码
                T2.SRC_SECU_ID as IN_SRC_SECU_ID, --转入源证券ID
              T2.TNV_PRC AS IN_TNV_PRC, --转入成交价格
               T2.TNV_VAL AS IN_TNV_VAL, --转入成交金额
               T2.OCCU_VAL AS IN_OCCU_VAL, --转入发生金额
               NVL(T2.STMP,0) + NVL(T2.TFEE,0) + NVL(T2.HAND_FEE,0) + NVL(T2.SFEE,0) + NVL(T2.CLEA_CHAG,0) +
                      NVL(T2.CLEA_RPTL,0) + NVL(T2.OTH_FEE,0) + NVL(T2.CMS,0) + NVL(T2.FULL_TFEE,0) AS IN_FEE, --转入费用
               T0.RES_FLAG, --限售标识
                T0.LOCK_LMT_CLAS, --锁定受限类型
                T0.LMT_CLAS_ONUM, --受限类型序号
                T0.AGMT_NUM, --合同号
             T0.PAY_DT, --缴款日期
             T0.EXCR_DT, --除权日期
             T0.ETF_ONUM,--ETF序号
             T0.ESTI_CASH_DIFF,--预估现金差额
             T0.ETF_FND_CLAS,--ETF基金类型
             ${end_date} AS BUSI_DATE, --业务日期
             'evt_exch_tnv_his_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
			T0.OCCU_DT as p_dt,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM  ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS T0
        LEFT JOIN ${dwd_db}.PRO_REPO_TNV_INFO T1
          ON T0.SECU_ID = T1.SECU_ID
          AND T1.SYS_RS_ID = 'O3'
        LEFT JOIN  ( select * from  ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS T2 where T2.OCCU_DT  BETWEEN ${beg_date} AND ${end_date} and SYS_RS_ID = 'O3') T2
          ON T0.P_DT = T2.P_DT
         AND T0.ENTR_ONUM = T2.ENTR_ONUM
         AND T2.BUSI_CLAS IN ('21000101', '26000101')
       WHERE T0.P_DT  BETWEEN ${beg_date} AND ${end_date}
         AND T0.BUSI_CLAS NOT IN ('21000101', '26000101')
         AND T0.BUSI_TYP <> '230001'
         AND T0.SYS_RS_ID = 'O3'
      UNION ALL
      SELECT
                T0.BUSI_SYS_ID, --业务系统编码
             T0.OCCU_DT, --发生日期
             T0.TNV_ONUM, --成交序号
             T0.TNV_TIME, --成交时间
             null as odr_onum, --指令序号
                T0.ODR_RELA_ONUM, --指令关联序号
                T0.TRD_SRC_ID, --交易源ID
             T0.ENTR_ONUM, --委托序号
             T0.REP_NO, --申报编号
             T0.TNV_NO, --成交编号
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
             T0.busi_clas, --业务类型
             T0.CLR_TYP, --清算类型
             T0.ENTR_DIR, --委托方向
             T0.CLR_SPED, --清算速度
             T0.TNV_VOL, --成交数量
             T0.AFT_PAR_VOL, --发生后数量
             T0.TNV_PRC, --成交价格
             T0.rat, --回购利率
             T0.TNV_VAL, --成交金额
             T0.OCCU_VAL, --发生金额
             T0.AFT_OCCU_VAL, --发生后资金金额
             T0.STMP, --印花税
             T0.TFEE, --过户费
             T0.HAND_FEE, --经手费
             T0.SFEE, --证管费
             T0.CLEA_CHAG, --结算费
             T0.CLEA_RPTL, --结算风险金
             T0.OTH_FEE, --其他费用
             T0.CMS, --佣金
             T0.FULL_TFEE, --全额过户费
             T0.DELI_DT, --交割日期
             T0.TRD_CNTP_ID, --交易对手编码
             T0.APPT_NUM, --约定号
             T0.TRD_PLFM, --交易平台
             T0.TRD_MODE,--交易方式
             T0.GUAR_SETT_FLAG, --担保交收标志
             T0.RF_VAL, --退款金额
             T0.MARG, --保证金
             T0.ENTR_DIR_O3, --委托方向_O32
             T0.ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.BUSI_CLAS_O3, --业务分类_O32
             T0.TRAD_ID, --券商编码
             T0.OPER_NO, --操作员
             T0.TNV_STAT, --成交状态
             T0.CONT_MULT, --合约乘数
             T0.COVR_DIR, --平仓方向
             T0.ARBI_FLAG, --套利标志
             T1.REFC_CONT_DAYS AS cont_days, --合约天数
             T1.INTA_DAYS, --计息天数
             T1.TNV_DT as cont_tnv_dt, --合约成交日期
             T1.END_DT as cont_end_dt, --合约到期日期
             T1.FIR_DELI_DT, --首期交割日期
             T1.END_DELI_DT, --到期交割日期
             NULL as FIR_DELI_MODE, --首期交割方式
             NULL as END_DELI_MODE, --到期交割方式
             NULL as BUYB_VAL, --购回金额
             T1.REFE_INTR as intr, --利息
            NULL AS IN_PRD_CODE, --转入产品代码
            NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
            NULL AS IN_PFL_CODE, --转入投组代码
            NULL AS IN_SH_CODE, --转入股东代码
            NULL AS IN_SEAT_CODE, --转入席位号
             NULL AS IN_INV_TYP, --转入投资类型
             NULL AS IN_SECU_ID, --转入证券编码
                      NULL as IN_SRC_SECU_ID, --转入源证券ID
             NULL AS IN_TNV_PRC, --转入成交价格
             NULL AS IN_TNV_VAL, --转入成交金额
             NULL AS IN_OCCU_VAL, --转入发生金额
             NULL AS IN_FEE,--转入费用
                     T0.RES_FLAG, --限售标识
                     T0.LOCK_LMT_CLAS, --锁定受限类型
                     T0.LMT_CLAS_ONUM, --受限类型序号
                       T0.AGMT_NUM, --合同号
                      T0.PAY_DT, --缴款日期
                      T0.EXCR_DT, --除权日期
                       T0.ETF_ONUM,--ETF序号
                        T0.ESTI_CASH_DIFF,--预估现金差额
                         T0.ETF_FND_CLAS,--ETF基金类型
             ${end_date} AS BUSI_DATE, --业务日期
                 'evt_exch_tnv_his_2' AS TASK_RS_ID, --任务来源标识
                 CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                      T0.OCCU_DT as p_dt,
                 'O3' --系统来源标识
        FROM ${dwd_db}.EVT_EXCH_CLEA_JOUR_HIS T0
        LEFT JOIN ${dwd_db}.PRO_REFC_INFO T1
          ON T0.SECU_ID = T1.SECU_ID
          AND T1.SYS_RS_ID = 'O3'
       WHERE T0.P_DT  BETWEEN ${beg_date} AND ${end_date}
         AND T0.BUSI_TYP = '230001'
         AND T0.SYS_RS_ID = 'O3';