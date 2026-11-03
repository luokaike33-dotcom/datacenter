------------------------------------------------------------------------
-- 模块名称：产品持仓信息--手工补录+非交易日补录
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


insert into ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
(prd_code,hld_dt,prd_typ,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_typ,cir_id,ast_stat,pos_id,lf_curr_id,curr_code,olcy_curr_code,crse_name,hld_vol,hld_cost,quot_prc,hld_val,olcy_hld_cost,olcy_hld_val,accr_intr,recv_divd,valu_add,intr_adj,ipmt_pvsn,ipmt_pvsn_i,ipmt_pvsn_ii,ipmt_pvsn_iii,pl_adj,oth_equi_chg,excr,is_value_cnfm,secu_quot_dt,iss_typ,acg_proj,busi_date,task_rs_id,dm_created_time,valu_aprc,ipmt_intr,aggr_fixa,dm_src_info,p_dt,sys_rs_id)
--手工补录新增
SELECT 
A.PRD_CODE AS PRD_CODE --产品代码
,b.cald_date AS HLD_DT --持仓日期
,'2' AS PRD_TYP --组合类型
,a.secu_id
,c.TYP_CODE AS TYP_CODE --证券类别代码（大类）
,c.TYP_CODEI AS TYP_CODEI --证券类别代码（中类）
,c.TYP_CODEII AS TYP_CODEII --证券类别代码（细类）
,c.EXCH_CODE AS EXCH_CODE --交易市场代码
,c.CHI_NAME AS CHI_NAME --证券中文名称
,'XC' AS crse_code
,'XC' AS crse_type
,'XC' AS crse_dim
,a.INV_TYP
,a.CIR_ID
,a.AST_STAT
,a.POS_ID
,'1' AS lf_curr_id
,'CNY' AS curr_code
,'CNY' AS olcy_curr_code
,'XC' AS crse_name
,a.HLD_VOL
,a.HLD_COST
,a.QUOT_PRC
,CAST(a.HLD_VOL AS DOUBLE) * CAST(a.QUOT_PRC AS DOUBLE) AS hld_val
,a.HLD_COST AS olcy_hld_cost
,CAST(a.HLD_VOL AS DOUBLE) * CAST(a.QUOT_PRC AS DOUBLE) AS olcy_hld_val
,a.ACCR_INTR
,a.RECV_DIVD
,CAST(a.HLD_VOL AS DOUBLE) * CAST(a.QUOT_PRC AS DOUBLE) - a.HLD_COST AS valu_add
,a.INTR_ADJ
,a.IPMT_PVSN
,a.IPMT_PVSN_I
,a.IPMT_PVSN_II
,a.IPMT_PVSN_III
,a.PL_ADJ
,a.OTH_EQUI_CHG
,1 AS excr
,NULL AS is_value_cnfm --是否估值确认日
,NULL AS secu_quot_dt --证券行情日期
,NULL AS iss_typ --发行方式
,NULL AS acg_proj --辅助核算项
,date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date
,'fin_prd_hld_data_fourth_2' as task_rs_id
,CURRENT_TIMESTAMP as dm_created_time
,NULL AS valu_aprc
,a.IPMT_INTR
,a.AGGR_FIXA
,'fin_prd_hld_inpt' AS dm_src_info
,b.cald_date AS P_DT
,'DYCF' AS sys_rs_id --系统来源标识
FROM ${dwd_db}.fin_prd_hld_inpt a
inner join ${dwd_db}.trd_cald_dtl b
on 1=1
and b.cald_date between ${beg_date} and ${end_date}
and b.cald_id = '1'
and b.is_trd_dt = '1'
LEFT JOIN ${dwd_db}.VAR_SECU_INFO c
ON a.SECU_ID = c.SECU_ID
where a.OPER_TYP = 0
and a.HLD_BEG_DT >= ${beg_date} 
and a.HLD_END_DT <= ${end_date} 
and b.cald_date between a.HLD_BEG_DT and a.HLD_END_DT
; 

with tmp as (
select
concat(a.PRD_CODE,a.PRD_TYP,a.SECU_ID,a.INV_TYP,a.CIR_ID,a.AST_STAT,a.POS_ID,A.P_DT) as a
from ${dwd_db}.fin_prd_hld_data a
inner join ${dwd_db}.fin_prd_hld_inpt b
on a.PRD_CODE = b.PRD_CODE
and a.PRD_TYP = b.PRD_TYP
and a.SECU_ID = b.SECU_ID
and a.INV_TYP = b.INV_TYP
and a.CIR_ID = b.CIR_ID
and a.AST_STAT = b.AST_STAT
and a.POS_ID = b.POS_ID
where b.OPER_TYP = 1
and b.HLD_BEG_DT >= ${beg_date}
and b.HLD_END_DT <= ${end_date}
and A.P_DT BETWEEN ${beg_date} AND ${end_date}
and A.P_DT BETWEEN b.HLD_BEG_DT AND b.HLD_END_DT
)
--删除需要补录的数据
insert overwrite table ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
select
a.prd_code
,a.hld_dt
,a.prd_typ
,a.secu_id
,a.typ_code
,a.typ_codei
,a.typ_codeii
,a.exch_code
,a.chi_name
,a.crse_code
,a.crse_type
,a.crse_dim
,a.inv_typ
,a.cir_id
,a.ast_stat
,a.pos_id
,a.lf_curr_id
,a.curr_code
,a.olcy_curr_code
,a.crse_name
,a.hld_vol
,a.hld_cost
,a.quot_prc
,a.hld_val
,a.olcy_hld_cost
,a.olcy_hld_val
,a.accr_intr
,a.recv_divd
,a.valu_add
,a.intr_adj
,a.ipmt_pvsn
,a.ipmt_pvsn_i
,a.ipmt_pvsn_ii
,a.ipmt_pvsn_iii
,a.pl_adj
,a.oth_equi_chg
,a.excr
,a.is_value_cnfm
,a.secu_quot_dt
,a.iss_typ
,a.acg_proj
,a.trd_dim
,a.busi_date
,a.task_rs_id
,a.dm_created_time
,a.valu_aprc
,a.ipmt_intr
,a.aggr_fixa
,a.dm_src_info
,a.p_dt
,a.sys_rs_id
from ${dwd_db}.fin_prd_hld_data a
where concat(a.PRD_CODE,a.PRD_TYP,a.SECU_ID,a.INV_TYP,a.CIR_ID,a.AST_STAT,a.POS_ID,a.p_dt) not in (
select a from tmp
)
AND A.P_DT BETWEEN ${beg_date} AND ${end_date}
;


--更新需要补录的数据
insert overwrite table ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
select
a.prd_code
,a.hld_dt
,a.prd_typ
,a.secu_id
,a.typ_code
,a.typ_codei
,a.typ_codeii
,a.exch_code
,a.chi_name
,a.crse_code
,a.crse_type
,a.crse_dim
,a.inv_typ
,a.cir_id
,a.ast_stat
,a.pos_id
,a.lf_curr_id
,a.curr_code
,a.olcy_curr_code
,a.crse_name
,nvl(b.HLD_VOL,a.hld_vol) as HLD_VOL
,nvl(b.HLD_COST,a.hld_cost) as HLD_COST
,nvl(b.QUOT_PRC,a.quot_prc) as QUOT_PRC
,nvl(CAST(b.HLD_VOL AS DOUBLE) * CAST(b.QUOT_PRC AS DOUBLE),a.hld_val) as hld_val
,nvl(b.HLD_COST,a.olcy_hld_cost) as olcy_hld_cost
,nvl(CAST(b.HLD_VOL AS DOUBLE) * CAST(b.QUOT_PRC AS DOUBLE),a.olcy_hld_val) as olcy_hld_val
,nvl(b.ACCR_INTR,a.accr_intr) as ACCR_INTR
,nvl(b.RECV_DIVD,a.recv_divd) as RECV_DIVD
,a.valu_add
,nvl(b.INTR_ADJ,a.intr_adj) as INTR_ADJ
,nvl(b.IPMT_PVSN,a.ipmt_pvsn) as IPMT_PVSN
,nvl(b.IPMT_PVSN_I,a.ipmt_pvsn_i) as IPMT_PVSN_I
,nvl(b.IPMT_PVSN_II,a.ipmt_pvsn_ii) as IPMT_PVSN_II
,nvl(b.IPMT_PVSN_III,a.ipmt_pvsn_iii) as IPMT_PVSN_III
,nvl(b.PL_ADJ,a.pl_adj) as PL_ADJ
,nvl(b.OTH_EQUI_CHG,a.oth_equi_chg) as OTH_EQUI_CHG
,a.excr
,a.is_value_cnfm
,a.secu_quot_dt
,a.iss_typ
,a.acg_proj
,a.trd_dim
,a.busi_date
,a.task_rs_id
,a.dm_created_time
,a.valu_aprc
,nvl(b.IPMT_INTR,a.ipmt_intr) as IPMT_INTR
,nvl(b.AGGR_FIXA,a.aggr_fixa) as AGGR_FIXA
,a.dm_src_info
,a.p_dt
,a.sys_rs_id
from ${dwd_db}.fin_prd_hld_data a
inner join (
select b.*,c.cald_date
from ${dwd_db}.fin_prd_hld_inpt b
inner join ${dwd_db}.trd_cald_dtl c
on 1=1
and c.cald_date between ${beg_date} and ${end_date}
and c.cald_id = '1'
and c.is_trd_dt = '1'
where c.cald_date between b.HLD_BEG_DT and b.HLD_END_DT
) b
on a.PRD_CODE = b.PRD_CODE
and a.PRD_TYP = b.PRD_TYP
and a.SECU_ID = b.SECU_ID
and a.INV_TYP = b.INV_TYP
and a.CIR_ID = b.CIR_ID
and a.AST_STAT = b.AST_STAT
and a.POS_ID = b.POS_ID
and b.OPER_TYP = 2
and a.p_dt = b.cald_date
where A.P_DT BETWEEN ${beg_date} AND ${end_date}
;

--补充非交易日
insert overwrite table ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
select 
B2.prd_code AS prd_code ,
A2.cald_date AS hld_dt ,
B2.prd_typ AS prd_typ ,
B2.secu_id AS secu_id ,
B2.typ_code AS typ_code ,
B2.typ_codei AS typ_codei ,
B2.typ_codeii AS typ_codeii ,
B2.exch_code AS exch_code ,
B2.chi_name AS chi_name ,
B2.crse_code AS crse_code ,
B2.crse_type AS crse_type ,
B2.crse_dim AS crse_dim ,
B2.inv_typ AS inv_typ ,
B2.cir_id AS cir_id ,
B2.ast_stat AS ast_stat ,
B2.pos_id AS pos_id ,
B2.lf_curr_id AS lf_curr_id ,
B2.curr_code AS curr_code ,
B2.olcy_curr_code AS olcy_curr_code ,
B2.crse_name AS crse_name ,
B2.hld_vol AS hld_vol ,
B2.hld_cost AS hld_cost ,
B2.quot_prc AS quot_prc ,
B2.hld_val AS hld_val ,
B2.olcy_hld_cost AS olcy_hld_cost ,
B2.olcy_hld_val AS olcy_hld_val ,
B2.accr_intr AS accr_intr ,
B2.recv_divd AS recv_divd ,
B2.valu_add AS valu_add ,
B2.intr_adj AS intr_adj ,
B2.ipmt_pvsn AS ipmt_pvsn ,
B2.ipmt_pvsn_i AS ipmt_pvsn_i ,
B2.ipmt_pvsn_ii AS ipmt_pvsn_ii ,
B2.ipmt_pvsn_iii AS ipmt_pvsn_iii ,
B2.pl_adj AS pl_adj ,
B2.oth_equi_chg AS oth_equi_chg ,
B2.excr AS excr ,
B2.is_value_cnfm AS is_value_cnfm ,
B2.secu_quot_dt AS secu_quot_dt ,
B2.iss_typ AS iss_typ ,
B2.acg_proj AS acg_proj ,
B2.trd_dim AS trd_dim ,
date_format(date_sub(current_date(), 1), 'yyyyMMdd') AS busi_date ,
B2.task_rs_id AS task_rs_id ,
CURRENT_TIMESTAMP AS dm_created_time ,
B2.valu_aprc AS valu_aprc ,
B2.ipmt_intr AS ipmt_intr ,
B2.aggr_fixa AS aggr_fixa ,
B2.dm_src_info AS dm_src_info ,
A2.cald_date AS p_dt ,
B2.sys_rs_id AS sys_rs_id 
      from (
	  select b.prd_code, a.cald_date, a.lst_cald_date
            from ${dwd_db}.trd_cald_dtl a
            inner join ${dwd_db}.pty_prd_base_info b
                       on 1 = 1	
                      AND B.SYS_RS_ID = 'DYCF'					   
            where a.cald_id = '1' AND A.IS_TRD_DT=0
              and a.cald_date >= b.found_dt
			  and a.cald_date <= b.end_dt
              and a.cald_date >= ${beg_date}
              and a.cald_date <= ${end_date}
		  ) a2
               left join ${dwd_db}.fin_prd_hld_data b2
                         on a2.prd_code = b2.prd_code
						and b2.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date}
						and b2.sys_rs_id IN ('DYCF','DYCF_CASH')
      where  a2.lst_cald_date=b2.p_dt
;	  