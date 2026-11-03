------------------------------------------------------------------------
-- 模块名称：产品持仓数据--非现金部分
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

--清除指定范围分区的数据
alter table ${dwd_db}.fin_prd_hld_data drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='DYCF');

WITH VPRO_DPSI_INFO AS
(
SELECT DISTINCT T0.PRD_CODE,T0.AST_UNIT_CODE
FROM ${dwd_db}.PRO_DPSI_INFO T0
),
--L_FUND_ID = 781(如果后续有新增需要调整，目前只有一只)
V_SYHH AS
(
SELECT DISTINCT T1.VC_FUND_CODE AS PRD_CODE,CONCAT(T1.VC_FUND_CODE , '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE
FROM ${ods_db}.O3_THISUNITSTOCK T0
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.O3_TASSET T2 ON T0.L_ASSET_ID = T2.L_ASSET_ID
where t0.p_dt between ${beg_date} and ${end_date}
AND T0.L_FUND_ID IN ('781')
),
VFIN_PRD_HLD_DATA AS
(SELECT T0.PRD_CODE, T0.HLD_DT, SUM(T0.ACCR_INTR) AS ACCR_INTR, T0.EXCH_CODE
 FROM ${dwd_db}.fin_prd_hld_data T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1  --产品基本信息，获取产品
         ON T0.PRD_CODE = T1.PRD_CODE
        AND T1.PRD_TYP = '1'
	  WHERE T0.ACCR_INTR <> 0
	    AND T0.TYP_CODE = 'STK'
	    AND T0.POS_ID = 'L' --获取转融券利息不为0
	    AND T0.p_dt between ${beg_date} and ${end_date}
	    AND T0.sys_rs_id IN ('YSSFA45','yssgz25')
 GROUP BY T0.PRD_CODE, T0.HLD_DT, T0.EXCH_CODE
),
VFIN_PRD_HLD_DATA1 AS
(SELECT T0.PRD_CODE, T0.HLD_DT, SUM(T0.HLD_VAL) AS HLD_VAL,SUM(T0.ACCR_INTR) AS ACCR_INTR
        FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
       INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2  --产品基本信息，获取产品
          ON T0.PRD_CODE = T2.PRD_CODE
         AND T2.PRD_TYP = '1'
		LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
		  ON T0.SECU_ID = T1.SECU_ID
	   WHERE ((T0.TYP_CODE = 'CASH' AND T1.TRD_CODE IN ('QSBFJ','JSBFJ','ZQQSK','QHBFJ','ZDBFJ','QHBZJ','QSJSBFJ'))----范围见word说明
	      OR (T0.TYP_CODE = 'DPSI' AND T1.TRD_CODE = 'DPSI101')
		   )
		 AND T0.EXCH_CODE NOT IN ('CFFEX','SHFE','CZCE','DCE')
         AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25')
         AND T0.P_DT between ${beg_date} and ${end_date}
       GROUP BY T0.PRD_CODE, T0.HLD_DT
),
V_ZQSGK AS
(--配股认购证券申购款，缴款（加申购款）,除权（冲申购款）
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T4.L_DATE AS HLD_DT, --持仓日期
       CASE WHEN T0.EXCH_CODE = 'SH' THEN 'ZQSGK.CASH.SH'
		    WHEN T0.EXCH_CODE = 'SZ' THEN 'ZQSGK.CASH.SZ'
		    WHEN T0.EXCH_CODE = 'NONE' THEN 'ZQSGK.CASH.NONE'
	   END AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.OCCU_VAL AS HLD_VAL --持仓市值
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN ${dwd_db}.EVT_EXCH_TNV_HIS T0
    ON 1=1
 WHERE T4.L_DATE >= T0.OCCU_DT
   AND T4.L_DATE < T0.DELI_DT
   AND T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'
   AND T0.BUSI_CLAS = '06000108' --配股缴款
   AND T0.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
   AND T4.L_DATE between ${beg_date} and ${end_date}
UNION ALL
--网上新股、新债证券申购款，缴款（加申购款），缴款交收（冲申购款）
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T4.L_DATE AS HLD_DT, --持仓日期
       CASE WHEN T0.EXCH_CODE = 'SH' THEN 'ZQSGK.CASH.SH'
		    WHEN T0.EXCH_CODE = 'SZ' THEN 'ZQSGK.CASH.SZ'
		    WHEN T0.EXCH_CODE = 'NONE' THEN 'ZQSGK.CASH.NONE'
	   END AS SECU_ID, --证券编码
	   T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.OCCU_VAL AS HLD_VAL --持仓市值
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN ${dwd_db}.EVT_EXCH_TNV_HIS T0
    ON 1=1
 WHERE T4.L_DATE >= T0.OCCU_DT
   AND T4.L_DATE < T0.DELI_DT
   AND T4.VC_TRADEDAY_TYPE = '00'
   AND T4.C_TRADE_FLAG = '1'   
   AND T0.BUSI_CLAS = '05000103' --网上新股缴款
   AND T0.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
   AND T4.L_DATE between ${beg_date} and ${end_date}
UNION ALL
--网下新债、新股（注册制定金）、战略配售、增发、定增申购款：执行确认定金（加申购款），中签（冲申购款）
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T4.L_DATE AS HLD_DT, --持仓日期
       CASE WHEN T0.EXCH_CODE = 'SH' THEN 'ZQSGK.CASH.SH'
		    WHEN T0.EXCH_CODE = 'SZ' THEN 'ZQSGK.CASH.SZ'
		    WHEN T0.EXCH_CODE = 'NONE' THEN 'ZQSGK.CASH.NONE'
	   END AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.MARG AS HLD_VAL --持仓市值
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN (
   SELECT A.*,NVL(B.OCCU_DT, CASE WHEN B.BUSI_CLAS = '05010102' then t.aft_1_dt
								  WHEN B.BUSI_CLAS = '05030102' then t.aft_2_dt
								  WHEN B.BUSI_CLAS = '05050102' then t.aft_2_dt
								  WHEN B.BUSI_CLAS = '05060102' then t.aft_3_dt
							 END
				) AS ZQ_DT
   FROM ${dwd_db}.EVT_OFLE_EXCF_HIS A
   LEFT JOIN ${dwd_db}.EVT_OFLE_TNV_HIS B
     ON A.EXCF_ONUM = B.EXCF_ONUM
	AND A.PFL_CODE = B.PFL_CODE
    AND B.BUSI_CLAS IN ('05010102', '05030102', '05050102', '05060102')  --网下新股申购中签,网下定增申购中签,网下增发申购中签,网下战略配售申购中签
    AND B.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
   LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T
     ON B.p_dt = t.dt
	and t.mkt_no = '1'
  WHERE A.BUSI_CLAS IN ('05010101', '05030101', '05050101', '05060101') --网下新股申购执行确认,网下定增申购执行确认,网下增发申购执行确认,网下战略配售申购执行确认
    AND A.IS_MARG_MDL = '1' --定金模式
    AND A.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
	) T0
	 ON 1=1
  WHERE T4.L_DATE >= T0.OCCU_DT
    AND T4.L_DATE < T0.ZQ_DT
    AND T4.VC_TRADEDAY_TYPE = '00'
    AND T4.C_TRADE_FLAG = '1'
	AND T4.L_DATE between ${beg_date} and ${end_date}
UNION ALL
--开基申购、认购申购款：执行确认（加申购款），成交确认（冲申购款）
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T4.L_DATE AS HLD_DT, --持仓日期
       CASE WHEN T0.EXCH_CODE = 'SH' THEN 'ZQSGK.CASH.SH' WHEN T0.EXCH_CODE = 'SZ' THEN 'ZQSGK.CASH.SZ' WHEN T0.EXCH_CODE = 'NONE' THEN 'ZQSGK.CASH.NONE' END AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.ENTR_VAL AS HLD_VAL --持仓市值
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN (SELECT A.*,NVL(B.OCCU_DT, CASE WHEN B.BUSI_CLAS = '09000303' then t.aft_1_dt
								  WHEN B.BUSI_CLAS = '09000301' then t.aft_2_dt
							 END) AS ZQ_DT
   FROM ${dwd_db}.EVT_OTC_EXCF_HIS A
   LEFT JOIN ${dwd_db}.EVT_OTC_TNV_HIS B
     ON A.EXCF_ONUM = B.EXCF_ONUM
	AND A.PFL_CODE = B.PFL_CODE
    AND B.BUSI_CLAS IN ('09000301', '09000303')  --场外开基认购成交确认,场外开基申购成交确认
    AND B.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
   LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T
     ON B.p_dt = t.dt
	and t.mkt_no = '1'
  WHERE A.BUSI_CLAS IN ('09000300', '09000302') --场外开基认购执行确认,场外开基申购执行确认
    AND A.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND ${end_date}
	) T0
	 ON 1=1
  WHERE T4.L_DATE >= T0.OCCU_DT
    AND T4.L_DATE < T0.ZQ_DT
	AND T0.TNV_STAT <> '4'
    AND T4.VC_TRADEDAY_TYPE = '00'
    AND T4.C_TRADE_FLAG = '1'	
	AND T4.L_DATE between ${beg_date} and ${end_date}
	
UNION ALL
	--开基赎回申购款：成交确认（加应收赎回款），交收（减应收赎回款，加活期存款）
SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
       T4.L_DATE AS HLD_DT, --持仓日期
       case when T0.EXCH_CODE = 'SH' then 'ZQSGK.CASH.SH'
            when T0.EXCH_CODE = 'SZ' then 'ZQSGK.CASH.SZ'
            when T0.EXCH_CODE = 'NONE' then 'ZQSGK.CASH.NONE'
       end AS SECU_ID, --证券编码
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       NVL(T0.TNV_VAL,0)-NVL(T0.PR_FEE,0) AS HLD_VAL --持仓市值
  FROM ${ods_db}.O3_TMARKETTRADEDAY T4
 INNER JOIN ${dwd_db}.EVT_OTC_TNV_HIS T0
       ON 1=1
  WHERE T0.BUSI_CLAS IN ('09000305') --场外开基赎回成交确认
    AND T4.VC_TRADEDAY_TYPE = '00'
    AND T4.C_TRADE_FLAG = '1'
    AND T4.L_DATE >= T0.OCCU_DT
    AND T4.L_DATE < T0.DELI_DT  --如果日期有问题，需要调整L0逻辑 
    AND T0.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd') AND date_format(date_add(from_unixtime(unix_timestamp(cast(${end_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),30),'yyyyMMdd')
	AND T4.l_date BETWEEN ${beg_date} and ${end_date}
)

insert into ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
(prd_code,hld_dt,prd_typ,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_typ,cir_id,ast_stat,pos_id,curr_code,olcy_curr_code,crse_name,hld_vol,hld_cost,quot_prc,hld_val,olcy_hld_cost,olcy_hld_val,accr_intr,recv_divd,valu_add,intr_adj,ipmt_pvsn,ipmt_pvsn_i,ipmt_pvsn_ii,ipmt_pvsn_iii,pl_adj,oth_equi_chg,excr,is_value_cnfm,secu_quot_dt,iss_typ,acg_proj,busi_date,task_rs_id,dm_created_time,valu_aprc,ipmt_intr,aggr_fixa,dm_src_info,p_dt,sys_rs_id)
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
--股票品种--普通
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_1' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    REPLACE(T0.SECU_ID,'.BJ','.SB') AS SECU_ID, --证券编码
                    T2.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T2.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T2.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    CASE WHEN T0.SECU_ID LIKE '%BJ' THEN 'SB' ELSE T2.EXCH_CODE END AS EXCH_CODE, --交易市场代码
                    T2.CHI_NAME AS CHI_NAME, --证券中文名称
                    T2.CRSE_CODE AS CRSE_CODE, --会计科目
                    T2.CRSE_TYPE AS CRSE_TYPE, --科目大类
                    T2.CRSE_DIM AS CRSE_DIM, --科目属性
                    T2.INV_TYP AS INV_TYP, --投资类型
                    T2.CIR_ID AS CIR_ID, --流通标识
                    T2.AST_STAT AS AST_STAT, --资产状态
                    T2.POS_ID AS POS_ID, --多空标识
                    T2.CURR_CODE AS CURR_CODE, --货币类型
                    T2.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
                    T2.CRSE_NAME AS CRSE_NAME, --科目名称
                    CASE WHEN T0.POS_ID = 'L' THEN T0.CURR_VOL ELSE -T0.CURR_VOL END AS HLD_VOL, --持仓数量
                    CASE WHEN T0.POS_ID = 'L' THEN nvl( T0.CURR_COST ,0) ELSE -nvl( T0.CURR_COST ,0) END AS HLD_COST, --持仓成本
                    T2.QUOT_PRC AS QUOT_PRC, --行情价格
                    CASE WHEN T0.POS_ID = 'L' THEN CAST(T0.CURR_VOL AS double) * (CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) ELSE - CAST(T0.CURR_VOL AS double) * (CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) END  AS HLD_VAL, --持仓市值
                    CASE WHEN T0.POS_ID = 'L' THEN nvl( T0.CURR_COST ,0) ELSE -nvl( T0.CURR_COST ,0) END AS OLCY_HLD_COST, --持仓成本-原币
                    CASE WHEN T0.POS_ID = 'L' THEN CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) ELSE -CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) END AS OLCY_HLD_VAL, --持仓市值-原币
                    CASE WHEN T0.POS_ID = 'S' THEN CAST(T0.CURR_VOL AS double) * (CAST(T2.ACCR_INTR AS double) / CAST(T2.HLD_VOL AS double)) ELSE 0 END AS ACCR_INTR, --应计利息
                    CASE WHEN T0.POS_ID = 'L' THEN CAST(T0.CURR_VOL AS double) * (CAST(T2.RECV_DIVD AS double) / CAST(T2.HLD_VOL AS double)) ELSE -CAST(T0.CURR_VOL AS double) * (CAST(T2.RECV_DIVD AS double) / CAST(T2.HLD_VOL AS double)) END AS RECV_DIVD, --应收股利
                    CASE WHEN T0.POS_ID = 'L' THEN CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) - nvl( T0.CURR_COST ,0) ELSE -CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) + nvl( T0.CURR_COST ,0) END AS VALU_ADD, --估值增值,估值增值与估值不同
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.INTR_ADJ AS double) / CAST(T2.HLD_VOL AS double)) AS INTR_ADJ, --利息调整
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN, --减值准备
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_I AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_I, --减值准备一阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_II AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_II, --减值准备二阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_III AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_III, --减值准备三阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.PL_ADJ AS double) / CAST(T2.HLD_VOL AS double)) AS PL_ADJ, --损益调整
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.OTH_EQUI_CHG AS double) / CAST(T2.HLD_VOL AS double)) AS OTH_EQUI_CHG, --其他权益变动
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_INTR AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_INTR, --利息减值
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.AGGR_FIXA AS double) / CAST(T2.HLD_VOL AS double)) AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    T2.EXCR AS EXCR --汇率
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
               LEFT JOIN ${dwd_db}.fin_prd_hld_data T2
                 ON T0.PRD_CODE = T2.PRD_CODE
                AND T0.P_DT = T2.P_DT
                AND REPLACE(T0.SECU_ID,'BJ','SB') = T2.SECU_ID
				AND T0.POS_ID = T2.POS_ID
				AND T2.AST_STAT IN ('L1', 'L5', 'L11') --普通、网上新股、网下新股
				AND T2.P_DT between ${beg_date} and ${end_date}
				AND T2.sys_rs_id IN ('YSSFA45','yssgz25')
			    AND T2.iss_typ NOT IN ('WSS_WS_PG','WSS_WX_ZF','WSS_WX_FGK','WSS_WX_ZLPS','WSS_WS_DZSX','WSS_WX_ZLPSXS','WSS_WX_FGKXS','WSS_WX_LG1Y','WSS_WX_LG3Y','WSS_WX_KCBXGSD','WSS_WX_XGXS','WSS_WS_XJZR','WSS_WX_LG')
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
              WHERE T0.SECU_ID LIKE '%STK%' AND T0.HLD_FLAG IN ('1', '9', '10')
                AND T0.CURR_VOL <> 0 --剔除当日有买卖，但是持仓为0部分
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--股票品种--补充股票红利
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_hl' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    T0.SECU_ID AS SECU_ID, --证券编码
                    T2.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T2.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T2.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    T2.EXCH_CODE AS EXCH_CODE, --交易市场代码
                    T2.CHI_NAME AS CHI_NAME, --证券中文名称
                    T2.CRSE_CODE AS CRSE_CODE, --会计科目
                    T2.CRSE_TYPE AS CRSE_TYPE, --科目大类
                    T2.CRSE_DIM AS CRSE_DIM, --科目属性
                    T2.INV_TYP AS INV_TYP, --投资类型
                    T2.CIR_ID AS CIR_ID, --流通标识
                    T2.AST_STAT AS AST_STAT, --资产状态
                    T2.POS_ID AS POS_ID, --多空标识
                    T2.CURR_CODE AS CURR_CODE, --货币类型
                    T2.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
                    T2.CRSE_NAME AS CRSE_NAME, --科目名称
                    0 AS HLD_VOL, --持仓数量
                    0 AS HLD_COST, --持仓成本
                    0 AS QUOT_PRC, --行情价格
                    0 AS HLD_VAL, --持仓市值
                    0 AS OLCY_HLD_COST, --持仓成本-原币
                    0 AS OLCY_HLD_VAL, --持仓市值-原币
                    0 AS ACCR_INTR, --应计利息
                    CASE WHEN T0.POS_ID = 'L' THEN CAST(T0.CURR_DIVD AS double) * CAST(T2.RECV_DIVD AS double) / CAST(sum(t0.CURR_DIVD)over(partition by t2.prd_code,t2.hld_dt,t2.secu_id) AS DOUBLE) 
					ELSE -CAST(T0.CURR_DIVD AS double) * CAST(T2.RECV_DIVD AS double) / CAST(sum(t0.CURR_DIVD)over(partition by t2.prd_code,t2.hld_dt,t2.secu_id) AS DOUBLE) END AS RECV_DIVD, --应收股利
                    0 AS VALU_ADD, --估值增值,估值增值与估值不同
                    0 AS INTR_ADJ, --利息调整
                    0 AS IPMT_PVSN, --减值准备
                    0 AS IPMT_PVSN_I, --减值准备一阶段
                    0 AS IPMT_PVSN_II, --减值准备二阶段
                    0 AS IPMT_PVSN_III, --减值准备三阶段
                    0 AS PL_ADJ, --损益调整
                    0 AS OTH_EQUI_CHG, --其他权益变动
                    0 AS IPMT_INTR, --利息减值
                    0 AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    T2.EXCR AS EXCR --汇率
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
               INNER JOIN ${dwd_db}.fin_prd_hld_data T2
                 ON T0.PRD_CODE = T2.PRD_CODE
                AND T0.P_DT = T2.P_DT
                AND T0.SECU_ID = T2.SECU_ID
				AND T0.POS_ID = T2.POS_ID
				AND T2.AST_STAT IN ('L1', 'L5', 'L11') --普通、网上新股、网下新股
				AND T2.P_DT between ${beg_date} and ${end_date}
				AND T2.sys_rs_id IN ('YSSFA45','yssgz25')
			    AND T2.iss_typ NOT IN ('WSS_WS_PG','WSS_WX_ZF','WSS_WX_FGK','WSS_WX_ZLPS','WSS_WS_DZSX','WSS_WX_ZLPSXS','WSS_WX_FGKXS','WSS_WX_LG1Y','WSS_WX_LG3Y','WSS_WX_KCBXGSD','WSS_WX_XGXS','WSS_WS_XJZR','WSS_WX_LG')
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
              WHERE T0.SECU_ID LIKE '%STK%' AND T0.HLD_FLAG IN ('1', '9', '10')
                AND T0.CURR_VOL = 0
                AND T2.HLD_VOL = 0
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--股票品种--限售
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_2' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    T0.SECU_ID AS SECU_ID, --证券编码
                    T2.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T2.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T2.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    T2.EXCH_CODE AS EXCH_CODE, --交易市场代码
                    T2.CHI_NAME AS CHI_NAME, --证券中文名称
                    'XC' AS CRSE_CODE, --会计科目
                    CASE WHEN T0.POS_ID = 'L' THEN '1' ELSE '2' END AS CRSE_TYPE, --科目大类
                    'XC' AS CRSE_DIM, --科目属性
                    T0.IVSM_TYPE AS INV_TYP, --投资类型
                    '0' AS CIR_ID, --流通标识
                    CASE WHEN T0.HLD_FLAG = '2' THEN 'L4'  --网下新股限售
                         WHEN T0.HLD_FLAG = '3' THEN 'L2' --定增限售
                         WHEN T0.HLD_FLAG = '4' THEN 'L14' --大宗买入限售
                         WHEN T0.HLD_FLAG = '5' THEN 'L13' --战略配售限售
                         WHEN T0.HLD_FLAG = '11' THEN 'L13' --战略配售限售证券融出
					END AS AST_STAT, --资产状态
                    T0.POS_ID AS POS_ID, --多空标识
                    'CNY' AS CURR_CODE, --货币类型
                    'CNY' AS OLCY_CURR_CODE, --货币类型-原币
                    'XC' AS CRSE_NAME, --科目名称
                    T0.CURR_VOL AS HLD_VOL, --持仓数量
                    nvl( T0.CURR_COST ,0) AS HLD_COST, --持仓成本
                    CAST(T0.CURR_VAL AS double) / CAST(T0.CURR_VOL AS double) AS QUOT_PRC, --行情价格
                    T0.CURR_VAL AS HLD_VAL, --持仓市值
                    nvl( T0.CURR_COST ,0) AS OLCY_HLD_COST, --持仓成本-原币
                    T0.CURR_VAL AS OLCY_HLD_VAL, --持仓市值-原币
                    0 AS ACCR_INTR, --应计利息
                    0 AS RECV_DIVD, --应收股利
                    nvl(T0.CURR_VAL,0) - nvl( T0.CURR_COST ,0) AS VALU_ADD, --估值增值,估值增值与估值不同
                    0 AS INTR_ADJ, --利息调整
                    0 AS IPMT_PVSN, --减值准备
                    0 AS IPMT_PVSN_I, --减值准备一阶段
                    0 AS IPMT_PVSN_II, --减值准备二阶段
                    0 AS IPMT_PVSN_III, --减值准备三阶段
                    0 AS PL_ADJ, --损益调整
                    0 AS OTH_EQUI_CHG, --其他权益变动
                    0 AS IPMT_INTR, --利息减值
                    0 AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    1 AS EXCR --汇率
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
			   LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
			     ON T0.SECU_ID = T2.SECU_ID
              WHERE T0.SECU_ID LIKE '%STK%' AND T0.HLD_FLAG IN ('2', '3', '4', '5', '11')
                AND T0.CURR_VOL <> 0 --剔除当日有买卖，但是持仓为0部分
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--债券品种
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
					T0.PRD_CODE AS PRD_CODET0,T0.PFL_CODE,T0.SH_CODE,
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    T0.SECU_ID AS SECU_ID, --证券编码
                    T2.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T2.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T2.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    T2.EXCH_CODE AS EXCH_CODE, --交易市场代码
                    T2.CHI_NAME AS CHI_NAME, --证券中文名称
                    T2.CRSE_CODE AS CRSE_CODE, --会计科目
                    T2.CRSE_TYPE AS CRSE_TYPE, --科目大类
                    T2.CRSE_DIM AS CRSE_DIM, --科目属性
                    T2.INV_TYP AS INV_TYP, --投资类型
                    T2.CIR_ID AS CIR_ID, --流通标识
                    'L1' AS AST_STAT, --资产状态
                    T2.POS_ID AS POS_ID, --多空标识
                    T2.CURR_CODE AS CURR_CODE, --货币类型
                    T2.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
                    T2.CRSE_NAME AS CRSE_NAME, --科目名称
                    T0.CURR_VOL AS HLD_VOL, --持仓数量
                    nvl( T0.CURR_COST ,0) AS HLD_COST, --持仓成本
                    T2.QUOT_PRC AS QUOT_PRC, --行情价格
                    CASE WHEN T2.HLD_VOL = 0 AND T2.HLD_VAL <> 0 THEN CAST(T2.HLD_VAL AS double) * CAST(T0.CURR_SELL_VOL AS double) / CAST(SUM(T0.CURR_SELL_VOL) OVER (PARTITION BY T2.PRD_CODE,T2.HLD_DT,T2.SECU_ID) AS double)
					WHEN T2.HLD_VOL = 0 THEN 0
					ELSE CAST(T0.CURR_VOL AS double) * (CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double))
					END AS HLD_VAL, --持仓市值
                    nvl( T0.CURR_COST ,0) AS OLCY_HLD_COST, --持仓成本-原币
                    CASE WHEN T2.HLD_VOL = 0 AND T2.HLD_VAL <> 0 THEN CAST(T2.OLCY_HLD_VAL AS double) * CAST(T0.CURR_SELL_VOL AS double) / CAST(SUM(T0.CURR_SELL_VOL) OVER (PARTITION BY T2.PRD_CODE,T2.HLD_DT,T2.SECU_ID) AS double)
					WHEN T2.HLD_VOL = 0 THEN 0
					ELSE CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double))
					END AS OLCY_HLD_VAL, --持仓市值-原币
                    CASE WHEN T2.HLD_VOL = 0 AND T2.ACCR_INTR <> 0 THEN CAST(T2.ACCR_INTR AS double) * CAST(T0.CURR_SELL_VOL AS double) / CAST(SUM(T0.CURR_SELL_VOL) OVER (PARTITION BY T2.PRD_CODE,T2.HLD_DT,T2.SECU_ID) AS double)
					WHEN T2.HLD_VOL = 0 THEN 0
					ELSE CAST(T0.CURR_VOL AS double) * (CAST(T2.ACCR_INTR AS double) / CAST(T2.HLD_VOL AS double))
					END AS ACCR_INTR, --应计利息
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.RECV_DIVD AS double) / CAST(T2.HLD_VOL AS double)) AS RECV_DIVD, --应收股利
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) - nvl( T0.CURR_COST ,0) AS VALU_ADD, --估值增值,估值增值与估值不同
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.INTR_ADJ AS double) / CAST(T2.HLD_VOL AS double)) AS INTR_ADJ, --利息调整
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN, --减值准备
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_I AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_I, --减值准备一阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_II AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_II, --减值准备二阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_PVSN_III AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_PVSN_III, --减值准备三阶段
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.PL_ADJ AS double) / CAST(T2.HLD_VOL AS double)) AS PL_ADJ, --损益调整
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.OTH_EQUI_CHG AS double) / CAST(T2.HLD_VOL AS double)) AS OTH_EQUI_CHG, --其他权益变动
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.IPMT_INTR AS double) / CAST(T2.HLD_VOL AS double)) AS IPMT_INTR, --利息减值
                    CAST(T0.CURR_VOL AS double) * (CAST(T2.AGGR_FIXA AS double) / CAST(T2.HLD_VOL AS double)) AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    T2.EXCR AS EXCR --汇率 
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
               LEFT JOIN ${dwd_db}.fin_prd_hld_data T2 --不考虑保险公司对于同一只债券即摊余成本估值又市值法估值（O32的投资类型可能维护不准）
                 ON T0.PRD_CODE = T2.PRD_CODE
                AND T0.P_DT = T2.P_DT
                AND T0.SECU_ID = T2.SECU_ID
				AND T2.P_DT between ${beg_date} and ${end_date}
				AND T2.sys_rs_id IN ('YSSFA45','yssgz25')
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
              WHERE T0.SECU_ID LIKE '%BOND%'
                AND (T0.CURR_VOL <> 0 OR (T2.HLD_VOL = 0 AND T2.HLD_VAL <> 0) OR (T2.HLD_VOL = 0 AND T2.ACCR_INTR <> 0))--剔除当日有买卖，但是持仓为0部分
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
			 	LEFT JOIN ${dwd_db}.EVT_EXCH_TNV_HIS T4
			     ON A.PRD_CODET0 = T4.PRD_CODE
			    AND A.PFL_CODE = T4.PFL_CODE
				AND A.SH_CODE = T4.SH_CODE
				AND A.SECU_ID = T4.SECU_ID
				AND T4.BUSI_CLAS IN ('06000101')
				AND A.HLD_DT = T4.P_DT
				AND T4.SECU_ID LIKE '%SH%'
				AND T4.P_DT between ${beg_date} and ${end_date}
				WHERE NVL(T4.TNV_ONUM,'0') = '0'
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--基金品种
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    T0.SECU_ID AS SECU_ID, --证券编码
                    T2.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T2.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T2.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    T2.EXCH_CODE AS EXCH_CODE, --交易市场代码
                    T2.CHI_NAME AS CHI_NAME, --证券中文名称
                    T2.CRSE_CODE AS CRSE_CODE, --会计科目
                    T2.CRSE_TYPE AS CRSE_TYPE, --科目大类
                    T2.CRSE_DIM AS CRSE_DIM, --科目属性
                    T2.INV_TYP AS INV_TYP, --投资类型
                    T2.CIR_ID AS CIR_ID, --流通标识
                    T2.AST_STAT AS AST_STAT, --资产状态
                    T2.POS_ID AS POS_ID, --多空标识
                    T2.CURR_CODE AS CURR_CODE, --货币类型
                    T2.OLCY_CURR_CODE AS OLCY_CURR_CODE, --货币类型-原币
                    T2.CRSE_NAME AS CRSE_NAME, --科目名称
                    T0.CURR_VOL AS HLD_VOL, --持仓数量
                    nvl( T0.CURR_COST ,0) AS HLD_COST, --持仓成本
                    T2.QUOT_PRC AS QUOT_PRC, --行情价格
                    CAST(T0.CURR_VOL as double) * (CAST(T2.HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) AS HLD_VAL, --持仓市值
                    nvl( T0.CURR_COST ,0) AS OLCY_HLD_COST, --持仓成本-原币
                    CAST(T0.CURR_VOL as double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) AS OLCY_HLD_VAL, --持仓市值-原币
                    CAST(T0.CURR_VOL as double) * (CAST(T2.ACCR_INTR AS double) / CAST(T2.HLD_VOL AS double)) AS ACCR_INTR, --应计利息
                    CAST(T0.CURR_VOL as double) * (CAST(T2.RECV_DIVD AS double) / CAST(T2.HLD_VOL AS double)) AS RECV_DIVD, --应收股利
                    CAST(T0.CURR_VOL as double) * (CAST(T2.OLCY_HLD_VAL AS double) / CAST(T2.HLD_VOL AS double)) - nvl( T0.CURR_COST ,0) AS VALU_ADD, --估值增值,估值增值与估值不同
                    0 AS INTR_ADJ, --利息调整
                    0 AS IPMT_PVSN, --减值准备
                    0 AS IPMT_PVSN_I, --减值准备一阶段
                    0 AS IPMT_PVSN_II, --减值准备二阶段
                    0 AS IPMT_PVSN_III, --减值准备三阶段
                    0 AS PL_ADJ, --损益调整
                    0 AS OTH_EQUI_CHG, --其他权益变动
                    0 AS IPMT_INTR, --利息减值
                    0 AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    T2.EXCR AS EXCR --汇率
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
               LEFT JOIN ${dwd_db}.fin_prd_hld_data T2
                 ON T0.PRD_CODE = T2.PRD_CODE
                AND T0.P_DT = T2.P_DT
                AND T0.SECU_ID = T2.SECU_ID
				AND T2.P_DT between ${beg_date} and ${end_date}
				AND T2.sys_rs_id IN ('YSSFA45','yssgz25')
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
              WHERE T0.SECU_ID LIKE '%FUND%'
                AND ROUND(T0.CURR_VOL,2) <> 0 --剔除当日有买卖，但是持仓为0部分
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--期货品种
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       A.PRD_TYP AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       MAX(A.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(A.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(A.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(A.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(A.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(A.CRSE_CODE) AS CRSE_CODE, --会计科目
       MAX(A.CRSE_TYPE) AS CRSE_TYPE, --科目大类
       MAX(A.CRSE_DIM) AS CRSE_DIM, --科目属性
       A.INV_TYP AS INV_TYP, --投资类型
       A.CIR_ID AS CIR_ID, --流通标识
       A.AST_STAT AS AST_STAT, --资产状态
       A.POS_ID AS POS_ID, --多空标识
       MAX(A.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(A.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(A.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       AVG(A.QUOT_PRC) AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
       SUM(round(A.RECV_DIVD,2)) AS RECV_DIVD, --应收股利
       SUM(round(A.VALU_ADD,2)) AS VALU_ADD, --估值增值,估值增值与估值不同
       SUM(round(A.INTR_ADJ,2)) AS INTR_ADJ, --利息调整
       SUM(round(A.IPMT_PVSN,2)) AS IPMT_PVSN, --减值准备
       SUM(round(A.IPMT_PVSN_I,2)) AS IPMT_PVSN_I, --减值准备一阶段
       SUM(round(A.IPMT_PVSN_II,2)) AS IPMT_PVSN_II, --减值准备二阶段
       SUM(round(A.IPMT_PVSN_III,2)) AS IPMT_PVSN_III, --减值准备三阶段
       SUM(round(A.PL_ADJ,2)) AS PL_ADJ, --损益调整
       SUM(round(A.OTH_EQUI_CHG,2)) AS OTH_EQUI_CHG, --其他权益变动
       MAX(A.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_5' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       SUM(round(A.IPMT_INTR,2)) AS IPMT_INTR, --利息减值
       SUM(round(A.AGGR_FIXA,2)) AS AGGR_FIXA, --累计折旧
	   'AST_UNIT_SECU_BAL_HIS' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
       FROM (SELECT T0.AST_UNIT_CODE AS PRD_CODE, --产品代码
                    T0.HLD_DT AS HLD_DT, --持仓日期
                    '2' AS PRD_TYP, --组合类型
                    T0.SECU_ID AS SECU_ID, --证券编码
                    T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
                    T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
                    T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
                    T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
                    T1.CHI_NAME AS CHI_NAME, --证券中文名称
                    'XC' AS CRSE_CODE, --会计科目
                    '3' AS CRSE_TYPE, --科目大类
                    'XC' AS CRSE_DIM, --科目属性
                    T0.IVSM_TYPE AS INV_TYP, --投资类型
                    '1' AS CIR_ID, --流通标识
                    'L1' AS AST_STAT, --资产状态
                    T0.POS_ID AS POS_ID, --多空标识
                    'CNY' AS CURR_CODE, --货币类型
                    'CNY' AS OLCY_CURR_CODE, --货币类型-原币
                    'XC' AS CRSE_NAME, --科目名称
                    CASE WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN T0.CURR_VOL
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN -T0.CURR_VOL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN -T0.CURR_VOL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN T0.CURR_VOL
					END AS HLD_VOL, --持仓数量
                    CASE WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0)
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN -nvl( T0.CURR_COST ,0)
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN -nvl( T0.CURR_COST ,0)
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0)
					END AS HLD_COST, --持仓成本
					CASE WHEN T0.SECU_ID LIKE 'ZQQSK%' THEN 0 ELSE T0.QUOT_PRC END AS QUOT_PRC, --行情价格,暂定
                    CASE WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN T0.CURR_VAL
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN -T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN -T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN T0.CURR_VAL
					END AS HLD_VAL, --持仓市值
                    CASE WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0)
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN -nvl( T0.CURR_COST ,0)
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN -nvl( T0.CURR_COST ,0)
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0)
					END AS OLCY_HLD_COST, --持仓成本-原币
                    CASE WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN T0.CURR_VAL
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN -T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN -T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN T0.CURR_VAL
					END AS OLCY_HLD_VAL, --持仓市值-原币
                    0 AS ACCR_INTR, --应计利息
                    0 AS RECV_DIVD, --应收股利
					CASE WHEN T0.SECU_ID LIKE 'ZQQSK%' THEN 0
					     WHEN T0.POS_ID = 'L' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN T0.CURR_VAL - nvl( T0.CURR_COST ,0)
						 WHEN T0.POS_ID = 'L' AND T0.SECU_ID LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0) - T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID NOT LIKE '%CXXJ%' THEN nvl( T0.CURR_COST ,0) - T0.CURR_VAL
						 WHEN T0.POS_ID = 'S' AND T0.SECU_ID LIKE '%CXXJ%' THEN T0.CURR_VAL - nvl( T0.CURR_COST ,0)
				    END AS VALU_ADD, --估值增值
                    0 AS INTR_ADJ, --利息调整
                    0 AS IPMT_PVSN, --减值准备
                    0 AS IPMT_PVSN_I, --减值准备一阶段
                    0 AS IPMT_PVSN_II, --减值准备二阶段
                    0 AS IPMT_PVSN_III, --减值准备三阶段
                    0 AS PL_ADJ, --损益调整
                    0 AS OTH_EQUI_CHG, --其他权益变动
                    0 AS IPMT_INTR, --利息减值
                    0 AS AGGR_FIXA, --累计折旧
                    NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
                    1 AS EXCR --汇率
               FROM ${dwd_db}.ast_unit_secu_bal_his T0
		       LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
                 ON T0.SECU_ID = T1.SECU_ID
               LEFT JOIN ${dwd_db}.PTY_PRD_BASE_INFO T3 --产品基本信息
                 ON T0.PRD_CODE = T3.PRD_CODE
              WHERE (T1.EXCH_CODE IN ('CFFEX', 'SHFE', 'CZCE', 'DCE')) --筛选中国金融期货交易所、上海期货交易所、郑州商品交易所、大连商品交易所
                AND (T0.CURR_VOL <> 0 OR T0.SECU_ID LIKE '%ZQQSK%') --剔除当日有买卖，但是持仓为0部分
				AND T0.P_DT between ${beg_date} and ${end_date}
             ) A
GROUP BY A.PRD_CODE, A.HLD_DT, A.PRD_TYP, A.SECU_ID, A.INV_TYP, A.CIR_ID, A.AST_STAT, A.POS_ID

UNION ALL
--回购汇总
SELECT T3.PRD_CODE AS PRD_CODE, --产品代码
       T3.HLD_DT AS HLD_DT, --持仓日期
       T3.PRD_TYP AS PRD_TYP, --组合类型
       T3.SECU_ID AS SECU_ID, --证券编码
       MAX(T3.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(T3.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(T3.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(T3.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(T3.CHI_NAME) AS CHI_NAME, --证券中文名称
       MAX(T3.CRSE_CODE) AS CRSE_CODE, --会计科目
       T3.CRSE_TYPE AS CRSE_TYPE, --科目大类
       T3.CRSE_DIM AS CRSE_DIM, --科目属性
       T3.INV_TYP AS INV_TYP, --投资类型
       MAX(T3.CIR_ID) AS CIR_ID, --流通标识
       T3.AST_STAT AS AST_STAT, --资产状态
       T3.POS_ID AS POS_ID, --多空标识
       MAX(T3.CURR_CODE) AS CURR_CODE, --货币类型
       MAX(T3.OLCY_CURR_CODE) AS OLCY_CURR_CODE, --货币类型-原币
       MAX(T3.CRSE_NAME) AS CRSE_NAME, --科目名称
       SUM(round(T3.HLD_VOL,2)) AS HLD_VOL, --持仓数量
       SUM(round(T3.HLD_COST,2)) AS HLD_COST, --持仓成本
       SUM(round(T3.QUOT_PRC,2)) AS QUOT_PRC, --行情价格
       SUM(round(T3.HLD_VAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(T3.OLCY_HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(T3.OLCY_HLD_VAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(T3.ACCR_INTR) AS ACCR_INTR, --应计利息
       0 AS RECV_DIVD, --应收股利
       0 AS VALU_ADD, --估值增值,估值增值与估值不同
       0 AS INTR_ADJ, --利息调整
       0 AS IPMT_PVSN, --减值准备
       0 AS IPMT_PVSN_I, --减值准备一阶段
       0 AS IPMT_PVSN_II, --减值准备二阶段
       0 AS IPMT_PVSN_III, --减值准备三阶段
       0 AS PL_ADJ, --损益调整
       0 AS OTH_EQUI_CHG, --其他权益变动
       MAX(T3.EXCR) AS EXCR, --汇率
	   NULL AS is_value_cnfm, --是否估值确认日
	   NULL AS secu_quot_dt, --	证券行情日期
	   NULL AS iss_typ, --发行方式
	   NULL AS acg_proj, --	辅助核算项
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_hld_data_6&7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_REPO_HLD' AS dm_src_info,
       T3.HLD_DT AS P_DT,
       'DYCF' AS SYS_RS_ID --系统来源标识
FROM (
--回购品种
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       B.PRD_TYP AS PRD_TYP, --组合类型
       A.VAR_SECU_ID AS SECU_ID, --证券编码
       MAX(C.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(C.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(C.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(C.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       MAX(C.CHI_NAME) AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       CASE WHEN C.POS_ID = 'L' THEN '1' ELSE '2' END AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       C.POS_ID AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       SUM(A.HLD_VOL) AS HLD_VOL, --持仓数量
       SUM(round(A.HLD_COST,2)) AS HLD_COST, --持仓成本
       100 AS QUOT_PRC, --行情价格
       SUM(round(A.HLD_MVAL,2)) AS HLD_VAL, --持仓市值
       SUM(round(A.HLD_COST,2)) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(round(A.HLD_MVAL,2)) AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INT) AS ACCR_INTR, --应计利息
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
       'fin_prd_hld_data_6' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_REPO_HLD' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_REPO_HLD A  --回购持仓明细表
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B  --产品基本信息，获取资产单元产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '2'
  LEFT JOIN ${dwd_db}.FIN_PRD_REPO_PRO C --回购合约信息
    ON A.SECU_ID = C.SECU_ID
   AND C.sys_rs_id='DYCF'
  WHERE A.P_DT between ${beg_date} and ${end_date}
   AND A.SYS_RS_ID = 'DYCF'
GROUP BY A.PRD_CODE, A.HLD_DT, B.PRD_TYP, A.VAR_SECU_ID, C.POS_ID
) T3
GROUP BY T3.PRD_CODE, T3.HLD_DT, T3.PRD_TYP, T3.SECU_ID, T3.POS_ID,T3.CRSE_TYPE,T3.CRSE_DIM,T3.INV_TYP,T3.AST_STAT

UNION ALL
--存款品种
--一个产品只在某个资产单元中做存款，其中为基金代码为30的产品，资产单元由1279强制映射到000575_00057500（特殊处理）
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
       'fin_prd_hld_data_7' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       A.VALU_APRC AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       A.IPMT_INTR AS IPMT_INTR, --利息减值
       A.AGGR_FIXA AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.fin_prd_hld_data A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN VPRO_DPSI_INFO C
    ON A.PRD_CODE = C.PRD_CODE
 WHERE A.TYP_CODE IN ('DPSI') AND A.SECU_ID <> 'DPSI101.DPSI.NONE'
   AND A.p_dt between ${beg_date} and ${end_date}
   AND A.sys_rs_id IN ('YSSFA45','yssgz25')
   AND C.AST_UNIT_CODE <> '000575_0005752'

UNION ALL
--收益互换品种
--L_FUND_ID = 781(如果后续有新增需要调整，目前只有一只)
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
       'fin_prd_hld_data_8' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       A.VALU_APRC AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       A.IPMT_INTR AS IPMT_INTR, --利息减值
       A.AGGR_FIXA AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.fin_prd_hld_data A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
 INNER JOIN V_SYHH C
    ON A.PRD_CODE = C.PRD_CODE
 WHERE (A.TYP_CODE IN ('EX') OR A.SECU_ID = 'CXXJ.CASH.NONE')
   AND A.p_dt between ${beg_date} and ${end_date}
   AND A.sys_rs_id IN ('YSSFA45','yssgz25')

UNION ALL
--转融券汇总
SELECT T3.PRD_CODE AS PRD_CODE, --产品代码
       T3.HLD_DT AS HLD_DT, --持仓日期
       T3.PRD_TYP AS PRD_TYP, --组合类型
       T3.SECU_ID AS SECU_ID, --证券编码
       MAX(T3.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(T3.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(T3.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(T3.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       '转融券应计利息' AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       'L' AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       0 AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
       0 AS HLD_VAL, --持仓市值
       0 AS OLCY_HLD_COST, --持仓成本-原币
       0 AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(round(T3.ACCR_INTR,2)) AS ACCR_INTR, --应计利息
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
       'fin_prd_hld_data_9&10' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_REFC_HLD' AS dm_src_info,
       T3.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
FROM (
--转融券品种
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       B.PRD_TYP AS PRD_TYP, --组合类型
       A.VAR_SECU_ID AS SECU_ID, --证券编码
       MAX(C.TYP_CODE) AS TYP_CODE, --证券类别代码（大类）
       MAX(C.TYP_CODEI) AS TYP_CODEI, --证券类别代码（中类）
       MAX(C.TYP_CODEII) AS TYP_CODEII, --证券类别代码（细类）
       MAX(C.EXCH_CODE) AS EXCH_CODE, --交易市场代码
       '转融券应计利息' AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       'L' AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       0 AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
       0 AS HLD_VAL, --持仓市值
       0 AS OLCY_HLD_COST, --持仓成本-原币
       0 AS OLCY_HLD_VAL, --持仓市值-原币
       SUM(A.ACCR_INTR) AS ACCR_INTR, --应计利息
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
       'fin_prd_hld_data_9' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_REFC_HLD' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.FIN_PRD_REFC_HLD A  --产品转融通持仓明细信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B  --产品基本信息，获取资产单元产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '2'
  LEFT JOIN ${dwd_db}.FIN_PRD_ZRT_LEND C --转融券合约信息
    ON A.SECU_ID = C.SECU_ID
   AND C.sys_rs_id = 'DYCF'
 WHERE A.HLD_DT between ${beg_date} and ${end_date}
   AND A.sys_rs_id = 'DYCF'
  GROUP BY A.PRD_CODE, A.HLD_DT, B.PRD_TYP, A.VAR_SECU_ID

UNION ALL
--转融券品种,利息兜底
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
       CURR_CODE, --货币类型
       OLCY_CURR_CODE, --货币类型-原币
       CRSE_NAME, --科目名称
       HLD_VOL, --持仓数量
       HLD_COST, --持仓成本
       QUOT_PRC, --行情价格
       HLD_VAL, --持仓市值
       OLCY_HLD_COST, --持仓成本-原币
       OLCY_HLD_VAL, --持仓市值-原币
       CASE WHEN RN = 1 THEN ACCR_INTR1+YE ELSE ACCR_INTR1 END AS ACCR_INTR, --应计利息
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
T1.* ,
ACCR_INTR - SUM(ACCR_INTR1) over(partition by PRD_CODEA,HLD_DTD,SECU_VAR) as ye,
row_number() over(partition by PRD_CODEA,HLD_DTD,SECU_VAR order by ACCR_INTR1) as rn
FROM (
SELECT C.AST_UNIT_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       CONCAT('ZRT.REFC.', A.EXCH_CODE) AS SECU_ID, --证券编码
       'REFC' AS TYP_CODE, --证券类别代码（大类）
       'REFC102' AS TYP_CODEI, --证券类别代码（中类）
       'REFC10201' AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       '转融券应计利息' AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       'L' AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       0 AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
       0 AS HLD_VAL, --持仓市值
       0 AS OLCY_HLD_COST, --持仓成本-原币
       0  AS OLCY_HLD_VAL, --持仓市值-原币
	   A.PRD_CODE AS PRD_CODEA,D.HLD_DT AS HLD_DTD,D.SECU_VAR,
	   (A.ACCR_INTR- cast(SUM(D.ACCR_INT)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT,D.SECU_VAR) as double)) as ACCR_INTR,
       (A.ACCR_INTR- cast(SUM(D.ACCR_INT)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT,D.SECU_VAR) as double)) * cast(D.HLD_COST as double) / cast(SUM(D.HLD_COST)OVER(PARTITION BY A.PRD_CODE,D.HLD_DT,D.SECU_VAR) as double) AS ACCR_INTR1, --应计利息
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
       'DYCF' AS sys_rs_id --系统来源标识
  FROM VFIN_PRD_HLD_DATA A --产品持仓信息
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO B --产品基本信息，获取产品层产品
    ON A.PRD_CODE = B.PRD_CODE
   AND B.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO C
    ON A.PRD_CODE = C.PRD_CODE
  LEFT JOIN (SELECT T0.PRD_CODE,T0.HLD_DT,T1.SECU_VAR,SUM(HLD_COST) AS HLD_COST,SUM(ACCR_INTR) AS ACCR_INT,T0.EXCH_CODE
            FROM ${dwd_db}.FIN_PRD_REFC_HLD T0
			LEFT JOIN ${dwd_db}.FIN_PRD_ZRT_LEND T1 --转融券合约信息
              ON T0.SECU_ID = T1.SECU_ID AND T1.sys_rs_id='DYCF'
			WHERE T0.HLD_DT between ${beg_date} and ${end_date}
			 AND T0.sys_rs_id='DYCF'
			GROUP BY T0.PRD_CODE,T0.HLD_DT,T1.SECU_VAR,T0.EXCH_CODE
			) D
    ON C.AST_UNIT_CODE = D.PRD_CODE
   AND A.HLD_DT = D.HLD_DT
   AND A.EXCH_CODE = D.EXCH_CODE
) T1
) T2
) T3
group by T3.PRD_CODE,T3.HLD_DT,T3.PRD_TYP,T3.SECU_ID

UNION ALL
--现金类--投资端-证券申购款
SELECT A.PRD_CODE AS PRD_CODE, --产品代码
       A.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       A.SECU_ID AS SECU_ID, --证券编码
       'CASH' AS TYP_CODE, --证券类别代码（大类）
       'CASH143' AS TYP_CODEI, --证券类别代码（中类）
       '' AS TYP_CODEII, --证券类别代码（细类）
       A.EXCH_CODE AS EXCH_CODE, --交易市场代码
       '证券申购款' AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '1' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       'L' AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称
       0 AS HLD_VOL, --持仓数量
       SUM(A.HLD_VAL) AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
       SUM(A.HLD_VAL) AS HLD_VAL, --持仓市值
       SUM(A.HLD_VAL) AS OLCY_HLD_COST, --持仓成本-原币
       SUM(A.HLD_VAL)  AS OLCY_HLD_VAL, --持仓市值-原币
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
       'fin_prd_hld_data_19' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       A.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM V_ZQSGK A
  GROUP BY A.PRD_CODE,A.HLD_DT,A.SECU_ID,A.EXCH_CODE
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
;



WITH V_FIN_DD  AS 
(SELECT T0.PRD_CODE,
       T0.HLD_DT,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN CONCAT('GP.STK.', T2.EXCH_CODE)
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN CONCAT('JJ.FUND.', T2.EXCH_CODE)
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN CONCAT('REPO10101.REPO.' , T2.EXCH_CODE)
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN CONCAT('REPO10201.REPO.' , T2.EXCH_CODE)
	   END AS SECU_ID,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO'
	   END AS TYP_CODE,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO101'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO102'
	   END AS TYP_CODEI,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO10101'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO10201'
	   END AS TYP_CODEII,	   
	   T2.EXCH_CODE,
	   T0.POS_ID,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 0
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN T0.HLD_VAL
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 0
	   END) AS HLD_VAL,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN T0.RECV_DIVD
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN T0.RECV_DIVD
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 0
	   END) AS RECV_DIVD,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 0
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN T0.ACCR_INTR
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN T0.ACCR_INTR
	   END) AS ACCR_INTR
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
    ON T0.PRD_CODE = T1.PRD_CODE
   AND T1.PRD_TYP = '1'
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
    ON T0.SECU_ID = T2.SECU_ID	 
 WHERE T0.P_DT between  ${beg_date} and ${end_date}
   AND T2.TYP_CODE IN ('STK', 'FUND','REPO')
   AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25')
 GROUP BY T0.PRD_CODE,T0.HLD_DT,CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END,T2.EXCH_CODE,T0.POS_ID
 ),
V_TRD_DD  AS 
(SELECT T3.PRD_CODE,
        T0.HLD_DT,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN CONCAT('GP.STK.', T2.EXCH_CODE)
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN CONCAT('JJ.FUND.', T2.EXCH_CODE)
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN CONCAT('REPO10101.REPO.' , T2.EXCH_CODE)
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN CONCAT('REPO10201.REPO.' , T2.EXCH_CODE)
	   END AS SECU_ID,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO'
	   END AS TYP_CODE,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO101'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO102'
	   END AS TYP_CODEI,
	   CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 'STK'
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 'FUND'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 'REPO10101'
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 'REPO10201'
	   END AS TYP_CODEII,	   
	   T2.EXCH_CODE,
	   T0.POS_ID,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 0
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN T0.HLD_VAL
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 0
	   END) AS HLD_VAL,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN T0.RECV_DIVD
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN T0.RECV_DIVD
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN 0
	   END) AS RECV_DIVD,
	   SUM(CASE WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'STK' THEN 0
	        WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'FUND' THEN 0
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10101' THEN T0.ACCR_INTR
			WHEN CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END = 'REPO10201' THEN T0.ACCR_INTR
	   END) AS ACCR_INTR
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T1 --产品基本信息，获取产品层产品
    ON T0.PRD_CODE = T1.PRD_CODE
   AND T1.PRD_TYP = '2'
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T2
    ON T0.SECU_ID = T2.SECU_ID	 
  LEFT JOIN ${dwd_db}.ACC_ASSET_UNIT_INFO T3
    ON T0.PRD_CODE = T3.AST_UNIT_CODE   
 WHERE T0.P_DT between  ${beg_date} and ${end_date}
   AND T2.TYP_CODE IN ('STK', 'FUND','REPO')
   AND T0.SYS_RS_ID = 'DYCF'
 GROUP BY T3.PRD_CODE,T0.HLD_DT,CASE WHEN T2.TYP_CODE = 'REPO' THEN T2.TYP_CODEII ELSE T2.TYP_CODE END,T2.EXCH_CODE,T0.POS_ID
 )
 
 
insert into ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
(prd_code,hld_dt,prd_typ,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_typ,cir_id,ast_stat,pos_id,curr_code,olcy_curr_code,crse_name,hld_vol,hld_cost,quot_prc,hld_val,olcy_hld_cost,olcy_hld_val,accr_intr,recv_divd,valu_add,intr_adj,ipmt_pvsn,ipmt_pvsn_i,ipmt_pvsn_ii,ipmt_pvsn_iii,pl_adj,oth_equi_chg,excr,is_value_cnfm,secu_quot_dt,iss_typ,acg_proj,busi_date,task_rs_id,dm_created_time,valu_aprc,ipmt_intr,aggr_fixa,dm_src_info,p_dt,sys_rs_id)
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
--股票红利、基金红利再投和基金红利、回购利息兜底
SELECT CONCAT(T2.VC_FUND_CODE , '_' , T3.VC_ASSET_NO) AS PRD_CODE, --产品代码
       T0.HLD_DT AS HLD_DT, --持仓日期
       '2' AS PRD_TYP, --组合类型
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       CASE WHEN T1.SECU_ID LIKE '%BJ' THEN 'BJ' ELSE T0.EXCH_CODE END AS EXCH_CODE, --交易市场代码
       T4.CHI_NAME AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       CASE WHEN T0.POS_ID = 'L' THEN '1' ELSE '2' END AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       '2' AS INV_TYP, --投资类型
       '1' AS CIR_ID, --流通标识
       'L1' AS AST_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       'CNY' AS CURR_CODE, --货币类型
       'CNY' AS OLCY_CURR_CODE, --货币类型-原币
       'XC' AS CRSE_NAME, --科目名称        
       0 AS HLD_VOL, --持仓数量
       NVL(T0.HLD_VAL,0) - NVL(T1.HLD_VAL,0) AS HLD_COST, --持仓成本
       0 AS QUOT_PRC, --行情价格
       NVL(T0.HLD_VAL,0) - NVL(T1.HLD_VAL,0) AS HLD_VAL, --持仓市值
       NVL(T0.HLD_VAL,0) - NVL(T1.HLD_VAL,0) AS OLCY_HLD_COST, --持仓成本-原币
       NVL(T0.HLD_VAL,0) - NVL(T1.HLD_VAL,0) AS OLCY_HLD_VAL, --持仓市值-原币
       NVL(T0.ACCR_INTR,0) - NVL(T1.ACCR_INTR,0) AS ACCR_INTR, --应计利息
       NVL(T0.RECV_DIVD,0) - NVL(T1.RECV_DIVD,0) AS RECV_DIVD, --应收股利
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
       'fin_prd_hld_data_dd' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       NULL AS VALU_APRC, --估值表估值增值,无法均摊，赋值null
       0 AS IPMT_INTR, --利息减值
       0 AS AGGR_FIXA, --累计折旧
	   'FIN_PRD_HLD_DATA' AS dm_src_info,
       T0.HLD_DT AS P_DT,
       'DYCF' AS sys_rs_id --系统来源标识
  FROM V_FIN_DD T0
  LEFT JOIN V_TRD_DD T1
    ON T0.PRD_CODE = T1.PRD_CODE
   AND T0.HLD_DT = T1.HLD_DT
   AND T0.SECU_ID = REPLACE(T1.SECU_ID,'BJ','SB')
   AND T0.POS_ID = T1.POS_ID
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T2  --O32产品信息
    ON T0.PRD_CODE = T2.VC_FUND_CODE
  LEFT JOIN ${ods_db}.O3_TASSET T3 --032单元信息
    ON T2.L_DEFAULT_ASSET = T3.L_ASSET_ID  
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T4
    ON T0.SECU_ID = T4.SECU_ID		
  WHERE ((NVL(T0.HLD_VAL,0) - NVL(T1.HLD_VAL,0) <> 0)
  OR (NVL(T0.ACCR_INTR,0) - NVL(T1.ACCR_INTR,0) <> 0)
  OR (NVL(T0.RECV_DIVD,0) - NVL(T1.RECV_DIVD,0) <> 0)
  )
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
LEFT JOIN ${dwd_db}.PTY_PRD_DIFF_INFO T3
ON T2.FOFS_CODE = T3.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt
AND (T1.P_DT >= T3.END_DATE OR T3.END_DATE IS NULL)
; 