------------------------------------------------------------------------
-- 模块名称：产品交易信息--估值部分
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

--清除指定范围分区的数据
alter table ${dwd_db}.fin_prd_astrd_trd drop if exists partition (p_dt>=${beg_date}, p_dt<=${end_date}, sys_rs_id='DYCF');

--存款品种
--一个产品只在某个资产单元中做存款，其中为基金代码为30的产品，资产单元由1079强制映射到137（特殊处理）
WITH VPRO_DPSI_INFO AS
(SELECT DISTINCT T0.PRD_CODE,T0.AST_UNIT_CODE
FROM ${dwd_db}.PRO_DPSI_INFO T0
),
--L_FUND_ID = 781(如果后续有新增需要调整，目前只有一只)
V_SYHH AS
(SELECT DISTINCT T1.VC_FUND_CODE AS PRD_CODE,CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE
FROM ${ods_db}.O3_THISUNITSTOCK T0
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 ON T0.L_FUND_ID = T1.L_FUND_ID
LEFT JOIN ${ods_db}.O3_TASSET T2 ON T0.L_ASSET_ID = T2.L_ASSET_ID
WHERE T0.P_DT between ${beg_date} and ${end_date}
)
insert into ${dwd_db}.fin_prd_astrd_trd partition(p_dt,sys_rs_id)
(prd_code,prd_typ,trd_dt,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_type,cir_id,var_stat,pos_id,lf_curr_id,curr_code,tnv_no,trd_dir,tnv_vol,trd_prc,trd_net_prc,accr_int,tnv_val,sett_val,ytm,trd_fee,trd_fee_cms,trd_fee_hand,trd_fee_stmp,trd_fee_sfee,trd_fee_tfee,trd_fee_chag,excr,trd_cntp,trd_seat,trd_typ,inrt_tax,trad_no,trad_name,vou_typ,busi_date,task_rs_id,dm_src_info,dm_created_time,p_dt,sys_rs_id)
SELECT
t1.prd_code
,t1.prd_typ
,t1.trd_dt
,t1.secu_id
,t1.typ_code
,t1.typ_codei
,t1.typ_codeii
,t1.exch_code
,t1.chi_name
,t1.crse_code
,t1.crse_type
,t1.crse_dim
,t1.inv_type
,t1.cir_id
,t1.var_stat
,t1.pos_id
,t1.lf_curr_id
,t1.curr_code
,t1.tnv_no
,t1.trd_dir
,t1.tnv_vol
,t1.trd_prc
,t1.trd_net_prc
,t1.accr_int
,t1.tnv_val
,t1.sett_val
,t1.ytm
,t1.trd_fee
,t1.trd_fee_cms
,t1.trd_fee_hand
,t1.trd_fee_stmp
,t1.trd_fee_sfee
,t1.trd_fee_tfee
,t1.trd_fee_chag
,t1.excr
,t1.trd_cntp
,t1.trd_seat
,t1.trd_typ
,t1.inrt_tax
,t1.trad_no
,t1.trad_name
,t1.vou_typ
,t1.busi_date
,t1.task_rs_id
,t1.dm_src_info
,t1.dm_created_time
,t1.p_dt
,t1.sys_rs_id
FROM (
SELECT
       T1.AST_UNIT_CODE AS PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.CHI_NAME AS CHI_NAME, --证券中文名称
       T0.CRSE_CODE AS CRSE_CODE, --会计科目
       T0.CRSE_TYPE AS CRSE_TYPE, --科目大类
       T0.CRSE_DIM AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       T0.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       T0.CURR_CODE AS CURR_CODE, --货币类型
       T0.TNV_NO AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       T0.TRD_NET_PRC AS TRD_NET_PRC, --成交净价
       T0.ACCR_INT AS ACCR_INT, --应计利息
       T0.TNV_VAL AS TNV_VAL, --成交金额（不包含费用）
       T0.SETT_VAL AS SETT_VAL, --结算金额（包含费用）
	   NULL AS ytm,
       T0.TRD_FEE AS TRD_FEE, --交易费
	   NULL AS trd_fee_cms,   --交易费明细_佣金
	   NULL AS trd_fee_hand,  --交易费明细_经手费
	   NULL AS trd_fee_stmp,  --交易费明细_印花税
	   NULL AS trd_fee_sfee,  --交易费明细_证管费
	   NULL AS trd_fee_tfee,  --交易费明细_过户费
	   NULL AS trd_fee_chag,  --交易费明细_手续费
	   NULL AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   NULL AS trd_typ,       --交易类型
	   NULL AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       T0.VOU_TYP AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_1' AS TASK_RS_ID, --任务来源标识
       'FIN_PRD_ASTRD_TRD' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.P_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_ASTRD_TRD T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2 --产品基本信息，获取产品层产品
    ON T0.PRD_CODE = T2.PRD_CODE
   AND T2.PRD_TYP = '1'
  LEFT JOIN VPRO_DPSI_INFO T1
    ON T0.PRD_CODE = T1.PRD_CODE
 WHERE T0.TYP_CODE IN ('DPSI') AND T0.SECU_ID <> 'DPSI101.DPSI.NONE'
   AND T0.P_DT between  ${beg_date} and ${end_date}
   AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25')
   AND T1.AST_UNIT_CODE <> '000575_0005752'   

UNION ALL
--收益互换品种
SELECT
       T1.AST_UNIT_CODE AS PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.CHI_NAME AS CHI_NAME, --证券中文名称
       T0.CRSE_CODE AS CRSE_CODE, --会计科目
       T0.CRSE_TYPE AS CRSE_TYPE, --科目大类
       T0.CRSE_DIM AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       T0.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       T0.CURR_CODE AS CURR_CODE, --货币类型
       T0.TNV_NO AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       T0.TRD_NET_PRC AS TRD_NET_PRC, --成交净价
       T0.ACCR_INT AS ACCR_INT, --应计利息
       T0.TNV_VAL AS TNV_VAL, --成交金额（不包含费用）
       T0.SETT_VAL AS SETT_VAL, --结算金额（包含费用）
	   NULL AS ytm,
       T0.TRD_FEE AS TRD_FEE, --交易费
	   NULL AS trd_fee_cms,   --交易费明细_佣金
	   NULL AS trd_fee_hand,  --交易费明细_经手费
	   NULL AS trd_fee_stmp,  --交易费明细_印花税
	   NULL AS trd_fee_sfee,  --交易费明细_证管费
	   NULL AS trd_fee_tfee,  --交易费明细_过户费
	   NULL AS trd_fee_chag,  --交易费明细_手续费
	   NULL AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   NULL AS trd_typ,       --交易类型
	   NULL AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       T0.VOU_TYP AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_2' AS TASK_RS_ID, --任务来源标识
       'FIN_PRD_ASTRD_TRD' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.P_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_ASTRD_TRD T0
 INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2 --产品基本信息，获取产品层产品
    ON T0.PRD_CODE = T2.PRD_CODE
   AND T2.PRD_TYP = '1'
  LEFT JOIN V_SYHH T1
    ON T0.PRD_CODE = T1.PRD_CODE
 WHERE T0.TYP_CODE IN ('EX')
   AND T0.P_DT between ${beg_date} and ${end_date}
   AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25')

--手工补录维护
UNION ALL
SELECT
       T0.PRD_CODE AS PRD_CODE, --产品代码
       T0.PRD_TYP AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T1.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T1.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T1.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T1.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T1.CHI_NAME AS CHI_NAME, --证券中文名称
       'XC' AS CRSE_CODE, --会计科目
       '1' AS CRSE_TYPE, --科目大类
       'XC' AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       '1' AS LF_CURR_ID, --本币/原币标识
       'CNY' AS CURR_CODE, --货币类型
       CONCAT('INPT_' , T0.TNV_NO) AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       CASE WHEN T0.TRD_DIR = '1' THEN T0.TNV_VOL ELSE -T0.TNV_VOL END AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       T0.TRD_PRC - T0.ACCR_INT AS TRD_NET_PRC, --成交净价
       T0.ACCR_INT AS ACCR_INT, --应计利息
       CASE WHEN T0.TRD_DIR = '1' THEN CAST(T0.TNV_VOL AS DECIMAL(18,2)) * CAST(T0.TRD_PRC AS DECIMAL(18,2)) ELSE -(CAST(T0.TNV_VOL AS DECIMAL(18,2)) * CAST(T0.TRD_PRC AS DECIMAL(18,2))) END  AS TNV_VAL, --成交金额（不包含费用）
       CASE WHEN T0.TRD_DIR = '1' THEN CAST(T0.TNV_VOL AS DECIMAL(18,2)) * CAST(T0.TRD_PRC AS DECIMAL(18,2)) + CAST(T0.TRD_FEE AS DECIMAL(18,2)) ELSE -(CAST(T0.TNV_VOL AS DECIMAL(18,2)) * CAST(T0.TRD_PRC AS DECIMAL(18,2)) + CAST(T0.TRD_FEE AS DECIMAL(18,2))) END AS SETT_VAL, --结算金额（包含费用）
	   NULL AS ytm,
       CASE WHEN T0.TRD_DIR = '1' THEN T0.TRD_FEE ELSE -T0.TRD_FEE END AS TRD_FEE, --交易费
	   NULL AS trd_fee_cms,   --交易费明细_佣金
	   NULL AS trd_fee_hand,  --交易费明细_经手费
	   NULL AS trd_fee_stmp,  --交易费明细_印花税
	   NULL AS trd_fee_sfee,  --交易费明细_证管费
	   NULL AS trd_fee_tfee,  --交易费明细_过户费
	   NULL AS trd_fee_chag,  --交易费明细_手续费
	   NULL AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   NULL AS trd_typ,       --交易类型
	   NULL AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       NULL AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_3' AS TASK_RS_ID, --任务来源标识
       'FIN_PRD_ASTRD_TRD_INPT' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.TRD_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_ASTRD_TRD_INPT T0
  LEFT JOIN ${dwd_db}.VAR_SECU_INFO T1
    ON T0.SECU_ID = T1.SECU_ID
 WHERE T0.TRD_DT between ${beg_date} and ${end_date}

UNION ALL
--补充虚拟交易流水
SELECT
       CONCAT(T0.PRD_CODE, '_XC') AS PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T0.TRD_DT AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.CHI_NAME AS CHI_NAME, --证券中文名称
       T0.CRSE_CODE AS CRSE_CODE, --会计科目
       T0.CRSE_TYPE AS CRSE_TYPE, --科目大类
       T0.CRSE_DIM AS CRSE_DIM, --科目属性
       T0.INV_TYPE AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.VAR_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       T0.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       T0.CURR_CODE AS CURR_CODE, --货币类型
       T0.TNV_NO AS TNV_NO, --成交编号
       T0.TRD_DIR AS TRD_DIR, --交易方向
       T0.TNV_VOL AS TNV_VOL, --成交数量
       T0.TRD_PRC AS TRD_PRC, --交易价格（单价）
       T0.TRD_NET_PRC AS TRD_NET_PRC, --成交净价
       T0.ACCR_INT AS ACCR_INT, --应计利息
       T0.TNV_VAL AS TNV_VAL, --成交金额（不包含费用）
       T0.SETT_VAL AS SETT_VAL, --结算金额（包含费用）
	   t0.ytm AS ytm,
       T0.TRD_FEE AS TRD_FEE, --交易费
	   t0.trd_fee_cms AS trd_fee_cms,   --交易费明细_佣金
	   t0.trd_fee_hand AS trd_fee_hand,  --交易费明细_经手费
	   t0.trd_fee_stmp AS trd_fee_stmp,  --交易费明细_印花税
	   t0.trd_fee_sfee AS trd_fee_sfee,  --交易费明细_证管费
	   t0.trd_fee_tfee AS trd_fee_tfee,  --交易费明细_过户费
	   t0.trd_fee_chag AS trd_fee_chag,  --交易费明细_手续费
	   t0.excr AS excr,          --汇率
	   t0.trd_cntp AS trd_cntp,      --交易对手
	   t0.trd_seat AS trd_seat,      --交易席位
	   t0.trd_typ AS trd_typ,       --交易类型
	   t0.inrt_tax AS inrt_tax,      --利息税
	   t0.trad_no AS trad_no,       --券商编号
	   t0.trad_name AS trad_name,     --券商名称
       T0.VOU_TYP AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_4' AS TASK_RS_ID, --任务来源标识
       'FIN_PRD_ASTRD_TRD' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.P_DT AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_ASTRD_TRD T0
 INNER JOIN ${dwd_db}.PTY_PRD_DIFF_INFO T2 --产品差异信息
    ON T0.PRD_CODE = T2.PRD_CODE
 WHERE T0.P_DT between ${beg_date} and ${end_date}
   AND T0.SYS_RS_ID IN ('YSSFA45','yssgz25') 
   AND T0.P_DT >= T2.stat_date 
   and T0.P_DT < T2.end_date
   
UNION ALL
--补充虚拟清退交易流水
SELECT DISTINCT 
       CONCAT(T0.PRD_CODE, '_XC') AS PRD_CODE, --产品代码
       '2' AS PRD_TYP, --组合类型
       T2.END_DATE AS TRD_DT, --交易日期
       T0.SECU_ID AS SECU_ID, --证券编码
       T0.TYP_CODE AS TYP_CODE, --证券类别代码（大类）
       T0.TYP_CODEI AS TYP_CODEI, --证券类别代码（中类）
       T0.TYP_CODEII AS TYP_CODEII, --证券类别代码（细类）
       T0.EXCH_CODE AS EXCH_CODE, --交易市场代码
       T0.CHI_NAME AS CHI_NAME, --证券中文名称
       T0.CRSE_CODE AS CRSE_CODE, --会计科目
       T0.CRSE_TYPE AS CRSE_TYPE, --科目大类
       T0.CRSE_DIM AS CRSE_DIM, --科目属性
       T0.INV_TYP AS INV_TYPE, --投资类型
       T0.CIR_ID AS CIR_ID, --流通标识
       T0.AST_STAT AS VAR_STAT, --资产状态
       T0.POS_ID AS POS_ID, --多空标识
       T0.LF_CURR_ID AS LF_CURR_ID, --本币/原币标识
       T0.CURR_CODE AS CURR_CODE, --货币类型
       NULL AS TNV_NO, --成交编号
       NULL AS TRD_DIR, --交易方向
       -T0.HLD_VOL AS TNV_VOL, --成交数量
       nvl(cast(T0.HLD_VAL as double) / cast(T0.HLD_VOL as double),0)  AS TRD_PRC, --交易价格（单价）
       0 AS TRD_NET_PRC, --成交净价
       -T0.ACCR_INTR AS ACCR_INT, --应计利息
       -T0.HLD_VAL AS TNV_VAL, --成交金额（不包含费用）
       -T0.HLD_VAL AS SETT_VAL, --结算金额（包含费用）
	   0 AS ytm,
       0 AS TRD_FEE, --交易费
	   0 AS trd_fee_cms,   --交易费明细_佣金
	   0 AS trd_fee_hand,  --交易费明细_经手费
	   0 AS trd_fee_stmp,  --交易费明细_印花税
	   0 AS trd_fee_sfee,  --交易费明细_证管费
	   0 AS trd_fee_tfee,  --交易费明细_过户费
	   0 AS trd_fee_chag,  --交易费明细_手续费
	   0 AS excr,          --汇率
	   NULL AS trd_cntp,      --交易对手
	   NULL AS trd_seat,      --交易席位
	   NULL AS trd_typ,       --交易类型
	   0 AS inrt_tax,      --利息税
	   NULL AS trad_no,       --券商编号
	   NULL AS trad_name,     --券商名称
       NULL AS VOU_TYP, --凭证类别
       date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
       'fin_prd_astrd_trd_5' AS TASK_RS_ID, --任务来源标识
       'FIN_PRD_ASTRD_TRD' AS dm_src_info,
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T2.END_DATE AS P_DT, --日期
       'DYCF' AS SYS_RS_ID --系统来源标识
  FROM ${dwd_db}.FIN_PRD_HLD_DATA T0
 INNER JOIN ${dwd_db}.PTY_PRD_DIFF_INFO T2 --产品差异信息
    ON T0.PRD_CODE = T2.PRD_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade w1
    ON T0.p_dt = W1.dt
   AND W1.mkt_no = '1'
   AND W1.SYS_RS_ID = 'O3'	
 WHERE T0.SYS_RS_ID IN ('YSSFA45','yssgz25') 
   AND T0.SECU_ID LIKE '%FUND.NONE'
   AND T2.END_DATE between ${beg_date} and ${end_date}
   AND W1.AFT_1_DT = T2.END_DATE
   and t0.P_DT between t2.stat_date and t2.END_DATE
   AND T0.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
) T1
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO T2
ON T1.PRD_CODE = T2.PRD_CODE
WHERE T1.p_dt <= T2.valu_cnfm_dt