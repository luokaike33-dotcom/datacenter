------------------------------------------------------------------------
  -- 模块名称：汇率
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

alter table ${dwd_db}.var_excr_info_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_excr_info_o32 partition(p_dt)
SELECT T0.L_DATE AS EXCR_DT,
             'HKD' AS BASI_CURR,
             t0.VC_CURRENCY_TARGET AS EXCH_CURR,
             case
               when t0.VC_CURRENCY_SOURCE = 'HK1' then
                '2'
               when t0.VC_CURRENCY_SOURCE = 'HK2' then
                '3'
             end AS EXER_RS,
             T0.EN_BID_PRICE AS BUY_PRC,
             t0.EN_ASK_PRICE AS SELL_PRC,
             t0.EN_MID_PRICE AS MID_PRC,
             T0.L_DATE AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'prc_var_excr_info_1' AS TASK_RS_ID, --任务来源标识
             'thisbondproperty' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     T0.L_DATE
        FROM ${ods_db}.O3_THISCURRENCYRATE t0
       WHERE t0.VC_CURRENCY_SOURCE IN ('HK1', 'HK2')
         AND t0.VC_CURRENCY_TARGET IN ('CNY')
         and t0.l_set_no = '0'
         and t0.L_DATE between ${beg_date} and ${end_date};