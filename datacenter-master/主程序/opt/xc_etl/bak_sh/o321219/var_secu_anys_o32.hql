------------------------------------------------------------------------
  -- 模块名称：证券分析数据_O32
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

alter table ${dwd_db}.var_secu_anys_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_secu_anys_o32 partition(p_dt)
    (secu_id
     ,secu_sht
     ,occu_dt
     ,o32_com_id
     ,o32_tscp
     ,o32_cir_capt
     ,o32_secu_clas
     ,o32_secu_clas_name
     ,o32_ast_clas
     ,o32_ast_clas_name
     ,o32_mix_typ
     ,o32_mix_typ_name
     ,o32_trade_name
     ,o32_custom_class
     ,busi_date
     ,task_rs_id
     ,dm_created_time
     ,p_dt
       )
select concat(t0.vc_report_code , case when t0.c_asset_class = '2' then '.STK.' when t0.c_asset_class = '3' then '.BOND.' when t0.c_asset_class = '4' then '.FUND.' end ,
       case when t0.c_market_no = '1' THEN 'SH' 
            when t0.c_market_no = '2' THEN 'SZ' 
            when t0.c_market_no = '5' THEN 'YHJ' 
            when t0.c_market_no = '6' THEN 'NONE' 
            when t0.c_market_no = '7' THEN 'CFFEX' 
            when t0.c_market_no = 'j' THEN 'SB' 
            when t0.c_market_no = 'n' THEN 'SHSC' 
            when t0.c_market_no = 'o' THEN 'SZSC' 
       end)  as secu_id, --证券编码
       t0.vc_stock_name,
       t0.l_date as occu_dt, --发生日期
       t0.l_company_id as o32_com_id,
       t0.l_total_amount as o32_tscp, --o32_总股本
       t0.l_turnover_amount  as o32_cir_capt, --o32_流通股本
       t0.c_stock_type  as o32_secu_clas, --o32_证券类型
       t1.vc_item_name  as o32_secu_clas_name, --o32_证券类型名称
       t0.c_asset_class  as o32_ast_clas, --o32_资产类型
       t2.vc_item_name  as o32_ast_clas_name, --o32_资产类型名称
       t0.vc_mixed_type  as o32_mix_typ, --o32_杂项分类
       t3.vc_item_name  as o32_mix_typ_name, --o32_杂项分类名称
       tname.vc_trade_name as o32_trade_name,
       null as o32_custom_class,
       ${current_date} as busi_date, --业务日期
       'var_secu_anys_o32_1' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       t0.l_date as p_dt-- 分区
   from ${ods_db}.o3_tstockinfo t0
   left join ${ods_db}.o3_tdictionary t1
   on t1.l_dictionary_no = 70110 
   and t0.c_stock_type = t1.c_lemma_item
   left join ${ods_db}.o3_tdictionary t2
   on t2.l_dictionary_no = 10036 
   and t0.c_asset_class = t2.c_lemma_item
   left join ${ods_db}.o3_tdictionary t3
   on t3.l_dictionary_no = 10073 
   and t0.vc_mixed_type = t3.c_lemma_item
   left join (select stock.vc_inter_code,concat_ws('|',collect_set(types.vc_trade_name)) as vc_trade_name
	from ${ods_db}.o3_ttradetypes types
	join ${ods_db}.o3_ttradestock stock
	on types.l_serial_id = stock.l_serial_id
	where types.vc_trade_no in ('3505', '3568','3854','3855','4006')
	group by stock.vc_inter_code) tname
   on t0.vc_inter_code = tname.vc_inter_code
   left join (select clas.vc_inter_code,concat_ws(' | ',sort_array(collect_set(if(clas.vc_custom_class = '00007','主体房地产行业',dict.vc_item_name)))) vc_custom_class
              from (select cc.vc_inter_code,t.vc_custom_class,row_number() over(partition by cc.vc_inter_code order by t.vc_custom_class) rn
					from ${ods_db}.o3_tcustomclass cc
					lateral view explode(split(cc.vc_custom_class, ',')) t as vc_custom_class
					where 1=1 --and split(cc.vc_custom_class, ',')[0] is not null
					) clas
			  left join ${ods_db}.o3_tdictionary dict
			  on clas.vc_custom_class = dict.c_lemma_item
			  and dict.l_dictionary_no = 60655
			  and clas.rn <= 10
			  group by clas.vc_inter_code) tclas
   on t0.vc_inter_code = tclas.vc_inter_code
   where t0.c_asset_class in ('2', '3', '4')
   and t0.l_date = ${current_date}

UNION

select concat(t0.vc_report_code , case when t0.c_asset_class = '2' then '.STK.' when t0.c_asset_class = '3' then '.BOND.' when t0.c_asset_class = '4' then '.FUND.' end ,
       case when t0.c_market_no = '1' then 'SH' 
            when t0.c_market_no = '2' then 'SZ' 
            when t0.c_market_no = '5' then 'YHJ' 
            when t0.c_market_no = '6' then 'NONE' 
            when t0.c_market_no = '7' then 'CFFEX' 
            when t0.c_market_no = 'j' then 'SB' 
            when t0.c_market_no = 'n' then 'SHSC' 
            when t0.c_market_no = 'o' then 'SZSC' 
       end)  as secu_id, --证券编码
       t0.vc_stock_name,
       t0.l_date as occu_dt, --发生日期
       t0.l_company_id as o32_com_id,
       t0.l_total_amount as o32_tscp, --o32_总股本
       t0.l_turnover_amount  as o32_cir_capt, --o32_流通股本
       t0.c_stock_type  as o32_secu_clas, --o32_证券类型
       t1.vc_item_name  as o32_secu_clas_name, --o32_证券类型名称
       t0.c_asset_class  as o32_ast_clas, --o32_资产类型
       t2.vc_item_name  as o32_ast_clas_name, --o32_资产类型名称
       t0.vc_mixed_type  as o32_mix_typ, --o32_杂项分类
       t3.vc_item_name  as o32_mix_typ_name, --o32_杂项分类名称
       tname.vc_trade_name as o32_trade_name,
       tclas.vc_custom_class as o32_custom_class,
       ${end_date} as busi_date, --业务日期
       'var_secu_anys_o32_2' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       t0.l_date as p_dt-- 分区
   from ${ods_db}.o3_thisstockinfo t0
   left join ${ods_db}.o3_tdictionary t1
   on t1.l_dictionary_no = 70110 
   and t0.c_stock_type = t1.c_lemma_item
   left join ${ods_db}.o3_tdictionary t2
   on t2.l_dictionary_no = 10036 
   and t0.c_asset_class = t2.c_lemma_item
   left join ${ods_db}.o3_tdictionary t3
   on t3.l_dictionary_no = 10073 
   and t0.vc_mixed_type = t3.c_lemma_item
   left join (select types.p_dt,stock.vc_inter_code,concat_ws('|',collect_set(types.vc_trade_name)) as vc_trade_name
				from ${ods_db}.o3_thistradetypes types--(select * from ty_ods.o3_thistradetypes where p_dt='20231031') types
				join ${ods_db}.o3_thistradestock stock--(select * from ty_ods.o3_thistradestock where p_dt='20231031') stock
				on types.p_dt = stock.p_dt
				and types.l_serial_id = stock.l_serial_id
				and types.p_dt between '20231031' and '20231031'--between ${beg_date} and ${end_date}
				where types.vc_trade_no IN ('3505', '3568','3854','3855','4006')
				group by types.p_dt,stock.vc_inter_code) tname
   on t0.p_dt = tname.p_dt and t0.vc_inter_code = tname.vc_inter_code
   left join (select clas.p_dt,clas.vc_inter_code,concat_ws(' | ',sort_array(collect_set(if(clas.vc_custom_class = '00007','主体房地产行业',dict.vc_item_name))))  vc_custom_class
              from (select cc.p_dt,cc.vc_inter_code,t.vc_custom_class,row_number() over(partition by cc.p_dt,cc.vc_inter_code order by t.vc_custom_class) rn
					from ${ods_db}.o3_thiscustomclass cc
					lateral view explode(split(cc.vc_custom_class, ',')) t as vc_custom_class
					where 1=1
					--and split(cc.vc_custom_class, ',')[0] is not null
					and cc.p_dt between ${beg_date} and ${end_date}) clas
			  left join ${ods_db}.o3_tdictionary dict
			  on clas.vc_custom_class = dict.c_lemma_item
			  and dict.l_dictionary_no = 60655
			  and clas.rn <= 10
			  group by clas.p_dt,clas.vc_inter_code) tclas
   on t0.p_dt = tclas.p_dt and t0.vc_inter_code = tclas.vc_inter_code
   where t0.c_asset_class in ('2', '3', '4')
   and t0.p_dt between ${beg_date} and ${end_date}
  ;
