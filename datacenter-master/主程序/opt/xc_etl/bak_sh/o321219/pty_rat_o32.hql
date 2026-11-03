------------------------------------------------------------------------
  -- 模块名称：机构评级
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

alter table ${dwd_db}.pty_rat_o32 drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;
insert into ${dwd_db}.pty_rat_o32 partition(p_dt)
select t0.l_issuer_id as com_id, --机构编码
       t0.vc_full_name as com_name, --机构名称
       t0.vc_issuer_name as com_sht, --机构简称
       t0.l_date as rat_dt, --评级日期
       t2.vc_item_name as inr_rat, --内部主体评级
       t1.vc_item_name as lst_ext_rat, --最新外部主体评级
       t6.vc_item_name as lst_ext_rat_com_name, --最新外部评级机构
       t3.vc_item_name as lst_ext_rat_two, --最新外部主体评级(含中债)
       t4.vc_item_name as low_ext_rat_lmdt, --中债资信评级1
       t5.vc_item_name as low_ext_rat_lmdt_two, --中债资信评级2
       t0.en_issuer_asset as com_ttl_ast,--add by JakeLin for XZQQ HOLDING
       t7.vc_item_name as rat_expt_typ_desc,--评级展望
       t8.vc_item_name as iss_type,--发行人分类
       t9.vc_item_name as reg_prov,--发行人所在省份
       date_format(date_add(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
       'pty_rat_o32' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       t0.l_date as p_dt
  from ${ods_db}.o3_thisissuer t0
   left join ${ods_db}.o3_tdictionary t1
          on t1.l_dictionary_no = '110000'--外部评级
          and t0.c_outer_appraise = t1.c_lemma_item
   left join ${ods_db}.o3_tdictionary t2
          on t2.l_dictionary_no = '110001'--内部信用级别
          and t0.c_inside_appraise = t2.c_lemma_item
   left join ${ods_db}.o3_tdictionary t3
          on t3.l_dictionary_no = '110000'--外部主体评级(含中债)
          and t0.c_outer_appraise1 = t3.c_lemma_item
   left join ${ods_db}.o3_tdictionary t4
          on t4.l_dictionary_no = '60096'--其它评级一
          and t0.c_issuer_other_appraise_one = t4.c_lemma_item
   left join ${ods_db}.o3_tdictionary t5
          on t5.l_dictionary_no = '60097'--其它评级二
          and t0.c_issuer_other_appraise_two = t5.c_lemma_item
   left join ${ods_db}.o3_tdictionary t6
          on t6.l_dictionary_no = '60200'--主体评级机构
          and t0.vc_appraise_organ = t6.c_lemma_item
   left join ${ods_db}.o3_tdictionary t7
          on t7.l_dictionary_no = '60707'--评级展望
          and t0.c_level_expectation = t7.c_lemma_item
   left join ${ods_db}.o3_tdictionary t8
          on t8.l_dictionary_no = '10090'--发行人分类
          and t0.vc_issuer_type = t8.c_lemma_item
   left join ${ods_db}.o3_tdictionary t9
          on t9.l_dictionary_no = '60050'--省份
      and t0.vc_provincecode = t9.c_lemma_item 
 where t0.p_dt between ${beg_date} and ${end_date}

UNION  ALL 

select t0.l_issuer_id as com_id, --机构编码
       t0.vc_full_name as com_name, --机构名称
       t0.vc_issuer_name as com_sht, --机构简称
       t0.l_date as rat_dt, --评级日期
       t2.vc_item_name as inr_rat, --内部主体评级
       t1.vc_item_name as lst_ext_rat, --最新外部主体评级
       t6.vc_item_name as lst_ext_rat_com_name, --最新外部评级机构
       t3.vc_item_name as lst_ext_rat_two, --最新外部主体评级(含中债)
       t4.vc_item_name as low_ext_rat_lmdt, --中债资信评级1
       t5.vc_item_name as low_ext_rat_lmdt_two, --中债资信评级2
       t0.en_issuer_asset as com_ttl_ast,--add by JakeLin for XZQQ HOLDING
       t7.vc_item_name as rat_expt_typ_desc,--评级展望
       t8.vc_item_name as iss_type,--发行人分类
       t9.vc_item_name as reg_prov,--发行人所在省份
       date_format(date_add(current_date,-1),'yyyyMMdd') as busi_date, --业务日期
       'pty_rat_o32' as task_rs_id, --任务来源标识
       current_timestamp as dm_created_time, --数据中台创建时间
       t0.l_date as p_dt
  from ${ods_db}.o3_tissuer t0
   left join ${ods_db}.o3_tdictionary t1
          on t1.l_dictionary_no = '110000'--外部评级
          and t0.c_outer_appraise = t1.c_lemma_item
   left join ${ods_db}.o3_tdictionary t2
          on t2.l_dictionary_no = '110001'--内部信用级别
          and t0.c_inside_appraise = t2.c_lemma_item
   left join ${ods_db}.o3_tdictionary t3
          on t3.l_dictionary_no = '110000'--外部主体评级(含中债)
          and t0.c_outer_appraise1 = t3.c_lemma_item
   left join ${ods_db}.o3_tdictionary t4
          on t4.l_dictionary_no = '60096'--其它评级一
          and t0.c_issuer_other_appraise_one = t4.c_lemma_item
   left join ${ods_db}.o3_tdictionary t5
          on t5.l_dictionary_no = '60097'--其它评级二
          and t0.c_issuer_other_appraise_two = t5.c_lemma_item
   left join ${ods_db}.o3_tdictionary t6
          on t6.l_dictionary_no = '60200'--主体评级机构
          and t0.vc_appraise_organ = t6.c_lemma_item
   left join ${ods_db}.o3_tdictionary t7
          on t7.l_dictionary_no = '60707'--评级展望
          and t0.c_level_expectation = t7.c_lemma_item
   left join ${ods_db}.o3_tdictionary t8
          on t8.l_dictionary_no = '10090'--发行人分类
          and t0.vc_issuer_type = t8.c_lemma_item
   left join ${ods_db}.o3_tdictionary t9
          on t9.l_dictionary_no = '60050'--省份
  and t0.vc_provincecode = t9.c_lemma_item
;