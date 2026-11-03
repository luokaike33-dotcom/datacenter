------------------------------------------------------------------------
  -- 模块名称：产品代码关联关系表
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

  truncate  table  ${dwd_db}.pty_prd_code_rela_o32;

insert into ${dwd_db}.pty_prd_code_rela_o32
(	prd_code, -- 产品代码
           itnl_code, -- 内部代码
           asso_code, -- 基金业协会代码
           valu_id, -- 估值代码
           ta_code, -- ta代码
           trd_sys_id, -- 交易系统代码
           secu_id, -- 证券代码
           busi_date, -- 业务日期
           upd_time, -- 源数据修改时间
           sys_rs_id, -- 系统来源标识
           task_rs_id, -- 任务来源标识
           dm_src_info, -- 来源信息
           dm_created_time, -- 数据中台创建时间
           dm_created_by, -- 数据中台创建者
           dm_updated_time, -- 数据中台更新时间
           dm_updated_by -- 数据中台更新者
)
SELECT T0.VC_FUND_CODE AS PRD_CODE, --产品代码
             null AS ITNL_CODE, --内部代码
             null AS ASSO_CODE, --基金业协会代码
             null AS VALU_ID, --估值代码
             null AS TA_CODE, --TA代码
             T0.L_FUND_ID AS TRD_SYS_ID, --交易系统代码
             null AS SECU_ID, --证券代码
              DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS RS_ID, --系统来源标识
             'pty_prd_code_rela_1' AS TASK_RS_ID, --任务来源标识
             'tfundinfo' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY --数据中台更新者
        FROM ${ods_db}.O3_TFUNDINFO T0;