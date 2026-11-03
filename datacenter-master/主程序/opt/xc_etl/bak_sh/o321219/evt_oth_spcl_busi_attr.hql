------------------------------------------------------------------------
  -- 模块名称：特殊业务属性表
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

alter table ${dwd_db}.evt_oth_spcl_busi_attr drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.evt_oth_spcl_busi_attr partition(sys_rs_id)
       (exch_code
        ,o32_busi_typ
        ,o32_entr_dir
        ,o32_secu_clas
        ,ctrl_typ
        ,lst_sts_code
        ,lowl_vol
        ,o32_mix_typ
        ,busi_date
        ,task_rs_id
        ,dm_created_time
        ,sys_rs_id
       )
SELECT case when T0.C_MARKET_NO = '1' then 'SH' when T0.C_MARKET_NO = '2' then 'SZ' when T0.C_MARKET_NO = 'j' then 'SB' end AS EXCH_CODE, --交易市场代码
       T0.C_BUSIN_CLASS AS O32_BUSI_TYP, --O32_业务类型
       T0.C_ENTRUST_DIRECTION AS O32_ENTR_DIR, --O32_委托方向
       T0.C_STOCK_TYPE AS O32_SECU_CLAS, --O32_证券类型
       T0.C_CONTROL_TYPE AS O32_CTRL_TYP, --O32_控制类型
       case when T0.C_STOCK_PROPERTY = '0' then '1' when T0.C_STOCK_PROPERTY = '1' then '5' when T0.C_STOCK_PROPERTY = '2' then '2' when T0.C_STOCK_PROPERTY = '3' then '3' else '' end AS LST_STS_CODE, --上市状态代码
       T0.EN_DOWNLIMIT AS LOWL_VOL, --下限数量
       T0.VC_MIXED_TYPE AS O32_MIX_TYP, --O32_杂项分类
       ${current_date} as busi_date, --业务日期
       'evt_oth_spcl_busi_attr_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_TBUSINESSSPECIAL T0