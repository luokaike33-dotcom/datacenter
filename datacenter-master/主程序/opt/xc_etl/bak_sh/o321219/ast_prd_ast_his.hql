-------------------------------------------------------------------------
  -- 模块名称：产品资产信息表
-------------------------------------------------------------------------
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

alter table ${dwd_db}.ast_prd_ast_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

with tmp as (
    select
    CASE WHEN count(*)  =1
    THEN
    nvl(a.vc_value,'0')
    ELSE
   (
    nvl(b.tmp,'0')
    )
    END as numbers
    from ${ods_db}.o3_torgsysparameter a
    left join (SELECT CASE WHEN  count(*) =1
    THEN
    nvl(a.vc_value,'0')
    ELSE  '0' END  as tmp
    FROM   ${ods_db}.o3_tsysparameter a
    where a.l_serial_no = 62244
    GROUP BY a.vc_value ) b
    on 1=1
    where a.l_serial_no = 62244 and a.l_org_id = 0
    group by a.vc_value,b.tmp
    ),
O3_VHISFUNDASSET AS (
  select a.l_date l_date,
       a.l_fund_id l_fund_id,
       b.vc_currency_no vc_currency_no,
                  sum(cast(nvl(a.en_begin_cash, 0) as double) * cast(nvl(c.hl, 1) as double)) en_begin_cash,
                  sum(cast(nvl(a.en_current_cash, 0) as double) * cast(nvl(c.hl, 1) as double)) en_current_cash,
                  sum(cast(nvl(a.en_basic_frozen_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_basic_frozen_balance,
                  sum(cast(nvl(a.en_prebuy_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_prebuy_balance,
                  sum(cast(nvl(a.en_presale_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_presale_balance,
                  sum(cast(nvl(a.en_buy_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_balance,
                  sum(cast(nvl(a.en_sale_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_balance,
                  sum(cast(nvl(a.en_buy_unsettle_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_unsettle_balance,
                  sum(cast(nvl(a.en_sale_unsettle_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_unsettle_balance,
                  sum(cast(nvl(a.en_other_expense, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_expense,
                  sum(cast(nvl(a.en_other_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_profit,
                  sum(cast(nvl(a.en_interest_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_balance,
                  case when tmp.numbers='0' then (
       case
         when instr(',HK1,HK2,',
                    CONCAT(',' , max(nvl(a.vc_currency_no, 'CNY')) , ',')) > 0 then
           ( case when  min(nvl(b.c_ggtgzjgxs_mode, '1'))='1'
                then  sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double))
                   when  min(nvl(b.c_ggtgzjgxs_mode, '1'))='2'
                 then cast(sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) as decimal(10,2))
               else   round(sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double)), 2) end )
         else
          sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double))
       end )
       else sum(nvl(a.en_stock_asset_ggt,0)+nvl(a.en_stock_asset_noggt,0))
       end  en_stock_asset,
                  sum(cast(nvl(a.en_bond_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_bond_asset,
                  sum(cast(nvl(a.en_fund_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_fund_asset,
                  sum(cast(nvl(a.en_warrant_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_warrant_asset,
                  sum(cast(nvl(a.en_hg_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_hg_asset,
                  sum(cast(nvl(a.en_other_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_asset,
                  sum(cast(nvl(a.en_futures_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_asset,
                  sum(cast(nvl(a.en_accumulate_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_accumulate_profit,
                  sum(cast(nvl(a.en_futures_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_balance,
                  sum(cast(nvl(a.en_futures_deposit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_deposit,
                  sum(cast(nvl(a.en_futures_prepare, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_prepare,
                  max(nvl(a.en_fund_share, 0)) en_fund_share,
                  sum(case when tmp.numbers='0' then cast(nvl(a.en_fund_value, 0) as double) * cast(nvl(c.hl, 1) as double) else nvl(a.en_fund_value, 0)end ) en_fund_value,
                  case
                      when nvl(max(nvl(b.c_fa_precision_mode, '2')), '2') = '2' then
          round(tmp.numbers,4)
         else
          trunc(tmp.numbers,'4')
       end en_nav,
                  sum(cast(nvl(a.en_fund_value_yesterday, 0) as double) * cast(nvl(c.hl, 1) as double)) en_fund_value_yesterday,
                  sum(cast(nvl(a.en_total_nav, 0) as double)) en_total_nav,
                  sum(cast(nvl(a.EN_UNIT_DIVIDENDS, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_UNIT_DIVIDENDS,
                  sum(cast(nvl(a.en_deposit_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_deposit_balance,
                  sum(cast(nvl(a.en_begin_fund_value, 0) as double) * cast(nvl(c.hl, 1) as double)) en_begin_fund_value,
                  sum(cast(nvl(a.en_bond_interest, 0) as double) * cast(nvl(c.hl, 1) as double)) en_bond_interest,
                  max(cast(nvl(a.en_nav_yesterday, 0) as double) * cast(nvl(c.hl, 1) as double)) en_nav_yesterday,
                  sum(case when  tmp.numbers='0' then cast(nvl(a.en_fund_total_value, 0) as double) * cast(nvl(c.hl, 1) as double)else nvl(a.en_fund_total_value, 0) end ) en_fund_total_value,
                  sum(cast(nvl(a.en_payable_bond_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_payable_bond_asset,
                  sum(cast(nvl(a.EN_REC_SEC_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_REC_SEC_ASSET,
                  sum(cast(nvl(a.EN_PAY_SEC_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_PAY_SEC_ASSET,
                  sum(cast(nvl(a.EN_OPTION_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_OPTION_ASSET,
                  sum(cast(nvl(a.en_accumulate_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_accumulate_profit_gq,
                  sum(cast(nvl(a.en_turn_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_profit_gq,
                  sum(cast(nvl(a.en_net_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_net_gain_gq,
                  sum(cast(nvl(a.en_uncarryover_net_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_uncarryover_net_gain_gq,
                  sum(cast(nvl(a.en_interest_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_profit_gq,
                  sum(cast(nvl(a.en_turn_interest_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_interest_profit_gq,
                  sum(cast(nvl(a.en_interest_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_gain_gq,
                  sum(cast(nvl(a.en_turn_interest_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_interest_gain_gq,
                  sum(cast(nvl(a.en_buy_unasset_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_unasset_balance,
                  sum(cast(nvl(a.en_gold_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_asset,
                  sum(cast(nvl(a.en_gold_equity, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_equity,
                  sum(cast(nvl(a.en_gold_spot, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_spot,
                  sum(cast(nvl(a.en_gold_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_profit,
                  sum(cast(nvl(a.EN_GOLD_DEPOSIT, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_deposit,
                  sum(cast(nvl(a.en_sale_unasset_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_unasset_balance,
                  sum(cast(nvl(a.en_finadebt_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_finadebt_asset,
                  sum(cast(nvl(a.en_finadebt_interest, 0) as double) * cast(nvl(c.hl, 1) as double)) en_finadebt_interest
  from ${ods_db}.o3_THISFUNDASSET a
    inner join ${ods_db}.o3_TFUNDINFO b
       on a.l_fund_id = b.l_fund_id
    left join tmp on 1=1
    inner join (select vc_currency_target,l_date,vc_currency_source,l_set_no, cast(nvl(x.en_mid_price, 0) as double) / cast(nvl(x.l_unit_amount, 1) as double) hl
          from ${ods_db}.O3_TCURRENCYRATE x) c
       on b.vc_currency_no = c.vc_currency_target
              and cast(a.l_date as int) = cast(c.l_date as int)
              and a.vc_currency_no = c.vc_currency_source
    where ((cast(b.l_set_no as bigint) = cast(c.l_set_no as bigint) and
    c.vc_currency_source not in ('HK1', 'HK2')) or
    (cast(b.l_ggt_set_no as bigint) = cast(c.l_set_no as bigint) and
    c.vc_currency_source in ('HK1', 'HK2')))
    group by a.l_date, a.l_fund_id, b.vc_currency_no,tmp.numbers
),
O3_VFUNDASSET AS (
   select a.l_date l_date,
       a.l_fund_id l_fund_id,
       b.vc_currency_no vc_currency_no,
                  sum(cast(nvl(a.en_begin_cash, 0) as double) * cast(nvl(c.hl, 1) as double)) en_begin_cash,
                  sum(cast(nvl(a.en_current_cash, 0) as double) * cast(nvl(c.hl, 1) as double)) en_current_cash,
                  sum(cast(nvl(a.en_basic_frozen_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_basic_frozen_balance,
                  sum(cast(nvl(a.en_prebuy_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_prebuy_balance,
                  sum(cast(nvl(a.en_presale_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_presale_balance,
                  sum(cast(nvl(a.en_buy_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_balance,
                  sum(cast(nvl(a.en_sale_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_balance,
                  sum(cast(nvl(a.en_buy_unsettle_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_unsettle_balance,
                  sum(cast(nvl(a.en_sale_unsettle_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_unsettle_balance,
                  sum(cast(nvl(a.en_other_expense, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_expense,
                  sum(cast(nvl(a.en_other_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_profit,
                  sum(cast(nvl(a.en_interest_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_balance,
                  case when tmp.numbers='0' then (
       case
         when instr(',HK1,HK2,',
                    CONCAT(',' , max(nvl(a.vc_currency_no, 'CNY')) , ',')) > 0 then
           ( case when  min(nvl(b.c_ggtgzjgxs_mode, '1'))='1'
                then  sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double))
                   when  min(nvl(b.c_ggtgzjgxs_mode, '1'))='2'
                 then cast(sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) as decimal(10,2))
               else   round(sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double)), 2) end )
         else
          sum(cast(nvl(a.en_stock_asset, 0) as double) * cast(nvl(c.hl, 1) as double))
       end )
       else sum(nvl(a.en_stock_asset_ggt,0)+nvl(a.en_stock_asset_noggt,0))
       end  en_stock_asset,
                  sum(cast(nvl(a.en_bond_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_bond_asset,
                  sum(cast(nvl(a.en_fund_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_fund_asset,
                  sum(cast(nvl(a.en_warrant_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_warrant_asset,
                  sum(cast(nvl(a.en_hg_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_hg_asset,
                  sum(cast(nvl(a.en_other_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_other_asset,
                  sum(cast(nvl(a.en_futures_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_asset,
                  sum(cast(nvl(a.en_accumulate_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_accumulate_profit,
                  sum(cast(nvl(a.en_futures_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_balance,
                  sum(cast(nvl(a.en_futures_deposit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_deposit,
                  sum(cast(nvl(a.en_futures_prepare, 0) as double) * cast(nvl(c.hl, 1) as double)) en_futures_prepare,
                  max(nvl(a.en_fund_share, 0)) en_fund_share,
                  sum(case when tmp.numbers='0' then cast(nvl(a.en_fund_value, 0) as double) * cast(nvl(c.hl, 1) as double) else nvl(a.en_fund_value, 0)end ) en_fund_value,
                  case
                      when nvl(max(nvl(b.c_fa_precision_mode, '2')), '2') = '2' then
          round(tmp.numbers,4)
         else
          trunc(tmp.numbers,'4')
       end en_nav,
                  sum(cast(nvl(a.en_fund_value_yesterday, 0) as double) * cast(nvl(c.hl, 1) as double)) en_fund_value_yesterday,
                  sum(cast(nvl(a.en_total_nav, 0) as double)) en_total_nav,
                  sum(cast(nvl(a.EN_UNIT_DIVIDENDS, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_UNIT_DIVIDENDS,
                  sum(cast(nvl(a.en_deposit_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_deposit_balance,
                  sum(cast(nvl(a.en_begin_fund_value, 0) as double) * cast(nvl(c.hl, 1) as double)) en_begin_fund_value,
                  sum(cast(nvl(a.en_bond_interest, 0) as double) * cast(nvl(c.hl, 1) as double)) en_bond_interest,
                  max(cast(nvl(a.en_nav_yesterday, 0) as double) * cast(nvl(c.hl, 1) as double)) en_nav_yesterday,
                  sum(case when  tmp.numbers='0' then cast(nvl(a.en_fund_total_value, 0) as double) * cast(nvl(c.hl, 1) as double)else nvl(a.en_fund_total_value, 0) end ) en_fund_total_value,
                  sum(cast(nvl(a.en_payable_bond_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_payable_bond_asset,
                  sum(cast(nvl(a.EN_REC_SEC_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_REC_SEC_ASSET,
                  sum(cast(nvl(a.EN_PAY_SEC_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_PAY_SEC_ASSET,
                  sum(cast(nvl(a.EN_OPTION_ASSET, 0) as double) * cast(nvl(c.hl, 1) as double)) EN_OPTION_ASSET,
                  sum(cast(nvl(a.en_accumulate_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_accumulate_profit_gq,
                  sum(cast(nvl(a.en_turn_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_profit_gq,
                  sum(cast(nvl(a.en_net_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_net_gain_gq,
                  sum(cast(nvl(a.en_uncarryover_net_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_uncarryover_net_gain_gq,
                  sum(cast(nvl(a.en_interest_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_profit_gq,
                  sum(cast(nvl(a.en_turn_interest_profit_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_interest_profit_gq,
                  sum(cast(nvl(a.en_interest_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_interest_gain_gq,
                  sum(cast(nvl(a.en_turn_interest_gain_gq, 0) as double) * cast(nvl(c.hl, 1) as double)) en_turn_interest_gain_gq,
                  sum(cast(nvl(a.en_buy_unasset_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_buy_unasset_balance,
                  sum(cast(nvl(a.en_gold_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_asset,
                  sum(cast(nvl(a.en_gold_equity, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_equity,
                  sum(cast(nvl(a.en_gold_spot, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_spot,
                  sum(cast(nvl(a.en_gold_profit, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_profit,
                  sum(cast(nvl(a.EN_GOLD_DEPOSIT, 0) as double) * cast(nvl(c.hl, 1) as double)) en_gold_deposit,
                  sum(cast(nvl(a.en_sale_unasset_balance, 0) as double) * cast(nvl(c.hl, 1) as double)) en_sale_unasset_balance,
                  sum(cast(nvl(a.en_finadebt_asset, 0) as double) * cast(nvl(c.hl, 1) as double)) en_finadebt_asset,
                  sum(cast(nvl(a.en_finadebt_interest, 0) as double) * cast(nvl(c.hl, 1) as double)) en_finadebt_interest
    from ${ods_db}.o3_TFUNDASSET a
    inner join ${ods_db}.o3_TFUNDINFO b
         on a.l_fund_id = b.l_fund_id
    left join tmp on 1=1
    inner join  (select vc_currency_target,l_date,vc_currency_source,l_set_no, cast(nvl(x.en_mid_price, 0) as double) / cast(nvl(x.l_unit_amount, 1) as double) hl
          from ${ods_db}.O3_TCURRENCYRATE x) c
         on b.vc_currency_no = c.vc_currency_target
                and cast(a.l_date as int) = cast(c.l_date as int)
                and a.vc_currency_no = c.vc_currency_source
    where  (( cast(b.l_set_no as bigint) = cast(c.l_set_no as bigint) and
             c.vc_currency_source not in ('HK1', 'HK2')) or
           ( cast(b.l_ggt_set_no as bigint) = cast(c.l_set_no as bigint) and
             c.vc_currency_source in ('HK1', 'HK2')))
    group by a.l_date, a.l_fund_id, b.vc_currency_no,tmp.numbers
    )
insert into ${dwd_db}.ast_prd_ast_his partition(p_dt,sys_rs_id)
(occu_dt,prd_code,curr_code,bgng_cptl_bal,curr_cptl_bal,bgng_navl ,ttl_ast ,ttl_navl ,yest_ttl_navl ,yest_unit_nval,ttl_shr ,unit_nval, aggr_unit_nval,ttl_payb_val, ttl_recv_val, inta_hldp ,stk_ast, bond_ast ,fnd_ast ,wrnt_ast ,repo_ast ,oth_ast ,futr_marg_bal ,futr_marg, futr_marg_pl, unit_bons, dpsi_bal, bond_intr, payb_bond_ast ,recv_secu_ast, payb_secu_ast ,busi_date ,task_rs_id,dm_created_time ,p_dt ,sys_rs_id)  SELECT T0.l_date AS OCCU_DT, --发生日期
             T1.vc_fund_code AS PRD_CODE, --产品代码
             T0.vc_currency_no AS CURR_CODE, --货币代码
             T0.en_begin_cash AS BGNG_CPTL_BAL, --期初资金余额
             T0.en_current_cash AS CURR_CPTL_BAL, --当前资金余额
             T0.en_begin_fund_value AS BGNG_NAVL, --期初净值
             T0.en_fund_total_value AS TTL_AST, --总资产
             T0.en_fund_value AS TTL_NAVL, --净资产
             T0.en_fund_value_yesterday AS YEST_TTL_NAVL, --昨日净资产
             T0.en_nav_yesterday AS YEST_UNIT_NVAL, --昨日单位净值
             T0.en_fund_share AS TTL_SHR, --总份额
             T0.en_nav AS UNIT_NVAL, --单位净值
             T0.en_total_nav AS AGGR_UNIT_NVAL, --累计单位净值
             T0.en_other_expense AS TTL_PAYB_VAL, --合计应付金额
             T0.en_other_profit AS TTL_RECV_VAL, --合计应收金额
             T0.en_interest_balance AS INTA_HLDP, --计息头寸
             T0.en_stock_asset AS STK_AST, --股票资产
             T0.en_bond_asset AS BOND_AST, --债券资产
             T0.en_fund_asset AS FND_AST, --基金资产
             T0.en_warrant_asset AS WRNT_AST, --权证资产
             T0.en_hg_asset AS REPO_AST, --回购资产
             T0.en_other_asset AS OTH_AST, --其他资产
             T0.EN_FUTURES_BALANCE AS FUTR_MARG_BAL, --期货保证金账户余额
             T0.EN_FUTURES_DEPOSIT AS FUTR_MARG, --期货保证金
             T0.en_futures_asset AS FUTR_MARG_PL, --期货盈亏
             T0.EN_UNIT_DIVIDENDS AS UNIT_BONS, --单位分红
             T0.en_deposit_balance AS DPSI_BAL, --存款余额
             T0.en_bond_interest AS BOND_INTR, --债券利息
             T0.en_payable_bond_asset AS PAYB_BOND_AST, --应付债券资产
             T0.EN_REC_SEC_ASSET AS RECV_SECU_AST, --应收证券资产
             T0.EN_PAY_SEC_ASSET AS PAYB_SECU_AST, --应付证券资产
             ${end_date} AS BUSI_DATE, --业务日期
             'ast_prd_ast_his_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.l_date,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM O3_VHISFUNDASSET T0
        JOIN ${ods_db}.O3_TFUNDINFO T1
          ON T0.L_FUND_ID = T1.L_FUND_ID
       WHERE T0.L_DATE BETWEEN ${beg_date} AND ${end_date}
      UNION ALL
      --产品资产信息表
      SELECT T0.l_date AS OCCU_DT, --发生日期
             T1.vc_fund_code AS PRD_CODE, --产品代码
             T0.vc_currency_no AS CURR_CODE, --货币代码
             T0.en_begin_cash AS BGNG_CPTL_BAL, --期初资金余额
             T0.en_current_cash AS CURR_CPTL_BAL, --当前资金余额
             T0.en_begin_fund_value AS BGNG_NAVL, --期初净值
             T0.en_fund_total_value AS TTL_AST, --总资产
             T0.en_fund_value AS TTL_NAVL, --净资产
             T0.en_fund_value_yesterday AS YEST_TTL_NAVL, --昨日净资产
             T0.en_nav_yesterday AS YEST_UNIT_NVAL, --昨日单位净值
             T0.en_fund_share AS TTL_SHR, --总份额
             T0.en_nav AS UNIT_NVAL, --单位净值
             T0.en_total_nav AS AGGR_UNIT_NVAL, --累计单位净值
             T0.en_other_expense AS TTL_PAYB_VAL, --合计应付金额
             T0.en_other_profit AS TTL_RECV_VAL, --合计应收金额
             T0.en_interest_balance AS INTA_HLDP, --计息头寸
             T0.en_stock_asset AS STK_AST, --股票资产
             T0.en_bond_asset AS BOND_AST, --债券资产
             T0.en_fund_asset AS FND_AST, --基金资产
             T0.en_warrant_asset AS WRNT_AST, --权证资产
             T0.en_hg_asset AS REPO_AST, --回购资产
             T0.en_other_asset AS OTH_AST, --其他资产
             T0.EN_FUTURES_BALANCE AS FUTR_MARG_BAL, --期货保证金账户余额
             T0.EN_FUTURES_DEPOSIT AS FUTR_MARG, --期货保证金
             T0.en_futures_asset AS FUTR_MARG_PL, --期货盈亏
             T0.EN_UNIT_DIVIDENDS AS UNIT_BONS, --单位分红
             T0.en_deposit_balance AS DPSI_BAL, --存款余额
             T0.en_bond_interest AS BOND_INTR, --债券利息
             T0.en_payable_bond_asset AS PAYB_BOND_AST, --应付债券资产
             T0.EN_REC_SEC_ASSET AS RECV_SECU_AST, --应收证券资产
             T0.EN_PAY_SEC_ASSET AS PAYB_SECU_AST, --应付证券资产
             ${end_date} AS BUSI_DATE, --业务日期
             'ast_prd_ast_his_2' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.l_date,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM O3_VFUNDASSET T0
        JOIN ${ods_db}.O3_TFUNDINFO T1
          ON T0.L_FUND_ID = T1.L_FUND_ID
       WHERE T0.L_DATE = DATE_FORMAT(current_date,'yyyyMMdd');