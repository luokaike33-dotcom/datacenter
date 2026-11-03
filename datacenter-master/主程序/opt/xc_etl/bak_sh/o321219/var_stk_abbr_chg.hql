------------------------------------------------------------------------
  -- 模块名称：股票简称变更表
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

alter table ${dwd_db}.var_stk_abbr_chg drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.var_stk_abbr_chg partition(p_dt)
select t0.secu_id,
             t0.bgn_dt,
             (case
               when nvl(t2.secu_sht,t0.secu_sht_bfr) is null then
                '初始'
               else
                '名称变更'
             end) as info_sour,
             t0.secu_sht,
             nvl(nvl(t2.secu_sht,t0.secu_sht_bfr), t0.secu_sht),
             t0.bgn_dt,
             nvl(DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(t0.end_dt as string),'yyyyMMdd'),'yyyy-MM-dd'),-1),'yyyyMMdd'),
                 20991231) as end_dt,
             '1' as is_impl, --是否实施
             t0.bgn_dt AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'var_stk_abbr_chg_1' AS TASK_RS_ID, --任务来源标识
             t0.dm_src_info AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
             t0.bgn_dt as p_dt
        from (SELECT CONCAT(T0.VC_REPORT_CODE , '.STK.' , T2.PARA_HCODE) AS SECU_ID, --证券编码
                     T0.l_date as bgn_dt, --生效日期
                     T0.VC_STOCK_NAME as secu_sht, --证券简称
                     'thisstockinfo' as dm_src_info,
                     lead(t0.l_date) over(partition by T0.VC_REPORT_CODE, T2.PARA_HCODE order by t0.l_date) as end_dt, --获取周期内取消时间
                     lag(t0.vc_stock_name) over(partition by T0.VC_REPORT_CODE, T2.PARA_HCODE order by t0.l_date) as secu_sht_bfr --获取周期内名称变更记录
                FROM (select T0.l_date,
                             t0.vc_inter_code,
                             t0.vc_report_code,
                             t0.vc_stock_name,
                             T0.c_market_no,
                             lag(T0.vc_stock_name) over(partition by t0.vc_inter_code order by T0.l_date) vc_stock_name2 --只取变更名称的记录                        from ${ods_db}.O3_THISSTOCKINFO T0
                       from ${ods_db}.O3_THISSTOCKINFO T0
                       WHERE (T0.C_ASSET_CLASS IN ('2') --股票
                             OR
                             (T0.C_ASSET_CLASS IN ('6') AND
                             T0.C_STOCK_TYPE IN ('{', 'h', 'd', 'a', 'b') --{优先股、h配股、d增发、a股票申购、b申购款
                             ))
                         AND T0.L_DATE between ${beg_date} and ${end_date}) t0
                JOIN ${dwd_db}.PUB_PARA_MAPPING T2
                  ON T0.C_MARKET_NO = T2.ORISYS_PARA_CODE
                 AND T2.PARA_CLASS_HCODE = '4'
                 AND T2.ORISYS_HCODE = 'HSO3'
               where t0.vc_stock_name <> nvl(t0.vc_stock_name2,'666')) t0
        left join (select t.secu_id,
                          t.secu_sht,
                          t.bgn_dt,
                          row_number() over(partition by t.secu_id order by t.bgn_dt) rn
                     from ${dwd_db}.var_stk_abbr_chg  t--获取下一个变更日期
                    where bgn_dt > ${end_date}) t1
          on t0.secu_id = t1.secu_id
         and t1.rn = 1
       left join(select t.secu_id,
                          t.secu_sht,
                          row_number() over(partition by t.secu_id order by t.bgn_dt desc) rn
                     from ${dwd_db}.var_stk_abbr_chg  t--获取下一个变更日期
                    where bgn_dt < ${beg_date}
                ) t2 --已录入变更的不录入
                on t0.secu_id = t2.secu_id
                 and t2.rn=1
       where t0.bgn_dt between ${beg_date} and ${end_date}
            --and t0.secu_sht_bfr is not null
         and t0.secu_sht <> nvl(t2.secu_sht,'666');