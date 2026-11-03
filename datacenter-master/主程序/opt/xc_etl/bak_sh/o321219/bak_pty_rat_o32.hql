------------------------------------------------------------------------
  -- 模块名称：机构评级
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

alter table ${dwd_db}.pty_rat_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;
insert into ${dwd_db}.pty_rat_o32 partition(p_dt)
-- (	com_id, -- 机构编号
--            com_id_code, -- 评级机构代码
--            com_name, -- 机构名称
--            rat_dt, -- 评级日期
--            rat_typ, -- 评级类型
--            rat_name, -- 信用评级
--            rat_obj_code, -- 评级对象类型代码
--            busi_date, -- 业务日期
--            upd_time, -- 源数据修改时间
--            sys_rs_id, -- 系统来源标识
--            task_rs_id, -- 任务来源标识
--            dm_src_info, -- 来源信息
--            dm_created_time, -- 数据中台创建时间
--            dm_created_by, -- 数据中台创建者
--            dm_updated_time, -- 数据中台更新时间
--            dm_updated_by -- 数据中台更新者
-- )
--外部主体评级
SELECT T0.L_ISSUER_ID AS COM_ID, --机构编号
       T0.VC_APPRAISE_ORGAN AS COM_ID_CODE, --评级机构代码
       T3.VC_ITEM_NAME AS COM_NAME, --机构名称
       T0.L_OUTER_APPRAISE_DATE AS RAT_DT, --评级日期
       '1' AS RAT_TYP, --评级类型
       T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
       '2' AS RAT_OBJ_CODE, --评级对象类型代码
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
       NULL AS UPD_TIME, --源数据更新时间
       'O3' AS RS_ID, --系统来源标识
       'pty_rat_1' AS TASK_RS_ID, --任务来源标识
       'tissuer' AS DM_SRC_INFO, --来源信息
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
       CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
       'OUTLINE' AS DM_UPDATED_BY, --数据中台更新者
       cast(T0.L_OUTER_APPRAISE_DATE as bigint)
FROM ${ods_db}.O3_TISSUER T0
         LEFT JOIN ${ods_db}.O3_TDICTIONARY T3
                   ON T3.L_DICTIONARY_NO = '60200'
                       AND T0.VC_APPRAISE_ORGAN = T3.C_LEMMA_ITEM
         LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                   ON T4.L_DICTIONARY_NO = '110000'
                       AND T0.C_OUTER_APPRAISE = T4.C_LEMMA_ITEM
WHERE T0.C_OUTER_APPRAISE IS NOT NULL
UNION ALL
--内部主体评级
SELECT T0.L_ISSUER_ID AS COM_ID, --机构编号
       'TK' AS COM_ID_CODE, --评级机构代码
       'TK' AS COM_NAME, --机构名称
       T0.L_OUTER_APPRAISE_DATE AS RAT_DT, --评级日期
       '1' AS RAT_TYP, --评级类型
       T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
       '3' AS RAT_OBJ_CODE, --评级对象类型代码
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
       NULL AS UPD_TIME, --源数据更新时间
       'O3' AS RS_ID, --系统来源标识
       'pty_rat_2' AS TASK_RS_ID, --任务来源标识
       'tissuer' AS DM_SRC_INFO, --来源信息
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
       CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
       'OUTLINE' AS DM_UPDATED_BY, --数据中台更新者
       cast(T0.L_OUTER_APPRAISE_DATE as bigint)
FROM ${ods_db}.O3_TISSUER T0
         LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                   ON T4.L_DICTIONARY_NO = '110001'
                       AND T0.C_INSIDE_APPRAISE = T4.C_LEMMA_ITEM
WHERE T0.C_INSIDE_APPRAISE IS NOT NULL
UNION ALL
--担保评级
SELECT T0.L_ISSUER_ID AS COM_ID, --机构编号
       'TK' AS COM_ID_CODE, --评级机构代码
       'TK' AS COM_NAME, --机构名称
       T0.L_OUTER_APPRAISE_DATE AS RAT_DT, --评级日期
       '1' AS RAT_TYP, --评级类型
       T4.VC_ITEM_NAME AS RAT_NAME, --信用评级
       '4' AS RAT_OBJ_CODE, --评级对象类型代码
       DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
       NULL AS UPD_TIME, --源数据更新时间
       'O3' AS RS_ID, --系统来源标识
       'pty_rat_3' AS TASK_RS_ID, --任务来源标识
       'tissuer' AS DM_SRC_INFO, --来源信息
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
       CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
       'OUTLINE' AS DM_UPDATED_BY, --数据中台更新者
       cast(T0.L_OUTER_APPRAISE_DATE as bigint)
FROM ${ods_db}.O3_TISSUER T0
         LEFT JOIN ${ods_db}.O3_TDICTIONARY T4
                   ON T4.L_DICTIONARY_NO = '110001'
                       AND T0.C_GUARANTOR_APPRAISE = T4.C_LEMMA_ITEM
WHERE T0.C_GUARANTOR_APPRAISE IS NOT NULL;