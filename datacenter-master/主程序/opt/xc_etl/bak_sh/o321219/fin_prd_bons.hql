------------------------------------------------------------------------
  -- 模块名称：产品分红信息
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

alter table ${dwd_db}.fin_prd_bons drop if exists partition (sys_rs_id='DYCF') ;


insert into ${dwd_db}.fin_prd_bons partition(sys_rs_id)
(
prd_code
,rt_reg_dt
,ex_rd_dt
,unit_shr_bons
,spli_cnv_rat
,bons_shr
,bons_val
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,sys_rs_id
)
SELECT CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) AS PRD_CODE, --产品代码
       A.RT_REG_DT AS RT_REG_DT, --股权登记日期
       A.EX_RD_DT AS EX_RD_DT, --除权除息日期
       A.UNIT_SHR_BONS AS UNIT_SHR_BONS, --每份分红
       A.SPLI_CNV_RAT AS SPLI_CNV_RAT, --拆分折算比例
       CAST(A.BONS_SHR AS DECIMAL(18,2)) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS DECIMAL(18,2)) / 100 AS BONS_SHR, --分红份额
       CAST(A.BONS_VAL AS DECIMAL(18,2)) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS DECIMAL(18,2)) / 100 AS BONS_VAL, --分红金额
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_dpsi_pro_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_BONS' AS dm_src_info,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_BONS A --产品分红信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取组合层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.EX_RD_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_BONUS_RATIO <> 0 --分红拆分比例
   AND D.L_ASSET_ID<>'-1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
 WHERE A.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND A.EX_RD_DT <= B.valu_cnfm_dt