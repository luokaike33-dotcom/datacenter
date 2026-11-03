-- 其他验证SQL：
select t.prd_code_1, t1.prd_code, t.hld_dt, t1.hld_dt, t.var_secu_id, t1.var_secu_id, t.pos_id, t1.pos_id,
       t.hld_vol, t1.hld_vol, t.hld_cost, t1.hld_cost, t.hld_mval, t1.hld_mval, t.accr_int, t1.accr_int,
       t.accr_int - t1.accr_int as diff_accr_int
from (
select t1.prd_code as prd_code_1, t.hld_dt, t.var_secu_id, t.pos_id, sum(t.hld_vol) as hld_vol, sum(t.hld_cost) as hld_cost, sum(hld_mval) as hld_mval,
       sum(t.accr_int) as accr_int
from ty_dwd.fin_prd_repo_hld t 
left join ty_dwd.acc_asset_unit_info t1 on t.prd_code = t1.ast_unit_code
where t.p_dt = 20230505 and t.prd_code like '000575_%' and t.secu_id not like '%YHJ%'
group by t1.prd_code, t.var_secu_id, t.pos_id, t.hld_dt) t
full join(
select t.prd_code, t.hld_dt, t.var_secu_id, t.pos_id, sum(t.hld_vol) as hld_vol, sum(t.hld_cost) as hld_cost, sum(hld_mval) as hld_mval,
       sum(t.accr_int) as accr_int
from ty_dwd.fin_prd_repo_hld t where t.p_dt = 20230505 and t.prd_code like '000575' and t.secu_id not like '%YHJ%'
group by t.prd_code, t.var_secu_id, t.pos_id, t.hld_dt) t1
on t.var_secu_id = t1.var_secu_id and t.pos_id = t1.pos_id and t.prd_code_1 = t1.prd_code and t.hld_dt = t1.hld_dt;



select t1.prd_code, t2.prd_code, t1.pos_id, t2.pos_id, 
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr 
from (
select prd_code, t.pos_id, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.p_dt between 20230505 and 20230505 and t.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t.pos_id) t1 
full join (
select split(t.prd_code,'_')[0] as prd_code, t.pos_id, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on split(t.prd_code,'_')[0] = t1.vc_fund_code
where t.p_dt between 20230505 and 20230505 and t.typ_code = 'REPO' and t.sys_rs_id = 'DYCF'
group by split(t.prd_code,'_')[0], t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.pos_id = t2.pos_id;




select t1.prd_code, t2.prd_code, t1.pos_id, t2.pos_id, t1.exch_code, t2.exch_code, t1.hld_dt, t2.hld_dt,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr 
from (
select prd_code, t.hld_dt,t.pos_id, t.exch_code, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.p_dt between 20230505 and 20230505 and t.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t.hld_dt, t.pos_id, t.exch_code
order by t.prd_code, t.hld_dt, t.pos_id, t.exch_code) t1 
full join (
select t2.fofs_code as prd_code, t.hld_dt, t.pos_id, t.exch_code, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t2 on t.prd_code = t2.prd_code and t2.prd_typ = '2'
where t.p_dt between 20230505 and 20230505 and t.typ_code = 'REPO' and t.sys_rs_id = 'DYCF'
group by t2.fofs_code, t.hld_dt, t.pos_id, t.exch_code) t2
on t1.prd_code = t2.prd_code and t1.pos_id = t2.pos_id and t1.hld_dt = t2.hld_dt and t1.exch_code = t2.exch_code
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.hld_dt,t2.hld_dt) = tt.cald_date
order by t1.prd_code, t1.hld_dt, t1.pos_id, t1.exch_code;

-- 估值和交易差异数据
with tmp_fund_dt as (
select coalesce(t1.prd_code,t2.prd_code) as prd_code, t1.jy_p_dt, t2.gz_p_dt
from (
select t1.vc_fund_code as prd_code, min(t.p_dt) as jy_p_dt from ty_ods.o3_thisassetday t
inner join ty_ods.o3_tfundinfo t1 on t.l_fund_id = t1.l_fund_id
where t.en_current_cash <> 0
group by t1.vc_fund_code) t1
full join
(select t.c_port_code as prd_code, min(t.p_dt) as gz_p_dt from ty_ods.fa45_vf_report_val t group by t.c_port_code) t2
on t1.prd_code = t2.prd_code 
where t1.jy_p_dt <> t2.gz_p_dt and t1.jy_p_dt >= 20230101 and t2.gz_p_dt >= 20230101)
select t1.p_dt, t1.prd_code, t1.typ_code
from ty_dwd.fin_prd_hld_data t1
inner join tmp_fund_dt t2 on t1.prd_code = t2.prd_code
where t1.p_dt >= t2.jy_p_dt and t1.p_dt <= t2.gz_p_dt
group by t1.p_dt, t1.prd_code, t1.typ_code
order by t1.p_dt, t1.prd_code, t1.typ_code;

-- 兜底虚拟券数据稽核
select * from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.trd_cald_dtl t1 on t.p_dt = t1.cald_date and t1.cald_id = '1' and t1.is_trd_dt = '1'
where t.task_rs_id = 'fin_prd_hld_data_dd' and t.p_dt >= 20221231
order by t.prd_code, t.p_dt, t.secu_id;

-- 证券申购款稽核对比
select * from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.trd_cald_dtl t1 on t.p_dt = t1.cald_date and t1.cald_id = '1' and t1.is_trd_dt = '1'
inner join (  -- 过滤估值和交易不同做账的日期的数据
select t.prd_code, max(t.p_dt) as p_dt from (
select t1.vc_fund_code as prd_code, min(t.p_dt) as p_dt from ty_ods.o3_thisassetday t
inner join ty_ods.o3_tfundinfo t1 on t.l_fund_id = t1.l_fund_id
where t.en_current_cash <> 0
group by t1.vc_fund_code
union all
select t.c_port_code as prd_code, min(t.p_dt) from ty_ods.fa45_vf_report_val t group by t.c_port_code) t group by t.prd_code) ty on substring(t.prd_code,1,6) = ty.prd_code 
where t.task_rs_id = 'fin_prd_hld_data_dd' and t.p_dt >= 20221231 and t.p_dt >= ty.p_dt
order by t.prd_code, t.p_dt, t.secu_id;

-- 获取计算收益率的净值、资金流数据
select t.prd_code, t.p_dt, t.ttl_navl, t.ttl_shr, t.unit_nval, t3.shr_add, t3.capi_add, t3.shr_reduce, t3.capi_reduce, t1.is_trd_dt from ty_dwd.fin_prd_nav t
left join ty_dwd.trd_cald_dtl t1 on t.p_dt = t1.cald_date and t1.cald_id = '1'
inner join ty_dwd.pty_prd_base_info t2 on t.prd_code = t2.prd_code and t2.prd_typ = '2'
left join (select t.prd_code, t.chg_dt, sum(shr_add) as shr_add, sum(capi_add) as capi_add, sum(shr_reduce) as shr_reduce, sum(capi_reduce) as capi_reduce
from ty_dwd.fin_prd_capi_chg_detail t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
group by t.prd_code, t.chg_dt) t3 on t.prd_code = t3.prd_code and t.p_dt = t3.chg_dt
where t.prd_code like '004952_%' and t.p_dt between 20230101 and 20230331
order by t.prd_code, t.p_dt;

-- 估值本身核对
select t1.p_dt, t2.p_dt,
       t1.prd_code, t2.prd_code,
       t1.ttl_navl, t2.ttl_navl, t1.ttl_navl-t2.ttl_navl as diff_ttl_navl
from (
select * from ty_dwd.fin_prd_nav t where t.sys_rs_id = 'YSSFA45' and t.p_dt between 20230101 and 20230531) t1
left join (
select t.prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as ttl_navl
from ty_dwd.fin_prd_hld_data t
where t.sys_rs_id = 'YSSFA45' and t.p_dt between 20230101 and 20230531
group by t.p_dt, t.prd_code) t2 on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt
inner join ty_ods.o3_tfundinfo t3 on t1.prd_code = t3.vc_fund_code;

-- 获取净值差，份额差，现金流数据
select t1.p_dt, t1.prd_code, t5.prd_code, 
       t1.ttl_navl, t5.ttl_navl, t1.ttl_navl-t5.ttl_navl as diff_ttl_navl, 
       t1.ttl_shr, t5.ttl_shr, t1.ttl_shr-t5.ttl_shr as diff_ttl_shr,
       t4.capi_add, t4.capi_reduce
from (select * from ty_dwd.fin_prd_nav t where t.p_dt between 20230101 and 20230531 and t.sys_rs_id = 'DYCF') t1
inner join ty_dwd.pty_prd_base_info t2 on t1.prd_code = t2.prd_code and t2.prd_typ = '2'
inner join ty_dwd.trd_cald_dtl t3 on t1.p_dt = t3.cald_date and t3.cald_id = 1
left join ty_dwd.fin_prd_capi_chg t4 on t1.prd_code = t4.prd_code and t1.p_dt = t4.chg_dt
left join (select t.* from ty_dwd.fin_prd_nav t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2') t5 on t1.prd_code = t5.prd_code and t3.lst_cald_date = t5.p_dt and t1.sys_rs_id = t5.sys_rs_id
where t1.p_dt between 20230101 and 20230531
order by t1.p_dt, t1.prd_code;

select t1.p_dt, t1.prd_code, t5.prd_code, 
       t1.ttl_navl, t5.ttl_navl, t1.ttl_navl-t5.ttl_navl as diff_ttl_navl, 
       t1.ttl_shr, t5.ttl_shr, t1.ttl_shr-t5.ttl_shr as diff_ttl_shr,
       t4.capi_add, t4.capi_reduce,
       CASE WHEN nvl(t5.ttl_navl,0)-nvl(t4.capi_reduce,0)+nvl(t4.capi_add,0) = 0 THEN 0  
            ELSE (nvl(t1.ttl_navl,0)-nvl(t5.ttl_navl,0)+nvl(t4.capi_reduce,0)-nvl(t4.capi_add,0))/(nvl(t5.ttl_navl,0)-nvl(t4.capi_reduce,0)+nvl(t4.capi_add,0)) end AS ttl_daily_rate
from (select * from ty_dwd.fin_prd_nav t where t.p_dt between 20230301 and 20230531) t1
inner join ty_dwd.pty_prd_base_info t2 on t1.prd_code = t2.prd_code and t2.prd_typ = '2'
inner join ty_dwd.trd_cald_dtl t3 on t1.p_dt = t3.cald_date and t3.cald_id = 1
left join (select t.* from ty_dwd.fin_prd_capi_chg t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.chg_dt between 20230301 and 20230531) t4 on t1.prd_code = t4.prd_code and t1.p_dt = t4.chg_dt
left join (select t.* from ty_dwd.fin_prd_nav t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.p_dt between 20230224 and 20230531) t5 on t1.prd_code = t5.prd_code and t3.lst_cald_date = t5.p_dt
where t1.p_dt between 20230301 and 20230531
order by t1.prd_code, t1.p_dt;