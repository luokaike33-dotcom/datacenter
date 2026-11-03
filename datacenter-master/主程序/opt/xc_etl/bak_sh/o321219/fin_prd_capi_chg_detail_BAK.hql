------------------------------------------------------------------------
  -- 模块名称：产品资金流明细信息
------------------------------------------------------------------------
----set spark.app.name=fin_prd_capi_chg_detail;
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
----set spark.dynamicAllocation.enabled=false;
----set spark.executor.cores=16;
----set spark.driver.memory=32G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;
----set hive.warehouse.subdir.inherit.perms=false;

alter table ${dwd_db}.fin_prd_capi_chg_detail drop if exists partition (p_dt=${end_date},sys_rs_id='DYCF_TA') ;
alter table ${dwd_db}.fin_prd_capi_chg_detail drop if exists partition (p_dt=${end_date},sys_rs_id='DYCF_HB') ;


insert into ${dwd_db}.fin_prd_capi_chg_detail partition(p_dt,sys_rs_id)
(
prd_code
,chg_dt
,capi_chg_typ
,shr_add
,capi_add
,capi_add_fee
,shr_reduce
,capi_reduce
,capi_reduce_fee
,busi_date
,task_rs_id
,dm_created_time
,dm_src_info
,p_dt
,sys_rs_id
)
--TA流水：申购
SELECT
       CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) 
	   ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
	   A.CHG_DT AS CHG_DT, --变动日期
       A.CAPI_CHG_TYP AS CAPI_CHG_TYP, --资金变动类型
       CAST(A.CAPI_ADD AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / CAST(NVL(G.UNIT_NVAL,1) AS DOUBLE) / 100 AS SHR_ADD, --份额增加
       CAST(A.CAPI_ADD AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS CAPI_ADD, --资金增加
       CAST(A.CAPI_ADD_FEE AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS CAPI_ADD_FEE, --资金增加_费用支出
       CAST(A.CAPI_REDUCE AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / CAST(NVL(G.UNIT_NVAL,1) AS DOUBLE) / 100 AS SHR_REDUCE, --份额减少
       CAST(A.CAPI_REDUCE AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS CAPI_REDUCE, --资金减少
       CAST(A.CAPI_REDUCE_FEE AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       CASE WHEN G.UNIT_NVAL IS NOT NULL THEN 'fin_prd_capi_chg_detail_1' ELSE 'fin_prd_capi_chg_detail_11' END AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
	   A.CHG_DT AS p_dt, 
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_CAPI_CHG_DETAIL A --产品资金流明细信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.CHG_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_RATIO <> 0 --申购拆分比例
   AND D.L_ASSET_ID<>'-1'
   AND D.P_DT = ${end_date}
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON A.CHG_DT = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.FIN_PRD_NAV G
	ON G.SYS_RS_ID = 'DYCF'
   AND CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) = G.PRD_CODE
   AND W1.pre_1_dt = G.P_DT --取上一个交易日净值信息
   AND G.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.CHG_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT = ${end_date}
 WHERE A.CAPI_CHG_TYP IN ('TAXS_FHTZ','TAXS_JJCL','TAXS_QZ','TAXS_SG','TAXS_ZR')
  --  'TAXS_FH', --分红除权   -1
  --  'TAXS_FHTZ', --分红转投     1
  --  'TAXS_JJCL', --成立    1
  --  'TAXS_QJ', --强减   -1
  --  'TAXS_QZ', --强增    1
  --  'TAXS_SG', --产品申购    1
  --  'TAXS_SH', --产品赎回   -1
  --  'TAXS_ZC', --转出     -1
  --  'TAXS_ZR' --转入    1
   AND A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND A.CHG_DT <= B.valu_cnfm_dt
   AND A.CHG_DT = ${end_date}

union all
--TA流水：赎回
SELECT
       CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) 
	   ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
	   A.CHG_DT AS CHG_DT, --变动日期
       A.CAPI_CHG_TYP AS CAPI_CHG_TYP, --资金变动类型
       CAST(A.CAPI_ADD AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / CAST(NVL(G.UNIT_NVAL,1) AS DOUBLE) / 100 AS SHR_ADD, --份额增加
       CAST(A.CAPI_ADD AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS CAPI_ADD, --资金增加
       CAST(A.CAPI_ADD_FEE AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS CAPI_ADD_FEE, --资金增加_费用支出
       CAST(A.CAPI_REDUCE AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / CAST(NVL(G.UNIT_NVAL,1) AS DOUBLE) / 100 AS SHR_REDUCE, --份额减少
       CAST(A.CAPI_REDUCE AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS CAPI_REDUCE, --资金减少
       CAST(A.CAPI_REDUCE_FEE AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       CASE WHEN G.UNIT_NVAL IS NOT NULL THEN 'fin_prd_capi_chg_detail_2' ELSE 'fin_prd_capi_chg_detail_22' END AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
	   A.CHG_DT AS p_dt, 	   
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_CAPI_CHG_DETAIL A --产品资金流明细信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.CHG_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_REDEEM_RATIO <> 0 --赎回拆分比例
   AND D.L_ASSET_ID<>'-1'
   AND D.P_DT = ${end_date}   
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON A.CHG_DT = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.FIN_PRD_NAV G
	ON G.SYS_RS_ID = 'DYCF'
   AND CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) = G.PRD_CODE
   AND W1.pre_1_dt = G.P_DT --取上一个交易日净值信息
   AND G.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.CHG_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT = ${end_date}   
 WHERE A.CAPI_CHG_TYP IN ('TAXS_FH','TAXS_QJ','TAXS_SH','TAXS_ZC')
  --  'TAXS_FH', --分红除权   -1
  --  'TAXS_FHTZ', --分红转投     1
  --  'TAXS_JJCL', --成立    1
  --  'TAXS_QJ', --强减   -1
  --  'TAXS_QZ', --强增    1
  --  'TAXS_SG', --产品申购    1
  --  'TAXS_SH', --产品赎回   -1
  --  'TAXS_ZC', --转出     -1
  --  'TAXS_ZR' --转入    1
   AND A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND A.CHG_DT <= B.valu_cnfm_dt
   AND A.CHG_DT = ${end_date}

union all
--补充虚拟赎回流水
SELECT
       CONCAT(A.PRD_CODE, '_XC') AS PRD_CODE, --产品代码
	   A.P_DT AS CHG_DT, --变动日期
       'SH' AS CAPI_CHG_TYP, --资金变动类型
       0 AS SHR_ADD, --份额增加
       0 AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       A.TTL_SHR AS SHR_REDUCE, --份额减少
       A.TTL_NAVL AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_xnsh' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
	   A.P_DT AS p_dt, 	   
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_NAV A --产品资金流明细信息 
 INNER JOIN ${dwd_db}.PTY_PRD_DIFF_INFO H --产品差异信息
    ON A.PRD_CODE = H.PRD_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON ${end_date} = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'	
 WHERE A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND W1.pre_1_dt = a.p_dt
   AND H.END_DATE = ${end_date}
   AND A.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}

union all
--补充虚拟申购流水
SELECT
       CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) AS PRD_CODE, --产品代码
	   A.P_DT AS CHG_DT, --变动日期
       'SG' AS CAPI_CHG_TYP, --资金变动类型
       cast(A.TTL_SHR as double) * CAST(NVL(D.EN_RATIO, 100) AS double) /100 AS SHR_ADD, --份额增加
       cast(A.TTL_NAVL as double) * CAST(NVL(D.EN_RATIO, 100) AS double) /100 AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       0 AS SHR_REDUCE, --份额减少
       0 AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_xnsg' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
	   A.P_DT AS p_dt, 	   
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_NAV A --产品资金流明细信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.P_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_RATIO <> 0 --申购拆分比例
   AND D.L_ASSET_ID<>'-1'
   AND D.P_DT = ${end_date}
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON A.P_DT = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'
 INNER JOIN ${dwd_db}.PTY_PRD_DIFF_INFO H --产品差异信息
    ON A.PRD_CODE = H.PRD_CODE
 WHERE A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND W1.pre_1_dt = a.p_dt
   AND H.END_DATE = ${end_date}
   AND A.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
   
union all
--资金管理-划拨资金
SELECT
       CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.L_DATE AS CHG_DT, --变动日期
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN '3' ELSE '4' END AS CAPI_CHG_TYP, --资金变动类型
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN (CAST(A.EN_OCCUR_BALANCE AS double) / CAST(NVL(D.UNIT_NVAL,1) AS double))
            ELSE 0
       END AS SHR_ADD, --份额增加
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       CASE WHEN A.L_BUSIN_FLAG IN ('40102') THEN (CAST(A.EN_OCCUR_BALANCE AS double) / CAST(NVL(D.UNIT_NVAL,1) AS double))
            ELSE 0
       END AS SHR_REDUCE, --份额减少
       CASE WHEN A.L_BUSIN_FLAG IN ('40102') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       CASE WHEN D.UNIT_NVAL IS NOT NULL THEN 'fin_prd_capi_chg_detail_3' ELSE 'fin_prd_capi_chg_detail_33' END AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'O3_THISCURRENTS' AS dm_src_info,
	   A.L_DATE AS p_dt, 	   
       'DYCF_HB' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --流水表
 INNER JOIN ${ods_db}.O3_TFUNDINFO B  --O32产品信息
    ON A.L_FUND_ID = B.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET C --032单元信息
    ON A.L_ASSET_ID = C.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON A.P_DT = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.FIN_PRD_NAV D
	ON D.SYS_RS_ID = 'DYCF'
   AND CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = D.PRD_CODE
   AND W1.pre_1_dt = D.P_DT --取上一个交易日净值信息
   AND D.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO E --产品基本信息，获取产品层产品
    ON CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = E.PRD_CODE
 WHERE A.L_BUSIN_FLAG IN ('40101', '40102')
   AND A.vc_busin_opflag = '107'
   AND NVL(A.C_STATUS,'1') = '1'   
   AND A.P_DT <= E.valu_cnfm_dt
   AND A.p_dt = ${end_date}
   
union all
--资金管理-划拨证券
SELECT
       CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.L_DATE AS CHG_DT, --变动日期
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN '3' ELSE '4' END AS CAPI_CHG_TYP, --资金变动类型
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN (CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)/ CAST(NVL(D.UNIT_NVAL,1) AS double))
            ELSE 0
       END AS SHR_ADD, --份额增加
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       CASE WHEN A.L_BUSIN_FLAG IN ('40302') THEN (CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double) / CAST(NVL(D.UNIT_NVAL,1) AS double))
            ELSE 0
       END AS SHR_REDUCE, --份额减少
       CASE WHEN A.L_BUSIN_FLAG IN ('40302') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       CASE WHEN D.UNIT_NVAL IS NOT NULL THEN 'fin_prd_capi_chg_detail_4' ELSE 'fin_prd_capi_chg_detail_44' END AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   'O3_THISCURRENTS' AS dm_src_info,
	   A.L_DATE AS p_dt, 	 	   
       'DYCF_HB' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --流水表
 INNER JOIN ${ods_db}.O3_TFUNDINFO B  --O32产品信息
    ON A.L_FUND_ID = B.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET C --032单元信息
    ON A.L_ASSET_ID = C.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON A.P_DT = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.FIN_PRD_NAV D
	ON D.SYS_RS_ID = 'DYCF'
   AND CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = D.PRD_CODE
   AND W1.pre_1_dt = D.P_DT --取上一个交易日净值信息
   AND D.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO E --产品基本信息，获取产品层产品
    ON CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = E.PRD_CODE
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO F
    ON A.P_DT = F.P_DT
   AND A.VC_INTER_CODE = F.VC_INTER_CODE
   AND F.P_DT = ${end_date}   
 WHERE A.L_BUSIN_FLAG IN ('40301', '40302')
   AND (A.vc_busin_opflag = '207' OR A.VC_SUMMARY LIKE '%组合证券合并%' OR A.VC_SUMMARY LIKE '%ims-fof管理划券%' OR A.VC_SUMMARY LIKE '%证券增加(手工)(批量复核)%' OR A.VC_SUMMARY LIKE '%证券减少(手工)(批量复核)%')
   AND NVL(A.C_STATUS,'1') = '1'
   AND A.P_DT <= E.valu_cnfm_dt   
   AND A.p_dt = ${end_date}
