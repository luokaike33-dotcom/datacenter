-- 估值本身核对，产品持仓回购数据和产品回购明细表数据核对
select t1.prd_code, t2.prd_code, t1.hld_dt, t2.hld_dt, t1.pos_id, t2.pos_id,
       t1.sum_mval, t2.sum_mval, t1.sum_mval-t2.sum_mval as diff_sum_mval,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.hld_dt, t.pos_id, sum(hld_vol) as sum_vol, sum(hld_mval) as sum_mval, sum(accr_int) as sum_intr
from ty_dwd.fin_prd_repo_hld t 
where t.sys_rs_id = 'YSSFA45' and t.p_dt between 20230101 and 20230531
group by t.prd_code, t.hld_dt, t.pos_id
order by t.prd_code, t.hld_dt, t.pos_id) t1
full join (
select t.prd_code, t.hld_dt, t.pos_id, sum(hld_val) as sum_mval, sum(accr_intr) as sum_intr 
from ty_dwd.fin_prd_hld_data t where t.sys_rs_id = 'YSSFA45' and t.p_dt between 20230101 and 20230531 and t.typ_code = 'REPO'
group by t.prd_code, t.hld_dt, t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.hld_dt = t2.hld_dt and t1.pos_id = t2.pos_id
where t1.sum_mval-t2.sum_mval <> 0 or t1.sum_intr-t2.sum_intr <> 0;

-- 不同维度的回购数据对比
-- 由于估值本身的产品持仓表回购数据和产品回购明细表数据存在差异，故核对时直接产品持仓表的数据进行对比
-- 1.产品回购持仓对比:按市场、多空方向维度汇总对比，单天维度
select t1.prd_code, t2.prd_code, t1.exch_code, t2.exch_code, t1.pos_id, t2.pos_id, 
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
	   t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr 
from (
select prd_code, t2.exch_code, t.pos_id, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230504 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t2.exch_code, t.pos_id) t1 
full join (
select t1.fofs_code as prd_code, t2.exch_code, t.pos_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230504 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'DYCF'
group by t1.fofs_code, t2.exch_code, t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.pos_id = t2.pos_id and t1.exch_code = t2.exch_code
order by coalesce(t1.prd_code,t2.prd_code), coalesce(t1.exch_code,t2.exch_code), coalesce(t1.pos_id,t2.pos_id);

-- 2.产品回购持仓对比:按市场、多空方向维度汇总对比，多天维度
select t1.p_dt, t2.p_dt, t1.prd_code, t2.prd_code, t1.exch_code, t2.exch_code, t1.pos_id, t2.pos_id, 
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
	   t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr 
from (
select t.p_dt, t.prd_code, t2.exch_code, t.pos_id, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45'
group by t.p_dt, t.prd_code, t2.exch_code, t.pos_id) t1 
full join (
select t.p_dt, t1.fofs_code as prd_code, t2.exch_code, t.pos_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'DYCF'
group by t.p_dt, t1.fofs_code, t2.exch_code, t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.pos_id = t2.pos_id and t1.exch_code = t2.exch_code and t1.p_dt = t2.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt,t2.p_dt) = tt.cald_date
order by coalesce(t1.p_dt,t2.p_dt), coalesce(t1.prd_code,t2.prd_code), coalesce(t1.exch_code,t2.exch_code), coalesce(t1.pos_id,t2.pos_id);

-- 3.明细对比数据
-- 3.1 交易所
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id, t1.pos_id, t2.pos_id,
	   t1.hld_cost, t2.hld_cost, t1.hld_cost-t2.hld_cost as diff_hld_cost,
	   t1.hld_val, t2.hld_val, t1.hld_val-t2.hld_val as diff_hld_val,
	   t1.accr_intr, t2.accr_intr, t1.accr_intr-t2.accr_intr as diff_accr_intr
from (
select t.prd_code, t.p_dt, t.secu_id, t.pos_id, sum(t.hld_cost) as hld_cost, sum(hld_val) as hld_val, sum(accr_intr) as accr_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.pty_prd_base_info t3 on t.prd_code = t3.prd_code and t3.prd_typ = '1'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45' and t2.exch_code in ('SH','SZ')
group by t.prd_code, t.secu_id, t.pos_id, t.p_dt) t1
full join(
select t1.fofs_code as prd_code, t.p_dt, t.secu_id, t.pos_id, sum(t.hld_cost) as hld_cost, sum(hld_val) as hld_val, sum(accr_intr) as accr_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230504 and t2.typ_code = 'REPO' and t.sys_rs_id = 'DYCF' and t2.exch_code in ('SH','SZ')
group by t1.fofs_code, t.secu_id, t.pos_id, t.p_dt) t2
on t1.secu_id = t2.secu_id and t1.pos_id = t2.pos_id and t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt,t2.p_dt) = tt.cald_date
order by coalesce(t1.p_dt,t2.p_dt),coalesce(t1.prd_code,t2.prd_code),coalesce(t1.secu_id,t2.secu_id),coalesce(t1.pos_id,t2.pos_id);
   

-- 产品回购持仓对比:按产品
-- 回购持仓明细对比：
-- 按品种
-- 不区分品种
-- 产品层，核对更不准
-- 产品层，和产品持仓对比

-- 多天期验证
-- 结果：差异数据较多，需要具体分析
select t1.prd_code, t2.prd_code, t1.hld_dt, t2.hld_dt, t1.pos_id, t2.pos_id,
       t1.sum_mval, t2.sum_mval, t1.sum_mval-t2.sum_mval as diff_sum_mval,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.hld_dt, t.pos_id, sum(hld_vol) as sum_vol, sum(hld_val) as sum_mval, sum(accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.sys_rs_id = 'YSSFA45' and t.p_dt between 20230504 and 20230531 and t.typ_code = 'REPO'
group by t.prd_code, t.hld_dt, t.pos_id
order by t.prd_code, t.hld_dt, t.pos_id) t1
full join (
select prd_code_1 as prd_code, t.hld_dt, t.pos_id, sum(hld_vol) as sum_vol, sum(hld_mval) as sum_mval, sum(accr_int) as sum_intr from
(select split(t.prd_code,'_')[0] as prd_code_1, t.* from ty_dwd.fin_prd_repo_hld t where t.sys_rs_id = 'DYCF' and t.p_dt between 20230504 and 20230531) t 
group by prd_code_1, t.hld_dt, t.pos_id
order by prd_code_1, t.hld_dt, t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.hld_dt = t2.hld_dt and t1.pos_id = t2.pos_id
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on t1.hld_dt = tt.cald_date
order by t1.prd_code, t1.hld_dt, t1.pos_id;
-- 多天期，按市场分开对比
select t1.prd_code, t2.prd_code, t1.pos_id, t2.pos_id, t1.exch_code, t2.exch_code, t1.hld_dt, t2.hld_dt,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr 
from (
select prd_code, t.hld_dt,t.pos_id, t.exch_code, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.p_dt between 20230501 and 20230531 and t.typ_code = 'REPO' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t.hld_dt, t.pos_id, t.exch_code
order by t.prd_code, t.hld_dt, t.pos_id, t.exch_code) t1 
full join (
select t2.fofs_code as prd_code, t.hld_dt, t.pos_id, t.exch_code, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t2 on t.prd_code = t2.prd_code and t2.prd_typ = '2'
where t.p_dt between 20230501 and 20230531 and t.typ_code = 'REPO' and t.sys_rs_id = 'DYCF'
group by t2.fofs_code, t.hld_dt, t.pos_id, t.exch_code) t2
on t1.prd_code = t2.prd_code and t1.pos_id = t2.pos_id and t1.hld_dt = t2.hld_dt and t1.exch_code = t2.exch_code
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.hld_dt,t2.hld_dt) = tt.cald_date
order by coalesce(t1.prd_code,t2.prd_code), coalesce(t1.hld_dt,t2.hld_dt), coalesce(t1.pos_id,t2.pos_id), coalesce(t1.exch_code,t2.exch_code);

-- 产品持仓层的按市场、品种维度对比数据
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