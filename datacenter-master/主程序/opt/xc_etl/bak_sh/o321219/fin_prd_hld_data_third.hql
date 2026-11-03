------------------------------------------------------------------------
-- 模块名称：产品持仓信息--现金部分非活期存款
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


WITH VFIN_PRD_HLD_DATA1 AS
(SELECT T0.PRD_CODE, T0.HLD_DT,T0.TYP_CODE, SUM(T0.RECV_DIVD) AS RECV_DIVD
        FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
       INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1  --产品基本信息，获取产品
          ON T0.PRD_CODE = T1.PRD_CODE
         AND T1.PRD_TYP = '2'
	 WHERE T0.RECV_DIVD <> 0 AND T0.TYP_CODE IN ('STK', 'FUND')
       AND T0.P_DT between ${beg_date} and ${end_date}
      GROUP BY T0.PRD_CODE, T0.HLD_DT,T0.TYP_CODE
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
--现金品种--管理端
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST1+HLD_COST_YE ELSE HLD_COST1 END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL1+HLD_VAL_YE ELSE HLD_VAL1 END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST1+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST1 END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL1+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL1 END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR1+ACCR_INTR_YE ELSE ACCR_INTR1 END,2) AS ACCR_INTR, --应计利息
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
SELECT
T1.*,
CAST(T1.HLD_COST_PRD - sum(T1.HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
CAST(T1.HLD_VAL_PRD - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
CAST(T1.OLCY_HLD_COST_PRD - sum(T1.OLCY_HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
CAST(T1.OLCY_HLD_VAL_PRD - sum(T1.OLCY_HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
CAST(T1.ACCR_INTR_PRD - sum(T1.ACCR_INTR1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as ACCR_INTR_ye--应计利息余额
FROM (
SELECT C.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
	   A.PRD_CODE as PRD_CODEA,A.HLD_COST_PRD,A.HLD_VAL_PRD,A.OLCY_HLD_COST_PRD,A.OLCY_HLD_VAL_PRD,A.ACCR_INTR_PRD,
       CAST(A.HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_COST1, --持仓成本
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_VAL1, --持仓市值
       CAST(A.OLCY_HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_COST1, --持仓成本-原币
       CAST(A.OLCY_HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_VAL1, --持仓市值-原币
       CAST(A.ACCR_INTR AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS ACCR_INTR1, --应计利息
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by D.HLD_VAL) as rn,
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
       'fin_prd_hld_data_11' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM (
  SELECT T.*
  ,SUM(HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_COST_PRD
  ,SUM(HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_VAL_PRD
  ,SUM(OLCY_HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_COST_PRD
  ,SUM(OLCY_HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_VAL_PRD
  ,SUM(ACCR_INTR)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS ACCR_INTR_PRD
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON T.SECU_ID = E.SECU_ID  
  WHERE T.TYP_CODE = 'CASH' AND E.TRD_CODE IN ('DTFY','GLF','TGF','XSFWF','YYFWF','YTFY','XXPLF','YJBC','TZGWF','SJF') --范围见word说明
  AND T.SYS_RS_ID IN ('YSSFA45','yssgz25') 
  AND T.P_DT between ${beg_date} and ${end_date}
  ) A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C
    ON A.PRD_CODE = C.PRD_CODE
  LEFT JOIN (SELECT T0.PRD_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.p_dt between ${beg_date} and ${end_date}
		     AND T0.SYS_RS_ID IN ('DYCF_CASH','DYCF')
			 AND (T2.TYP_CODE IN ('STK','BOND','FUND','REPO','DPSI','EX') OR T0.SECU_ID = 'DPSI101.DPSI.NONE') --其中现金资产（活期、清算款等）统一处理成DPSI101.DPSI.NONE
			GROUP BY T0.PRD_CODE,T0.HLD_DT
			) D
    ON C.AST_UNIT_CODE = D.PRD_CODE
   AND A.P_DT = D.HLD_DT
  LEFT JOIN (SELECT T1.FOFS_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.p_dt between ${beg_date} and ${end_date}
		     AND T0.SYS_RS_ID IN ('DYCF_CASH','DYCF')
			 AND (T2.TYP_CODE IN ('STK','BOND','FUND','REPO','DPSI','EX') OR T0.SECU_ID = 'DPSI101.DPSI.NONE') --其中现金资产（活期、清算款等）统一处理成DPSI101.DPSI.NONE
			GROUP BY T1.FOFS_CODE,T0.HLD_DT
			) F
    ON A.PRD_CODE = F.FOFS_CODE
   AND A.P_DT = F.HLD_DT   
) T1
) T2

UNION ALL
--现金品种--发行端应收认申购款
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST+HLD_COST_YE ELSE HLD_COST END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL+HLD_VAL_YE ELSE HLD_VAL END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR+ACCR_INTR_YE ELSE ACCR_INTR END,2) AS ACCR_INTR, --应计利息
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
SELECT CONCAT(C.VC_FUND_CODE , '_' , F.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS HLD_COST, --持仓成本
	   CAST(A.HLD_COST - sum(CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS HLD_VAL, --持仓市值
	   CAST(A.HLD_VAL - sum(CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
       CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS OLCY_HLD_COST, --持仓成本-原币
	   CAST(A.OLCY_HLD_COST - sum(CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
       CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100 AS OLCY_HLD_VAL, --持仓市值-原币
	   CAST(A.OLCY_HLD_VAL - sum(CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
       CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100  AS ACCR_INTR, --应计利息
	   CAST(A.ACCR_INTR - sum(CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as ACCR_INTR_ye,--应计利息余额
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.EN_RATIO, 100)) as rn,
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
       'fin_prd_hld_data_12' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.HLD_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_RATIO <> 0 --申购拆分比例
   AND D.L_ASSET_ID<>'-1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO G
    ON A.SECU_ID = G.SECU_ID
 WHERE A.TYP_CODE = 'CASH' AND G.TRD_CODE IN ('MJQLX','RGK', 'YSSGK') --范围见word说明
   AND A.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND A.P_DT between ${beg_date} and ${end_date}
) T1

 UNION ALL
--现金品种--发行端应付赎回款
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST+HLD_COST_YE ELSE HLD_COST END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL+HLD_VAL_YE ELSE HLD_VAL END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR+ACCR_INTR_YE ELSE ACCR_INTR END,2) AS ACCR_INTR, --应计利息
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
SELECT CONCAT(C.VC_FUND_CODE , '_' , F.VC_ASSET_NO) AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS HLD_COST, --持仓成本
	   CAST(A.HLD_COST - sum(CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS HLD_VAL, --持仓市值
	   CAST(A.HLD_VAL - sum(CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
       CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS OLCY_HLD_COST, --持仓成本-原币
	   CAST(A.OLCY_HLD_COST - sum(CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
       CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100 AS OLCY_HLD_VAL, --持仓市值-原币
	   CAST(A.OLCY_HLD_VAL - sum(CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
       CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100  AS ACCR_INTR, --应计利息
	   CAST(A.ACCR_INTR - sum(CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_REDEEM_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as ACCR_INTR_ye,--应计利息余额
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.EN_REDEEM_RATIO, 100)) as rn,
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
       'fin_prd_hld_data_13' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.HLD_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_REDEEM_RATIO <> 0 --申购拆分比例
   AND D.L_ASSET_ID<>'-1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO G
    ON A.SECU_ID = G.SECU_ID
 WHERE A.TYP_CODE = 'CASH' AND G.TRD_CODE IN ('YFSHK','SHK') --范围见word说明
   AND A.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND A.P_DT between ${beg_date} and ${end_date}
) T1

 UNION ALL
--现金品种--发行端应付利润
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST+HLD_COST_YE ELSE HLD_COST END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL+HLD_VAL_YE ELSE HLD_VAL END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR+ACCR_INTR_YE ELSE ACCR_INTR END,2) AS ACCR_INTR, --应计利息
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
SELECT CONCAT(C.VC_FUND_CODE , '_' , NVL(E.VC_ASSET_NO, F.VC_ASSET_NO)) AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100 AS HLD_COST, --持仓成本
	   CAST(A.HLD_COST - sum(CAST(A.HLD_COST AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100 AS HLD_VAL, --持仓市值
	   CAST(A.HLD_VAL - sum(CAST(A.HLD_VAL AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
       CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100 AS OLCY_HLD_COST, --持仓成本-原币
	   CAST(A.OLCY_HLD_COST - sum(CAST(A.OLCY_HLD_COST AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
       CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100 AS OLCY_HLD_VAL, --持仓市值-原币
	   CAST(A.OLCY_HLD_VAL - sum(CAST(A.OLCY_HLD_VAL AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
       CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100  AS ACCR_INTR, --应计利息
	   CAST(A.ACCR_INTR - sum(CAST(A.ACCR_INTR AS double) * CAST(NVL(D.EN_BONUS_RATIO, 100) AS double) / 100)over(PARTITION BY A.PRD_CODE,A.HLD_DT) AS double) as ACCR_INTR_ye,--应计利息余额
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.EN_BONUS_RATIO, 100)) as rn,
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
       'fin_prd_hld_data_14' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_THISASSETDAY D  --O32资产单元日信息表
    ON A.HLD_DT = D.L_DATE
   AND C.L_FUND_ID = D.L_FUND_ID
   AND D.EN_BONUS_RATIO <> 0 --申购拆分比例
   AND D.L_ASSET_ID<>'-1'
  LEFT JOIN ${ods_db}.O3_TASSET E --032单元信息
    ON D.L_ASSET_ID = E.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TASSET F --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = F.L_ASSET_ID
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO G
    ON A.SECU_ID = G.SECU_ID
 WHERE A.TYP_CODE = 'CASH' AND G.TRD_CODE IN ('YFLR') --范围见word说明
   AND A.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND A.P_DT between ${beg_date} and ${end_date}
) T1

UNION ALL
--现金品种--投资端-交易保证金
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST1+HLD_COST_YE ELSE HLD_COST1 END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL1+HLD_VAL_YE ELSE HLD_VAL1 END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST1+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST1 END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL1+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL1 END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR1+ACCR_INTR_YE ELSE ACCR_INTR1 END,2) AS ACCR_INTR, --应计利息
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
SELECT
T1.*,
	   CAST(T1.HLD_COST_PRD - sum(T1.HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
       CAST(T1.HLD_VAL_PRD - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
	   CAST(T1.OLCY_HLD_COST_PRD - sum(T1.OLCY_HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
	   CAST(T1.OLCY_HLD_VAL_PRD - sum(T1.OLCY_HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
	   CAST(T1.ACCR_INTR_PRD - sum(T1.ACCR_INTR1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as ACCR_INTR_ye--应计利息余额
FROM (
SELECT CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN CONCAT(G.VC_FUND_CODE , '_' , H.VC_ASSET_NO) ELSE C.AST_UNIT_CODE END AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
	   A.PRD_CODE as PRD_CODEA,A.HLD_COST_PRD,A.HLD_VAL_PRD,A.OLCY_HLD_COST_PRD,A.OLCY_HLD_VAL_PRD,A.ACCR_INTR_PRD,
       CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN A.HLD_COST
	   ELSE CAST(A.HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) 
	   END AS HLD_COST1, --持仓成本
       0 AS QUOT_PRC, --行情价格
       CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN A.HLD_VAL
	   ELSE CAST(A.HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) 
	   END AS HLD_VAL1, --持仓市值
       CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN A.OLCY_HLD_COST
	   ELSE CAST(A.OLCY_HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) 
	   END AS OLCY_HLD_COST1, --持仓成本-原币
       CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN A.OLCY_HLD_VAL
	   ELSE CAST(A.OLCY_HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) 
	   END AS OLCY_HLD_VAL1, --持仓市值-原币
       CASE WHEN NVL(SUM(D.HLD_VAL)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT),0) = 0 THEN A.ACCR_INTR
	   ELSE CAST(A.ACCR_INTR AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) 
	   END AS ACCR_INTR1, --应计利息
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.HLD_VAL, 100)) as rn,
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
       'fin_prd_hld_data_15' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM (
  SELECT T.*
  ,SUM(HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_COST_PRD
  ,SUM(HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_VAL_PRD
  ,SUM(OLCY_HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_COST_PRD
  ,SUM(OLCY_HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_VAL_PRD
  ,SUM(ACCR_INTR)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS ACCR_INTR_PRD
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON T.SECU_ID = E.SECU_ID  
  WHERE T.TYP_CODE = 'CASH' AND E.TRD_CODE IN ('JYBZJ','CCBZJ') --范围见word说明
   AND T.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND T.P_DT between ${beg_date} and ${end_date}
  ) A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON A.SECU_ID = E.SECU_ID
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C
    ON A.PRD_CODE = C.PRD_CODE
  LEFT JOIN ${ods_db}.O3_TFUNDINFO G
    ON A.PRD_CODE = G.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_TASSET H
    ON G.L_DEFAULT_ASSET = H.L_ASSET_ID
  LEFT JOIN (SELECT T0.PRD_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.P_DT between ${beg_date} and ${end_date}
			 AND T2.TYP_CODE IN ('STK','BOND','FUND') AND T2.EXCH_CODE NOT IN ('SHSC','SZSC')
			 AND T0.sys_rs_id='DYCF'
			GROUP BY T0.PRD_CODE,T0.HLD_DT
		) D
    ON C.AST_UNIT_CODE = D.PRD_CODE
   AND A.P_DT = D.HLD_DT
  LEFT JOIN (SELECT T1.FOFS_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.p_dt between ${beg_date} and ${end_date}
		     AND T0.SYS_RS_ID = 'DYCF'
			 AND T2.TYP_CODE IN ('STK','BOND','FUND') AND T2.EXCH_CODE NOT IN ('SHSC','SZSC')
			GROUP BY T1.FOFS_CODE,T0.HLD_DT
			) F
    ON A.PRD_CODE = F.FOFS_CODE
   AND A.P_DT = F.HLD_DT    
) T1
) T2

UNION ALL
--现金品种-投资端-风险金
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST1+HLD_COST_YE ELSE HLD_COST1 END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL1+HLD_VAL_YE ELSE HLD_VAL1 END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST1+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST1 END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL1+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL1 END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR1+ACCR_INTR_YE ELSE ACCR_INTR1 END,2) AS ACCR_INTR, --应计利息
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
SELECT
T1.*,
CAST(T1.HLD_COST_PRD - sum(T1.HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
CAST(T1.HLD_VAL_PRD - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
CAST(T1.OLCY_HLD_COST_PRD - sum(T1.OLCY_HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
CAST(T1.OLCY_HLD_VAL_PRD - sum(T1.OLCY_HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
CAST(T1.ACCR_INTR_PRD - sum(T1.ACCR_INTR1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as ACCR_INTR_ye--应计利息余额
FROM (
SELECT C.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
	   A.PRD_CODE as PRD_CODEA,A.HLD_COST_PRD,A.HLD_VAL_PRD,A.OLCY_HLD_COST_PRD,A.OLCY_HLD_VAL_PRD,A.ACCR_INTR_PRD,
       CAST(A.HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_COST1, --持仓成本
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_VAL1, --持仓市值
       CAST(A.OLCY_HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_COST1, --持仓成本-原币
       CAST(A.OLCY_HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_VAL1, --持仓市值-原币
       CAST(A.ACCR_INTR AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS ACCR_INTR1, --应计利息
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.HLD_VAL, 100)) as rn,
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
       'fin_prd_hld_data_16' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM (
  SELECT T.*
  ,SUM(HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_COST_PRD
  ,SUM(HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_VAL_PRD
  ,SUM(OLCY_HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_COST_PRD
  ,SUM(OLCY_HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_VAL_PRD
  ,SUM(ACCR_INTR)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS ACCR_INTR_PRD
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON T.SECU_ID = E.SECU_ID  
 WHERE T.TYP_CODE = 'CASH' AND E.TRD_CODE IN ('FXJ') --范围见word说明
   AND T.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND T.P_DT between ${beg_date} and ${end_date} 
  ) A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON A.SECU_ID = E.SECU_ID
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C
    ON A.PRD_CODE = C.PRD_CODE
  LEFT JOIN (SELECT T0.PRD_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.P_DT between ${beg_date} and ${end_date}
			 AND T2.TYP_CODE IN ('STK') AND T2.EXCH_CODE IN ('SHSC','SZSC')
			 AND T0.sys_rs_id = 'DYCF'
			GROUP BY T0.PRD_CODE,T0.HLD_DT
			) D
    ON C.AST_UNIT_CODE = D.PRD_CODE
   AND A.P_DT = D.HLD_DT
  LEFT JOIN (SELECT T1.FOFS_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.p_dt between ${beg_date} and ${end_date}
			 AND T2.TYP_CODE IN ('STK') AND T2.EXCH_CODE IN ('SHSC','SZSC')
			 AND T0.sys_rs_id = 'DYCF'
			GROUP BY T1.FOFS_CODE,T0.HLD_DT
			) F
    ON A.PRD_CODE = F.FOFS_CODE
   AND A.P_DT = F.HLD_DT  
) T1
) T2

UNION ALL
--现金类--投资端-应收股利、应收红利
SELECT T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       CASE WHEN T0.TYP_CODE = 'STK' THEN 'YSGPHL.CASH.NONE' ELSE 'YSJJHL.CASH.NONE' END AS SECU_ID, --证券编码
       'CASH' AS TYP_CODE, --证券类别代码（大类）
       CASE WHEN T0.TYP_CODE = 'STK' THEN 'CASH146' ELSE 'CASH147' END AS TYP_CODEI, --证券类别代码（中类）
       NULL AS TYP_CODEII, --证券类别代码（细类）
       'NONE' AS EXCH_CODE, --交易市场代码
       CASE WHEN T0.TYP_CODE = 'STK' THEN '应收股票红利' ELSE '应收基金红利' END AS CHI_NAME, --证券中文名称
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
       T0.RECV_DIVD AS HLD_VAL, --持仓市值
       0 AS OLCY_HLD_COST, --持仓成本-原币
       T0.RECV_DIVD AS OLCY_HLD_VAL, --持仓市值-原币
       0 AS ACCR_INTR, --应计利息
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
       'fin_prd_hld_data_17' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       T0.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM VFIN_PRD_HLD_DATA1 T0 --产品持仓信息

UNION ALL
--现金品种--投资端--其他
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
       ROUND(CASE WHEN RN = 1 THEN HLD_COST1+HLD_COST_YE ELSE HLD_COST1 END,2) AS HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       ROUND(CASE WHEN RN = 1 THEN HLD_VAL1+HLD_VAL_YE ELSE HLD_VAL1 END,2) AS HLD_VAL, --持仓市值
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_COST1+OLCY_HLD_COST_YE ELSE OLCY_HLD_COST1 END,2) AS OLCY_HLD_COST, --持仓成本-原币
       ROUND(CASE WHEN RN = 1 THEN OLCY_HLD_VAL1+OLCY_HLD_VAL_YE ELSE OLCY_HLD_VAL1 END,2) AS OLCY_HLD_VAL, --持仓市值-原币
       ROUND(CASE WHEN RN = 1 THEN ACCR_INTR1+ACCR_INTR_YE ELSE ACCR_INTR1 END,2) AS ACCR_INTR, --应计利息
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
SELECT
T1.*,
CAST(T1.HLD_COST_PRD - sum(T1.HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_COST_ye,--持仓成本余额
CAST(T1.HLD_VAL_PRD - sum(T1.HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as HLD_VAL_ye,--持仓市值余额
CAST(T1.OLCY_HLD_COST_PRD - sum(T1.OLCY_HLD_COST1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_COST_ye,--持仓成本-原币余额
CAST(T1.OLCY_HLD_VAL_PRD - sum(T1.OLCY_HLD_VAL1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as OLCY_HLD_VAL_ye,--持仓市值-原币余额
CAST(T1.ACCR_INTR_PRD - sum(T1.ACCR_INTR1)over(PARTITION BY T1.PRD_CODEA,T1.HLD_DT) AS double) as ACCR_INTR_ye--应计利息余额
FROM (
SELECT C.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
	   A.PRD_CODE as PRD_CODEA,A.HLD_COST_PRD,A.HLD_VAL_PRD,A.OLCY_HLD_COST_PRD,A.OLCY_HLD_VAL_PRD,A.ACCR_INTR_PRD,
       CAST(A.HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_COST1, --持仓成本
       0 AS QUOT_PRC, --行情价格
       CAST(A.HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS HLD_VAL1, --持仓市值
       CAST(A.OLCY_HLD_COST AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_COST1, --持仓成本-原币
       CAST(A.OLCY_HLD_VAL AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS OLCY_HLD_VAL1, --持仓市值-原币
       CAST(A.ACCR_INTR AS double) * CAST(D.HLD_VAL AS double) / CAST(F.HLD_VAL AS double) AS ACCR_INTR1, --应计利息
	   ROW_NUMBER() over(partition by A.PRD_CODE,A.HLD_DT order by NVL(D.HLD_VAL, 100)) as rn,
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
       'fin_prd_hld_data_18' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识
  FROM (
  SELECT T.*
  ,SUM(HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_COST_PRD
  ,SUM(HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS HLD_VAL_PRD
  ,SUM(OLCY_HLD_COST)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_COST_PRD
  ,SUM(OLCY_HLD_VAL)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS OLCY_HLD_VAL_PRD
  ,SUM(ACCR_INTR)OVER(PARTITION BY T.PRD_CODE,T.HLD_DT) AS ACCR_INTR_PRD
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON T.SECU_ID = E.SECU_ID  
 WHERE ((T.TYP_CODE = 'CASH' AND E.TRD_CODE NOT IN ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','CCBZJ','DTFY','GLF','TGF','XSFWF','YYFWF','YTFY','XXPLF','YJBC','TZGWF','SJF','MJQLX','RGK', 'YSSGK','YFSHK','SHK','YFLR','JYBZJ','FXJ','CXXJ','QSJSBFJ')) --剩余部分
    OR T.SECU_ID IN ('RQ.SHTS.NONE')    
	)
   AND T.SECU_ID NOT IN ('QTYSK.CASH.NONE','QTYFK.CASH.NONE') --BY xiaoxiao 20230912  
   AND T.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND T.P_DT between ${beg_date} and ${end_date} 
  ) A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO E
    ON A.SECU_ID = E.SECU_ID
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C
    ON A.PRD_CODE = C.PRD_CODE
  LEFT JOIN (SELECT T0.PRD_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.P_DT between ${beg_date} and ${end_date}
			 AND T2.TYP_CODE IN ('STK','BOND','FUND','REPO','DPSI','EX') --其中现金资产（活期、清算款等）统一处理成DPSI101.DPSI.NONE
			 AND T0.sys_rs_id IN ('DYCF_CASH','DYCF')
			GROUP BY T0.PRD_CODE,T0.HLD_DT
			) D
    ON C.AST_UNIT_CODE = D.PRD_CODE
   AND A.P_DT = D.HLD_DT
  LEFT JOIN (SELECT T1.FOFS_CODE,T0.HLD_DT,SUM(HLD_VAL) AS HLD_VAL
            FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
		   INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
              ON T0.PRD_CODE = T1.PRD_CODE
             AND T1.PRD_TYP = '2'
		    LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
              ON T0.SECU_ID = T2.SECU_ID
		   WHERE T0.P_DT between ${beg_date} and ${end_date}
			 AND T2.TYP_CODE IN ('STK','BOND','FUND','REPO','DPSI','EX') --其中现金资产（活期、清算款等）统一处理成DPSI101.DPSI.NONE
			 AND T0.sys_rs_id IN ('DYCF_CASH','DYCF')
			GROUP BY T1.FOFS_CODE,T0.HLD_DT
			) F
    ON A.PRD_CODE = F.FOFS_CODE
   AND A.P_DT = F.HLD_DT    
) T1
) T2
  
UNION ALL
--现金品种--投资端--其他应收款\其他应付款
SELECT CONCAT(C.VC_FUND_CODE ,'_', D.VC_ASSET_NO) AS PRD_CODE, --产品代码 by xiaoxiao 20230912
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       A.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       A.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       A.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       A.CHI_NAME AS CHI_NAME, --证券中文名称
       A.CRSE_CODE AS CRSE_CODE, --会计科目
       A.CRSE_TYPE AS CRSE_TYPE, --科目大类
       A.CRSE_DIM AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       A.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       A.CURR_CODE AS CURR_CODE, --货币类型
       A.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
       A.CRSE_NAME AS CRSE_NAME, --科目名称        
       A.HLD_VOL AS HLD_VOL, --持仓数量
       A.HLD_COST AS HLD_COST, --持仓成本
       A.QUOT_PRC AS QUOT_PRC, --行情价格
       A.HLD_VAL AS HLD_VAL, --持仓市值
       A.OLCY_HLD_COST AS OLCY_HLD_COST, --持仓成本-原币
       A.OLCY_HLD_VAL  AS OLCY_HLD_VAL, --持仓市值-原币
       A.ACCR_INTR AS ACCR_INTR, --应计利息
       A.RECV_DIVD AS RECV_DIVD, --应收股利
       A.VALU_ADD AS VALU_ADD, --估值增值,估值增值与估值不同
       A.INTR_ADJ AS INTR_ADJ, --利息调整
       A.IPMT_PVSN AS IPMT_PVSN, --减值准备
       A.IPMT_PVSN_I AS IPMT_PVSN_I, --减值准备一阶段
       A.IPMT_PVSN_II AS IPMT_PVSN_II, --减值准备二阶段
       A.IPMT_PVSN_III AS IPMT_PVSN_III, --减值准备三阶段   
       A.PL_ADJ AS PL_ADJ, --损益调整
       A.OTH_EQUI_CHG AS OTH_EQUI_CHG, --其他权益变动
       1 AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项	   
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_21' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       A.VALU_APRC AS VALU_APRC, --估值表估值增值,无法均摊，赋值null     
       A.IPMT_INTR AS IPMT_INTR, --利息减值
       A.AGGR_FIXA AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF_CASH' AS sys_rs_id --系统来源标识	   
  FROM ${dwd_db}.FIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
   AND B.SYS_RS_ID IN ('YSSFA45','yssgz25')   
  LEFT JOIN ${ods_db}.O3_TFUNDINFO C  --O32产品信息
    ON A.PRD_CODE = C.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_TASSET D --032缺省单元,如果未找到直接找缺省单元
    ON C.L_DEFAULT_ASSET = D.L_ASSET_ID        
 WHERE A.SECU_ID IN ('QTYSK.CASH.NONE', 'QTYFK.CASH.NONE')
   AND A.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND A.P_DT between ${beg_date} and ${end_date}  
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
;

