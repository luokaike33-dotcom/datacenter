-- 考虑投资类型、资产状态、多空标识、流通标识
--set hive.vectorized.execution.enabled=false;
--set hive.strict.checks.type.safety=false;
--set hive.exec.dynamic.partition.mode=nonstrict;
--set hive.execution.engine=spark;
--set hive.exec.max.dynamic.partitions.pernode=10000;
--set hive.exec.max.dynamic.partitions=10000;
--set hive.exec.max.created.files=10000;
--set hive.merge.sparkfiles=true;
--set hive.optimize.sort.dynamic.partition=true;
--set hive.merge.orcfile.stripe.level=false;
--set spark.memory.fraction=0.8;
--set hive.exec.dynamic.partition=true;
--set hive.crud.dynamic.partition=true;
--set spark.driver.memory=2G;
--set hive.auto.convert.join=true;


-- 不考虑投资类型、流通标识，20230626这一天
select t1.prd_code, t2.prd_code,
       t1.p_dt, t2.p_dt,
       t1.secu_id, t2.secu_id,
       t1.pos_id, t2.pos_id,
       t1.ast_stat, t2.ast_stat,
       t1.hld_vol, t2.hld_vol,
       t1.hld_vol-t2.hld_vol as diff_hld_vol,
       t1.vou_typ
from 
(select     t1.prd_code as prd_code,
            t1.p_dt as p_dt,
            t1.secu_id as secu_id,
            t1.pos_id as pos_id,
            t1.var_stat as ast_stat,
            concat_ws(',',collect_set(t1.vou_typ)) as vou_typ,
            sum(t1.tnv_vol) as hld_vol
       from ty_dwd.fin_prd_astrd_trd t1
      inner join ty_dwd.trd_cald_dtl tt on t1.p_dt = tt.cald_date and tt.cald_id = '1'
      where t1.typ_code <> 'CASH'
        and t1.typ_codei <> 'DPSI101'
        and t1.sys_rs_id <> 'YSSFA45'
        and t1.p_dt>=20230626
        and t1.p_dt<=20230626
      group by t1.prd_code, t1.p_dt, t1.secu_id, t1.pos_id, t1.var_stat
        having sum(t1.tnv_vol) <> 0) t1
full join (
select nvl(t1.prd_code, t2.prd_code) as prd_code,
       nvl(t1.p_dt, t2.next_cald_date) as p_dt,
       nvl(t1.secu_id, t2.secu_id) as secu_id,
       nvl(t1.pos_id, t2.pos_id) as pos_id,
       nvl(t1.ast_stat, t2.ast_stat) as ast_stat,
       nvl(t1.hld_vol,0) - nvl(t2.hld_vol, 0) as hld_vol
from (select t1.prd_code,
           t1.p_dt,
           max(tt.lst_cald_date) as pre_cald_date,
           t1.secu_id,
           t1.pos_id,
           t1.ast_stat,
           '' as vou_typ,
           sum(t1.hld_vol) as hld_vol
      from ty_dwd.fin_prd_hld_info t1
      inner join ty_dwd.trd_cald_dtl tt on t1.p_dt = tt.cald_date and tt.cald_id = '1'
     where t1.typ_code <> 'CASH'
       and t1.typ_codei <> 'DPSI101'
	   and t1.sys_rs_id <> 'YSSFA45'
       and t1.p_dt>=20230626
       and t1.p_dt<=20230626
     group by t1.prd_code, t1.p_dt, t1.secu_id, t1.pos_id, t1.ast_stat) t1
full join (select t2.prd_code,
                t2.p_dt,
                max(tt.next_cald_date) as next_cald_date,
                t2.secu_id,
                t2.pos_id,
                t2.ast_stat,
                '' as vou_typ,
                sum(t2.hld_vol) as hld_vol
           from ty_dwd.fin_prd_hld_info t2
           inner join ty_dwd.trd_cald_dtl tt on t2.p_dt = tt.cald_date and tt.cald_id = '1'
          where t2.typ_code <> 'CASH'
            and t2.typ_codei <> 'DPSI101'
	        and t2.sys_rs_id <> 'YSSFA45'
            and t2.p_dt>=20230621
            and t2.p_dt<=20230621
          group by t2.prd_code, t2.p_dt, t2.secu_id, t2.pos_id, t2.ast_stat) t2
on t1.prd_code = t2.prd_code
and t1.pre_cald_date = t2.p_dt
and t1.secu_id = t2.secu_id
and t1.ast_stat = t2.ast_stat
and t1.pos_id = t2.pos_id
where nvl(t1.hld_vol,0) - nvl(t2.hld_vol, 0) <> 0) t2 
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt and t1.secu_id = t2.secu_id 
 and t1.pos_id = t2.pos_id and t1.ast_stat = t2.ast_stat
order by coalesce(t1.p_dt,t2.p_dt), coalesce(t1.prd_code,t2.prd_code);

-- 不考虑投资类型、流通标识，20230104-20230707区间内的交易数据
select t1.prd_code, t2.prd_code,
       t1.p_dt, t2.p_dt,
       t1.secu_id, t2.secu_id,
       t1.pos_id, t2.pos_id,
       t1.ast_stat, t2.ast_stat,
       t1.hld_vol, t2.hld_vol,
       t1.hld_vol-t2.hld_vol as diff_hld_vol,
       t1.vou_typ
from 
(select     t1.prd_code as prd_code,
            t1.p_dt as p_dt,
            t1.secu_id as secu_id,
            t1.pos_id as pos_id,
            t1.var_stat as ast_stat,
            concat_ws(',',collect_set(t1.vou_typ)) as vou_typ,
            sum(t1.tnv_vol) as hld_vol
       from ty_dwd.fin_prd_astrd_trd t1
      inner join ty_dwd.trd_cald_dtl tt on t1.p_dt = tt.cald_date and tt.cald_id = '1' and tt.is_trd_dt = '1'
      where nvl(t1.typ_code,'0') <> 'CASH'
        and nvl(t1.typ_codei,'0') <> 'DPSI101'
        and t1.sys_rs_id <> 'YSSFA45'
        and t1.p_dt>=20230104
        and t1.p_dt<=20230707
      group by t1.prd_code, t1.p_dt, t1.secu_id, t1.pos_id, t1.var_stat
        having sum(t1.tnv_vol) <> 0) t1
full join (
select nvl(t1.prd_code, t2.prd_code) as prd_code,
       nvl(t1.p_dt, t2.next_cald_date) as p_dt,
       nvl(t1.secu_id, t2.secu_id) as secu_id,
       nvl(t1.pos_id, t2.pos_id) as pos_id,
       nvl(t1.ast_stat, t2.ast_stat) as ast_stat,
       nvl(t1.hld_vol,0) - nvl(t2.hld_vol, 0) as hld_vol
from (select t1.prd_code,
           t1.p_dt,
           max(tt.lst_cald_date) as pre_cald_date,
           t1.secu_id,
           t1.pos_id,
           t1.ast_stat,
           '' as vou_typ,
           sum(t1.hld_vol) as hld_vol
      from ty_dwd.fin_prd_hld_info t1
      inner join ty_dwd.trd_cald_dtl tt on t1.p_dt = tt.cald_date and tt.cald_id = '1' and tt.is_trd_dt = '1'
     where nvl(t1.typ_code,'0') <> 'CASH'
       and nvl(t1.typ_codei,'0') <> 'DPSI101'
	   and t1.sys_rs_id <> 'YSSFA45'
       and t1.p_dt>=20230104
       and t1.p_dt<=20230707
     group by t1.prd_code, t1.p_dt, t1.secu_id, t1.pos_id, t1.ast_stat) t1
full join (select t2.prd_code,
                t2.p_dt,
                max(tt.next_cald_date) as next_cald_date,
                t2.secu_id,
                t2.pos_id,
                t2.ast_stat,
                '' as vou_typ,
                sum(t2.hld_vol) as hld_vol
           from ty_dwd.fin_prd_hld_info t2
           inner join ty_dwd.trd_cald_dtl tt on t2.p_dt = tt.cald_date and tt.cald_id = '1' and tt.is_trd_dt = '1'
          where nvl(t2.typ_code,'0') <> 'CASH'
            and nvl(t2.typ_codei,'0') <> 'DPSI101'
	        and t2.sys_rs_id <> 'YSSFA45'
            and t2.p_dt>=20230103
            and t2.p_dt<=20230706
          group by t2.prd_code, t2.p_dt, t2.secu_id, t2.pos_id, t2.ast_stat) t2
on t1.prd_code = t2.prd_code
and t1.pre_cald_date = t2.p_dt
and t1.secu_id = t2.secu_id
and t1.ast_stat = t2.ast_stat
and t1.pos_id = t2.pos_id
where nvl(t1.hld_vol,0) - nvl(t2.hld_vol, 0) <> 0) t2 
on t1.prd_code = t2.prd_code and t1.p_dt = t2.p_dt and t1.secu_id = t2.secu_id 
 and t1.pos_id = t2.pos_id and t1.ast_stat = t2.ast_stat
where coalesce(t1.p_dt,t2.p_dt) >= 20230104 and (t1.prd_code is null or t2.prd_code is null or t1.hld_vol-t2.hld_vol <> 0 or t1.hld_vol is null or t2.hld_vol is null)
  and coalesce(t1.secu_id,t2.secu_id) <> '600568.STK.SH'
order by coalesce(t1.p_dt,t2.p_dt), coalesce(t1.prd_code,t2.prd_code), coalesce(t1.pos_id,t2.pos_id), coalesce(t1.ast_stat,t2.ast_stat);




--hive查询L0数据
--产品持仓
select * from fin_prd_hld_data 
where p_dt BETWEEN 20230531 AND 20230601
and prd_code like '341199_34119900%'
and secu_id like '%300638%'
;
--网下清算
select * from evt_ofle_clea_jour_his
where p_dt BETWEEN 20230317 AND 20230317
and prd_code like '007449%'
and secu_id like '%002881%'
;
--场外清算
select * from evt_otc_clea_jour_his
where p_dt in (20230621,20230626)
and prd_code = '343692'
and secu_id like '%301280%'
;
--银行间清算
select * from evt_inbk_clea_jour_his
where p_dt BETWEEN 20230103 AND 20230104
and prd_code = '000575'
and secu_id like '%R030%'
;
--结算清算
select * from evt_sett_clea_jour_his
where p_dt BETWEEN 20230601 AND 20230601
and prd_code like '341199%'
and secu_id like '%300638%'
;
--交易所清算
select * from evt_exch_clea_jour_his
where p_dt BETWEEN 20230406 AND 20230407
--AND BUSI_CLAS = '20000100'
and prd_code = '343700'
and secu_id like '%159607%'
;
--产品交易
select * from fin_prd_astrd_trd
where p_dt BETWEEN 20230601 AND 20230601
and prd_code like '341199_34119900%'
and secu_id like '%300638%'
;
--交易单元持仓
select * from ast_unit_secu_bal_his
where p_dt >= 20230620
and prd_code = '004919'
and secu_id like '%115563%'
order by p_dt
;



--ORACLE查询数据
--查询O3持仓
select T1.* 
from trade.thisunitstock t1
left join trade.tfundinfo t2
on t1.l_fund_id = t2.l_fund_id
left join trade.tstockinfo t3
on t1.vc_inter_code = t3.vc_inter_code
LEFT JOIN TRADE.THISRESTRICTEDSTOCK T5
ON T1.L_DATE = T5.L_DATE
AND T1.L_UNIT_ID = T5.L_UNIT_ID
where  t1.l_date BETWEEN 20230619 AND 20230620
and t2.vc_fund_code = '501215'
and t3.VC_ASSIGN_CODE like '%688507%'
;


--查询O3交易流水
select T1.L_BUSIN_AMOUNT,T4.VC_BUSIN_CAPTION,T1.VC_SUMMARY,t1.* 
from trade.thiscurrents t1
left join trade.tfundinfo t2
on t1.l_fund_id = t2.l_fund_id
left join trade.tstockinfo t3
on t1.vc_inter_code = t3.vc_inter_code
LEFT JOIN TRADE.TBUSINFLAG T4
ON T1.L_BUSIN_FLAG = T4.L_BUSIN_FLAG
where  t1.l_date BETWEEN 20230619 AND 20230620
and t2.vc_fund_code = '501215'
and t3.VC_ASSIGN_CODE like '%688507%'
;