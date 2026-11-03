------------------------------------------------------------------------
-- 模块名称：产品净值信息--补充非交易日
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
----set spark.driver.memory=6G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;


insert overwrite table ${dwd_db}.fin_prd_nav partition(p_dt,sys_rs_id)
SELECT
b2.prd_code as prd_code
,B2.sub_code as sub_code
,b2.fofs_code fofs_code
,a2.cald_date as nav_dt
,b2.prd_typ prd_typ
,b2.ttl_navl ttl_navl
,b2.ttl_shr ttl_shr
,b2.unit_nval unit_nval
,B2.aggr_unit_nval as aggr_unit_nval
,B2.nav_add_rat as nav_add_rat
,B2.aggr_nav_add_rat as aggr_nav_add_rat
,B2.unit_yld as unit_yld
,B2.aggr_unit_yld_setp as aggr_unit_yld_setp
,B2.ann_yld_rat as ann_yld_rat
,B2.ttl_ast as ttl_ast
,B2.ttl_liab as ttl_liab
,B2.paid_capi as paid_capi
,B2.f_savc as f_savc
,B2.f_maty as f_maty
,B2.f_eval_dvat_val as f_eval_dvat_val
,B2.f_eval_dvat_rat as f_eval_dvat_rat
,B2.real_incm_d as real_incm_d
,B2.real_incm_m as real_incm_m
,B2.real_incm_y as real_incm_y
,B2.prfi_ttl as prfi_ttl
,B2.prftrd_unit as prftrd_unit
,B2.prftrd_loss_unreal as prftrd_loss_unreal
,B2.prftrd_loss_real as prftrd_loss_real
,B2.curr_code as curr_code
,B2.cash_nav_rat as cash_nav_rat
,B2.prd_stat as prd_stat
,B2.prd_stat_yest as prd_stat_yest
,B2.shr_add as shr_add
,B2.shr_reduce as shr_reduce
,B2.prd_rtn_yest as prd_rtn_yest
,B2.prfi_ttl_un as prfi_ttl_un
,B2.grt_val as grt_val
,B2.nav_mth_rat as nav_mth_rat
,B2.nav_year_rat as nav_year_rat
,b2.busi_date busi_date
,'fin_prd_nav_second_o32' task_rs_id
,CURRENT_TIMESTAMP dm_created_time
,B2.cash_pos as cash_pos
,B2.aggr_cadi_amt as aggr_cadi_amt
,B2.tot_secu_ivsm as tot_secu_ivsm
,B2.stk_ivsm as stk_ivsm
,B2.bond_ivsm as bond_ivsm
,B2.cvtb_ivsm as cvtb_ivsm
,B2.fnd_ivs as fnd_ivs
,B2.supp_dt as supp_dt
,'fin_prd_nav' dm_src_info
,a2.cald_date as p_dt 
,b2.sys_rs_id sys_rs_id
      from (
	  select b.prd_code, a.cald_date, a.lst_cald_date
            from ${dwd_db}.trd_cald_dtl a
            inner join ${dwd_db}.pty_prd_base_info b
            on 1 = 1
	    and B.sys_rs_id = 'DYCF'
          where a.cald_id = '1' AND A.IS_TRD_DT=0
              and a.cald_date >= b.found_dt
	      and a.cald_date <= b.end_dt
              and a.cald_date >= ${beg_date}
              and a.cald_date <= ${end_date}		  
	 ) a2
         left join ${dwd_db}.fin_prd_nav b2
                         on a2.prd_code = b2.prd_code and b2.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-15),'yyyyMMdd') and ${end_date} and b2.sys_rs_id = 'DYCF'						 
      where  a2.lst_cald_date=b2.nav_dt
	  
