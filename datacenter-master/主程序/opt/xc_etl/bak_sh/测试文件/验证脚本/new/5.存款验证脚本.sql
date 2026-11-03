-- 存款，考虑了投资类型、多空方向、资产状态、流通标识，会存在对不上的数据
select t1.prd_code, t2.prd_code, t1.secu_id, t2.secu_id, t1.pos_id, t2.pos_id, t1.sum_val, t2.sum_val, t1.sum_intr, t2.sum_intr 
from (
select prd_code, t.secu_id, t.inv_typ, t.cir_id, t.ast_stat, t.pos_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.p_dt between 20230504 and 20230504 and t.typ_code = 'DPSI' and t.secu_id <> 'DPSI101.DPSI.NONE' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t.secu_id, t.inv_typ, t.cir_id, t.ast_stat, t.pos_id) t1 
full join (
select split(t.prd_code,'_')[0] as prd_code, t.secu_id, t.inv_typ, t.cir_id, t.ast_stat, t.pos_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on split(t.prd_code,'_')[0] = t1.vc_fund_code
where t.p_dt between 20230504 and 20230504 and t.typ_code = 'DPSI' and t.secu_id <> 'DPSI101.DPSI.NONE' and t.sys_rs_id = 'DYCF'
group by split(t.prd_code,'_')[0], t.secu_id, t.inv_typ, t.cir_id, t.ast_stat, t.pos_id) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id 
   and t1.inv_typ = t2.inv_typ and t1.cir_id = t2.cir_id 
   and t1.ast_stat = t2.ast_stat 
   and t1.pos_id = t2.pos_id;

-- 存款，直接多天期的核对  
select t1.prd_code, t2.prd_code, t1.secu_id, t2.secu_id, t1.p_dt, t2.p_dt,
       t1.sum_vol, t2.sum_vol, t1.sum_vol - t2.sum_vol as diff_sum_vol,
       t1.sum_val, t2.sum_val, t1.sum_val - t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr - t2.sum_intr as diff_sum_intr
from (
select prd_code, t.secu_id, t.p_dt, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230531 and t.typ_code = 'DPSI' and t.secu_id <> 'DPSI101.DPSI.NONE' and t.sys_rs_id = 'YSSFA45'
group by t.prd_code, t.secu_id, t.p_dt) t1 
full join (
select split(t.prd_code,'_')[0] as prd_code, t.secu_id, t.p_dt, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t.p_dt between 20230101 and 20230531 and t.typ_code = 'DPSI' and t.secu_id <> 'DPSI101.DPSI.NONE' and t.sys_rs_id = 'DYCF'
group by split(t.prd_code,'_')[0], t.secu_id, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.p_dt = t2.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt,t2.p_dt) = tt.cald_date
order by t1.p_dt, t1.prd_code, t1.secu_id;