------------------------------------------------------------------------
  -- 模块名称：操作员信息
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

alter table ${dwd_db}.pty_oper_info drop if exists partition (sys_rs_id='O3');

insert into ${dwd_db}.pty_oper_info partition(sys_rs_id)
(	oper_no, --操作人编号
           oper_name, --操作人名称
           addr, --地址
           eml, --邮箱
           tel, --电话
           oa_no, --OA编号
           busi_date, -- 业务日期
           task_rs_id, -- 任务来源标识
           dm_created_time, -- 数据中台创建时间
           sys_rs_id -- 系统来源标识
)
 SELECT   cast(cast(L_OPERATOR_NO as bigint) as string) AS OPER_NO, --操作人编号
             VC_OPERATOR_NAME AS OPER_NAME, --操作人名称
             VC_ADDRESS AS ADDR, --地址
             VC_EMAIL AS EML, --邮箱
             VC_TEL_NO AS TEL, --电话
             null as oa_no, --OA编号
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd')  as busi_date, --业务日期
             'pty_oper_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TOPERATOR;