------------------------------------------------------------------------
  -- 模块名称：股东信息表
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

alter table ${dwd_db}.acc_sh_info drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.acc_sh_info partition(sys_rs_id)
    (sh_code, --股东代码
       exch_code, --交易市场编号
       sh_name, --股东名称
       oact_dt, --开户日期
       sh_stat, --股东状态
       sh_assn_stat, --股东指定状态
       sh_attr, --股东属性
       sh_clas, --股东类型
       assn_seat, --指定席位
       rmk, --备注
       busi_date, -- 业务日期
       task_rs_id, -- 任务来源标识
       dm_created_time, -- 数据中台创建时间
       sys_rs_id -- 系统来源标识
       )
      SELECT T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
             t2.para_hcode AS EXCH_CODE, --交易市场编号
             T0.VC_STOCKHOLDER_NAME AS SH_NAME, --股东名称
             T0.L_OPEN_DATE AS OACT_DT, --开户日期
             T0.C_STOCKHOLDER_STATUS AS SH_STAT, --股东状态
             T0.C_BIND_STATUS AS SH_ASSN_STAT, --股东指定状态
             T0.VC_OWNER_TYPE AS SH_ATTR, --股东属性
             NVL(
             case when T0.C_CREDIT_STOCKHOLDER = 0 then 1
                  when T0.C_CREDIT_STOCKHOLDER = 1 then 2
                  when T0.C_CREDIT_STOCKHOLDER = 2 then 3
             end
             , 1) AS SH_CLAS,  --股东类型
             T0.VC_BIND_SEAT AS ASSN_SEAT, --指定席位
             T0.VC_REMARKS AS RMK, --备注
             ${current_date} as busi_date, --业务日期
             'acc_sh_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS sys_rs_id --系统来源标识
        FROM ${ods_db}.O3_TSTOCKHOLDER T0
        LEFT JOIN ${dwd_db}.PUB_PARA_MAPPING T2
          ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
         AND T2.PARA_CLASS_HCODE = '4'
         AND T2.ORISYS_HCODE = 'HSO3'
		 ;