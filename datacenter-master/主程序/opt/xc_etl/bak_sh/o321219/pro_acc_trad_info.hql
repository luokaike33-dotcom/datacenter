------------------------------------------------------------------------
  -- 模块名称：券商信息
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

 truncate  table  ${dwd_db}.pro_acc_trad_info;
insert into ${dwd_db}.pro_acc_trad_info
(	trad_id, --  券商编码
           trad_name, --  券商名称
           trd_men_num, --  交易会员号
           futr_pl_avl_mdl, --  期货盈亏可用模式
           sett_men_num, --  结算会员号
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
SELECT T0.VC_BROKER_NO AS TRAD_ID, --券商编码
             T0.VC_BROKER_NAME AS TRAD_NAME, --券商名称
             T0.VC_trade_MEMBER AS TRD_MEN_NUM, --交易会员号
             T0.C_PROFIT_AVAILABLE AS FUTR_PL_AVL_MDL, --期货盈亏可用模式
             T0.VC_SELLTE_MEMBER AS SETT_MEN_NUM, --结算会员号
              DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS RS_ID, --系统来源标识
             'pro_acc_trad_info_1' AS TASK_RS_ID, --任务来源标识
             'tbroker' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY --数据中台更新者
        FROM ${ods_db}.O3_TBROKER T0;