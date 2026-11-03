------------------------------------------------------------------------
  -- 模块名称：席位信息表
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

alter table ${dwd_db}.acc_seat_info drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.acc_seat_info partition(sys_rs_id)
       (seat_code, -- 席位代码
       exch_code, -- 交易市场编号
       seat_name, -- 席位名称
       main_seat, -- 主席位
       trad_id, --券商编码
       trad_name, --券商名称
       stat, -- 状态
       clos_dt, -- 注销日期
       pasw, -- 密码
       rmk, -- 备注
       busi_date, -- 业务日期
       task_rs_id, -- 任务来源标识
       dm_created_time, -- 数据中台创建时间
       sys_rs_id -- 系统来源标识
       )
      SELECT T0.VC_SEAT_ID AS SEAT_CODE, --席位代码
             T2.PARA_HCODE AS EXCH_CODE, --交易市场编号
             T0.VC_SEAT_NAME AS SEAT_NAME, --席位名称
             T0.VC_MAIN_SEAT AS MAIN_SEAT, --主席位
             T0.VC_COMPANY_NO AS TRAD_ID, --券商编码
             T1.VC_BROKER_NAME AS TRAD_NAME, --券商名称
             T0.C_STATUS AS STAT, --状态
             T0.L_LOGOFF_DATE AS CLOS_DT, --注销日期
             T0.VC_PASSWORD AS PASW, --密码
             null as rmk, --备注
             ${current_date} as busi_date, --业务日期
             'acc_seat_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS sys_rs_id --系统来源标识
        FROM ${ods_db}.O3_TSEAT T0
        LEFT JOIN ${ods_db}.O3_TBROKER T1
          ON T0.VC_COMPANY_NO = T1.VC_BROKER_NO
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3'
		 ;