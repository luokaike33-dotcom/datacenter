------------------------------------------------------------------------
  -- 模块名称：产品资金流明细信息
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

alter table ${dwd_db}.fin_prd_capi_chg_detail drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='DYCF_TA') ;
alter table ${dwd_db}.fin_prd_capi_chg_detail drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}, sys_rs_id='DYCF_HB') ;


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
       CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , 
     CASE WHEN A.L_ASSET_ID = '0' THEN F.VC_ASSET_NO ELSE NVL(E.VC_ASSET_NO, F.VC_ASSET_NO) END) 
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
       'SG' AS CAPI_CHG_TYP, --资金变动类型
       case 
    when l_busin_flag = '40101' then en_occur_balance 
    when l_busin_flag = '71902' then en_subject_balance 
    when l_busin_flag = '72202' and L_SUBJECT_NO = '201' then en_subject_balance
    when l_busin_flag = '72201' and L_SUBJECT_NO = '114' then en_subject_balance
     end AS SHR_ADD, --份额增加
       case 
    when l_busin_flag = '40101' then en_occur_balance 
    when l_busin_flag = '71902' then en_subject_balance 
    when l_busin_flag = '72202' and L_SUBJECT_NO = '201' then en_subject_balance
    when l_busin_flag = '72201' and L_SUBJECT_NO = '114' then en_subject_balance
     end AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       0 AS SHR_REDUCE, --份额减少
       0 AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
     A.P_DT AS p_dt, 
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'  
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND (
    (A.l_busin_flag in ('40101') and A.vc_busin_opflag in ('101','102')) 
    or (l_busin_flag in ('71902')) 
    or (l_busin_flag = '72202' AND L_SUBJECT_NO in ('201'))
    or (l_busin_flag = '72201' AND L_SUBJECT_NO in ('114')) 
    )
   AND NVL(A.C_STATUS,'1') = '1'    
   AND A.P_DT between ${beg_date} and ${end_date}

union all
--TA流水：赎回
SELECT
       CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , 
     CASE WHEN A.L_ASSET_ID = '0' THEN F.VC_ASSET_NO ELSE NVL(E.VC_ASSET_NO, F.VC_ASSET_NO) END) 
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
       'SH' AS CAPI_CHG_TYP, --资金变动类型
       0 AS SHR_ADD, --份额增加
       0 AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       case 
    when l_busin_flag = '40102' then en_occur_balance
    when l_busin_flag = '71903' then en_subject_balance
    when l_busin_flag = '72202' and L_SUBJECT_NO = '114' then en_subject_balance
    when l_busin_flag = '72201' and L_SUBJECT_NO = '201' then en_subject_balance
     end AS SHR_REDUCE, --份额减少
       case 
    when l_busin_flag = '40102' then en_occur_balance
    when l_busin_flag = '71903' then en_subject_balance
    when l_busin_flag = '72202' and L_SUBJECT_NO = '114' then en_subject_balance
    when l_busin_flag = '72201' and L_SUBJECT_NO = '201' then en_subject_balance
     end AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
     A.P_DT AS p_dt,     
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID   
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'  
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND (
    (A.l_busin_flag in ('40102') and A.vc_busin_opflag in ('101','102')) 
    or (l_busin_flag in ('71903')) 
    or (l_busin_flag = '72202' AND L_SUBJECT_NO in ('114'))
    or (l_busin_flag = '72201' AND L_SUBJECT_NO in ('201')) 
    )
   AND NVL(A.C_STATUS,'1') = '1'        
   AND A.P_DT between ${beg_date} and ${end_date}

union all
--TA流水：分红再投
SELECT
     CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) 
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
     'FHTZ' AS CAPI_CHG_TYP, --资金变动类型
     en_subject_balance AS SHR_ADD, --份额增加
     en_subject_balance AS CAPI_ADD, --资金增加
     0 AS CAPI_ADD_FEE, --资金增加_费用支出
     0 AS SHR_REDUCE, --份额减少
     0 AS CAPI_REDUCE, --资金减少
     0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'fin_prd_capi_chg_detail_3' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
     A.P_DT AS p_dt,     
     'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID   
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'  
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND A.l_busin_flag in ('71911') 
   AND NVL(A.C_STATUS,'1') = '1'        
   AND A.P_DT between ${beg_date} and ${end_date}

union all
--TA流水：科目余额调整
SELECT
     CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) 
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     T3.P_DT AS CHG_DT, --变动日期
     'KMTZ' AS CAPI_CHG_TYP, --资金变动类型
     case when T3.l_busin_flag = '40101' then T3.en_occur_balance end AS SHR_ADD, --份额增加
     case when T3.l_busin_flag = '40101' then T3.en_occur_balance end AS CAPI_ADD, --资金增加
     0 AS CAPI_ADD_FEE, --资金增加_费用支出
     case when T3.l_busin_flag = '40102' then T3.en_occur_balance end AS SHR_REDUCE, --份额减少
     case when T3.l_busin_flag = '40102' then T3.en_occur_balance end AS CAPI_REDUCE, --资金减少
     0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'fin_prd_capi_chg_detail_4' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'FIN_PRD_CAPI_CHG_DETAIL' AS dm_src_info,
     T3.P_DT AS p_dt,     
     'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  inner join ${ods_db}.O3_thissubjectbusiness t2
    on a.P_DT = t2.L_DATE
   and a.l_fund_id = t2.l_fund_id
   and a.l_busin_no = t2.l_busin_no
   and t2.c_adjust_asset = 1
  inner join ${ods_db}.O3_thiscurrents t3
    on a.P_DT = t3.P_DT
   and a.l_fund_id = t3.l_fund_id
   and a.l_busin_no = t3.l_busin_no
   and t3.l_busin_flag in ('40101','40102')
   and t3.vc_busin_opflag in ('301','302')  
   and t3.P_DT between ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID   
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'  
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND a.L_BUSIN_FLAG IN ('72202','72201')
   AND a.L_SUBJECT_NO IN ('114','201')
   AND NVL(A.C_STATUS,'1') = '1'        
   AND A.P_DT between ${beg_date} and ${end_date}

union all
--TA申购、赎回冲现
SELECT
     CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , 
     CASE WHEN A.L_ASSET_ID = '0' THEN F.VC_ASSET_NO ELSE NVL(E.VC_ASSET_NO, F.VC_ASSET_NO) END) 
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
     case when l_busin_flag = '71802' then 'SGCX' else 'SHCX' end AS CAPI_CHG_TYP, --资金变动类型
     case when l_busin_flag = '71802' then en_occur_balance end AS SHR_ADD, --份额增加
     case when l_busin_flag = '71802' then en_occur_balance end AS CAPI_ADD, --资金增加
     0 AS CAPI_ADD_FEE, --资金增加_费用支出
     case when l_busin_flag = '71804' then en_occur_balance end AS SHR_REDUCE, --份额减少
     case when l_busin_flag = '71804' then en_occur_balance end AS CAPI_REDUCE, --资金减少
     0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'fin_prd_capi_chg_detail_5' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     regexp_replace(reflect("java.util.UUID","randomUUID"),"-","") AS dm_src_info, --特殊做法为了获取唯一数据
     A.P_DT AS p_dt, 
     'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'  
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND A.l_busin_flag in ('71802','71804')
   AND NVL(A.C_STATUS,'1') = '1'       
   AND A.P_DT between ${beg_date} and ${end_date}

union all
--TA申购、赎回冲现虚拟单元
SELECT
     CASE WHEN H.L_FUND_ID IS NOT NULL THEN CONCAT(C.VC_FUND_CODE , '_' , F.VC_ASSET_NO)
     ELSE CONCAT(C.VC_FUND_CODE , '_XC') END AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
     case when l_busin_flag = '71804' then 'SGCX' else 'SHCX' end  AS CAPI_CHG_TYP, --资金变动类型
     case when l_busin_flag = '71804' then en_occur_balance end AS SHR_ADD, --份额增加
     case when l_busin_flag = '71804' then en_occur_balance end AS CAPI_ADD, --资金增加
     0 AS CAPI_ADD_FEE, --资金增加_费用支出
     case when l_busin_flag = '71802' then en_occur_balance end AS SHR_REDUCE, --份额减少
     case when l_busin_flag = '71802' then en_occur_balance end AS CAPI_REDUCE, --资金减少
     0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
     date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
     'fin_prd_capi_chg_detail_6' AS TASK_RS_ID, --任务来源标识
     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     regexp_replace(reflect("java.util.UUID","randomUUID"),"-","") AS dm_src_info,  --特殊做法为了获取唯一数据
     A.P_DT AS p_dt, 
     'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --资金流水表
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.L_FUND_ID = C.L_FUND_ID
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON C.VC_FUND_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON A.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${ods_db}.o3_thisfundasset H
   ON A.P_DT = H.P_DT
  AND C.L_FUND_ID = H.L_FUND_ID
  AND H.EN_FUND_VALUE <> 0
  AND H.P_DT between ${beg_date} and ${end_date}
  AND H.vc_currency_no = 'CNY'    
 WHERE A.P_DT <= B.valu_cnfm_dt
   AND A.l_busin_flag in ('71802','71804')
   AND NVL(A.C_STATUS,'1') = '1'       
   AND A.P_DT between ${beg_date} and ${end_date}
   
union all
--补充虚拟赎回流水
SELECT
       CONCAT(A.PRD_CODE, '_XC') AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
       'SH' AS CAPI_CHG_TYP, --资金变动类型
       0 AS SHR_ADD, --份额增加
       0 AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       A.TTL_NAVL AS SHR_REDUCE, --份额减少
       A.TTL_NAVL AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_7' AS TASK_RS_ID, --任务来源标识
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
   AND H.END_DATE between ${beg_date} and ${end_date}
   and A.P_DT between h.stat_date and h.END_DATE
   AND A.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}

union all
--补充虚拟申购流水
SELECT
       CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) AS PRD_CODE, --产品代码
     A.P_DT AS CHG_DT, --变动日期
       'SG' AS CAPI_CHG_TYP, --资金变动类型
       cast(A.TTL_NAVL as double) * CAST(NVL(D.EN_RATIO, 100) AS double) /100 AS SHR_ADD, --份额增加
       cast(A.TTL_NAVL as double) * CAST(NVL(D.EN_RATIO, 100) AS double) /100 AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       0 AS SHR_REDUCE, --份额减少
       0 AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_8' AS TASK_RS_ID, --任务来源标识
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
   AND D.P_DT between ${beg_date} and ${end_date}
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
   AND H.END_DATE between ${beg_date} and ${end_date}
   AND A.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
   
union all
--资金管理-划拨资金
SELECT
       CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.L_DATE AS CHG_DT, --变动日期
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN '3' ELSE '4' END AS CAPI_CHG_TYP, --资金变动类型
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS SHR_ADD, --份额增加
       CASE WHEN A.L_BUSIN_FLAG IN ('40101') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       CASE WHEN A.L_BUSIN_FLAG IN ('40102') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS SHR_REDUCE, --份额减少
       CASE WHEN A.L_BUSIN_FLAG IN ('40102') THEN A.EN_OCCUR_BALANCE
            ELSE 0
       END AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_9' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'O3_THISCURRENTS' AS dm_src_info,
     A.L_DATE AS p_dt,     
       'DYCF_HB' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --流水表
 INNER JOIN ${ods_db}.O3_TFUNDINFO B  --O32产品信息
    ON A.L_FUND_ID = B.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET C --032单元信息
    ON A.L_ASSET_ID = C.L_ASSET_ID
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO E --产品基本信息，获取产品层产品
    ON CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = E.PRD_CODE
 WHERE A.L_BUSIN_FLAG IN ('40101', '40102')
   AND A.vc_busin_opflag = '107'
   AND NVL(A.C_STATUS,'1') = '1'   
   AND A.P_DT <= E.valu_cnfm_dt
   AND A.p_dt between ${beg_date} and ${end_date}
   
union all
--资金管理-划拨证券
SELECT
       CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.L_DATE AS CHG_DT, --变动日期
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN '3' ELSE '4' END AS CAPI_CHG_TYP, --资金变动类型
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS SHR_ADD, --份额增加
       CASE WHEN A.L_BUSIN_FLAG IN ('40301') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS CAPI_ADD, --资金增加
       0 AS CAPI_ADD_FEE, --资金增加_费用支出
       CASE WHEN A.L_BUSIN_FLAG IN ('40302') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS SHR_REDUCE, --份额减少
       CASE WHEN A.L_BUSIN_FLAG IN ('40302') THEN CAST(A.L_BUSIN_AMOUNT AS double) * CAST(F.EN_LAST_PRICE AS double)
            ELSE 0
       END AS CAPI_REDUCE, --资金减少
       0 AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_10' as TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
     'O3_THISCURRENTS' AS dm_src_info,
     A.L_DATE AS p_dt,       
       'DYCF_HB' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS A --流水表
 INNER JOIN ${ods_db}.O3_TFUNDINFO B  --O32产品信息
    ON A.L_FUND_ID = B.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET C --032单元信息
    ON A.L_ASSET_ID = C.L_ASSET_ID
  INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO E --产品基本信息，获取产品层产品
    ON CONCAT(B.VC_FUND_CODE , '_' , C.VC_ASSET_NO) = E.PRD_CODE
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO F
    ON A.P_DT = F.P_DT
   AND A.VC_INTER_CODE = F.VC_INTER_CODE
   AND F.P_DT between ${beg_date} and ${end_date}
 WHERE A.L_BUSIN_FLAG IN ('40301', '40302')
   AND (A.vc_busin_opflag = '207' OR A.VC_SUMMARY LIKE '%组合证券合并%' OR A.VC_SUMMARY LIKE '%ims-fof管理划券%' )
   AND NVL(A.C_STATUS,'1') = '1'
   AND A.P_DT <= E.valu_cnfm_dt   
   AND A.p_dt between ${beg_date} and ${end_date}

union all
--手工补录
SELECT
       PRD_CODE AS PRD_CODE, --产品代码
       CHG_DT AS CHG_DT, --变动日期
       CAPI_CHG_TYP AS CAPI_CHG_TYP, --资金变动类型
       SHR_ADD AS SHR_ADD, --份额增加
       CAPI_ADD AS CAPI_ADD, --资金增加
       CAPI_ADD_FEE AS CAPI_ADD_FEE, --资金增加_费用支出
       SHR_REDUCE AS SHR_REDUCE, --份额减少
       CAPI_REDUCE AS CAPI_REDUCE, --资金减少
       CAPI_REDUCE_FEE AS CAPI_REDUCE_FEE, --资金减少_费用支出
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_capi_chg_detail_11' as TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'FIN_PRD_CAPI_CHGD_INPT' AS dm_src_info,
       CHG_DT AS p_dt,       
       'DYCF_TA' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_CAPI_CHGD_INPT A --资金流补录表
 WHERE CHG_DT between ${beg_date} and ${end_date}

