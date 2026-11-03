-- 总净值核对，限定某一天数据进行对比：
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt,
       t1.tot_val, t2.tot_val, t1.tot_val-t2.tot_val as diff_tot_val
from (
select t.prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '1'
inner join ty_ods.o3_tfundinfo t2 on t.prd_code = t2.vc_fund_code
where t.p_dt between 20230504 and 20230504
group by t.prd_code, t.p_dt) t1
full join (
select t1.fofs_code as prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.p_dt between 20230504 and 20230504
group by t1.fofs_code, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt;

-- 多天的核对，估值产品持仓汇总数据和单元产品持仓汇总数据对比
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt,
      t1.tot_val, t2.tot_val, t1.tot_val-t2.tot_val as diff_tot_val
from (
select t.prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '1'
inner join ty_ods.o3_tfundinfo t2 on t.prd_code = t2.vc_fund_code
where t.p_dt between 20230101 and 20230531
group by t.prd_code, t.p_dt) t1
full join (
select t1.fofs_code as prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.p_dt between 20230101 and 20230531
group by t1.fofs_code, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt, t2.p_dt) = tt.cald_date
inner join (  -- 过滤估值和交易不同做账的日期的数据
select t.prd_code, max(t.p_dt) as p_dt from (
select t1.vc_fund_code as prd_code, min(t.p_dt) as p_dt from ty_ods.o3_thisassetday t
inner join ty_ods.o3_tfundinfo t1 on t.l_fund_id = t1.l_fund_id
where t.en_current_cash <> 0
group by t1.vc_fund_code
union all
select t.c_port_code as prd_code, min(t.p_dt) from ty_ods.fa45_vf_report_val t group by t.c_port_code) t group by t.prd_code) ty 
on coalesce(t1.prd_code, t2.prd_code) = ty.prd_code
where coalesce(t1.p_dt, t2.p_dt) >= ty.p_dt
order by coalesce(t1.p_dt,t2.p_dt), coalesce(t1.prd_code,t2.prd_code);

-- 多天的核对，估值净值表数据和单元产品持仓汇总数据对比
-- 已经补充了虚拟产品数据，去掉估值和交易不同产品日期的条件限制
select t1.prd_code, t2.prd_code, t3.prd_code, t1.p_dt, t2.p_dt, t3.p_dt,
      t1.tot_val, t2.tot_val, t3.tot_val, 
      case when t2.tot_val is null and t3.tot_val is null then null 
           when t1.tot_val is null then null
           else nvl(t1.tot_val,0)-nvl(t2.tot_val,0)-nvl(t3.tot_val,0) end as diff_tot_val
from (
select t.prd_code, t.p_dt, t.ttl_navl as tot_val
from ty_dwd.fin_prd_nav t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '1'
inner join ty_ods.o3_tfundinfo t2 on t.prd_code = t2.vc_fund_code
where t.p_dt between 20230101 and 20230705) t1
full join (
select t1.fofs_code as prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.p_dt between 20230101 and 20230705 and t.prd_code not like '%_XC%'
group by t1.fofs_code, t.p_dt) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt
full join (
select t1.fofs_code as prd_code, t.p_dt, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
inner join ty_ods.o3_tfundinfo t2 on t1.fofs_code = t2.vc_fund_code
where t.p_dt between 20230101 and 20230705 and t.prd_code like '%_XC%'
group by t1.fofs_code, t.p_dt) t3
on coalesce(t1.prd_code,t2.prd_code) = t3.prd_code and coalesce(t1.p_dt,t2.p_dt) = t3.p_dt
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt, t2.p_dt, t3.p_dt) = tt.cald_date
-- inner join (  -- 过滤估值和交易不同做账的日期的数据
-- select t.prd_code, max(t.p_dt) as p_dt from (
-- select t1.vc_fund_code as prd_code, min(t.p_dt) as p_dt from ty_ods.o3_thisassetday t
-- inner join ty_ods.o3_tfundinfo t1 on t.l_fund_id = t1.l_fund_id
-- where t.en_current_cash <> 0
-- group by t1.vc_fund_code
-- union all
-- select t.c_port_code as prd_code, min(t.p_dt) from ty_ods.fa45_vf_report_val t group by t.c_port_code) t group by t.prd_code) ty 
-- on coalesce(t1.prd_code, t2.prd_code) = ty.prd_code
-- where coalesce(t1.p_dt, t2.p_dt) >= ty.p_dt and coalesce(t1.prd_code,t2.prd_code) = 009611
order by coalesce(t1.p_dt,t2.p_dt,t3.p_dt), coalesce(t1.prd_code,t2.prd_code,t3.prd_code);

-- 多天期市值核对，按证券大类进行核对
select t1.prd_code, t2.prd_code, t1.p_dt, t2.p_dt, t1.typ_code, t2.typ_code,
       t1.tot_val, t2.tot_val, t1.tot_val-t2.tot_val as diff_tot_val
from (
select t.prd_code, t.p_dt, t.typ_code, sum(t.hld_val+ case when t.typ_code = 'STK' then 0 else t.accr_intr end) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '1'
inner join ty_ods.o3_tfundinfo t2 on t.prd_code = t2.vc_fund_code
where t.p_dt between 20230501 and 20230531
group by t.prd_code, t.p_dt, t.typ_code) t1
full join (
select t1.fofs_code as prd_code, t.p_dt, t.typ_code, sum(t.hld_val+t.accr_intr) as tot_val
from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
where t.p_dt between 20230501 and 20230531
group by t1.fofs_code, t.p_dt, t.typ_code) t2
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt and t1.typ_code = t2.typ_code
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t1.p_dt, t2.p_dt) = tt.cald_date
-- where t1.prd_code = '010673' and t1.p_dt = 20230522
order by t1.p_dt, t1.prd_code;

-- 估值和交易存在差异的数据
select t1.prd_code, t2.prd_code, t1.jy_p_dt, t2.gz_p_dt
from (
select t1.vc_fund_code as prd_code, min(t.p_dt) as jy_p_dt from ty_ods.o3_thisassetday t
inner join ty_ods.o3_tfundinfo t1 on t.l_fund_id = t1.l_fund_id
where t.en_current_cash <> 0
group by t1.vc_fund_code) t1
full join
(select t.c_port_code as prd_code, min(t.p_dt) as gz_p_dt from ty_ods.fa45_vf_report_val t group by t.c_port_code) t2
on t1.prd_code = t2.prd_code 
where t1.jy_p_dt <> t2.gz_p_dt and t1.jy_p_dt >= 20230101 and t2.gz_p_dt >= 20230101

-- 单元层的持仓汇总净值和净值表数据核对
select t.p_dt, t1.p_dt, t.prd_code, t1.prd_code,
      t.ttl_navl, t1.ttl_navl, t.ttl_navl-t1.ttl_navl as diff_ttl_nval
from ty_dwd.fin_prd_nav t
inner join (
select t.p_dt, t.prd_code, sum(t.hld_val+t.accr_intr) as ttl_navl from ty_dwd.fin_prd_hld_data t
inner join ty_dwd.pty_prd_base_info t1 on t.prd_code = t1.prd_code and t1.prd_typ = '2'
group by t.p_dt, t.prd_code) t1 on t.prd_code = t1.prd_code and t.p_dt = t1.p_dt
inner join ty_dwd.pty_prd_base_info t2 on t.prd_code = t2.prd_code and t2.prd_typ = '2'
inner join (select * from ty_dwd.trd_cald_dtl t where t.cald_id = '1' and t.is_trd_dt = '1') tt on coalesce(t.p_dt, t1.p_dt) = tt.cald_date
where t.p_dt >= 20230101 and t.p_dt <= 20230131
order by t.p_dt, t.prd_code;  