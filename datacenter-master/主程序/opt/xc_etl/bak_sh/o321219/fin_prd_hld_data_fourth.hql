------------------------------------------------------------------------
-- 模块名称：产品持仓信息--补充估值比交易做账早的数据
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


--补充估值比交易做账早的数据
insert into ${dwd_db}.fin_prd_hld_data partition(p_dt,sys_rs_id)
(prd_code,hld_dt,prd_typ,secu_id,typ_code,typ_codei,typ_codeii,exch_code,chi_name,crse_code,crse_type,crse_dim,inv_typ,cir_id,ast_stat,pos_id,lf_curr_id,curr_code,olcy_curr_code,crse_name,hld_vol,hld_cost,quot_prc,hld_val,olcy_hld_cost,olcy_hld_val,accr_intr,recv_divd,valu_add,intr_adj,ipmt_pvsn,ipmt_pvsn_i,ipmt_pvsn_ii,ipmt_pvsn_iii,pl_adj,oth_equi_chg,excr,is_value_cnfm,secu_quot_dt,iss_typ,acg_proj,busi_date,task_rs_id,dm_created_time,valu_aprc,ipmt_intr,aggr_fixa,dm_src_info,p_dt,sys_rs_id)
SELECT 
concat(A.PRD_CODE, '_XC') AS PRD_CODE --产品代码
,A.HLD_DT AS HLD_DT --持仓日期
,'2' AS PRD_TYP --组合类型
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
,date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date
,'fin_prd_hld_data_fourth_1' as task_rs_id
,CURRENT_TIMESTAMP as dm_created_time
,a.valu_aprc
,a.ipmt_intr
,a.aggr_fixa
,'FIN_PRD_HLD_DATA' AS dm_src_info
,A.HLD_DT AS P_DT
,'DYCF' AS sys_rs_id --系统来源标识
FROM ${dwd_db}.FIN_PRD_HLD_DATA a
INNER JOIN ${dwd_db}.PTY_PRD_DIFF_INFO B --产品差异信息
  ON A.PRD_CODE = B.PRD_CODE
WHERE a.SYS_RS_ID IN ('YSSFA45','yssgz25') 
 AND a.P_DT between ${beg_date} and ${end_date}   
 AND A.P_DT >= B.stat_date 
 and A.P_DT < B.end_date
;