------------------------------------------------------------------------
  -- 模块名称：债券评级信息
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

alter table ${dwd_db}.var_bond_rat_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_bond_rat_o32 partition(p_dt)
select concat(t1.vc_report_code, '.BOND.', t2.para_hcode) as secu_id,
       t1.l_company_id as com_id,
       t0.l_date as rat_dt,
       t3.vc_item_name as lst_ext_rat,
       t4.vc_item_name as inr_rat,
       t5.vc_item_name as low_ext_rat_lmdt, --中债资信评级1
       t6.vc_item_name as low_ext_rat_lmdt_two, --中债资信评级2
       t7.vc_item_name as lst_ext_rat_com_name, --最新外部评级机构
       t8.vc_item_name as rat_expt_typ_desc,--评级展望
       date_format(date_add(current_date,-1),'yyyymmdd') as busi_date, --业务日期
       'var_bond_rat_o32' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       t0.l_date as p_dt
from ${ods_db}.o3_thisbondproperty t0
left join ${ods_db}.o3_thisstockinfo t1
	  on t0.l_date=t1.l_date
	 and t0.vc_inter_code=t1.vc_inter_code
	 and t1.p_dt between ${beg_date} and ${end_date}
left join ${dwd_db}.pub_para_mapping t2
	  on t0.c_market_no = t2.orisys_para_code
	 and t2.para_class_hcode = '4'
	 and t2.orisys_hcode = 'HSO3'
left join ${ods_db}.o3_tdictionary t3
	  on t3.l_dictionary_no = '110000'--外部评级
	 and t0.c_outer_appraise = t3.c_lemma_item
left join ${ods_db}.o3_tdictionary t4
	  on t4.l_dictionary_no = '110001'--内部信用级别
	 and t0.C_INSIDE_APPRAISE = t4.c_lemma_item
left join ${ods_db}.o3_tdictionary t5
	  on t5.l_dictionary_no = '60096'--其它评级一
	  and t0.c_other_appraise_one = t5.c_lemma_item
left join ${ods_db}.o3_tdictionary t6
	  on t6.l_dictionary_no = '60097'--其它评级二
	  and t0.c_other_appraise_two = t6.c_lemma_item
left join ${ods_db}.o3_tdictionary t7
	  on t7.l_dictionary_no = '60200'--评级机构
	  and t0.vc_appraise_organ = t7.c_lemma_item
left join ${ods_db}.o3_tdictionary t8
	  on t8.l_dictionary_no = '60707'--评级展望
	  and t0.c_level_expectation = t8.c_lemma_item             
where t0.p_dt between ${beg_date} and ${end_date}
;
