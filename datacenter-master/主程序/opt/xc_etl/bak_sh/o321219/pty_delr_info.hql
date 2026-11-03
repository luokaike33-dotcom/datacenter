------------------------------------------------------------------------
  -- 模块名称：交易员信息
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

alter table ${dwd_db}.pty_delr_info drop if exists partition (sys_rs_id='O3');

insert into ${dwd_db}.pty_delr_info partition(sys_rs_id)
(      delr_id, --交易员编码
       is_day_trd, --是否参与当天交易
       is_free_trd, --是否允许自由交易
       disp_oder, --分发次序
       ordr_cnt, --指令条数
       busi_date, -- 业务日期
       task_rs_id, -- 任务来源标识
       dm_created_time, -- 数据中台创建时间
       sys_rs_id -- 系统来源标识
       )
      SELECT T0.l_operator_no AS DELR_ID, --交易员编码
             T0.C_trade AS IS_DAY_TRD, --是否参与当天交易
             T0.C_FREE_ENTRUST AS IS_FREE_TRD, --是否允许自由交易
             T0.L_DISPENSE_ORDER AS DISP_ODER, --分发次序
             T0.L_INSTRUCTION_COUNT AS ODRR_CNT, --指令条数
             ${end_date} as busi_date, --业务日期
             'pty_delr_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TOPtradeINFO T0;