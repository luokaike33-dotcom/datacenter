------------------------------------------------------------------------
  -- 模块名称：投组资产关联关系表
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


alter table ${dwd_db}.ACC_PFL_RELA drop if exists partition (sys_rs_id='O3');
insert into ${dwd_db}.ACC_PFL_RELA partition(sys_rs_id)
(	prd_code, ast_unit_code, pfl_code, busi_date,  task_rs_id, dm_created_time ,sys_rs_id)
SELECT T0.VC_FUND_CODE AS PRD_CODE, --产品代码
              CONCAT(T0.VC_FUND_CODE , '_' , T1.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
              CONCAT(T0.VC_FUND_CODE , '_' , T1.VC_ASSET_NO , '_' ,
              T2.VC_COMBI_NO) AS PFL_CODE, --投组代码
              DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
              'acc_pfl_rela_1' AS TASK_RS_ID, --任务来源标识
              CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
              'O3' AS sys_rs_id --系统来源标识
         FROM ${ods_db}.O3_TFUNDINFO T0
         LEFT JOIN ${ods_db}.O3_TASSET T1
           ON T0.L_FUND_ID = T1.L_FUND_ID
         LEFT JOIN ${ods_db}.O3_TCOMBI T2
           ON T1.L_ASSET_ID = T2.L_ASSET_ID
          AND T0.L_FUND_ID = T2.L_FUND_ID;