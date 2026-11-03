------------------------------------------------------------------------
  -- 模块名称：银行间清算流水兴全个性化
--银行间接口：银行间债券回售到账
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

insert into ${dwd_db}.evt_inbk_clea_jour_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,odr_onum,excf_onum,odr_rela_onum,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,
src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,entr_dir,clr_typ,clr_sped,tnv_vol,aft_par_vol,tnv_val,occu_val,aft_occu_val,rat,tnv_prc,net_prc,full_prc,end_yld,trd_chag,clea_serv_chag,oth_fee,deli_dt,trd_cntp_id,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,oper_no,tnv_time,cntp_delr_id,cntp_delr_name,sett_fail_flag,stat,memo,buyt_repo_tnv_vol,bond_debc_tnv_vol,repo_use_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
	   NULL AS odr_onum,
       NULL AS EXCF_ONUM, --执行确认序号
       NULL AS ODR_RELA_ONUM, --指令关联序号
       NULL AS tnv_no, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CONCAT(T5.VC_REPORT_CODE , '.BOND.YHJ') AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志,融资回购为空头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '080002' AS BUSI_TYP, --业务类别
       CASE
           WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           WHEN T0.C_INVEST_TYPE IN ('c') THEN
               '12' --套利交易
           WHEN T0.C_INVEST_TYPE IN ('b') THEN
               '10' --套期工具
           WHEN T0.C_INVEST_TYPE IN ('a') THEN
               '15' --投机
           ELSE
               T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '08000203' AS busi_clas, --业务类型
       '11' AS ENTR_DIR, --委托方向
       '1' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       0 AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --成交数量
       T4.EN_OCCUR_BALANCE + CAST(T8.INT_PER AS DOUBLE) * CAST(T0.L_BUSIN_AMOUNT AS DOUBLE) AS TNV_VAL, --成交金额
       T4.EN_OCCUR_BALANCE + CAST(T8.INT_PER AS DOUBLE) * CAST(T0.L_BUSIN_AMOUNT AS DOUBLE) AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       NULL AS rat, --回购利率,对于回购利率中，O32的价格存放为利率
       T0.EN_ENTRUST_PRICE + T8.INT_PER AS TNV_PRC, --成交价格，其中所有回购默认100
       NULL AS NET_PRC, --净价价格
       NULL AS FULL_PRC, --全价价格
       NULL AS END_YLD, --到期收益率
       T0.EN_FEE_JG AS TRD_CHAG, --交易手续费+经手费
       T0.EN_FEE_JS2 AS CLEA_SERV_CHAG, --结算服务费+过户费
       T0.EN_FARE7 AS OTH_FEE, --其他费用
       T0.L_DATE AS DELI_DT, --交割日期
       NULL AS TRD_CNTP_ID, --交易对手编码
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       NULL AS OPER_NO, --操作员
       NULL AS TNV_TIME, --成交时间
       NULL AS CNTP_DELR_ID, --对手方交易员
       NULL AS CNTP_DELR_NAME, --对手方交易员名称
       NULL AS SETT_FAIL_FLAG, --交收失败标识
       1  AS STAT, --状态
       NULL AS MEMO, --备注
       NULL AS BUYT_REPO_TNV_VOL, --买断式回购成交数量
       NULL AS BOND_DEBC_TNV_VOL, --债券借贷成交数量
       NULL AS REPO_USE_CLAS, --回购用途类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'evt_inbk_clea_jour_his_spcl' AS TASK_RS_ID, --任务来源标识
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
  LEFT JOIN ${ods_db}.O3_THISCURRENTS T4
    ON T0.p_dt = T4.p_dt
   AND T0.L_FUND_ID = T4.L_FUND_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.VC_SUMMARY = 'ims-债券回售持仓调整结转成本调整'
   AND T4.C_STATUS ='1'
   AND T4.p_dt BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，
    ON T0.p_dt = T5.p_dt
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_MARKET_NO IN ('5')
   AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
  LEFT JOIN ${dwd_db}.VAR_BOND_INTP_PAY T8
    ON CONCAT(T5.VC_REPORT_CODE , '.BOND.YHJ') = T8.SECU_ID
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T7.C_MARKET_NO
 WHERE T0.VC_SUMMARY = 'ims-债券回售持仓调整'
   AND T0.L_BUSIN_FLAG = '40302'
   AND T0.C_STATUS ='1'
   AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}
   AND T0.P_DT BETWEEN T8.EX_DVD_DT AND T8.PAY_BGN_DT	   

   