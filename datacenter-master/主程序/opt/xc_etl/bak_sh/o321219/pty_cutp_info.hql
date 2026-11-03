------------------------------------------------------------------------
  -- 模块名称：对手方信息
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

alter table ${dwd_db}.pty_cutp_info drop if exists partition (sys_rs_id='O3');

insert into ${dwd_db}.pty_cutp_info partition(sys_rs_id)
(	cutp_id, -- 对手方编码
           cutp_no, -- 对手方编号
           cntp_sht, -- 对手方简称
           cntp_name, -- 对手全称
           cntp_typ, -- 对手类型
           conp, -- 联系人
           tel, -- 电话号码
           eml, -- 邮箱地址
           ins_rela_typ, -- 机构主从类型
           main_ins_id, -- 主机构编码
           main_ins_no, -- 主机构编号
           main_ins_sht, -- 主机构名称
           busi_date, -- 业务日期
           task_rs_id, -- 任务来源标识
           dm_created_time, -- 数据中台创建时间
           sys_rs_id -- 系统来源标识
)
SELECT T0.L_RIVAL_ID AS CUTP_ID, --对手方编码
             T0.VC_RIVAL_CODE AS CUTP_NO, --对手方编号
             T0.VC_NAME AS CNTP_SHT, --对手方简称
             T0.VC_ALL_NAME AS CNTP_NAME, --对手全称
             T0.C_RIVAL_TYPE AS CNTP_TYP, --对手类型
             T0.VC_LINKMAN AS CONP, --联系人
             T0.VC_PHONE AS TEL, --电话号码
             null AS EML, --邮箱地址
             T0.C_ORGMASTERORSLAVE AS INS_RELA_TYP, --机构主从类型
             T0.L_MASTERORG_RIVAL_ID AS MAIN_INS_ID, --主机构编码
             T0.L_UPPER_BANK_ID AS MAIN_INS_NO, --主机构编号
             T0.VC_UPPER_BANK_NAME AS MAIN_INS_SHT, --主机构名称
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as BUSI_DATE, --业务日期
             'pty_cutp_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TtradeRIVAL T0;