-- 全量
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id, 
       t1.sum_vol, t2.sum_vol, t1.sum_vol-t2.sum_vol as diff_sum_vol,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.secu_id, t.p_dt,
       sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from (
select t.prd_code, t.p_dt, split(t.secu_id,'.')[0], 
       case when split(t.secu_id,'.')[0] in ('QSBFJ','JSBFJ','ZQQSK','QHBFJ','ZDBFJ','QHBZJ','CCBZJ') then 'DPSI101.DPSI.NONE' else t.secu_id end as secu_id,
       t.hld_vol, t.hld_val, t.accr_intr	   
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.sys_rs_id = 'YSSFA45' and (t.typ_code in ('CASH') or t1.typ_codei = 'DPSI101') and t.p_dt = 20230504) t
group by t.prd_code, t.secu_id, t.p_dt) t1
full join 
(select split(t.prd_code,'_')[0] as prd_code, t.p_dt, t.secu_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
where t.sys_rs_id  = 'DYCF' and (t.typ_code in ('CASH') or t1.typ_codei = 'DPSI101') and t.p_dt = 20230504
group by split(t.prd_code,'_')[0], t.secu_id, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.p_dt = t2.p_dt;

-- 管理端现金
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id, 
       t1.sum_vol, t2.sum_vol, t1.sum_vol-t2.sum_vol as diff_sum_vol,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.secu_id, t.p_dt,
       sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from (
select t.prd_code, t.p_dt, t.secu_id,
       t.hld_vol, t.hld_val, t.accr_intr	   
from ty_dwd.fin_prd_hld_data t
left join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.sys_rs_id = 'YSSFA45' and t.p_dt = 20230504
  and t2.trd_code in ('DTFY','GLF','TGF','XSFWF','YYFWF','YTFY','XXPLF','YJBC','TZGWF','SJF')) t
group by t.prd_code, t.secu_id, t.p_dt) t1
full join 
(select split(t.prd_code,'_')[0] as prd_code, t.p_dt, t.secu_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
left join ty_dwd.var_secu_info t1 on t.secu_id = t1.secu_id
where t.sys_rs_id  = 'DYCF_CASH' and t.p_dt = 20230504
  and t1.trd_code in ('DTFY','GLF','TGF','XSFWF','YYFWF','YTFY','XXPLF','YJBC','TZGWF','SJF')
group by split(t.prd_code,'_')[0], t.secu_id, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.p_dt = t2.p_dt;

-- 发行端现金
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id, 
       t1.sum_vol, t2.sum_vol, t1.sum_vol-t2.sum_vol as diff_sum_vol,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.secu_id, t.p_dt,
       sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from (
select t.prd_code, t.p_dt, t.secu_id,
       t.hld_vol, t.hld_val, t.accr_intr	   
from ty_dwd.fin_prd_hld_data t
left join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.sys_rs_id = 'YSSFA45' and t.p_dt = 20230504
  and t2.trd_code in ('YFLR','YFSHK','SHK','MJQLX','RGK', 'YSSGK')) t
group by t.prd_code, t.secu_id, t.p_dt) t1
full join 
(select split(t.prd_code,'_')[0] as prd_code, t.p_dt, t.secu_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
left join ty_dwd.var_secu_info t1 on t.secu_id = t1.secu_id
where t.sys_rs_id  = 'DYCF_CASH' and t.p_dt = 20230504
  and t1.trd_code in ('YFLR','YFSHK','SHK','MJQLX','RGK', 'YSSGK')
group by split(t.prd_code,'_')[0], t.secu_id, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.p_dt = t2.p_dt;

-- 投资端现金，未包含证券申购款
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id, 
       t1.sum_vol, t2.sum_vol, t1.sum_vol-t2.sum_vol as diff_sum_vol,
       t1.sum_val, t2.sum_val, t1.sum_val-t2.sum_val as diff_sum_val,
       t1.sum_intr, t2.sum_intr, t1.sum_intr-t2.sum_intr as diff_sum_intr
from (
select t.prd_code, t.secu_id, t.p_dt,
       sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from (
select t.prd_code, t.p_dt, t.secu_id,
       t.hld_vol, t.hld_val, t.accr_intr	   
from ty_dwd.fin_prd_hld_data t
left join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
where t.sys_rs_id = 'YSSFA45' and t.p_dt = 20230504
  and (t2.trd_code in ('JYBZJ','CCBZJ','FXJ','YSGPHL','YSJJHL') or 
       (t2.TYP_CODE = 'CASH' AND t2.TRD_CODE NOT IN ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','CCBZJ','DTFY','GLF','TGF','XSFWF','YYFWF',
	   'YTFY','XXPLF','YJBC','TZGWF','SJF','MJQLX','RGK', 'YSSGK','YFSHK','SHK','YFLR','JYBZJ','FXJ','CXXJ')))) t
group by t.prd_code, t.secu_id, t.p_dt) t1
full join 
(select split(t.prd_code,'_')[0] as prd_code, t.p_dt, t.secu_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
left join ty_dwd.var_secu_info t1 on t.secu_id = t1.secu_id
where t.sys_rs_id  = 'DYCF_CASH' and t.p_dt = 20230504
  and (t1.trd_code in ('JYBZJ','CCBZJ','FXJ','YSGPHL','YSJJHL') or t1.trd_code <> 'ZQSGK' or
       (t1.TYP_CODE = 'CASH' AND t1.TRD_CODE NOT IN ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','CCBZJ','DTFY','GLF','TGF','XSFWF','YYFWF',
	   'YTFY','XXPLF','YJBC','TZGWF','SJF','MJQLX','RGK', 'YSSGK','YFSHK','SHK','YFLR','JYBZJ','FXJ','CXXJ')))
group by split(t.prd_code,'_')[0], t.secu_id, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.p_dt = t2.p_dt;

-- 活期存款：
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.secu_id, t2.secu_id,
       t1.sum_vol, t2.sum_vol, tt.sum_vol, t1.sum_vol-t2.sum_vol-coalesce(tt.sum_vol,0) as diff_sum_vol,
       t1.sum_val, t2.sum_val, tt.sum_val, t1.sum_val-t2.sum_val-coalesce(tt.sum_val,0) as diff_sum_val,
       t1.sum_intr, t2.sum_intr, tt.sum_intr, t1.sum_intr-t2.sum_intr-coalesce(tt.sum_intr,0) as diff_sum_intr
from (
select t.prd_code, 'DPSI101.DPSI.NONE' as secu_id, t.p_dt,
       sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from (
select t.prd_code, t.p_dt, t.secu_id,
       t.hld_vol, t.hld_val, t.accr_intr	   
from ty_dwd.fin_prd_hld_data t
left join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.pty_prd_base_info t3 on t.prd_code = t3.prd_code and t3.prd_typ = '1'
where t.sys_rs_id = 'YSSFA45' and t.p_dt = 20230504 and t2.trd_code in ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','QSJSBFJ')
and t2.exch_code not in('CFFEX','SHFE')) t
group by t.prd_code, t.p_dt) t1
left join (select t1.prd_code, t.p_dt, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.acc_asset_unit_info t1 on t.prd_code = t1.ast_unit_code
where t.sys_rs_id = 'DYCF' and t.secu_id like 'ZQSGK%' and t.p_dt between 20230504 and 20230504
group by t1.prd_code, t.p_dt) tt on t1.prd_code = tt.prd_code and t1.p_dt = tt.p_dt
full join 
(select split(t.prd_code,'_')[0] as prd_code, t.p_dt, 'DPSI101.DPSI.NONE' as secu_id, sum(hld_vol) as sum_vol, sum(t.hld_val) as sum_val, sum(t.accr_intr) as sum_intr
from ty_dwd.fin_prd_hld_data t 
left join ty_dwd.var_secu_info t1 on t.secu_id = t1.secu_id
where t.sys_rs_id  = 'DYCF_CASH' and t.p_dt = 20230504 and t1.trd_code = 'DPSI101'
group by split(t.prd_code,'_')[0], t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt;

-- 现金类整理核对
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt,
       t1.val_cash, t2.val_cash, t1.val_cash-t2.val_cash as diff_val_cash
from (
select t.prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as val_cash 
from ty_dwd.fin_prd_hld_data t 
inner join ty_ods.o3_tfundinfo t1 on t.prd_code = t1.vc_fund_code
inner join ty_dwd.pty_prd_base_info t3 on t.prd_code = t3.prd_code and t3.prd_typ = '1'
where t.typ_code in ('DPSI','CASH') and t.p_dt between 20230501 and 20230531
group by t.prd_code, t.p_dt) t1 
full join
(
select t3.fofs_code as prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as val_cash 
from ty_dwd.fin_prd_hld_data t 
inner join ty_dwd.pty_prd_base_info t3 on t.prd_code = t3.prd_code and t3.prd_typ = '2'
where t.typ_code in ('DPSI','CASH') and t.p_dt between 20230501 and 20230531
group by t3.fofs_code, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt, t2.p_dt) = tt.cald_date
order by t1.prd_code, t1.p_dt

-- 现金类具体记录核对
------ 排除现金存款
select t1.fofs_code, t2.prd_code, t1.secu_id, t2.secu_id,
       t1.hld_vol, t2.hld_vol, t1.hld_vol-t2.hld_vol as diff_hld_vol,
       t1.hld_val, t2.hld_val, t1.hld_val-t2.hld_val as diff_hld_val,
       t1.accr_intr, t2.accr_intr, t1.accr_intr-t2.accr_intr as diff_accr_intr
from (
select t1.fofs_code, t.secu_id, t.pos_id, sum(t.hld_vol) as hld_vol, sum(hld_val) as hld_val, sum(accr_intr) as accr_intr, t.p_dt 
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t2.typ_code in ('CASH','DPSI') and t.secu_id <> 'DPSI101.DPSI.NONE' 
  and t2.trd_code not in ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','QSJSBFJ','ZQSGK')
  and t.p_dt between 20230101 and 20230531
group by t1.fofs_code, t.secu_id, t.pos_id, t.p_dt) t1
full join (
select t.* from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '1'
inner join ty_dwd.var_secu_info t2 on t.secu_id = t2.secu_id
where t2.typ_code in ('CASH','DPSI') and t.secu_id <> 'DPSI101.DPSI.NONE' 
  and t2.trd_code not in ('QSBFJ','JSBFJ','ZQQSK','DPSI101','QHBFJ','ZDBFJ','QHBZJ','QSJSBFJ','ZQSGK')
  and t.p_dt between 20230101 and 20230531) t2
on t1.fofs_code = t2.prd_code and t1.secu_id = t2.secu_id and t1.pos_id = t2.pos_id and t1.p_dt = t2.p_dt
where coalesce(t1.fofs_code, t2.prd_code) = 343689 and coalesce(t1.p_dt, t2.p_dt) = 20230227;