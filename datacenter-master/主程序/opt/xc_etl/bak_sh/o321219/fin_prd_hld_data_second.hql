------------------------------------------------------------------------
-- 模块名称：产品持仓信息--现金部分活期存款
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
----set spark.driver.memory=4G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;



alter table ${dwd_db}.fin_prd_hld_data drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='DYCF_CASH');



WITH VFIN_PRD_HLD_DATA AS (
SELECT T0.PRD_CODE, T0.HLD_DT, SUM(T0.HLD_VAL) AS HLD_VAL, SUM(T0.ACCR_INTR) AS ACCR_INTR
 FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2  --产品基本信息，获取产品
   ON T0.PRD_CODE = T2.PRD_CODE
  AND T2.PRD_TYP = '1'                                  
 LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
   ON T0.SECU_ID = T1.SECU_ID
WHERE T0.P_DT between ${beg_date} and ${end_date}
  AND T0.TYP_CODE IN ('CASH', 'DPSI') AND T1.TRD_CODE IN ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','QSJSBFJ')
  AND T0.EXCH_CODE NOT IN ('CFFEX', 'SHFE', 'CZCE', 'DCE')----范围见word说明
  AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25')
GROUP BY T0.PRD_CODE, T0.HLD_DT
),
V_ZQSGK AS (
SELECT T3.PRD_CODE, T0.HLD_DT, SUM(T0.HLD_VAL) AS HLD_VAL
 FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2  --产品基本信息，获取产品
   ON T0.PRD_CODE = T2.PRD_CODE
  AND T2.PRD_TYP = '2'                                  
 LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
   ON T0.SECU_ID = T1.SECU_ID
 LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T3
   ON T0.PRD_CODE = T3.AST_UNIT_CODE
WHERE T0.P_DT between ${beg_date} and ${end_date}
  AND T1.TRD_CODE IN ('ZQSGK')
  AND T0.SYS_RS_ID IN ('DYCF')
GROUP BY T3.PRD_CODE, T0.HLD_DT
)     


insert into ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
(prd_code,hld_dt,prd_typ,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_typ,cir_id,ast_stat,pos_id,lf_curr_id,curr_code,olcy_curr_code,crse_name,hld_vol,hld_cost,quot_prc,hld_val,olcy_hld_cost,olcy_hld_val,accr_intr,recv_divd,valu_add,intr_adj,ipmt_pvsn,ipmt_pvsn_i,ipmt_pvsn_ii,ipmt_pvsn_iii,pl_adj,oth_equi_chg,excr,is_value_cnfm,secu_quot_dt,iss_typ,acg_proj,busi_date,task_rs_id,dm_created_time,valu_aprc,ipmt_intr,aggr_fixa,dm_src_info,p_dt,sys_rs_id)
SELECT
T1.prd_code
,T1.hld_dt
,T1.prd_typ
,T1.secu_id
,T1.typ_code
,T1.typ_codei
,T1.typ_codeii
,T1.exch_code
,T1.chi_name
,T1.crse_code
,T1.crse_type
,T1.crse_dim
,T1.inv_typ
,T1.cir_id
,T1.ast_stat
,T1.pos_id
,T1.lf_curr_id
,T1.curr_code
,T1.olcy_curr_code
,T1.crse_name
,T1.hld_vol
,T1.hld_cost
,T1.quot_prc
,T1.hld_val
,T1.olcy_hld_cost
,T1.olcy_hld_val
,T1.accr_intr
,T1.recv_divd
,T1.valu_add
,T1.intr_adj
,T1.ipmt_pvsn
,T1.ipmt_pvsn_i
,T1.ipmt_pvsn_ii
,T1.ipmt_pvsn_iii
,T1.pl_adj
,T1.oth_equi_chg
,T1.excr
,T1.is_value_cnfm
,T1.secu_quot_dt
,T1.iss_typ
,T1.acg_proj
,T1.busi_date
,T1.task_rs_id
,T1.dm_created_time
,T1.valu_aprc
,T1.ipmt_intr
,T1.aggr_fixa
,T1.dm_src_info
,T1.p_dt
,T1.sys_rs_id
FROM (
--现金类-投资端-现金类资产
SELECT PRD_CODE, --产品代码
       HLD_DT, --持仓日期
       PRD_TYP, --组合类型
       SECU_ID, --证券编码
       TYP_CODE, --证券类别代码（大类）
       TYP_CODEI, --证券类别代码（中类）
       TYP_CODEII, --证券类别代码（细类）
       EXCH_CODE, --交易市场代码
       CHI_NAME, --证券中文名称
       CRSE_CODE, --会计科目
       CRSE_TYPE, --科目大类
       CRSE_DIM, --科目属性
       INV_TYP, --投资类型
       CIR_ID, --流通标识
       AST_STAT, --资产状态
       POS_ID, --多空标识
       LF_CURR_ID, --本币/原币标识
       CURR_CODE, --货币类型
       OLCY_CURR_CODE, --货币类型-原币
       CRSE_NAME, --科目名称
       HLD_VOL, --持仓数量
       HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL1+HLD_VAL_YE ELSE HLD_VAL1 END,2) AS HLD_VAL, --持仓市值
       OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL1+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL1 END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       CASE WHEN RN = 1 THEN ACCR_INTR1+ACCR_INTR_YE ELSE ACCR_INTR1 END AS ACCR_INTR, --应计利息
       RECV_DIVD, --应收股利
       VALU_ADD, --估值增值,估值增值与估值不同
       INTR_ADJ, --利息调整
       IPMT_PVSN, --减值准备
       IPMT_PVSN_I, --减值准备一阶段
       IPMT_PVSN_II, --减值准备二阶段
       IPMT_PVSN_III, --减值准备三阶段
       PL_ADJ, --损益调整
       OTH_EQUI_CHG, --其他权益变动
       EXCR, --汇率
	   is_value_cnfm, --是否估值确认日
	   secu_quot_dt, --	证券行情日期
	   iss_typ, --发行方式
	   acg_proj, --	辅助核算项
       busi_date, --业务日期
       TASK_RS_ID, --任务来源标识
       DM_CREATED_TIME, --数据中台创建时间
       VALU_APRC, --估值表估值增值,无法均摊，赋值null
       IPMT_INTR, --利息减值
       AGGR_FIXA, --累计折旧
	   dm_src_info,
       P_DT,
       sys_rs_id --系统来源标识
FROM (
SELECT T1.*,
	   CAST(T1.HLD_VAL - nvl(T1.HLD_VALE,0) - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
	   CAST(T1.HLD_VAL - nvl(T1.HLD_VALE,0) - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
	   CAST(T1.ACCR_INTR - sum(T1.ACCR_INTR1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as ACCR_INTR_ye--应计利息余额
FROM (
SELECT CONCAT(C.VC_FUND_CODE , '_' , F.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       'DPSI101.DPSI.NONE' AS SECU_ID, --证券编码
       'DPSI' AS TYP_CODE, --证券类别代码（大类）
       'DPSI101' AS TYP_CODEI, --证券类别代码（中类）
       '' AS TYP_CODEII, --证券类别代码（细类）
       'NONE' AS EXCH_CODE, --交易市场代码
       '活期存款' AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       'L' AS POS_ID, --多空标识
       '1' AS LF_CURR_ID, --本币/原币标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       0 AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
	   A.PRD_CODE AS PRD_CODEA,D.EN_CURRENT_CASH,A.ACCR_INTR,A.HLD_VAL,
	   nvl(E.HLD_VAL,0) AS HLD_VALE,
       ROUND(CAST(nvl(D.EN_CURRENT_CASH,0) + (CAST((nvl(A.HLD_VAL,0) - nvl(E.HLD_VAL,0) - SUM(D.EN_CURRENT_CASH)OVER(PARTITION BY A.PRD_CODE,A.HLD_DT)) AS double) * CAST(abs(D.EN_CURRENT_CASH) AS double)) / CAST(SUM(abs(D.EN_CURRENT_CASH))OVER(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double)AS double),2) AS HLD_VAL1, --持仓市值
       0 AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CAST(nvl(D.EN_CURRENT_CASH,0) + (CAST((nvl(A.HLD_VAL,0) - nvl(E.HLD_VAL,0) - SUM(D.EN_CURRENT_CASH)OVER(PARTITION BY A.PRD_CODE,A.HLD_DT)) AS double) * CAST(abs(D.EN_CURRENT_CASH) AS double)) / CAST(SUM(abs(D.EN_CURRENT_CASH))OVER(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double)AS double),2) AS OLCY_HLD_VAL1, --持仓市值-原币
	   ROUND(CAST(A.ACCR_INTR AS double) * CAST(abs(D.EN_CURRENT_CASH) AS double) / CAST(SUM(abs(D.EN_CURRENT_CASH))OVER(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double),2)  AS ACCR_INTR1, --应计利息
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.EN_CURRENT_CASH, 100)) as rn,
       0 AS RECV_DIVD, --应收股利
       0 AS VALU_ADD, --估值增值,估值增值与估值不同
       0 AS INTR_ADJ, --利息调整
       0 AS IPMT_PVSN, --减值准备
       0 AS IPMT_PVSN_I, --减值准备一阶段
       0 AS IPMT_PVSN_II, --减值准备二阶段
       0 AS IPMT_PVSN_III, --减值准备三阶段
       0 AS PL_ADJ, --损益调整
       0 AS OTH_EQUI_CHG, --其他权益变动
       1 AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_10' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM VFIN_PRD_HLD_DATA A --产品持仓信息
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.HLD_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_CURRENT_CASH <> 0 --现金资产不为0
   AND D.L_ASSET_ID<>'-1'
  LEFT JOIN V_ZQSGK E
    ON A.PRD_CODE = E.PRD_CODE
   AND A.HLD_DT = E.HLD_DT
  LEFT JOIN ${ods_db}.O3_TASSET F --032单元信息
    ON D.L_ASSET_ID = F.L_ASSET_ID
) T1
) T2   
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
;


