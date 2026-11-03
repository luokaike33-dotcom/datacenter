------------------------------------------------------------------------
  -- 模块名称：投资组合表
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

alter table ${dwd_db}.acc_pfl drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.acc_pfl partition(sys_rs_id)
(
pfl_code
,prd_code
,ast_unit_code
,pfl_name
,pfl_typ
,pfl_stat
,inv_typ
,perm_inv_trd_mkt
,perm_inv_busi_typ
,index_futr_inv_typ
,src_sys_code
,busi_date
,task_rs_id
,dm_created_time
,sys_rs_id
)
SELECT CONCAT(T1.VC_FUND_CODE , '_' , nvl(T2.VC_ASSET_NO,'') , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T1.VC_FUND_CODE  AS PRD_CODE, --产品代码
             concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AST_UNIT_CODE, --资产单元代码
             T0.VC_COMBI_NAME AS PFL_NAME, --投资组合名称
             T0.C_COMBI_CLASS AS PFL_TYP, --组合类型
             T0.C_COMBI_STATUS AS PFL_STAT, --组合状态
             T0.C_INVEST_TYPE AS INV_TYP, --投资类型
             T0.VC_PERMIT_MARKET AS PERM_INV_TRD_MKT, --允许投资的交易市场,需要转换
             T0.VC_PERMIT_BUSIN_CLASS AS PERM_INV_BUSI_TYP, --允许投资的业务分类,需要转换
             T0.C_FUTURES_INVEST_TYPE AS INDEX_FUTR_INV_TYP, --股指期货投资类型,需要转换
             T0.L_COMBI_ID AS SRC_SYS_CODE, --源系统代码
             ${current_date} as busi_date, --业务日期
             'acc_pfl_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS sys_rs_id --系统来源标识
        FROM (SELECT T0.VC_COMBI_NO,
                                   T0.VC_COMBI_NAME, --投资组合名称
                                   T0.C_COMBI_CLASS, --组合类型
                                   T0.C_COMBI_STATUS, --组合状态
                                   T0.C_INVEST_TYPE, --投资类型
                                  concat_ws(',', collect_list(t2.para_hcode))  AS VC_PERMIT_MARKET, --允许投资的交易市场,需要转换
                                   T0.VC_PERMIT_BUSIN_CLASS, --允许投资的业务分类,需要转换
                                   T0.C_FUTURES_INVEST_TYPE, --股指期货投资类型,需要转换
                                   T0.L_FUND_ID,
                                   T0.L_ASSET_ID,
                                   T0.L_COMBI_ID --源系统代码
                              FROM ${ods_db}.O3_TCOMBI T0
                              LEFT JOIN
                              (
                              select distinct t0.L_COMBI_ID,t2.para_hcode  from
                              ${ods_db}.O3_TCOMBI T0 LEFT JOIN
                              ${dwd_db}.PUB_PARA_MAPPING T2
                               on T2.PARA_CLASS_HCODE = '4'
                               AND T2.ORISYS_HCODE = 'HSO3'
                               AND 1=1
                              where instr(T0.VC_PERMIT_MARKET, T2.ORISYS_PARA_CODE) >= 1 )T2
                              on t0.L_COMBI_ID=t2.L_COMBI_ID
                             group by T0.VC_COMBI_NO,
                                      T0.VC_COMBI_NAME, --投资组合名称
                                      T0.C_COMBI_CLASS, --组合类型
                                      T0.C_COMBI_STATUS, --组合状态
                                      T0.C_INVEST_TYPE, --投资类型
                                      T0.VC_PERMIT_MARKET, --允许投资的交易市场,需要转换
                                      T0.VC_PERMIT_BUSIN_CLASS, --允许投资的业务分类,需要转换
                                      T0.C_FUTURES_INVEST_TYPE, --股指期货投资类型,需要转换
                                      T0.L_FUND_ID,
                                      T0.L_ASSET_ID,
                                      T0.L_COMBI_ID --源系统代码
              ) T0
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2
          ON T0.L_ASSET_ID = T2.L_ASSET_ID;