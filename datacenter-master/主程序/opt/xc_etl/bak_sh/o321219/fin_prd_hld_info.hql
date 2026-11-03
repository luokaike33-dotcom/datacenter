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
----set spark.driver.memory=2G;
----set hive.auto.convert.join=true;
----set hive.warehouse.subdir.inherit.perms=false;

alter table ${dwd_db}.fin_prd_hld_info drop if exists partition (p_dt >='${beg_date}',p_dt <='${end_date}',sys_rs_id='DYCF');

insert into ${dwd_db}.fin_prd_hld_info partition(p_dt, sys_rs_id)
  (prd_code, --产品代码
   hld_dt, --持仓日期
   prd_typ, --组合类型
   secu_id, --证券编码
   typ_code, --证券类别代码（大类）
   typ_codei, --证券类别代码（中类）
   typ_codeii, --证券类别代码（细类）
   exch_code, --交易市场代码
   chi_name, --证券中文名称
   crse_code, --会计科目
   crse_type, --科目大类
   crse_dim, --科目属性
   inv_typ, --投资类型
   cir_id, --流通标识
   ast_stat, --资产状态
   pos_id, --多空标识
   lf_curr_id, --本币/原币标识
   curr_code, --货币类型
   olcy_curr_code, --货币类型-原币
   crse_name, --科目名称
   hld_vol, --持仓数量
   hld_cost, --持仓成本
   quot_prc, --行情价格
   hld_val, --持仓市值
   olcy_hld_cost, --持仓成本-原币
   olcy_hld_val, --持仓市值-原币
   accr_intr, --应计利息
   recv_divd, --应收股利
   valu_add, --估值增值
   intr_adj, --利息调整
   ipmt_pvsn, --减值准备
   ipmt_pvsn_i, --减值准备一阶段
   ipmt_pvsn_ii, --减值准备二阶段
   ipmt_pvsn_iii, --减值准备三阶段
   pl_adj, --损益调整
   oth_equi_chg, --其他权益变动
   excr, --汇率
   is_value_cnfm, --是否估值确认日
   secu_quot_dt, --证券行情日期
   iss_typ, --发行方式
   acg_proj, --辅助核算项
   busi_date, --业务日期
   task_rs_id, --任务来源标识
   dm_created_time, --数据中台创建时间
   valu_aprc, --估值表估值增值
   ipmt_intr, --利息减值
   aggr_fixa, --累计折旧
   p_dt, --日期
   sys_rs_id, --系统来源标识
   dm_src_info --来源信息
   )
select prd_code, --产品代码
       hld_dt, --持仓日期
       max(prd_typ) as prd_typ, --组合类型
       secu_id, --证券编码
       max(typ_code) as typ_code, --证券类别代码（大类）
       max(typ_codei) as typ_codei, --证券类别代码（中类）
       max(typ_codeii) as typ_codeii, --证券类别代码（细类）
       max(exch_code) as exch_code, --交易市场代码
       max(chi_name) as chi_name, --证券中文名称
       max(crse_code) as crse_code, --会计科目
       max(crse_type) as crse_type, --科目大类
       max(crse_dim) as crse_dim, --科目属性
       inv_typ, --投资类型
       cir_id, --流通标识
       ast_stat, --资产状态
       pos_id, --多空标识
       max(lf_curr_id) as lf_curr_id, --本币/原币标识
       max(curr_code) as curr_code, --货币类型
       max(olcy_curr_code) as olcy_curr_code, --货币类型-原币
       max(crse_name) as crse_name, --科目名称
       sum(nvl(hld_vol,0)) as hld_vol, --持仓数量
       sum(nvl(hld_cost,0)) as hld_cost, --持仓成本
       max(quot_prc) as quot_prc, --行情价格
       sum(nvl(hld_val,0)) as hld_val, --持仓市值
       sum(nvl(olcy_hld_cost,0)) as olcy_hld_cost, --持仓成本-原币
       sum(nvl(olcy_hld_val,0)) as olcy_hld_val, --持仓市值-原币
       sum(nvl(accr_intr,0)) as accr_intr, --应计利息
       sum(nvl(recv_divd,0)) as recv_divd, --应收股利
       sum(nvl(valu_add,0)) as valu_add, --估值增值
       sum(nvl(intr_adj,0)) as intr_adj, --利息调整
       sum(nvl(ipmt_pvsn,0)) as ipmt_pvsn, --减值准备
       sum(nvl(ipmt_pvsn_i,0)) as ipmt_pvsn_i, --减值准备一阶段
       sum(nvl(ipmt_pvsn_ii,0)) as ipmt_pvsn_ii, --减值准备二阶段
       sum(nvl(ipmt_pvsn_iii,0)) as ipmt_pvsn_ii, --减值准备三阶段
       sum(nvl(pl_adj,0)) as pl_adj, --损益调整
       sum(nvl(oth_equi_chg,0)) as oth_equi_chg, --其他权益变动
       max(excr) as excr, --汇率
       max(is_value_cnfm) as is_value_cnfm, --是否估值确认日
       max(secu_quot_dt) as secu_quot_dt, --证券行情日期
       max(iss_typ) as iss_typ, --发行方式
       max(acg_proj) as acg_proj, --辅助核算项
       max(busi_date) as busi_date, --业务日期
       'fin_prd_hld_info1' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       sum(valu_aprc) as valu_aprc, --估值表估值增值
       sum(ipmt_intr) as ipmt_intr, --利息减值
       sum(aggr_fixa) as aggr_fixa, --累计折旧
       hld_dt as p_dt,
       'DYCF' as sys_rs_id,
       'fin_prd_hld_data' as dm_src_info --来源信息
from ${dwd_db}.fin_prd_hld_data
where p_dt between ${beg_date} and ${end_date}
  and sys_rs_id in ('DYCF','DYCF_CASH')
group by prd_code, --产品代码
         hld_dt, --持仓日期
         secu_id, --证券编码
         inv_typ, --投资类型
         cir_id, --流通标识
         ast_stat, --资产状态
         pos_id --多空标识
