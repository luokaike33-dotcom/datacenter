------------------------------------------------------------------------
  -- 模块名称：产品基本信息
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

  truncate  table  ${dwd_db}.pty_prd_base_info_o32;

insert into ${dwd_db}.pty_prd_base_info_o32
(	prd_code, --产品代码
           sub_code, --子产品代码
           fofs_code, --母产品代码
           prd_name, --产品名称
           prd_typ, --组合类型
           prd_cald, --产品日历
           impt_crt_dt, --引进/创设日期
           found_dt, --成立日期
           prod_sht_py, --产品英文名称
           prd_full_name, --产品全称
           prod_name_py, --产品英文全称
           prod_intr, --产品简介
           crrc, --币种
           parv_unit, --每份面值
           iss_lmt, --发行额度
           dqr_end, --预计到期日
           end_dt, --终止日期
           clr_dt, --清算日期
           is_citd_amor, --是否分期/分级产品
           is_fcode, --是否母产品
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
             null AS SUB_CODE, --子产品代码
             null AS FOFS_CODE, --母产品代码
             T0.VC_FUND_NAME AS PRD_NAME, --产品名称
             '1' AS PRD_TYP, --组合类型,默认资金单元层
             null AS PRD_CALD, --产品日历
             null AS IMPT_CRT_DT, --引进/创设日期
             T0.L_OPEN_DATE AS FOUND_DT, --成立日期
             null AS PROD_SHT_PY, --产品英文名称
             T0.VC_FUND_CAPTION AS PRD_FULL_NAME, --产品全称
             null AS PROD_NAME_PY, --产品英文全称
             null AS PROD_INTR, --产品简介
             T0.VC_CURRENCY_NO AS CRRC, --币种
             T0.EN_FUND_FACEVALUE AS PARV_UNIT, --每份面值,默认1
             null AS ISS_LMT, --发行额度
             T0.L_END_DATE AS DQR_END, --预计到期日
             T0.L_END_DATE AS END_DT, --终止日期
             T0.L_END_DATE AS CLR_DT, -- 清算日期
             '0' AS IS_CITD_AMOR, --是否分期/分级产品,默认0
             '0' AS IS_FCODE, --是否母产品,默认0
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS RS_ID, --系统来源标识
             'pty_prd_base_info_1' AS TASK_RS_ID, --任务来源标识
             'tfundinfo' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY --数据中台更新者
        FROM ${ods_db}.O3_TFUNDINFO T0;