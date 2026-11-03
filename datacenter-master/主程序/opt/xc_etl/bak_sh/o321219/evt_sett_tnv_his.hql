------------------------------------------------------------------------
  -- 模块名称：结算类成交
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

alter table ${dwd_db}.evt_sett_tnv_his drop if exists partition (p_dt>=${beg_date},p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_sett_tnv_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,intr_val,deli_dt,intr_tran_dpsi,pnlt_val,cont_id,res_flag,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--获取红利、红股、红利再投、兑付数据（剔除兑息与兑付重复数据）
SELECT T0.OCCU_DT AS OCCU_DT, --发生日期
       T0.OCCU_TIME AS OCCU_TIME,
       T0.busi_sys_id AS busi_sys_id,
       T0.TRD_SRC_ID AS TRD_SRC_ID,
       T0.TNV_ONUM AS TNV_ONUM, --成交序号
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.AST_UNIT_CODE AS AST_UNIT_CODE, --资产单元代码
       T0.PFL_CODE AS PFL_CODE, --投组代码
       T0.SH_CODE AS SH_CODE,
       T0.SEAT_CODE AS SEAT_CODE,
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.SECU_CODE AS SECU_CODE, --证券代码
       T0.SRC_SECU_ID AS SRC_SECU_ID,
       T0.SRC_SECU_TRD_ID AS SRC_SECU_TRD_ID,
       T0.POS_ID AS POS_ID, --多空标志
       T0.CURR_CODE AS CURR_CODE, --货币代码
       T0.BUSI_TYP AS BUSI_TYP, --业务类别
       T0.INV_TYP AS INV_TYP, --投资类型
       T0.BUSI_CLAS AS BUSI_CLAS, --业务类型
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.AFT_PAR_VOL AS AFT_PAR_VOL, --发生后数量
       T0.TNV_PRC AS TNV_PRC, --成交价格
       T0.TNV_VAL AS TNV_VAL, --成交金额
       T0.OCCU_VAL AS OCCU_VAL, --发生金额
       T0.AFT_OCCU_VAL AS AFT_OCCU_VAL, --发生后资金金额
       T0.INTR_VAL AS INTR_VAL, --利息金额
       T0.DELI_DT AS DELI_DT, --交割日期
       T0.INTR_TRAN_DPSI AS INTR_TRAN_DPSI,
       T0.PNLT_VAL AS PNLT_VAL,
       T0.CONT_ID AS CONT_ID,
       T0.RES_FLAG AS RES_FLAG,
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_sett_tnv_his_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间\
       T0.OCCU_DT as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
FROM ${dwd_db}.evt_sett_clea_jour_his T0
WHERE T0.P_DT BETWEEN ${beg_date} AND ${end_date}
